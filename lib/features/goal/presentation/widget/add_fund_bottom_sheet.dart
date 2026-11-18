import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/purchase_scenario.dart';
import 'package:my_sip/features/cart/presentation/widgets/checkout_bank_selector.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/entity/single_goal_detail_entity.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_req_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_req_model.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/features/personalization/domain/entity/profile_update_entity.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

import 'goal_portfolio_link_tab.dart';

class AddFundBottomSheet extends StatefulWidget {
  final int goalId;
  final UserGoalEntity? goal;
  final SingleGoalDetailEntity? liveDetail;
  final int? initialTabIndex;

  const AddFundBottomSheet({
    super.key,
    required this.goalId,
    this.goal,
    this.liveDetail,
    this.initialTabIndex,
  });

  static Future<void> show(
    BuildContext context, {
    required int goalId,
    UserGoalEntity? goal,
    SingleGoalDetailEntity? liveDetail,
    int? initialTabIndex,
    bool isDesktop = false,
  }) async {
    if (isDesktop) {
      await showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 780),
            child: AddFundBottomSheet(
              goalId: goalId,
              goal: goal,
              liveDetail: liveDetail,
              initialTabIndex: initialTabIndex,
            ),
          ),
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => AddFundBottomSheet(
          goalId: goalId,
          goal: goal,
          liveDetail: liveDetail,
          initialTabIndex: initialTabIndex,
        ),
      );
    }
  }

  @override
  State<AddFundBottomSheet> createState() => _AddFundBottomSheetState();
}

class _AddFundBottomSheetState extends State<AddFundBottomSheet> {
  int _activeTabIndex =
      0; // 0 = Monthly SIP, 1 = One-Time Lumpsum, 2 = Link from Portfolio
  bool _isReviewing = false; // Two-phase flow: selection -> review & pay
  String _selectedCategory = 'Equity';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _fundsScrollController = ScrollController();
  final Map<String, TextEditingController> _amountControllers = {};
  final Set<String> _selectedSchemeCodes = {};
  final Map<String, MutualFundListEntity> _selectedFundsMap = {};
  final Map<String, String> _frequencies = {};
  final Map<String, String> _sipDays = {};
  bool _isSubmitting = false;

  final GoalSipController _goalController = Get.find<GoalSipController>();
  final MutualFundController _mutualController =
      Get.find<MutualFundController>();
  final MfuController _mfuController = Get.find<MfuController>();

