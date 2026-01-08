import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/return.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/piechart_with_value.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/sipslidertile.dart';

class SipCalculatorPage extends StatefulWidget {
  const SipCalculatorPage({super.key});

  @override
  State<SipCalculatorPage> createState() => _SipCalculatorPageState();
}

class _SipCalculatorPageState extends State<SipCalculatorPage> {
  double monthlyInvestment = 5000;
  double returnRate = 11.9;
  double years = 5;
  @override
  Widget build(BuildContext context) {
    final returns = [
      ReturnRow(
        period: '1',
        scheme: 120000,
        category: 35661,
        benchmark: 415661,
      ),
      ReturnRow(
        period: '2',
        scheme: 240000,
        category: 64575,
        benchmark: 324575,
      ),
      ReturnRow(
        period: '3',
        scheme: 360000,
        category: 86202,
        benchmark: 226202,
      ),
      ReturnRow(
        period: '4',
        scheme: 480000,
        category: 99960,
        benchmark: 119960,
      ),
      ReturnRow(period: '5', scheme: 600000, category: 105218, benchmark: 5218),
    ];
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.96),

      // backgroundColor: The
      appBar: CustomAppBarNormal(title: 'SIP Calculator'),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'SIP Calculator',
                //   style: UTextStyles.medium.copyWith(
                //     color: Ucolors.dark,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // Gap(15),
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

