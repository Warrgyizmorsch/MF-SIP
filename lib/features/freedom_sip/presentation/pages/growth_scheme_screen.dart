import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../mf/screen/fund_details/fund_deatails.dart';

class GrowthSchemeScreen extends StatefulWidget {
  const GrowthSchemeScreen({super.key});

  @override
  State<GrowthSchemeScreen> createState() => _GrowthSchemeScreenState();
}

class _GrowthSchemeScreenState extends State<GrowthSchemeScreen> {
  final list = [
    "Motilal Ostwal Small Cap Fund",
    "Bandhan Midcap Fund",
    "Parag Parikh Flexi Cap Fund",
    "SBI Banking & Financial Services"
  ];
  final risk = ["Very High Risk", "Very High Risk", "Very High Risk", "Very High Risk"];
  final returns = ["29.89%", "29.89%", "29.89%", "29.89%"];
  final ageList = ["27 Year", "27 Year", "27 Year", "27 Year"];


  int _selectedIndex = -1;

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
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(UText.growthSchemeScreenTitle,
                                style: AppTextStyles.bodyLargeBold()),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                text: UText.growthSchemeScreenKnowMore,
                                style: AppTextStyles.bodySmall(color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: "Know More",
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
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          itemCount: list.length,
                          separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                          itemBuilder: (context, index) {


                            final isSelected = _selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(

                                  color: isSelected
                                      ? Ucolors.primary.withOpacity(0.2)
                                      : Colors.white,


                                  border: Border.all(
                                    color: isSelected
                                        ? Ucolors.primary
                                        : Colors.grey.shade300,
                                    width: isSelected ? 1.5 : 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  children: [

                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: AssetImage(UImages.sbi),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            list[index],
                                            style: AppTextStyles.bodyMediumSemiBold(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 10),



                                    DashedLine(color: Colors.grey.shade400),

                                    const SizedBox(height: 10),

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.circle,
                                                color: Colors.red, size: 8),
                                            const SizedBox(width: 4),
                                            Text(
                                              risk[index],
                                              style: AppTextStyles.bodySmall(
                                                  color: Colors.grey, size: 11),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("SIP Returns: ",
                                                style: AppTextStyles.bodySmall(
                                                    color: Colors.grey,
                                                    size: 11)),
                                            Text(
                                              returns[index],
                                              style: AppTextStyles.bodySmall(
                                                  color: Colors.green,
                                                  size: 11),
                                            ),
                                            Text(
                                              "pa",
                                              style: AppTextStyles.bodySmall(
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Fund Age: ",
                                                style: AppTextStyles.bodySmall(
                                                    color: Colors.grey,
                                                    size: 11)),
                                            Text(
                                              ageList[index],
                                              style: AppTextStyles.bodySmall(
                                                  color: Colors.black,
                                                  size: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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

                    if (_selectedIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please select a scheme to proceed"))
                      );
                      return;
                    }
                    Get.toNamed(AppRoutes.accumulationanddistributionscreen);
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
      ),
    );
  }
}