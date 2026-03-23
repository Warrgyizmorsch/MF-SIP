import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_amount_selector.dart';
import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../controllers/sip_process_controller.dart';

class MonthlySipScreen extends GetView<SipProcessController> {
  const MonthlySipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.primary,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Header ---
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

              // --- White Container ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Input Section ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15.0),
                            // Text(
                            //   "Monthly Investment",
                            //   style: AppTextStyles.bodyLargeBold(),
                            // ),
                            Obx(
                              () => Text(
                                controller.isLumpsum.value
                                    ? "Lumpsum Investment"
                                    : "Monthly Investment",
                                style: AppTextStyles.bodyLargeBold(),
                              ),
                            ),
                            Text(
                              "Start small grow big. You can change this later",
                              style: AppTextStyles.bodySmall(
                                size: 10,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Obx needed here: Updates slider/input UI when amount changes
                            Obx(
                              () => SipAmountSelector(
                                label: "Select Amount(₹)",
                                amount: controller.amount.value,
                                onChanged: controller.updateAmount,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // No Obx needed here: The list doesn't change, only the click action
                            AmountChipList(
                              customAmounts: controller.currentChips,
                              onSelected: (val) {
                                // For Lumpsum, we usually replace the value rather than adding to it
                                if (controller.isLumpsum.value) {
                                  controller.updateAmount(
                                    val + controller.amount.value,
                                  );
                                } else {
                                  controller.updateAmount(
                                    val + controller.amount.value,
                                  );
                                }
                              },

                              // onSelected: (val) {
                              //   controller.updateAmount(
                              //       val + controller.amount.value);
                              // },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- Projection Card Section ---
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
                              const SizedBox(height: 15),

                              // --- Inner Dark Card (Values) ---
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                ),
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
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff044973),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Projected Value (5y)",
                                              style: AppTextStyles.h3(
                                                color: Colors.white,
                                              ),
                                            ),
                                            // Dynamic Projected Value
                                            Obx(
                                              () => Text(
                                                controller.formatCurrency(
                                                  controller
                                                      .totalProjected
                                                      .value,
                                                ),
                                                style: AppTextStyles.bodyLarge(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Invested Amount",
                                              style: AppTextStyles.bodyMedium(
                                                color: Colors.white,
                                              ),
                                            ),
                                            // Dynamic Invested Amount
                                            Obx(
                                              () => Text(
                                                controller.formatCurrency(
                                                  controller
                                                      .totalInvested
                                                      .value,
                                                ),
                                                style: AppTextStyles.bodyLarge(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // --- Text Description ---
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Expected Growth Value",
                                      style: AppTextStyles.h3(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Obx(
                                      () => RichText(
                                        text: TextSpan(
                                          text: "Your wealth will grow to",
                                          style: AppTextStyles.bodySmall(
                                            color: const Color(0xffC9EAFB),
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' ${controller.formatCurrency(controller.totalProjected.value)}',
                                              style:
                                                  AppTextStyles.bodySmallBold(
                                                    color: const Color(
                                                      0xffC9EAFB,
                                                    ),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: ' by ',
                                              style: AppTextStyles.bodySmall(
                                                color: const Color(0xffC9EAFB),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${DateTime.now().year + 5}',
                                              style:
                                                  AppTextStyles.bodySmallBold(
                                                    color: const Color(
                                                      0xffC9EAFB,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "assuming",
                                        style: AppTextStyles.bodySmall(
                                          color: const Color(0xffC9EAFB),
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                ' ${controller.expectedReturnRate.toStringAsFixed(0)}% ',
                                            style: AppTextStyles.bodySmallBold(
                                              color: const Color(0xffC9EAFB),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'returns (p.a.) ',
                                            style: AppTextStyles.bodySmall(
                                              color: const Color(0xffC9EAFB),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // --- Chart Section ---
                              Center(
                                child: SizedBox(
                                  height: 190,
                                  // Dynamic Chart Data
                                  child: Obx(
                                    () => SipProjectionChart(
                                      showLeftNumbers: false,
                                      investedSpots: controller
                                          .chartInvestedSpots
                                          .toList(),
                                      projectedSpots: controller
                                          .chartProjectedSpots
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
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
                  onPressed: () =>
                      Get.toNamed(AppRoutes.investingApproachScreen),
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
