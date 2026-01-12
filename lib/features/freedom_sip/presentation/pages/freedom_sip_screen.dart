import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class FreedomSipScreen extends StatefulWidget {
  const FreedomSipScreen({super.key});

  @override
  State<FreedomSipScreen> createState() => _FreedomSipScreenState();
}

class _FreedomSipScreenState extends State<FreedomSipScreen> {
  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 10.0,),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0)
          ),
          child: Column(
            spacing: 10.0,
            children: [
              SizedBox(height: 5.0,),
              Text(UText.freedomSipSubTitle, style: AppTextStyles.bodyLargeBold(),),
              buildFreedomSipCard(
                  context: context,
                  title: UText.freedomSipStep1Title,
                  desc: UText.freedomSipStep1desc,
                  buttonText: UText.freedomSipStep1button
              ),
              buildFreedomSipCard(
                  context: context,
                  title: UText.freedomSipStep2Title,
                  desc: UText.freedomSipStep2desc,
                  buttonText: UText.freedomSipStep2button
              )
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
                    Get.toNamed(AppRoutes.sipTenureScreen);
                  },
                  child: Center(
                    child: Text(
                      'Select Sip Fund',
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


buildFreedomSipCard(
    {required BuildContext context, required String title, required String desc, required String buttonText}) {


  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xff07315C),
            Color(0xff07315C),
            Color(0xff0280C0)
          ])

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          spacing: 10.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodyLargeBold(color: Colors.white),),
            Text(desc, style: AppTextStyles.bodySmall(color: Colors.white),),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),


                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(buttonText, style: AppTextStyles.bodySmall(color: Colors.black),),
                    Icon(Icons.arrow_forward, color: Colors.black,size: 15.0,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}