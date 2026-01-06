import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/features/dashboard/screen/widget/comparison_chart.dart';
import 'package:my_sip/features/dashboard/screen/widget/invest_fund_list.dart';
import 'package:my_sip/features/dashboard/screen/widget/portfolio_summary.dart';
import 'package:my_sip/features/dashboard/screen/widget/suggest_fund_list.dart';
import 'package:my_sip/features/mf/screen/explore/explore.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log('${Get.height}  ${Get.width}');
    return Scaffold(
      appBar: CustomProfileAppbar(
        greetingName: 'Pratik',
        role: 'Developer',
        avatar: AssetImage(UImages.avatar),
        onProfiletap: () {
          log('profile tap');
          // Get.to(() => ProfileScreen());
          Get.to(() => NavigationMenuBar());
        },
        action: [
          // CompactIcon(
          //   icon: Icons.search,
          //   onPressed: () {
          //     log('iconPressed');
          //   },
          // ),
          CompactIcon(
            icon: Iconsax.notification,
            onPressed: () {
              log('iconPressed');
            },
          ),
          CompactIcon(
            icon: Icons.shopping_cart_outlined,
            onPressed: () {
              log('iconPressed');
            },
          ),
          CompactIcon(
            icon: Icons.bookmark_border_outlined,
            onPressed: () {
              log('iconPressed');
            },
          ),
          SizedBox(width: 16),
        ],
      ), // Heading AppBar

      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            SizedBox(height: 20),

            //Section
            SectionHeading(
              fontSize: 14,
              showActionButton: true,
              sectionTitle: 'Your Mutual fund Assets',
              textcolor: Ucolors.darkgrey,
            ),

            //Profile Summary
            PortfolioSummary(),
            SizedBox(height: Get.height * 0.02),

            //Fund chart
            // Image.asset(UImages.comparison),
            // FundComparisonChartWidget(),
            FundComparisonChartWidget1(),
            // SizedBox(height: 20),
            SizedBox(height: Get.height * 0.02),

            //Section
            SectionHeading(
              fontSize: (Get.width * 0.04).clamp(15, 20),
              sectionTitle: 'You\'re money invest in these funds ',
              textcolor: Ucolors.dark,
              fontWeight: FontWeight.w500,
              // fontSize: 15,
            ),
            SizedBox(height: Get.height * 0.01),

            ListView.separated(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => InvestFundList(),
              separatorBuilder: (context, index) => Divider(),
              itemCount: 3,
            ),
            SizedBox(height: Get.height * 0.01),

            //Section
            SectionHeading(
              // fontSize: 18,
              sectionTitle: 'Our Suggested Funds',
              fontSize: (Get.width * 0.04).clamp(15, 20),
            ),

            // SizedBox(height: 15),
            SizedBox(height: Get.height * 0.01),

            ListView.separated(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => SuggestFundList(),
              separatorBuilder: (context, index) => Divider(),
              itemCount: 10,
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      //Bottom Bar
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomBarButton(
          firstButtonP: () => Get.to(() => NavigationMenuBar()),
          secondButtonP: () {},

          firstButton: 'Explore',
          secondButton: 'View Cart',
        ),
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    super.key,
    required this.firstButton,
    required this.secondButton,
    this.firstButtonP,
    this.secondButtonP,
  });

  final String firstButton;
  final String secondButton;
  final VoidCallback? firstButtonP;
  final VoidCallback? secondButtonP;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        // 16 + MediaQuery.of(context).viewPadding.bottom,
        16 + bottomInset,
      ),
      child: Row(
        children: [
          Expanded(
            child: UElevatedBUtton(
              onPressed: firstButtonP,
              height: 52,
              outlined: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(firstButton, style: TextStyle(color: Ucolors.dark)),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),

          Expanded(
            child: UElevatedBUtton(
              onPressed: secondButtonP,

              height: 52,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(secondButton, style: UTextStyles.buttonText)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
