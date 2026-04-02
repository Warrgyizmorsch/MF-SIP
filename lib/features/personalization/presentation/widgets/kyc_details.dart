import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';

// class KycDetailsScreen extends StatelessWidget {
//   const KycDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = SessionManager.instance.userObs.value;

//     return Scaffold(
//       appBar: CustomAppBarNormal(title: 'KYC Details'),
//       body: Padding(
//         padding: UPadding.screenPadding,
//         child: Column(
//           children: [
//             SizedBox(height: kToolbarHeight - kToolbarHeight / 2),

//             //Profile Header
//             ProfileHeader(
//               // iconcolor: Colors.blue,
//               img: UImages.avatar,
//               name: user?.name ?? 'Guest User',
//               subtitle:
//                   'Ready to invest since ${user?.customerDetailsModel?.dob?.split('-')[0]}',
//               icon: Icons.verified,
//               onTap: () {},
//             ),
//             SizedBox(height: 24),

//             //Kyc Details
//             InfoCard(
//               title: 'Tax Status',
//               subtitle: user?.customerDetailsModel?.wealthSource ?? '',
//             ),
//             SizedBox(height: 5),
//             InfoCard(title: 'Pan Number', subtitle: user?.panCard ?? ''),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InfoCard extends StatelessWidget {
//   const InfoCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     this.colum1,
//     this.trailing,
//     this.onTap,
//   });

//   final String title;
//   final String subtitle;
//   final Widget? colum1;
//   final Widget? trailing;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       color: Ucolors.light,
//       child: SizedBox(
//         // height: Get.height * 0.07,
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             top: 10,
//             bottom: 10,
//             right: 16,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   /// Title
//                   SectionHeading(
//                     sectionTitle: title,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     // height: 21 / 14,
//                   ),
//                   SizedBox(height: 5),

//                   //Subtitle
//                   SubtitleText(subtitle: subtitle, fontSize: 10),

//                   //New coloumn
//                   if (colum1 != null) ...[SizedBox(height: 5), colum1!],
//                 ],
//               ),

//               //New row
//               if (trailing != null) ...[const SizedBox(width: 5), trailing!],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class KycDetailsScreen extends StatelessWidget {
  const KycDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.userObs.value;

    return Scaffold(
      appBar: CustomAppBarNormal(title: 'KYC Details'),
      // 🔥 FIX: Column ko SingleChildScrollView mein wrap kiya taaki overflow na ho
      body: SingleChildScrollView(
        padding: UPadding.screenPadding,
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight - kToolbarHeight / 2),

            //Profile Header
            ProfileHeader(
              img: user?.img ?? UImages.avatar,
              name: user?.name ?? 'Guest User',
              subtitle:
                  'Ready to invest since ${user?.customerDetailsModel?.dob?.split('-')[0]}',
              icon: Icons.verified,
              onTap: () {},
            ),
            SizedBox(height: 24),

            //Kyc Details
            InfoCard(
              title: 'Tax Status',
              subtitle: user?.customerDetailsModel?.wealthSource ?? '',
            ),
            SizedBox(height: 5),
            InfoCard(title: 'Pan Number', subtitle: user?.panCard ?? ''),
          ],
        ),
      ),
    );
  }
}

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Ucolors.light,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            top: 10,
            bottom: 10,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔥 FIX: Is Column ko Expanded mein wrap kiya taaki lamba text screen ke bahar na bhage
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Title
                    SectionHeading(
                      sectionTitle: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 5),

                    //Subtitle
                    SubtitleText(subtitle: subtitle, fontSize: 10),

                    //New coloumn
                    if (colum1 != null) ...[SizedBox(height: 5), colum1!],
                  ],
                ),
              ),

              //New row
              if (trailing != null) ...[const SizedBox(width: 5), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
