// ignore_for_file: dead_null_aware_expression, dead_code, unnecessary_null_in_if_null_operators

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/data/model/systematic_txn_req_model.dart';
import 'package:my_sip/features/mfu/presentation/controller/mfu_controller.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/animated/custom_footer.dart';
import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../common/widget/table/table_header.dart';
import '../../../../common/widget/text/view_all.dart';
import '../../../../common/widget/text_form/custom_text_field.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../../../../navigation_menu_bar.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/presentation/pages/cart_page.dart';

import '../../../explore/presentation/controller/mutual_fund_controller.dart';

import '../../../fund_details/data/models/return_model.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../fund_details/presentation/widgets/return.dart';
import '../../../home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import '../../../sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../domain/entity/goal_entity.dart';
import '../controller/goal_sip_controller.dart';

class MasterGoalsPage extends GetView<GoalSipController> {
  const MasterGoalsPage({super.key});

  static Map<String, dynamic>? tempArgs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalSipController>(
      initState: (_) async {
        controller.isHome.value = false;
        await controller.getMasterGoals();

        final args = (Get.arguments as Map<String, dynamic>?) ?? tempArgs;
        tempArgs = null;

        if (args == null) return;

        final String initialType = args['goalType'] ?? 'custom';

        controller.isEdit.value = args['isEdit'] ?? false;
        controller.isHome.value = args['isHome'] ?? false;
        controller.isAddFund.value = args['isAddFund'] ?? false;

        final UserGoalEntity? goal = args['goal'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!controller.isEdit.value) {
            controller.resetStateForNewGoal();
          }

          controller.updateGoalType(initialType);

          if (controller.isEdit.value && goal != null) {
            controller.loadGoalForEdit(goal);
          }
          if (controller.isAddFund.value && goal != null) {
            controller.loadGoalForAddFund(goal);
          }
          if (controller.isHome.value) {
            final masterGoal = controller.masterGoals.firstWhereOrNull(
                  (e) => e.goalType == initialType,
            );

            if (masterGoal != null) {
              controller.handleHomeGoal(masterGoal);
            }
          }
        });

        controller.update();
      },
      builder: (controller) {
        // ✅ Added isNewGoal so the UI switches in-place for Web
        final bool showDetails = controller.isEdit.value || controller.isHome.value || controller.isAddFund.value || controller.isNewGoal.value;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: showDetails
              ? SizedBox.expand(key: const ValueKey("details"), child: GoalDetailsScreen())
              : SizedBox.expand(key: const ValueKey("grid"), child: const GoalsGridScreen()),
        );
      },
    );
  }
}

// ==========================================
// 🎯 GOAL DETAILS SCREEN
// ==========================================
class GoalDetailsScreen extends GetView<GoalSipController> {
  GoalDetailsScreen({super.key});

  final CartController cartController = Get.find<CartController>();
  static final GlobalKey popularFundsKey = GlobalKey();
  final session = SessionManager.instance;

