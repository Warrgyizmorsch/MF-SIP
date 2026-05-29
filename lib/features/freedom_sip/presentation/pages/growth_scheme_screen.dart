import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';

class GrowthSchemeScreen extends StatefulWidget {
  const GrowthSchemeScreen({super.key});

  @override
  State<GrowthSchemeScreen> createState() => _GrowthSchemeScreenState();
}

class _GrowthSchemeScreenState extends State<GrowthSchemeScreen> {

  final mutualFundController = Get.find<MutualFundController>();
   late final growthSchemes = mutualFundController.mutualfund;


  final list = [
    "Motilal Ostwal Small Cap Fund",
    "Bandhan Midcap Fund",
    "Parag Parikh Flexi Cap Fund",
    "SBI Banking & Financial Services",
    "HDFC Top 100 Fund",
    "ICICI Prudential Bluechip Fund"
  ];
  final risk = [
    "Very High Risk",
    "Very High Risk",
    "Very High Risk",
    "Very High Risk",
    "High Risk",
    "High Risk"
  ];
  final returns = ["29.89%", "29.89%", "29.89%", "29.89%", "15.5%", "14.2%"];
  final ageList = ["27 Year", "27 Year", "27 Year", "27 Year", "10 Year", "15 Year"];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {

    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Ucolors.primary,

      bottomNavigationBar: isDesktop ? null : _buildMobileBottomBar(context),

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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      UText.growthSchemeScreenTitle,
                                      style: AppTextStyles.bodyLargeBold()
                                  ),
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

                              child: _buildSchemeList(),
                            ),
                          ],
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
                                    color: Colors.black.withValues(alpha:0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UElevatedBUtton(
                                    onPressed: _onProceed,
                                    child: Center(
                                      child: Text(
                                        'Proceed',
                                        style: AppTextStyles.bodyMedium(
                                            color: Colors.white),
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
                                            color: Ucolors.primary),
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
    );
  }


  Widget _buildSchemeList() {

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: growthSchemes.length.clamp(0, 4),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildSchemeCard(index),
    );
  }

  Widget _buildSchemeCard(int index) {
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
          color: isSelected ? Ucolors.primary.withValues(alpha:0.2) : Colors.white,
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
                CustomCachedImage(imageUrl: growthSchemes[index].amc?.amcLogoUrl),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    growthSchemes[index].baseSchemeName ?? '',
                    style: AppTextStyles.bodyMediumSemiBold(),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            DashedLine(color: Colors.grey.shade400),
            const SizedBox(height: 10),


            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.red, size: 8),
                      const SizedBox(width: 4),
                      Text(
                        risk[index],
                        style: AppTextStyles.bodySmall(
                            color: Colors.grey, size: 11),
                      ),
                    ],
                  ),


                  const SizedBox(width: 12),


                  Row(
                    children: [
                      Text("SIP Returns: ",
                          style: AppTextStyles.bodySmall(
                              color: Colors.grey, size: 11)),
                      Text(
                        returns[index],
                        style: AppTextStyles.bodySmall(
                            color: Colors.green, size: 11),
                      ),
                      Text(
                        " pa",
                        style: AppTextStyles.bodySmall(color: Colors.grey),
                      )
                    ],
                  ),

                  const SizedBox(width: 12),


                  Row(
                    children: [
                      Text("Fund Age: ",
                          style: AppTextStyles.bodySmall(
                              color: Colors.grey, size: 11)),
                      Text(
                        ageList[index],
                        style: AppTextStyles.bodySmall(
                            color: Colors.black, size: 11),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void _onProceed() {
    if (_selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a scheme to proceed"))
      );
      return;
    }
    Get.toNamed(AppRoutes.accumulationanddistributionscreen);
  }


  Widget _buildMobileBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
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
                onPressed: _onProceed,
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