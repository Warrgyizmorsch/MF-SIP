import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/piechart_with_value.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive

import '../../../../fund_details/data/models/return_model.dart';
import '../../../../fund_details/presentation/pages/fund_deatails.dart';
import '../../../../fund_details/presentation/widgets/return.dart';
import 'StepUp/formula/step_up_formula.dart';
import 'StepUp/model/step_up_model.dart';

class TopUpCalculatorPage extends StatefulWidget {
  const TopUpCalculatorPage({super.key});

  @override
  State<TopUpCalculatorPage> createState() => _TopUpCalculatorPageState();
}

class _TopUpCalculatorPageState extends State<TopUpCalculatorPage> {
  double baseAmount = 500;
  double stepUpValue = 500;
  int years = 10;
  double returnRate = 12;

  StepUpType stepUpType = StepUpType.amount;

  @override
  Widget build(BuildContext context) {
    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final result = simulateStepUpSip(
      baseMonthly: baseAmount,
      stepUpType: stepUpType,
      stepUpValue: stepUpValue,
      years: years,
      annualRate: returnRate,
    );

    final summaryRows = [
      ReturnRow(
        period: 'Normal SIP',
        scheme: result.normal.invested,
        category: result.normal.value,
        benchmark: result.normal.profit,
      ),
      ReturnRow(
        period: 'Stepup SIP',
        scheme: result.stepUp.invested,
        category: result.stepUp.value,
        benchmark: result.stepUp.profit,
      ),
    ];

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white.withOpacity(0.96),
      appBar: CustomAppBarNormal(title: 'SIP Top-Up Calculator'),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.symmetric(vertical: 30, horizontal: 24)
            : UPadding.screenPadding.copyWith(top: 20, bottom: 20),
        child: Column(
          children: [
            if (isDesktop)
              Center(
                child: MaxWidthBox(
                  maxWidth: 1200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildInputs(isDesktop)),
                      const Gap(30),
                      Expanded(flex: 6, child: _buildResults(isDesktop, result, summaryRows)),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  _buildInputs(isDesktop),
                  const Gap(20),
                  _buildResults(isDesktop, result, summaryRows),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 🔹 INPUT SECTION
  // =========================================================
  Widget _buildInputs(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 0),
      decoration: isDesktop ? _webCardDecoration() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) ...[
            const Text("Input Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Gap(20),
          ],
          SipSliderTile2(
            title: 'I want to invest (per month)',
            value: baseAmount,
            min: 500,
            max: 100000,
            suffix: null,
            prefix: '₹',
            onChanged: (value) => setState(() => baseAmount = value),
          ),
          SipSliderTile3(
            key: const ValueKey('sip_stepup_rate'),
            title: 'Increase SIP every year',
            value: stepUpValue,
            pMin: 1, pMax: 30,      // % Range
            rMin: 100, rMax: 50000,
            onChanged: (value) => setState(() => stepUpValue = value),
          ),
          SipSliderTile2(
            title: 'Over a period of',
            value: years.toDouble(),
            min: 1,
            max: 30,
            suffix: 'Years',
            onChanged: (value) => setState(() => years = value.toInt()),
          ),
          SipSliderTile2(
            title: 'Expected rate of return',
            value: returnRate,
            min: 1,
            max: 20,
            suffix: '%',
            onChanged: (value) => setState(() => returnRate = value),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 🔹 RESULTS SECTION (Summary + Tabs)
  // =========================================================
  Widget _buildResults(bool isDesktop, StepUpSipResult result, List<ReturnRow> summaryRows) {
    return Column(
      children: [
        // 1. SUMMARY TABLE CARD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Ucolors.borderside),
            boxShadow: isDesktop
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Normal vs Step-up Summary', style: UTextStyles.large.copyWith(fontWeight: FontWeight.bold)),
              const Gap(15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: isDesktop ? 600 : 400,
                  child: Column(
                    children: [
                      TableHeader(
                        width: 100,
                        heading1: 'Metric',
                        heading2: 'Invested',
                        heading3: 'Future',
                        heading4: 'Profit',
                      ),
                      DashedLine(color: Colors.grey.shade300, dashSpace: 0),
                      ...summaryRows.map(
                            (e) => ReturnsTableRow(
                          width: 100,
                          color4: Colors.green.shade600,
                          data: e,
                          percentage: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const Gap(24),

        // 2. DETAILED TABS CARD
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          decoration: BoxDecoration(
            color: Ucolors.light,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Ucolors.borderside),
            boxShadow: isDesktop ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
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
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                    ),
                    tabs: const [
                      Tab(text: 'Visual Rep.'),
                      Tab(text: 'Report'),
                    ],
                  ),
                ),

                const Gap(20),

                // Tab Views
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      // A. Visual Rep
                      SingleChildScrollView(
                        child: PieChartWithValue(
                          title1: 'Step-up Invested',
                          title2: 'Step-up Profit',
                          list: [
                            InvestValue(
                              inrFomat: false,
                              color: Colors.black87,
                              title: 'Step-up Invested',
                              value: formatIndianNumber(result.stepUp.invested),
                            ),
                            InvestValue(
                              color: Colors.black87,
                              title: 'Step-up Future Value',
                              inrFomat: false,
                              value: formatIndianNumber(result.stepUp.value),
                            ),
                            InvestValue(
                              color: Colors.black87,
                              title: 'Step-up Profit',
                              inrFomat: false,
                              value: formatIndianNumber(result.stepUp.profit),
                            ),
                          ],
                          piechartvalue1: result.stepUp.invested,
                          piechartvalue2: result.stepUp.profit,
                          piechartcolor1: Ucolors.primary,
                          piechartcolor2: Ucolors.primary.withOpacity(0.1),
                        ),
                      ),

                      // B. Report Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: isDesktop ? 800 : 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TableHeader(
                                heading1: 'Years',
                                heading2: 'Invested',
                                heading3: 'Normal',
                                heading4: 'Step-up',
                                heading5: 'Extra',
                              ),
                              DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                              SizedBox(
                                height: 350,
                                child: ListView.builder(
                                  itemCount: result.detailRows.length,
                                  itemBuilder: (_, i) {
                                    final r = result.detailRows[i];
                                    return ReturnsTableRow(
                                      percentage: false,
                                      color5: Ucolors.success,
                                      data: ReturnRow(
                                        period: r.year.toString(),
                                        scheme: r.stepInvested,
                                        category: r.normalValue,
                                        benchmark: r.stepValue,
                                        extra: r.extraGain,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _webCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
      border: Border.all(color: Colors.grey.shade200),
    );
  }
}