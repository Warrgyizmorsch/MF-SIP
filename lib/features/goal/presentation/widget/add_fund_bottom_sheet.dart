import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:my_sip/features/goal/domain/entity/single_goal_detail_entity.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/core/utils/helper/purchase_scenario.dart';
import 'package:my_sip/features/mfu/data/model/lumpsum_req_model.dart';
import 'package:my_sip/features/mfu/data/model/sip_req_model.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';

class AddFundBottomSheet extends StatefulWidget {
  final int goalId;
  final UserGoalEntity? goal;
  final SingleGoalDetailEntity? liveDetail;

  const AddFundBottomSheet({
    super.key,
    required this.goalId,
    this.goal,
    this.liveDetail,
  });

  static Future<void> show(
    BuildContext context, {
    required int goalId,
    UserGoalEntity? goal,
    SingleGoalDetailEntity? liveDetail,
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
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
            child: AddFundBottomSheet(
              goalId: goalId,
              goal: goal,
              liveDetail: liveDetail,
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
        ),
      );
    }
  }

  @override
  State<AddFundBottomSheet> createState() => _AddFundBottomSheetState();
}

class _AddFundBottomSheetState extends State<AddFundBottomSheet> {
  int _activeTabIndex = 0; // 0 = Monthly SIP, 1 = One-Time Lumpsum, 2 = Link from Portfolio
  String _selectedCategory = 'Equity';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _fundsScrollController = ScrollController();
  final Map<String, TextEditingController> _amountControllers = {};
  final Set<String> _selectedSchemeCodes = {};
  final Map<String, MutualFundListEntity> _selectedFundsMap = {};
  bool _isSubmitting = false;

  final GoalSipController _goalController = Get.find<GoalSipController>();
  final MutualFundController _mutualController =
      Get.find<MutualFundController>();
  final MfuController _mfuController = Get.find<MfuController>();

  DashboardController? get _dashboardController =>
      Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : null;

