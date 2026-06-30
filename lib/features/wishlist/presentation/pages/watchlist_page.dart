// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/widget/animated/empty_filled.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
// import 'package:my_sip/common/widget/images/custom_cached_image.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
// import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
// import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
// import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
// import 'package:my_sip/features/home/presentation/pages/home.dart';
// import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';
// import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';

// class WatchlistPage extends StatelessWidget {
//   WatchlistPage({super.key});

//   final MutualFundController controller = Get.find();
//   final WishlistController controllerr = Get.find<WishlistController>();
//   final CartController cartController = Get.find<CartController>();

//   @override
//   Widget build(BuildContext context) {
//     // 🚀 Check for Web/Desktop
//     final bool isDesktop = MediaQuery.of(context).size.width > 800;

//     return Scaffold(
//       backgroundColor: isDesktop ? Colors.transparent : Colors.grey.shade50,

//       // 🚀 THE FIX: Web par local AppBar hide karo (Global Header handles it)
//       appBar: isDesktop
//           ? null
//           : CustomAppBarNormal(
//               actionsPadding: 15,
//               title: 'Watchlist',
//               action: [
//                 Obx(
//                   () => Stack(
//                     children: [
//                       CompactIcon(
//                         icon: Iconsax.shopping_cart,
//                         onPressed: () {
//                           Get.find<CartController>().filterGoalId.value = null;
//                           Get.toNamed(AppRoutes.cart);
//                         },
//                         iconColor: Ucolors.dark,
//                       ),
//                       if (cartController.generalItemsCount > 0)
//                         Positioned(
//                           right: 0,
//                           top: -5,
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: const BoxDecoration(
//                               color: Ucolors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               cartController.generalItemsCount.toString(),
//                               style: UTextStyles.buttonText.copyWith(
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//       body: SafeArea(
//         child: isDesktop
//             ? _buildWebLayout(context) // 💻 Web UI
//             : _buildMobileLayout(context), // 📱 Mobile UI
//       ),
//     );
//   }

//   // =========================================
//   // 💻 WEB / DESKTOP LAYOUT
//   // =========================================
//   Widget _buildWebLayout(BuildContext context) {
//     return Center(
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(
//           maxWidth: 800,
//         ), // 🚀 Optimal width for list view
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.05),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- Web Header ---
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "My Watchlist",
//                           style: AppTextStyles.h2(color: Ucolors.dark),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Track and monitor your favorite mutual funds.",
//                           style: TextStyle(
//                             color: Colors.grey.shade600,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Action Buttons (Optional extra controls)
//                     IconButton(
//                       onPressed: () => controllerr.fetchWishlist(),
//                       icon: const Icon(Icons.refresh, color: Ucolors.primary),
//                       tooltip: 'Refresh Watchlist',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 32),

//                 // --- Content List ---
//                 _buildWatchlistContent(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // =========================================
//   // 📱 MOBILE LAYOUT
//   // =========================================
//   Widget _buildMobileLayout(BuildContext context) {
//     return _buildWatchlistContent();
//   }

//   // =========================================
//   // 🧩 REUSABLE CONTENT
//   // =========================================

//   Widget _buildWatchlistContent() {
//     return Obx(() {
//       if (controllerr.isLoading.value) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.all(40.0),
//             child: CircularProgressIndicator(color: Ucolors.primary),
//           ),
//         );
//       }

//       if (controller.errorMessage.isNotEmpty) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(40.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   controller.errorMessage.value,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => controllerr.fetchWishlist(),
//                   child: const Text("Retry"),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }

//       final wishlistItems =
//           controllerr.wishlistResponseEntity.value?.data ?? [];

//       return CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // --- 1. THE MAIN CONTENT (EMPTY STATE OR LIST) ---
//           if (wishlistItems.isEmpty)
//             SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   SizedBox(height: Get.height * 0.05),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const AnimatedEmptyState(
//                           title: 'Your Watchlist is Empty',
//                           message:
//                               'Track the funds you love. Add them to your watchlist to monitor their performance easily.',
//                           icon: Icons.favorite_border_rounded,
//                         ),
//                         const SizedBox(height: 32),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 56,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Get.toNamed(AppRoutes.explorePage);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Ucolors.primary,
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.search_rounded, size: 20),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Discover Funds',
//                                   style: AppTextStyles.bodyMediumBold()
//                                       .copyWith(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           else
//             SliverPadding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               sliver: SliverList(
//                 delegate: SliverChildBuilderDelegate((context, index) {
//                   final item = wishlistItems[index];
//                   return MutualFundCard1(
//                     isDelete: true,
//                     containercolor: const Color(0xffFEF0F0),
//                     entity: item,
//                   );
//                 }, childCount: wishlistItems.length),
//               ),
//             ),

//           // --- 2. RECENTLY VIEWED SECTION (PUSHED TO BOTTOM) ---
//           SliverFillRemaining(
//             hasScrollBody: false, // 🚀 This makes it act like a Spacer!
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end, // Aligns to the bottom
//               children: [
//                 Obx(() {
//                   final recentFunds =
//                       Get.find<MutualFundController>().recentlyViewedFunds;

