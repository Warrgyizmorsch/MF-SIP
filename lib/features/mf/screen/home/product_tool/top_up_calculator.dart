import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/return.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/piechart_with_value.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/sipslidertile.dart';

class TopUpCalculatorPage extends StatelessWidget {
  const TopUpCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final normalvsstep = [
      ReturnRow(
        period: 'Normal',
        scheme: 3000000,
        category: 5600897,
        benchmark: 2600897,
      ),
      ReturnRow(
        period: 'Step-up',
        scheme: 3000000,
        category: 5600897,
        benchmark: 2600897,
      ),
    ];
    final returns = [
      ReturnRow(
        period: '1',
        scheme: 1200000,
        category: 35661,
        benchmark: 415661,
        extra: 421,
      ),
      ReturnRow(
        period: '2',
        scheme: 240000,
        category: 64575,
        benchmark: 324575,
        extra: 421,
      ),
      ReturnRow(
        period: '3',
        scheme: 360000,
        category: 86202,
        benchmark: 226202,
        extra: 421,
      ),
      ReturnRow(
        period: '4',
        scheme: 480000,
        category: 99960,
        benchmark: 119960,
        extra: 421,
      ),
      ReturnRow(
        period: '5',
        scheme: 600000,
        category: 105218,
        benchmark: 5218,
        extra: 421,
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: CustomAppBarNormal(title: 'SIP Top-Up Calculator'),
      body: Padding(
        padding: UPadding.screenPadding.copyWith(top: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SipSliderTile2(
                title: 'I want to invest (per month)',
                value: 10000,
                min: 10000,
                max: 1000000,
                suffix: null,
                prefix: '₹',

                onChanged: (value) {},
              ),
              SipSliderTile2(
                title: 'Increase SIP every year',
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

              Row(
                children: [
                  Text('Normal vs Step-up Summary', style: UTextStyles.large),
                ],
              ),
              Gap(12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],

                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Ucolors.borderside),
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    TableHeader(
                      heading1: 'Metric',
                      heading2: 'Invested',
                      heading3: 'Future Value',
                      heading4: 'Profit',
                    ),
                    DashedLine(color: Colors.grey.shade300, dashSpace: 0),
                    ...normalvsstep.map(
                      (e) => ReturnsTableRow(
                        color4: Colors.green.shade600,
                        data: e,
                        percentage: false,
                        // fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Gap(20),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Ucolors.light,
                  borderRadius: BorderRadius.circular(20),

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
                                Gap(12),
                                PieChartWithValue(
                                  title1: 'Step-up Future Value',
                                  title2: 'Step-up Profit',
                                  list: [
                                    Text(
                                      'You can withdraw ₹500 per month for 5 years at 10.5% expected return.',
                                      textAlign: TextAlign.center,
                                      style: UTextStyles.caption,
                                    ),
                                    Gap(10),
                                    InvestValue(
                                      color: Colors.black87,

                                      title: 'Step-up Invested',
                                      value: '184777777',
                                      // color: Ucolors.pri,
                                    ),
                                    InvestValue(
                                      color: Colors.black87,

                                      title: 'Step-up Future Value',
                                      value: '184777777',
                                      // color: Ucolors.dark,
                                    ),
                                    InvestValue(
                                      color: Colors.black87,

                                      title: 'Step-up Profit',
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
                                  heading2: 'Invested',
                                  heading3: 'Normal',
                                  heading4: 'Step-up',
                                  heading5: 'Extra',
                                ),
                                DashedLine(
                                  color: Ucolors.borderColor,
                                  dashSpace: 0,
                                ),
                                ...returns.map(
                                  (row) => ReturnsTableRow(
                                    color5: Colors.green.shade600,
                                    // color4: Colors.green,
                                    // fontSize: 10,
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
