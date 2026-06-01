// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_amount_selector.dart';
import 'package:my_sip/features/sip_process/presentation/widgets/sip_projection_chart.dart';
import '../../../../common/widget/animated/custom_footer.dart';
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
    // 🚀 Check for Web/Desktop
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : Ucolors.primary,

      bottomNavigationBar: isDesktop ? null : _buildMobileBottomNav(context),

      body: SafeArea(
        top: true,
        child: isDesktop
            ? _buildWebLayout(context) // 💻 Web UI
            : _buildMobileLayout(context), // 📱 Mobile UI
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (2-Column Card)
  // =========================================
  Widget _buildWebLayout(BuildContext context) {
    double width = Get.width * 0.75;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1000,
        ), // Perfect max-width for web
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Web Header ---
                Text(
                  "Plan Your Investment",
                  style: AppTextStyles.h2(color: Ucolors.dark),
                ),
                const SizedBox(height: 8),
                Text(
                  "Start small, grow big. Adjust the slider to see your projected wealth.",
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),

                // --- 2 Column Layout ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side: Inputs
                    Expanded(flex: 5, child: _buildInputSection()),
                    const SizedBox(width: 40),

                    // Right Side: Projection Chart
                    Expanded(flex: 6, child: _buildProjectionSection()),
                  ],
                ),

                const SizedBox(height: 40),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 24),

                // --- Action Buttons (Web) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 140,
                      child: UElevatedBUtton(
                        onPressed: () => Get.back(id: 1),
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
                    SizedBox(
                      width: 200,
                      child: UElevatedBUtton(
                        // 🚀 Web Nested Navigation
                        onPressed: () => Get.toNamed(
                          AppRoutes.investingApproachScreen,
                          id: 1,
                        ),
                        child: Center(
                          child: Text(
                            'Select Sip Fund',
                            style: AppTextStyles.bodyMedium(
                              color: Colors.white,
                            ),
                          ),
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
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT
  // =========================================
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // --- Mobile Header ---
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 30,
                    ),
                    child: _buildInputSection(),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildProjectionSection(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================
  // 🧩 REUSABLE WIDGETS
  // =========================================

  // 1. Input Section (Slider & Chips)
  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15.0),
        Obx(
          () => Text(
            controller.isLumpsum.value
                ? "Lumpsum Investment"
                : "Monthly Investment",
            style: AppTextStyles.bodyLargeBold(color: Ucolors.dark),
          ),
        ),
        Text(
          "Start small grow big. You can change this later",
          style: AppTextStyles.bodySmall(size: 10, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Obx(
          () => SipAmountSelector(
            label: "Select Amount(₹)",
            amount: controller.amount.value,
            onChanged: controller.updateAmount,
          ),
        ),
        const SizedBox(height: 16),
        AmountChipList(
          customAmounts: controller.currentChips,
          onSelected: (val) {
            if (controller.isLumpsum.value) {
              controller.updateAmount(val + controller.amount.value);
            } else {
              controller.updateAmount(val + controller.amount.value);
            }
          },
        ),
      ],
    );
  }

  // 2. Projection Card Section (Blue Gradient & Chart)
  Widget _buildProjectionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        children: [
          const SizedBox(height: 15),
          // Inner Dark Card (Values)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
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
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xff044973),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Projected Value (5y)",
                          style: AppTextStyles.h3(color: Colors.white),
                        ),
                        Obx(
                          () => Text(
                            controller.formatCurrency(
                              controller.totalProjected.value,
                            ),
                            style: AppTextStyles.bodyLarge(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Invested Amount",
                          style: AppTextStyles.bodyMedium(color: Colors.white),
                        ),
                        Obx(
                          () => Text(
                            controller.formatCurrency(
                              controller.totalInvested.value,
                            ),
                            style: AppTextStyles.bodyLarge(color: Colors.white),
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

          // Text Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expected Growth Value",
                  style: AppTextStyles.h3(color: Colors.white),
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
                          style: AppTextStyles.bodySmallBold(
                            color: const Color(0xffC9EAFB),
                          ),
                        ),
                        TextSpan(
                          text: ' by ',
                          style: AppTextStyles.bodySmall(
                            color: const Color(0xffC9EAFB),
                          ),
                        ),
                        TextSpan(
                          text: '${DateTime.now().year + 5}',
                          style: AppTextStyles.bodySmallBold(
                            color: const Color(0xffC9EAFB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Obx(
                //   () =>
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
                // ),
              ],
            ),
          ),

          // Chart Section
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 190,
              child: Obx(
                () => SipProjectionChart(
                  showLeftNumbers: true,
                  investedSpots: controller.chartInvestedSpots.toList(),
                  projectedSpots: controller.chartProjectedSpots.toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 3. Mobile Bottom Nav Bar
  Widget _buildMobileBottomNav(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        CustomFooter(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
                    onPressed: () => Get.back(),
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
                        controller.isLumpsum.value ? 'Lumpsum' : 'Sip',
                        style: AppTextStyles.bodyMedium(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
