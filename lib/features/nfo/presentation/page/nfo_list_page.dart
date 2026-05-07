// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/animated/empty_filled.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/common/widget/images/custom_cached_image.dart';
// import 'package:my_sip/common/widget/shimmer/shimmer.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/core/utils/helper/helpers.dart';
// import 'package:my_sip/features/nfo/presentation/controller/nfo_controller.dart';
// import 'package:my_sip/features/nfo/presentation/page/nfo_details_page.dart';

// // class NfoListPage extends GetView<NfoController> {
// //   const NfoListPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade50,
// //       appBar: CustomAppBarNormal(title: 'NFO', backgroundColor: Colors.white),
// //       body: Obx(
// //         () => controller.isLoading.value
// //             ? Center(child: CircularProgressIndicator(color: Colors.blue))
// //             : Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 10),
// //                 child: Column(
// //                   // crossAxisAlignment: CrossAxisAlignment.center,
// //                   // mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const SizedBox(height: 5),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           'Open Now',
// //                           style: AppTextStyles.bodyMediumBold(
// //                             size: 20,
// //                             // color: Colors.greenAccent.shade400,
// //                           ),
// //                         ),
// //                         Text(
// //                           '${controller.nfoResult.value?.count.toString()} FUNDS OPEN',
// //                           style: AppTextStyles.bodyMediumBold(
// //                             color: Colors.greenAccent.shade400,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 5),

// //                     NfoCard(
// //                       title: 'Groww BSE Hospitals ETF FoF Direct - Growth',
// //                       subtitle: 'Equity • Very High Risk',
// //                       logoUrl:
// //                           'https://lh3.googleusercontent.com/aida-public/AB6AXuCu2sQMvS2OjERoI1G_O1426uQS0v9ERbGaWDBoMZuQnGszMS6eBdn5ES-vVo8SlIeSPIR5gQO8h1HLo6VokaYyXEXhJyAuZck1iOGReEczZAUD7w7PTxp1NRgD93yJebQ5-uYlTBZkWWuUHNahSjQZtmeoQYjMvmHe1WYuCTD83ByAIWGXO22AD1NPSC9ABNxZDX3D_DfEyBujDO7ljkre4JNXIew5IdzIr0NBtKPu5_dHYSJLgxyC41Ip8Cib-3i2jY47EyrkRZnw', // URL from your code
// //                       tagText: 'Ends in 4 Days',
// //                       tagBackgroundColor: Colors.green.shade100,
// //                       // tagBackgroundColor: Colors.orange.shade100,
// //                       // tagColor: Colors.orange.shade700,
// //                       tagColor: Colors.green.shade700,
// //                       launchDate: "11 Feb '26",
// //                       closingDate: "25 Feb '26",
// //                       onInvestTap: () {
// //                         log(
// //                           "Navigate to investment page --- ${controller.nfoResult.value}",
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //       ),
// //     );
// //   }
// // }
// class NfoListPage extends GetView<NfoController> {
//   const NfoListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: CustomAppBarNormal(title: 'NFO', backgroundColor: Colors.white),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             // child: CircularProgressIndicator(color: Colors.blue),
//             child: UShimmerEffect(
//               radius: 0,
//               width: double.infinity,
//               height: double.infinity,
//             ),
//           );
//         }

//         final nfoList = controller.nfoResult.value?.data ?? [];

//         if (nfoList.isEmpty) {
//           return const Center(
//             child:
//                 //  Text("No NFOs available at the moment")
//                 AnimatedEmptyState(
//                   title: 'NFO',
//                   message: 'No NFOs available at the moment',
//                 ),
//           );
//         }

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               // Header Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Open Now',
//                     style: AppTextStyles.bodyMediumBold(size: 20),
//                   ),
//                   Text(
//                     '${nfoList.length} FUNDS OPEN',
//                     style: AppTextStyles.bodyMediumBold(
//                       color: Colors.greenAccent.shade400,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               Expanded(
//                 child: ListView.separated(
//                   itemCount: nfoList.length,
//                   separatorBuilder: (context, index) =>
//                       const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final nfo = nfoList[index];
//                     final String urgencyText = getRemainingDays(
//                       nfo.nfoCloseDate,
//                     );
//                     log('${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}}');

