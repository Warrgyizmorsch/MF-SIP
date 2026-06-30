import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/swp_calculator/formula/swp_formula.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/piechart_with_value.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive

import '../../../../../common/widget/button/elevated_button.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/utils/constant/text_style.dart';
import '../../../../../core/utils/helper/helpers.dart';
import '../../../../../navigation_menu_bar.dart';
import '../../../../fund_details/data/models/return_model.dart';
import '../../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../../fund_details/presentation/widgets/return.dart';

class SwpCalciScreen extends StatefulWidget {
  const SwpCalciScreen({super.key});

  @override
  State<SwpCalciScreen> createState() => _SwpCalciScreenState();
}

class _SwpCalciScreenState extends State<SwpCalciScreen> {
  double initialInvestment = 100000; // Increased default for realistic SWP
  double monthlyWithdrawal = 5000;
  double years = 5;
  double returnRate = 12;

  @override
  Widget build(BuildContext context) {
    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final swp = calculateSwp(
      initialInvestment: initialInvestment,
      monthlyWithdrawal: monthlyWithdrawal,
      years: years.toInt(),
      annualRate: returnRate,
    );

    return Scaffold(
      backgroundColor: isDesktop
          ? const Color(0xFFF5F7FA)
          : Colors.white.withValues(alpha: 0.96),
      appBar: CustomAppBarNormal(
        title: 'SWP Calculator',
        onpressed: () {
          if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
            Get.find<NavigationBarController>().backNested();
          } else {
            Get.back();
          }
        },
      ),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.symmetric(vertical: 30, horizontal: 24)
            : UPadding.screenPadding.copyWith(top: 20, bottom: 20),
        child: Column(
          children: [
            // --- 1. Header/Tabs (Optional for consistency, but simple title is fine here) ---

            // --- 2. Main Layout ---
            isDesktop
                ? Center(
                    child: MaxWidthBox(
                      maxWidth: 1200,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: _buildInputs(isDesktop)),
                          const Gap(30),
                          Expanded(
                            flex: 6,
                            child: _buildResults(isDesktop, swp),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      _buildInputs(isDesktop),
                      const Gap(20),
                      _buildResults(isDesktop, swp),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: isDesktop
          ? null
          : UElevatedBUtton(
              onPressed: () {
                Get.offAllNamed(AppRoutes.navMenuBar);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (Get.isRegistered<NavigationBarController>()) {
                    Get.find<NavigationBarController>().selectedIndex.value = 1;
                  }
                });
              },
              child: Center(
                child: Text("Explore Funds", style: UTextStyles.buttonText),
              ),
            ),
    );
  }

  // =========================================================
  // 🔹 INPUT SECTION (Sliders)
  // =========================================================
  Widget _buildInputs(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 0),
      decoration: isDesktop ? _webCardDecoration() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) ...[
            const Text(
              "Input Details",
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(20),
          ],
          SipSliderTile2(
            title: 'Initial Investment',
            value: initialInvestment,
            min: 10000,
            max: 5000000, // Increased Max
            suffix: null,
            prefix: '₹',
            onChanged: (value) => setState(() => initialInvestment = value),
          ),
          SipSliderTile2(
            title: 'Withdraw per month',
            value: monthlyWithdrawal,
            min: 500,
            max: 200000, // Increased Max
            suffix: null,
            prefix: '₹',
            onChanged: (value) => setState(() => monthlyWithdrawal = value),
          ),
          SipSliderTile2(
            title: 'Over a period of',
            value: years,
            min: 1,
            max: 30,
            suffix: 'Years',
            onChanged: (value) => setState(() => years = value),
          ),
          SipSliderTile2(
            title: 'Expected rate of return',
            value: returnRate,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (value) => setState(() => returnRate = value),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 🔹 RESULTS SECTION (Chart + Table)
  // =========================================================
  Widget _buildResults(bool isDesktop, dynamic swp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Ucolors.light,
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 10),
        border: Border.all(color: Ucolors.borderside),
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Tabs
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
                labelColor: Ucolors.primary,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                tabs: const [
                  Tab(text: 'Visual Rep.'),
                  Tab(text: 'Report'),
                ],
              ),
            ),

            const Gap(20),

            // Views
            SizedBox(
              height: 450,
              child: TabBarView(
                children: [
                  // 1. Visual Chart
                  SingleChildScrollView(
                    child: PieChartWithValue(
                      title1: 'Withdrawn',
                      title2: 'Remaining',
                      piechartvalue1: swp.totalWithdrawn,
                      piechartvalue2: swp.remainingValue,
                      list: [
                        InvestValue(
                          inrFomat: false,
                          title: 'Invest Amount',
                          value: formatCurrency(initialInvestment),
                        ),
                        InvestValue(
                          title: 'Total Withdrawn',
                          inrFomat: false,
                          value: formatCurrency(swp.totalWithdrawn),
                        ),
                        InvestValue(
                          inrFomat: false,
                          title: 'Remaining Value',
                          value: formatCurrency(swp.remainingValue),
                        ),
                        InvestValue(
                          inrFomat: false,
                          title: 'Total Profit',
                          value: formatCurrency(swp.totalProfit),
                        ),
                      ],
                      piechartcolor1: Ucolors.primary,
                      piechartcolor2: Ucolors.primary.withValues(alpha: 0.1),
                    ),
                  ),

                  // 2. Report Table
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Allow vertical scroll
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Allow horizontal scroll for table
                      child: SizedBox(
                        width: 450, // Fixed width to ensure columns align
                        child: Column(
                          children: [
                            const TableHeader(
                              heading1: "Years",
                              heading2: "Withdrawn",
                              heading3: "Profit",
                              heading4: "Remaining",
                            ),
                            DashedLine(
                              dashSpace: 0,
                              color: Ucolors.borderColor,
                            ),

                            // Using a Column here instead of ListView to work inside ScrollView
                            if (swp.report.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No Data Available'),
                              )
                            else
                              Column(
                                children: List.generate(swp.report.length, (i) {
                                  final r = swp.report[i];
                                  return ReturnsTableRow(
                                    percentage: false,
                                    color3: Colors.green,
                                    data: ReturnRow(
                                      period: r.year.toString(),
                                      scheme: r.withdrawn,
                                      category: r.profit,
                                      benchmark: r.remaining,
                                    ),
                                  );
                                }),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _webCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    );
  }
}
