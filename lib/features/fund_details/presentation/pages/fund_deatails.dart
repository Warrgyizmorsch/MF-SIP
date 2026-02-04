import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import 'package:readmore/readmore.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../dashboard/presentation/pages/comparison_screen.dart';
import '../../../dashboard/presentation/pages/dashboard.dart';
import '../../data/models/fund_performance.dart';
import '../../data/models/return_model.dart';
import '../controllers/fund_details_controller.dart';
import '../widgets/fund_performance_bar.dart';
import '../widgets/percentage_indicator.dart';
import '../widgets/return.dart';
import '../widgets/risk_indicator_ball.dart';
import '../widgets/schemeLineChart.dart';
import '../widgets/stock_allocation_items.dart';
import '../widgets/timeselecter.dart';

class FundDetailsScreen extends GetView<FundDetailsController> {
  const FundDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Ucolors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Loading fund details...',
                        style: TextStyle(color: Ucolors.darkgrey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Show error state
        if (controller.hasError.value) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.info_circle, size: 64, color: Ucolors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load fund details',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Ucolors.darkgrey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: controller.retryFetchingDetails,
                          icon: const Icon(Iconsax.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (controller.fundDetail.value!.riskStatisticsList.isEmpty) {
          return Center(
            child: TextButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Data not available ',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text('Go Back'),
                ],
              ),
              onPressed: () => Get.back(),
            ),
          );
        }

        // Show data state
        return CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            _buildAppBar(),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            _buildFundHeader(context),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Use GetBuilder for the TabBar to react to index changes
            GetBuilder<FundDetailsController>(
              id: 'tabs',
              builder: (controller) => SliverPersistentHeader(
                pinned: true,
                delegate: SliverPageTabs(
                  selectedIndex: controller.tabController.index,
                  onTap: (index) => controller.scrollToIndex(index),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: OverviewScreen(
                overViewKey: controller.overViewKey,
                returnsKey: controller.returnsKey,
                riskKey: controller.riskKey,
                portfolioKey: controller.portfolioKey,
                infoKey: controller.infoKey,
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        // Only show bottom bar when data is loaded successfully
        if (controller.isLoading.value || controller.hasError.value) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          top: false,
          child: controller.fundDetail.value!.riskStatisticsList.isNotEmpty
              ? BottomBarButton(
                  firstButton: 'Lumpsum',
                  secondButton: 'Start SIP',
                )
              : SizedBox.shrink(),
        );
      }),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        actionsPadding: 10,
        title: 'Fund Details',
        action: [
          CompactIcon(
            icon: Iconsax.shopping_cart,
            onPressed: () => Get.toNamed(AppRoutes.cart),
          ),
          CompactIcon(
            icon: Iconsax.archive_tick,
            onPressed: () => Get.toNamed(AppRoutes.watchlist),
          ),
        ],
      ),
    );
  }

  Widget _buildFundHeader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Obx(() {
          final fund = controller.fundDetail.value;
          createLog("Fund is $fund");
          log('$fund');

          return Column(
            children: [
              Row(
                children: [
                  // Using your helper logic or CustomCachedImage helper provided earlier
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: controller.imgUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      fund?.schemeName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _metaText(fund?.schemeCategory ?? 'Equity'),
                  _dot(),
                  // _metaText(fund?.schemeCategory.toUpperCase() ?? 'Large cap'),
                  // _dot(),
                  _metaText(
                    fund?.riskometerValue.toUpperCase() ?? 'Very High',
                    color: _getRiskColor(fund?.riskometerValue ?? ''),
                  ),
                  _dot(),
                  _metaText('STATUS:'),
                  _metaText(
                    fund?.schemeStatus.toUpperCase().split(" ")[0] ?? 'Open',
                    color: (fund?.schemeStatus == 'Open Ended Schemes')
                        ? Ucolors.success
                        : Ucolors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    final riskLower = risk.toLowerCase();
    if (riskLower.contains('very high') || riskLower.contains('veryhigh')) {
      return Ucolors.red;
    } else if (riskLower.contains('high')) {
      return Colors.orange;
    } else if (riskLower.contains('moderate')) {
      return Colors.yellow[700]!;
    } else if (riskLower.contains('low')) {
      return Ucolors.success;
    }
    return Ucolors.darkgrey;
  }
}

class OverviewScreen extends GetView<FundDetailsController> {
  final GlobalKey overViewKey;
  final GlobalKey returnsKey;
  final GlobalKey riskKey;
  final GlobalKey portfolioKey;
  final GlobalKey infoKey;
  const OverviewScreen({
    super.key,
    required this.overViewKey,
    required this.returnsKey,
    required this.riskKey,
    required this.portfolioKey,
    required this.infoKey,
  });

  @override
  Widget build(BuildContext context) {
    final returns = [
      ReturnRow(period: '1M', scheme: 0.78, category: 0.01, benchmark: -0.13),
      ReturnRow(period: '3M', scheme: 3.77, category: 4.93, benchmark: 4.29),
      ReturnRow(period: '6M', scheme: 3.77, category: 2.68, benchmark: 2.02),
      ReturnRow(period: '1Y', scheme: 7.86, category: 9.93, benchmark: 6.99),
      ReturnRow(period: '2Y', scheme: 13.91, category: 11.62, benchmark: 11.14),
      ReturnRow(period: '3Y', scheme: 19.54, category: 14.72, benchmark: 15.23),
      ReturnRow(period: '5Y', scheme: 20.26, category: 14.86, benchmark: 14.37),
    ];

    final yearlyData = [
      YearlyReturn('2019', 6.63),
      YearlyReturn('2020', 4.89),
      YearlyReturn('2021', 31.65),
      YearlyReturn('2022', 9.72),
      YearlyReturn('2023', 31.44),
      YearlyReturn('2024', 13.54),
      YearlyReturn('2025', 7.91),
      YearlyReturn('2026', 0.69),
    ];

    final height = MediaQuery.of(context).size;

    return Obx(() {
      final fund = controller.fundDetail.value;
      final managers = parseFundManagers(fund?.schemeManager);

      final risk = getRiskMeter(fund?.riskometerValue);

      return Column(
        children: [
          CustomContainer(
            topPadding: 15,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatItem1(
                      title: 'Nav',
                      amount: '${fund?.nav.toString()}',
                      percentage: '',
                    ),
                    StatItem1(
                      title: 'Returns (1Y)',
                      amount:
                          fund?.schemePerformanceList[0].oneYearReturn
                              .toString() ??
                          '',
                      amountColor: Ucolors.success,

                      percentage: '%',
                    ),
                    StatItem1(
                      title: 'BenchMark (1Y)',
                      amount: fund?.benchmarkInceptionReturn.toString() ?? '',
                      percentage: '%',
                      amountColor: Ucolors.success,
                    ),
                  ],
                ),
                SchemeLineChart(),
                Gap(12),
                PeriodSelector(),
              ],
            ),
          ),

          // --- Fund Overview Section ---
          Padding(
            key: overViewKey,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: const USectionHeading(
              title: 'Fund Overview',
              showActionButton: false,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Ucolors.light,
                border: Border.all(color: Ucolors.borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _twoColumnRow(
                    leftTitle: 'Min SIP',
                    leftValue: '₹ ${fund?.sipMinimumAmount.toString()}',
                    rightTitle: 'Min lumpsum',
                    rightValue: '₹ ${fund?.minimumInvestment.toString()}',
                  ),
                  const SizedBox(height: 10),
                  _twoColumnRow(
                    leftTitle: 'Expense Ratio',
                    leftValue: '${fund?.expenseRatioPercentage.toString()}%',
                    rightTitle: 'AUM',
                    rightValue: '₹ ${fund?.schemeAssets.toString()} Cr',
                  ),
                  const SizedBox(height: 10),
                  _twoColumnRow(
                    leftTitle: 'Lock In',
                    leftValue: 'No Lock-in',
                    rightTitle: 'Launch Date',
                    rightValue: fund?.schemeInceptionDate.toString() ?? '',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Exit Load:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  ReadMoreText(
                    fund?.exitLoad.toString() ??
                        '', // 'Nippon India Large Cap Fund – Growth charges 1.0% of sell value; if fund sold before 7 days. There are no other charges.',
                    trimMode: TrimMode.Line,
                    trimLines: 1,
                    trimCollapsedText: 'Show More',
                    trimExpandedText: 'Show Less',
                    colorClickableText: Ucolors.primary,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 5),
            child: const USectionHeading(
              title: 'Quick look',
              showActionButton: false,
            ),
          ),
          CustomContainer(
            bottomPadding: 10,
            topPadding: 10,
            child: _twoColumnRow(
              leftTitle: '5Y CAGR',
              color: Ucolors.success,
              leftValue: '20.23%',
              rightTitle: '5Y SIP Return',
              rightValue:
                  '${fund?.schemePerformanceList[0].fiveYearReturn.toString()} %',
              color2: Ucolors.success,
            ),
          ),
          // Gap(10),
          Padding(
            key: returnsKey,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: const USectionHeading(
              title: 'Trailing Returns',
              showActionButton: false,
            ),
          ),
          CustomContainer(
            child: Column(
              children: [
                // returnsTableHeader(),
                TableHeader(
                  heading1: 'Period',
                  heading2: 'Scheme',
                  heading3: 'Category',
                  heading4: 'Benchmark',
                ),
                DashedLine(color: Colors.grey.shade200),

                ...returns.map((row) => ReturnsTableRow(data: row)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 5),
            child: const USectionHeading(
              title: 'Fund Performance',
              showActionButton: false,
            ),
          ),
          CustomContainer(
            child: SizedBox(
              height: 160,
              // child: ReturnsBarChart(data: yearlyData),
              // child: ,
              child: Obx(() {
                final data = controller.yearlyReturns;
                if (data.isEmpty) {
                  return const CircularProgressIndicator(); // or loader
                }
                return YearlyReturnsChart(yearlyData: data);
              }),
            ),
          ),

          // --- Risk Analysis Section ---
          Padding(
            key: riskKey,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: const USectionHeading(
              title: 'Risk Analysis',
              showActionButton: false,
            ),
          ),

          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(15),
                _twoColumnRow(
                  leftTitle: 'Risk-o-Meter',
                  leftValue: fund?.riskometerValue.toString() ?? '',
                  // leftValue: risk.label,
                  rightTitle: 'Volatile',
                  rightValue:
                      fund?.riskStatisticsList[0].volatilityCm3Year
                          .toString() ??
                      '',

                  color: risk.color,
                ),
                Gap(10),
                _twoColumnRow(
                  leftTitle: 'Shape Ratio:',
                  leftValue:
                      fund?.riskStatisticsList[0].sharpeRatioCm3Year
                          .toString() ??
                      '',
                  rightTitle: 'Beta',
                  rightValue:
                      fund?.riskStatisticsList[0].beteCm1Y.toString() ?? '',
                ),
                Gap(12),
                DashedLine(color: Colors.grey.shade400),

                SpeedometerGauge(
                  value: risk.needleValue.toDouble(),
                ), // Updated to show high risk
                Text(
                  'Your Principle Will be at:',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  fund?.riskometerValue.toString() ?? '',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,

                    color: risk.color,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Suitable for aggressive investors and investors with very high-risk tolerance.',
                  textAlign: TextAlign.center,
                  style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
                ),
                const Gap(14),
                DashedLine(color: Colors.grey.shade400),
                Gap(12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiskLegendItem(color: Colors.green, label: 'Very Low'),
                        SizedBox(height: 14),
                        RiskLegendItem(color: Colors.orange, label: 'Medium'),
                        SizedBox(height: 14),
                        RiskLegendItem(color: Colors.redAccent, label: 'High'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RiskLegendItem(color: Colors.lightGreen, label: 'Low'),
                        SizedBox(height: 14),
                        RiskLegendItem(
                          color: Colors.amber,
                          label: 'Moderate High',
                        ),
                        SizedBox(height: 14),
                        RiskLegendItem(color: Colors.red, label: 'Very High'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            key: portfolioKey,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: const USectionHeading(
              title: 'Fund Allocation',
              showActionButton: false,
            ),
          ),

          CustomContainer(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Market Cap',
                  style: UTextStyles.medium.copyWith(
                    color: Ucolors.dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Divider(color: Colors.grey.shade200),

                Gap(10),
                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: PieChart(
                        PieChartData(
                          centerSpaceColor: Colors.grey.shade200,
                          sectionsSpace: 0,

                          centerSpaceRadius: 50,
                          // centerSpaceRadius: 0,
                          sections: [
                            PieChartSectionData(
                              showTitle: false,

                              value: 70,
                              color: Colors.indigo.shade900,
                            ),
                            PieChartSectionData(
                              showTitle: false,
                              value: 10,
                              color: Colors.deepPurpleAccent,
                            ),
                            PieChartSectionData(
                              showTitle: false,

                              value: 5,
                              color: Colors.greenAccent,
                            ),
                            PieChartSectionData(
                              showTitle: false,

                              value: 15,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 55,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Equity Market Cap',
                            style: UTextStyles.medium.copyWith(
                              color: Ucolors.dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                marketCapPercentage(
                  'Large Cap',
                  '70.4%',
                  Colors.indigo.shade700,
                ),
                Gap(5),
                marketCapPercentage('Equity', '10.4%', Colors.deepPurpleAccent),
                Gap(5),
                marketCapPercentage('Mid Cap', '5.4%', Colors.greenAccent),
                Gap(5),
                marketCapPercentage('Small Cap', '15.4%', Colors.green),
                Gap(12),
                Divider(color: Colors.grey.shade200),
                Gap(10),

                DefaultTabController(
                  animationDuration: Duration(milliseconds: 200),

                  length: 2,

                  child: Column(
                    children: [
                      Container(
                        // height: 44,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,

                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Tab(
                          child: TabBar(
                            // tabAlignment: TabAlignment.fill,
                            // textScaler: TextScaler.noScaling,
                            labelStyle: UTextStyles.buttonText.copyWith(
                              color: Ucolors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            // isScrollable: true,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.blue,
                            indicatorSize: TabBarIndicatorSize.tab,
                            // isScrollable: true,
                            unselectedLabelColor: Colors.grey,
                            indicator: BoxDecoration(
                              // color: Colors.white,
                              color: Ucolors.light,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Text('Top 5 Sector'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Text('Top 5 Stock'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child: TabBarView(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Gap(20),
                                PercentageBar(
                                  title: 'Financial Services',
                                  percentage: 42,
                                  color: Ucolors.primary,
                                ),

                                PercentageBar(
                                  title: 'Energy',
                                  percentage: 80,
                                  color: Ucolors.primary,
                                ),
                                PercentageBar(
                                  title: 'Technolgy',
                                  percentage: 42,
                                  color: Ucolors.primary,
                                ),
                                PercentageBar(
                                  title: 'Consumer Defensive',
                                  percentage: 42,
                                  color: Ucolors.primary,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Gap(12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Stocks Allocation',
                                        style: UTextStyles.caption,
                                      ),
                                      Text(
                                        '% Holdings',
                                        style: UTextStyles.caption,
                                      ),
                                    ],
                                  ),

                                  Gap(5),
                                  StockAllocationItem(
                                    name: 'HDFC Bank Ltd',
                                    category: 'Large Cap',
                                    sector: 'Financial Services',
                                    percentage: 9.08,
                                  ),
                                  StockAllocationItem(
                                    name: 'Reliance Industries Ltd',
                                    category: 'Large Cap',
                                    sector: 'Energy',
                                    percentage: 6.08,
                                  ),
                                  StockAllocationItem(
                                    name: 'ICICI Bank Ltd',
                                    category: 'Large Cap',
                                    sector: 'Financial Services',
                                    percentage: 5.54,
                                  ),
                                  StockAllocationItem(
                                    name: 'Axis Bank Ltd',
                                    category: 'Large Cap',
                                    sector: 'Financial Services',
                                    percentage: 3.97,
                                  ),
                                  StockAllocationItem(
                                    name: 'State Bank of India',
                                    category: 'Large Cap',
                                    sector: 'Financial Services',
                                    percentage: 3.81,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Fund Comparison Section ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: const USectionHeading(
              title: 'Fund Comparison',
              showActionButton: false,
            ),
          ),
          SizedBox(
            // height:   MediaQuery.of(context).size.height * 0.3,
            // height: MediaQuery.of(context).size.height * 0.23,
            height: MediaQuery.of(context).size.height < 700 ? 210 : 195,

            child: ListView.builder(
              // itemCount: 10,
              itemCount: fund!.schemePeerComparisonList.length - 1,
              scrollDirection: Axis.horizontal,

              itemBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.97,
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.comparefund),
                  child: CustomContainer(
                    bottomPadding: 8,
                    topPadding: 15,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        FundComparisonItem(
                          imgUrl: controller.imgUrl,
                          fund1: fund?.schemeName,
                          year: fund?.schemePerformanceList[0].threeYearReturn
                              .toString(),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            // Left dashed line
                            Expanded(
                              child: DashedLine(color: Colors.blue.shade200),
                            ),

                            // VS circlef
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                'VS',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Right dashed line
                            Expanded(
                              child: DashedLine(color: Colors.blue.shade200),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        FundComparisonItem(
                          year: fund
                              .schemePeerComparisonList[index + 1]
                              .threeYearReturn
                              .toString(),
                          fund1: fund
                              ?.schemePeerComparisonList[index + 1]
                              .schemeName
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Ucolors.primary.withOpacity(0.5)),
              ),
              onPressed: () => Get.toNamed(AppRoutes.comparefund),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Compare Funds',
                    style: UTextStyles.buttonText.copyWith(
                      color: Ucolors.primary.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward,
                    color: Ucolors.primary.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),

          // --- Related Funds Section ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: const USectionHeading(
              title: 'Related Funds',
              showActionButton: false,
            ),
          ),

          // Add your Related Funds list here
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: fund.schemePeerComparisonList.length - 1,
              separatorBuilder: (context, index) => SizedBox(width: 0),
              itemBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,

                child: GestureDetector(
                  // onTap: () => Get.toNamed(AppRoutes.funddetails),
                  onTap: () {
                    final scheme = fund
                        .schemePeerComparisonList[index + 1]
                        .schemeName
                        .toString();
                    log('tap ${scheme}');

                    Get.offAndToNamed(
                      AppRoutes.funddetails,
                      arguments: {'scheme': scheme, 'imgUrl': Appurl.baseUrl2},
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// 🔹 Top Row (Icon + Title + Menu)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // / Fund Icon
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade100,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  UImages.imp,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // CircleAvatar(backgroundImage: AssetImage(UImages.sbi)),
                            const SizedBox(width: 12),

                            /// Title + Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxLines: 2,
                                    fund
                                        .schemePeerComparisonList[index + 1]
                                        .schemeName,
                                    // 'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Menu
                            // const Icon(Icons.more_vert, color: Colors.grey),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// 🔹 Bottom Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatItem1(
                              title: '1Y Returns',
                              amount:
                                  '${fund.schemePeerComparisonList[index].oneYearReturn.toString()}%',
                              //  fund
                              //     .schemePeerComparisonList[index]
                              //     .oneYearReturn
                              //     .toString(),
                              percentage: '',
                              amountColor: Colors.green.shade800,

                              percentageColor: Ucolors.success,
                            ),
                            StatItem1(
                              percentage: '',
                              title: '3Y Returns',
                              // amount: '43%',
                              amount:
                                  '${fund.schemePeerComparisonList[index].threeYearReturn.toString()}%',
                              amountColor: Colors.green.shade800,
                              percentageColor: Ucolors.success,
                            ),

                            StatItem1(
                              percentage: '',
                              title: '5Y Returns',
                              amountColor: Colors.green.shade800,

                              percentageColor: Ucolors.success,

                              amount:
                                  '${fund.schemePeerComparisonList[index].fiveYearReturn.toString()}%',

                              // '35%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            key: infoKey,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: const USectionHeading(
              title: 'About this Fund',
              showActionButton: false,
            ),
          ),
          CustomContainer(
            topPadding: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadMoreText(
                  style: UTextStyles.medium,
                  fund?.schemeObjective.toString() ?? '',
                  // 'Quant Small Cap Fund - Direct Plan - Growth is a Small Cap scheme. The fund is currently managed by Jeetu Vechha. This content is a placeholder — you can replace it with your API description.',
                  trimMode: TrimMode.Line,
                  trimLines: 2,
                  trimCollapsedText: 'Show More',
                  trimExpandedText: 'Show Less',
                  colorClickableText: Ucolors.primary,
                ),
                SizedBox(height: 5),
                Text(
                  'Fund Manager',
                  style: UTextStyles.large.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (managers['fm1']!.isNotEmpty) ...[
                  fundManager(managers['fm1'] ?? ''),
                ],
                if (managers['fm2']!.isNotEmpty) ...[
                  DashedLine(color: Colors.grey.shade300),

                  fundManager(managers['fm2'] ?? ''),

                  // DashedLine(color: Colors.grey.shade300),
                ],
              ],
            ),
          ),

          ///Investment Details
          ExpansionTile(
            shape: Border(),
            collapsedShape: Border(),
            // dense: true,
            title: Text('Invesment Details'),
            children: [
              CustomContainer(
                bottomPadding: 0,
                child: Column(
                  children: [
                    investmentDetailSection(
                      'Fund Size',
                      fund?.schemeAssets.toString() ?? '',
                      Icons.bar_chart,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Min Investement',
                      '₹ ${fund?.minimumInvestment.toString()}',
                      Icons.circle,
                    ),

                    Divider(height: 0),
                    investmentDetailSection(
                      'Turn over',
                      '23',
                      Icons.lightbulb_circle_rounded,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Expense Ratio',
                      fund?.expenseRatioPercentage.toString() ?? '',
                      Icons.pie_chart,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Exit Load',
                      fund?.exitLoad.toString() ?? '',
                      Icons.logout_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///Basic Details
          ExpansionTile(
            shape: Border(),
            collapsedShape: Border(),
            // dense: true,
            title: Text('Basic Details'),
            children: [
              CustomContainer(
                bottomPadding: 0,
                child: Column(
                  children: [
                    investmentDetailSection(
                      'Category',
                      fund?.schemeCategory.split(':')[0].toString() ?? '',
                      Icons.bar_chart,
                    ),
                    Divider(height: 0),
                    investmentDetailSection('KRA', 'KARVY', Icons.circle),

                    Divider(height: 0),
                    investmentDetailSection(
                      'Inv. Plan',
                      fund?.schemeName.split('-')[1].toString() ?? '',
                      Icons.lightbulb_circle_rounded,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Launched IN',
                      fund?.schemeInceptionDate.toString() ?? '',
                      Icons.pie_chart,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Bench Mark',
                      fund?.schemeBenchmarkCode.toString() ?? '',
                      Icons.logout_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),

          //AMC Information
          ExpansionTile(
            shape: Border(),
            collapsedShape: Border(),
            // dense: true,
            title: Text('AMC Inforamtion'),
            children: [
              CustomContainer(
                bottomPadding: 0,
                child: Column(
                  children: [
                    investmentDetailSection(
                      'AMC',
                      fund?.schemeCompany.toString() ?? '',
                      Icons.bar_chart_rounded,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Email',
                      'abc.warrgyizmorch@gmail.com',
                      Icons.mail_outline,
                    ),

                    Divider(height: 0),
                    investmentDetailSection(
                      'Office No',
                      '1876471871',
                      Icons.home_work_outlined,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Website',
                      'http://www.google.com',
                      Iconsax.global,
                    ),
                    Divider(height: 0),
                    investmentDetailSection(
                      'Address',
                      '',
                      Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget marketCapPercentage(String title, String value, Color? color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '● $title',
          style: UTextStyles.medium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: UTextStyles.medium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget investmentDetailSection(String title, String value, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      dense: true,
      isThreeLine: false,
      title: Row(
        children: [
          Icon(icon, color: Ucolors.blue),
          Gap(8),
          Text(
            title,
            style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
      trailing: Text(
        value,
        style: UTextStyles.medium.copyWith(
          fontWeight: FontWeight.w600,
          color: Ucolors.dark,
        ),
      ),
    );
  }

  Widget fundManager(String name) {
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: Ucolors.skyblue1,
        child: Icon(Icons.person, color: Ucolors.dark, size: 13),
      ),
      title: Text(
        name,
        style: UTextStyles.medium.copyWith(
          fontWeight: FontWeight.w600,
          color: Ucolors.dark,
        ),
      ),
      trailing: CompactIcon(
        icon: Icons.arrow_forward_ios_rounded,
        iconColor: Ucolors.darkgrey,
        iconSize: 15,

        onPressed: () {},
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.color = Colors.blue,
    this.height = 1,
    this.dashWidth = 6,
    this.dashSpace = 4,
  });

  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}

class FundComparisonItem extends StatelessWidget {
  const FundComparisonItem({super.key, this.fund1, this.imgUrl, this.year});

  final String? fund1;
  final String? imgUrl;
  final String? year;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // / Fund Icon
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: ClipOval(
                // child: Image.asset(UImages.sbi, fit: BoxFit.cover),
                child: CustomCachedImage(imageUrl: '$imgUrl'),
              ),
            ),

            // CircleAvatar(backgroundImage: AssetImage(UImages.sbi)),
            const SizedBox(width: 12),

            /// Title + Subtitle
            Flexible(
              child: Text(
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                fund1 ??
                    'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),

            /// Menu
            // const Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '3Y Return :',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Ucolors.darkgrey,
                ),
              ),
              const TextSpan(text: '  '),
              TextSpan(
                text: '$year%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Ucolors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeedometerGauge extends StatelessWidget {
  final double value; // 0–100

  const SpeedometerGauge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,

      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 180,
            endAngle: 0,
            centerY: 0.8,
            radiusFactor: 1,
            showTicks: false,
            showLabels: false,

            axisLineStyle: const AxisLineStyle(
              thickness: 0,
              color: Colors.transparent,
            ),

            ranges: [
              GaugeRange(
                startValue: 0,
                endValue: 18,
                color: Colors.green,
                startWidth: 14,
                endWidth: 14,
              ),
              GaugeRange(
                startValue: 18,
                endValue: 20,
                color: Colors.transparent,
              ),

              GaugeRange(
                startValue: 20,
                endValue: 38,
                color: Colors.lightGreen,
                startWidth: 14,
                endWidth: 14,
              ),
              GaugeRange(
                startValue: 38,
                endValue: 40,
                color: Colors.transparent,
              ),

              GaugeRange(
                startValue: 40,
                endValue: 58,
                color: Colors.amber,
                startWidth: 14,
                endWidth: 14,
              ),
              GaugeRange(
                startValue: 58,
                endValue: 60,
                color: Colors.transparent,
              ),

              GaugeRange(
                startValue: 60,
                endValue: 78,
                color: Colors.orange,
                startWidth: 14,
                endWidth: 14,
              ),
              GaugeRange(
                startValue: 78,
                endValue: 80,
                color: Colors.transparent,
              ),

              GaugeRange(
                startValue: 80,
                endValue: 100,
                color: Colors.red,
                startWidth: 14,
                endWidth: 14,
              ),
            ],

            pointers: [
              NeedlePointer(
                value: value,
                needleLength: 0.6,
                needleStartWidth: 1,
                needleEndWidth: 4,
                needleColor: Colors.black,
                knobStyle: const KnobStyle(
                  color: Colors.black,
                  knobRadius: 0.06,
                ),
              ),
            ],
          ),
        ],
      ),

      //  SfRadialGauge(
      //   // backgroundColor: Colors.green,
      //   axes: [
      //     RadialAxis(
      //       // interval: 3,
      //       radiusFactor: 1,
      //       centerY: 0.8,

      //       // centerX: 0,
      //       minimum: 0,
      //       maximum: 100,
      //       startAngle: 180,
      //       endAngle: 0,
      //       showTicks: false,
      //       showLabels: false,

      //       axisLineStyle: const AxisLineStyle(
      //         thickness: 0.15,

      //         thicknessUnit: GaugeSizeUnit.factor,
      //         color: Colors.transparent,
      //       ),

      //       // COLOR SEGMENTS
      //       ranges: [
      //         GaugeRange(
      //           startValue: 0,
      //           endValue: 20,
      //           color: Colors.green,
      //           startWidth: 15,
      //           endWidth: 15,
      //         ),
      //         GaugeRange(
      //           startValue: 20,
      //           endValue: 40,
      //           color: Colors.lightGreen,
      //           startWidth: 15,
      //           endWidth: 15,
      //         ),
      //         GaugeRange(
      //           startValue: 40,
      //           endValue: 60,
      //           color: Colors.yellow,
      //           startWidth: 15,
      //           endWidth: 15,
      //         ),
      //         GaugeRange(
      //           startValue: 60,
      //           endValue: 80,
      //           color: Colors.orange,
      //           startWidth: 15,
      //           endWidth: 15,
      //         ),
      //         GaugeRange(
      //           startValue: 80,
      //           endValue: 100,
      //           color: Colors.red,
      //           startWidth: 15,
      //           endWidth: 15,
      //         ),
      //       ],

      //       // NEEDLE
      //       pointers: [
      //         NeedlePointer(
      //           value: value,
      //           needleLength: 0.6,
      //           needleStartWidth: 1,
      //           needleEndWidth: 4,
      //           needleColor: Colors.black,
      //           knobStyle: const KnobStyle(
      //             color: Colors.black,
      //             knobRadius: 0.06,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.child,
    this.topPadding = 4,
    this.bottomPadding = 15,
    this.height,
    this.width,
  });

  final Widget child;
  final double topPadding;
  final double bottomPadding;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.fromLTRB(15, topPadding, 15, bottomPadding),
        decoration: BoxDecoration(
          color: Ucolors.light,
          border: Border.all(color: Ucolors.borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

Widget _twoColumnRow({
  required String leftTitle,
  required String leftValue,
  required String rightTitle,
  required String rightValue,
  Color? color,
  Color? color2,
}) {
  return Row(
    children: [
      Expanded(child: _infoItem(leftTitle, leftValue, color)),
      Expanded(child: _infoItem(rightTitle, rightValue, color2)),
    ],
  );
}

Widget _infoItem(String title, String value, Color? color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 12, color: Ucolors.darkgrey)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    ],
  );
}

class SliverPageTabs extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  static final ScrollController _scrollController = ScrollController();

  SliverPageTabs({required this.selectedIndex, required this.onTap});

  final tabs = const [
    'Overview',
    'Returns',
    'Risk',
    'Portfolio',
    'Information',
  ];
  // Logic to move the horizontal list automatically
  void _scrollToActiveTab() {
    if (_scrollController.hasClients) {
      // 100.0 is an estimated width per tab item
      double offset = selectedIndex * 90.0;
      double target = offset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  bool shouldRebuild(covariant SliverPageTabs oldDelegate) {
    // This forces the header to rebuild when the index passed from parent changes
    return oldDelegate.selectedIndex != selectedIndex;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActiveTab());
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      // padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(
                  //   color: isSelected ? Colors.white : Colors.grey.shade300,
                  // ),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Ucolors.primary : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;
}

Widget _dot() {
  return const Text('•', style: TextStyle(fontSize: 12, color: Colors.grey));
}

Widget _metaText(
  String text, {
  Color color = Colors.grey,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return Text(
    text,
    style: TextStyle(fontSize: 12, color: color, fontWeight: fontWeight),
  );
}
