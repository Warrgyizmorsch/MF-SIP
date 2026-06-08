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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
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
                  "Choose Your Approach",
                  style: AppTextStyles.h2(color: Ucolors.dark),
                ),
                const SizedBox(height: 8),
                Text(
                  "Hi ${session.getUserData?.name ?? 'User'}, let's pick the best way to invest your money.",
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
                    // Left Side: Profile Summary (Blue Box)
                    Expanded(flex: 5, child: _buildProfileSection(session)),
                    const SizedBox(width: 40),

                    // Right Side: Approach Selection
                    Expanded(flex: 6, child: _buildSelectionSection()),
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
                        onPressed: () =>
                            Get.toNamed(AppRoutes.selectFundsScreen, id: 1),
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
              '${session.riskScoreObs.value?.profileName ?? ''}',
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
