// ignore_for_file: dead_null_aware_expression, dead_code
// ignore_for_file: dead_null_aware_expression, dead_code

import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../common/widget/appbar/widget/compact_icon.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../common/widget/table/table_header.dart';
import '../../../../common/widget/text/view_all.dart';
import '../../../../common/widget/text_form/custom_text_field.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../explore/presentation/controller/fundhouse_controller.dart';
import '../../../explore/presentation/controller/mutual_fund_controller.dart';
import '../../../explore/presentation/pages/explore.dart';
import '../../../fund_details/data/models/return_model.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../fund_details/presentation/widgets/return.dart';
import '../../../home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import '../../../sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../domain/entity/goal_entity.dart';
import '../controller/goal_sip_controller.dart';

class UnifiedGoalDashboard extends GetView<GoalSipController> {
  UnifiedGoalDashboard({super.key});

  final GlobalKey popularFundsKey = GlobalKey();

  IconData getGoalIcon(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'house':
        return Icons.home_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'marriage':
        return Icons.favorite_rounded;
      case 'retirement':
        return Icons.elderly_rounded;
      case 'vacation':
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  static Map<String, dynamic>? tempArgs;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final ScrollController _scrollController = ScrollController();

    // Reactive visibility indicators safely declared at build container setup
    final RxBool showLeftArrow = false.obs;
    final RxBool showRightArrow = true.obs;

    void scrollWithArrow(bool scrollRight) {
      final double targetOffset = scrollRight
          ? _scrollController.offset + 220
          : _scrollController.offset - 220;

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return GetBuilder<GoalSipController>(
    initState: (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        controller.isHome.value = false;
        controller.selectedPopularFund.clear();

        _scrollController.addListener(() {
          if (!_scrollController.hasClients) return;
          showLeftArrow.value = _scrollController.offset > 10;
          showRightArrow.value = _scrollController.offset < (_scrollController.position.maxScrollExtent - 10);
        });

        await controller.initializeDashboardData();

        final args = (Get.arguments as Map<String, dynamic>?) ?? tempArgs;
        tempArgs = null;

        if (args == null) {
          controller.update(); // Trigger safe rebuild if no arguments
          return;
        }

        final String initialType = args['goalType'] ?? 'custom';
        controller.isEdit.value = args['isEdit'] ?? false;
        controller.isHome.value = args['isHome'] ?? false;

        final UserGoalEntity? goal = args['goal'];

        if (!controller.isEdit.value) {
          controller.resetStateForNewGoal();
        }

        controller.updateGoalType(initialType);

        // EDIT GOAL
        if (controller.isEdit.value && goal != null) {
          controller.loadGoalForEdit(goal);
        }
        if (controller.isAddFund.value && goal != null) {
          controller.loadGoalForAddFund(goal);
        }

        // HOME GOAL
        if (controller.isHome.value) {
          final masterGoal = controller.masterGoals.firstWhereOrNull(
                (e) => e.goalType == initialType,
          );
          if (masterGoal != null) {
            controller.handleHomeGoal(masterGoal);
          }
        }

        // Safe to request layout refresh now that current frame is rendered
        controller.update();
      });
    },
    builder: (controller) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool canPopScope = false;

            return PopScope(
              canPop: canPopScope,
              onPopInvokedWithResult: (didPop, result) async {
                if (didPop) return;

                final currentGoal = controller.goalResponse.value?.data
                    .firstWhereOrNull(
                      (e) => e.goalId == controller.savedDatabaseId.value,
                );

                bool needsWarning =
                    currentGoal?.status == "pending" ||
                        currentGoal?.status == null ||
                        !controller.isGoalSaved.value ||
                        currentGoal?.mfuOrderStatus == "not_ordered" ||
                        currentGoal?.mfuOrderStatus == null;

                if (needsWarning) {
                  final shouldLeave = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text("Discard Changes?"),
                      content: const Text(
                        "Your goal is not saved yet. Do you want to leave this page?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text(
                            "Stay",
                            style: TextStyle( fontFamily:FontFamily.regular,color: Ucolors.primary),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text(
                            "Leave",
                            style: TextStyle( fontFamily:FontFamily.regular,color: Ucolors.primary),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldLeave == true) {
                    setState(() => canPopScope = true);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                    });
                  }
                  return;
                }

                setState(() => canPopScope = true);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
              },
              child: Scaffold(
                backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Ucolors.light,
                appBar: CustomAppBarNormal(
                  backgroundColor: Ucolors.light,
                  title: 'Goals',
                  backIcon: true,
                  actionsPadding: 10,
                  action: [
                    CompactIcon(icon: Iconsax.info_circle, onPressed: () {}),
                  ],
                ),
                body: Column(
                  children: [
                    Obx(() {
                      if (controller.isMasterGoalLoading.value  ) {
                        return const SizedBox(
                          height: 140,
                          child: Center(
                            child: CircularProgressIndicator(color: Ucolors.primary),
                          ),
                        );
                      }

                      if (controller.masterGoals.isEmpty || controller.isGoalSaved.value || controller.isAddFund.value == true) {
                        return const SizedBox.shrink();
                      }

                      return Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 150,
                            margin: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Listener(
                              onPointerSignal: (pointerSignal) {
                                if (pointerSignal is PointerScrollEvent) {
                                  final double newOffset = _scrollController.offset + pointerSignal.scrollDelta.dy;
                                  _scrollController.animateTo(
                                    newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    PointerDeviceKind.touch,
                                    PointerDeviceKind.mouse,
                                    PointerDeviceKind.trackpad,
                                  },
                                ),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.masterGoals.length,
                                  itemBuilder: (context, index) {
                                    final goal = controller.masterGoals[index];
                                    final isSelected = controller.selectedGoalIndex.value == index;

                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () async {
                                          controller.selectedGoalIndex.value = index;
                                          controller.isGoalSaved.value = false;
                                          controller.goalId.value = goal.id;
                                          controller.selectedGoalType.value = goal.goalType;

                                          final goalType = goal.goalType.toLowerCase() ?? '';
                                          if (!['custom', 'other'].contains(goalType)) {
                                            controller.goalNameTextEditingController.text = goal.goalType;
                                          }

                                          controller.setTarget(goal.targetAmount);
                                          controller.setYears(goal.goalTenure.toDouble());
                                          controller.setRate(goal.expectedReturnRate);

                                          final double r = goal.expectedReturnRate / 100;
                                          final int n = goal.goalTenure.toInt();
                                          final double pv = goal.targetAmount / pow(1 + r, n);

                                          controller.lumpsumAmount.value = controller.smartRoundOff(pv);
                                          controller.lumpsumFutureValue.value = goal.targetAmount;
                                          controller.lumpsumTotalReturn.value = goal.targetAmount - pv;

                                          controller.update();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          width: 200,
                                          margin: const EdgeInsets.only(right: 16, bottom: 8),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? controller.getGoalColor(goal.goalType).withValues(alpha: 0.05)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: isSelected
                                                  ? controller.getGoalColor(goal.goalType)
                                                  : Colors.grey.shade200,
                                              width: isSelected ? 1.5 : 1.0,
                                            ),
                                            boxShadow: [
                                              if (!isSelected)
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.02),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    getGoalIcon(goal.goalType),
                                                    color: controller.getGoalColor(goal.goalType),
                                                    size: 24,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      goal.goalType.capitalizeFirst ?? '',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontFamily: FontFamily.medium,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    isSelected
                                                        ? Icons.check_circle_rounded
                                                        : Icons.radio_button_unchecked_rounded,
                                                    color: isSelected
                                                        ? controller.getGoalColor(goal.goalType)
                                                        : Colors.grey.shade300,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "Target Amount",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.medium,
                                                            fontSize: 11,
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          formatCurrency(goal.targetAmount),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontFamily: FontFamily.medium,
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.schedule_rounded,
                                                        size: 14,
                                                        color: Colors.grey.shade400,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "${goal.goalTenure} Yrs",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily.medium,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.grey.shade700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          if (showLeftArrow.value)
                            Positioned(
                              left: 12,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.chevron_left_rounded, size: 28, color: Colors.black87),
                                  onPressed: () => scrollWithArrow(false),
                                ),
                              ),
                            ),

                          if (showRightArrow.value)
                            Positioned(
                              right: 12,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.chevron_right_rounded, size: 28, color: Colors.black87),
                                  onPressed: () => scrollWithArrow(true),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (controller.isGoalSaved.value || controller.isAddFund.value == true) {
                                        return const SavedGoalDetailsCard();
                                      } else {
                                        return const SIPSectionGoal();
                                      }
                                    }),
                                    const Gap(16),
                                    Obx(() {
                                      final bool isEdit = controller.isEdit.value;
                                      final bool hasChanges = controller.hasChanges.value;
                                      final bool isGoalSaved = controller.isGoalSaved.value;

                                      if (!isGoalSaved || (isEdit && hasChanges)) {
                                        return controller.isSavingGoal.value
                                            ? const Center(child: CircularProgressIndicator(color: Ucolors.primary))
                                            : UElevatedBUtton(
                                          onPressed: () async {
                                            if (isEdit) {
                                              // await controller.updateGoal();
                                            } else {
                                              await controller.saveGoalToDb();
                                              await Get.find<MutualFundController>().fetchData();
                                            }
                                          },
                                          child: Center(
                                            child: Text(
                                              isEdit ? "Update Goal" : "Save Goal",
                                              style: AppTextStyles.bodyMedium(color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }),
                                    const Gap(40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Obx(() {
                                final bool isEdit = controller.isEdit.value;
                                final bool hasChanges = controller.hasChanges.value;
                                final bool isGoalSaved = controller.isGoalSaved.value;

                                if (isGoalSaved || (isEdit && !hasChanges)) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Obx(() {
                                          final selectedCount = controller.selectedPopularFund.length;

                                          return USectionHeading(
                                            key: popularFundsKey,
                                            title: selectedCount > 0 ? 'Selected Funds ($selectedCount)' : 'Popular Funds',
                                            showActionButton: true,
                                            buttonTitle: selectedCount > 0 ? 'Add Funds' : 'Explore All',
                                            onPressed: () {
                                              _showExploreMoreBottomSheet(context);
                                            },
                                          );
                                        }),
                                        const Gap(16),
                                        PopularAndSelectedFund(),
                                        const Gap(20),
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.analytics_outlined, size: 60, color: Colors.grey.shade300),
                                      const Gap(16),
                                      Text(
                                        "Save your goal to unlock insights",
                                        style: TextStyle(fontFamily: FontFamily.medium, fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                                      ),
                                      const Gap(8),
                                      Text(
                                        "Projections and fund selections will appear here.",
                                        style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontFamily:FontFamily.regular,),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Obx(() {
                  if (!controller.isGoalSaved.value) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SafeArea(
                        top: false,
                        child: CartBottomBarWeb(
                          isValid: controller.selectedPopularFund.isNotEmpty,
                          ontap: () async {
                            if (controller.selectedPopularFund.isEmpty ||
                                controller.amountControllers.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please select funds and enter amount to start SIP",
                              );
                              return;
                            }

                            final mutualController = Get.find<MutualFundController>();
                            final mfuController =
                            Get.find<MfuController>();

                            final selectedFunds = mutualController.searchFund
                                .where(
                                  (fund) => controller.selectedPopularFund.contains(
                                fund.baseSchemeName,
                              ),
                            )
                                .toList();

                            final String goalIdString = controller.savedDatabaseId.value
                                .toString();
                            final int? parsedGoalId = int.tryParse(goalIdString);
                            final int? finalGoalId =
                            (parsedGoalId != null && parsedGoalId > 0)
                                ? parsedGoalId
                                : null;



                            controller.isLoading.value = true;

                            try {
                              for (final fund in selectedFunds) {
                                final schemeCode = fund.schemeCode?.toString() ?? '';
                                final amountText = controller
                                    .getAmountController(schemeCode)
                                    .text;
                                final amount = double.tryParse(amountText) ?? 0.0;
                                if (schemeCode.isNotEmpty &&
                                    amount > 0 &&
                                    finalGoalId != null) {
                                  await controller.saveGoalFund(
                                    goalId: finalGoalId,
                                    schemeCode: schemeCode,
                                    schemeName: fund.baseSchemeName ?? '',
                                    sipAmount:
                                    amount,
                                    sipDay:
                                    controller.selectedSipDay.value,
                                  );
                                }
                              }

                              /// Lumpsum Transaction
                              if (controller.savedInvestmentType.value == 'lumpsum') {
                                List<MfuTxnScheme> lumpsumSchemes = [];

                                for (final fund in selectedFunds) {
                                  final schemeCode = fund.schemeCode?.toString() ?? '';
                                  final amountText = controller
                                      .getAmountController(schemeCode)
                                      .text;
                                  final amount = double.tryParse(amountText) ?? 0.0;

                                  // Only add if scheme code exists and amount is valid
                                  if (schemeCode.isNotEmpty && amount > 0) {
                                    lumpsumSchemes.add(
                                      MfuTxnScheme(
                                        schemeCode: "012", // static
                                        // schemeCode: schemeCode,
                                        amount: amount,
                                        folio:
                                        "NEW",
                                        divOpt: "N",
                                      ),
                                    );
                                  }
                                }

                                if (lumpsumSchemes.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please enter valid amounts for selected funds.",
                                  );
                                  return;
                                }

                                final uid =
                                    SessionManager.instance.getUserData?.id ?? 0;

                                // 🚀 Fire the Multi-Lumpsum API!
                                mfuController.normalTransaction(
                                  MfuNormalTxnRequest.lumpsumMultiple(
                                    uid: uid,
                                    goalId: finalGoalId,
                                    schemes: lumpsumSchemes,
                                  ),
                                );
                              }
                              /// SIP Transaction
                              else if (controller.savedInvestmentType.value == "sip") {
                                List<MfuSysTxnScheme> sipSchemes = [];
                                for (final fund in selectedFunds) {
                                  final schemeCode = fund.schemeCode?.toString() ?? '';
                                  final amountText = controller
                                      .getAmountController(schemeCode)
                                      .text;
                                  final amount = int.tryParse(amountText) ?? 0;

                                  if (schemeCode.isNotEmpty && amount > 0) {
                                    sipSchemes.add(
                                      MfuSysTxnScheme(
                                        schemeCode: "001",
                                        // schemeCode: schemeCode,
                                        amount: 2000,
                                        // amount: amount,
                                        folio: "NEW",
                                        divOpt: "R", // Default Growth
                                      ),
                                    );
                                  }
                                }

                                // final user = SessionManager.instance.getUserData;
                                final mandateRefNo =
                                    mfuController.mandateStatusResponse.value?.mumrn ??
                                        mfuController.mandateStatusResponse.value?.mmrn ??
                                        '';

                                final now = DateTime.now();
                                // Assuming default 10th of the month for Cart SIPs. Adjust as needed!
                                DateTime startDate = DateTime(
                                  now.year,
                                  now.month + 1,
                                  10,
                                );
                                if (startDate.difference(now).inDays < 30) {
                                  startDate = DateTime(now.year, now.month + 2, 10);
                                }
                                final endDate = DateTime(
                                  startDate.year + 30,
                                  startDate.month,
                                  startDate.day,
                                );

                                mfuController.systematicTransaction(
                                  MfuSystematicTxnRequest.sipMultiple(
                                    uid: 7,
                                    goalId: finalGoalId,
                                    can: "14167AZA01",
                                    frequency: "M",
                                    day: "10",
                                    startMonth: startDate.month.toString().padLeft(
                                      2,
                                      '0',
                                    ),
                                    startYear: startDate.year.toString(),
                                    endMonth: "08",
                                    endYear: "2027",
                                    paymentMode: "DM",
                                    accType: "SB",
                                    accNo: "654321",
                                    ifsc: "ABHY0065002",
                                    micr: "400065002",
                                    mandateRefNo: "PRNUAT001",
                                    schemes:
                                    sipSchemes, // 🚀 Multi-Fund List injected here!
                                  ),
                                );
                              } else {
                                // Your SIP cart logic goes here later
                                Get.snackbar("Info", "Processing SIP Checkout...");
                              }
                            } catch (e) {
                              debugPrint("Transaction Error: $e");
                              Get.snackbar(
                                "Error",
                                "Something went wrong while processing.",
                              );
                            } finally {
                              // 🚀 End Loading State (runs whether it succeeds or fails)
                              controller.isLoading.value = false;
                            }
                          },
                          amount: controller.savedInvestmentType.value == 'lumpsum'
                              ? controller.lumpsumAmount.value.toStringAsFixed(0)
                              : controller.monthlySip.value.toStringAsFixed(0),
                          amountColor: Ucolors.blue,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  void _showExploreMoreBottomSheet(BuildContext context) {
    final mutualController = Get.find<MutualFundController>();
    final goalSipController = Get.find<GoalSipController>();
    final FocusNode searchFocus = FocusNode();
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Align(
          alignment: isDesktop ? Alignment.center : Alignment.center,
          child: Container(
            width: isDesktop ? 450 : double.infinity,
            margin: isDesktop ? const EdgeInsets.only(right: 16, bottom: 16) : EdgeInsets.zero,
            child: DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.96,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: isDesktop ? BorderRadius.circular(24) : const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: isDesktop ? [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10))] : [],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 16),
                          height: 5,
                          width: 48,
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Explore Funds", style: AppTextStyles.h2(color: Ucolors.dark)),
                                const SizedBox(height: 4),
                                Text("Search and select funds for your goal.", style: TextStyle(fontFamily: FontFamily.medium, fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SizedBox(
                          height: 44,
                          child: SearchBar(
                            focusNode: searchFocus,
                            onTap: () => mutualController.setSearchFocus(true),
                            onTapOutside: (event) { searchFocus.unfocus(); mutualController.setSearchFocus(false); },
                            backgroundColor: WidgetStateProperty.all(Colors.grey.shade50),
                            leading: Icon(Icons.search, color: Colors.grey.shade600),
                            hintText: "Search mutual funds...",
                            hintStyle: WidgetStateProperty.all(TextStyle(fontFamily: FontFamily.medium, color: Colors.grey.shade500, fontSize: 14)),
                            elevation: WidgetStateProperty.all(0),
                            side: WidgetStateProperty.all(BorderSide(color: Colors.grey.shade200)),
                            onChanged: (value) => mutualController.onSearchQueryChanged(value),
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey.shade200, height: 20),
                      Expanded(
                        child: Obx(() {
                          if (mutualController.isLoading.value) return const Center(child: CircularProgressIndicator(color: Ucolors.primary));
                          if (mutualController.searchFund.isEmpty) return Center(child: Text("No mutual funds found", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.grey.shade600)));

                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: mutualController.searchFund.length,
                            itemBuilder: (context, index) {
                              final fund = mutualController.searchFund[index];
                              final name = fund.baseSchemeName ?? "Unknown Name";

                              return Obx(() {
                                final isSelected = goalSipController.isSelectedFund(name);

                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      child: MutualFundCard(
                                        entity: fund,
                                        showTrainlings: false,
                                        onTapOverride: () async {
                                          FocusScope.of(context).unfocus();
                                          final isSelected = goalSipController.isSelectedFund(name);

                                          if (!isSelected && goalSipController.savedInvestmentType.value == "sip" && goalSipController.selectedPopularFund.isEmpty) {
                                            final confirmed = await _showSipDateDialog(context, goalSipController);
                                            if (confirmed != true) return;
                                          }

                                          try {
                                            if (goalSipController.savedInvestmentType.value == "lumpsum" || goalSipController.savedInvestmentType.value == "sip") {
                                              goalSipController.showLoading();
                                            }

                                            if (isSelected) {
                                              final goalFundId = goalSipController.getGoalFundId(fund.schemeCode?.toString() ?? '');
                                              if (goalFundId != null) {
                                                await goalSipController.deleteGoalFund(id: goalFundId, isEdit: false, schemeName: fund.schemeCode?.toString() ?? '');
                                                goalSipController.toggleFund(name);
                                                if (goalSipController.selectedPopularFund.isNotEmpty) {
                                                  if (goalSipController.savedInvestmentType.value == "lumpsum") await goalSipController.distributeMonthlyAmount();
                                                  else if (goalSipController.savedInvestmentType.value == "sip") await goalSipController.distributeSipAmount();
                                                }
                                              }
                                              return;
                                            }

                                            goalSipController.toggleFund(name);
                                            if (goalSipController.savedInvestmentType.value == "lumpsum") await goalSipController.distributeMonthlyAmount();
                                            else if (goalSipController.savedInvestmentType.value == "sip") await goalSipController.distributeSipAmount();
                                          } catch (e, stackTrace) {
                                            debugPrintStack(stackTrace: stackTrace);
                                          } finally {
                                            goalSipController.hideLoading();
                                          }
                                        },
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(color: Ucolors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Ucolors.primary, width: 2)),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              });
                            },
                          );
                        }),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: isDesktop ? const BorderRadius.vertical(bottom: Radius.circular(24)) : null, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
                        child: Obx(() {
                          final selectedCount = goalSipController.selectedPopularFund.length;
                          return UElevatedBUtton(
                            onPressed: () => Get.back(),
                            child: Center(child: Text(selectedCount > 0 ? "Add $selectedCount Funds" : "Done", style: AppTextStyles.bodyMedium(color: Colors.white))),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        mutualController.setSearchFocus(false);
        Get.find<FundhouseController>().clearAllFilters();
        mutualController.silentReset();
      });
    });
  }

  Future<bool?> _showSipDateDialog(BuildContext context, GoalSipController controller) {
    RxString selectedSipDay = (controller.selectedSipDay.value).toString().obs;
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Align(
            alignment: isDesktop ? Alignment.bottomRight : Alignment.bottomCenter,
            child: Container(
              width: isDesktop ? 350 : double.infinity,
              margin: isDesktop ? const EdgeInsets.only(right: 30, bottom: 30) : EdgeInsets.zero,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: isDesktop ? BorderRadius.circular(20) : const BorderRadius.vertical(top: Radius.circular(24)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 5))]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Ucolors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Icon(Icons.calendar_month_rounded, color: Ucolors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text("Select SIP Date", style: TextStyle(fontFamily: FontFamily.medium, fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 1.5), borderRadius: BorderRadius.circular(12), color: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSipDay.value,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade600),
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          items: List.generate(28, (i) => DropdownMenuItem(value: '${i + 1}', child: Text('Day ${i + 1} of every month', style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600, fontSize: 15)))),
                          onChanged: (val) {
                            if (val != null) {
                              selectedSipDay.value = val;
                              controller.selectedSipDay.value = int.parse(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300))),
                          child: Text("Cancel", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Ucolors.primary, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Confirm", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleFundInBottomSheet({
    required GoalSipController goalSipController,
    required CartController cartController,
    required dynamic fund,
    required String name,
    required String schemeCodeStr,
    required bool isSelected,
  }) {
    final int? currentGoalId = goalSipController.savedDatabaseId.value;

    if (!isSelected) {
      goalSipController.toggleFund(name);
      cartController.addToCart(title: 'Goal', fund.schemeCode ?? '', name, fund.minSipAmount ?? 0, currentGoalId);
    } else {
      final cartItem = cartController.cartResponseEntity.value?.items.firstWhereOrNull((item) => item.schemeCode.toString() == schemeCodeStr);
      if (cartItem != null && cartItem.id != null) {
        cartController.deleteCartItem(cartItem.id!, name);
        goalSipController.toggleFund(name);
      }
    }
  }
}

class PopularFundCardMobSelected extends StatelessWidget {
  const PopularFundCardMobSelected({super.key, required this.imgPath, required this.name, this.onTap, this.isNetwork = false, this.borderColor = Ucolors.borderColor, this.threeYear, this.tenYear, this.oneYear, this.fiveYear, this.isSelected = false, this.showAmountField = false, this.amountController, this.onAmountSubmitted});
  final Function(String)? onAmountSubmitted;
  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;
  final String? tenYear;
  final String? oneYear;
  final String? fiveYear;
  final bool isSelected;
  final bool showAmountField;
  final TextEditingController? amountController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? Ucolors.primary : Colors.grey.shade100, width: isSelected ? 2 : 1),
            boxShadow: [BoxShadow(color: isSelected ? Ucolors.primary.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.04), blurRadius: isSelected ? 12 : 6, offset: const Offset(0, 3))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: isSelected ? 34 : 30,
                    width: isSelected ? 34 : 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade50, border: isSelected ? Border.all(color: Ucolors.primary, width: 1.5) : null),
                    child: ClipOval(child: isNetwork ? CustomCachedImage(imageUrl: imgPath, size: 40) : Image.asset(imgPath, fit: BoxFit.cover)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: UTextStyles.medium.copyWith(color: Colors.black, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 11, height: 1.1)),
                  ),
                  if (isSelected)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: 1,
                      child: Container(margin: const EdgeInsets.only(left: 4), padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Ucolors.primary, shape: BoxShape.circle), child: const Icon(Icons.check, size: 12, color: Colors.white)),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _returnColumn('1Y', oneYear),
                  if (showAmountField) const Gap(20),
                  _returnColumn('3Y', threeYear),
                  if (!showAmountField) ...[
                    _returnColumn('5Y', fiveYear),
                    _returnColumn('10Y', tenYear),
                  ],
                  if (showAmountField) ...[
                    const Gap(20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SizedBox(
                          height: 36,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: onAmountSubmitted,
                            decoration: InputDecoration(hintText: "Amount", contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _returnColumn(String label, String? value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
          child: Text(label, style: UTextStyles.bodySmallW500.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_drop_up_rounded, color: Ucolors.success, size: 20),
            Text('${value ?? 0}%', style: UTextStyles.bodySmallW500.copyWith(color: Ucolors.success, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class PopularAndSelectedFund extends StatelessWidget {
  PopularAndSelectedFund({super.key});

  final MutualFundController mutualController = Get.find();
  final GoalSipController goalSipController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final allFunds = mutualController.searchFund;
      final selectedFunds = allFunds.where((f) => goalSipController.isSelectedFund(f.baseSchemeName ?? '')).toList();
      final popularFunds = allFunds.where((f) => !goalSipController.isSelectedFund(f.baseSchemeName ?? '')).toList();
      final List<dynamic> displayFunds = selectedFunds.isNotEmpty ? [...selectedFunds, ...popularFunds] : popularFunds.take(15).toList();

      if (displayFunds.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.account_balance_wallet, size: 42, color: Ucolors.primary),
                const SizedBox(height: 12),
                Text("No Funds Available", style: TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600, fontSize: 16, color: Ucolors.dark)),
                const SizedBox(height: 6),
                Text("Please add funds", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.grey.shade600)),
              ],
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          const int crossAxisCount = 2;
          const double spacing = 16;
          final double availableWidth = constraints.maxWidth;
          final double cardWidth = (availableWidth - spacing) / crossAxisCount;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(displayFunds.length, (index) {
              final fund = displayFunds[index];
              final name = fund.baseSchemeName ?? 'Unknown Name';
              final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
              final threeYear = fund.returnsEntity?.threeYear ?? "";
              final oneYear = fund.returnsEntity?.oneYear ?? "";
              final fiveYear = fund.returnsEntity?.fiveYear ?? "";
              final tenYear = fund.returnsEntity?.tenYear ?? "";

              return Obx(() {
                final isSelected = goalSipController.isSelectedFund(name);

                return SizedBox(
                  width: cardWidth,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 250),
                    scale: isSelected ? 1.02 : 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final isSelected = goalSipController.isSelectedFund(name);

                        if (!isSelected && goalSipController.savedInvestmentType.value == "sip" && goalSipController.selectedPopularFund.isEmpty) {
                          final confirmed = await _showSipDateDialog(context, goalSipController);
                          if (confirmed != true) return;
                        }

                        try {
                          if (goalSipController.savedInvestmentType.value == "lumpsum" || goalSipController.savedInvestmentType.value == "sip") {
                            goalSipController.showLoading();
                          }

                          if (isSelected) {
                            final goalFundId = goalSipController.getGoalFundId(fund.schemeCode?.toString() ?? '');
                            if (goalFundId != null) {
                              await goalSipController.deleteGoalFund(id: goalFundId, isEdit: false, schemeName: fund.schemeCode?.toString() ?? '');
                              goalSipController.toggleFund(name);
                              if (goalSipController.selectedPopularFund.isNotEmpty) {
                                if (goalSipController.savedInvestmentType.value == "lumpsum") await goalSipController.distributeMonthlyAmount();
                                else if (goalSipController.savedInvestmentType.value == "sip") await goalSipController.distributeSipAmount();
                              }
                            }
                            return;
                          }

                          goalSipController.toggleFund(name);
                          if (goalSipController.savedInvestmentType.value == "lumpsum") await goalSipController.distributeMonthlyAmount();
                          else if (goalSipController.savedInvestmentType.value == "sip") await goalSipController.distributeSipAmount();
                        } catch (e, stackTrace) {
                          debugPrint("Error: $e");
                          debugPrintStack(stackTrace: stackTrace);
                        } finally {
                          goalSipController.hideLoading();
                        }
                      },
                      child: PopularFundCardMobSelected(
                        borderColor: isSelected ? Ucolors.primary : Ucolors.borderColor,
                        isNetwork: true,
                        imgPath: img,
                        name: name,
                        threeYear: threeYear,
                        oneYear: oneYear,
                        fiveYear: fiveYear,
                        tenYear: tenYear,
                        isSelected: isSelected,
                        showAmountField: isSelected && (goalSipController.savedInvestmentType.value == "lumpsum" || goalSipController.savedInvestmentType.value == "sip"),
                        amountController: goalSipController.getAmountController(fund.schemeCode?.toString() ?? ''),
                        onAmountSubmitted: (value) async {
                          final amount = double.tryParse(value) ?? 0;
                          if (goalSipController.savedInvestmentType.value == "lumpsum") {
                            await goalSipController.redistributeRemainingAmount(editedSchemeCode: fund.schemeCode?.toString() ?? '', editedAmount: amount);
                          } else if (goalSipController.savedInvestmentType.value == "sip") {
                            await goalSipController.redistributeSipAmountAfterEdit(editedSchemeCode: fund.schemeCode?.toString() ?? '', editedAmount: amount);
                          }
                        },
                      ),
                    ),
                  ),
                );
              });
            }),
          );
        },
      );
    });
  }

  Future<bool?> _showSipDateDialog(BuildContext context, GoalSipController controller) {
    RxString selectedSipDay = (controller.selectedSipDay.value).toString().obs;
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Align(
            alignment: isDesktop ? Alignment.bottomRight : Alignment.bottomCenter,
            child: Container(
              width: isDesktop ? 350 : double.infinity,
              margin: isDesktop ? const EdgeInsets.only(right: 30, bottom: 30) : EdgeInsets.zero,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: isDesktop ? BorderRadius.circular(20) : const BorderRadius.vertical(top: Radius.circular(24)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 5))]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Ucolors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Icon(Icons.calendar_month_rounded, color: Ucolors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text("Select SIP Date", style: TextStyle(fontFamily: FontFamily.medium, fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 1.5), borderRadius: BorderRadius.circular(12), color: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSipDay.value,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 24, color: Colors.grey.shade600),
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          items: List.generate(28, (i) => DropdownMenuItem(value: '${i + 1}', child: Text('Day ${i + 1} of every month', style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600, fontSize: 15)))),
                          onChanged: (val) {
                            if (val != null) {
                              selectedSipDay.value = val;
                              controller.selectedSipDay.value = int.parse(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300))),
                          child: Text("Cancel", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Ucolors.primary, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Confirm", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProjectionGraph extends StatefulWidget {
  const ProjectionGraph({super.key});

  @override
  State<ProjectionGraph> createState() => _ProjectionGraphState();
}

class _ProjectionGraphState extends State<ProjectionGraph> {
  int selectedView = 0;

  List<FlSpot> investedSpotsFromRows(List<ReturnRow> rows) => rows.map((e) => FlSpot(double.parse(e.period), e.scheme)).toList();
  List<FlSpot> valueSpotsFromRows(List<ReturnRow> rows) => rows.map((e) => FlSpot(double.parse(e.period), e.category)).toList();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(15),
      decoration: isDesktop ? null : BoxDecoration(color: Ucolors.light, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Projection', style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w600)),
              Container(
                decoration: BoxDecoration(color: const Color(0xffF3F4F6), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    ProjectionIcon(onTap: () => setState(() => selectedView = 0), isSelected: selectedView == 0, icon: Icons.trending_up),
                    ProjectionIcon(onTap: () => setState(() => selectedView = 1), isSelected: selectedView == 1, icon: Icons.grid_on_sharp),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          if (selectedView == 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('● Invest', style: UTextStyles.small.copyWith(color: const Color(0xff868686))),
                Text('● Value', style: UTextStyles.small.copyWith(color: const Color(0xff213C73))),
              ],
            ),
            const Gap(25),
            Obx(() {
              final rows = controller.savedInvestmentType.value == "lumpsum" ? controller.buildLumpsumYearlyReport() : controller.buildYearlyReport();
              if (rows.isEmpty) return const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));
              return SizedBox(
                height: 250,
                child: SipProjectionChart(
                  showLeftNumbers: true,
                  textColor: Colors.black,
                  investedSpots: investedSpotsFromRows(rows),
                  projectedSpots: valueSpotsFromRows(rows),
                ),
              );
            }),
          ] else
            Obx(() {
              final result = controller.savedInvestmentType.value == "lumpsum" ? controller.buildLumpsumYearlyReport() : controller.buildYearlyReport();
              if (result.isEmpty) return const SizedBox(height: 250, child: Center(child: Text("No projection data available")));
              return Column(
                children: [
                  const TableHeader(heading1: 'Year', heading2: 'Invest', heading3: 'Current', heading4: 'Profit'),
                  DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final row = result[index];
                      return ReturnsTableRow(color4: Colors.green, data: row, percentage: false);
                    },
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class ProjectionIcon extends StatelessWidget {
  const ProjectionIcon({super.key, required this.onTap, required this.isSelected, required this.icon});
  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: IconButton(onPressed: onTap, icon: Icon(icon, color: isSelected ? Ucolors.blue : Colors.grey)),
    );
  }
}

class SIPSectionGoal extends GetView<GoalSipController> {
  const SIPSectionGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
                () => IgnorePointer(
              ignoring: controller.isGoalSaved.value,
              child: TextFormFieldCustom(
                title: "Goal Title",
                hintTextColor: Ucolors.black,
                hintTextSize: 12,
                borderWidth: 1,
                backgroundColor: Ucolors.light,
                borderColor: Ucolors.darkgrey,
                method: TextFieldCustom(
                  height: 50,
                  width: double.infinity,
                  hintText: "Enter Full Name",
                  readOnly: controller.isGoalSaved.value,
                  textInputType: TextInputType.text,
                  backgroundColor: Colors.transparent,
                  controller: controller.goalNameTextEditingController,
                  onTap: () { if (controller.isGoalSaved.value) FocusScope.of(context).unfocus(); },
                  onChanged: (value) { controller.setGoalName(value ?? ""); return null; },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  suffixIcon: Container(width: 30, alignment: Alignment.center, child: const Text("*", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.red, fontSize: 16))),
                ),
              ),
            ),
          ),
          Obx(() => controller.goalError.isNotEmpty ? Padding(padding: const EdgeInsets.only(top: 4), child: Text(controller.goalError.value, style: TextStyle(fontFamily: FontFamily.medium, fontSize: 12, color: Ucolors.red))) : const SizedBox.shrink()),
          const Gap(20),
          Obx(() {
            final isSip = controller.investmentMode.value == 'sip';
            return Container(
              decoration: BoxDecoration(color: const Color(0xffF3F4F6), borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _TabButton(label: 'SIP', isSelected: isSip, onTap: () => controller.investmentMode.value = 'sip'),
                  _TabButton(label: 'Lumpsum', isSelected: !isSip, onTap: () { controller.investmentMode.value = 'lumpsum'; controller.recalculateLumpsum(); }),
                ],
              ),
            );
          }),
          const Gap(20),
          Obx(() {
            final isSip = controller.investmentMode.value == 'sip';
            return isSip ? const _SipTabContent() : const _LumpsumTabContent();
          }),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.isSelected, required this.onTap});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))] : [],
          ),
          child: Center(child: Text(label, style: TextStyle(fontFamily: FontFamily.medium, fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Ucolors.primary : Colors.grey.shade500))),
        ),
      ),
    );
  }
}

class _SipTabContent extends GetView<GoalSipController> {
  const _SipTabContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        int crossAxisCount = availableWidth < 450 ? 2 : 3;
        const double spacing = 10;
        final double cardWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Column(
          children: [
            Obx(() {
              final double minTarget = 1000.0;
              double maxTarget = 10000000.0;
              if (controller.targetAmount.value > maxTarget) maxTarget = controller.targetAmount.value.toDouble();
              if (maxTarget <= minTarget) maxTarget = minTarget + 1.0;
              final double safeTarget = controller.targetAmount.value.toDouble().clamp(minTarget, maxTarget);
              return IgnorePointer(ignoring: controller.isGoalSaved.value, child: SipSliderTile2(prefix: '₹', title: 'I Need', value: safeTarget, min: minTarget, max: maxTarget, suffix: '', onChanged: controller.setTarget));
            }),
            const Gap(16),
            Obx(() {
              final double actualYears = controller.years.value.toDouble();
              double maxYears = 30.0;
              if (actualYears > maxYears) maxYears = actualYears;
              if (maxYears <= 1.0) maxYears = 2.0;
              final double safeYears = actualYears.clamp(1.0, maxYears);
              return IgnorePointer(ignoring: controller.isGoalSaved.value, child: SipSliderTile2(title: 'Duration', value: safeYears, min: 1.0, max: maxYears, suffix: 'Yrs', onChanged: controller.setYears));
            }),
            const Gap(16),
            Obx(() {
              final double actualRate = controller.annualRate.value.toDouble();
              double maxRate = 30.0;
              if (actualRate > maxRate) maxRate = actualRate;
              if (maxRate <= 1.0) maxRate = 2.0;
              final double safeRate = actualRate.clamp(1.0, maxRate);
              return IgnorePointer(ignoring: controller.isGoalSaved.value, child: SipSliderTile2(title: 'Expected Return', value: safeRate, min: 1.0, max: maxRate, suffix: '%', onChanged: controller.setRate));
            }),
            const Gap(20),
            Obx(
                  () => Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Daily SIP', value: formatCurrency(controller.dailySipAmount.value), accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Weekly SIP', value: formatCurrency(controller.weeklySipAmount.value), accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Monthly SIP', value: formatCurrency(controller.monthlySip.value.toDouble()), accent: true)),
                  if (controller.hasChanges.value && controller.isEdit.value) ...[
                    SizedBox(width: cardWidth, child: _ValueCard(title: 'Existing SIP', value: formatCurrency(controller.existingSipAmount.value.toDouble()), accent: false)),
                    SizedBox(width: cardWidth, child: _ValueCard(title: 'Additional SIP', value: formatCurrency(controller.additionalSipAmount.value.toDouble()), accent: false)),
                  ],
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Invested', value: formatCurrency(controller.invested.value.toDouble()), accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Future Value', value: formatCurrency(controller.targetAmount.value.toDouble()), accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Total Return', value: formatCurrency(controller.totalReturn.value.toDouble()), accent: false)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LumpsumTabContent extends GetView<GoalSipController> {
  const _LumpsumTabContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        int crossAxisCount = availableWidth < 450 ? 2 : 3;
        const double spacing = 10;
        final double cardWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Column(
          children: [
            Obx(() {
              final double minLump = 500.0;
              double maxLump = controller.lumpsumFutureValue.value.toDouble();
              if (controller.lumpsumAmount.value > maxLump) maxLump = controller.lumpsumAmount.value.toDouble();
              if (maxLump <= minLump) maxLump = minLump + 1.0;
              final double safeValue = controller.smartRoundOff(controller.lumpsumAmount.value).clamp(minLump, maxLump);
              return IgnorePointer(ignoring: controller.isGoalSaved.value, child: SipSliderTile2(prefix: '₹', title: 'Invest Amount', value: safeValue, min: minLump, max: maxLump, suffix: '', onChanged: (value) => controller.setLumpsumAmount(value)));
            }),
            const Gap(16),
            Obx(() {
              final double actualYears = controller.years.value.toDouble();
              double maxYears = 30.0;
              if (actualYears > maxYears) maxYears = actualYears;
              if (maxYears <= 1.0) maxYears = 2.0;
              final double safeYears = actualYears.clamp(1.0, maxYears);
              return IgnorePointer(ignoring: controller.isGoalSaved.value, child: SipSliderTile2(title: 'Duration', value: safeYears, min: 1.0, max: maxYears, suffix: 'Yrs', onChanged: controller.setYears));
            }),
            const Gap(16),
            Obx(() {
              final double actualRate = controller.annualRate.value.toDouble();
              double maxRate = 30.0;
              if (actualRate > maxRate) maxRate = actualRate;
              if (maxRate <= 1.0) maxRate = 2.0;
              final double safeRate = actualRate.clamp(1.0, maxRate);
              return IgnorePointer(ignoring: controller.isGoalSaved.value, child: SipSliderTile2(title: 'Expected Return', value: safeRate, min: 1.0, max: maxRate, suffix: '%', onChanged: controller.setRate));
            }),
            const Gap(20),
            Obx(
                  () => Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Invest Once', value: formatCurrency(controller.lumpsumAmount.value.toDouble()), accent: true)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Duration', value: '${controller.years.value.toInt()} Yrs', accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Future Value', value: formatCurrency(controller.lumpsumFutureValue.value.toDouble()), accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Total Return', value: formatCurrency(controller.lumpsumTotalReturn.value.toDouble()), accent: false)),
                  SizedBox(width: cardWidth, child: _ValueCard(title: 'Return %', value: '${controller.lumpsumReturnPercent.value.toStringAsFixed(1)}%', accent: false)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SavedGoalDetailsCard extends GetView<GoalSipController> {
  const SavedGoalDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  controller.goalNameTextEditingController.text.isNotEmpty ? controller.goalNameTextEditingController.text : "Saved Goal",
                  style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Obx(
                    () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Ucolors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    controller.investmentMode.value == 'sip' ? "SIP" : "Lumpsum",
                    style: const TextStyle(fontFamily: FontFamily.medium, color: Ucolors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth = constraints.maxWidth;
              int crossAxisCount = availableWidth < 450 ? 2 : 3;
              const double spacing = 10;
              final double cardWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

              return Obx(() {
                final bool isSip = controller.investmentMode.value == 'sip';

                return Column(
                  children: [
                    const ProjectionGraph(),
                    const Gap(8),
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        SizedBox(width: cardWidth, child: _ValueCard(title: 'Target Amount', value: formatCurrency(controller.targetAmount.value.toDouble()), accent: false)),
                        SizedBox(width: cardWidth, child: _ValueCard(title: 'Duration', value: '${controller.years.value.toInt()} Yrs', accent: false)),
                        SizedBox(width: cardWidth, child: _ValueCard(title: 'Expected Return', value: '${controller.annualRate.value.toStringAsFixed(1)}%', accent: false)),
                        if (isSip) ...[
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Daily SIP', value: formatCurrency(controller.dailySipAmount.value), accent: false)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Weekly SIP', value: formatCurrency(controller.weeklySipAmount.value), accent: false)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Monthly SIP', value: formatCurrency(controller.monthlySip.value.toDouble()), accent: true)),
                          if (controller.hasChanges.value && controller.isEdit.value) ...[
                            SizedBox(width: cardWidth, child: _ValueCard(title: 'Existing SIP', value: formatCurrency(controller.existingSipAmount.value.toDouble()), accent: false)),
                            SizedBox(width: cardWidth, child: _ValueCard(title: 'Additional SIP', value: formatCurrency(controller.additionalSipAmount.value.toDouble()), accent: false)),
                          ],
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Invested', value: formatCurrency(controller.invested.value.toDouble()), accent: false)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Future Value', value: formatCurrency(controller.targetAmount.value.toDouble()), accent: false)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Total Return', value: formatCurrency(controller.totalReturn.value.toDouble()), accent: false)),
                        ] else ...[
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Invest Once', value: formatCurrency(controller.lumpsumAmount.value.toDouble()), accent: true)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Future Value', value: formatCurrency(controller.lumpsumFutureValue.value.toDouble()), accent: false)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Total Return', value: formatCurrency(controller.lumpsumTotalReturn.value.toDouble()), accent: false)),
                          SizedBox(width: cardWidth, child: _ValueCard(title: 'Return %', value: '${controller.lumpsumReturnPercent.value.toStringAsFixed(1)}%', accent: false)),
                        ],
                      ],
                    ),
                  ],
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.title, required this.value, this.accent = false});
  final String title;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent ? Ucolors.primary.withValues(alpha: 0.06) : const Color(0xffF5F7FB),
        borderRadius: BorderRadius.circular(14),
        border: accent ? Border.all(color: Ucolors.primary.withValues(alpha: 0.35), width: 1.2) : null,
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontFamily: FontFamily.medium, color: accent ? Ucolors.primary : Colors.grey.shade600, fontSize: 12, fontWeight: accent ? FontWeight.w600 : FontWeight.w400)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontFamily: FontFamily.medium, fontSize: 16, fontWeight: FontWeight.w600, color: accent ? Ucolors.primary : Colors.black)),
          Text("Approx", style: TextStyle(fontFamily: FontFamily.medium, fontSize: 8, fontWeight: FontWeight.w400, color: accent ? Ucolors.primary.withValues(alpha: 0.65) : Colors.grey.shade500)),
        ],
      ),
    );
  }
}