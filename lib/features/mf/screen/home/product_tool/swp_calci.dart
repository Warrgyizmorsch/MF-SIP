import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/return.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/piechart_with_value.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/sipslidertile.dart';

class SwpCalciScreen extends StatelessWidget {
  const SwpCalciScreen({super.key});

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
      appBar: CustomAppBarNormal(title: 'SWP Calculator'),
      body: Padding(
        padding: UPadding.screenPadding.copyWith(top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SipSliderTile2(
                title: 'Initial Investment',
                value: 10000,
                min: 10000,
                max: 1000000,
                suffix: null,
                prefix: '₹',

                onChanged: (value) {},
              ),
              SipSliderTile2(
                title: 'Withdraw per month',
                value: 500,
                min: 500,
                max: 1000000,
                // suffix: '₹',
                suffix: null,
                prefix: '₹',
                onChanged: (value) {},
              ),
              SipSliderTile2(
                title: 'Over a period of',
                value: 1,
                min: 1,
                max: 50,
                suffix: 'Years',
                onChanged: (value) {},
              ),
              SipSliderTile2(
                // prefix: 'da',
                title: 'Expected rate of return %',
                value: 1,
                min: 0,
                max: 50,
                suffix: '%',
                onChanged: (value) {},
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
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
                        height: 500,
                        child: TabBarView(
                          children: [
                            //Visual representation
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PieChartWithValue(
                                  title1: 'Withdrawn',
                                  title2: 'Remaining',
                                  list: [
                                    // Text(
                                    //   'You can withdraw ₹500 per month for 5 years at 10.5% expected return.',
                                    //   textAlign: TextAlign.center,
                                    //   style: UTextStyles.caption,
                                    // ),
                                    // Gap(10),
                                    InvestValue(
                                      title: 'Total Withdrawn',
                                      value: '184777777',
                                      // color: Ucolors.pri,
                                    ),
                                    InvestValue(
                                      title: 'Remaining Value',
                                      value: '184777777',
                                      // color: Ucolors.dark,
                                    ),
                                    InvestValue(
                                      title: 'Total Profit',
                                      value: '184777777',
                                      // color: Ucolors.success,
                                    ),
                                  ],
                                  piechartvalue1: 30,
                                  piechartvalue2: 70,
                                  piechartcolor1: Ucolors.primary,
                                  piechartcolor2: Ucolors.primary.withOpacity(
                                    0.1,
                                  ),
                                ),
                              ],
                            ),

                            //Report table
                            Column(
                              children: [
                                TableHeader(
                                  heading1: 'Years',
                                  heading2: 'Total-Withdrawn',
                                  heading3: 'Profit',
                                  heading4: 'Remaining Value',
                                ),
                                DashedLine(color: Ucolors.borderColor),
                                ...returns.map(
                                  (row) => ReturnsTableRow(
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
            ],
          ),
        ),
      ),
    );
  }
}
