import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';

import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';

class InvestingApproachScreen extends StatefulWidget {
  const InvestingApproachScreen({super.key});

  @override
  State<InvestingApproachScreen> createState() =>
      _InvestingApproachScreenState();
}

class _InvestingApproachScreenState extends State<InvestingApproachScreen> {
  int _selectedApproach = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.primary,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15.0),
                            Text(
                              "Hi Prateek,",
                              style: AppTextStyles.bodyLargeBold(),
                            ),
                            Text(
                              "According to your inputs your investing style is",
                              style: AppTextStyles.bodySmall(
                                size: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Ucolors.blue,
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Ucolors.blue, Ucolors.primary],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8,
                                  top: 8,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(UImages.tickInCircle),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Your Profile",
                                      style: AppTextStyles.bodyLargeBold(
                                        color: Ucolors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              _buildProfileRow(
                                UImages.logoAccount,
                                "Investor Type",
                                "Experienced Investor",
                              ),
                              const SizedBox(height: 10),
                              _buildProfileRow(
                                UImages.logoShield,
                                "Risk Appetite",
                                "High",
                              ),
                              const SizedBox(height: 10),
                              _buildProfileRow(
                                UImages.logoCurrency,
                                "Monthly SIP",
                                "₹ 5,000",
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Select Your Investing Approach",
                              style: AppTextStyles.bodyLargeBold(),
                            ),
                            const SizedBox(height: 10),

                            _buildSelectionCard(
                              index: 0,
                              iconPath: UImages.logoHighGrowthFunds,
                              topText: "Fund Recommendation",
                              mainText: "Best High Growth Funds",
                              subText:
                                  "List of funds suggested by mutual fund analysis",
                            ),

                            const SizedBox(height: 10),

                            _buildSelectionCard(
                              index: 1,
                              iconPath: UImages.logoHighGrowthFunds,
                              topText: "Readymade Portfolio",
                              mainText: "Suggested Portfolio",
                              subText: "Model portfolio created by expert team",
                            ),

                            const SizedBox(height: 20),
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
                    Get.toNamed(AppRoutes.selectFundsScreen);
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

  Widget _buildSelectionCard({
    required int index,
    required String iconPath,
    required String topText,
    required String mainText,
    required String subText,
  }) {
    final isSelected = _selectedApproach == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedApproach = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? null : Colors.white,

          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFD7EFFF), Color(0xFFFFFFFF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          border: Border.all(
            color: isSelected ? Ucolors.primary : Colors.grey,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topText, style: AppTextStyles.bodySmall(size: 10)),
                  const SizedBox(height: 2),
                  Text(mainText, style: AppTextStyles.bodyLargeSemiBold()),
                  const SizedBox(height: 2),
                  Text(
                    subText,
                    style: AppTextStyles.bodySmall(size: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 24,
              spreadRadius: -1,
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xffE4E4E4),
              Color(0xffA2A2A2),
              Color(0xff494949),
              Color(0xffA9A9A9),
              Color(0xff060606),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xff07609e),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              SvgPicture.asset(icon),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge(color: Ucolors.textLight),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
