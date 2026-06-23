import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure GetX is imported for Obx support
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';
import '../../../../core/utils/constant/text_style.dart';

class KycDetailsScreen extends StatelessWidget {
  const KycDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: isDesktop ? null : CustomAppBarNormal(title: 'KYC Details'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: isDesktop ? const EdgeInsets.all(24) : UPadding.screenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            // Wrap the layouts with Obx to establish structural reactivity
            child: Obx(() => isDesktop
                ? _buildWebDashboardLayout()
                : _buildMobileLayout()),
          ),
        ),
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (Side-by-Side Dashboard)
  // =========================================
  Widget _buildWebDashboardLayout() {
    final user = SessionManager.instance.userObs.value;
    final String readySinceYear = user?.customerDetailsModel?.dob?.split('-').firstOrNull ?? '---';
    final String taxStatusName = ProfileUtils.getWealthSourceName(
      int.tryParse(user?.customerDetailsModel?.wealthSource ?? ''),
    ) ?? 'Salary';
    final bool hasRiskProfile = user?.riskProfileModel?.profileName != null;
    final bool isKycApproved = user?.kycStatus?.toLowerCase() == 'approved';
    final bool isPanVerified = user?.panCard != null && user!.panCard!.isNotEmpty;
    final bool isRiskProfileUpdated = user?.riskProfileModel != null;
    final String aadhaarDisplay = user?.customerDetailsModel?.adhar ?? '---';
    final bool hasAadhaar = aadhaarDisplay.isNotEmpty && aadhaarDisplay != '---';
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Left Column: KYC Verification Overview Checklist Module
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Color(0xFF1F9254), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'KYC Overview',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1D20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Your KYC is verified and up to date.', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 20),

                  _buildWebCheckmarkItem(
                    'KYC Verified',
                    isValid: isKycApproved,
                  ),
                  _buildWebCheckmarkItem(
                    'PAN Verified',
                    isValid: isPanVerified,
                  ),
                  _buildWebCheckmarkItem(
                    'Risk Profile Updated',
                    isValid: isRiskProfileUpdated,
                  ),

                  const SizedBox(height: 24),

                  /// Premium Shield Compliance Callout
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: Color(0xFF0066FF), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Secure & Compliant', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF0066FF))),
                              SizedBox(height: 4),
                              Text(
                                'We use industry-leading security to protect your information.',
                                style: TextStyle(fontSize: 10, color: Color(0xFF4A5568), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 24),

            /// Right Column: Interactive Profile Information Cards Grid Matrix
            Expanded(
              child: Column(
                children: [
                  /// Info Row Block 1
                  Row(
                    children: [
                      Expanded(child: _buildWebInfoGridCard('Full Name', user?.name ?? '---')),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWebInfoGridCard(
                          'PAN Number',
                          user?.panCard ?? '---',
                          badgeText: user?.panCard != null ? 'PAN Verified' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWebInfoGridCard(
                          'Aadhaar (Last 4)',
                          aadhaarDisplay,
                          badgeText: hasAadhaar ? 'Verified' : 'Pending',
                          isErrorBadge: !hasAadhaar,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Info Row Block 2
                  Row(
                    children: [
                      Expanded(child: _buildWebInfoGridCard('Tax Status', taxStatusName)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWebInfoGridCard(
                          'Risk Profile',
                          user?.riskProfileModel?.profileName ?? 'Balanced',
                          badgeText: hasRiskProfile ? 'Updated' : 'Pending',
                          isErrorBadge: !hasRiskProfile,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWebInfoGridCard(
                          'Ready to invest since',
                          readySinceYear,
                          trailingIcon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Comprehensive Horizon Wide Status Field
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('KYC Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF70767F))),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFE6F7ED), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Verified', style: TextStyle(color: Color(0xFF1F9254), fontSize: 10, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your KYC is complete and verified. You can continue investing without any interruptions.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('Last Updated', style: TextStyle(fontSize: 11, color: Color(0xFF70767F))),
                            SizedBox(height: 4),
                            Text('10 May 2024', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1D20))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        /// Bottom Global Help Alert Strip
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.info, color: Color(0xFF0066FF), size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Need to update your KYC?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1D20))),
                    SizedBox(height: 4),
                    Text('If your details have changed, please update your information to keep your account up to date.', style: TextStyle(color: Color(0xFF4A5568), fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0066FF),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFDBEAFE)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: const Text('Update KYC', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT (Preserved Setup Style)
  // =========================================
  Widget _buildMobileLayout() {
    final user = SessionManager.instance.userObs.value;
    final String readySinceYear = user?.customerDetailsModel?.dob?.split('-').firstOrNull ?? '';

    return Column(
      children: [
        SizedBox(height: kToolbarHeight - kToolbarHeight / 2),
        ProfileHeader(
          img: user?.img ?? UImages.avatar,
          name: user?.name ?? 'Guest User',
          subtitle: 'Ready to invest since $readySinceYear',
          icon: Icons.verified,
          onTap: () {},
          iconColor: user?.kycStatus?.toLowerCase() == 'approved' ? Colors.green : Colors.black,
        ),
        const SizedBox(height: 30),
        InfoCard(
          title: 'Kyc Status',
          subtitle: user?.kycStatus ?? 'NO KYC',
          trailing: user?.kycStatus?.toLowerCase() == 'approved' ? const Icon(Icons.verified, color: Colors.green) : null,
        ),
        const SizedBox(height: 10),
        InfoCard(
          title: 'Pan Number',
          subtitle: user?.panCard ?? 'Not Available',
        ),
      ],
    );
  }

  // =========================================
  // 🛠️ PRIVATE DESIGN HELPER BLOCKS
  // =========================================
  Widget _buildWebCheckmarkItem(String label, {required bool isValid}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? const Color(0xFF1F9254) : Colors.grey.shade400,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isValid ? const Color(0xFF2D3136) : Colors.grey.shade500,
              decoration: isValid ? TextDecoration.none : TextDecoration.lineThrough, // Optional visual cue
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebInfoGridCard(
      String label,
      String value, {
        String? badgeText,
        IconData? trailingIcon,
        bool isErrorBadge = false, // Renamed to accurately reflect status flags
      }) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF70767F)),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1D20)),
                ),
              ],
            ),
          ),
          if (badgeText != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                // ✅ FIXED: Background color now changes dynamically to match status semantics
                color: isErrorBadge ? const Color(0xFFFCE8E6) : const Color(0xFFE6F7ED),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  // ✅ FIXED: Typo reference color mapping resolved
                  color: isErrorBadge ? Ucolors.red : Ucolors.success,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(trailingIcon, color: Colors.grey.shade400, size: 18),
          ],
        ],
      ),
    );
  }}

// Mobile Compatible Fallback Implementation Card
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.colum1,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget? colum1;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Ucolors.light,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SectionHeading(sectionTitle: title, fontSize: 14, fontWeight: FontWeight.w600),
                    const SizedBox(height: 6),
                    SubtitleText(subtitle: subtitle, fontSize: 12),
                    if (colum1 != null) ...[const SizedBox(height: 8), colum1!],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/text/section_heading.dart';
// import 'package:my_sip/common/widget/text/subtitle_section.dart';
// import 'package:my_sip/core/utils/helper/helpers.dart';
// import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/services/session_manager.dart';
//
// import '../../../../core/utils/constant/text_style.dart';
//
// class KycDetailsScreen extends StatelessWidget {
//   const KycDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;
//
//     return Scaffold(
//       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
//       appBar: isDesktop ? null : CustomAppBarNormal(title: 'KYC Details'),
//       body: SingleChildScrollView(
//         padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
//         child: Center(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: 1200), // Max web width
//             child: isDesktop
//                 ? _buildWebDashboardLayout() // 💻 Desktop Layout
//                 : _buildMobileLayout(), // 📱 Mobile Layout
//           ),
//         ),
//       ),
//     );
//   }
//
//   // =========================================
//   // 💻 WEB / DESKTOP LAYOUT (Side-by-Side)
//   // =========================================
//   Widget _buildWebDashboardLayout() {
//     final user = SessionManager.instance.userObs.value;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // --- LEFT COLUMN: Profile Summary ---
//         Expanded(
//           flex: 4,
//           child: Card(
//             color: Colors.white,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(32.0),
//               child: Column(
//                 children: [
//                   ProfileHeader(
//                     img: user?.img ?? UImages.avatar,
//                     name: user?.name ?? 'Guest User',
//                     subtitle:
//                         'Ready to invest since ${user?.customerDetailsModel?.dob?.split('-')[0] ?? ''}',
//                     icon: Icons.verified,
//                     onTap: () {},
//                   ),
//                   const SizedBox(height: 20),
//                   const Divider(),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Your account is fully verified and ready for investments.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: FontFamily.medium,
//                       color: Colors.grey,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         const SizedBox(width: 30), // Gap between columns
//         // --- RIGHT COLUMN: KYC Cards Grid ---
//         Expanded(
//           flex: 8,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // const Text(
//               //   "KYC Information",
//               //   style: TextStyle(fontFamily: FontFamily.medium,fontSize: 22, fontWeight: FontWeight.bold),
//               // ),
//               // const SizedBox(height: 20),
//               // Grid for displaying cards side by side on Web
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2, // 2 cards in one row
//                 childAspectRatio: 2.5, // Controls card height
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: [
//                   InfoCard(
//                     title: 'Tax Status',
//                     subtitle: ProfileUtils.getWealthSourceName(
//                       int.tryParse(
//                         user?.customerDetailsModel?.wealthSource ?? '',
//                       ),
//                     ),
//                   ),
//                   InfoCard(
//                     title: 'Pan Number',
//                     subtitle: user?.panCard ?? 'Not Available',
//                   ),
//                   InfoCard(
//                     title: 'Risk Profile',
//                     subtitle: user?.riskProfileModel?.profileName ?? 'Balanced',
//                   ),
//                   InfoCard(
//                     title: 'Aadhaar (Last 4)',
//                     subtitle: user?.customerDetailsModel?.adhar ?? 'XXXX',
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // =========================================
//   // 📱 MOBILE LAYOUT (Stacked)
//   // =========================================
//   Widget _buildMobileLayout() {
//     final user = SessionManager.instance.userObs.value;
//
//     return Column(
//       children: [
//         SizedBox(height: kToolbarHeight - kToolbarHeight / 2),
//         ProfileHeader(
//           img: user?.img ?? UImages.avatar,
//           name: user?.name ?? 'Guest User',
//           subtitle:
//               'Ready to invest since ${user?.customerDetailsModel?.dob?.split('-')[0] ?? ''}',
//           icon: Icons.verified,
//           onTap: () {},
//           iconColor: user?.kycStatus?.toLowerCase() == 'approved'
//               ? Colors.green
//               : Colors.black,
//         ),
//         const SizedBox(height: 30),
//
//         InfoCard(
//           title: 'Kyc Status',
//           // subtitle: user?.customerDetailsModel?.wealthSource ?? 'Not Available',
//           // subtitle: ProfileUtils.getWealthSourceName(
//           //   int.tryParse(user?.customerDetailsModel?.wealthSource ?? ''),
//           // ),
//           subtitle: user?.kycStatus ?? 'NO KYC',
//           trailing: user?.kycStatus?.toLowerCase() == 'approved'
//               ? Icon(Icons.verified, color: Colors.green)
//               : null,
//         ),
//         const SizedBox(height: 10),
//         InkWell(
//           onTap: () {
//             // final responseData =
//             //     SessionManager.instance.onboardingRespone.value;
//
//             // if (responseData != null) {
//             //   String prettyPrint = const JsonEncoder.withIndent(
//             //     '  ',
//             //   ).convert(responseData.toJson());
//             //   log('✅ Onboarding Response:\n$prettyPrint');
//             // } else {
//             //   log('❌ Onboarding Response is currently NULL');
//             //   log(
//             //     '${SessionManager.instance.tokenDataModel.value?.id}----------${SessionManager.instance.getTokenData?.id}',
//             //   );
//             // }
//           },
//
//           child: InfoCard(
//             title: 'Pan Number',
//             subtitle:
//                 SessionManager.instance.getUserData?.panCard ?? 'Not Available',
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Keep your existing InfoCard here
// class InfoCard extends StatelessWidget {
//   const InfoCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     this.colum1,
//     this.trailing,
//     this.onTap,
//   });
//
//   final String title;
//   final String subtitle;
//   final Widget? colum1;
//   final Widget? trailing;
//   final VoidCallback? onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200, width: 1),
//       ),
//       color: Ucolors.light,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SectionHeading(
//                       sectionTitle: title,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     const SizedBox(height: 6),
//                     SubtitleText(subtitle: subtitle, fontSize: 12),
//                     if (colum1 != null) ...[const SizedBox(height: 8), colum1!],
//                   ],
//                 ),
//               ),
//               if (trailing != null) ...[const SizedBox(width: 10), trailing!],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
