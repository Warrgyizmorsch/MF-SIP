import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../explore/domain/entities/mutual_fund_list_entity.dart';
import '../../../explore/presentation/controller/mutual_fund_controller.dart';
import '../../../mfu/presentation/controller/mfu_controller.dart';
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
  bool review = false, consent = false;
  final Map<String, String> _frequencies = {};
  String _frequencyKey(MutualFundListEntity fund) =>
      fund.schemeCode ?? fund.baseSchemeName ?? '';
  String _frequency(MutualFundListEntity fund) =>
      _frequencies[_frequencyKey(fund)] ?? 'Monthly';
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
    setState(() => review = false);
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
                () => setState(() => review = false),
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
                          onTap:
                              loading ||
                                  selected.isEmpty ||
                                  (review && !consent)
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (review) {
                                    if (c.savedInvestmentType.value !=
                                            'lumpsum' &&
                                        selected.any(
                                          (fund) =>
                                              _frequency(fund) != 'Monthly',
                                        )) {
                                      Get.snackbar(
                                        'Frequency unavailable',
                                        'Daily and Weekly orders are not supported by this checkout yet. Select Monthly to continue.',
                                      );
                                      return;
                                    }
                                    await widget.onCheckout();
                                  } else {
                                    setState(() => review = true);
                                  }
                                },
                          child: Center(
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    review
                                        ? (c.savedInvestmentType.value ==
                                                  'lumpsum'
                                              ? 'Pay Now'
                                              : 'Set up autopay & start')
                                        : 'Pay Now',
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
      Text(
        '${money(total)} ${c.savedInvestmentType.value == 'lumpsum' ? 'invested' : 'a month'} across ${selected.length} funds, chosen for a ${c.years.value.toInt()}-year goal.',
        style: text(14, color: muted).copyWith(height: 1.5),
      ),
      const SizedBox(height: 20),
      ...selected.map(
        (f) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: fundCard(f),
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

  Widget fundCard(MutualFundListEntity f) => Container(
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
                    child: TextField(
                      controller: c.getAmountController(f.schemeCode ?? ''),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: text(11, weight: FontWeight.w800),
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: line),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onSubmitted: (v) async {
                        final value = double.tryParse(v) ?? 0;
                        if (c.savedInvestmentType.value == 'lumpsum') {
                          await c.redistributeRemainingAmount(
                            editedSchemeCode: f.schemeCode ?? '',
                            editedAmount: value,
                          );
                        } else {
                          await c.redistributeSipAmountAfterEdit(
                            editedSchemeCode: f.schemeCode ?? '',
                            editedAmount: value,
                          );
                        }
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                  if (c.savedInvestmentType.value != 'lumpsum')
                    SizedBox(
                      width: 100,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _frequency(f),
                              style: text(10, weight: FontWeight.w800),
                            ),
                            svg('goal_basket_chevron', 3.5, 6),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
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
                  if (c.savedInvestmentType.value == 'lumpsum') {
                    await c.distributeMonthlyAmount();
                  } else {
                    await c.distributeSipAmount();
                  }
                }
              } else {
                final id = c.getGoalFundId(f.schemeCode ?? '');
                if (id != null) {
                  await c.deleteGoalFund(
                    id: id,
                    isEdit: false,
                    schemeName: f.schemeCode,
                  );
                }
                c.toggleFund(f.baseSchemeName ?? '');
                c.amountControllers.remove(f.schemeCode);
                if (c.savedInvestmentType.value == 'lumpsum') {
                  await c.distributeMonthlyAmount();
                } else {
                  await c.distributeSipAmount();
                }
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

  void frequency(MutualFundListEntity f) {
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
            child: Text(
              label,
              style: text(12, color: purple, weight: FontWeight.w700),
            ),
          ),
      ],
    ).then((value) {
      if (!mounted || value == null) return;
      setState(() => _frequencies[_frequencyKey(f)] = value);
      if (value == 'Monthly') calendar(f);
    });
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

  Widget reviewContent(List<MutualFundListEntity> selected) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('My Goals / New', style: text(12, color: muted)),
      const SizedBox(height: 6),
      Text(
        c.goalNameTextEditingController.text,
        style: text(30, weight: FontWeight.w700),
      ),
      const SizedBox(height: 46),
      detail(
        'Target',
        Text(
          money(c.targetAmount.value),
          style: text(14, weight: FontWeight.w800),
        ),
      ),
      detail(
        'Plan',
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            pill(
              '${money(total)}${c.savedInvestmentType.value == 'sip' ? '/mo' : ''} ›',
              const Color(0xFFF5A524),
            ),
          ],
        ),
      ),
      detail(
        'Target date',
        Text(
          DateFormat('MMM yyyy').format(
            DateTime(
              DateTime.now().year + c.years.value.toInt(),
              DateTime.now().month,
            ),
          ),
          style: text(14, weight: FontWeight.w700),
        ),
      ),
      detail(
        'Funds',
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: selected
              .map(
                (f) => pill(
                  f.schemecategory ?? f.baseSchemeName ?? '',
                  const Color(0xFFF0F1F6),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 4),
      if (c.savedInvestmentType.value == 'sip')
        Container(
          padding: const EdgeInsets.all(18),
          decoration: box(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pay automatically with',
                style: text(14, weight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              payment(
                'upi',
                'UPI Autopay',
                'Approve once in your UPI app · ready in minutes',
              ),
              const SizedBox(height: 14),
              payment(
                'netbanking',
                'Bank e-mandate',
                'Choose your bank in the secure mandate flow',
              ),
            ],
          ),
        ),
      const SizedBox(height: 18),
      InkWell(
        onTap: () => setState(() => consent = !consent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: consent ? purple : Colors.transparent,
                border: Border.all(color: consent ? purple : line),
              ),
              child: consent
                  ? Center(child: svg('goal_basket_consent', 13, 13))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'I’ve read the scheme documents and riskometer for these ${selected.length} funds, and understand returns aren’t guaranteed.',
                style: text(13).copyWith(height: 19 / 13),
              ),
            ),
          ],
        ),
      ),
    ],
  );
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
  Widget payment(String method, String title, String subtitle) {
    final m = Get.find<MfuController>();
    return Obx(
      () => InkWell(
        onTap: () => m.selectMethod(method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: m.selectedMethod.value == method
                ? const Color(0xFFF3F0FF)
                : const Color(0xFFFAFAFD),
            border: Border.all(
              color: m.selectedMethod.value == method
                  ? const Color(0xFF5B3FE0)
                  : line,
              width: m.selectedMethod.value == method ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: m.selectedMethod.value == method
                        ? const Color(0xFF0E176F)
                        : const Color(0xFFC4C6D4),
                    width: m.selectedMethod.value == method ? 7 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text(14, weight: FontWeight.w700)),
                    Text(subtitle, style: text(12, color: muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
