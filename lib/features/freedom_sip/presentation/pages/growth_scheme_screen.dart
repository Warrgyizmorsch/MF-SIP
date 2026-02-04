import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../controllers/freedom_sip_controller.dart';

class GrowthSchemeScreen extends GetView<FreedomSipController> {
  const GrowthSchemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Ucolors.primary,
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 10,
                  vertical: isDesktop ? 20 : 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        margin: isDesktop ? const EdgeInsets.only(right: 20) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleSection(),
                            const SizedBox(height: 15),
                            Expanded(
                              child: Obx(() => _buildSchemeList()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isDesktop) _buildDesktopSidebar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
          Text(
            UText.freedomSipTitle,
            style: AppTextStyles.bodyLarge(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           controller.isStep1Completed ? UText.growthSchemeScreenTitle2 : UText.growthSchemeScreenTitle,
            style: AppTextStyles.bodyLargeBold(),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: UText.growthSchemeScreenKnowMore,
              style: AppTextStyles.bodySmall(color: Colors.grey),
              children: [
                TextSpan(
                  text: " Know More",
                  style: AppTextStyles.bodySmall(
                    color: Ucolors.primary,
                    decoration: TextDecoration.underline,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeList() {
    return controller.isStep1Completed ?
    ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: controller.growthSchemes.length.clamp(0, 4),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildSchemeCard2(index),
    )
        :  ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: controller.growthSchemes.length.clamp(0, 4),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildSchemeCard(index),
    );
  }

  Widget _buildSchemeCard(int index) {
    return Obx(() {
      final isSelected = controller.selectedSchemeIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectScheme(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? Ucolors.primary : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomCachedImage(
                    imageUrl: "${Appurl.baseUrl}${controller.growthSchemes[index].amc?.amcLogoUrl}",
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.growthSchemes[index].baseSchemeName ?? '',
                      style: AppTextStyles.bodyMediumSemiBold(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFE0E0E0)), // Replaced custom Dash with Divider
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(Icons.circle, Colors.red, controller.riskList[index]),
                    const SizedBox(width: 12),
                    _buildReturnItem("SIP Returns: ", controller.returnsList[index]),
                    const SizedBox(width: 12),
                    _buildStatItem(null, null, "Fund Age: ${controller.ageList[index]}", isAge: true),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSchemeCard2(int index) {
    return Obx(() {
      final isSelected = controller.selectedSchemeIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectScheme(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Ucolors.primary.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? Ucolors.primary : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomCachedImage(
                    imageUrl: "${Appurl.baseUrl}${controller.growthSchemes[index].amc?.amcLogoUrl}",
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.growthSchemes[index].baseSchemeName ?? '',
                      style: AppTextStyles.bodyMediumSemiBold(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fund Age", style:  AppTextStyles.bodyMedium(color: Ucolors.darkgrey),),
                  Text(controller.growthSchemes[index].riskLevel.toString(), style:  AppTextStyles.bodyMedium(color: Ucolors.darkgrey),),

                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text("Volatility", style:  AppTextStyles.bodyMedium(color: Ucolors.darkgrey),),
                  Text(controller.growthSchemes[index].riskLevel.toString(), style:  AppTextStyles.bodyMedium(color: Ucolors.darkgrey),),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text("Returns (S.I.)", style:  AppTextStyles.bodyMedium(color: Ucolors.darkgrey),),
                  Text(controller.growthSchemes[index].riskLevel.toString(), style:  AppTextStyles.bodyMedium(color: Ucolors.darkgrey),),

                ],
              ),
              const SizedBox(height: 10),
              Text("For SWP Tenure 5 Years and above", style: AppTextStyles.bodySmall(color: Ucolors.darkgrey),)
              // const Divider(height: 1, color: Color(0xFFE0E0E0)), // Replaced custom Dash with Divider
              // const SizedBox(height: 10),
              // FittedBox(
              //   fit: BoxFit.scaleDown,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       _buildStatItem(Icons.circle, Colors.red, controller.riskList[index]),
              //       const SizedBox(width: 12),
              //       _buildReturnItem("SIP Returns: ", controller.returnsList[index]),
              //       const SizedBox(width: 12),
              //       _buildStatItem(null, null, "Fund Age: ${controller.ageList[index]}", isAge: true),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatItem(IconData? icon, Color? color, String label, {bool isAge = false}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 8),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: AppTextStyles.bodySmall(
            color: isAge ? Colors.black : Colors.grey,
            size: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildReturnItem(String label, String value) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodySmall(color: Colors.grey, size: 11)),
        Text(
          value,
          style: AppTextStyles.bodySmall(color: Colors.green, size: 11),
        ),
        Text(" pa", style: AppTextStyles.bodySmall(color: Colors.grey, size: 11)),
      ],
    );
  }

  Widget _buildDesktopSidebar() {
    return SizedBox(
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
                  onPressed: controller.proceedToAccumulation,
                  child: Center(
                    child: Text(
                      'Proceed',
                      style: AppTextStyles.bodyMedium(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                UElevatedBUtton(
                  onPressed: controller.goBack,
                  outlined: true,
                  child: Center(
                    child: Text(
                      'Back',
                      style: AppTextStyles.bodyMedium(color: Ucolors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBottomBar() {
    return Container(
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
                onPressed: controller.goBack,
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
                onPressed: () => {
                  if(controller.isStep1Completed) {
                    Get.toNamed(AppRoutes.freedomSipScreen)
                  }
                },
                child: Center(
                  child: Text(
                    'Proceed',
                    style: AppTextStyles.bodyMedium(color: Colors.white),
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