  @override
  void initState() {
    super.initState();
    final initialIsLumpsum =
        (widget.goal?.txnType.toLowerCase() == 'lumpsum') ||
        (_goalController.savedInvestmentType.value == 'lumpsum');
    _activeTabIndex = initialIsLumpsum ? 1 : 0;

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
    if (_dashboardController != null &&
        _dashboardController!.portfolioData.value == null) {
      _dashboardController!.getPortfolio();
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
      // If switching between SIP (0) and Lumpsum (1), auto-adjust any amount that is below the new minimum
      if (newIndex == 0 || newIndex == 1) {
        for (final schemeCode in _selectedSchemeCodes) {
          final fund = _selectedFundsMap[schemeCode];
          if (fund != null) {
            final newMin = _getMinAmountForFund(fund);
            final ctrl = _amountControllers[schemeCode];
            if (ctrl != null) {
              final currentVal = double.tryParse(ctrl.text) ?? 0.0;
              if (currentVal < newMin) {
                ctrl.text = newMin.toString();
              }
            }
          }
        }
      }
    });
  }

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

  bool _hasInvalidAmounts() {
    for (final schemeCode in _selectedSchemeCodes) {
      final fund = _selectedFundsMap[schemeCode];
      if (fund != null) {
        final minAllowed = _getMinAmountForFund(fund);
        final ctrl = _amountControllers[schemeCode];
        final amount = double.tryParse(ctrl?.text ?? '0') ?? 0.0;
        if (amount < minAllowed) {
          return true;
        }
      }
    }
    return false;
  }

  TextEditingController _getControllerForScheme(
    String schemeCode,
    int? defaultMin,
  ) {
    if (!_amountControllers.containsKey(schemeCode)) {
      final initialAmount = (defaultMin != null && defaultMin > 0)
          ? defaultMin
          : 1000;
      _amountControllers[schemeCode] = TextEditingController(
        text: initialAmount.toString(),
      );
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

  Future<void> _handleInvest() async {
    if (_selectedSchemeCodes.isEmpty) {
      Get.snackbar(
        "Select Funds",
        "Please select at least one fund to invest in.",
      );
      return;
    }

    final selectedFunds = _selectedFundsMap.values.toList();

    if (selectedFunds.isEmpty) {
      Get.snackbar("Error", "Selected funds not found.");
      return;
    }

    // Verify all selected funds meet minimum amount requirement
    for (final fund in selectedFunds) {
      final schemeCode = fund.schemeCode?.toString() ?? '';
      final minAllowed = _getMinAmountForFund(fund);
      final amount =
          double.tryParse(_amountControllers[schemeCode]?.text ?? '0') ?? 0.0;
      if (amount < minAllowed) {
        Get.snackbar(
          "Invalid Amount",
          "Minimum ${_isLumpsum ? 'Lumpsum' : 'SIP'} amount for ${fund.baseSchemeName ?? 'selected fund'} is ₹$minAllowed",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }
    }

    final isLumpsum = _isLumpsum;

    GatekeeperHelper.runWithPrerequisites(
      isLumpsum: isLumpsum,
      onSuccess: () async {
        setState(() {
          _isSubmitting = true;
        });

        try {
          // Note: Funds are now directly associated with the goal via the goal_id parameter in postLumpsum/postSip.
          // _goalController.saveGoalFund(...) is kept in the codebase for reference/backward compatibility.

          // 2. Fire MFU Transaction (Latest postLumpsum and postSip APIs with goal_id)
          if (isLumpsum) {
            final List<LumpsumFundItemModel> lumpsumFunds = [];
            for (final fund in selectedFunds) {
              final schemeCode = fund.schemeCode?.toString() ?? '';
              final amount =
                  double.tryParse(_amountControllers[schemeCode]?.text ?? '0') ??
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
                  double.tryParse(_amountControllers[schemeCode]?.text ?? '0') ??
                  0.0;
              if (schemeCode.isNotEmpty && amount > 0) {
                sipFunds.add(
                  SipFundItemModel(
                    schemeCode: schemeCode,
                    amount: amount,
                    folio: "NEW",
                    frequency: "M",
                    day: "10",
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

          // Close bottom sheet and refresh
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
    final live = widget.liveDetail;
    final fallbackGoal = widget.goal;

    final String goalName = live?.goalName.isNotEmpty == true
        ? live!.goalName
        : (fallbackGoal?.goalName ?? 'My Goal');

    final double targetAmount = (live?.targetAmount ?? 0) > 0
        ? live!.targetAmount
        : (fallbackGoal?.targetAmount ?? 0).toDouble();

    final double savedAmount =
        live?.savedAmount ?? (fallbackGoal?.investedAmount ?? 0.0);

    final double remainingAmount = (live?.remainingAmount ?? 0) > 0
        ? live!.remainingAmount
        : (targetAmount - savedAmount > 0 ? targetAmount - savedAmount : 0.0);

    final double progressFraction = targetAmount > 0
        ? (savedAmount / targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final int progressPercent = (progressFraction * 100).round();

    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final maxHeight = mediaQuery.size.height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header: Goal Summary & Close
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.flag_rounded,
                          color: Color(0xFF2563EB),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goalName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "Target: ₹${targetAmount.toStringAsFixed(0)} • Remaining: ₹${remainingAmount.toStringAsFixed(0)}",
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
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$progressPercent% Completed",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Text(
                      "Invested: ₹${savedAmount.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressFraction >= 1.0
                          ? const Color(0xFF16A34A)
                          : Ucolors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Segmented Three-Tab Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Tab 0: Monthly SIP
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: () => _switchTab(0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _activeTabIndex == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: _activeTabIndex == 0
                              ? const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
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
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Monthly SIP",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: _activeTabIndex == 0
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _activeTabIndex == 0
                                    ? Ucolors.primary
                                    : Colors.grey.shade600,
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _activeTabIndex == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: _activeTabIndex == 1
                              ? const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
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
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Lumpsum",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: _activeTabIndex == 1
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _activeTabIndex == 1
                                    ? Ucolors.primary
                                    : Colors.grey.shade600,
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _activeTabIndex == 2
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: _activeTabIndex == 2
                              ? const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
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
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "From Portfolio",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: _activeTabIndex == 2
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _activeTabIndex == 2
                                    ? Ucolors.primary
                                    : Colors.grey.shade600,
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

          const SizedBox(height: 10),

          // Tab Content Area
          Expanded(
            child: _activeTabIndex != 2
                ? _buildInvestNewFundsTab()
                : _buildLinkPortfolioTab(),
          ),

          // Bottom Bar for Invest (Tab 0 & Tab 1)
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
                        "₹${_calculateTotalAmount().toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 18,
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
                              : _handleInvest,
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
                              _isLumpsum
                                  ? "Invest Lumpsum"
                                  : "Start Monthly SIP",
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

  /// ── Tab 0 & Tab 1: Invest New Funds View ──
  Widget _buildInvestNewFundsTab() {
    return Column(
      children: [
        // Search & Filter Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
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
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        size: 20,
                        color: Color(0xFF475569),
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

              const SizedBox(width: 8),

              // Search Bar (calls backend search API)
              Expanded(
                child: Container(
                  height: 42,
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
                      hintText: "Search mutual funds...",
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Sort Toggle Chip (1Y, 3Y, 5Y cycle like Explore page)
              Obx(
                () => InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _mutualController.cycleGlobalSort(),
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: _mutualController.currentSortLabel.value !=
                              "1Y,3Y,5Y"
                          ? Ucolors.primary.withValues(alpha: 0.1)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _mutualController.currentSortLabel.value !=
                                "1Y,3Y,5Y"
                            ? Ucolors.primary
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sort_rounded,
                          size: 16,
                          color: _mutualController.currentSortLabel.value !=
                                  "1Y,3Y,5Y"
                              ? Ucolors.primary
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _mutualController.currentSortLabel.value,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _mutualController.currentSortLabel.value !=
                                    "1Y,3Y,5Y"
                                ? Ucolors.primary
                                : const Color(0xFF475569),
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

        const SizedBox(height: 8),

        // Quick Category Filter Chips (syncs with API via applyFilters)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: ['All', 'Equity', 'Debt', 'Hybrid', 'Index'].map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat;
                    });
                    if (cat == 'All') {
                      _mutualController.applyFilters({'scheme_category': 'All'});
                    } else {
                      _mutualController.applyFilters({'scheme_category': cat});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Ucolors.primary
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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

            final int itemCount = fundsList.length +
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
                final threeYear = fund.returnsEntity?.threeYear ?? '0';
                final minAllowed = _getMinAmountForFund(fund);
                final sipMin =
                    (fund.minSipAmount != null && fund.minSipAmount! > 0)
                        ? fund.minSipAmount!
                        : 500;
                final lumpMin = (fund.minLumpsum != null && fund.minLumpsum! > 0)
                    ? fund.minLumpsum!
                    : 1000;
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
                    }
                  });
                }

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isSelected ? null : toggleSelection,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
                          blurRadius: 6,
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
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 22,
                                height: 22,
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
                              const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomCachedImage(
                              imageUrl: logoUrl,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      fund.schemeType ?? '',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "3Y: $threeYear%",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Ucolors.success,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "• Min Lumpsum: ₹$lumpMin",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // When Selected: Amount Input & Quick Chips
                      if (isSelected) ...[
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final currentAmount =
                                double.tryParse(amountCtrl.text) ?? 0.0;
                            final isAmountBelowMin = currentAmount < minAllowed;
                            final modeLabel = _isLumpsum ? 'Lumpsum' : 'SIP';

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Amount:",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SizedBox(
                                        height: 34,
                                        child: TextFormField(
                                          controller: amountCtrl,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isAmountBelowMin
                                                ? Colors.red.shade700
                                                : const Color(0xFF1E293B),
                                          ),
                                          onChanged: (_) => setState(() {}),
                                          decoration: InputDecoration(
                                            prefixText: "₹ ",
                                            prefixStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: isAmountBelowMin
                                                  ? Colors.red.shade700
                                                  : const Color(0xFF1E293B),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 0,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isAmountBelowMin
                                                    ? Colors.red.shade400
                                                    : const Color(0xFFCBD5E1),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isAmountBelowMin
                                                    ? Colors.red.shade400
                                                    : const Color(0xFFCBD5E1),
                                                width:
                                                    isAmountBelowMin ? 1.5 : 1.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isAmountBelowMin
                                                    ? Colors.red.shade600
                                                    : Ucolors.primary,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isAmountBelowMin
                                            ? Icons.error_outline
                                            : Icons.info_outline,
                                        size: 13,
                                        color: isAmountBelowMin
                                            ? Colors.red.shade600
                                            : Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isAmountBelowMin
                                            ? "Minimum $modeLabel amount is ₹$minAllowed"
                                            : "Min SIP: ₹$sipMin  •  Min Lumpsum: ₹$lumpMin",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: isAmountBelowMin
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isAmountBelowMin
                                              ? Colors.red.shade700
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        // Quick increment chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [500, 1000, 2000, 5000].map((step) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    final current =
                                        int.tryParse(amountCtrl.text) ?? 0;
                                    final updated =
                                        (current < minAllowed ? minAllowed : current) +
                                            step;
                                    amountCtrl.text = updated.toString();
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFFBFDBFE),
                                      ),
                                    ),
                                    child: Text(
                                      "+₹$step",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1D4ED8),
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

  /// ── Tab 1: Link from Portfolio View ──
  Widget _buildLinkPortfolioTab() {
    if (_dashboardController == null) {
      return const Center(
        child: Text(
          "Portfolio is not initialized",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Obx(() {
      if (_dashboardController!.isLoadingPortfolio.value) {
        return const Center(
          child: CircularProgressIndicator(color: Ucolors.primary),
        );
      }

      final portfolio =
          _dashboardController!.portfolioData.value?.portfolio ?? [];
      final currentGoalId = widget.goalId;
      final allGoals = _goalController.goalResponse.value?.data ?? [];

      final unlinkedFunds = portfolio.where((item) {
        // 1 fund can only be linked to 1 goal.
        // 1. If holding is already linked to any goal directly
        if (item.goalId != null && item.goalId! > 0) return false;
        if (item.goalName != null && item.goalName!.trim().isNotEmpty) {
          return false;
        }

        // 2. Check if this scheme is already linked to any goal
        final isLinkedToAnyGoal = allGoals.any(
          (g) => g.goalFunds.any((gf) => gf.schemeCode == item.schemeCode),
        );
        if (isLinkedToAnyGoal) return false;

        final isLinkedToLiveDetail = widget.liveDetail?.linkedFunds.any(
              (lf) => lf.schemeCode == item.schemeCode,
            ) ??
            false;
        if (isLinkedToLiveDetail) return false;

        final isLinkedToGoal = widget.goal?.goalFunds.any(
              (gf) => gf.schemeCode == item.schemeCode,
            ) ??
            false;
        if (isLinkedToGoal) return false;

        return true;
      }).toList();

      if (unlinkedFunds.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.wallet_3,
                    size: 32,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "No Available Holdings to Link",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "All your portfolio holdings are already linked to goals or you have no active investments.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: unlinkedFunds.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = unlinkedFunds[index];
          final bool isLinking =
              _goalController.linkingFundMap[item.mfuOrderId] ?? false;

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.amcLogo.isNotEmpty
                      ? CustomCachedImage(
                          imageUrl: item.amcLogo,
                          size: 36,
                        )
                      : Container(
                          width: 36,
                          height: 36,
                          color: const Color(0xFFEFF6FF),
                          child: const Icon(
                            Icons.account_balance,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.fundName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.investmentType.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Val: ₹${item.currentValue.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Ucolors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLinking
                        ? null
                        : () async {
                            if (item.mfuOrderId == null) {
                              Get.snackbar(
                                "Error",
                                "Order ID missing for this holding",
                              );
                              return;
                            }
                            await _goalController.linkFundToGoal(
                              goalId: currentGoalId,
                              mfuOrderId: item.mfuOrderId!,
                              goalName:
                                  widget.liveDetail?.goalName ??
                                  widget.goal?.goalName,
                            );
                            await _dashboardController?.getPortfolio();
                            await _goalController.fetchSingleGoal(
                              currentGoalId,
                            );
                            await _goalController.getAllGoals();
                          },
                    child: isLinking
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Link",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
