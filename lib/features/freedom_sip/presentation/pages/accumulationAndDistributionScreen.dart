import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
    "SIP Amount": "₹ 5,000",
    "Tenure": "5 Years",
    "Exp. Return Rate": "15.00%",
    "Total Inv.": "₹3.00 Lac",
    "Exp. SIP Corpus": "₹4.43 Lac",
  };
  final distributionData = {
    "SWP Amount": "₹4,273",
    "Tenure": "20 Years",
    "Exp. Return Rate": "10.00%",
    "Exp. Total Withdrawal Amt..": "₹10.26 Lac",
  };

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarNormal(title: 'Freedom SIP'),

      bottomNavigationBar: isDesktop
          ? null
          : _buildBottomBar(context, isDesktop, isTablet),

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 0,
            vertical: isDesktop ? 20 : 0,
          ),
          child: isDesktop
              ? _buildDesktopStructure(context)
              : _buildMobileStructure(context, isTablet),
        ),
      ),
    );
  }

  Widget _buildDesktopStructure(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  height: 60,
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
                        ),
                      ],
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: AppTextStyles.bodyMediumSemiBold(size: 16),
                    indicatorPadding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: "Accumulation"),
                      Tab(text: "Distribution"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TabBarView(
                      children: [
                        _buildDesktopInnerContent(
                          context,
                          data,
                          "Growth Scheme Details (SIP)",
                          "2025-2030",
                        ),
                        _buildDesktopInnerContent(
                          context,
                          distributionData,
                          "Target Scheme Details (SWP)",
                          "2030-2050",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 20),
        SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UElevatedBUtton(
                      onPressed: () => Get.toNamed(AppRoutes.paymentScreen),
                      child: Center(
                        child: Text(
                          'Checkout',
                          style: AppTextStyles.bodyMedium(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    UElevatedBUtton(
                      onPressed: () => Navigator.pop(context),
                      outlined: true,
                      child: Center(
                        child: Text(
                          'Back',
                          style: AppTextStyles.bodyMedium(
                            color: Ucolors.primary,
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
      ],
    );
  }

  Widget _buildDesktopInnerContent(
    BuildContext context,
    Map<String, String> schemeData,
    String title,
    String period,
  ) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildChart(context, period, true, false)),
          const SizedBox(width: 40),

          Expanded(
            flex: 2,
            child: _buildSchemeDetails(context, schemeData, title, true, false),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStructure(BuildContext context, bool isTablet) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 60 : 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TabBar(
                splashBorderRadius: BorderRadius.circular(20.0),
                splashFactory: NoSplash.splashFactory,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
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
            child: TabBarView(
              children: [
                _buildMobileTabContent(
                  context,
                  data,
                  "Growth Scheme Details (SIP)",
                  "2025-2030",
                  isTablet,
                ),
                _buildMobileTabContent(
                  context,
                  distributionData,
                  "Target Scheme Details (SWP)",
                  "2030-2050",
                  isTablet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabContent(
    BuildContext context,
    Map<String, String> schemeData,
    String title,
    String period,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 30 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildChart(context, period, false, isTablet),
          SizedBox(height: isTablet ? 25 : 15),
          _buildSchemeDetails(context, schemeData, title, false, isTablet),
        ],
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    String period,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      children: [
        Container(
          height: isDesktop ? 350 : (isTablet ? 280 : 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const SipGrowthChart(),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 20),
          child: Text(
            "*Graph showing ${period.contains('2025') ? 'Accumulation' : 'Distribution'} phase from period $period",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall(size: isDesktop ? 13 : 12.0),
          ),
        ),
      ],
    );
  }

  Widget _buildSchemeDetails(
    BuildContext context,
    Map<String, String> schemeData,
    String title,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLargeBold(
            size: isDesktop ? 20 : (isTablet ? 18 : 16.0),
          ),
        ),
        SizedBox(height: isDesktop ? 20 : 15),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                decoration: const BoxDecoration(
                  color: Ucolors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: isDesktop ? 15 : 10),
                    Image.asset(
                      "assets/images/bandhan_logo.png",
                      height: isDesktop ? 40 : 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Bandhan Midcap Fund",
                        style: AppTextStyles.bodyMediumSemiBold(
                          color: Colors.white,
                          size: isDesktop ? 16 : 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: schemeData.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: isDesktop ? 14 : 12.0,
                              ),
                            ),
                          ),
                          Text(
                            entry.value,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: isDesktop ? 14 : 12.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDesktop, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
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
                    style: AppTextStyles.bodyMedium(
                      color: Ucolors.primary,
                      size: isDesktop ? 16 : 14.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: UElevatedBUtton(
                onPressed: () => Get.toNamed(AppRoutes.paymentScreen),
                child: Center(
                  child: Text(
                    'Checkout',
                    style: AppTextStyles.bodyMedium(
                      color: Colors.white,
                      size: isDesktop ? 16 : 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
