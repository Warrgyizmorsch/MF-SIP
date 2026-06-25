// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
// import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/services/session_manager.dart';

// class DocumentScreen extends StatelessWidget {
//   const DocumentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = SessionManager.instance.userObs.value;
//     return Scaffold(
//       appBar: CustomAppBarNormal(title: 'Document'),
//       body: Padding(
//         padding: UPadding.screenPadding.copyWith(),
//         child: Column(
//           children: [
//             SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

//             ProfileHeader(
//               // iconcolor: Ucolors.primary,
//               name: user?.name ?? '',
//               img: user?.img ?? '',
//               subtitle:
//                   'Ready to invest since ${user?.createdAt?.split('-')[0]}',
//               icon: Icons.verified,
//               onTap: () {},
//             ),

//             SizedBox(height: 10),

// ignore_for_file: unused_local_variable

//             InfoCard(
//               onTap: () {},
//               title: 'PAN Card',
//               subtitle: user?.panCard ?? '',
//             ),
//             SizedBox(height: 10),
//             InfoCard(
//               onTap: () {},
//               trailing: Image.asset(UImages.signature, fit: BoxFit.contain),
//               title: 'Bank Signature',
//               subtitle: 'Upload Individual’s Signature',
//               colum1: OutlinedButton(
//                 onPressed: () {},
//                 style: OutlinedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.grey.shade100),
//                     borderRadius: BorderRadiusGeometry.circular(12),
//                   ),
//                 ),
//                 child: FittedBox(
//                   child: Text(
//                     'View',
//                     style: UTextStyles.subtitle2.copyWith(
//                       color: Ucolors.dark,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:iconsax/iconsax.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.userObs.value;

    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: isDesktop ? null : const CustomAppBarNormal(title: 'Documents'),

      body: SingleChildScrollView(
        padding: isDesktop ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0) : UPadding.screenPadding,
        child: isDesktop
            ? _buildWebDashboardLayout() // 💻 Desktop Layout
            : _buildMobileLayout(),
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (Document Vault Grid)
  // =========================================
  Widget _buildWebDashboardLayout() {
    final user = SessionManager.instance.userObs.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Document Vault",
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Manage and view your uploaded KYC documents.",
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),

        // 🚀 FIX: Grid Layout for Documents on Web
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, // 2 Documents per row
          childAspectRatio:4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            // PAN Card Web Design
            _buildWebDocumentCard(
              title: "PAN Card",
              subtitle: user?.panCard ?? 'Not Available',
              icon: Iconsax.card,
              color: Colors.blue,
              status: "Verified",
              onView: () {},
            ),

            // Signature Web Design
            _buildWebDocumentCard(
              title: "Bank Signature",
              subtitle: "Individual's Signature",
              icon: Iconsax.edit,
              color: Colors.purple,
              status: "Uploaded",
              onView: () {},
              trailingImage: UImages.signature, // Pass the image path here
            ),
          ],
        ),
      ],
    );
  }

  // =========================================
  // 💎 PREMIUM WEB DOCUMENT CARD WIDGET
  // =========================================
  Widget _buildWebDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String status,
    required VoidCallback onView,
    String? trailingImage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)), // Clean slate border
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Header Core Details ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact Premium Icon Box
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),

              // Text Blocks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: title.toLowerCase().contains("pan") ? 1.0 : 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Sharp Minimalist Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), // Emerald tint
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFDCFCE7)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Color(0xFF16A34A), // Deep professional green
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          // --- Bottom Action Section ---
          Column(
            children: [
              const Divider(color: Color(0xFFF1F5F9), thickness: 1, height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: onView,
                    style: TextButton.styleFrom(
                      foregroundColor: Ucolors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_outlined, size: 15),
                        SizedBox(width: 6),
                        Text(
                          "View Document",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailingImage != null)
                    Opacity(
                      opacity: 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          trailingImage,
                          width: 32,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT (Stacked InfoCards)
  // =========================================
  Widget _buildMobileLayout() {
    final user = SessionManager.instance.userObs.value;

    return Column(
      children: [
        SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
        ProfileHeader(
          name: user?.name ?? 'Guest User',
          img: user?.img ?? '',
          subtitle:
              'Ready to invest since ${user?.createdAt?.split('-')[0] ?? ''}',
          icon: Icons.verified,
          onTap: () {},
        ),
        const SizedBox(height: 30),

        InfoCard(
          onTap: () {},
          title: 'PAN Card',
          subtitle: user?.panCard ?? 'Not Available',
        ),
        const SizedBox(height: 10),
        InfoCard(
          onTap: () {},
          trailing: SizedBox(
            width: 60,
            height: 40,
            child: Image.asset(UImages.signature, fit: BoxFit.contain),
          ),
          title: 'Bank Signature',
          subtitle: 'Upload Individual’s Signature',
          colum1: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View',
              style: UTextStyles.subtitle2.copyWith(
                color: Ucolors.dark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class DocumentScreen extends StatelessWidget {
//   const DocumentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 🚀 Check if Desktop/Web or Mobile
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;

//     return Scaffold(
//       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
//       appBar: const CustomAppBarNormal(title: 'Documents'),

//       // 🚀 FIX: Wrapped in SingleChildScrollView to prevent bottom overflow on small screens
//       body: SingleChildScrollView(
//         padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxWidth: 1200,
//             ), // Max web width limit
//             child: isDesktop
//                 ? _buildWebDashboardLayout() // 💻 Desktop Layout
//                 : _buildMobileLayout(), // 📱 Mobile Layout
//           ),
//         ),
//       ),
//     );
//   }

//   // =========================================
//   // 💻 WEB / DESKTOP LAYOUT (40/60 Split)
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
//                     name: user?.name ?? 'Guest User',
//                     img: user?.img ?? '',
//                     subtitle:
//                         'Ready to invest since ${user?.createdAt?.split('-')[0] ?? ''}',
//                     icon: Icons.verified,
//                     onTap: () {},
//                   ),
//                   const SizedBox(height: 20),
//                   const Divider(),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Your documents are securely encrypted and stored as per regulatory guidelines.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontFamily: FontFamily.medium,color: Colors.grey, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(width: 30), // Gap between columns
//         // --- RIGHT COLUMN: Documents List ---
//         Expanded(
//           flex: 8,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Uploaded Documents",
//                 style: TextStyle(fontFamily: FontFamily.medium,fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 24),

//               // We can use a Grid or Column here. Since there are only 2 items,
//               // a Column inside a card looks very clean.
//               Card(
//                 elevation: 0,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   side: BorderSide(color: Colors.grey.shade200),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(32.0),
//                   child: Column(
//                     children: [
//                       _buildPanCardItem(user),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16.0),
//                         child: Divider(),
//                       ),
//                       _buildSignatureItem(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // =========================================
//   // 📱 MOBILE LAYOUT (Stacked)
//   // =========================================
//   Widget _buildMobileLayout() {
//     final user = SessionManager.instance.userObs.value;

//     return Column(
//       children: [
//         SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
//         ProfileHeader(
//           name: user?.name ?? 'Guest User',
//           img: user?.img ?? '',
//           subtitle:
//               'Ready to invest since ${user?.createdAt?.split('-')[0] ?? ''}',
//           icon: Icons.verified,
//           onTap: () {},
//         ),
//         const SizedBox(height: 30),

//         // Mobile uses the standard InfoCard components directly
//         _buildPanCardItem(user),
//         const SizedBox(height: 10),
//         _buildSignatureItem(),
//       ],
//     );
//   }

//   // =========================================
//   // 🧩 REUSABLE ITEMS
//   // =========================================

//   Widget _buildPanCardItem(dynamic user) {
//     return InfoCard(
//       onTap: () {},
//       title: 'PAN Card',
//       subtitle: user?.panCard ?? 'Not Available',
//     );
//   }

//   Widget _buildSignatureItem() {
//     return InfoCard(
//       onTap: () {},
//       // 🚀 FIX: Gave the image a fixed width/height so it doesn't break Web layouts
//       trailing: SizedBox(
//         width: 60,
//         height: 40,
//         child: Image.asset(UImages.signature, fit: BoxFit.contain),
//       ),
//       title: 'Bank Signature',
//       subtitle: 'Upload Individual’s Signature',
//       colum1: OutlinedButton(
//         onPressed: () {},
//         style: OutlinedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             side: BorderSide(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(
//               8,
//             ), // Reduced radius for a sharper web look
//           ),
//         ),
//         child: Text(
//           'View',
//           style: UTextStyles.subtitle2.copyWith(
//             color: Ucolors.dark,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }
