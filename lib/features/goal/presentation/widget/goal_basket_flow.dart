import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../common/widget/animated/custom_toast.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../cart/presentation/widgets/checkout_bank_selector.dart';
import '../../../explore/domain/entities/mutual_fund_list_entity.dart';
import '../../../explore/presentation/controller/mutual_fund_controller.dart';
import '../../../mfu/presentation/controller/mfu_controller.dart';
import '../../../personalization/domain/entity/profile_update_entity.dart';
import '../../../personalization/presentation/controllers/personalisation_controller.dart';
import '../controller/goal_sip_controller.dart';
import 'goal_flow_app_bar.dart';

class GoalBasketFlow extends StatefulWidget {
  const GoalBasketFlow({
    super.key,
    required this.controller,
    required this.onAdd,
    required this.onCheckout,
    required this.onBack,
  });
  final GoalSipController controller;
  final Future<void> Function() onAdd;
  final VoidCallback onBack;
  final Future<void> Function() onCheckout;
  @override
  State<GoalBasketFlow> createState() => GoalBasketFlowState();
}

class GoalBasketFlowState extends State<GoalBasketFlow> {
  bool review = false;
  bool _amountMismatchConfirmed = false;
  final Map<String, String> _frequencies = {};
  final Map<String, String> _sipDays = {};

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<PersonalisationController>()) {
      final pCtrl = Get.find<PersonalisationController>();
      pCtrl.syncDefaultCheckoutBank(
        isLumpsum: c.savedInvestmentType.value == 'lumpsum',
      );
      _syncOptimalPaymentMethod(pCtrl.activeCheckoutBank);
    }
  }

  void _syncOptimalPaymentMethod(BankAccountEntity? bank) {
    if (c.savedInvestmentType.value == 'lumpsum') return;
    if (bank == null) return;
    final mandates = bank.approvedMandates ?? [];
    final hasUpi = mandates.any(
      (m) =>
          m.mandateMode?.toUpperCase() == 'UPI' &&
          (m.status?.toLowerCase() == 'approved' ||
              m.status?.toLowerCase() == 'active' ||
              m.aggrStatus?.toUpperCase() == 'AC'),
    );
    final hasEnach = mandates.any(
      (m) =>
          (m.mandateMode?.toUpperCase() == 'ENACH' ||
              m.mandateMode?.toUpperCase() == 'NETBANKING') &&
          (m.status?.toLowerCase() == 'approved' ||
              m.status?.toLowerCase() == 'active' ||
              m.aggrStatus?.toUpperCase() == 'AC'),
    );
    if (Get.isRegistered<MfuController>()) {
      final mfu = Get.find<MfuController>();
      if (hasEnach && !hasUpi) {
        mfu.selectMethod('netbanking');
      } else {
        mfu.selectMethod('upi');
      }
    }
  }

  bool _isMandateNeededForSelectedMethod() {
    final isLumpsum = c.savedInvestmentType.value == 'lumpsum';
    if (isLumpsum) return false;
    if (!Get.isRegistered<PersonalisationController>() ||
        !Get.isRegistered<MfuController>()) {
      return false;
    }
    final pCtrl = Get.find<PersonalisationController>();
    final mfuCtrl = Get.find<MfuController>();
    final bank = pCtrl.activeCheckoutBank;
    if (bank == null) return false;
    final mandates = bank.approvedMandates ?? [];
    final selectedMethod = mfuCtrl.selectedMethod.value;

    if (selectedMethod == 'upi') {
      final hasUpi = mandates.any(
        (m) =>
            m.mandateMode?.toUpperCase() == 'UPI' &&
            (m.status?.toLowerCase() == 'approved' ||
                m.status?.toLowerCase() == 'active' ||
                m.aggrStatus?.toUpperCase() == 'AC'),
      );
      return !hasUpi;
    } else {
      final hasEnach = mandates.any(
        (m) =>
            (m.mandateMode?.toUpperCase() == 'ENACH' ||
                m.mandateMode?.toUpperCase() == 'NETBANKING') &&
            (m.status?.toLowerCase() == 'approved' ||
                m.status?.toLowerCase() == 'active' ||
                m.aggrStatus?.toUpperCase() == 'AC'),
      );
      return !hasEnach;
    }
  }

  Future<void> _navigateToMandateSetup() async {
    final isDesktop = Get.width > 600;
    final pCtrl = Get.isRegistered<PersonalisationController>()
        ? Get.find<PersonalisationController>()
        : null;
    final activeBank = pCtrl?.activeCheckoutBank;

    await Get.toNamed(
      AppRoutes.paymentScreen,
      arguments: {
        'isMandate': true,
        'amount': '100000',
        if (activeBank?.id != null) 'bankId': activeBank!.id,
      },
      id: isDesktop ? 1 : null,
    );

    // Refresh bank details upon returning to reflect newly approved/created mandate
    if (pCtrl != null) {
      await pCtrl.fetchUserBankList(isRefresh: true);
      _syncOptimalPaymentMethod(pCtrl.activeCheckoutBank);
    }
    if (mounted) {
      setState(() {});
    }
  }

  String _frequencyKey(MutualFundListEntity fund) =>
      fund.schemeCode ?? fund.baseSchemeName ?? '';
  String _frequency(MutualFundListEntity fund) =>
      _frequencies[_frequencyKey(fund)] ?? 'Monthly';
  String _sipDay(MutualFundListEntity fund) =>
      _sipDays[_frequencyKey(fund)] ??
      (c.selectedSipDay.value > 0 ? c.selectedSipDay.value.toString() : '10');

  String getFrequencyCode(MutualFundListEntity fund) {
    final freq = _frequency(fund);
    switch (freq) {
      case 'Daily':
        return 'D';
      case 'Weekly':
        return 'W';
      case 'Monthly':
      default:
        return 'M';
    }
  }

  String getMfuDay(MutualFundListEntity fund) {
    final freq = _frequency(fund);
    switch (freq) {
      case 'Daily':
        return 'NA';
      case 'Weekly':
        final dayName = _sipDay(fund);
        const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
        final idx = days.indexOf(dayName);
        return (idx >= 0 ? idx + 1 : 1).toString();
      case 'Monthly':
      default:
        final dayStr = _sipDay(fund);
        final parsed = int.tryParse(dayStr) ?? c.selectedSipDay.value;
        return (parsed > 0 ? parsed : 10).toString();
    }
  }

  String getFrequencyDisplayLabel(MutualFundListEntity fund) {
    final freq = _frequency(fund);
    if (freq == 'Daily') return 'Daily';
    if (freq == 'Weekly') {
      final day = _sipDay(fund);
      final short = day.length >= 3 ? day.substring(0, 3) : day;
      return 'Weekly • $short';
    }
    final day = _sipDay(fund);
    final intDay =
        int.tryParse(day) ??
        (c.selectedSipDay.value > 0 ? c.selectedSipDay.value : 10);
    String suffix = 'th';
    if (intDay % 10 == 1 && intDay != 11) {
      suffix = 'st';
    } else if (intDay % 10 == 2 && intDay != 12) {
      suffix = 'nd';
    } else if (intDay % 10 == 3 && intDay != 13) {
      suffix = 'rd';
    }
    return 'Monthly • $intDay$suffix';
  }

  String _getBasketFrequencyType(List<MutualFundListEntity> selected) {
    if (selected.isEmpty) return 'Monthly';
    final frequencies = selected.map((f) => _frequency(f)).toSet();
    if (frequencies.length == 1) {
      return frequencies.first;
    }
    return 'Mixed';
  }

  String _getFrequencyHeaderTitle(
    List<MutualFundListEntity> selected,
    bool isLumpsum,
  ) {
    if (isLumpsum) return 'TOTAL PAYABLE';
    final type = _getBasketFrequencyType(selected);
    switch (type) {
      case 'Daily':
        return 'DAILY SIP AMOUNT';
      case 'Weekly':
        return 'WEEKLY SIP AMOUNT';
      case 'Monthly':
        return 'MONTHLY SIP AMOUNT';
      default:
        return 'TOTAL SIP INSTALLMENT';
    }
  }

  String _getFrequencyAmountSuffix(
    List<MutualFundListEntity> selected,
    bool isLumpsum,
  ) {
    if (isLumpsum) return '';
    final type = _getBasketFrequencyType(selected);
    switch (type) {
      case 'Daily':
        return ' / day';
      case 'Weekly':
        return ' / week';
      case 'Monthly':
        return ' / mo';
      default:
        return '';
    }
  }

  String _getFrequencySubtitle(
    List<MutualFundListEntity> selected,
    bool isLumpsum,
    String targetDateStr,
  ) {
    if (isLumpsum) {
      return 'One-time investment toward ${c.goalNameTextEditingController.text}';
    }
    final type = _getBasketFrequencyType(selected);
    switch (type) {
      case 'Daily':
        return 'Auto-debited daily on business days to reach ${money(c.targetAmount.value)} by $targetDateStr';
      case 'Weekly':
        return 'Auto-debited weekly on selected weekdays to reach ${money(c.targetAmount.value)} by $targetDateStr';
      case 'Monthly':
        return 'Auto-debited monthly on selected dates to reach ${money(c.targetAmount.value)} by $targetDateStr';
      default:
        return 'Includes mixed frequencies (Daily, Weekly & Monthly) toward ${money(c.targetAmount.value)}';
    }
  }

  String _getFundAmountSuffix(MutualFundListEntity fund) {
    final freq = _frequency(fund);
    switch (freq) {
      case 'Daily':
        return '/ day';
      case 'Weekly':
        return '/ wk';
      case 'Monthly':
      default:
        return '/ mo';
    }
  }

  String _getButtonText(List<MutualFundListEntity> selected) {
    final isLumpsum = c.savedInvestmentType.value == 'lumpsum';
    if (!review) {
      return 'Review Plan';
    }
    if (_isMandateNeededForSelectedMethod()) {
      return 'Set Up Auto Pay';
    }
    if (isLumpsum) {
      return 'Pay ${money(total)}';
    }
    final type = _getBasketFrequencyType(selected);
    switch (type) {
      case 'Daily':
        return 'Pay ${money(total)} / day';
      case 'Weekly':
        return 'Pay ${money(total)} / wk';
      case 'Monthly':
        return 'Pay ${money(total)} / mo';
      default:
        return 'Pay ${money(total)}';
    }
  }

  GoalSipController get c => widget.controller;
  // Search results are transient: closing or searching the picker replaces them.
  // Retain fund details independently; selection remains owned by GetX.
  final Map<String, MutualFundListEntity> _knownFunds = {};

  List<MutualFundListEntity> get selectedFunds {
    for (final fund in Get.find<MutualFundController>().searchFund) {
      _knownFunds[fund.schemeCode ?? fund.baseSchemeName ?? ''] = fund;
    }
    return _knownFunds.values
        .where((fund) => c.isSelectedFund(fund.baseSchemeName ?? ''))
        .toList();
  }

  List<MutualFundListEntity> get funds => selectedFunds;
  bool backToBasket() {
    if (!review) return false;
    setState(() {
      review = false;
      _amountMismatchConfirmed = false;
    });
    return true;
  }

  static const purple = Color(0xFF441D9E),
      line = Color(0xFFE4E6EE),
      muted = Color(0xFF5E6175);
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E176F), Color(0xFF5B3FE0)],
  );
  TextStyle text(
    double size, {
    Color color = const Color(0xFF12121A),
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: size,
    color: color,
    fontWeight: weight,
  );
  BoxDecoration box(double radius) => BoxDecoration(
    color: Colors.white,
    border: Border.all(color: line),
    borderRadius: BorderRadius.circular(radius),
  );
  String money(num n) =>
      '₹${NumberFormat.decimalPattern('en_IN').format(n.round())}';
  double amount(MutualFundListEntity f) =>
      double.tryParse(
        c.getAmountController(f.schemeCode ?? '').text.replaceAll(',', ''),
      ) ??
      0;
  double get total => funds.fold(0, (sum, f) => sum + amount(f));
  double get _expectedGoalAmount {
    final isLumpsum = c.savedInvestmentType.value == 'lumpsum';
    if (isLumpsum) {
      if (c.lumpsumAmount.value > 0) return c.lumpsumAmount.value;
      if (c.targetAmount.value > 0) return c.targetAmount.value;
      return 0.0;
    } else {
      if (c.monthlySip.value > 0) return c.monthlySip.value.toDouble();
      if (c.existingSipAmount.value > 0) return c.existingSipAmount.value;
      final savedMonthly = c.currentGoalDetail.value?.monthlySavings.toDouble();
      if (savedMonthly != null && savedMonthly > 0) return savedMonthly;
      return 0.0;
    }
  }

  Future<void> _commitFundAmount(String schemeCode, String rawValue) async {
    final value = double.tryParse(rawValue.replaceAll(',', '')) ?? 0;
    if (value <= 0 || c.isDistributingAmount.value) return;
    if (c.savedInvestmentType.value == 'lumpsum') {
      await c.redistributeRemainingAmount(
        editedSchemeCode: schemeCode,
        editedAmount: value,
      );
    } else {
      await c.redistributeSipAmountAfterEdit(
        editedSchemeCode: schemeCode,
        editedAmount: value,
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _deleteFund(MutualFundListEntity f) async {
    final id = c.getGoalFundId(f.schemeCode ?? '');
    if (id != null) {
      await c.deleteGoalFund(id: id, isEdit: false, schemeName: f.schemeCode);
    }
    c.toggleFund(f.baseSchemeName ?? '');
    c.amountControllers.remove(f.schemeCode);
    if (f.schemeCode != null) {
      c.manuallyEditedSchemeCodes.remove(f.schemeCode);
    }
    if (c.savedInvestmentType.value == 'lumpsum') {
      await c.distributeMonthlyAmount();
    } else {
      await c.distributeSipAmount();
    }
    if (mounted) setState(() {});
  }

  int minRequired(MutualFundListEntity f) {
    final isLumpsum = c.savedInvestmentType.value == 'lumpsum';
    if (isLumpsum) {
      return (f.minLumpsum != null && f.minLumpsum! > 0) ? f.minLumpsum! : 1000;
    } else {
      return (f.minSipAmount != null && f.minSipAmount! > 0)
          ? f.minSipAmount!
          : 500;
    }
  }

  String? _getFundAmountError(MutualFundListEntity f) {
    final amt = amount(f);
    final min = minRequired(f);

    if (amt <= 0) {
      return 'Please enter an amount';
    }
    if (amt < min) {
      return 'Min investment: ₹${NumberFormat.decimalPattern('en_IN').format(min)}';
    }
    if ((amt.round() % 100) != 0) {
      return 'Amount must be a multiple of ₹100';
    }
    return null;
  }

  Widget svg(String name, double width, double height) => SvgPicture.asset(
    'assets/home/figma/$name.svg',
    width: width,
    height: height,
  );

  @override
  Widget build(BuildContext context) => Obx(() {
    final selected = funds;
    final loading = c.isLoading.value;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: GoalFlowAppBar(
        title: review ? 'Review Plan' : 'Goal Basket',
        step: review ? null : 4,
        onBack: () {
          if (!backToBasket()) widget.onBack();
        },
        trailing: review
            ? circle(
                svg('goal_basket_edit', 22, 22),
                () => setState(() {
                  review = false;
                  _amountMismatchConfirmed = false;
                }),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                child: SingleChildScrollView(
                  key: ValueKey(review),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: review ? reviewContent(selected) : basket(selected),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    Text(
                      review
                          ? 'Mutual fund investments are subject to market risks; read all scheme related documents carefully.'
                          : 'Regular plans via an AMFI-registered distributor. Read scheme documents before investing.',
                      textAlign: TextAlign.center,
                      style: text(
                        11,
                        color: const Color(0xFF6E7186),
                      ).copyWith(height: 15 / 11),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x617C5CFF),
                            blurRadius: 30,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: loading || selected.isEmpty
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  final hasValidationError = selected.any(
                                    (fund) => _getFundAmountError(fund) != null,
                                  );
                                  if (hasValidationError) {
                                    setState(() {});
                                    return;
                                  }

                                  final goalAmount = _expectedGoalAmount;
                                  final hasMismatch =
                                      goalAmount > 0 &&
                                      (total - goalAmount).abs() >= 1;

                                  if (hasMismatch &&
                                      !_amountMismatchConfirmed) {
                                    final proceed =
                                        await _showAmountMismatchDialog(
                                          context: context,
                                          basketTotal: total,
                                          goalAmount: goalAmount,
                                          isLumpsum:
                                              c.savedInvestmentType.value ==
                                              'lumpsum',
                                        );
                                    if (!proceed) return;
                                    _amountMismatchConfirmed = true;
                                  }

                                  if (review) {
                                    if (_isMandateNeededForSelectedMethod()) {
                                      await _navigateToMandateSetup();
                                    } else {
                                      await widget.onCheckout();
                                    }
                                  } else {
                                    if (Get.isRegistered<
                                      PersonalisationController
                                    >()) {
                                      final pCtrl =
                                          Get.find<PersonalisationController>();
                                      pCtrl.syncDefaultCheckoutBank(
                                        isLumpsum:
                                            c.savedInvestmentType.value ==
                                            'lumpsum',
                                      );
                                      _syncOptimalPaymentMethod(
                                        pCtrl.activeCheckoutBank,
                                      );
                                    }
                                    setState(() => review = true);
                                  }
                                },
                          child: Center(
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Obx(
                                    () => Text(
                                      _getButtonText(selected),
                                      style: text(
                                        16,
                                        color: Colors.white,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });

  Widget circle(Widget child, VoidCallback? onTap) => Material(
    color: const Color(0xFFF0F1F6),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(width: 44, height: 44, child: Center(child: child)),
    ),
  );

  Widget basket(List<MutualFundListEntity> selected) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Your ${c.goalNameTextEditingController.text} basket',
        style: text(
          24,
          weight: FontWeight.w700,
        ).copyWith(height: 37 / 24, letterSpacing: -0.48),
      ),
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            money(total),
            style: text(
              22,
              weight: FontWeight.w800,
              color: const Color(0xFF12121A),
            ),
          ),
          if (_expectedGoalAmount > 0) ...[
            Text(
              ' / ${money(_expectedGoalAmount)}',
              style: text(16, weight: FontWeight.w600, color: muted),
            ),
          ],
        ],
      ),
      const SizedBox(height: 4),
      Text(
        'Across ${selected.length} ${selected.length == 1 ? 'fund' : 'funds'}, chosen for a ${c.years.value.toInt()}-year goal.',
        style: text(14, color: muted).copyWith(height: 1.5),
      ),
      const SizedBox(height: 20),
      ...selected.map(
        (f) => Dismissible(
          key: ValueKey(
            'basket_${f.schemeCode ?? f.baseSchemeName ?? UniqueKey().toString()}',
          ),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEB),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Delete',
                  style: text(
                    13,
                    color: const Color(0xFFFF383C),
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFFF383C),
                  size: 22,
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            if (selected.length <= 1) {
              CustomSnackbar.warning(
                title: 'Cannot Remove',
                message: 'At least one fund must remain in your goal basket.',
              );
              return false;
            }
            return true;
          },
          onDismissed: (direction) async {
            await _deleteFund(f);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: fundCard(f),
          ),
        ),
      ),
      if (Get.find<MutualFundController>().isLoading.value ||
          Get.find<MutualFundController>().searchFund.any(
            (f) => !c.isSelectedFund(f.baseSchemeName ?? ''),
          )) ...[
        Text('Popular Funds', style: text(18, weight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (Get.find<MutualFundController>().isLoading.value)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(color: purple, strokeWidth: 2),
              ),
            ),
          )
        else
          ...Get.find<MutualFundController>().searchFund
              .where((f) => !c.isSelectedFund(f.baseSchemeName ?? ''))
              .take(6)
              .map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: const BorderSide(color: line),
                    ),
                    child: ListTile(
                      leading: fundLogo(f),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        f.baseSchemeName ?? '',
                        style: text(14, weight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        'Risk: ${f.riskLevel ?? '—'} • 3Y: ${f.returnsEntity?.threeYear ?? '—'}',
                        style: text(11, color: muted),
                      ),
                      trailing: const Icon(
                        Icons.add_circle_outline,
                        color: purple,
                      ),
                      onTap: () async {
                        if (c.isLoading.value) return;
                        c.showLoading();
                        try {
                          c.toggleFund(f.baseSchemeName ?? '');
                          if (c.savedInvestmentType.value == 'lumpsum') {
                            await c.distributeMonthlyAmount();
                          } else {
                            await c.distributeSipAmount();
                          }
                        } finally {
                          c.hideLoading();
                          if (mounted) setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
      ],
      DottedBorder(
        options: const RoundedRectDottedBorderOptions(
          radius: Radius.circular(22),
          color: Color(0xFF2E289F),
          strokeWidth: 1.5,
          dashPattern: [6, 4],
          padding: EdgeInsets.zero,
        ),
        child: InkWell(
          onTap: widget.onAdd,
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: 78,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x1A2E289F),
                  ),
                  child: Center(child: svg('goal_plan_add', 22, 22)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add more',
                  style: text(10, color: purple, weight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget fundLogo(MutualFundListEntity fund) {
    final path = fund.amc?.amcLogoUrl?.trim();
    final uri = path == null || path.isEmpty
        ? null
        : Uri.parse(path).hasScheme
        ? path
        : '${Appurl.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/${path.replaceFirst(RegExp(r'^/+'), '')}';
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CustomCachedImage(
        imageUrl: uri,
        width: 40,
        height: 40,
        radius: 10,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget fundCard(MutualFundListEntity f) {
    final fundError = _getFundAmountError(f);
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(16),
      decoration: box(22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fundLogo(f),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.baseSchemeName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text(14, weight: FontWeight.w700),
                ),
                const SizedBox(height: 7),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Risk: ',
                        style: text(10, color: muted),
                      ),
                      TextSpan(
                        text: f.riskLevel ?? '—',
                        style: text(10, color: const Color(0xFFFF383C)),
                      ),
                      TextSpan(
                        text: ' • Return: ${f.returnsEntity?.threeYear ?? '—'}',
                        style: text(10, color: muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 20,
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            _commitFundAmount(
                              f.schemeCode ?? '',
                              c.getAmountController(f.schemeCode ?? '').text,
                            );
                          }
                        },
                        child: TextField(
                          controller: c.getAmountController(f.schemeCode ?? ''),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: text(11, weight: FontWeight.w800),
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            prefixText: '₹ ',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: fundError != null
                                    ? const Color(0xFFE11D48)
                                    : line,
                                width: fundError != null ? 1.2 : 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: fundError != null
                                    ? const Color(0xFFE11D48)
                                    : purple,
                                width: fundError != null ? 1.2 : 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: fundError != null
                                    ? const Color(0xFFE11D48)
                                    : line,
                              ),
                            ),
                          ),
                          onSubmitted: (v) =>
                              _commitFundAmount(f.schemeCode ?? '', v),
                        ),
                      ),
                    ),
                    if (c.savedInvestmentType.value != 'lumpsum')
                      SizedBox(
                        height: 20,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            side: const BorderSide(color: line),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () => frequency(f),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                getFrequencyDisplayLabel(f),
                                style: text(10, weight: FontWeight.w800),
                              ),
                              const SizedBox(width: 4),
                              svg('goal_basket_chevron', 3.5, 6),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                if (fundError != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 13,
                        color: Color(0xFFE11D48),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          fundError,
                          style: text(
                            11,
                            color: const Color(0xFFE11D48),
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 20,
            height: 24,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: line),
              ),
              popUpAnimationStyle: const AnimationStyle(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              icon: svg('goal_basket_more', 3.66667, 17),
              onSelected: (v) async {
                if (v == 'detail') {
                  Get.toNamed(
                    AppRoutes.funddetails,
                    arguments: {
                      'scheme': f.baseSchemeName,
                      'scheme_code': f.schemeCode,
                      'isin': f.isin,
                    },
                  );
                } else if (v == 'swap') {
                  final before = funds.map((e) => e.schemeCode).toSet();
                  await widget.onAdd();
                  if (funds.any((e) => !before.contains(e.schemeCode))) {
                    c.toggleFund(f.baseSchemeName ?? '');
                    c.amountControllers.remove(f.schemeCode);
                    if (f.schemeCode != null) {
                      c.manuallyEditedSchemeCodes.remove(f.schemeCode);
                    }
                    if (c.savedInvestmentType.value == 'lumpsum') {
                      await c.distributeMonthlyAmount();
                    } else {
                      await c.distributeSipAmount();
                    }
                    if (mounted) setState(() {});
                  }
                } else {
                  if (funds.length <= 1) {
                    CustomSnackbar.warning(
                      title: 'Cannot Remove',
                      message:
                          'At least one fund must remain in your goal basket.',
                    );
                    return;
                  }
                  await _deleteFund(f);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'detail',
                  child: Text('Fund Detail', style: text(12, color: muted)),
                ),
                PopupMenuItem(
                  value: 'swap',
                  child: Text('Swap', style: text(12, color: purple)),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: text(12, color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void frequency(MutualFundListEntity f) {
    final current = _frequency(f);
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(195, 275, 40, 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: line),
      ),
      items: [
        for (final label in ['Daily', 'Weekly', 'Monthly'])
          PopupMenuItem(
            value: label,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: text(
                    12,
                    color: label == current ? purple : const Color(0xFF12121A),
                    weight: label == current
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                if (label == current)
                  const Icon(Icons.check, color: purple, size: 16),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (!mounted || value == null) return;
      setState(() => _frequencies[_frequencyKey(f)] = value);
      if (value == 'Monthly') {
        calendar(f);
      } else if (value == 'Weekly') {
        _pickWeekDay(f);
      } else if (value == 'Daily') {
        setState(() => _sipDays[_frequencyKey(f)] = 'NA');
      }
    });
  }

  void _pickWeekDay(MutualFundListEntity f) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final currentDay = _sipDays[_frequencyKey(f)] ?? 'Monday';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close SIP weekday',
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, a, b) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SIP day of week',
                      style: text(16, weight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...days.map((day) {
                final isSelected = day == currentDay;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() => _sipDays[_frequencyKey(f)] = day);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF3EFFF)
                          : const Color(0xFFF8F9FD),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSelected ? purple : line),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Every $day',
                          style: text(
                            14,
                            color: isSelected
                                ? purple
                                : const Color(0xFF12121A),
                            weight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: purple,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Text(
                'Weekly SIP order executes every week on this day.',
                style: text(11, color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calendar(MutualFundListEntity f) {
    final allowed = RegExp(r'\d+')
        .allMatches(f.allowedSipDates ?? '')
        .map((m) => int.parse(m.group(0)!))
        .toSet();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close SIP date',
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, a, b) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SIP date each month',
                      style: text(14, weight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFFF),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 31,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisExtent: 48,
                  ),
                  itemBuilder: (context, i) {
                    final day = i + 1;
                    return Obx(
                      () => InkWell(
                        onTap: allowed.isNotEmpty && !allowed.contains(day)
                            ? null
                            : () {
                                c.selectedSipDay.value = day;
                                setState(
                                  () => _sipDays[_frequencyKey(f)] = day
                                      .toString(),
                                );
                                Navigator.of(context).pop();
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: const Cubic(0.2, 0, 0, 1),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.selectedSipDay.value == day
                                ? const Color(0xFF0E176F)
                                : Colors.transparent,
                          ),
                          child: Text(
                            '$day',
                            style: text(
                              15,
                              color: c.selectedSipDay.value == day
                                  ? Colors.white
                                  : allowed.isNotEmpty && !allowed.contains(day)
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SIP date applies to the monthly order.',
                style: text(12, color: muted),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showAmountMismatchDialog({
    required BuildContext context,
    required double basketTotal,
    required double goalAmount,
    required bool isLumpsum,
  }) async {
    final isLess = basketTotal < goalAmount;
    final diff = (basketTotal - goalAmount).abs();
    final period = isLumpsum ? 'invested' : 'a month';
    final tenureYears = c.years.value.toInt() > 0
        ? c.years.value.toInt()
        : ((c.currentGoalDetail.value?.goalTenure ?? 0) / 12).round();
    final targetAmt = c.targetAmount.value > 0
        ? money(c.targetAmount.value)
        : (c.currentGoalDetail.value?.targetAmount != null
              ? money(c.currentGoalDetail.value!.targetAmount)
              : null);

    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Amount validation',
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim, secondaryAnim, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            child: child,
          ),
        );
      },
      pageBuilder: (context, a, b) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isLess
                        ? const Color(0xFFFFF7ED)
                        : const Color(0xFFF3EFFF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      isLess
                          ? Icons.warning_amber_rounded
                          : Icons.trending_up_rounded,
                      color: isLess
                          ? const Color(0xFFEA580C)
                          : const Color(0xFF5B3FE0),
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isLess
                    ? 'Investment Amount is Less'
                    : 'Investment Amount is Higher',
                textAlign: TextAlign.center,
                style: text(18, weight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                isLess
                    ? 'Your total basket amount is less than the planned goal amount. Investing less may delay reaching your goal${targetAmt != null && tenureYears > 0 ? ' of $targetAmt in $tenureYears years' : ''}.'
                    : 'Your total basket amount is higher than the planned goal amount. Investing more can help you achieve your goal earlier${targetAmt != null && tenureYears > 0 ? ' than $tenureYears years' : ''}.',
                textAlign: TextAlign.center,
                style: text(13, color: muted).copyWith(height: 1.45),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: line),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Planned Goal', style: text(13, color: muted)),
                        Text(
                          '${money(goalAmount)} $period',
                          style: text(13, weight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Basket Total', style: text(13, color: muted)),
                        Text(
                          '${money(basketTotal)} $period',
                          style: text(
                            13,
                            color: isLess
                                ? const Color(0xFFEA580C)
                                : const Color(0xFF5B3FE0),
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16, color: line),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Difference',
                          style: text(
                            13,
                            color: muted,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${money(diff)} ${isLess ? 'less' : 'more'}',
                          style: text(
                            13,
                            color: isLess
                                ? const Color(0xFFEA580C)
                                : const Color(0xFF16A34A),
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(
                        'Adjust Amount',
                        style: text(
                          14,
                          color: const Color(0xFF12121A),
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => Navigator.of(context).pop(true),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: Text(
                                'Proceed Anyway',
                                style: text(
                                  14,
                                  color: Colors.white,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }

  Widget reviewContent(List<MutualFundListEntity> selected) {
    final isLumpsum = c.savedInvestmentType.value == 'lumpsum';
    final targetDateStr = DateFormat('MMM yyyy').format(
      DateTime(
        DateTime.now().year + c.years.value.toInt(),
        DateTime.now().month,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('My Goals / New', style: text(12, color: muted)),
        const SizedBox(height: 6),
        Text(
          c.goalNameTextEditingController.text,
          style: text(28, weight: FontWeight.w700),
        ),
        const SizedBox(height: 18),

        // ── 1. Amount to Pay / Investment Summary Card ──
        Container(
          padding: const EdgeInsets.all(18),
          decoration: box(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getFrequencyHeaderTitle(selected, isLumpsum),
                    style: text(
                      11,
                      weight: FontWeight.w700,
                      color: muted,
                    ).copyWith(letterSpacing: 0.8),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${selected.length} ${selected.length == 1 ? 'Fund' : 'Funds'}',
                      style: text(11, weight: FontWeight.w700, color: purple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${money(total)}${_getFrequencyAmountSuffix(selected, isLumpsum)}',
                style: text(
                  28,
                  weight: FontWeight.w800,
                  color: const Color(0xFF1A1D2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getFrequencySubtitle(selected, isLumpsum, targetDateStr),
                style: text(12, color: muted),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFF0F1F6)),
              const SizedBox(height: 12),
              Text(
                'FUNDS BREAKDOWN',
                style: text(
                  10,
                  weight: FontWeight.w700,
                  color: muted,
                ).copyWith(letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              ...selected.map((f) {
                final amt = amount(f);
                final freq = _frequency(f);
                final freqLabel = getFrequencyDisplayLabel(f);
                final isDaily = freq == 'Daily';
                final isWeekly = freq == 'Weekly';
                final badgeColor = isDaily
                    ? const Color(0xFF0284C7)
                    : (isWeekly
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF4338CA));
                final badgeBg = isDaily
                    ? const Color(0xFFF0F9FF)
                    : (isWeekly
                          ? const Color(0xFFF5F3FF)
                          : const Color(0xFFEEF2FF));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f.baseSchemeName ?? '',
                              style: text(
                                13,
                                weight: FontWeight.w600,
                                color: const Color(0xFF1A1D2E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!isLumpsum) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  freqLabel,
                                  style: text(
                                    10,
                                    weight: FontWeight.w600,
                                    color: badgeColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            money(amt),
                            style: text(
                              14,
                              weight: FontWeight.w700,
                              color: const Color(0xFF1A1D2E),
                            ),
                          ),
                          if (!isLumpsum)
                            Text(
                              _getFundAmountSuffix(f),
                              style: text(10, color: muted),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── 2. Investment Bank Selection (Like Payment Page) ──
        Text(
          'INVESTMENT BANK',
          style: text(
            11,
            weight: FontWeight.w700,
            color: muted,
          ).copyWith(letterSpacing: 0.8),
        ),
        const SizedBox(height: 8),
        CheckoutBankCard(isLumpsum: isLumpsum),

        const SizedBox(height: 20),

        // ── 3. Payment Method & Mandate Section ──
        Obx(() {
          final personalisationCtrl = Get.find<PersonalisationController>();
          final mfuCtrl = Get.find<MfuController>();
          final bank = personalisationCtrl.activeCheckoutBank;
          final mandates = bank?.approvedMandates ?? [];

          final upiMandate = mandates.firstWhereOrNull(
            (m) =>
                m.mandateMode?.toUpperCase() == 'UPI' &&
                (m.status?.toLowerCase() == 'approved' ||
                    m.status?.toLowerCase() == 'active' ||
                    m.aggrStatus?.toUpperCase() == 'AC'),
          );
          final hasActiveUpiMandate = upiMandate != null;

          final enachMandate = mandates.firstWhereOrNull(
            (m) =>
                (m.mandateMode?.toUpperCase() == 'ENACH' ||
                    m.mandateMode?.toUpperCase() == 'NETBANKING') &&
                (m.status?.toLowerCase() == 'approved' ||
                    m.status?.toLowerCase() == 'active' ||
                    m.aggrStatus?.toUpperCase() == 'AC'),
          );
          final hasActiveEnachMandate = enachMandate != null;

          final selectedMethod = mfuCtrl.selectedMethod.value;
          final isSelectedMethodMandateReady =
              (selectedMethod == 'upi' && hasActiveUpiMandate) ||
              ((selectedMethod == 'netbanking' || selectedMethod == 'enach') &&
                  hasActiveEnachMandate);

          return Container(
            padding: const EdgeInsets.all(18),
            decoration: box(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isLumpsum
                          ? 'CHOOSE PAYMENT METHOD'
                          : 'PAY AUTOMATICALLY WITH',
                      style: text(
                        11,
                        weight: FontWeight.w700,
                        color: muted,
                      ).copyWith(letterSpacing: 0.8),
                    ),
                    if (!isLumpsum)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelectedMethodMandateReady
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isSelectedMethodMandateReady
                              ? 'Mandate Ready ✓'
                              : 'Mandate Required',
                          style: text(
                            10,
                            weight: FontWeight.w700,
                            color: isSelectedMethodMandateReady
                                ? const Color(0xFF059669)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isLumpsum
                      ? 'Instant one-time investment via verified bank'
                      : 'Recurring mandate linked to ${bank?.bankName ?? "your bank"}',
                  style: text(12, color: muted),
                ),
                const SizedBox(height: 14),

                // Option 1: UPI / UPI AutoPay
                paymentOption(
                  method: 'upi',
                  icon: Icons.smartphone_rounded,
                  title: isLumpsum ? 'UPI' : 'UPI AutoPay',
                  subtitle: isLumpsum
                      ? 'Instant approval via any UPI app (GPay, PhonePe, Paytm)'
                      : (hasActiveUpiMandate
                            ? 'Active mandate approved${upiMandate.mumrn != null && upiMandate.mumrn!.isNotEmpty ? " • ${upiMandate.mumrn}" : ""}'
                            : 'One-time approval in PhonePe, GPay, or Paytm'),
                  badgeText: isLumpsum
                      ? 'Instant'
                      : (hasActiveUpiMandate
                            ? 'Active Mandate ✓'
                            : 'Setup Required'),
                  isSuccessBadge: isLumpsum || hasActiveUpiMandate,
                  onSetupTap: (!isLumpsum && !hasActiveUpiMandate)
                      ? _navigateToMandateSetup
                      : null,
                ),

                const SizedBox(height: 12),

                // Option 2: NetBanking / Bank e-Mandate
                paymentOption(
                  method: 'netbanking',
                  icon: Icons.account_balance_rounded,
                  title: isLumpsum ? 'NetBanking' : 'Bank e-Mandate (eNACH)',
                  subtitle: isLumpsum
                      ? 'Pay directly via your bank internet banking portal'
                      : (hasActiveEnachMandate
                            ? 'Active eNACH approved${enachMandate.maxAmount != null && enachMandate.maxAmount!.isNotEmpty ? " • Limit ₹${enachMandate.maxAmount}" : ""}'
                            : 'Authenticate once via NetBanking or Debit Card'),
                  badgeText: isLumpsum
                      ? 'Direct'
                      : (hasActiveEnachMandate
                            ? 'Active eNACH ✓'
                            : 'Setup Required'),
                  isSuccessBadge: isLumpsum || hasActiveEnachMandate,
                  onSetupTap: (!isLumpsum && !hasActiveEnachMandate)
                      ? _navigateToMandateSetup
                      : null,
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        // ── 4. Goal Target & Tenure Info ──
        detail(
          'Target',
          Text(
            money(c.targetAmount.value),
            style: text(14, weight: FontWeight.w800),
          ),
        ),
        detail(
          'Target date',
          Text(targetDateStr, style: text(14, weight: FontWeight.w700)),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  Widget detail(String label, Widget value) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: text(14, color: muted)),
        ),
        Expanded(child: value),
      ],
    ),
  );
  Widget pill(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(label, style: text(12, weight: FontWeight.w600)),
  );
  Widget paymentOption({
    required String method,
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    bool isSuccessBadge = false,
    VoidCallback? onSetupTap,
  }) {
    final m = Get.find<MfuController>();
    return Obx(() {
      final isSelected = m.selectedMethod.value == method;
      return InkWell(
        onTap: () => m.selectMethod(method),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF3F0FF)
                : const Color(0xFFFAFAFD),
            border: Border.all(
              color: isSelected ? const Color(0xFF5B3FE0) : line,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5B3FE0)
                        : const Color(0xFFC4C6D4),
                    width: isSelected ? 7 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? purple.withValues(alpha: 0.12)
                      : const Color(0xFFE8EAF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? purple : const Color(0xFF6E7186),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: text(
                              14,
                              weight: FontWeight.w700,
                              color: const Color(0xFF1A1D2E),
                            ),
                          ),
                        ),
                        if (badgeText != null)
                          GestureDetector(
                            onTap: onSetupTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isSuccessBadge
                                    ? const Color(0xFFECFDF5)
                                    : const Color(0xFFFFFBEB),
                                borderRadius: BorderRadius.circular(6),
                                border: isSuccessBadge
                                    ? null
                                    : Border.all(
                                        color: const Color(0xFFFDE68A),
                                      ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    badgeText,
                                    style: text(
                                      10,
                                      weight: FontWeight.w700,
                                      color: isSuccessBadge
                                          ? const Color(0xFF059669)
                                          : const Color(0xFFD97706),
                                    ),
                                  ),
                                  if (!isSuccessBadge &&
                                      onSetupTap != null) ...[
                                    const SizedBox(width: 3),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 8,
                                      color: Color(0xFFD97706),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: text(12, color: muted).copyWith(height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
