import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FreedomSipScreen extends StatefulWidget {
  const FreedomSipScreen({super.key});

  @override
  State<FreedomSipScreen> createState() => _FreedomSipScreenState();
}

class _FreedomSipScreenState extends State<FreedomSipScreen> {
  @override
  Widget build(BuildContext context) {

    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Ucolors.primary,
      body: SafeArea(
        top: true,
        child: Column(
          children: [

            Padding(
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
            ),
            const SizedBox(height: 10.0),



            Expanded(
              child: Padding(

                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40.0 : 0.0,
                  vertical: isDesktop ? 20.0 : 0.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Expanded(
                      flex: 3,
                      child: Container(

                        margin: isDesktop ? const EdgeInsets.only(right: 20) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),

                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 5.0),
                              Text(
                                UText.freedomSipSubTitle,
                                style: AppTextStyles.bodyLargeBold(),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20.0),
                              buildFreedomSipCard(
                                context: context,
                                title: UText.freedomSipStep1Title,
                                desc: UText.freedomSipStep1desc,
                                buttonText: UText.freedomSipStep1button,
                              ),
                              const SizedBox(height: 15.0),
                              buildFreedomSipCard(
                                context: context,
                                title: UText.freedomSipStep2Title,
                                desc: UText.freedomSipStep2desc,
                                buttonText: UText.freedomSipStep2button,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),


                    if (isDesktop)
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
                                    onPressed: () {
                                      Get.toNamed(AppRoutes.sipTenureScreen);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Select Sip Fund',
                                        style: AppTextStyles.bodyMedium(
                                          color: Colors.white,
                                        ),
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
                ),
              ),
            ),
          ],
        ),
      ),


      bottomNavigationBar: isDesktop
          ? null
          : Container(
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
                      style: AppTextStyles.bodyMedium(
                        color: Ucolors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: UElevatedBUtton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.sipTenureScreen);
                  },
                  child: Center(
                    child: Text(
                      'Select SIP Fund',
                      style: AppTextStyles.bodyMedium(
                        color: Colors.white,
                      ),
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


  Widget buildFreedomSipCard({
    required BuildContext context,
    required String title,
    required String desc,
    required String buttonText,
  }) {
    return Container(
      width: double.infinity,

      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff07315C),
            Color(0xff07315C),
            Color(0xff0280C0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLargeBold(
                color: Colors.white,
                size: 18.0,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                desc,
                style: AppTextStyles.bodySmall(
                  color: Colors.white,
                  size: 13.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      buttonText,
                      style: AppTextStyles.bodySmall(color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}