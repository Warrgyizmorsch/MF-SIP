import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/images.dart';
import '../controllers/freedom_sip_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/images.dart';
import '../controllers/freedom_sip_controller.dart';

class FreedomSipScreen extends GetView<FreedomSipController> {
  const FreedomSipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Ucolors.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40.0 : 10.0,
                  vertical: isDesktop ? 20.0 : 0.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Body Content (Wrapped in Obx)
                    Obx(() => _buildMainContent(isDesktop)),

                    // Sidebar for Desktop (Wrapped in Obx to update button text)
                    if (isDesktop)
                      Obx(() => _buildSidebarActions()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Mobile Bottom Bar (Wrapped in Obx to update button text)
      bottomNavigationBar: isDesktop
          ? null
          : Obx(() => _buildMobileBottomBar()),
    );
  }

  Widget _buildMainContent(bool isDesktop) {
    return Expanded(
      flex: 3,
      child: Container(
        margin: isDesktop ? const EdgeInsets.only(right: 20) : EdgeInsets.zero,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(UText.freedomSipSubTitle, style: AppTextStyles.bodyLargeBold(), textAlign: TextAlign.center),
              const SizedBox(height: 20.0),

              // Step 1: SIP Card
              _buildStepCard(
                title: UText.freedomSipStep1Title,
                desc: UText.freedomSipStep1desc,
                btnText: controller.isStep1Completed ? "Completed" : UText.freedomSipStep1button,
                isCompleted: controller.isStep1Completed,
                onPressed: controller.startSipFlow,
                imgUrl: controller.isStep1Completed
                    ? "${Appurl.baseUrl}${controller.selectedScheme.amc?.amcLogoUrl ?? ''}"
                    : null,
                schemeName: controller.isStep1Completed
                    ? (controller.selectedScheme.baseSchemeName ?? '')
                    : null,
              ),

              const SizedBox(height: 15.0),

              // Step 2: SWP Card
              IgnorePointer(
                ignoring: !controller.isStep1Completed,
                child: _buildStepCard(
                  title: UText.freedomSipStep2Title,
                  desc: UText.freedomSipStep2desc,
                  btnText: controller.isStep2Completed ? "Completed" : UText.freedomSipStep2button,
                  isCompleted: controller.isStep2Completed,
                  onPressed: controller.startSwpFlow,
                  imgUrl: controller.isStep2Completed
                      ? "${Appurl.baseUrl}${controller.selectedSWPScheme.amc?.amcLogoUrl ?? ''}"
                      : null,
                  schemeName: controller.isStep2Completed
                      ? (controller.selectedSWPScheme.baseSchemeName ?? '')
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required String desc,
    required String btnText,
    required bool isCompleted,
    required VoidCallback onPressed,
    required String? imgUrl,
    required String? schemeName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: const LinearGradient(
          colors: [Color(0xff07315C), Color(0xff0280C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.bodyLargeBold(color: Colors.white, size: 18.0)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(desc, style: AppTextStyles.bodySmall(color: Colors.white, size: 13.0)),
          const SizedBox(height: 10),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        btnText,
                        style: AppTextStyles.bodySmall(color: isCompleted ? Colors.white : Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        isCompleted ? Icons.check : Icons.arrow_forward,
                        size: 14,
                        color: isCompleted ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (isCompleted)
                InkWell(
                  onTap: onPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "Change",
                      style: AppTextStyles.bodySmall(color: Colors.white),
                    ),
                  ),
                )
            ],
          ),

          if (isCompleted) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Divider(color: Colors.white, thickness: 1, height: 20), // Replaced DashedLine for standard Divider
            ),
            Row(
              children: [
                CustomCachedImage(imageUrl: imgUrl),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    schemeName ?? '',
                    style: AppTextStyles.bodyMediumBold(color: Colors.white),
                  ),
                )
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildSidebarActions() {
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Added logic to match Mobile Bottom Bar (Show Final Summary or Select Fund)
          if (controller.isStep1Completed && controller.isStep2Completed)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: UElevatedBUtton(
                onPressed: () => Get.toNamed(AppRoutes.accumulationanddistributionscreen),
                child: Center(child: Text("See Your Detailed Summary", style: AppTextStyles.bodyMedium(color: Colors.white))),
              ),
            )
          else
            ActionBox(
              onPrimary: controller.isStep1Completed ? controller.startSwpFlow : controller.startSipFlow,
              onSecondary: controller.goBack,
              primaryText: controller.isStep1Completed ? 'Select SWP Fund' : 'Select SIP Fund',
            ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomBar() {
    if (controller.isStep1Completed && controller.isStep2Completed) {
      return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UElevatedBUtton(
              onPressed: () => Get.toNamed(AppRoutes.accumulationanddistributionscreen),
              child: Center(
                child: Text("See Your Detailed Summary", style: AppTextStyles.bodyMedium(color: Colors.white)),
              ),
            ),
          ),
        ),
      );
    }

    return MobileBottomNav(
      onPrimary: controller.isStep1Completed ? controller.startSwpFlow : controller.startSipFlow,
      onSecondary: controller.goBack,
      primaryText: controller.isStep1Completed ? 'Select SWP Fund' : 'Select SIP Fund',
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(UImages.mfLogoLight, height: 20),
          const SizedBox(width: 10),
          Text(UText.freedomSipTitle, style: AppTextStyles.bodyLarge(color: Colors.white)),
        ],
      ),
    );
  }
}

class ActionBox extends StatelessWidget {
  final VoidCallback onPrimary, onSecondary;
  final String primaryText;
  const ActionBox({super.key, required this.onPrimary, required this.onSecondary, required this.primaryText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UElevatedBUtton(onPressed: onPrimary, child: Center(child: Text(primaryText, style: AppTextStyles.bodyMedium(color: Colors.white)))),
          const SizedBox(height: 16),
          UElevatedBUtton(onPressed: onSecondary, outlined: true, child: Center(child: Text('Back', style: AppTextStyles.bodyMedium(color: Ucolors.primary)))),
        ],
      ),
    );
  }
}

class MobileBottomNav extends StatelessWidget {
  final VoidCallback onPrimary, onSecondary;
  final String primaryText;
  const MobileBottomNav({super.key, required this.onPrimary, required this.onSecondary, required this.primaryText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: UElevatedBUtton(onPressed: onSecondary, outlined: true, child: Center(child: Text('Back', style: AppTextStyles.bodyMedium(color: Ucolors.primary))))),
            const SizedBox(width: 16),
            Expanded(child: UElevatedBUtton(onPressed: onPrimary, child: Center(child: Text(primaryText, style: AppTextStyles.bodyMedium(color: Colors.white))))),
          ],
        ),
      ),
    );
  }
}