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
import 'package:dropdown_button2/dropdown_button2.dart';

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Container(
          clipBehavior: Clip
              .antiAlias, // Ensures the left blue panel curves with the container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          // IntrinsicHeight makes both Expanded children stretch to the exact same height
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- LEFT SIDE: Projection Panel (Blue) ---
                Expanded(flex: 4, child: _buildLeftBluePanelWeb(context)),

                // --- RIGHT SIDE: Input Panel (White) ---
                Expanded(flex: 6, child: _buildRightWhitePanelWeb(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftBluePanelWeb(BuildContext context) {
    return Container(
      color: const Color(0xFF0061A0), // Dark blue background from the design
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "BUILD YOUR WEALTH WITH SIP",
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // --- Inner Value Card ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Projected Value (5Years)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.formatCurrency(
                          controller.totalProjected.value,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Invested Amount",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.formatCurrency(
                          controller.totalInvested.value,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // --- Chart Section ---
          Expanded(
            child: Center(
              child: Obx(
                () => SipProjectionChart(
                  showLeftNumbers: true,
                  // Make sure your chart supports white text so axis labels are visible!
                  // textColor: Colors.white,
                  investedSpots: controller.chartInvestedSpots.toList(),
                  projectedSpots: controller.chartProjectedSpots.toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Dynamic Disclaimer ---
          Center(
            child: Text(
              "*Based on historical returns of ${controller.expectedReturnRate.toStringAsFixed(0)}%. Past performance is not an indicator of\nfuture returns.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightWhitePanelWeb(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Input Section (Title, Chips, Dropdown) ---
          _buildInputSection(context),

          // Pushes the buttons to the very bottom of the card
          const Spacer(),
          const SizedBox(height: 32),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 24),

          // --- Bottom Action Buttons ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 140,
                child: UElevatedButtonWeb(
                  // Using the Web optimized button
                  onPressed: () => Get.back(id: 1),
                  outlined: true,
                  child: Text(
                    'Back',
                    style: AppTextStyles.bodyMedium(color: Ucolors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 200,
                child: UElevatedButtonWeb(
                  // Using the Web optimized button
                  onPressed: () =>
                      Get.toNamed(AppRoutes.investingApproachScreen, id: 1),
                  child: Text(
                    'Continue',
                    style: AppTextStyles.bodyMedium(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Quick helper function for "1st", "2nd", "3rd", "4th"
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
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
                    child: _buildInputSection(context),
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
  Widget _buildInputSection(BuildContext context) {
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
        const SizedBox(height: 32),
        controller.isLumpsum.value?SizedBox.shrink():
        Text(
          "SIP Date",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,

            valueListenable: controller.selectedSipDay,

            items: List.generate(
              28,
              (i) => DropdownItem<String>(
                value: '${i + 1}',
                child: Text(
                  '${controller.getOrdinal(i + 1)} of every month',
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF142438),
                  ),
                ),
              ),
            ),
            onChanged: (val) {
              if (val != null) {
                controller.selectedSipDay.value = val;
              }
            },
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                color: Colors.white,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: Colors.grey.shade600,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
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
                    color: Ucolors.primary,
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
