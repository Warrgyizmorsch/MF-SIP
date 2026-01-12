import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/commonslider/sip_slider_with_bg.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/helper/helpers.dart';
import '../widgets/sip_amount_selector.dart';

class SipTenureScreen extends StatefulWidget {
  const SipTenureScreen({super.key});

  @override
  State<SipTenureScreen> createState() => _SipTenureScreenState();
}

class _SipTenureScreenState extends State<SipTenureScreen> {
  double years = 5;
  double amount = 1000;

  void _updateAmount(double targetAmount) {
    setState(() {
      if (targetAmount < 0) return;
      amount = targetAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.primary,



      body: SafeArea(
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


            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(UText.sipTenureTitle, style: AppTextStyles.bodyLargeBold()),
                        const SizedBox(height: 5),
                        Text(UText.sipTenureDrag, style: AppTextStyles.bodySmall(color: Colors.grey)),
                        const SizedBox(height: 15),


                        SipSliderWithBg(
                          title: "Enter Customer Tenure",
                          value: years,
                          min: 1,
                          max: 30,
                          suffix: 'Years',
                          onChanged: (double value) {
                            setState(() {
                              years = value;
                            });
                          },
                          activeColor: Color(0xff07315C),
                        ),

                        const SizedBox(height: 25),



                        SipAmountSelector(
                          label: "Enter SIP Amount",
                          amount: amount,
                          onChanged: _updateAmount,
                        ),


                        const SizedBox(height: 25),

                        AmountChipList(
                          onSelected: (double amt) {
                            _updateAmount( amount + amt);
                          },
                        )





                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),


      bottomNavigationBar:Container(
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
                    Get.toNamed(AppRoutes.growthSchemeScreen);
                  },
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
      ),
    );
  }
}