  Future<void> _handleBackPress(BuildContext context, bool isDesktop) async {
    final currentGoal = controller.goalResponse.value?.data.firstWhereOrNull(
          (e) => e.goalId == controller.savedDatabaseId.value,
    );

    if (currentGoal?.status == "pending" ||
        currentGoal?.status == null ||
        !controller.isGoalSaved.value ||
        currentGoal?.mfuOrderStatus == "not_ordered" ||
        currentGoal?.mfuOrderStatus == null) {
      final shouldLeave = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Discard Changes?"),
          content: const Text(
            "Your goal is not saved yet. Do you want to leave this page?",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Stay", style: TextStyle(color: Ucolors.primary)),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Leave", style: TextStyle(color: Ucolors.primary)),
            ),
          ],
        ),
      );

      if (shouldLeave == true) {
        if (isDesktop) {
          // Web: Switch back to the Grid view in place
          controller.isEdit.value = false;
          controller.isHome.value = false;
          controller.isAddFund.value = false;
          controller.isNewGoal.value = false;
          controller.update();
        } else {
          // Mobile: Pop the route
          Get.back();
        }
      }
      return;
    }

    if (isDesktop) {
      // Web: Switch back to the Grid view in place
      controller.isEdit.value = false;
      controller.isHome.value = false;
      controller.isAddFund.value = false;
      controller.isNewGoal.value = false;
      controller.update();
    } else {
      // Mobile: Pop the route
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // 1. The Scrollable Body Content
    Widget bodyContent = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SIPSectionGoal(),
                const Gap(4),
                Obx(() {
                  final bool isEdit = controller.isEdit.value;
                  final bool hasChanges = controller.hasChanges.value;
                  final bool isGoalSaved = controller.isGoalSaved.value;

                  if (isEdit && !hasChanges) {
                    return _buildProjectionAndFunds(context);
                  }

                  if (!isGoalSaved || (isEdit && hasChanges)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Obx(
                            () => controller.isSavingGoal.value
                            ? const Center(
                          child: CircularProgressIndicator(color: Ucolors.primary),
                        )
                            : UElevatedBUtton(
                          onPressed: () async {
                            if (!isEdit) {
                              await controller.saveGoalToDb();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (popularFundsKey.currentContext != null) {
                                  Scrollable.ensureVisible(
                                    popularFundsKey.currentContext!,
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOutCubic,
                                    alignment: 0.1,
                                  );
                                }
                              });
                              await Get.find<MutualFundController>().fetchData();
                            }
                          },
                          child: Center(
                            child: Text(
                              isEdit ? "Update Goal" : "Save Goal",
                              style: AppTextStyles.bodyMedium(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return _buildProjectionAndFunds(context);
                }),
              ],
            ),
          ),
        ),
      ],
    );

    // 2. The Bottom Cart Bar
    Widget bottomNavContent = Obx(() {
      if (!controller.isGoalSaved.value) {
        return const CustomFooter();
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            top: false,
            child: CartBottomBar(
              isValid: controller.selectedPopularFund.isNotEmpty,
              ontap: () {
                if (controller.selectedPopularFund.isEmpty || controller.amountControllers.isEmpty) {
                  Get.snackbar("Error", "Please select funds and enter amount to start SIP");
                  return;
                }

                final mutualController = Get.find<MutualFundController>();
                final mfuController = Get.find<MfuController>();

                final selectedFunds = mutualController.searchFund
                    .where((fund) => controller.selectedPopularFund.contains(fund.baseSchemeName))
                    .toList();

                final String goalIdString = controller.savedDatabaseId.value.toString();
                final int? parsedGoalId = int.tryParse(goalIdString);
                final int? finalGoalId = (parsedGoalId != null && parsedGoalId > 0) ? parsedGoalId : null;

                if (controller.savedInvestmentType.value == 'lumpsum') {
                  List<MfuTxnScheme> lumpsumSchemes = [];
                  for (final fund in selectedFunds) {
                    final schemeCode = fund.schemeCode?.toString() ?? '';
                    final amountText = controller.getAmountController(schemeCode).text;
                    final amount = double.tryParse(amountText) ?? 0.0;

                    if (schemeCode.isNotEmpty && amount > 0) {
                      lumpsumSchemes.add(MfuTxnScheme(schemeCode: "012", amount: amount, folio: "NEW", divOpt: "N"));
                    }
                  }

                  if (lumpsumSchemes.isEmpty) {
                    Get.snackbar("Error", "Please enter valid amounts for selected funds.");
                    return;
                  }

                  final uid = session.getUserData?.id ?? 0;
                  mfuController.normalTransaction(
                    MfuNormalTxnRequest.lumpsumMultiple(uid: uid, goalId: finalGoalId, schemes: lumpsumSchemes),
                  );
                } else if (controller.savedInvestmentType.value == "sip") {
                  List<MfuSysTxnScheme> sipSchemes = [];
                  for (final fund in selectedFunds) {
                    final schemeCode = fund.schemeCode?.toString() ?? '';
                    final amountText = controller.getAmountController(schemeCode).text;
                    final amount = int.tryParse(amountText) ?? 0;

                    if (schemeCode.isNotEmpty && amount > 0) {
                      sipSchemes.add(MfuSysTxnScheme(schemeCode: "001", amount: 2000, folio: "NEW", divOpt: "R"));
                    }
                  }

                  final now = DateTime.now();
                  DateTime startDate = DateTime(now.year, now.month + 1, 10);
                  if (startDate.difference(now).inDays < 30) {
                    startDate = DateTime(now.year, now.month + 2, 10);
                  }

                  mfuController.systematicTransaction(
                    MfuSystematicTxnRequest.sipMultiple(
                      uid: 7,
                      goalId: finalGoalId,
                      can: "14167AZA01",
                      frequency: "M",
                      day: "10",
                      startMonth: startDate.month.toString().padLeft(2, '0'),
                      startYear: startDate.year.toString(),
                      endMonth: "08",
                      endYear: "2027",
                      paymentMode: "DM",
                      accType: "SB",
                      accNo: "654321",
                      ifsc: "ABHY0065002",
                      micr: "400065002",
                      mandateRefNo: "PRNUAT001",
                      schemes: sipSchemes,
                    ),
                  );
                } else {
                  Get.snackbar("Info", "Processing SIP Checkout...");
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
    });

    // ==========================================
    // 🖥️ WEB LAYOUT (Rendered inside Drawer)
    // ==========================================
    if (isDesktop) {
      return Material(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
                    onPressed: () => _handleBackPress(context, true),
                  ),
                  Text(
                    "${controller.selectedGoalType.value.capitalizeFirst} Details",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(child: bodyContent),

          ],
        ),
      );
    }

    // ==========================================
    // 📱 MOBILE LAYOUT (Full Screen Scaffold)
    // ==========================================
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _handleBackPress(context, false);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBarNormal(
          backgroundColor: Ucolors.light,
          title: controller.selectedGoalType.value.capitalizeFirst ?? '',
          backIcon: true,
          actionsPadding: 10,
          action: [
            Obx(() {
              if (!controller.isGoalSaved.value) return const SizedBox.shrink();
              return TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.navMenuBar);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (Get.isRegistered<NavigationBarController>()) {
                      Get.find<NavigationBarController>().selectedIndex.value = 3;
                    }
                  });
                },
                child: const Text("View All Goals", style: TextStyle(fontFamily: FontFamily.medium, color: Ucolors.primary)),
              );
            }),
          ],
        ),
        body: bodyContent,
        bottomNavigationBar: bottomNavContent,
      ),
    );
  }

  Widget _buildProjectionAndFunds(BuildContext context) {
    return Column(
      children: [
        const ProjectionGraph(),
        const Gap(9),
        Obx(() {
          final selectedCount = controller.selectedPopularFund.length;
          return USectionHeading(
            key: popularFundsKey,
            title: selectedCount > 0 ? 'Selected Funds ($selectedCount)' : 'Popular Funds',
            showActionButton: true,
            buttonTitle: selectedCount > 0 ? 'Add Funds' : 'View All',
            onPressed: () {
              // Add explore bottom sheet call
            },
          );
        }),
        const Gap(10),
        PopularAndSelectedFund(),
        const Gap(10),
      ],
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => IgnorePointer(
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
          )),
          Obx(() => controller.goalError.isNotEmpty ? Padding(padding: const EdgeInsets.only(top: 4), child: Text(controller.goalError.value, style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 12, color: Ucolors.red))) : const SizedBox.shrink()),
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
          Obx(() => controller.investmentMode.value == 'sip' ? const _SipTabContent() : const _LumpsumTabContent()),
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
          child: Center(
            child: Text(label, style: TextStyle(fontFamily: FontFamily.medium, fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? Ucolors.primary : Colors.grey.shade500)),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _SipTabContent  — Daily / Weekly / Monthly sliders + value cards
// =============================================================================
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
            Obx(() => Wrap(
              spacing: spacing, runSpacing: spacing,
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
            )),
          ],
        );
      },
    );
  }
}

// =============================================================================
// _LumpsumTabContent  — One-time invest amount + duration + return sliders
// =============================================================================
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
            Obx(() => Wrap(
              spacing: spacing, runSpacing: spacing,
              children: [
                SizedBox(width: cardWidth, child: _ValueCard(title: 'Invest Once', value: formatCurrency(controller.lumpsumAmount.value.toDouble()), accent: true)),
                SizedBox(width: cardWidth, child: _ValueCard(title: 'Duration', value: '${controller.years.value.toInt()} Yrs', accent: false)),
                SizedBox(width: cardWidth, child: _ValueCard(title: 'Future Value', value: formatCurrency(controller.lumpsumFutureValue.value.toDouble()), accent: false)),
                SizedBox(width: cardWidth, child: _ValueCard(title: 'Total Return', value: formatCurrency(controller.lumpsumTotalReturn.value.toDouble()), accent: false)),
                SizedBox(width: cardWidth, child: _ValueCard(title: 'Return %', value: '${controller.lumpsumReturnPercent.value.toStringAsFixed(1)}%', accent: false)),
              ],
            )),
          ],
        );
      },
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
          Text(value, style: TextStyle(fontFamily: FontFamily.medium, fontSize: 16, fontWeight: FontWeight.w700, color: accent ? Ucolors.primary : Colors.black)),
          Text("Approx", style: TextStyle(fontFamily: FontFamily.medium, fontSize: 8, fontWeight: FontWeight.w400, color: accent ? Ucolors.primary.withValues(alpha: 0.65) : Colors.grey.shade500)),
        ],
      ),
    );
  }
}