//                     final bool isUrgent =
//                         urgencyText.contains("TODAY") ||
//                         urgencyText.contains("TOMORROW");

//                     return NfoCard(
//                       title: nfo.schemeName ?? 'N/A',
//                       subtitle: '${nfo.assetClass} • ${nfo.riskLevel} Risk',
//                       logoUrl: '${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}',

//                       // 'https://img.logo.dev/google.com?token=pk_example', // Example URL logic
//                       // tagText:
//                       //     'Ends ${nfo.nfoCloseDate}', // You can calculate "Days left" here
//                       tagText: getRemainingDays(nfo.nfoCloseDate),
//                       // tagBackgroundColor: Colors.green.shade100,
//                       tagBackgroundColor: isUrgent
//                           ? Colors.orange.shade100
//                           : Colors.green.shade100,
//                       // tagColor: Colors.green.shade700,
//                       tagColor: isUrgent
//                           ? Colors.orange.shade800
//                           : Colors.green.shade800,
//                       launchDate: nfo.nfoOpenDate ?? '--',
//                       closingDate: nfo.nfoCloseDate ?? '--',
//                       onInvestTap: () {
//                         log("Investing in: ${nfo.schemeName}");
//                         Get.toNamed(AppRoutes.nfodetailsPage, arguments: nfo);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class NfoCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String logoUrl;
//   final String tagText;
//   final Color tagColor;
//   final Color tagBackgroundColor;
//   final String launchDate;
//   final String closingDate;
//   final VoidCallback onInvestTap;

//   const NfoCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.logoUrl,
//     required this.tagText,
//     required this.tagColor,
//     required this.tagBackgroundColor,
//     required this.launchDate,
//     required this.closingDate,
//     required this.onInvestTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onInvestTap,
//       child: Container(
//         // margin: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.02),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- Logo and Title Section ---
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipOval(child: CustomCachedImage(imageUrl: logoUrl)),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             right: 24.0,
//                           ), // Space for top-right tag
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 title,
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF0F172A),
//                                   height: 1.3,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 subtitle,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 15),

