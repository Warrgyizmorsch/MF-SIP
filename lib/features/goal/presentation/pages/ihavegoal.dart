import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/return.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
import 'package:responsive_framework/responsive_framework.dart';

class IhavegoalPage extends GetView<GoalSipController> {
  IhavegoalPage({super.key});

  final Map<String, Map<String, dynamic>> goalConfig = {
    'car': {
      'amount': 1000000, // 10 L
      'duration': 5,
      'rate': 12,
      'name': 'Car',
    },
    'bike': {
      'amount': 150000, // 1.5 L
      'duration': 3,
      'rate': 12,
      'name': 'Bike',
    },
    'home': {
      'amount': 3000000, // 30 L
      'duration': 10,
      'rate': 12,
      'name': 'Home',
    },
    'marriage': {
      'amount': 500000, // 5 L
      'duration': 5,
      'rate': 12,
      'name': 'Marriage',
    },
    'vacation': {
      'amount': 100000, // 1 L
      'duration': 2,
      'rate': 12,
      'name': 'Vacation',
    },
    'custom': {
      'amount': 100000, // 1 L
      'duration': 2,
      'rate': 12,
      'name': 'Custom',
    },
  };

  final CartController cartController = Get.find<CartController>();
  final GlobalKey popularFundsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    log('build');

    final args = Get.arguments ?? {};
    final String goalType = args['goalType'] ?? 'custom';

    final goalData = goalConfig[goalType]!;

    final double amount = goalData['amount']!.toDouble();
    final int duration = goalData['duration']!.toInt();
    final double rate = goalData['rate']!.toDouble();
    final String name = goalData['name']!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isGoalSaved.value = false;
      controller.initFromGoal(
        amount: goalData['amount'].toDouble(),
        years: goalData['duration'].toDouble(),
        rate: goalData['rate'].toDouble(),
      );
    });

    // Responsive values
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    final contentPadding = isMobile ? 8.0 : (isTablet ? 16.0 : 24.0);

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),
      appBar: CustomAppBarNormal(
        title: 'Create $name Goal',
        action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
        actionsPadding: 15,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 1200 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Column(
                children: [
                  const Gap(12),

                  ///Add Cover
                  CoverSection(),

                  ///Goal Name Select
                  GoalNameSelect(goalName: name, controller: controller),

                  //SIP section
                  SIPSection(amount: amount, duration: duration, rate: rate),
                  const Gap(12),
                  Obx(() {
                    if (!controller.isGoalSaved.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 20,
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
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => controller.isGoalSaved.value
            ? SafeArea(
          top: false,
          child: CartBottomBar(
            ontap: () {
              cartController.monthlyAmount.value =
                  controller.monthlySip.value.toInt();
              controller.selectedPopularFund.isNotEmpty
                  ? Get.toNamed(AppRoutes.cart)
                  : Get.snackbar("Error", "Please select funds to start SIP");
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

class PopularFund extends StatelessWidget {
  PopularFund({super.key});

  final MutualFundController controller = Get.find();
  final GoalSipController goalSipController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Responsive grid columns
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    final gridHeight = isMobile ? 300.0 : (isTablet ? 350.0 : 400.0);
    final childAspectRatio = isMobile ? 1.55 : (isTablet ? 1.4 : 1.3);

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        itemCount: controller.searchFund.length.clamp(0, crossAxisCount * 2),
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
          final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}" ?? '';
          final img1 = fund.amc?.amcLogoUrl ?? '';
          final name = fund.baseSchemeName ?? 'Unknown Name';
          log(img);

          return Obx(
                () => GestureDetector(
              onTap: () {
                log('tap to popular fund');
                final isSelected = goalSipController.isSelectedFund(name);
                log(isSelected.toString());

                goalSipController.toggleFund(name);

                !isSelected
                    ? cartController.addItem(
                  CartItem(
                    fundId: id.toString(),
                    fundName: name,
                    logoUrl: img1,
                  ),
                )
                    : cartController.removeItemByName(name);
                log('call 2');

                log('${goalSipController.selectedPopularFund}');
              },
              child: PopularFundCard(
                borderColor: goalSipController.isSelectedFund(name)
                    ? Ucolors.primary
                    : Ucolors.borderColor,
                isNetwork: true,
                imgPath: img,
                name: name,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProjectionGraph extends StatefulWidget {
  const ProjectionGraph({super.key});

  @override
  State<ProjectionGraph> createState() => _ProjectionGraphState();
}

class _ProjectionGraphState extends State<ProjectionGraph> {
  final List<FlSpot> investedSpots = [
    FlSpot(1, 38208),
    FlSpot(2, 76416),
    FlSpot(3, 114624),
    FlSpot(4, 152832),
    FlSpot(5, 191040),
    FlSpot(6, 229248),
    FlSpot(7, 267456),
    FlSpot(8, 305664),
  ];

  final List<FlSpot> projectedSpots = [
    FlSpot(1, 40649),
    FlSpot(2, 86175),
    FlSpot(3, 137164),
    FlSpot(4, 194273),
    FlSpot(5, 258234),
    FlSpot(6, 329870),
    FlSpot(7, 410103),
    FlSpot(8, 499964),
  ];

  int selectedView = 0;

  List<FlSpot> investedSpotsFromRows(List<ReturnRow> rows) {
    return rows.map((e) {
      return FlSpot(
        double.parse(e.period),
        e.scheme,
      );
    }).toList();
  }

  List<FlSpot> valueSpotsFromRows(List<ReturnRow> rows) {
    return rows.map((e) {
      return FlSpot(
        double.parse(e.period),
        e.category,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    log('build');
    final controller = Get.find<GoalSipController>();

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    final containerPadding = isMobile ? 10.0 : (isTablet ? 15.0 : 20.0);
    final chartHeight = isMobile ? 200.0 : (isTablet ? 250.0 : 300.0);

    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
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
                  color: Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ProjectionIcon(
                      onTap: () {
                        setState(() {
                          selectedView = 0;
                        });
                      },
                      isSelected: selectedView == 0,
                      icon: Icons.trending_up,
                    ),
                    ProjectionIcon(
                      onTap: () {
                        setState(() {
                          selectedView = 1;
                        });
                      },
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
                  style: UTextStyles.small.copyWith(color: Color(0xff868686)),
                ),
                Text(
                  '● Value',
                  style: UTextStyles.small.copyWith(color: Color(0xff213C73)),
                ),
              ],
            ),
            const Gap(25),
            Obx(() {
              final rows = controller.buildYearlyReport();

              if (rows.isEmpty) {
                return SizedBox(
                  height: chartHeight,
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox(
                height: chartHeight,
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
                  TableHeader(
                    heading1: 'Year',
                    heading2: 'Invest',
                    heading3: 'Curent',
                    heading4: 'Profit',
                  ),
                  DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Text(
            title,
            style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w600),
          ),
          Gap(5),
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
    log('build');
    final controller = Get.find<GoalSipController>();

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    final containerPadding = isMobile ? 10.0 : (isTablet ? 15.0 : 20.0);

    return Container(
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Ucolors.light,
        boxShadow: [],
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
            onChanged: (value) {
              controller.setTarget(value);
            },
          ),
          SipSliderTile2(
            title: 'Duration',
            value: duration.toDouble(),
            min: 1,
            max: 30,
            suffix: 'Yrs',
            onChanged: (value) {
              controller.setYears(value);
            },
          ),
          Gap(15),
          SipSliderTile2(
            title: 'Expected Returns',
            value: rate,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (value) {
              log('${controller.futureValue} + future value');
              log('${controller.invested} + Invested');
              log('${controller.monthlySip} + mothly');
              controller.setRate(value);
            },
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

class FrequencySelector extends StatefulWidget {
  const FrequencySelector({super.key});

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  final List<String> item = ['Daily', 'Weekly', 'Monthly', 'Quartly', 'Yearly'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            item.length,
                (index) => InstallmentContainer(
              title: item[index],
              isSelected: selectedIndex == index,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoalNameSelect extends StatelessWidget {
  final GoalSipController controller;
  GoalNameSelect({super.key, required this.goalName, required this.controller});

  final List<String> goal = [
    'Car',
    'Home Purchase',
    'Marriage',
    'Vacation',
    'Education',
    'Bike',
    'Personalize',
    'Other',
  ];

  final String goalName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SmallHeading(smallheading: 'Goal Name')]),
        Gap(5),
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
  const CoverSection({super.key, this.recentPhoto = false});

  final bool recentPhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddCoverBottomSheet(recentPhoto: recentPhoto),
        Gap(5),
        Text('Add Cover', style: UTextStyles.medium),
      ],
    );
  }
}

class AddCoverBottomSheet extends StatelessWidget {
  const AddCoverBottomSheet({super.key, required this.recentPhoto});

  final bool recentPhoto;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final containerSize = isMobile ? 100.0 : 120.0;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding: UPadding.screenPadding,
                child: Column(
                  children: [
                    Text(
                      'Add Cover',
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Photos',
                        style: UTextStyles.medium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Ucolors.dark,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: recentPhoto == true
                          ? SingleChildScrollView(
                        child: Wrap(
                          children: List.generate(
                            4,
                                (index) => Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffF3F4F6),
                              ),
                              child: const Icon(Icons.image),
                            ),
                          ),
                        ),
                      )
                          : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xffF3F4F6),
                              child: Icon(
                                Iconsax.gallery_remove,
                                color: Colors.black,
                              ),
                            ),
                            const Gap(15),
                            Text(
                              'Empty Photo Data',
                              style: UTextStyles.medium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'No recent photos saved',
                              style: UTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    UElevatedBUtton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Take a Photo', style: UTextStyles.buttonText),
                          const Gap(5),
                          const Icon(Iconsax.camera5, color: Ucolors.light),
                        ],
                      ),
                    ),
                    const Gap(12),
                    UElevatedBUtton(
                      outlined: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Upload from Gallery',
                            style: UTextStyles.buttonText.copyWith(
                              color: Ucolors.dark,
                            ),
                          ),
                          const Gap(5),
                          const Icon(
                            Iconsax.document_upload,
                            color: Ucolors.dark,
                          ),
                        ],
                      ),
                    ),
                    const Gap(kBottomNavigationBarHeight - 5),
                  ],
                ),
              ),
            );
          },
          showDragHandle: true,
          useSafeArea: true,
          enableDrag: true,
        );
      },
      child: Container(
        height: containerSize,
        width: containerSize,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(Icons.add, color: Colors.black, size: containerSize * 0.4),
      ),
    );
  }
}

class InstallmentContainer extends StatelessWidget {
  const InstallmentContainer({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Ucolors.primary : Color(0xff64748B),
          ),
        ),
        height: 40,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Ucolors.primary : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}