//                   // Only show if there are recent funds AND (wishlist is empty OR wishlist has <= 2 items)
//                   if (recentFunds.isEmpty || wishlistItems.length > 3) {
//                     return const SizedBox.shrink();
//                   }

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 56), // Spacing before the section
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 4,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Ucolors.primary,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               "Recently Viewed",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                                 letterSpacing: -0.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       SizedBox(
//                         height: 140,
//                         child: ListView.separated(
//                           padding: const EdgeInsets.symmetric(horizontal: 24),
//                           clipBehavior: Clip.none,
//                           physics: const BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           itemCount: recentFunds.length,
//                           separatorBuilder: (context, index) =>
//                               const SizedBox(width: 16),
//                           itemBuilder: (context, index) {
//                             final fund = recentFunds[index];
//                             final img =
//                                 "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
//                             final name = fund.baseSchemeName ?? 'Unknown Name';
//                             final threeyear =
//                                 fund.returnsEntity?.threeYear ?? '';
//                             final schemeCode = fund.schemeCode.toString();

//                             return SizedBox(
//                               width: Get.width * 0.45,
//                               child: Column(
//                                 children: [
//                                   Expanded(
//                                     child: PopularFundCardMob(
//                                       onTap: () {
//                                         Get.find<MutualFundController>()
//                                             .addToLocalRecentlyViewed(fund);
//                                         Get.toNamed(
//                                           AppRoutes.funddetails,
//                                           arguments: {
//                                             'scheme': name,
//                                             'imgUrl': img,
//                                             'scheme_code': schemeCode,
//                                           },
//                                         );
//                                       },
//                                       isNetwork: true,
//                                       imgPath: img,
//                                       name: name,
//                                       threeYear: threeyear,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 32, // Compact button height
//                                     child: ElevatedButton.icon(
//                                       onPressed: () {
//                                         Get.find<CartController>().addToCart(
//                                           schemeCode,
//                                           name,
//                                           fund.minSipAmount ?? 1000,
//                                           null,
//                                         );
//                                         Get.find<MutualFundController>()
//                                             .removeFromRecentlyViewed(
//                                               schemeCode,
//                                             );
//                                       },
//                                       icon: const Icon(
//                                         Icons.add_shopping_cart,
//                                         size: 16,
//                                         color: Colors.white,
//                                       ),
//                                       label: const Text(
//                                         "Add to Cart",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Ucolors
//                                             .primary, // Using your theme color
//                                         padding: EdgeInsets.zero,
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                     ],
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }

// }

// // =========================================
// // 💳 MUTUAL FUND CARD COMPONENT
// // =========================================
// class MutualFundCard1 extends StatelessWidget {
//   MutualFundCard1({
//     super.key,
//     this.isDelete = false,
//     this.containercolor,
//     required this.entity,
//   });

//   final bool isDelete;
//   final Color? containercolor;
//   final dynamic entity;

//   final CartController controller = Get.find<CartController>();
//   final MutualFundController mutualFundController =
//       Get.find<MutualFundController>();
//   final WishlistController wishlistController = Get.find<WishlistController>();

//   @override
//   Widget build(BuildContext context) {
//     final bool isWishlistType = entity is WishlistDataEntity;
//     final bool isWeb =
//         MediaQuery.of(context).size.width > 800; // 🚀 Web check for routing

//     // Extract Basic Info
//     final String displaySchemeName = isWishlistType
//         ? (entity as WishlistDataEntity).schemeName ?? 'Unknown Fund'
//         : (entity as MutualFundListEntity).baseSchemeName ?? 'Unknown Fund';

//     final String displaySchemeCode = isWishlistType
//         ? (entity as WishlistDataEntity).schemeCode ?? ''
//         : (entity as MutualFundListEntity).schemeCode?.toString() ?? '';

//     final String displayRiskLevel = entity.riskLevel ?? 'Moderate';

//     final String displayImgUrl = isWishlistType
//         ? "${Appurl.baseUrl}${(entity as WishlistDataEntity).amcLogo ?? ''}"
//         : "${Appurl.baseUrl}${(entity as MutualFundListEntity).amc?.amcLogoUrl ?? ''}";

//     // Extract Returns
//     final String r1Y = isWishlistType
//         ? (entity as WishlistDataEntity).returns?.oneYear ?? "0.00"
//         : (entity as MutualFundListEntity).returnsEntity?.oneYear ?? "0.00";
//     final String r3Y = isWishlistType
//         ? (entity as WishlistDataEntity).returns?.threeYear ?? "0.00"
//         : (entity as MutualFundListEntity).returnsEntity?.threeYear ?? "0.00";
//     final String r5Y = isWishlistType
//         ? (entity as WishlistDataEntity).returns?.fiveYear ?? "0.00"
//         : (entity as MutualFundListEntity).returnsEntity?.fiveYear ?? "0.00";
//     final String r10Y = isWishlistType
//         ? (entity as WishlistDataEntity).returns?.tenYear ?? "0.00"
//         : (entity as MutualFundListEntity).returnsEntity?.tenYear ?? "0.00";

//     return GestureDetector(
//       onTap: () {
//         // 🚀 FIX: Web Nested Routing Handling
//         if (isWeb) {
//           Get.toNamed(
//             AppRoutes.funddetails,
//             id: 1,
//             arguments: {
//               'scheme': displaySchemeName,
//               'imgUrl': displayImgUrl,
//               'scheme_code': displaySchemeCode,
//               if (!isWishlistType) ...{
//                 'email': (entity as MutualFundListEntity).amc?.email,
//                 'address': (entity as MutualFundListEntity).amc?.address,
//                 'contact': (entity as MutualFundListEntity).amc?.contact,
//               },
//             },
//           );
//         } else {
//           Get.toNamed(
//             AppRoutes.funddetails,
//             arguments: {
//               'scheme': displaySchemeName,
//               'imgUrl': displayImgUrl,
//               'scheme_code': displaySchemeCode,
//               if (!isWishlistType) ...{
//                 'email': (entity as MutualFundListEntity).amc?.email,
//                 'address': (entity as MutualFundListEntity).amc?.address,
//                 'contact': (entity as MutualFundListEntity).amc?.contact,
//               },
//             },
//           );
//           mutualFundController.addToLocalRecentlyViewed(
//             MutualFundListEntity(
//               schemecategory: null,
//               nav: null,
//               minTopUp: null,
//               returnsEntity: null,
//               schemeCode: displaySchemeCode,
//               baseSchemeName: displaySchemeName,
//               schemeType: null,
//               riskLevel: null,
//               isin: null,
//               amc: AmcEntity(
//                 id: null,
//                 amcName: null,
//                 amcLogoUrl: (entity as WishlistDataEntity).amcLogo ?? '',
//               ),
//               minSipAmount: null,
//               minLumpsum: null,
//               variants: [],
//             ),
//           );
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(16), // Slightly padded for better look
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.grey.shade200,
//           ), // Added border for crisp look
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.04), // Lighter shadow
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   maxRadius: 20,
//                   backgroundColor: Colors.transparent,
//                   child: ClipOval(
//                     child: CustomCachedImage(imageUrl: displayImgUrl),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         displaySchemeName,
//                         style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xff383838),
//                         ),
//                       ),
//                       if (!isDelete) const SizedBox(height: 4),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Risk: ',
//                               style: Theme.of(context).textTheme.labelSmall!
//                                   .copyWith(fontWeight: FontWeight.normal),
//                             ),
//                             TextSpan(
//                               text: displayRiskLevel,
//                               style: Theme.of(context).textTheme.labelMedium!
//                                   .copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     color: getRiskMeter(displayRiskLevel).color,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Delete Action
//                 Obx(() {
//                   final String currentId = isWishlistType
//                       ? (entity as WishlistDataEntity).wishlistId.toString()
//                       : "";
//                   bool isThisItemDeleting =
//                       wishlistController.deletingItemId.value == currentId;