//                   // --- Dates Section ---
//                   Container(
//                     padding: const EdgeInsets.only(top: 15),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(color: Colors.grey.shade100),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         // Launch Date
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.event_available,
//                                 size: 16,
//                                 color: Colors.grey.shade400,
//                               ),
//                               const SizedBox(width: 8),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'LAUNCH',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey.shade400,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                   Text(
//                                     launchDate,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF334155),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Closing Date
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.event_busy,
//                                 size: 16,
//                                 color: Colors.grey.shade400,
//                               ),
//                               const SizedBox(width: 8),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'CLOSING',
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey.shade400,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                   Text(
//                                     closingDate,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF334155), // slate-700
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // --- Invest Now Button ---
//                   // SizedBox(
//                   //   width: double.infinity,
//                   //   height: 44,
//                   //   child: ElevatedButton(
//                   //     onPressed: onInvestTap,
//                   //     style: ElevatedButton.styleFrom(
//                   //       backgroundColor: primaryColor.withOpacity(0.1),
//                   //       foregroundColor: primaryColor,
//                   //       elevation: 0,
//                   //       shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(12),
//                   //       ),
//                   //     ),
//                   //     child: const Text(
//                   //       'Invest Now',
//                   //       style: TextStyle(
//                   //         fontWeight: FontWeight.bold,
//                   //         fontSize: 14,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   // UElevatedBUtton(
//                   //   onPressed: onInvestTap,
//                   //   height: 44,
//                   //   child: Center(
//                   //     child: Text(
//                   //       'Invest Now',
//                   //       style: AppTextStyles.button(color: Colors.white),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),

//             // --- Top Right Tag ---
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: tagBackgroundColor,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(12),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Text(
//                   tagText.toUpperCase(),
//                   style: TextStyle(
//                     color: tagColor,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: -0.2,
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
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/empty_filled.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/nfo/presentation/controller/nfo_controller.dart';

class NfoListPage extends GetView<NfoController> {
  const NfoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : Colors.grey.shade50,

      appBar: isDesktop
          ? null
          : CustomAppBarNormal(title: 'NFO', backgroundColor: Colors.white),

      body: SafeArea(
        child: isDesktop
            ? _buildWebLayout(context) // 💻 Web UI
            : _buildMobileLayout(context), // 📱 Mobile UI
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                  "New Fund Offerings (NFO)",
                  style: AppTextStyles.h2(color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Invest early in the latest mutual fund schemes.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // --- Content List ---
                _buildNfoContent(isWeb: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildNfoContent(isWeb: false);
  }

  Widget _buildNfoContent({required bool isWeb}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SizedBox(
          height: 300,
          child: const Center(
            child: UShimmerEffect(
              radius: 0,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      }

      final nfoList = controller.nfoResult.value?.data ?? [];

      if (nfoList.isEmpty) {
        return SizedBox(
          height: 300,
          child: const Center(
            child: AnimatedEmptyState(
              title: 'NFO',
              message: 'No NFOs available at the moment',
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 10),
        child: Column(
          children: [
            if (!isWeb) const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Open Now', style: AppTextStyles.bodyMediumBold(size: 20)),
                Text(
                  '${nfoList.length} FUNDS OPEN',
                  style: AppTextStyles.bodyMediumBold(
                    color: Colors.greenAccent.shade400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // NFO List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nfoList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final nfo = nfoList[index];
                final String urgencyText = getRemainingDays(nfo.nfoCloseDate);
                final bool isUrgent =
                    urgencyText.contains("TODAY") ||
                    urgencyText.contains("TOMORROW");

                return NfoCard(
                  title: nfo.schemeName ?? 'N/A',
                  subtitle: '${nfo.assetClass} • ${nfo.riskLevel} Risk',
                  logoUrl: '${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}',
                  tagText: urgencyText,
                  tagBackgroundColor: isUrgent
                      ? Colors.orange.shade100
                      : Colors.green.shade100,
                  tagColor: isUrgent
                      ? Colors.orange.shade800
                      : Colors.green.shade800,
                  launchDate: nfo.nfoOpenDate ?? '--',
                  closingDate: nfo.nfoCloseDate ?? '--',
                  onInvestTap: () {
                    if (isWeb) {
                      Get.toNamed(
                        AppRoutes.nfodetailsPage,
                        arguments: nfo,
                        id: 1,
                      );
                    } else {
                      Get.toNamed(AppRoutes.nfodetailsPage, arguments: nfo);
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

// =========================================
// 💳 NFO CARD COMPONENT
// =========================================
class NfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoUrl;
  final String tagText;
  final Color tagColor;
  final Color tagBackgroundColor;
  final String launchDate;
  final String closingDate;
  final VoidCallback onInvestTap;

  const NfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoUrl,
    required this.tagText,
    required this.tagColor,
    required this.tagBackgroundColor,
    required this.launchDate,
    required this.closingDate,
    required this.onInvestTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onInvestTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Logo and Title Section ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: CustomCachedImage(imageUrl: logoUrl, size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 24.0,
                          ), // Space for top-right tag
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Dates Section ---
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Launch Date
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 16,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LAUNCH',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    launchDate,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Closing Date
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 16,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CLOSING',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    closingDate,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
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
            ),
            // --- Top Right Tag ---
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: tagBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  tagText.toUpperCase(),
                  style: TextStyle(
                    color: tagColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
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
