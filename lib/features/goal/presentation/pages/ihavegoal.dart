import 'dart:developer';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/cart/presentation/pages/cart_page.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/return.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../services/image_picker_service.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../home/presentation/pages/home.dart';

class IhavegoalPage extends GetView<GoalSipController> {
  IhavegoalPage({super.key});

  final Map<String, Map<String, dynamic>> goalConfig = {
    'car': {'amount': 1000000, 'duration': 5, 'rate': 12, 'name': 'Car'},
    'bike': {'amount': 150000, 'duration': 3, 'rate': 12, 'name': 'Bike'},
    'home': {'amount': 3000000, 'duration': 10, 'rate': 12, 'name': 'Home'},
    'marriage': {
      'amount': 500000,
      'duration': 5,
      'rate': 12,
      'name': 'Marriage',
    },
    'vacation': {
      'amount': 100000,
      'duration': 2,
      'rate': 12,
      'name': 'Vacation',
    },
    'custom': {'amount': 100000, 'duration': 2, 'rate': 12, 'name': 'Custom'},
  };

  final CartController cartController = Get.find<CartController>();
  final GlobalKey popularFundsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String goalType = args['goalType'] ?? 'custom';
    final goalData = goalConfig[goalType]!;
    final String name = goalData['name']!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isGoalSaved.value = false;
      controller.initFromGoal(
        amount: goalData['amount'].toDouble(),
        years: goalData['duration'].toDouble(),
        rate: goalData['rate'].toDouble(),
      );
    });

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop
          ? const Color(0xFFF5F7FA)
          : const Color(0xffF3F4F6),
      appBar: CustomAppBarNormal(
        title: 'Create $name Goal',
        action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
        actionsPadding: 15,
      ),
      body: isDesktop
          ? _WebLayout(
              name: name,
              goalData: goalData,
              controller: controller,
              popularFundsKey: popularFundsKey,
            )
          : _MobileLayout(
              name: name,
              goalData: goalData,
              controller: controller,
              popularFundsKey: popularFundsKey,
            ),
      bottomNavigationBar: Obx(
        () => controller.isGoalSaved.value
            ? SafeArea(
                top: false,
                child: CartBottomBar(
                  isValid: controller.selectedPopularFund.isNotEmpty,

                  ontap: () {
                    log(controller.savedDatabaseId.value.toString());
                    final cartCont = Get.find<CartController>();
                    cartCont.filterGoalId.value =
                        controller.savedDatabaseId.value;
                    cartController.monthlyAmount.value = controller
                        .monthlySip
                        .value
                        .toInt();

                    controller.selectedPopularFund.isNotEmpty
                        ? Get.toNamed(
                            AppRoutes.cart,
                            arguments: {
                              'goal_id': controller
                                  .savedDatabaseId
                                  .value, // Pass the ID (e.g., 50)
                            },
                          )
                        : Get.snackbar(
                            "Error",
                            "Please select funds to start SIP",
                          );
                  },
                  amount: controller.monthlySip.value.toStringAsFixed(0),
                  amountColor: Ucolors.blue,
                  title: 'Installment Amount',
                  buttonText: 'Start SIP',
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _WebLayout extends StatelessWidget {
  final String name;
  final Map<String, dynamic> goalData;
  final GoalSipController controller;
  final GlobalKey popularFundsKey;

  const _WebLayout({
    required this.name,
    required this.goalData,
    required this.controller,
    required this.popularFundsKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaxWidthBox(
        maxWidth: 1200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Goal Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(24),

                        // ✅ UPDATED: Passing Controller to Cover Section
                        CoverSection(controller: controller),

                        const Gap(20),
                        GoalNameSelect(goalName: name, controller: controller),
                        const Gap(20),
                        SIPSection(
                          amount: goalData['amount'].toDouble(),
                          duration: goalData['duration'].toInt(),
                          rate: goalData['rate'].toDouble(),
                        ),
                        const Gap(24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Ucolors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await controller.saveGoalToDb();
                            },
                            child: const Text(
                              "Save Goal & Calculate",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(30),
              // Right Panel logic remains same...
              Expanded(
                flex: 6,
                child: Obx(() {
                  if (!controller.isGoalSaved.value) return _buildEmptyState();
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "SIP Projection",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(20),
                              ProjectionGraph(),
                            ],
                          ),
                        ),
                        const Gap(24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Recommended Funds",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(16),
                              PopularFund(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 400,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.chart_square, size: 64, color: Colors.grey.shade400),
          const Gap(16),
          Text(
            "Set your goal parameters\nand click 'Save' to view projections",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final String name;
  final Map<String, dynamic> goalData;
  final GoalSipController controller;
  final GlobalKey popularFundsKey;

  const _MobileLayout({
    required this.name,
    required this.goalData,
    required this.controller,
    required this.popularFundsKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Gap(12),
            // ✅ UPDATED: Passing Controller to Cover Section
            CoverSection(controller: controller),
            GoalNameSelect(goalName: name, controller: controller),
            SIPSection(
              amount: goalData['amount'].toDouble(),
              duration: goalData['duration'].toInt(),
              rate: goalData['rate'].toDouble(),
            ),
            const Gap(12),
            Obx(() {
              if (!controller.isGoalSaved.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: UElevatedBUtton(
                    onPressed: () async {
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
                    },
                    child: Center(
                      child: Text(
                        "Save Goal",
                        style: AppTextStyles.bodyMedium(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  const ProjectionGraph(),
                  const Gap(9),
                  USectionHeading(
                    key: popularFundsKey,
                    title: 'Popular Funds',
                    showActionButton: true,
                  ),
                  PopularFund(),
                  const Gap(10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 🧩 WIDGETS (SIPSection, PopularFund, etc.)
// ==========================================

class PopularFund extends StatelessWidget {
  PopularFund({super.key});

  final MutualFundController controller = Get.find();
  final GoalSipController goalSipController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Adapt Grid for Web Split View
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // On Desktop, since we are in a split view (60% width), we treat it like a Tablet
    final int crossAxisCount = isDesktop ? 3 : 2;
    final double childAspectRatio = isDesktop ? 1.4 : 1.55;

    return GridView.builder(
      itemCount: controller.searchFund.length.clamp(0, 6), // Limit items
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final fund = controller.searchFund[index];
        final id = fund.amc?.id;
        if (id == null) return const SizedBox();
        final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
        final img1 = fund.amc?.amcLogoUrl ?? '';
        final name = fund.baseSchemeName ?? 'Unknown Name';
        final returns = fund.returnsEntity?.threeYear ?? "";

        return Obx(
          () => GestureDetector(
            onTap: () {
              final isSelected = goalSipController.isSelectedFund(name);
              final schemeCodeStr = fund.schemeCode.toString();
              final int? currentGoalId =
                  goalSipController.savedDatabaseId.value;

              if (!isSelected) {
                // Check if goal is saved first

                goalSipController.toggleFund(name);

                cartController.addToCart(
                  fund.schemeCode ?? '',
                  fund.baseSchemeName ?? '',
                  fund.minSipAmount ?? 0,
                  currentGoalId,
                );
              } else {
                // REMOVE LOGIC
                final cartItem = cartController.cartResponseEntity.value?.items
                    .firstWhereOrNull(
                      (item) => item.schemeCode.toString() == schemeCodeStr,
                    );

                if (cartItem != null && cartItem.id != null) {
                  cartController.deleteCartItem(cartItem.id!, name);
                  goalSipController.toggleFund(name);
                }
              }
            },
            // onTap: () {
            //   final isSelected = goalSipController.isSelectedFund(name);
            //   final schemeCodeStr = fund.schemeCode.toString();

            //   if (!isSelected) {
            //     // ADD TO CART
            //     goalSipController.toggleFund(name);
            //     cartController.addToCart(
            //       fund.schemeCode ?? '',
            //       fund.baseSchemeName ?? '',
            //       fund.minSipAmount ?? 0,
            //       1
            //     );
            //   } else {
            //     // REMOVE FROM CART
            //     // 1. Find the item in the cart that matches this scheme code
            //     final cartItem = cartController.cartResponseEntity.value?.items
            //         .firstWhereOrNull(
            //           (item) => item.schemeCode.toString() == schemeCodeStr,
            //         );

            //     if (cartItem != null && cartItem.id != null) {
            //       // 2. Use the actual cart item ID to delete
            //       cartController.deleteCartItem(cartItem.id!, name);
            //       // 3. Untoggle the UI state
            //       goalSipController.toggleFund(name);
            //     } else {
            //       // Fallback: If not found in cart list, just untoggle UI
            //       goalSipController.toggleFund(name);
            //       log(
            //         "Item not found in cart response, couldn't delete from server.",
            //       );
            //     }
            //   }
            // },
            // onTap: () async {
            //   final isSelected = goalSipController.isSelectedFund(name);
            //   goalSipController.toggleFund(name);

            //   // !isSelected
            //   //     ?
            //   //       //  cartController.addItem(
            //   //       //     CartItem(
            //   //       //       fundId: id.toString(),
            //   //       //       fundName: name,
            //   //       //       logoUrl: img1,
            //   //       //     ),
            //   //       //   )
            //   //       await cartController.addToCart(
            //   //         fund.schemeCode ?? '',
            //   //         fund.baseSchemeName ?? '',
            //   //         fund.minSipAmount ?? 0,
            //   //         1
            //   //       )
            //   //     :
            //   //       // cartController.removeItemByName(name);
            //   //       await cartController.deleteCartItem(
            //   //         cartController
            //   //                 .cartResponseEntity
            //   //                 .value
            //   //                 ?.items[index]
            //   //                 .id ??
            //   //             0,
            //   //         fund.baseSchemeName ?? '',
            //   //       );
            //   if (!isSelected) {
            //     cartController.addItem(
            //       CartItem(
            //         fundId: id.toString(),
            //         fundName: name,
            //         logoUrl: img1,
            //       ),
            //     );
            //     // PASS THE GOAL ID HERE
            //     cartController.addToCart(
            //       fund.schemeCode ?? '',
            //       fund.baseSchemeName ?? '',
            //       fund.minSipAmount ?? 0,
            //       1, // Use the dynamic ID from your saved goal if available
            //     );
            //   } else {
            //     // cartController.deleteCartItem(
            //     //   // fund.amc?.id ?? 0,
            //     //   cartController.cartResponseEntity.value.items.indexWhere(fund.schemeCode.toString())
            //     //   fund.baseSchemeName ?? '',
            //     // );
            //     cartController.removeItemByName(name);
            //   }
            // },
            child: PopularFundCard(
              borderColor: goalSipController.isSelectedFund(name)
                  ? Ucolors.primary
                  : Ucolors.borderColor,
              isNetwork: true,
              imgPath: img,
              name: name,
              threeYear: returns,
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

  List<FlSpot> investedSpotsFromRows(List<ReturnRow> rows) {
    return rows.map((e) => FlSpot(double.parse(e.period), e.scheme)).toList();
  }

  List<FlSpot> valueSpotsFromRows(List<ReturnRow> rows) {
    return rows.map((e) => FlSpot(double.parse(e.period), e.category)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      // On mobile, the container has decoration. On Web, the parent card has decoration.
      padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(15),
      decoration: isDesktop
          ? null
          : BoxDecoration(
              color: Ucolors.light,
              borderRadius: BorderRadius.circular(12),
            ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projection',
                style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ProjectionIcon(
                      onTap: () => setState(() => selectedView = 0),
                      isSelected: selectedView == 0,
                      icon: Icons.trending_up,
                    ),
                    ProjectionIcon(
                      onTap: () => setState(() => selectedView = 1),
                      isSelected: selectedView == 1,
                      icon: Icons.grid_on_sharp,
                    ),
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
                Text(
                  '● Invest',
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff868686),
                  ),
                ),
                Text(
                  '● Value',
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff213C73),
                  ),
                ),
              ],
            ),
            const Gap(25),
            Obx(() {
              final rows = controller.buildYearlyReport();
              if (rows.isEmpty)
                return const SizedBox(
                  height: 250,
                  child: CircularProgressIndicator(),
                );

              return SizedBox(
                height: 250,
                child: SipProjectionChart(
                  investedSpots: investedSpotsFromRows(rows),
                  projectedSpots: valueSpotsFromRows(rows),
                ),
              );
            }),
          ] else
            Obx(() {
              final result = controller.buildYearlyReport();
              return Column(
                children: [
                  const TableHeader(
                    heading1: 'Year',
                    heading2: 'Invest',
                    heading3: 'Curent',
                    heading4: 'Profit',
                  ),
                  DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final row = result[index];
                      return ReturnsTableRow(
                        color4: Colors.green,
                        data: row,
                        percentage: false,
                      );
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
  const ProjectionIcon({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
  });
  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: isSelected ? Ucolors.blue : Colors.grey),
      ),
    );
  }
}

class AllValue extends StatelessWidget {
  const AllValue({
    super.key,
    required this.title,
    required this.value,
    this.textColor,
  });
  final String title;
  final double value;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Text(
            title,
            style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w600),
          ),
          const Gap(5),
          Text(
            '₹${value.toDouble().toStringAsFixed(0)}',
            style: TextStyle(
              color: textColor ?? Ucolors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SIPSection extends StatelessWidget {
  const SIPSection({
    super.key,
    required this.amount,
    required this.duration,
    this.rate = 12,
  });
  final double amount;
  final int duration;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Ucolors.light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SipSliderTile2(
            prefix: '₹',
            title: 'I need',
            value: amount,
            min: 100,
            max: 10000000,
            suffix: '',
            onChanged: (value) => controller.setTarget(value),
          ),
          SipSliderTile2(
            title: 'Duration',
            value: duration.toDouble(),
            min: 1,
            max: 30,
            suffix: 'Yrs',
            onChanged: (value) => controller.setYears(value),
          ),
          const Gap(15),
          SipSliderTile2(
            title: 'Expected Returns',
            value: rate,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (value) => controller.setRate(value),
          ),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: AllValue(
                    title: 'Invested',
                    value: controller.invested.toDouble(),
                  ),
                ),
                Expanded(
                  child: AllValue(
                    title: 'Future Value',
                    value: controller.targetAmount.toDouble(),
                  ),
                ),
                Expanded(
                  child: AllValue(
                    title: 'Total Return',
                    value: controller.totalReturn.toDouble(),
                    textColor: Ucolors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GoalNameSelect extends StatelessWidget {
  final GoalSipController controller;
  final String goalName;
  const GoalNameSelect({
    super.key,
    required this.goalName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SmallHeading(smallheading: 'Goal Name')]),
        const Gap(5),
        UTextFormField(
          readOnly: true,
          prefixIcon: null,
          controller: TextEditingController(text: goalName),
          backgroundColor: Colors.white,
        ),
        UTextFormField(
          controller: controller.goalNameTextEditingController,
          backgroundColor: Colors.white,
          prefixIcon: null,
          hintText: 'Enter $goalName Name',
        ),
      ],
    );
  }
}

class CoverSection extends StatelessWidget {
  final GoalSipController controller;
  const CoverSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // We assume 'coverImage' exists in your GoalSipController as Rx<XFile?>
    return Column(
      children: [
        Obx(() {
          if (controller.coverImage.value != null) {
            return GestureDetector(
              onTap: () => _showPicker(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        controller.coverImage.value!.path,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(controller.coverImage.value!.path),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
              ),
            );
          }
          return AddCoverBottomSheet(
            recentPhoto: false,
            onTap: () => _showPicker(context),
          );
        }),
        const Gap(5),
        const Text('Add Cover', style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => _PickerSheet(controller: controller),
    );
  }
}

class AddCoverBottomSheet extends StatelessWidget {
  final bool recentPhoto;
  final VoidCallback onTap;

  const AddCoverBottomSheet({
    super.key,
    required this.recentPhoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final containerSize = isMobile ? 100.0 : 120.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: containerSize,
        width: containerSize,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, color: Colors.black, size: containerSize * 0.4),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final GoalSipController controller;
  final ImagePickerService _pickerService = ImagePickerService();

  _PickerSheet({required this.controller});

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final image = await _pickerService.pickImage(source);
    if (image != null) {
      controller.coverImage.value = image; // Save to controller
      Get.back(); // Close sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "Select Image Source",
              style: UTextStyles.medium.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  icon: Iconsax.camera,
                  label: "Camera",
                  onTap: () => _pick(context, ImageSource.camera),
                ),
                _buildOption(
                  icon: Iconsax.gallery,
                  label: "Gallery",
                  onTap: () => _pick(context, ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Ucolors.primary),
            const Gap(8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
