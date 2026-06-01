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

    // 🚀 Check if Desktop/Web or Mobile
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: isDesktop ? null : const CustomAppBarNormal(title: 'Documents'),

      body: SingleChildScrollView(
        padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ), // Max web width limit
            child: isDesktop
                ? _buildWebDashboardLayout() // 💻 Desktop Layout
                : _buildMobileLayout(), // 📱 Mobile Layout
          ),
        ),
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (Document Vault Grid)
  // =========================================
  Widget _buildWebDashboardLayout() {
    final user = SessionManager.instance.userObs.value;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LEFT COLUMN: Profile Summary ---
        Expanded(
          flex: 3,
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // ProfileHeader(
                  //   name: user?.name ?? 'Guest User',
                  //   img: user?.img ?? '',
                  //   subtitle:
                  //       'Member since ${user?.createdAt?.split('-')[0] ?? ''}',
                  //   icon: Icons.verified,
                  //   onTap: () {},
                  // ),
                  Obx(() {
                    final reactiveUser = SessionManager.instance.userObs.value;

                    return ProfileHeader(
                      onTap: () {},
                      img: reactiveUser?.img ?? '',
                      subtitle:
                          'Member since ${user?.createdAt?.split('-')[0] ?? ''}',
                      icon: Iconsax.export,
                    );
                  }),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.shield, color: Colors.green, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "End-to-End Encrypted",
                            style: TextStyle(fontFamily: FontFamily.medium,
                              color: Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 32),

        // --- RIGHT COLUMN: Documents Grid ---
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Document Vault",
                style: TextStyle(fontFamily: FontFamily.medium,fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Manage and view your uploaded KYC documents.",
                style: TextStyle(fontFamily: FontFamily.medium,color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // 🚀 FIX: Grid Layout for Documents on Web
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 Documents per row
                childAspectRatio: 1.4, // Card shape
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
                    trailingImage:
                        UImages.signature, // Pass the image path here
                  ),
                ],
              ),
            ],
          ),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontFamily: FontFamily.medium,
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Title & Value
          Text(
            title,
            style: const TextStyle(fontFamily: FontFamily.medium,fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontFamily: FontFamily.medium,
              color: Colors.grey.shade600,
              fontSize: 14,
              letterSpacing: title == "PAN Card" ? 1.5 : 0,
            ),
          ),

          const Spacer(),
          const Divider(),
          const SizedBox(height: 8),

          // Action & Trailing Image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.remove_red_eye, size: 18),
                label: const Text("View Document"),
                style: TextButton.styleFrom(
                  foregroundColor: Ucolors.blue,
                  padding: EdgeInsets.zero,
                ),
              ),
              if (trailingImage != null)
                SizedBox(
                  width: 50,
                  height: 30,
                  child: Image.asset(
                    trailingImage,
                    fit: BoxFit.contain,
                    color: Colors.grey.shade400,
                  ),
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