  @override
  void initState() {
    super.initState();
    if (widget.initialTabIndex != null) {
      _activeTabIndex = widget.initialTabIndex!;
    } else {
      final initialIsLumpsum =
          (widget.goal?.txnType.toLowerCase() == 'lumpsum') ||
          (_goalController.savedInvestmentType.value == 'lumpsum') ||
          (widget.liveDetail?.investmentType.toLowerCase() == 'lumpsum');
      _activeTabIndex = initialIsLumpsum ? 1 : 0;
    }

    if (Get.isRegistered<PersonalisationController>()) {
      final pCtrl = Get.find<PersonalisationController>();
      pCtrl.syncDefaultCheckoutBank(isLumpsum: _isLumpsum);
      _syncOptimalPaymentMethod(pCtrl.activeCheckoutBank);
    }

    // Setup pagination listener
    _fundsScrollController.addListener(() {
      if (_fundsScrollController.position.pixels >=
          _fundsScrollController.position.maxScrollExtent - 200) {
        _mutualController.loadNextPage();
      }
    });

    if (_mutualController.searchFund.isEmpty) {
      _mutualController.fetchData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fundsScrollController.dispose();
    for (final c in _amountControllers.values) {
      c.dispose();
    }
    // Clean up filters when sheet is closed so Explore page remains unaffected
    _mutualController.resetToDefault();
    super.dispose();
  }

  bool get _isLumpsum => _activeTabIndex == 1;

  void _switchTab(int newIndex) {
    if (_activeTabIndex == newIndex) return;
    setState(() {
      _activeTabIndex = newIndex;
      _isReviewing = false;
      // If switching between SIP (0) and Lumpsum (1), auto-adjust selected funds to the new tab's minimum amount
      if (newIndex == 0 || newIndex == 1) {
        for (final schemeCode in _selectedSchemeCodes) {
          final fund = _selectedFundsMap[schemeCode];
          if (fund != null) {
            final newMin = _getMinAmountForFund(fund);
            final ctrl = _amountControllers[schemeCode];
            if (ctrl != null) {
              ctrl.text = newMin.toString();
            }
          }
        }
      }
    });

    if (Get.isRegistered<PersonalisationController>()) {
      final pCtrl = Get.find<PersonalisationController>();
      pCtrl.syncDefaultCheckoutBank(isLumpsum: _isLumpsum);
      _syncOptimalPaymentMethod(pCtrl.activeCheckoutBank);
    }
  }

  // ── Frequency & Day Helpers (Matching Goal Basket) ──
  String _frequencyKey(MutualFundListEntity fund) =>
      fund.schemeCode?.toString() ?? fund.baseSchemeName ?? '';

  String _frequency(MutualFundListEntity fund) =>
      _frequencies[_frequencyKey(fund)] ?? 'Monthly';

  String _sipDay(MutualFundListEntity fund) =>
      _sipDays[_frequencyKey(fund)] ?? '10';

  String _getFrequencyCode(MutualFundListEntity fund) {
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

  String _getMfuDay(MutualFundListEntity fund) {
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
        final parsed = int.tryParse(dayStr) ?? 10;
        return (parsed > 0 ? parsed : 10).toString();
    }
  }

  String _getFrequencyDisplayLabel(MutualFundListEntity fund) {
    final freq = _frequency(fund);
    if (freq == 'Daily') return 'Daily';
    if (freq == 'Weekly') {
      final day = _sipDay(fund);
      final short = day.length >= 3 ? day.substring(0, 3) : day;
      return 'Weekly • $short';
    }
    final day = _sipDay(fund);
    final intDay = int.tryParse(day) ?? 10;
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

  String _getFrequencyAmountSuffix(List<MutualFundListEntity> selected) {
    if (_isLumpsum) return '';
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

  String _getFundAmountSuffix(MutualFundListEntity fund) {
    if (_isLumpsum) return '';
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

  // ── Mandate & Bank Setup Synchronization ──
  void _syncOptimalPaymentMethod(BankAccountEntity? bank) {
    if (_isLumpsum) return;
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
    if (_isLumpsum) return false;
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

  // ── Frequency Dialog Pickers ──
  void _openFrequencyMenu(BuildContext context, MutualFundListEntity fund) {
    final current = _frequency(fund);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Investment Frequency",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...['Monthly', 'Weekly', 'Daily'].map((freq) {
                final isSelected = freq == current;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? Ucolors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  leading: Icon(
                    freq == 'Monthly'
                        ? Icons.calendar_month_rounded
                        : (freq == 'Weekly'
                              ? Icons.date_range_rounded
                              : Icons.today_rounded),
                    color: isSelected ? Ucolors.primary : Colors.grey.shade600,
                  ),
                  title: Text(
                    freq,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? Ucolors.primary
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Ucolors.primary,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() => _frequencies[_frequencyKey(fund)] = freq);
                    if (freq == 'Monthly') {
                      _openCalendarPicker(fund);
                    } else if (freq == 'Weekly') {
                      _openWeekdayPicker(fund);
                    } else if (freq == 'Daily') {
                      setState(() => _sipDays[_frequencyKey(fund)] = 'NA');
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _openWeekdayPicker(MutualFundListEntity f) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'SIP Day of Week',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
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
                      border: Border.all(
                        color: isSelected
                            ? Ucolors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Every $day',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Ucolors.primary
                                : const Color(0xFF12121A),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Ucolors.primary,
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
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCalendarPicker(MutualFundListEntity f) {
    final allowed = RegExp(r'\d+')
        .allMatches(f.allowedSipDates ?? '')
        .map((m) => int.parse(m.group(0)!))
        .toSet();
    final currentDay = int.tryParse(_sipDays[_frequencyKey(f)] ?? '10') ?? 10;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close SIP date',
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, a, b) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'SIP Date Each Month',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 28, // Common valid MFU SIP range 1-28
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisExtent: 44,
                  ),
                  itemBuilder: (context, i) {
                    final day = i + 1;
                    final isAllowed = allowed.isEmpty || allowed.contains(day);
                    final isSelected = currentDay == day;

                    return InkWell(
                      onTap: !isAllowed
                          ? null
                          : () {
                              setState(
                                () =>
                                    _sipDays[_frequencyKey(f)] = day.toString(),
                              );
                              Navigator.of(context).pop();
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Ucolors.primary
                              : Colors.transparent,
                        ),
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : (isAllowed
                                      ? FontWeight.w500
                                      : FontWeight.w300),
                            color: isSelected
                                ? Colors.white
                                : (isAllowed
                                      ? const Color(0xFF1E293B)
                                      : Colors.grey.shade400),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Dates 1st through 28th are supported for monthly auto-debit.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Amount & Validation Helpers ──
  int _getMinAmountForFund(MutualFundListEntity fund) {
    if (_isLumpsum) {
      return (fund.minLumpsum != null && fund.minLumpsum! > 0)
          ? fund.minLumpsum!
          : 1000;
    } else {
      return (fund.minSipAmount != null && fund.minSipAmount! > 0)
          ? fund.minSipAmount!
          : 500;
    }
  }

  String? _getFundAmountError(MutualFundListEntity fund) {
    final schemeCode = fund.schemeCode?.toString() ?? '';
    final ctrl = _amountControllers[schemeCode];
    final amount = double.tryParse(ctrl?.text ?? '0') ?? 0.0;
    final min = _getMinAmountForFund(fund);

    if (amount <= 0) {
      return 'Please enter an amount';
    }
    if (amount < min) {
      return 'Min investment: ₹${NumberFormat.decimalPattern('en_IN').format(min)}';
    }
    if ((amount.round() % 100) != 0) {
      return 'Amount must be a multiple of ₹100';
    }
    return null;
  }

  bool _hasInvalidAmounts() {
    for (final schemeCode in _selectedSchemeCodes) {
      final fund = _selectedFundsMap[schemeCode];
      if (fund != null && _getFundAmountError(fund) != null) {
        return true;
      }
    }
    return false;
  }

  TextEditingController _getControllerForScheme(
    String schemeCode,
    int? defaultMin,
  ) {
    final targetMin = (defaultMin != null && defaultMin > 0)
        ? defaultMin
        : 1000;
    if (!_amountControllers.containsKey(schemeCode)) {
      _amountControllers[schemeCode] = TextEditingController(
        text: targetMin.toString(),
      );
    } else if (!_selectedSchemeCodes.contains(schemeCode)) {
      _amountControllers[schemeCode]!.text = targetMin.toString();
    }
    return _amountControllers[schemeCode]!;
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (final schemeCode in _selectedSchemeCodes) {
      final ctrl = _amountControllers[schemeCode];
      if (ctrl != null) {
        total += double.tryParse(ctrl.text) ?? 0.0;
      }
    }
    return total;
  }

  // ── Payment Execution ──
  Future<void> _executePayment() async {
    final selectedFunds = _selectedFundsMap.values.toList();
    if (selectedFunds.isEmpty) return;

    final isLumpsum = _isLumpsum;

    GatekeeperHelper.runWithPrerequisites(
      isLumpsum: isLumpsum,
      onSuccess: () async {
        setState(() {
          _isSubmitting = true;
        });

        try {
          if (isLumpsum) {
            final List<LumpsumFundItemModel> lumpsumFunds = [];
            for (final fund in selectedFunds) {
              final schemeCode = fund.schemeCode?.toString() ?? '';
              final amount =
                  double.tryParse(
                    _amountControllers[schemeCode]?.text ?? '0',
                  ) ??
                  0.0;
              if (schemeCode.isNotEmpty && amount > 0) {
                lumpsumFunds.add(
                  LumpsumFundItemModel(
                    schemeCode: schemeCode,
                    amount: amount,
                    folio: "NEW",
                  ),
                );
              }
            }

            if (lumpsumFunds.isNotEmpty) {
              await _mfuController.postLumpsum(
                goalId: widget.goalId,
                funds: lumpsumFunds,
              );
            }
          } else {
            final List<SipFundItemModel> sipFunds = [];
            for (final fund in selectedFunds) {
              final schemeCode = fund.schemeCode?.toString() ?? '';
              final amount =
                  double.tryParse(
                    _amountControllers[schemeCode]?.text ?? '0',
                  ) ??
                  0.0;
              if (schemeCode.isNotEmpty && amount > 0) {
                final freq = _getFrequencyCode(fund);
                final day = _getMfuDay(fund);
                sipFunds.add(
                  SipFundItemModel(
                    schemeCode: schemeCode,
                    amount: amount,
                    folio: "NEW",
                    frequency: freq,
                    day: day,
                  ),
                );
              }
            }

            if (sipFunds.isNotEmpty) {
              await _mfuController.postSip(
                goalId: widget.goalId,
                funds: sipFunds,
              );
            }
          }

          if (mounted) {
            Navigator.of(context).pop();
          }

          await _goalController.fetchSingleGoal(widget.goalId);
          await _goalController.getAllGoals();
        } catch (e) {
          debugPrint("Error in AddFundBottomSheet: $e");
          Get.snackbar(
            "Error",
            "Something went wrong while processing investment.",
          );
        } finally {
          if (mounted) {
            setState(() {
              _isSubmitting = false;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final maxHeight = mediaQuery.size.height * 0.90;

    final selectedFunds = _selectedFundsMap.values.toList();
    final double totalAmount = _calculateTotalAmount();

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle & Top Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                if (_isReviewing) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF1E293B),
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _isReviewing = false;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Review Investment",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                ] else ...[
                  const SizedBox(width: 24), // Balances close button on right
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Segmented Three-Tab Selector
          if (!_isReviewing) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    // Tab 0: Monthly SIP
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(9),
                        onTap: () => _switchTab(0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _activeTabIndex == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _activeTabIndex == 0
                                ? const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.repeat_rounded,
                                size: 14,
                                color: _activeTabIndex == 0
                                    ? Ucolors.primary
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Monthly SIP",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: _activeTabIndex == 0
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: _activeTabIndex == 0
                                      ? Ucolors.primary
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    // Tab 1: One-Time Lumpsum
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(9),
                        onTap: () => _switchTab(1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _activeTabIndex == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _activeTabIndex == 1
                                ? const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flash_on_rounded,
                                size: 14,
                                color: _activeTabIndex == 1
                                    ? Ucolors.primary
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Lumpsum",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: _activeTabIndex == 1
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: _activeTabIndex == 1
                                      ? Ucolors.primary
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    // Tab 2: Link from Portfolio
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(9),
                        onTap: () => _switchTab(2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _activeTabIndex == 2
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: _activeTabIndex == 2
                                ? const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.wallet_3,
                                size: 14,
                                color: _activeTabIndex == 2
                                    ? Ucolors.primary
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "From Portfolio",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: _activeTabIndex == 2
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: _activeTabIndex == 2
                                      ? Ucolors.primary
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Main Tab Content Area
          Expanded(
            child: _activeTabIndex == 2
                ? GoalPortfolioLinkTab(
                    goalId: widget.goalId,
                    goal: widget.goal,
                    liveDetail: widget.liveDetail,
                  )
                : (_isReviewing
                      ? _buildReviewPlanContent(selectedFunds)
                      : _buildInvestNewFundsTab()),
          ),

          // Bottom Bar (Tab 0 & Tab 1)
          if (_activeTabIndex != 2)
            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${_selectedSchemeCodes.length} Fund(s) Selected",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₹${totalAmount.toStringAsFixed(0)}${_getFrequencyAmountSuffix(selectedFunds)}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed:
                          _isSubmitting ||
                              _selectedSchemeCodes.isEmpty ||
                              _hasInvalidAmounts()
                          ? null
                          : () {
                              if (!_isReviewing) {
                                // Transition to Review Screen
                                setState(() {
                                  _isReviewing = true;
                                });
                              } else {
                                // Check if mandate setup is needed
                                if (_isMandateNeededForSelectedMethod()) {
                                  _navigateToMandateSetup();
                                } else {
                                  _executePayment();
                                }
                              }
                            },
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              !_isReviewing
                                  ? "Review & Pay ›"
                                  : (_isMandateNeededForSelectedMethod()
                                        ? "Set Up Auto Pay"
                                        : (_isLumpsum
                                              ? "Pay ₹${totalAmount.toStringAsFixed(0)}"
                                              : "Pay ₹${totalAmount.toStringAsFixed(0)}${_getFrequencyAmountSuffix(selectedFunds)}")),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Tab 0 & Tab 1: Invest New Funds View ──
  Widget _buildInvestNewFundsTab() {
    return Column(
      children: [
        // Search & Filter Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Search Bar (Expanded for maximum typing comfort)
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      _mutualController.onSearchQueryChanged(val);
                      setState(() {});
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Search mutual funds, AMCs...",
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: const Icon(
                        Iconsax.search_normal,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                _searchController.clear();
                                _mutualController.onSearchQueryChanged('');
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Filter Button (opens Filterpage like Explore)
              Obx(() {
                final fundController = Get.isRegistered<FundhouseController>()
                    ? Get.find<FundhouseController>()
                    : null;
                final int filterCount = fundController?.activeFilterCount ?? 0;

                return Badge(
                  isLabelVisible: filterCount > 0,
                  backgroundColor: Ucolors.primary,
                  label: Text(
                    '$filterCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: const Alignment(0.7, -0.7),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: filterCount > 0
                            ? Ucolors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune_rounded,
                        size: 19,
                        color: filterCount > 0
                            ? Ucolors.primary
                            : const Color(0xFF475569),
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        final result = await Get.toNamed(AppRoutes.filterpage);
                        if (result != null && result is Map<String, dynamic>) {
                          _mutualController.applyFilters(result);
                        }
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Quick Category Filter & Sort Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Integrated Sort Pill (Cycles 1Y, 3Y, 5Y)
              Obx(() {
                final sortLabel = _mutualController.currentSortLabel.value;
                final isCustomSort = sortLabel != "1Y,3Y,5Y";
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _mutualController.cycleGlobalSort(),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isCustomSort
                          ? Ucolors.primary.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCustomSort
                            ? Ucolors.primary
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 15,
                          color: isCustomSort
                              ? Ucolors.primary
                              : const Color(0xFF475569),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          sortLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCustomSort
                                ? Ucolors.primary
                                : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(width: 6),

              // Category Filter Pills
              ...['All', 'Equity', 'Debt', 'Hybrid', 'Index'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                      if (cat == 'All') {
                        _mutualController.applyFilters({
                          'scheme_category': 'All',
                        });
                      } else {
                        _mutualController.applyFilters({
                          'scheme_category': cat,
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Ucolors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Ucolors.primary
                              : const Color(0xFFCBD5E1),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Ucolors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Funds List
        Expanded(
          child: Obx(() {
            if (_mutualController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Ucolors.primary),
              );
            }

            final fundsList = _mutualController.searchFund;

            if (fundsList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.search_status,
                      size: 36,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No Matching Funds Found",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Try changing your search or filter options",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final int itemCount =
                fundsList.length +
                (_mutualController.isMoreLoading.value ? 1 : 0);

            return ListView.separated(
              controller: _fundsScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == fundsList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Ucolors.primary,
                        ),
                      ),
                    ),
                  );
                }

                final fund = fundsList[index];
                final schemeCode = fund.schemeCode?.toString() ?? '';
                final isSelected = _selectedSchemeCodes.contains(schemeCode);
                final name = fund.baseSchemeName ?? 'Unknown Fund';
                final logoUrl = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
                final activeSort = _mutualController.currentSortLabel.value;
                final String returnLabel;
                final String returnVal;
                switch (activeSort) {
                  case '1Y':
                    returnLabel = '1Y';
                    returnVal = fund.returnsEntity?.oneYear ?? '0';
                    break;
                  case '5Y':
                    returnLabel = '5Y';
                    returnVal = fund.returnsEntity?.fiveYear ?? '0';
                    break;
                  case '3Y':
                  default:
                    returnLabel = '3Y';
                    returnVal = fund.returnsEntity?.threeYear ?? '0';
                    break;
                }
                final double retNum = double.tryParse(returnVal) ?? 0.0;
                final minAllowed = _getMinAmountForFund(fund);
                final amountCtrl = _getControllerForScheme(
                  schemeCode,
                  minAllowed,
                );

                void toggleSelection() {
                  setState(() {
                    if (isSelected) {
                      _selectedSchemeCodes.remove(schemeCode);
                      _selectedFundsMap.remove(schemeCode);
                    } else {
                      _selectedSchemeCodes.add(schemeCode);
                      _selectedFundsMap[schemeCode] = fund;
                      final currentMin = _getMinAmountForFund(fund);
                      final ctrl = _getControllerForScheme(
                        schemeCode,
                        currentMin,
                      );
                      ctrl.text = currentMin.toString();
                    }
                  });
                }

                final amountErr = isSelected ? _getFundAmountError(fund) : null;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isSelected ? null : toggleSelection,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFAF9FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Ucolors.primary
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Ucolors.primary.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row: Checkbox, AMC Logo, Name, Returns
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: toggleSelection,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomCachedImage(
                                  imageUrl: logoUrl,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          "$returnLabel: $returnVal%",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: retNum < 0
                                                ? Colors.red
                                                : Ucolors.success,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            "•  Min ${_isLumpsum ? 'Lumpsum' : 'SIP'} : ₹$minAllowed",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Ucolors.primary
                                      : Colors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? Ucolors.primary
                                        : const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),

                        // When Selected: Frequency Pill + Amount Input & Quick Chips
                        if (isSelected) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Frequency Pill for SIP (Tab 0)
                                  if (!_isLumpsum)
                                    InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () =>
                                          _openFrequencyMenu(context, fund),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3EFFF),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFDDD6FE),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.repeat_rounded,
                                              size: 13,
                                              color: Ucolors.primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _getFrequencyDisplayLabel(fund),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Ucolors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 14,
                                              color: Ucolors.primary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    const Text(
                                      "Investment Amount:",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),

                                  // Amount Input Box
                                  Container(
                                    width: 130,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: amountErr != null
                                            ? Colors.red.shade400
                                            : const Color(0xFFE2E8F0),
                                        width: 1.0,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      controller: amountCtrl,
                                      keyboardType: TextInputType.number,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: amountErr != null
                                            ? Colors.red.shade700
                                            : const Color(0xFF1E293B),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                      decoration: InputDecoration(
                                        prefixText: "₹ ",
                                        prefixStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: amountErr != null
                                              ? Colors.red.shade700
                                              : const Color(0xFF1E293B),
                                        ),
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 7,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (amountErr != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                    bottom: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 13,
                                        color: Colors.red.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          amountErr,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Quick increment chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [500, 1000, 2000, 5000].map((step) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      final current =
                                          int.tryParse(amountCtrl.text) ?? 0;
                                      final updated =
                                          (current < minAllowed
                                              ? minAllowed
                                              : current) +
                                          step;
                                      amountCtrl.text = updated.toString();
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        "+₹$step",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // ── Review Plan & Payment Options View ──
  Widget _buildReviewPlanContent(List<MutualFundListEntity> selected) {
    final double totalAmount = _calculateTotalAmount();
    final isLumpsum = _isLumpsum;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Amount to Pay / Investment Summary Card ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isLumpsum ? "TOTAL PAYABLE" : "TOTAL SIP INSTALLMENT",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EFFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${selected.length} ${selected.length == 1 ? 'Fund' : 'Funds'}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Ucolors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${totalAmount.toStringAsFixed(0)}${_getFrequencyAmountSuffix(selected)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 10),
                const Text(
                  "FUNDS BREAKDOWN",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                ...selected.map((f) {
                  final schemeCode = f.schemeCode?.toString() ?? '';
                  final ctrl = _amountControllers[schemeCode];
                  final amt = double.tryParse(ctrl?.text ?? '0') ?? 0.0;
                  final freqLabel = _getFrequencyDisplayLabel(f);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.baseSchemeName ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isLumpsum) ...[
                                const SizedBox(height: 3),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3EFFF),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    freqLabel,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Ucolors.primary,
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
                              "₹${amt.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            if (!isLumpsum)
                              Text(
                                _getFundAmountSuffix(f),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
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

          const SizedBox(height: 16),

          // ── 2. Investment Bank Selection ──
          const Text(
            "INVESTMENT BANK",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          CheckoutBankCard(isLumpsum: isLumpsum),

          const SizedBox(height: 16),

          // ── 3. Payment Method & Mandate Section ──
          Obx(() {
            final personalisationCtrl =
                Get.isRegistered<PersonalisationController>()
                ? Get.find<PersonalisationController>()
                : null;
            final mfuCtrl = _mfuController;
            final bank = personalisationCtrl?.activeCheckoutBank;
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
                ((selectedMethod == 'netbanking' ||
                        selectedMethod == 'enach') &&
                    hasActiveEnachMandate);

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isLumpsum
                            ? "CHOOSE PAYMENT METHOD"
                            : "PAY AUTOMATICALLY WITH",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Color(0xFF64748B),
                        ),
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
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),

                  // Option 1: UPI / UPI AutoPay
                  _buildPaymentOption(
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

                  const SizedBox(height: 10),

                  // Option 2: NetBanking / Bank e-Mandate
                  _buildPaymentOption(
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

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String method,
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    bool isSuccessBadge = false,
    VoidCallback? onSetupTap,
  }) {
    return Obx(() {
      final isSelected = _mfuController.selectedMethod.value == method;
      return InkWell(
        onTap: () => _mfuController.selectMethod(method),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF3F0FF)
                : const Color(0xFFF8FAFC),
            border: Border.all(
              color: isSelected ? Ucolors.primary : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Ucolors.primary
                        : const Color(0xFFCBD5E1),
                    width: isSelected ? 6 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Ucolors.primary.withValues(alpha: 0.12)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Ucolors.primary : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (badgeText != null)
                          GestureDetector(
                            onTap: onSetupTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
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
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
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