//                   return Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       color: containercolor ?? const Color(0xffFEF0F0),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: isThisItemDeleting
//                         ? const Padding(
//                             padding: EdgeInsets.all(10.0),
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.red,
//                               ),
//                             ),
//                           )
//                         : IconButton(
//                             onPressed: () {
//                               if (currentId.isNotEmpty) {
//                                 wishlistController.removeFromWishlist(
//                                   currentId,
//                                 );
//                               }
//                             },
//                             icon: const Icon(
//                               Icons.delete_outline,
//                               color: Colors.red,
//                               size: 20,
//                             ),
//                           ),
//                   );
//                 }),

//                 const SizedBox(width: 8),

//                 // Add to Cart Action
//                 Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: IconButton(
//                     onPressed: () async {
//                       final String currentId = isWishlistType
//                           ? (entity as WishlistDataEntity).wishlistId.toString()
//                           : "";
//                       await controller.addToCart(
//                         displaySchemeCode,
//                         displaySchemeName,
//                         10000,
//                         null,
//                         transType: 'sip',
//                       );
//                       await controller.fetchCart();
//                       if (currentId.isNotEmpty) {
//                         await wishlistController.removeFromWishlist(currentId);
//                       }
//                     },
//                     icon: const Icon(
//                       Icons.shopping_cart_outlined,
//                       color: Ucolors.primary,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (!isDelete) const SizedBox(height: 16),
//             if (!isDelete)
//               Row(
//                 children: [
//                   Text(
//                     "Trailing Return",
//                     style: TextStyle(
//                       color: Ucolors.borderside,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Divider(color: Colors.grey.shade200, thickness: 1),
//                   ),
//                 ],
//               ),
//             if (!isDelete) const SizedBox(height: 12),
//             if (!isDelete)
//               // Returns
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _ReturnItem(
//                     isNegative: double.parse(r1Y) < 0,
//                     title: '1Y',
//                     value: '$r1Y%',
//                   ),
//                   _ReturnItem(
//                     isNegative: double.parse(r3Y) < 0,
//                     title: '3Y',
//                     value: '$r3Y%',
//                   ),
//                   _ReturnItem(
//                     isNegative: double.parse(r5Y) < 0,
//                     title: '5Y',
//                     value: '$r5Y%',
//                   ),
//                   _ReturnItem(
//                     isNegative: double.parse(r10Y) < 0,
//                     title: '10Y',
//                     value: '$r10Y%',
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ReturnItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isNegative;
//   const _ReturnItem({
//     required this.title,
//     required this.value,
//     this.isNegative = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: Theme.of(
//             context,
//           ).textTheme.labelMedium?.copyWith(color: Colors.grey.shade600),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: Theme.of(context).textTheme.labelMedium!.copyWith(
//             fontWeight: FontWeight.bold,
//             color: isNegative ? Colors.red : Colors.green,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/empty_filled.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class WatchlistPage extends StatelessWidget {
  WatchlistPage({super.key});

  final MutualFundController controller = Get.find();
  final WishlistController controllerr = Get.find<WishlistController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      // backgroundColor: isDesktop
      //     ? const Color(0xFFF5F7FB)
      //     : Colors.grey.shade50,
      appBar: isDesktop
          ? null
          : CustomAppBarNormal(
              actionsPadding: 15,
              title: 'Watchlist',
              action: [
                Obx(
                  () => Stack(
                    children: [
                      CompactIcon(
                        icon: Iconsax.shopping_cart,
                        onPressed: () {
                          Get.find<CartController>().filterGoalId.value = null;
                          Get.toNamed(AppRoutes.cart);
                        },
                        iconColor: Ucolors.dark,
                      ),
                      if (cartController.generalItemsCount > 0)
                        Positioned(
                          right: 0,
                          top: -5,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Ucolors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cartController.generalItemsCount.toString(),
                              style: UTextStyles.buttonText.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
      body: SafeArea(
        child: isDesktop
            ? _buildWebLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  // =========================================
  // 💻 MODERN WEB / DESKTOP LAYOUT
  // =========================================
  // Widget _buildWebLayout(BuildContext context) {
  //   return Obx(() {
  //     if (controllerr.isLoading.value) {
  //       return const Center(
  //         child: CircularProgressIndicator(color: Ucolors.primary),
  //       );
  //     }

  //     if (controller.errorMessage.isNotEmpty) {
  //       return _buildWebErrorState();
  //     }

  //     final wishlistItems =
  //         controllerr.wishlistResponseEntity.value?.data ?? [];
  //     final recentFunds = Get.find<MutualFundController>().recentlyViewedFunds;

  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildWebHeader(wishlistItems.length),
  //           const SizedBox(height: 24),
  //           Expanded(
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   flex: 6,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(26),
  //                       border: Border.all(color: const Color(0xFFE8ECF3)),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withValues(alpha: 0.04),
  //                           blurRadius: 24,
  //                           offset: const Offset(0, 10),
  //                         ),
  //                       ],
  //                     ),
  //                     child: wishlistItems.isEmpty
  //                         ? _buildWebEmptyState()
  //                         : _buildWebWishlistList(wishlistItems),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 24),
  //                 Expanded(
  //                flex: 4,
  //                   child: Column(
  //                     children: [
  //                       _buildWebStatsCard(wishlistItems.length),
  //                       const SizedBox(height: 18),
  //                       if (recentFunds.isNotEmpty)
  //                         Expanded(
  //                           child: _buildWebRecentlyViewed(recentFunds),
  //                         )
  //                       else
  //                         _buildWebHintCard(),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   });
  // }

  Widget _buildWebLayout(BuildContext context) {
    return Obx(() {
      if (controllerr.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Ucolors.primary),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return _buildWebErrorState();
      }

      final wishlistItems =
          controllerr.wishlistResponseEntity.value?.data ?? [];
      final recentFunds = Get.find<MutualFundController>().recentlyViewedFunds;

      return LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = MediaQuery.sizeOf(context);
          final pageWidth = constraints.maxWidth;

          final bool largeDesktopLayout =
              screenSize.width >= 1536 &&
              screenSize.height >= 729.5999755859375;

          final bool mediumCardsInOneRow =
              screenSize.width <= 1396.3636474609375 &&
              screenSize.height <= 663.272705078125 &&
              recentFunds.isEmpty;

          final bool compactHeaderOneRow =
              screenSize.width <= 877.7142944335938 &&
              screenSize.height <= 416.9142761230469;

          final bool stackedLayout = pageWidth < 1160 && !largeDesktopLayout;

          final double horizontalPadding = pageWidth <= 900
              ? 14
              : pageWidth <= 1300
              ? 22
              : 28;

          Widget wishlistPanel({required bool shrinkWrap}) {
            return _webPanel(
              child: wishlistItems.isEmpty
                  ? _buildWebEmptyState()
                  : _buildWebWishlistList(
                      wishlistItems,
                      shrinkWrap: shrinkWrap,
                    ),
            );
          }

          Widget cardsPanel({required bool fillHeight}) {
            if (mediumCardsInOneRow) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _buildWebStatsCard(wishlistItems.length)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildWebHintCard()),
                  ],
                ),
              );
            }

            return Column(
              mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
              children: [
                _buildWebStatsCard(wishlistItems.length),
                const SizedBox(height: 18),
                if (recentFunds.isNotEmpty)
                  fillHeight
                      ? Expanded(child: _buildWebRecentlyViewed(recentFunds))
                      : _buildWebRecentlyViewed(recentFunds, shrinkWrap: true)
                else
                  _buildWebHintCard(),
              ],
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: pageWidth <= 900 ? 14 : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWebHeader(
                  wishlistItems.length,
                  compactOneRow: compactHeaderOneRow,
                ),
                SizedBox(height: compactHeaderOneRow ? 14 : 24),

                Expanded(
                  child: stackedLayout
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              wishlistPanel(shrinkWrap: true),
                              const SizedBox(height: 18),
                              cardsPanel(fillHeight: false),
                            ],
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: largeDesktopLayout ? 6 : 6,
                              child: wishlistPanel(shrinkWrap: false),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: largeDesktopLayout ? 4 : 4,
                              child: cardsPanel(fillHeight: true),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _webPanel({required Widget child}) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE8ECF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildWebHeader(int count, {bool compactOneRow = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool normalCompact = constraints.maxWidth < 720;
        final bool forceOneRow = compactOneRow;

        final titleBlock = Row(
          children: [
            Container(
              height: forceOneRow ? 40 : 54,
              width: forceOneRow ? 40 : 54,
              decoration: BoxDecoration(
                gradient: Ucolors.backgroundGradient,
                borderRadius: BorderRadius.circular(forceOneRow ? 14 : 18),
                boxShadow: [
                  BoxShadow(
                    color: Ucolors.primary.withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: forceOneRow ? 18 : 24,
              ),
            ),
            SizedBox(width: forceOneRow ? 10 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Watchlist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h2(color: Ucolors.dark).copyWith(
                      fontSize: forceOneRow
                          ? 18
                          : normalCompact
                          ? 23
                          : 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    count == 0
                        ? forceOneRow
                              ? 'Track your favourite funds.'
                              : 'Track and compare your favourite mutual funds in one place.'
                        : forceOneRow
                        ? '$count saved fund${count == 1 ? '' : 's'}.'
                        : '$count saved fund${count == 1 ? '' : 's'} ready to track, review, or invest.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Colors.grey.shade600,
                      fontSize: forceOneRow ? 11 : 14,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WebHeaderButton(
              icon: Icons.refresh_rounded,
              label: 'Refresh',
              compact: forceOneRow,
              onTap: () => controllerr.fetchWishlist(),
            ),
            SizedBox(width: forceOneRow ? 8 : 12),
            Obx(
              () => _WebCartButton(
                count: cartController.generalItemsCount,
                compact: forceOneRow,
                onTap: () {
                  Get.find<CartController>().filterGoalId.value = null;
                  Get.find<NavigationBarController>().selectedIndex.value = 100;
                  Get.toNamed(AppRoutes.cart, id: 1);
                },
              ),
            ),
          ],
        );

        if (forceOneRow) {
          return Row(
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: 10),
              actions,
            ],
          );
        }

        if (normalCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  _WebHeaderButton(
                    icon: Icons.refresh_rounded,
                    label: 'Refresh',
                    onTap: () => controllerr.fetchWishlist(),
                  ),
                  Obx(
                    () => _WebCartButton(
                      count: cartController.generalItemsCount,
                      onTap: () {
                        Get.find<CartController>().filterGoalId.value = null;
                        Get.find<NavigationBarController>()
                                .selectedIndex
                                .value =
                            100;
                        Get.toNamed(AppRoutes.cart, id: 1);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: titleBlock),
            const SizedBox(width: 16),
            actions,
          ],
        );
      },
    );
  }

  // Widget _buildWebHeader(int count) {
  //   return Row(
  //     children: [
  //       Container(
  //         height: 54,
  //         width: 54,
  //         decoration: BoxDecoration(
  //           gradient: Ucolors.backgroundGradient,
  //           borderRadius: BorderRadius.circular(18),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Ucolors.primary.withValues(alpha: 0.20),
  //               blurRadius: 18,
  //               offset: const Offset(0, 8),
  //             ),
  //           ],
  //         ),
  //         child: const Icon(Icons.favorite_rounded, color: Colors.white),
  //       ),
  //       const SizedBox(width: 16),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'My Watchlist',
  //               style: AppTextStyles.h2(color: Ucolors.dark).copyWith(
  //                 fontSize: 28,
  //                 fontWeight: FontWeight.w600,
  //                 letterSpacing: -0.6,
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Text(
  //               count == 0
  //                   ? 'Track and compare your favourite mutual funds in one place.'
  //                   : '$count saved fund${count == 1 ? '' : 's'} ready to track, review, or invest.',
  //               style: TextStyle(
  //                 fontFamily: FontFamily.medium,
  //                 color: Colors.grey.shade600,
  //                 fontSize: 14,
  //                 height: 1.35,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       _WebHeaderButton(
  //         icon: Icons.refresh_rounded,
  //         label: 'Refresh',
  //         onTap: () => controllerr.fetchWishlist(),
  //       ),
  //       const SizedBox(width: 12),
  //       Obx(
  //         () => _WebCartButton(
  //           count: cartController.generalItemsCount,
  //           onTap: () {
  //             Get.find<CartController>().filterGoalId.value = null;
  //             Get.find<NavigationBarController>().selectedIndex.value = 100;
  //             Get.toNamed(AppRoutes.cart, id: 1);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildWebWishlistList(
    List<dynamic> wishlistItems, {
    bool shrinkWrap = false,
  }) {
    final list = ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: wishlistItems.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F3F8)),
      itemBuilder: (context, index) {
        return _WebWishlistRow(entity: wishlistItems[index]);
      },
    );

    return Column(
      mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE8ECF3))),
          ),
          child: Row(
            children: [
              const Expanded(flex: 5, child: _WebTableHeaderText('Fund Name')),
              const Expanded(flex: 2, child: _WebTableHeaderText('Risk')),
              const Expanded(flex: 3, child: _WebTableHeaderText('Returns')),
              SizedBox(
                width: 116,
                child: Text(
                  'Actions',
                  textAlign: TextAlign.right,
                  style: _webHeaderStyle(),
                ),
              ),
            ],
          ),
        ),
        shrinkWrap ? list : Expanded(child: list),
      ],
    );
  }

  // Widget _buildWebWishlistList(List<dynamic> wishlistItems) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.fromLTRB(24, 20, 24, 14),
  //         decoration: const BoxDecoration(
  //           border: Border(bottom: BorderSide(color: Color(0xFFE8ECF3))),
  //         ),
  //         child: Row(
  //           children: [
  //             const Expanded(flex: 5, child: _WebTableHeaderText('Fund Name')),
  //             const Expanded(flex: 2, child: _WebTableHeaderText('Risk')),
  //             const Expanded(flex: 3, child: _WebTableHeaderText('Returns')),
  //             SizedBox(
  //               width: 116,
  //               child: Text(
  //                 'Actions',
  //                 textAlign: TextAlign.right,
  //                 style: _webHeaderStyle(),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Expanded(
  //         child: ListView.separated(
  //           padding: const EdgeInsets.symmetric(vertical: 8),
  //           itemCount: wishlistItems.length,
  //           separatorBuilder: (_, __) => const Divider(
  //             height: 1,
  //             thickness: 1,
  //             color: Color(0xFFF0F3F8),
  //           ),
  //           itemBuilder: (context, index) {
  //             return _WebWishlistRow(entity: wishlistItems[index]);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildWebEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(56),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: Ucolors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: Ucolors.primary,
                  size: 38,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Your Watchlist is Empty',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Ucolors.dark,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Add funds to your watchlist and monitor performance before investing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.explorePage, id: 1),
                  icon: const Icon(Icons.search_rounded, color: Colors.white),
                  label: const Text(
                    'Discover Funds',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Ucolors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebStatsCard(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: Ucolors.backgroundGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Ucolors.primary.withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.bookmark_rounded, color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Live Tracking',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            count.toString(),
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Watchlisted Fund${count == 1 ? '' : 's'}',
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: Colors.white.withValues(alpha: 0.86),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              // onPressed: () => Get.toNamed(AppRoutes.explorePage, id: 1),
              onPressed: () {
                if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
                  Get.find<NavigationBarController>().openNestedRoute(
                    AppRoutes.explorePage,
                  );
                } else {
                  Get.toNamed(AppRoutes.explorePage);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Explore More Funds',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Ucolors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebRecentlyViewed(
    List<dynamic> recentFunds, {
    bool shrinkWrap = false,
  }) {
    final list = ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: recentFunds.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fund = recentFunds[index];
        final img = '${Appurl.baseUrl}${fund.amc?.amcLogoUrl}';
        final name = fund.baseSchemeName ?? 'Unknown Name';
        final threeyear = fund.returnsEntity?.threeYear ?? '0.00';
        final schemeCode = fund.schemeCode.toString();

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8ECF3)),
          ),
          child: Row(
            children: [
              ClipOval(child: CustomCachedImage(imageUrl: img, radius: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Ucolors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3Y Return $threeyear%',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 11,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Add to Cart',
                onPressed: () {
                  Get.find<CartController>().addToCart(
                    schemeCode,
                    name,
                    fund.minSipAmount ?? 1000,
                    null,
                  );
                  Get.find<MutualFundController>().removeFromRecentlyViewed(
                    schemeCode,
                  );
                },
                icon: const Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Ucolors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Ucolors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Recently Viewed',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          shrinkWrap ? list : Expanded(child: list),
        ],
      ),
    );
  }

  // Widget _buildWebRecentlyViewed(List<dynamic> recentFunds) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(color: const Color(0xFFE8ECF3)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.035),
  //           blurRadius: 18,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
  //           child: Row(
  //             children: [
  //               Container(
  //                 width: 4,
  //                 height: 20,
  //                 decoration: BoxDecoration(
  //                   color: Ucolors.primary,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               const Expanded(
  //                 child: Text(
  //                   'Recently Viewed',
  //                   style: TextStyle(
  //                     fontFamily: FontFamily.medium,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: ListView.separated(
  //             padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
  //             itemCount: recentFunds.length,
  //             separatorBuilder: (_, __) => const SizedBox(height: 12),
  //             itemBuilder: (context, index) {
  //               final fund = recentFunds[index];
  //               final img = '${Appurl.baseUrl}${fund.amc?.amcLogoUrl}';
  //               final name = fund.baseSchemeName ?? 'Unknown Name';
  //               final threeyear = fund.returnsEntity?.threeYear ?? '0.00';
  //               final schemeCode = fund.schemeCode.toString();

  //               return Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFF8FAFD),
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(color: const Color(0xFFE8ECF3)),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     ClipOval(
  //                       child: CustomCachedImage(imageUrl: img, radius: 16),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             name,
  //                             maxLines: 2,
  //                             overflow: TextOverflow.ellipsis,
  //                             style: const TextStyle(
  //                               fontFamily: FontFamily.medium,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w500,
  //                               color: Ucolors.dark,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             '3Y Return $threeyear%',
  //                             style: TextStyle(
  //                               fontFamily: FontFamily.medium,
  //                               fontSize: 11,
  //                               color: Colors.green.shade700,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     IconButton(
  //                       tooltip: 'Add to Cart',
  //                       onPressed: () {
  //                         Get.find<CartController>().addToCart(
  //                           schemeCode,
  //                           name,
  //                           fund.minSipAmount ?? 1000,
  //                           null,
  //                         );
  //                         Get.find<MutualFundController>()
  //                             .removeFromRecentlyViewed(schemeCode);
  //                       },
  //                       icon: const Icon(
  //                         Icons.add_shopping_cart_rounded,
  //                         color: Ucolors.primary,
  //                         size: 20,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildWebHintCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8ECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.insights_rounded, color: Ucolors.primary),
          const SizedBox(height: 12),
          const Text(
            'Build a smarter watchlist',
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Ucolors.dark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Save funds first, compare returns, then add the right option to cart.',
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebErrorState() {
    return Center(
      child: Container(
        width: 460,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 42,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 14,
                color: Ucolors.dark,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => controllerr.fetchWishlist(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT — kept same
  // =========================================
  Widget _buildMobileLayout(BuildContext context) {
    return _buildWatchlistContent();
  }

  Widget _buildWatchlistContent() {
    return Obx(() {
      if (controllerr.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: Ucolors.primary),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controllerr.fetchWishlist(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final wishlistItems =
          controllerr.wishlistResponseEntity.value?.data ?? [];

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          if (wishlistItems.isEmpty)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnimatedEmptyState(
                          title: 'Your Watchlist is Empty',
                          message:
                              'Track the funds you love. Add them to your watchlist to monitor their performance easily.',
                          icon: Icons.favorite_border_rounded,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.explorePage);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Ucolors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_rounded, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Discover Funds',
                                  style: AppTextStyles.bodyMediumBold()
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = wishlistItems[index];
                  return MutualFundCard1(
                    isDelete: true,
                    containercolor: const Color(0xffFEF0F0),
                    entity: item,
                  );
                }, childCount: wishlistItems.length),
              ),
            ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  final recentFunds =
                      Get.find<MutualFundController>().recentlyViewedFunds;

                  if (recentFunds.isEmpty || wishlistItems.length > 3) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 56),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Ucolors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Recently Viewed',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          clipBehavior: Clip.none,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: recentFunds.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final fund = recentFunds[index];
                            final img =
                                '${Appurl.baseUrl}${fund.amc?.amcLogoUrl}';
                            final name = fund.baseSchemeName ?? 'Unknown Name';
                            final threeyear =
                                fund.returnsEntity?.threeYear ?? '';
                            final schemeCode = fund.schemeCode.toString();

                            return SizedBox(
                              width: Get.width * 0.45,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: PopularFundCardMob(
                                      onTap: () {
                                        Get.find<MutualFundController>()
                                            .addToLocalRecentlyViewed(fund);
                                        Get.toNamed(
                                          AppRoutes.funddetails,
                                          arguments: {
                                            'scheme': name,
                                            'imgUrl': img,
                                            'scheme_code': schemeCode,
                                          },
                                        );
                                      },
                                      isNetwork: true,
                                      imgPath: img,
                                      name: name,
                                      threeYear: threeyear,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 32,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Get.find<CartController>().addToCart(
                                          schemeCode,
                                          name,
                                          fund.minSipAmount ?? 1000,
                                          null,
                                        );
                                        Get.find<MutualFundController>()
                                            .removeFromRecentlyViewed(
                                              schemeCode,
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.add_shopping_cart,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Add to Cart',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Ucolors.primary,
                                        padding: EdgeInsets.zero,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      );
    });
  }
}

// =========================================
// 💻 WEB HELPERS
// =========================================
class _WebHeaderButton extends StatelessWidget {
  const _WebHeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: compact ? 40 : 46,
        padding: EdgeInsets.symmetric(horizontal: compact ? 11 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8ECF3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Ucolors.primary, size: compact ? 18 : 19),
            if (!compact) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Ucolors.dark,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
// class _WebHeaderButton extends StatelessWidget {
//   const _WebHeaderButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         height: 46,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: const Color(0xFFE8ECF3)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Ucolors.primary, size: 19),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontFamily: FontFamily.medium,
//                 color: Ucolors.dark,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class _WebCartButton extends StatelessWidget {
  const _WebCartButton({
    required this.count,
    required this.onTap,
    this.compact = false,
  });

  final int count;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: compact ? 40 : 46,
        padding: EdgeInsets.symmetric(horizontal: compact ? 11 : 16),
        decoration: BoxDecoration(
          color: Ucolors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Ucolors.primary.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.shopping_cart,
              color: Colors.white,
              size: compact ? 18 : 19,
            ),
            if (!compact) ...[
              const SizedBox(width: 8),
              const Text(
                'Cart',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
            if (count > 0) ...[
              SizedBox(width: compact ? 5 : 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Ucolors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// class _WebCartButton extends StatelessWidget {
//   const _WebCartButton({required this.count, required this.onTap});

//   final int count;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         height: 46,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: Ucolors.primary,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Ucolors.primary.withValues(alpha: 0.22),
//               blurRadius: 14,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             const Icon(Iconsax.shopping_cart, color: Colors.white, size: 19),
//             const SizedBox(width: 8),
//             const Text(
//               'Cart',
//               style: TextStyle(
//                 fontFamily: FontFamily.medium,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//               ),
//             ),
//             if (count > 0) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//                 child: Text(
//                   count.toString(),
//                   style: const TextStyle(
//                     fontFamily: FontFamily.medium,
//                     color: Ucolors.primary,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

class _WebTableHeaderText extends StatelessWidget {
  const _WebTableHeaderText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: _webHeaderStyle());
  }
}

TextStyle _webHeaderStyle() {
  return TextStyle(
    fontFamily: FontFamily.medium,
    color: Colors.grey.shade500,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}

class _WebWishlistRow extends StatelessWidget {
  _WebWishlistRow({required this.entity});

  final dynamic entity;

  final CartController cartController = Get.find<CartController>();
  final MutualFundController mutualFundController =
      Get.find<MutualFundController>();
  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    final data = _FundRowData.from(entity);

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.funddetails, id: 1, arguments: data.arguments);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  ClipOval(
                    child: CustomCachedImage(
                      imageUrl: data.imageUrl,
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.schemeName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Ucolors.dark,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Scheme Code: ${data.schemeCode}',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.grey.shade500,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _WebRiskPill(risk: data.riskLevel),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _WebReturnMini(label: '1Y', value: data.oneYear),
                  const SizedBox(width: 13),
                  _WebReturnMini(label: '3Y', value: data.threeYear),
                  if (Get.height >= 486.3999938964844 && Get.width >= 1024)
                    const SizedBox(width: 13),
                  if (Get.height >= 486.3999938964844 && Get.width >= 1024)
                    _WebReturnMini(label: '5Y', value: data.fiveYear),
                ],
              ),
            ),
            SizedBox(
              width: 116,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    final isDeleting =
                        data.wishlistId.isNotEmpty &&
                        wishlistController.deletingItemId.value ==
                            data.wishlistId;
                    return _WebIconAction(
                      tooltip: 'Remove',
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red,
                      bgColor: const Color(0xFFFFF0F0),
                      isLoading: isDeleting,
                      onTap: () {
                        if (data.wishlistId.isNotEmpty) {
                          wishlistController.removeFromWishlist(
                            data.wishlistId,
                          );
                        }
                      },
                    );
                  }),
                  const SizedBox(width: 10),
                  _WebIconAction(
                    tooltip: 'Add to Cart',
                    icon: Icons.add_shopping_cart_rounded,
                    color: Ucolors.primary,
                    bgColor: Ucolors.primary.withValues(alpha: 0.08),
                    onTap: () async {
                      await cartController.addToCart(
                        data.schemeCode,
                        data.schemeName,
                        10000,
                        null,
                        transType: 'sip',
                      );
                      await cartController.fetchCart();
                      if (data.wishlistId.isNotEmpty) {
                        await wishlistController.removeFromWishlist(
                          data.wishlistId,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundRowData {
  final String schemeName;
  final String schemeCode;
  final String riskLevel;
  final String imageUrl;
  final String oneYear;
  final String threeYear;
  final String fiveYear;
  final String tenYear;
  final String wishlistId;
  final Map<String, dynamic> arguments;

  _FundRowData({
    required this.schemeName,
    required this.schemeCode,
    required this.riskLevel,
    required this.imageUrl,
    required this.oneYear,
    required this.threeYear,
    required this.fiveYear,
    required this.tenYear,
    required this.wishlistId,
    required this.arguments,
  });

  factory _FundRowData.from(dynamic entity) {
    final bool isWishlistType = entity is WishlistDataEntity;

    final String schemeName = isWishlistType
        ? (entity as WishlistDataEntity).schemeName ?? 'Unknown Fund'
        : (entity as MutualFundListEntity).baseSchemeName ?? 'Unknown Fund';

    final String schemeCode = isWishlistType
        ? (entity as WishlistDataEntity).schemeCode ?? ''
        : (entity as MutualFundListEntity).schemeCode?.toString() ?? '';

    final String imageUrl = isWishlistType
        ? '${Appurl.baseUrl}${(entity as WishlistDataEntity).amcLogo ?? ''}'
        : '${Appurl.baseUrl}${(entity as MutualFundListEntity).amc?.amcLogoUrl ?? ''}';

    final String riskLevel = entity.riskLevel ?? 'Moderate';

    final String oneYear = isWishlistType
        ? (entity as WishlistDataEntity).returns?.oneYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.oneYear ?? '0.00';
    final String threeYear = isWishlistType
        ? (entity as WishlistDataEntity).returns?.threeYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.threeYear ?? '0.00';
    final String fiveYear = isWishlistType
        ? (entity as WishlistDataEntity).returns?.fiveYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.fiveYear ?? '0.00';
    final String tenYear = isWishlistType
        ? (entity as WishlistDataEntity).returns?.tenYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.tenYear ?? '0.00';

    final String wishlistId = isWishlistType
        ? (entity as WishlistDataEntity).wishlistId.toString()
        : '';

    final Map<String, dynamic> args = {
      'scheme': schemeName,
      'imgUrl': imageUrl,
      'scheme_code': schemeCode,
      if (!isWishlistType) ...{
        'email': (entity as MutualFundListEntity).amc?.email,
        'address': (entity as MutualFundListEntity).amc?.address,
        'contact': (entity as MutualFundListEntity).amc?.contact,
      },
    };

    return _FundRowData(
      schemeName: schemeName,
      schemeCode: schemeCode,
      riskLevel: riskLevel,
      imageUrl: imageUrl,
      oneYear: oneYear,
      threeYear: threeYear,
      fiveYear: fiveYear,
      tenYear: tenYear,
      wishlistId: wishlistId,
      arguments: args,
    );
  }
}

class _WebRiskPill extends StatelessWidget {
  const _WebRiskPill({required this.risk});

  final String risk;

  @override
  Widget build(BuildContext context) {
    final color = getRiskMeter(risk).color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Text(
        risk,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: FontFamily.medium,
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WebReturnMini extends StatelessWidget {
  const _WebReturnMini({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final parsed = double.tryParse(value) ?? 0;
    final color = parsed < 0 ? Colors.red : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: Colors.grey.shade500,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '$value%',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WebIconAction extends StatelessWidget {
  const _WebIconAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
    this.isLoading = false,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.all(11),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

// =========================================
// 💳 MUTUAL FUND CARD COMPONENT — mobile kept same
// =========================================
class MutualFundCard1 extends StatelessWidget {
  MutualFundCard1({
    super.key,
    this.isDelete = false,
    this.containercolor,
    required this.entity,
  });

  final bool isDelete;
  final Color? containercolor;
  final dynamic entity;

  final CartController controller = Get.find<CartController>();
  final MutualFundController mutualFundController =
      Get.find<MutualFundController>();
  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    final bool isWishlistType = entity is WishlistDataEntity;
    final bool isWeb = MediaQuery.of(context).size.width > 800;

    final String displaySchemeName = isWishlistType
        ? (entity as WishlistDataEntity).schemeName ?? 'Unknown Fund'
        : (entity as MutualFundListEntity).baseSchemeName ?? 'Unknown Fund';

    final String displaySchemeCode = isWishlistType
        ? (entity as WishlistDataEntity).schemeCode ?? ''
        : (entity as MutualFundListEntity).schemeCode?.toString() ?? '';

    final String displayRiskLevel = entity.riskLevel ?? 'Moderate';

    final String displayImgUrl = isWishlistType
        ? '${Appurl.baseUrl}${(entity as WishlistDataEntity).amcLogo ?? ''}'
        : '${Appurl.baseUrl}${(entity as MutualFundListEntity).amc?.amcLogoUrl ?? ''}';

    final String r1Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.oneYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.oneYear ?? '0.00';
    final String r3Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.threeYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.threeYear ?? '0.00';
    final String r5Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.fiveYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.fiveYear ?? '0.00';
    final String r10Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.tenYear ?? '0.00'
        : (entity as MutualFundListEntity).returnsEntity?.tenYear ?? '0.00';

    return GestureDetector(
      onTap: () {
        if (isWeb) {
          Get.toNamed(
            AppRoutes.funddetails,
            id: 1,
            arguments: {
              'scheme': displaySchemeName,
              'imgUrl': displayImgUrl,
              'scheme_code': displaySchemeCode,
              if (!isWishlistType) ...{
                'email': (entity as MutualFundListEntity).amc?.email,
                'address': (entity as MutualFundListEntity).amc?.address,
                'contact': (entity as MutualFundListEntity).amc?.contact,
              },
            },
          );
        } else {
          Get.toNamed(
            AppRoutes.funddetails,
            arguments: {
              'scheme': displaySchemeName,
              'imgUrl': displayImgUrl,
              'scheme_code': displaySchemeCode,
              if (!isWishlistType) ...{
                'email': (entity as MutualFundListEntity).amc?.email,
                'address': (entity as MutualFundListEntity).amc?.address,
                'contact': (entity as MutualFundListEntity).amc?.contact,
              },
            },
          );
          if (isWishlistType) {
            mutualFundController.addToLocalRecentlyViewed(
              MutualFundListEntity(
                schemecategory: null,
                nav: null,
                minTopUp: null,
                returnsEntity: null,
                schemeCode: displaySchemeCode,
                baseSchemeName: displaySchemeName,
                schemeType: null,
                riskLevel: null,
                isin: null,
                amc: AmcEntity(
                  id: null,
                  amcName: null,
                  amcLogoUrl: (entity as WishlistDataEntity).amcLogo ?? '',
                ),
                minSipAmount: null,
                minLumpsum: null,
                variants: [],
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CustomCachedImage(imageUrl: displayImgUrl),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displaySchemeName,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff383838),
                        ),
                      ),
                      if (!isDelete) const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Risk: ',
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: displayRiskLevel,
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: getRiskMeter(displayRiskLevel).color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final String currentId = isWishlistType
                      ? (entity as WishlistDataEntity).wishlistId.toString()
                      : '';
                  final bool isThisItemDeleting =
                      wishlistController.deletingItemId.value == currentId;

                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: containercolor ?? const Color(0xffFEF0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isThisItemDeleting
                        ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              if (currentId.isNotEmpty) {
                                wishlistController.removeFromWishlist(
                                  currentId,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                  );
                }),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final String currentId = isWishlistType
                          ? (entity as WishlistDataEntity).wishlistId.toString()
                          : '';
                      await controller.addToCart(
                        displaySchemeCode,
                        displaySchemeName,
                        10000,
                        null,
                        transType: 'sip',
                      );
                      await controller.fetchCart();
                      if (currentId.isNotEmpty) {
                        await wishlistController.removeFromWishlist(currentId);
                      }
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Ucolors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            if (!isDelete) const SizedBox(height: 16),
            if (!isDelete)
              Row(
                children: [
                  Text(
                    'Trailing Return',
                    style: TextStyle(
                      color: Ucolors.borderside,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Divider(color: Colors.grey.shade200, thickness: 1),
                  ),
                ],
              ),
            if (!isDelete) const SizedBox(height: 12),
            if (!isDelete)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ReturnItem(
                    isNegative: (double.tryParse(r1Y) ?? 0) < 0,
                    title: '1Y',
                    value: '$r1Y%',
                  ),
                  _ReturnItem(
                    isNegative: (double.tryParse(r3Y) ?? 0) < 0,
                    title: '3Y',
                    value: '$r3Y%',
                  ),
                  _ReturnItem(
                    isNegative: (double.tryParse(r5Y) ?? 0) < 0,
                    title: '5Y',
                    value: '$r5Y%',
                  ),
                  _ReturnItem(
                    isNegative: (double.tryParse(r10Y) ?? 0) < 0,
                    title: '10Y',
                    value: '$r10Y%',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ReturnItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isNegative;

  const _ReturnItem({
    required this.title,
    required this.value,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: isNegative ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
