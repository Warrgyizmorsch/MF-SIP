import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/commonslider/sip_slider_with_bg.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../controllers/freedom_sip_controller.dart';
import '../widgets/sip_amount_selector.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SipTenureScreen extends GetView<FreedomSipController> {
  const SipTenureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Ucolors.primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40.0 : 10.0,
                  vertical: isDesktop ? 20.0 : 0.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Obx(() => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                UText.sipTenureTitle,
                                style: AppTextStyles.bodyLargeBold(),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                UText.sipTenureDrag,
                                style: AppTextStyles.bodySmall(color: Colors.grey),
                              ),
                              const SizedBox(height: 25),
                              SipSliderWithBg(
                                title: "Enter Customer Tenure",
                                value: controller.years.value,
                                min: 1,
                                max: 30,
                                suffix: 'Years',
                                onChanged: (double value) => controller.years.value = value,
                                activeColor: const Color(0xff07315C),
                              ),
                              const SizedBox(height: 25),
                              SipAmountSelector(
                                label: "Enter SIP Amount",
                                amount: controller.amount.value,
                                onChanged: controller.updateAmount,
                              ),
                              const SizedBox(height: 25),
                              AmountChipList(
                                onSelected: (double amt) {
                                  controller.updateAmount(controller.amount.value + amt);
                                },
                              )
                            ],
                          ),
                        )),
                      ),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 20),
                      _buildSidebarActions(),
                    ],
                  ],
                ),
              ),
            ),
            if (!isDesktop) const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: isDesktop ? null : _buildMobileNav(),
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

  Widget _buildSidebarActions() {
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
                  onPressed: controller.toGrowthScheme,
                  child: Center(
                    child: Text(
                      'Next',
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

  Widget _buildMobileNav() {
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
                onPressed: controller.isSwpFlow.value ? controller.toFreedomSip: controller.toGrowthScheme,
                child: Center(
                  child: Text(
                    'Next',
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

