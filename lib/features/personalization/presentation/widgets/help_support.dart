// // // import 'package:flutter/material.dart';
// // // import 'package:gap/gap.dart';
// // // import 'package:my_sip/common/style/padding.dart';
// // // import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// // // import 'package:my_sip/common/widget/webview/webview.dart';
// // // import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
// // // import 'package:my_sip/core/utils/constant/colors.dart';

// // // class HelpSupportScreen extends StatelessWidget {
// // //   const HelpSupportScreen({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: CustomAppBarNormal(title: 'Help & Support'),
// // //       body: Padding(
// // //         padding: UPadding.screenPadding,
// // //         child: Container(
// // //           color: Ucolors.light,
// // //           child: Column(
// // //             children: [
// // //               // SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
// // //               const Gap(10),

// // //               // Listtilecustom(title: 'About Us', onTap: () {}),
// // //               Listtilecustom(
// // //                 title: 'Contact Support',
// // //                 // onTap: () {},
// // //                 onTap: () => Navigator.push(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) => HtmlWebViewPage(
// // //                       title: 'Contact Us',
// // //                       url:
// // //                           'https://sip.londonstreetstore.com/contact-us?mobile=true',
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               Listtilecustom(
// // //                 title: 'Privacy Policy',
// // //                 onTap: () => Navigator.push(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) => HtmlWebViewPage(
// // //                       title: 'Privacy Policy',
// // //                       url:
// // //                           'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               Listtilecustom(
// // //                 title: 'Terms & Conditions',
// // //                 onTap: () => Navigator.push(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) => HtmlWebViewPage(
// // //                       title: 'Terms & Conditions',
// // //                       url:
// // //                           'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true',
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               Listtilecustom(title: 'FAQ', onTap: () {}),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:gap/gap.dart';
// // import 'package:get/get.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:my_sip/common/style/padding.dart';
// // import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// // import 'package:my_sip/common/widget/webview/webview.dart';
// // import 'package:my_sip/core/utils/constant/colors.dart';

// // class HelpSupportScreen extends StatelessWidget {
// //   const HelpSupportScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     // 🚀 Check if Desktop/Web or Mobile
// //     final bool isDesktop = MediaQuery.of(context).size.width > 600;

// //     // Define all support items in a list for cleaner code
// //     final List<_SupportItemData> supportItems = [
// //       _SupportItemData(
// //         title: 'Contact Support',
// //         subtitle: 'Get in touch with our team for assistance',
// //         icon: Iconsax.support,
// //         color: Colors.blue,
// //         onTap: () => Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => HtmlWebViewPage(
// //               title: 'Contact Us',
// //               url: 'https://sip.londonstreetstore.com/contact-us?mobile=true',
// //             ),
// //           ),
// //         ),
// //       ),
// //       _SupportItemData(
// //         title: 'Privacy Policy',
// //         subtitle: 'Learn how we protect your personal data',
// //         icon: Iconsax.shield_tick,
// //         color: Colors.green,
// //         onTap: () => Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => HtmlWebViewPage(
// //               title: 'Privacy Policy',
// //               url:
// //                   'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
// //             ),
// //           ),
// //         ),
// //       ),
// //       _SupportItemData(
// //         title: 'Terms & Conditions',
// //         subtitle: 'Read the rules and guidelines of our platform',
// //         icon: Iconsax.document_text,
// //         color: Colors.purple,
// //         onTap: () => Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => HtmlWebViewPage(
// //               title: 'Terms & Conditions',
// //               url:
// //                   'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true',
// //             ),
// //           ),
// //         ),
// //       ),
// //       _SupportItemData(
// //         title: 'FAQs',
// //         subtitle: 'Find answers to commonly asked questions',
// //         icon: Iconsax.message_question,
// //         color: Colors.orange,
// //         onTap: () {
// //           // Add your FAQ route here
// //         },
// //       ),
// //     ];

// //     return Scaffold(
// //       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
// //       appBar: const CustomAppBarNormal(title: 'Help & Support'),

// //       body: SingleChildScrollView(
// //         padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
// //         child: Center(
// //           child: ConstrainedBox(
// //             constraints: const BoxConstraints(maxWidth: 1000), // Max Web Width
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // --- Header Section ---
// //                 const Gap(10),
// //                 Text(
// //                   'How can we help you?',
// //                   style: TextStyle(
// //                     fontSize: isDesktop ? 28 : 22,
// //                     fontWeight: FontWeight.bold,
// //                     color: Ucolors.dark,
// //                   ),
// //                 ),
// //                 const Gap(8),
// //                 Text(
// //                   'Choose a category below to find the help you need.',
// //                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
// //                 ),
// //                 const Gap(32),

// //                 // --- Responsive Grid / List Section ---
// //                 isDesktop
// //                     ? GridView.builder(
// //                         shrinkWrap: true,
// //                         physics: const NeverScrollableScrollPhysics(),
// //                         gridDelegate:
// //                             const SliverGridDelegateWithFixedCrossAxisCount(
// //                               crossAxisCount: 2, // 2 cards per row on web
// //                               crossAxisSpacing: 24,
// //                               mainAxisSpacing: 24,
// //                               childAspectRatio: 3.0, // Adjust card height
// //                             ),
// //                         itemCount: supportItems.length,
// //                         itemBuilder: (context, index) {
// //                           return _SupportCard(item: supportItems[index]);
// //                         },
// //                       )
// //                     : Column(
// //                         children: supportItems
// //                             .map(
// //                               (item) => Padding(
// //                                 padding: const EdgeInsets.only(bottom: 16),
// //                                 child: _SupportCard(item: item),
// //                               ),
// //                             )
// //                             .toList(),
// //                       ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // =========================================
// // // 🧩 DATA MODEL & CUSTOM WIDGET
// // // =========================================

// // class _SupportItemData {
// //   final String title;
// //   final String subtitle;
// //   final IconData icon;
// //   final Color color;
// //   final VoidCallback onTap;

// //   _SupportItemData({
// //     required this.title,
// //     required this.subtitle,
// //     required this.icon,
// //     required this.color,
// //     required this.onTap,
// //   });
// // }

// // class _SupportCard extends StatelessWidget {
// //   final _SupportItemData item;

// //   const _SupportCard({required this.item});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: Colors.grey.shade200),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: item.onTap,
// //           borderRadius: BorderRadius.circular(16),
// //           hoverColor: item.color.withOpacity(0.05), // Light tint on hover (Web)
// //           child: Padding(
// //             padding: const EdgeInsets.all(20),
// //             child: Row(
// //               children: [
// //                 // Colored Icon Box
// //                 Container(
// //                   width: 50,
// //                   height: 50,
// //                   decoration: BoxDecoration(
// //                     color: item.color.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Icon(item.icon, color: item.color, size: 24),
// //                 ),
// //                 const Gap(16),

// //                 // Text Info
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         item.title,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                           color: Ucolors.dark,
// //                         ),
// //                       ),
// //                       const Gap(4),
// //                       Text(
// //                         item.subtitle,
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.grey.shade600,
// //                         ),
// //                         maxLines: 2,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 // Trailing Arrow
// //                 Icon(
// //                   Icons.arrow_forward_ios,
// //                   color: Colors.grey.shade400,
// //                   size: 16,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/webview/webview.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';

// class HelpSupportScreen extends StatelessWidget {
//   const HelpSupportScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 🚀 Check if Desktop/Web or Mobile
//     final bool isDesktop = MediaQuery.of(context).size.width > 600;

//     // Define all support items in a list for cleaner code
//     final List<_SupportItemData> supportItems = [
//       _SupportItemData(
//         title: 'Contact Support',
//         subtitle: 'Get in touch with our team for assistance',
//         icon: Iconsax.support,
//         color: Colors.blue,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HtmlWebViewPage(
//               title: 'Contact Us',
//               url: 'https://sip.londonstreetstore.com/contact-us?mobile=true',
//             ),
//           ),
//         ),
//       ),
//       _SupportItemData(
//         title: 'Privacy Policy',
//         subtitle: 'Learn how we protect your personal data',
//         icon: Iconsax.shield_tick,
//         color: Colors.green,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HtmlWebViewPage(
//               title: 'Privacy Policy',
//               url:
//                   'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
//             ),
//           ),
//         ),
//       ),
//       _SupportItemData(
//         title: 'Terms & Conditions',
//         subtitle: 'Read the rules and guidelines of our platform',
//         icon: Iconsax.document_text,
//         color: Colors.purple,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HtmlWebViewPage(
//               title: 'Terms & Conditions',
//               url:
//                   'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true',
//             ),
//           ),
//         ),
//       ),
//       _SupportItemData(
//         title: 'FAQs',
//         subtitle: 'Find answers to commonly asked questions',
//         icon: Iconsax.message_question,
//         color: Colors.orange,
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HtmlWebViewPage(
//               title: 'FAQ',
//               url: 'https://sip.londonstreetstore.com/faq?mobile=true',
//             ),
//           ),
//         ),
//       ),
//     ];

//     return Scaffold(
//       backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
//       appBar: const CustomAppBarNormal(title: 'Help & Support'),

//       body: SingleChildScrollView(
//         padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 1000), // Max Web Width
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- Header Section ---
//                 const Gap(10),
//                 Text(
//                   'How can we help you?',
//                   style: TextStyle(
//                     fontSize: isDesktop ? 28 : 22,
//                     fontWeight: FontWeight.bold,
//                     color: Ucolors.dark,
//                   ),
//                 ),
//                 const Gap(8),
//                 Text(
//                   'Choose a category below to find the help you need.',
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//                 const Gap(32),

//                 // --- Responsive Grid / List Section ---
//                 isDesktop
//                     ? GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2, // 2 cards per row on web
//                               crossAxisSpacing: 24,
//                               mainAxisSpacing: 24,
//                               childAspectRatio: 3.0, // Adjust card height
//                             ),
//                         itemCount: supportItems.length,
//                         itemBuilder: (context, index) {
//                           return _SupportCard(item: supportItems[index]);
//                         },
//                       )
//                     : Column(
//                         children: supportItems
//                             .map(
//                               (item) => Padding(
//                                 padding: const EdgeInsets.only(bottom: 16),
//                                 child: _SupportCard(item: item),
//                               ),
//                             )
//                             .toList(),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =========================================
// // 🧩 DATA MODEL & CUSTOM WIDGET
// // =========================================

// class _SupportItemData {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   _SupportItemData({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });
// }

// class _SupportCard extends StatelessWidget {
//   final _SupportItemData item;

//   const _SupportCard({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: item.onTap,
//           borderRadius: BorderRadius.circular(16),
//           hoverColor: item.color.withOpacity(0.05), // Light tint on hover (Web)
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 // Colored Icon Box
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: item.color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(item.icon, color: item.color, size: 24),
//                 ),
//                 const Gap(16),

//                 // Text Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         item.title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Ucolors.dark,
//                         ),
//                       ),
//                       const Gap(4),
//                       Text(
//                         item.subtitle,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Trailing Arrow
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: Colors.grey.shade400,
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    final List<_SupportItemData> supportItems = [
      _SupportItemData(
        title: 'Contact Support',
        subtitle: 'Get in touch with our team for assistance',
        icon: Iconsax.support,
        color: Colors.blue,

        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlWebViewPage(
              title: 'Contact Us',
              url: 'https://sip.londonstreetstore.com/contact-us?mobile=true',
            ),
          ),
        ),
      ),
      _SupportItemData(
        title: 'Privacy Policy',
        subtitle: 'Learn how we protect your personal data',
        icon: Iconsax.shield_tick,
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlWebViewPage(
              title: 'Contact Us',
              url:
                  'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
            ),
          ),
        ),
        // onTap: () => _openLink(
        //   context,
        //   'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
        //   'Privacy Policy',
        // ),
      ),
      _SupportItemData(
        title: 'Terms & Conditions',
        subtitle: 'Read the rules and guidelines of our platform',
        icon: Iconsax.document_text,
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlWebViewPage(
              title: 'Contact Us',
              url:
                  'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true',
            ),
          ),
        ),
      ),
      _SupportItemData(
        title: 'FAQs',
        subtitle: 'Find answers to commonly asked questions',
        icon: Iconsax.message_question,
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlWebViewPage(
              title: 'FAQs',
              url: 'https://sip.londonstreetstore.com/faq?mobile=true',
            ),
          ),
        ),
      ),
      _SupportItemData(
        title: 'About us',
        subtitle: 'Learn more about our mission and journey',
        icon: Icons.info_outlined,
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlWebViewPage(
              title: 'Abouts us',
              url: 'https://sip.londonstreetstore.com/about-us?mobile=true',
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: const CustomAppBarNormal(title: 'Help & Support'),

      body: SingleChildScrollView(
        padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000), // Max Web Width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header Section ---
                const Gap(10),
                Text(
                  'How can we help you?',
                  style: TextStyle(
                    fontSize: isDesktop ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: Ucolors.dark,
                  ),
                ),
                const Gap(8),
                Text(
                  'Choose a category below to find the help you need.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const Gap(32),

                // --- Responsive Grid / List Section ---
                isDesktop
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio: 3.0,
                            ),
                        itemCount: supportItems.length,
                        itemBuilder: (context, index) {
                          return _SupportCard(item: supportItems[index]);
                        },
                      )
                    : Column(
                        children: supportItems
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _SupportCard(item: item),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================
// 🧩 DATA MODEL & CUSTOM WIDGET
// =========================================
class _SupportItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _SupportItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _SupportCard extends StatelessWidget {
  final _SupportItemData item;

  const _SupportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16),
          hoverColor: item.color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Ucolors.dark,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