                    // indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('SIP', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Lumpsum', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 700,
                  child: TabBarView(
                    children: [
                      //Sip calci
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Gap(18),
                            SipSliderTile2(
                              title: 'Monthly Investment',
                              value: monthlyInvestment,
                              min: 500,
                              max: 100000,
                              // valueFormatter: (val) => '₹ ${val.toInt()}',
                              suffix: '₹',

                              onChanged: (value) {
                                setState(() {
                                  monthlyInvestment = value;
                                });
                              },
                            ),
                            SipSliderTile2(
                              title: 'Expected return rate (p.a)',
                              value: returnRate,
                              min: 1,
                              max: 30,
                              // valueFormatter: (val) => '${val.toStringAsFixed(1)}%',
                              suffix: '%',
                              onChanged: (val) {
                                // setState(() {
                                //   returnRate = val;
                                // });
                              },
                            ),

                            SipSliderTile2(
                              title: 'Total period',

                              suffix: 'Years',
                              onChanged: (val) {
                                setState(() {
                                  years = val;
                                });
                              },

                              value: years,
                              min: 1,
                              max: 30,
                            ),
                            Container(
                              // margin: EdgeInsets.all(9),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
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
                                        labelPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        indicator: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),

                                          color: Ucolors.primary.withOpacity(
                                            0.1,
                                          ),
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
                                      height: 400,
                                      child: TabBarView(
                                        children: [
                                          //Visual representation
                                          Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            children: [
                                              // PieChartWithValue(
                                              //   title1: 'Withdrawn',
                                              //   title2: 'Remaining',
                                              //   list: [
                                              //     Text(
                                              //       'You can withdraw ₹500 per month for 5 years at 10.5% expected return.',
                                              //       textAlign: TextAlign.center,
                                              //       style: UTextStyles.caption,
                                              //     ),
                                              //     Gap(10),
                                              //     InvestValue(
                                              //       title: 'Total Withdrawn',
                                              //       value: '184777777',
                                              //       // color: Ucolors.pri,
                                              //     ),
                                              //     InvestValue(
                                              //       title: 'Remaining Value',
                                              //       value: '184777777',
                                              //       // color: Ucolors.dark,
                                              //     ),
                                              //     InvestValue(
                                              //       title: 'Total Profit',
                                              //       value: '184777777',
                                              //       // color: Ucolors.success,
                                              //     ),
                                              //   ],
                                              //   piechartvalue1: 30,
                                              //   piechartvalue2: 70,
                                              //   piechartcolor1: Ucolors.primary,
                                              //   piechartcolor2: Ucolors.primary
                                              //       .withOpacity(0.1),
                                              // ),
                                              PieChartWithValue(
                                                title1: 'Returns',
                                                title2: 'Invest',
                                                list: [
                                                  InvestValue(
                                                    title: 'Investment amount ',
                                                    value: '123',
                                                    color: Colors.grey.shade800,
                                                  ),
                                                  InvestValue(
                                                    title: 'Est Returns ',
                                                    value: '123',
                                                    color: Colors.grey.shade800,
                                                  ),
                                                  InvestValue(
                                                    title: 'Total Value',
                                                    value: '123',
                                                    color: Ucolors.dark,
                                                  ),
                                                ],
                                                piechartvalue1: 70,
                                                piechartvalue2: 30,
                                                piechartcolor2: Ucolors.primary
                                                    .withOpacity(0.2),
                                                piechartcolor1: Ucolors.primary,
                                              ),
                                              // Gap(20),
                                            ],
                                          ),

                                          //Report table
                                          Column(
                                            children: [
                                              TableHeader(
                                                heading1: 'Years',
                                                heading2: 'Investment',
                                                heading3: 'Profit',
                                                heading4: 'Current Value',
                                              ),
                                              DashedLine(
                                                color: Ucolors.borderColor,
                                                dashSpace: 0,
                                              ),
                                              ...returns.map(
                                                (row) => ReturnsTableRow(
                                                  color3: Colors.green.shade600,
                                                  data: row,
                                                  percentage: false,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //  Column(
                                //   children: [
                                //     PieChartWithValue(
                                //       title1: 'Withdrawn',
                                //       title2: 'Remaining',
                                //       list: [
                                //         Text(
                                //           'You can withdraw ₹500 per month for 5 years at 10.5% expected return.',
                                //           textAlign: TextAlign.center,
                                //           style: UTextStyles.caption,
                                //         ),
                                //         Gap(10),
                                //         InvestValue(
                                //           title: 'Total Withdrawn',
                                //           value: '184777777',
                                //           color: Ucolors.red,
                                //         ),
                                //         InvestValue(
                                //           title: 'Remaining Value',
                                //           value: '184777777',
                                //           color: Ucolors.dark,
                                //         ),
                                //         InvestValue(
                                //           title: 'Total Profit',
                                //           value: '184777777',
                                //           color: Ucolors.success,
                                //         ),
                                //       ],
                                //       piechartvalue1: 30,
                                //       piechartvalue2: 70,
                                //       piechartcolor1: Ucolors.darkgrey,
                                //       piechartcolor2: Ucolors.success,
                                //     ),
                                //   ],
                                // ),
                              ),
                            ),

                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 15,
                            //     vertical: 15,
                            //   ),
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     border: Border.all(color: Ucolors.borderside),
                            //   ),
                            //   child:
                            // PieChartWithValue(
                            //     title1: 'Returns',
                            //     title2: 'Invest',
                            //     list: [
                            //       InvestValue(
                            //         title: 'Investment amount ',
                            //         value: '123',
                            //         color: Colors.grey.shade800,
                            //       ),
                            //       InvestValue(
                            //         title: 'Est Returns ',
                            //         value: '123',
                            //         color: Colors.grey.shade800,
                            //       ),
                            //       InvestValue(
                            //         title: 'Total Value',
                            //         value: '123',
                            //         color: Ucolors.dark,
                            //       ),
                            //     ],
                            //     piechartvalue1: 70,
                            //     piechartvalue2: 30,
                            //     piechartcolor2: Ucolors.primary.withOpacity(0.2),
                            //     piechartcolor1: Ucolors.primary,
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      //Lumpsum
                      Column(
                        children: [
                          Gap(18),
                          SipSliderTile2(
                            title: 'Total Investment',
                            value: monthlyInvestment,
                            min: 500,
                            max: 100000,
                            // valueFormatter: (val) => '₹ ${val.toInt()}',
                            suffix: '₹',

                            onChanged: (value) {
                              setState(() {
                                monthlyInvestment = value;
                              });
                            },
                          ),
                          SipSliderTile2(
                            title: 'Expected return rate (p.a)',
                            value: returnRate,
                            min: 1,
                            max: 30,
                            // valueFormatter: (val) => '${val.toStringAsFixed(1)}%',
                            suffix: '%',
                            onChanged: (val) {
                              // setState(() {
                              //   returnRate = val;
                              // });
                            },
                          ),

                          SipSliderTile2(
                            title: 'Total period',

                            suffix: 'Years',
                            onChanged: (val) {
                              setState(() {
                                years = val;
                              });
                            },

                            value: years,
                            min: 1,
                            max: 30,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            width: double.infinity,

                            decoration: BoxDecoration(
                              color: Ucolors.light,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Ucolors.borderside),
                            ),
                            child: PieChartWithValue(
                              title1: 'Returns',
                              title2: 'Invest',
                              list: [
                                InvestValue(
                                  title: 'Investment amount ',
                                  value: '123',
                                  color: Colors.grey.shade800,
                                ),
                                InvestValue(
                                  title: 'Est Returns ',
                                  value: '123',
                                  color: Colors.grey.shade800,
                                ),
                                InvestValue(
                                  title: 'Total Value',
                                  value: '123',
                                  color: Ucolors.dark,
                                ),
                              ],
                              piechartvalue1: 70,
                              piechartvalue2: 30,
                              piechartcolor2: Ucolors.primary.withOpacity(0.2),
                              piechartcolor1: Ucolors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
