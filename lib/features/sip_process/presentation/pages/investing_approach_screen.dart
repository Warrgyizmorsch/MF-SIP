
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/services/session_manager.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/images.dart';
import '../../../../core/utils/constant/text.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../controllers/sip_process_controller.dart';

class InvestingApproachScreen extends GetView<SipProcessController> {
  const InvestingApproachScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

  Widget _buildWebLayout(BuildContext context) {
    final session = SessionManager.instance;

    return Center(
      // Padding ensures it doesn't touch the edges on smaller web screens
      child:LayoutBuilder(
          builder: (context, constraints) {
            final double isWideScreen = constraints.maxWidth*0.9;

            final double availableHeight = constraints.maxHeight*0.9;

            return ConstrainedBox(
              constraints:  BoxConstraints(maxWidth: isWideScreen,maxHeight: availableHeight),
            child: Container(
              clipBehavior: Clip.antiAlias,
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
              child: Row(
                // 3. Stretch forces both the Left and Right panels to be exactly 650px tall
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Blue Panel (Your Profile)
                  Expanded(
                    flex: 4,
                    child: _buildLeftProfilePanel(session),
                  ),
                  // Right White Panel (Strategy Selection)
                  Expanded(
                    flex: 6,
                    child: _buildRightSelectionPanel(context),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildLeftProfilePanel(SessionManager session) {
    return Container(
      color: const Color(0xFF0061A0),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.trending_up, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                "BUILD YOUR WEALTH WITH SIP",
                style: TextStyle(
                  fontFamily: FontFamily.medium, // Make sure your font family is imported
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),

          Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                "Your Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Profile Detail Cards
          _buildProfileDetailCard(
            icon: Icons.person_outline,
            title: "Investor Type",
            value: "Experienced Investor",
          ),
          const SizedBox(height: 16),
          _buildProfileDetailCard(
            icon: Icons.shield_outlined,
            title: "Risk Appetite",
            value:  session.riskScoreObs.value?.profileName ?? '',
          ),
          const SizedBox(height: 16),
          Obx(
                () => _buildProfileDetailCard(
              icon: Icons.money,
              title: "Monthly SIP",
              // Assuming you have formatCurrency available in your controller
              value: controller.formatCurrency(controller.amount.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1), // Updated to withValues for newer Flutter versions
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12), // Match the inner card rounding of the example
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildRightSelectionPanel(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose Strategy",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF142438),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "How would you like to build your portfolio?",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),

          // CRITICAL FIX 2: Added 'Expanded' and 'stretch' to this Row
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Obx(
                        () => _buildStrategyCard(
                      index: 0,
                      isSelected: controller.selectedApproach.value == 0,
                      icon: Icons.bar_chart,
                      title: "Best High Growth Funds",
                      description: "Select from top-rated individual funds suggested by our analysts for maximum returns.",
                      features: ["15-18% Hist. Returns", "Direct Plans"],
                      onTap: () => controller.selectApproach(0),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Obx(
                        () => _buildStrategyCard(
                      index: 1,
                      isSelected: controller.selectedApproach.value == 1,
                      icon: Icons.pie_chart_outline,
                      title: "Curated Portfolio",
                      description: "A ready-made basket of funds diversified across sectors to minimize risk.",
                      features: ["Auto-Rebalancing", "Expert Managed"],
                      onTap: () => controller.selectApproach(1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Note: Removed the Spacer() from here, the Expanded above handles the spacing beautifully now!
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
                child: UElevatedButtonWeb(
                  onPressed: () => Get.toNamed(AppRoutes.selectFundsScreen, id: 1),
                  child: Center(
                    child: Text(
                      'Continue',
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
    );
  }

  Widget _buildStrategyCard({
    required int index,
    required bool isSelected,
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F8FB) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF0B598F) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon and Radio Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0B598F) : const Color(0xFFF0F4F8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : const Color(0xFF0B598F),
                    size: 24,
                  ),
                ),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? const Color(0xFF0B598F) : Colors.grey.shade300,
                ),
              ],
            ),
            const SizedBox(height: 6),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF142438),
              ),
            ),
            const SizedBox(height: 6),

            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const Spacer(),

            // Checkmark Features
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  // --- Bottom Action Buttons ---
  Widget _buildBottomActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 18, color: Colors.grey.shade600),
          label: Text(
            "Back",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        // Continue Button
        ElevatedButton(
          onPressed: () {}, // Connect to Get.toNamed()
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0073C6), // Bright blue matching image
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Row(
            children: const [
              Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 18, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildMobileLayout(BuildContext context) {
    final session = SessionManager.instance;
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
                          "Hi ${session.getUserData?.name ?? 'User'},",
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

                  // Blue Box
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildProfileSection(session),
                  ),

                  // Selection
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildSelectionSection(),
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

  Widget _buildProfileSection(SessionManager session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
            child: Row(
              children: [
                SvgPicture.asset(UImages.tickInCircle),
                const SizedBox(width: 5),
                Text(
                  "Your Profile",
                  style: AppTextStyles.bodyLargeBold(color: Ucolors.textLight),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          _buildProfileRow(
            UImages.logoAccount,
            "Investor Type",
            "Experienced Investor",
          ),
          const SizedBox(height: 10),
          Obx(
            () => _buildProfileRow(
              UImages.logoShield,
              "Risk Appetite",
              session.riskScoreObs.value?.profileName ?? '',
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => _buildProfileRow(
              UImages.logoCurrency,
              "Monthly SIP",
              controller.formatCurrency(controller.amount.value),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Selection Section
  Widget _buildSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          "Select Your Investing Approach",
          style: AppTextStyles.bodyLargeBold(),
        ),
        const SizedBox(height: 15),

        // Option 0: Best Funds
        Obx(
          () => _buildSelectionCard(
            index: 0,
            isSelected: controller.selectedApproach.value == 0,
            iconPath: UImages.logoHighGrowthFunds,
            topText: "Fund Recommendation",
            mainText: "Best High Growth Funds",
            subText: "List of funds suggested by mutual fund analysis",
            onTap: () => controller.selectApproach(0),
          ),
        ),
        const SizedBox(height: 15),

        // Option 1: Readymade Portfolio
        Obx(
          () => _buildSelectionCard(
            index: 1,
            isSelected: controller.selectedApproach.value == 1,
            iconPath: UImages.logoSuggestedPortfolio,
            topText: "Readymade Portfolio",
            mainText: "Suggested Portfolio",
            subText: "Model portfolio created by expert team",
            onTap: () => controller.selectApproach(1),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required int index,
    required bool isSelected,
    required String iconPath,
    required String topText,
    required String mainText,
    required String subText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
            color: isSelected ? Ucolors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, height: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topText,
                    style: AppTextStyles.bodySmall(
                      size: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(mainText, style: AppTextStyles.bodyLargeSemiBold()),
                  const SizedBox(height: 4),
                  Text(
                    subText,
                    style: AppTextStyles.bodySmall(size: 11),
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
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xff07609e),
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Row(
            children: [
              SvgPicture.asset(icon, height: 24),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall(color: Ucolors.textLight),
                  ),
                  const SizedBox(height: 2),
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

  Widget _buildMobileBottomNav(BuildContext context) {
    return Container(
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

                onPressed: () {
                  Get.toNamed(AppRoutes.selectFundsScreen);
                },
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
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/services/session_manager.dart';
// import '../../../../common/widget/button/elevated_button.dart';
// import '../../../../core/utils/constant/colors.dart';
// import '../../../../core/utils/constant/images.dart';
// import '../../../../core/utils/constant/text.dart';
// import '../../../../core/utils/constant/text_style.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../controllers/sip_process_controller.dart';

// class InvestingApproachScreen extends GetView<SipProcessController> {
//   const InvestingApproachScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final session = SessionManager.instance;

//     return Scaffold(
//       backgroundColor: Ucolors.primary,
//       body: SafeArea(
//         top: true,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // --- Header ---
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(UImages.mfLogoLight, height: 20),
//                     const SizedBox(width: 10),
//                     Text(
//                       UText.freedomSipTitle,
//                       style: AppTextStyles.bodyLarge(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10.0),

//               // --- Main Content ---
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 8.0,
//                           horizontal: 30,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 15.0),
//                             Text(
//                               "Hi ${session.getUserData?.name ?? 'User'},",
//                               style: AppTextStyles.bodyLargeBold(),
//                             ),
//                             Text(
//                               "According to your inputs your investing style is",
//                               style: AppTextStyles.bodySmall(
//                                 size: 10,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 5),

//                       // --- Blue Profile Box ---
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: Ucolors.blue,
//                             borderRadius: BorderRadius.circular(20),
//                             gradient: LinearGradient(
//                               colors: [Ucolors.blue, Ucolors.primary],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.max,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   left: 8.0,
//                                   right: 8,
//                                   top: 8,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     SvgPicture.asset(UImages.tickInCircle),
//                                     const SizedBox(width: 5),
//                                     Text(
//                                       "Your Profile",
//                                       style: AppTextStyles.bodyLargeBold(
//                                         color: Ucolors.textLight,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 10),

//                               _buildProfileRow(
//                                 UImages.logoAccount,
//                                 "Investor Type",
//                                 "Experienced Investor", // Static for now
//                               ),
//                               const SizedBox(height: 10),
//                               Obx(
//                                 () => _buildProfileRow(
//                                   UImages.logoShield,
//                                   "Risk Appetite",
//                                   // "High", // Static for now
//                                   '${session.riskScoreObs.value?.profileName ?? ''}',
//                                 ),
//                               ),
//                               const SizedBox(height: 10),

//                               // DYNAMIC AMOUNT ROW
//                               Obx(
//                                 () => _buildProfileRow(
//                                   UImages.logoCurrency,
//                                   "Monthly SIP",
//                                   controller.formatCurrency(
//                                     controller.amount.value,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // --- Selection Section ---
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 10),
//                             Text(
//                               "Select Your Investing Approach",
//                               style: AppTextStyles.bodyLargeBold(),
//                             ),
//                             const SizedBox(height: 10),

//                             // Option 0: Best Funds
//                             Obx(
//                               () => _buildSelectionCard(
//                                 index: 0,
//                                 isSelected:
//                                     controller.selectedApproach.value == 0,
//                                 iconPath: UImages.logoHighGrowthFunds,
//                                 topText: "Fund Recommendation",
//                                 mainText: "Best High Growth Funds",
//                                 subText:
//                                     "List of funds suggested by mutual fund analysis",
//                                 onTap: () => controller.selectApproach(0),
//                               ),
//                             ),

//                             const SizedBox(height: 10),

//                             // Option 1: Readymade Portfolio
//                             Obx(
//                               () => _buildSelectionCard(
//                                 index: 1,
//                                 isSelected:
//                                     controller.selectedApproach.value == 1,
//                                 iconPath: UImages.logoSuggestedPortfolio,
//                                 topText: "Readymade Portfolio",
//                                 mainText: "Suggested Portfolio",
//                                 subText:
//                                     "Model portfolio created by expert team",
//                                 onTap: () => controller.selectApproach(1),
//                               ),
//                             ),

//                             const SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha:0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Row(
//             children: [
//               Expanded(
//                 child: UElevatedBUtton(
//                   onPressed: () => Navigator.pop(context),
//                   outlined: true,
//                   child: Center(
//                     child: Text(
//                       'Back',
//                       style: AppTextStyles.bodyMedium(color: Ucolors.primary),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: UElevatedBUtton(
//                   onPressed: () {
//                     Get.toNamed(AppRoutes.selectFundsScreen);
//                   },
//                   child: Center(
//                     child: Text(
//                       'Select Sip Fund',
//                       style: AppTextStyles.bodyMedium(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectionCard({
//     required int index,
//     required bool isSelected,
//     required String iconPath,
//     required String topText,
//     required String mainText,
//     required String subText,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: isSelected ? null : Colors.white,
//           gradient: isSelected
//               ? const LinearGradient(
//                   colors: [Color(0xFFD7EFFF), Color(0xFFFFFFFF)],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 )
//               : null,
//           border: Border.all(
//             color: isSelected ? Ucolors.primary : Colors.grey,
//             width: isSelected ? 1.5 : 1.0,
//           ),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SvgPicture.asset(iconPath),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(topText, style: AppTextStyles.bodySmall(size: 10)),
//                   const SizedBox(height: 2),
//                   Text(mainText, style: AppTextStyles.bodyLargeSemiBold()),
//                   const SizedBox(height: 2),
//                   Text(
//                     subText,
//                     style: AppTextStyles.bodySmall(size: 10),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileRow(String icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha:0.3),
//               offset: const Offset(0, 4),
//               blurRadius: 24,
//               spreadRadius: -1,
//             ),
//           ],
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xffE4E4E4),
//               Color(0xffA2A2A2),
//               Color(0xff494949),
//               Color(0xffA9A9A9),
//               Color(0xff060606),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(6.0),
//         ),
//         padding: const EdgeInsets.all(1.0),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
//           decoration: BoxDecoration(
//             color: const Color(0xff07609e),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: Row(
//             children: [
//               SvgPicture.asset(icon),
//               const SizedBox(width: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: AppTextStyles.bodyLarge(color: Ucolors.textLight),
//                   ),
//                   Text(
//                     value,
//                     style: AppTextStyles.bodyMedium(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }