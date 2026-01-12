import 'package:flutter/material.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/return.dart';
// import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/formula/swp_%20calculator.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/swp_calculator/formula/swp_formula.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/piechart_with_value.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/sipslidertile.dart';

class SwpCalciScreen extends StatefulWidget {
  const SwpCalciScreen({super.key});

  @override
  State<SwpCalciScreen> createState() => _SwpCalciScreenState();
}

class _SwpCalciScreenState extends State<SwpCalciScreen> {
  double initialInvestment = 10000;
  double monthlyWithdrawal = 500;
  double years = 1;
  double returnRate = 12;

  @override
  Widget build(BuildContext context) {
    final swp = calculateSwp(
      initialInvestment: initialInvestment,
      monthlyWithdrawal: monthlyWithdrawal,
      years: years.toInt(),
      annualRate: returnRate,
    );

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),

      appBar: CustomAppBarNormal(title: 'SWP Calculator'),
      body: Padding(
        padding: UPadding.screenPadding.copyWith(top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SipSliderTile2(
                title: 'Initial Investment',
                value: initialInvestment,
                min: 10000,
                max: 1000000,
                suffix: null,
                prefix: '₹',

                onChanged: (value) {
                  setState(() {
                    initialInvestment = value;
                  });
                },
              ),
              SipSliderTile2(
                title: 'Withdraw per month',
                value: monthlyWithdrawal,
                min: 500,
                max: 1000000,
                // suffix: '₹',
                suffix: null,
                prefix: '₹',
                onChanged: (value) {
                  setState(() {
                    monthlyWithdrawal = value;
                  });
                },
              ),
              SipSliderTile2(
                title: 'Over a period of',
                value: years,
                min: 1,
                max: 30,
                suffix: 'Years',
                onChanged: (value) {
                  setState(() {
                    years = value;
                  });
                },
              ),
              SipSliderTile2(
                // prefix: 'da',
                title: 'Expected rate of return %',
                value: returnRate,
                min: 1,
                max: 20,
                suffix: '%',
                onChanged: (value) {
                  setState(() {
                    returnRate = value;
                  });
                },
              ),

              Card(
                elevation: 1,
                shadowColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Ucolors.light,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Ucolors.borderside),
                  ),
                  child: DefaultTabController(
                    length: 2,

                    child: Column(
                      children: [
                        Tab(
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,

                            // tabAlignment: TabAlignment.start,
                            // tabAlignment: TabAlignment.startOffset,s
                            // dividerHeight: 40,
                            // isScrollable: true,
                            unselectedLabelColor: Colors.grey,
                            dividerColor: Colors.transparent,
                            labelColor: Ucolors.primary,
                            indicatorColor: Colors.transparent,
                            labelPadding: EdgeInsets.symmetric(vertical: 5),
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),

                              color: Ucolors.primary.withOpacity(0.1),
                            ),
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Visual Rep.',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  'Report',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 450,
                          child: TabBarView(
                            children: [
                              //Visual representation
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PieChartWithValue(
                                    title1: 'Withdrawn',
                                    title2: 'Remaining',
                                    piechartvalue1: swp.totalWithdrawn,
                                    piechartvalue2: swp.remainingValue,
                                    list: [
                                      InvestValue(
                                        title: 'Invest Amount',
                                        value: initialInvestment
                                            .toStringAsFixed(0),
                                      ),
                                      InvestValue(
                                        title: 'Total Withdrawn',
                                        // value: formatIndianNumber(
                                        //   swp.totalWithdrawn,
                                        // ),
                                        value: swp.totalWithdrawn
                                            .toStringAsFixed(0),
                                      ),
                                      InvestValue(
                                        title: 'Remaining Value',
                                        // value: formatIndianNumber(
                                        //   swp.remainingValue,
                                        // ),
                                        value: swp.remainingValue
                                            .toStringAsFixed(0),
                                      ),
                                      InvestValue(
                                        title: 'Total Profit',
                                        // value: formatIndianNumber(
                                        //   swp.totalProfit,
                                        // ),
                                        value: swp.totalProfit.toStringAsFixed(
                                          0,
                                        ),
                                      ),
                                    ],
                                    piechartcolor1: Ucolors.primary,
                                    piechartcolor2: Ucolors.primary.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ],
                              ),

                              //2nd correct
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis
                                      .horizontal, // 🔑 one horizontal scroll
                                  child: SizedBox(
                                    width: 400, // total table width
                                    child: Column(
                                      children: [
                                        /// HEADER
                                        const TableHeader(
                                          heading1: "Years",
                                          heading2: "Withdrawn",
                                          heading3: "Profit",
                                          heading4: "Remaining",
                                        ),

                                        // const Divider(height: 1),
                                        DashedLine(
                                          dashSpace: 0,
                                          color: Ucolors.borderColor,
                                        ),

                                        /// BODY (VERTICAL SCROLL HERE ✅)
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: swp.report.length,
                                            itemBuilder: (_, i) {
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
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              //Correct
                              // Expanded(
                              //   child: SingleChildScrollView(
                              //     scrollDirection: Axis.horizontal,
                              //     child: SizedBox(
                              //       width: 550,
                              //       child: Column(
                              //         children: [
                              //           const TableHeader(
                              //             heading1: "Years",
                              //             heading2: "Withdrawn",
                              //             heading3: "Profit",
                              //             heading4: "Remaining",
                              //           ),

                              //           const Divider(height: 1),

                              //           SizedBox(
                              //             height:
                              //                 MediaQuery.of(
                              //                   context,
                              //                 ).size.height *
                              //                 0.4,
                              //             child: ListView.builder(
                              //               itemCount: swp.report.length,
                              //               itemBuilder: (_, i) {
                              //                 final r = swp.report[i];
                              //                 return ReturnsTableRow(
                              //                   percentage: false,
                              //                   color3: Colors.green,
                              //                   data: ReturnRow(
                              //                     period: r.year.toString(),
                              //                     scheme: r.withdrawn,
                              //                     category: r.profit,
                              //                     benchmark: r.remaining,
                              //                   ),
                              //                 );
                              //               },
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              //Report table
                              // Column(
                              //   children: [
                              //     TableHeader(
                              //       heading1: 'Years',
                              //       heading2: 'Withdrawn',
                              //       heading3: 'Profit',
                              //       heading4: 'Remaining',
                              //     ),
                              //     DashedLine(
                              //       color: Ucolors.borderColor,
                              //       dashSpace: 0,
                              //     ),

                              //     Expanded(
                              //       child: ListView.builder(
                              //         itemCount: swp.report.length,
                              //         itemBuilder: (_, i) {
                              //           final r = swp.report[i];
                              //           return ReturnsTableRow(
                              //             percentage: false,
                              //             color3: Colors.green,
                              //             data: ReturnRow(
                              //               period: r.year.toString(),
                              //               scheme: r.withdrawn,
                              //               category: r.profit,
                              //               benchmark: r.remaining,
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
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
    );
  }
}