// ==========================================
// 🎯 GOALS GRID SCREEN
// ==========================================
class GoalsGridScreen extends GetView<GoalSipController> {
  const GoalsGridScreen({super.key});

  IconData getGoalIcon(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'car': return Icons.directions_car_rounded;
      case 'house': return Icons.home_rounded;
      case 'education': return Icons.school_rounded;
      case 'marriage': return Icons.favorite_rounded;
      case 'retirement': return Icons.elderly_rounded;
      case 'vacation': return Icons.flight_takeoff_rounded;
      default: return Icons.flag_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalSipController>(
      builder: (controller) {
        if (controller.isMasterGoalLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Ucolors.primary));
        }

        if (controller.masterGoals.isEmpty) {
          return const Center(child: Text("No Goals Found"));
        }

        final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

        // 1. Core Grid Definition
        Widget gridContent = LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 2;

            if (width > 1400) {
              crossAxisCount = 3;
            } else if (width > 1000) {
              crossAxisCount = 3;
            } else if (width > 600) {
              crossAxisCount = 2;
            }

            return GridView.builder(
              padding: EdgeInsets.all(isDesktop ? 8 : 10),
              itemCount: controller.masterGoals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: isDesktop?240:216,
              ),
              itemBuilder: (context, index) {
                final goal = controller.masterGoals[index];
                final isSelected = controller.selectedGoalIndex.value == index;

                return AnimatedScale(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  scale: isSelected ? 1.04 : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [controller.getGoalColor(goal.goalType), controller.getGoalColor(goal.goalType).withValues(alpha: .75)]
                            : [Colors.white, Colors.white],
                      ),
                      border: Border.all(color: isSelected ? controller.getGoalColor(goal.goalType) : Colors.grey.shade200, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? controller.getGoalColor(goal.goalType).withValues(alpha: .20) : Colors.black.withValues(alpha: .04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        controller.selectedGoalIndex.value = index;
                        controller.update();

                        await Future.delayed(const Duration(milliseconds: 200));

                        controller.goalId.value = goal.id;
                        controller.selectedGoalType.value = goal.goalType;
                        final goalType = goal.goalType.toLowerCase();

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

                        // ✅ Web (Desktop) slides in-place, Mobile pushes new screen
                        if (isDesktop) {
                          controller.isEdit.value = false;
                          controller.isNewGoal.value = true;
                          controller.update();
                        } else {
                          controller.update();
                          Get.to(() => GoalDetailsScreen());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: width < 500 ? 42 : 52,
                                  width: width < 500 ? 42 : 52,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white.withValues(alpha: .18) : controller.getGoalColor(goal.goalType).withValues(alpha: .10),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(getGoalIcon(goal.goalType), color: isSelected ? Colors.white : controller.getGoalColor(goal.goalType), size: width < 500 ? 22 : 28),
                                ),
                                const Spacer(),
                                Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? Colors.transparent : Colors.grey.shade400,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check, size: 16, color: controller.getGoalColor(goal.goalType))
                                      : null,
                                ),
                              ],
                            ),
                            SizedBox(height: width < 500 ? 6 : 14),
                            Text(
                              goal.goalType.capitalizeFirst ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: FontFamily.medium, fontSize: width < 500 ? 15 : 20, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : Colors.black),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              goal.goalDescription,
                              maxLines: width < 500 ? 2 : 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: FontFamily.medium, fontSize: width < 500 ? 11 : 13, color: isSelected ? Colors.white.withValues(alpha: .9) : Colors.grey.shade600, height: 1.4),
                            ),
                            Gap(8),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(width < 500 ? 8 : 16),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withValues(alpha: .15) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Flex(
                                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                                mainAxisAlignment: isDesktop ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                crossAxisAlignment: isDesktop ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Target Amount",
                                        style: TextStyle(
                                          fontFamily: FontFamily.medium,
                                          fontSize: 10,
                                          color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        formatCurrency(goal.targetAmount),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: FontFamily.medium,
                                          fontSize: width < 500 ? 13 : 16,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isDesktop) SizedBox(height: width < 500 ? 4 : 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.schedule_rounded,
                                        size: 14,
                                        color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${goal.goalTenure} Years", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: FontFamily.medium, fontSize: width < 500 ? 11 : 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.black87)),
                                    ],
                                  ),
                                  if (!isDesktop) SizedBox(height: width < 500 ? 4 : 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.trending_up_rounded,
                                        size: 14,
                                        color: isSelected ? Colors.white70 : Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${goal.expectedReturnRate} %", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: FontFamily.medium, fontSize: width < 500 ? 11 : 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.black87)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );

        if (isDesktop) {
          return gridContent;
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: CustomAppBarNormal(
            backgroundColor: const Color(0xffF3F4F6),
            title: 'Goals',
            backIcon: true,
            actionsPadding: 10,
          ),
          bottomNavigationBar: const CustomFooter(),
          body: gridContent,
          floatingActionButton: controller.isEdit.value
              ? FloatingActionButton(
            onPressed: () => Get.to(() => GoalDetailsScreen()),
            backgroundColor: Ucolors.primary,
            child: const Icon(Icons.check, color: Colors.white),
          )
              : null,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Other Unchanged Supporting Components
// ─────────────────────────────────────────────────────────────────────────────

class PopularFundCardMobSelected extends StatelessWidget {
  const PopularFundCardMobSelected({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
    this.tenYear,
    this.oneYear,
    this.fiveYear,
    this.isSelected = false,
    this.showAmountField = false,
    this.amountController,
    this.onAmountSubmitted,
  });
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
            border: Border.all(
              color: isSelected ? Ucolors.primary : Colors.grey.shade100,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Ucolors.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade50,
                      border: isSelected ? Border.all(color: Ucolors.primary, width: 1.5) : null,
                    ),
                    child: ClipOval(
                      child: isNetwork ? CustomCachedImage(imageUrl: imgPath, size: 40) : Image.asset(imgPath, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: UTextStyles.medium.copyWith(
                        color: Colors.black,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                        height: 1.1,
                      ),
                    ),
                  ),
                  if (isSelected)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 250),
                      scale: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Ucolors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 12, color: Colors.white),
                      ),
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
                            decoration: InputDecoration(
                              hintText: "Amount",
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
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
            Text('${value ?? 0}%', style: UTextStyles.bodySmallW500.copyWith(color: Ucolors.success, fontWeight: FontWeight.bold)),
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
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final int crossAxisCount = isDesktop ? 3 : 1;

    return Obx(() {
      final allFunds = mutualController.searchFund;
      final selectedFunds = allFunds.where((f) => goalSipController.isSelectedFund(f.baseSchemeName ?? '')).toList();
      final popularFunds = allFunds.where((f) => !goalSipController.isSelectedFund(f.baseSchemeName ?? '')).toList();
      final List<dynamic> displayFunds = selectedFunds.isNotEmpty ? [...selectedFunds, ...popularFunds] : popularFunds.take(6).toList();

      if (displayFunds.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.account_balance_wallet, size: 42, color: Ucolors.primary),
                const SizedBox(height: 12),
                const Text("No Funds Available", style: TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w700, fontSize: 16, color: Ucolors.dark)),
                const SizedBox(height: 6),
                Text("Please add funds", style: TextStyle(fontFamily: FontFamily.medium, color: Colors.grey.shade600)),
              ],
            ),
          ),
        );
      }

      final double screenWidth = MediaQuery.of(context).size.width;
      final double horizontalPadding = isDesktop ? 96 : 32;
      const double spacing = 16;
      final double cardWidth = (screenWidth - horizontalPadding - (spacing * (crossAxisCount - 1))) / crossAxisCount;

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
                            if (goalSipController.savedInvestmentType.value == "lumpsum") {
                              await goalSipController.distributeMonthlyAmount();
                            } else if (goalSipController.savedInvestmentType.value == "sip") {
                              await goalSipController.distributeSipAmount();
                            }
                          }
                        }
                        return;
                      }

                      if (goalSipController.savedInvestmentType.value == "sip" &&
                          goalSipController.selectedPopularFund.isEmpty) {
                        RxString selectedSipDay =
                            goalSipController.selectedSipDay.value.toString().obs;

                        final confirmed = await Get.dialog<bool>(
                          Dialog(
                            insetPadding: const EdgeInsets.symmetric(horizontal: 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Select SIP Date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Obx(
                                        () => SizedBox(
                                      width: 120, // Smaller dropdown width
                                      child: DropdownButtonFormField<String>(
                                        value: selectedSipDay.value,
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                        ),
                                        items: List.generate(
                                          28,
                                              (i) => DropdownMenuItem(
                                            value: '${i + 1}',
                                            child: Text('${i + 1}'),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          if (val != null) {
                                            selectedSipDay.value = val;
                                            goalSipController.selectedSipDay.value =
                                                int.parse(val);
                                          }
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () => Get.back(result: false),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      SizedBox(
                                        height: 32,
                                        child: ElevatedButton(
                                          onPressed: () => Get.back(result: true),
                                          child: const Text(
                                            "Confirm",
                                            style: TextStyle(fontSize: 12),
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

                        if (confirmed != true) return;
                      }
                      goalSipController.toggleFund(name);
                      await goalSipController.saveGoalFund(
                        goalId: goalSipController.savedDatabaseId.value ?? 0,
                        schemeCode: fund.schemeCode?.toString() ?? '',
                        schemeName: fund.baseSchemeName ?? '',
                        sipAmount: (goalSipController.monthlySip.value).toDouble(),
                        sipDay: goalSipController.selectedSipDay.value,
                      );

                      if (goalSipController.savedInvestmentType.value == "lumpsum") {
                        await goalSipController.distributeMonthlyAmount();
                      } else if (goalSipController.savedInvestmentType.value == "sip") {
                        await goalSipController.distributeSipAmount();
                      }
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
    });
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
              Text('Projection', style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w700)),
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
              if (rows.isEmpty) {
                return const SizedBox(height: 250, child: Center(child: CircularProgressIndicator()));
              }
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
              if (result.isEmpty) {
                return const SizedBox(height: 250, child: Center(child: Text("No projection data available")));
              }
              return Column(
                children: [
                  const TableHeader(heading1: 'Year', heading2: 'Invest', heading3: 'Current', heading4: 'Profit'),
                  DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return ReturnsTableRow(color4: Colors.green, data: result[index], percentage: false);
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