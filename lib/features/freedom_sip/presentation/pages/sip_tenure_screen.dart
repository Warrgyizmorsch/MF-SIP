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



                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Enter SIP Amount(₹)", style: AppTextStyles.bodySmall()),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      priceFormatter.format(amount),
                                      style: AppTextStyles.bodyLarge(size: 28),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () => _updateAmount(amount + 1000),
                                          child: const Align(
                                            heightFactor: 0.4,
                                            child: Icon(Icons.arrow_drop_up, size: 40, color: Colors.grey),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => _updateAmount(amount - 1000),
                                          child: const Align(
                                            heightFactor: 0.4,
                                            child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),


                              AmountChipList(
                                onSelected: (val) {
                                  _updateAmount(amount + val);
                                },
                              ),
                            ],
                          ),
                        ),





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

class AmountChipList extends StatelessWidget {
  final List<double> amountList = const [1000, 2000, 5000, 10000];
  final ValueChanged<double> onSelected;

  const AmountChipList({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: amountList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final amt = amountList[index];
          return GestureDetector(
            onTap: () => onSelected(amt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                "+${priceFormatter.format(amt)}",
                style: AppTextStyles.bodySmall(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}