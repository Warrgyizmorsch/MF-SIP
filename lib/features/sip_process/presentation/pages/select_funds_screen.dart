import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_amount_selector.dart';
import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../common/widget/divider/thick_divider.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';

class SelectFundsScreen extends StatefulWidget {
  const SelectFundsScreen({super.key});

  @override
  State<SelectFundsScreen> createState() => _SelectFundsScreenState();
}

class _SelectFundsScreenState extends State<SelectFundsScreen> {
  final styleTags = ["12 - 15 % CAGR", "Medium Volatility", "Ideal for 5+ Years"];
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
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10.0),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(25.0)
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15.0),
                            Text(
                              "Balanced Investing Style",
                              style: AppTextStyles.bodyLargeBold(),
                            ),
                            RichText(                              maxLines: 2,
                                text: TextSpan(
                              text: "Investing in fundamentally strong, well - managed companies with",
                              style: AppTextStyles.bodySmall(size: 10, color: Colors.grey),
                              children: [
                                TextSpan(text: " Know More", style: AppTextStyles.bodySmallSemiBold(color: Colors.black45))
                              ]
                            )

                            ),
                            SizedBox(height: 5,),
                            Wrap(
                              spacing: 4.0,
                              runSpacing: 4.0,
                              children: styleTags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withAlpha(40),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    tag,
                                    style: AppTextStyles.bodySmall(size: 9.sp, color: Colors.black54),
                                  ),
                                );
                              }).toList(),
                            )

                          ],
                        ),
                      ),
                      ThickDivider(),
                      const SizedBox(height: 20),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20), child:
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "List Of Shortlisted high growth funds.",
                            style: AppTextStyles.bodyMediumBold(),
                          ),
                          Text(
                            "By MF radiant Finworld Team",
                            style: AppTextStyles.bodySmall(color: Colors.grey),
                          ),
                        ],
                      ),)
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
                    Get.toNamed(AppRoutes.investingApproachScreen);
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
