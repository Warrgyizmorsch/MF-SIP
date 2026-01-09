import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../widgets/sip_growth_chart.dart';


class Accumulationanddistributionscreen extends StatefulWidget {
  const Accumulationanddistributionscreen({super.key});

  @override
  State<Accumulationanddistributionscreen> createState() =>
      _AccumulationanddistributionscreenState();
}

class _AccumulationanddistributionscreenState
    extends State<Accumulationanddistributionscreen> {
  final data = {
    "SIP Amount" : "₹ 5,000",
    "Tenure" : "5 Years",
    "Exp. Return Rate" : "15.00%",
    "Total Inv." : "₹3.00 Lac",
    "Exp. SIP Corpus" : "₹4.43 Lac"
  };
  final distributionData = {
    "SWP Amount" : "₹4,273",
    "Tenure" : "20 Years",
    "Exp. Return Rate" : "10.00%",
    "Exp. Total Withdrawal Amt.." : "₹10.26 Lac",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarNormal(title: 'Freedom SIP'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- Tab Bar Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: AppTextStyles.bodyMediumSemiBold(),
                  indicatorPadding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: "Accumulation"),
                    Tab(text: "Distribution"),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: TabBarView(
                children: [
                  // 1. Accumulation Tab Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // THE CHART WIDGET IS HERE
                        ...[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const SipGrowthChart(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child:
                            Text(
                              "*Graph showing Accumulation phase from period 2025-2030",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall(),)
                            ,),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Growth Scheme Details (SIP)", style: AppTextStyles.bodyLargeBold(),),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                              color: Ucolors.blue,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                                          ),
                                          child:         Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 20,),
                                              Image.asset("assets/images/bandhan_logo.png", height: 40,),
                                              Text("Bandhan Midcap Fund", style: AppTextStyles.bodyMediumSemiBold(color: Colors.white),),
                            
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.grey.shade200),
                                          ),
                                          child: Column(
                                            children: data.entries.map((entry) {
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(entry.key, style: TextStyle(color: Colors.grey.shade600)),
                                                    Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )
                            
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],



                      ],
                    ),
                  ),

                  // 2. Distribution Tab Content

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // THE CHART WIDGET IS HERE
                        ...[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              // border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const SipGrowthChart(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child:
                            Text(
                              "*Graph showing Distribution phase from period 2030-2050",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodySmall(),)
                            ,),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Target Scheme Details (SWP)", style: AppTextStyles.bodyLargeBold(),),
                                SizedBox(height: 15.0,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Ucolors.blue,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                                        ),
                                        child:         Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 20,),
                                            Image.asset("assets/images/bandhan_logo.png", height: 40,),
                                            Text("Bandhan Midcap Fund", style: AppTextStyles.bodyMediumSemiBold(color: Colors.white),),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: Column(
                                          children: distributionData.entries.map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 12.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(entry.key, style: TextStyle(color: Colors.grey.shade600)),
                                                  Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],



                      ],
                    ),
                  ),
                ],
              ),
            ),




          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: UElevatedBUtton(
                  onPressed: () => Navigator.pop(context),
                  outlined: true,
                  child: Center(
                    child: Text(
                      'Back',
                      style: AppTextStyles.bodyMedium(color: Ucolors.primary),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: UElevatedBUtton(

                  onPressed: () {

                  },
                  child: Center(
                    child: Text(
                      'Checkout',
                      style: AppTextStyles.bodyMedium(color: Colors.white),
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