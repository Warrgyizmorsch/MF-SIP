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

class WatchlistPage extends StatelessWidget {
  WatchlistPage({super.key});

  final MutualFundController controller = Get.find();
  final WishlistController controllerr = Get.find<WishlistController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    // 🚀 Check for Web/Desktop
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : Colors.grey.shade50,

      // 🚀 THE FIX: Web par local AppBar hide karo (Global Header handles it)
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
            ? _buildWebLayout(context) // 💻 Web UI
            : _buildMobileLayout(context), // 📱 Mobile UI
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT
  // =========================================
  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ), // 🚀 Optimal width for list view
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Watchlist",
                          style: AppTextStyles.h2(color: Ucolors.dark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Track and monitor your favorite mutual funds.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    // Action Buttons (Optional extra controls)
                    IconButton(
                      onPressed: () => controllerr.fetchWishlist(),
                      icon: const Icon(Icons.refresh, color: Ucolors.primary),
                      tooltip: 'Refresh Watchlist',
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // --- Content List ---
                _buildWatchlistContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT
  // =========================================
  Widget _buildMobileLayout(BuildContext context) {
    return _buildWatchlistContent();
  }

  // =========================================
  // 🧩 REUSABLE CONTENT
  // =========================================

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
                  child: const Text("Retry"),
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
          // --- 1. THE MAIN CONTENT (EMPTY STATE OR LIST) ---
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

          // --- 2. RECENTLY VIEWED SECTION (PUSHED TO BOTTOM) ---
          SliverFillRemaining(
            hasScrollBody: false, // 🚀 This makes it act like a Spacer!
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns to the bottom
              children: [
                Obx(() {
                  final recentFunds =
                      Get.find<MutualFundController>().recentlyViewedFunds;

                  // Only show if there are recent funds AND (wishlist is empty OR wishlist has <= 2 items)
                  if (recentFunds.isEmpty || wishlistItems.length > 3) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 56), // Spacing before the section
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
                              "Recently Viewed",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
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
                                "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
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
                                    height: 32, // Compact button height
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
                                        "Add to Cart",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Ucolors
                                            .primary, // Using your theme color
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
  // Widget _buildWatchlistContent() {
  //   return Obx(() {
  //     if (controllerr.isLoading.value) {
  //       return const Center(
  //         child: Padding(
  //           padding: EdgeInsets.all(40.0),
  //           child: CircularProgressIndicator(color: Ucolors.primary),
  //         ),
  //       );
  //     }

  //     if (controller.errorMessage.isNotEmpty) {
  //       return Center(
  //         child: Padding(
  //           padding: const EdgeInsets.all(40.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 controller.errorMessage.value,
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(height: 16),
  //               ElevatedButton(
  //                 onPressed: () => controllerr.fetchWishlist(),
  //                 child: const Text("Retry"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }

  //     final wishlistItems =
  //         controllerr.wishlistResponseEntity.value?.data ?? [];

  //     // if (wishlistItems.isEmpty) {
  //     //   return const Center(
  //     //     child: Padding(
  //     //       padding: EdgeInsets.all(40.0),
  //     //       child: AnimatedEmptyState(
  //     //         title: 'Empty Watchlist',
  //     //         message: 'There are no funds in your watchlist',
  //     //         icon: Icons.favorite_border,
  //     //       ),
  //     //     ),
  //     //   );
  //     // }
  //     if (wishlistItems.isEmpty) {
  //       return SingleChildScrollView(
  //         physics: const BouncingScrollPhysics(), // Modern fluid scrolling
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(height: Get.height * 0.05), // Responsive top spacing
  //             // 1. --- EMPTY STATE GRAPHIC & MODERN CTA ---
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const AnimatedEmptyState(
  //                     title: 'Your Watchlist is Empty',
  //                     message:
  //                         'Track the funds you love. Add them to your watchlist to monitor their performance easily.',
  //                     icon: Icons.favorite_border_rounded,
  //                   ),
  //                   const SizedBox(height: 32),

  //                   // Modern Full-Width Action Button
  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: 56, // Tall, premium touch target
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         Get.toNamed(AppRoutes.explorePage);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Ucolors.primary,
  //                         foregroundColor: Colors.white,
  //                         elevation: 0,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(
  //                             16,
  //                           ), // Smooth corners
  //                         ),
  //                       ),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           const Icon(Icons.search_rounded, size: 20),
  //                           const SizedBox(width: 8),
  //                           Text(
  //                             'Discover Funds',
  //                             style: AppTextStyles.bodyMediumBold().copyWith(
  //                               color: Colors.white,
  //                               fontSize: 16,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             const SizedBox(height: 56),

  //             // 2. --- RECENTLY VIEWED SECTION ---
  //             Obx(() {
  //               final recentFunds =
  //                   Get.find<MutualFundController>().recentlyViewedFunds;

  //               if (recentFunds.isEmpty) return const SizedBox.shrink();

  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Modern Section Heading with Accent Bar
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           width: 4,
  //                           height: 20,
  //                           decoration: BoxDecoration(
  //                             color: Ucolors.primary,
  //                             borderRadius: BorderRadius.circular(4),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 8),
  //                         const Text(
  //                           "Recently Viewed",
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w700,
  //                             letterSpacing: -0.5, // Tighter, modern tracking
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),

  //                   // Horizontal Scrollable List
  //                   SizedBox(
  //                     height: 100,
  //                     child: ListView.separated(
  //                       padding: const EdgeInsets.symmetric(horizontal: 24),
  //                       clipBehavior: Clip.none,
  //                       physics: const BouncingScrollPhysics(),
  //                       scrollDirection: Axis.horizontal,
  //                       itemCount: recentFunds.length,
  //                       separatorBuilder: (context, index) =>
  //                           const SizedBox(width: 16),
  //                       itemBuilder: (context, index) {
  //                         final fund = recentFunds[index];
  //                         final img =
  //                             "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
  //                         final name = fund.baseSchemeName ?? 'Unknown Name';
  //                         final threeyear = fund.returnsEntity?.threeYear ?? '';
  //                         final schemeCode = fund.schemeCode.toString();

  //                         return SizedBox(
  //                           width:
  //                               Get.width *
  //                               0.45, // Slightly wider for breathing room
  //                           child: PopularFundCard(
  //                             onTap: () {
  //                               Get.find<MutualFundController>()
  //                                   .addToLocalRecentlyViewed(fund);
  //                               Get.toNamed(
  //                                 AppRoutes.funddetails,
  //                                 arguments: {
  //                                   'scheme': name,
  //                                   'imgUrl': img,
  //                                   'scheme_code': schemeCode,
  //                                 },
  //                               );
  //                             },
  //                             isNetwork: true,
  //                             imgPath: img,
  //                             name: name,
  //                             threeYear: threeyear,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),

  //                   const SizedBox(height: 40),
  //                 ],
  //               );
  //             }),
  //           ],
  //         ),
  //       );
  //     }

  //     return ListView.builder(
  //       shrinkWrap: true, // Needed for Web nested scroll
  //       physics: kIsWeb
  //           ? const NeverScrollableScrollPhysics()
  //           : null, // Let parent handle scroll
  //       itemCount: wishlistItems.length,
  //       itemBuilder: (context, index) {
  //         final item = wishlistItems[index];
  //         return MutualFundCard1(
  //           isDelete: true,
  //           containercolor: const Color(0xffFEF0F0),
  //           entity: item,
  //         );
  //       },
  //     );
  //   });
  // }
}

// =========================================
// 💳 MUTUAL FUND CARD COMPONENT
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
    final bool isWeb =
        MediaQuery.of(context).size.width > 800; // 🚀 Web check for routing

    // Extract Basic Info
    final String displaySchemeName = isWishlistType
        ? (entity as WishlistDataEntity).schemeName ?? 'Unknown Fund'
        : (entity as MutualFundListEntity).baseSchemeName ?? 'Unknown Fund';

    final String displaySchemeCode = isWishlistType
        ? (entity as WishlistDataEntity).schemeCode ?? ''
        : (entity as MutualFundListEntity).schemeCode?.toString() ?? '';

    final String displayRiskLevel = entity.riskLevel ?? 'Moderate';

    final String displayImgUrl = isWishlistType
        ? "${Appurl.baseUrl}${(entity as WishlistDataEntity).amcLogo ?? ''}"
        : "${Appurl.baseUrl}${(entity as MutualFundListEntity).amc?.amcLogoUrl ?? ''}";

    // Extract Returns
    final String r1Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.oneYear ?? "0.00"
        : (entity as MutualFundListEntity).returnsEntity?.oneYear ?? "0.00";
    final String r3Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.threeYear ?? "0.00"
        : (entity as MutualFundListEntity).returnsEntity?.threeYear ?? "0.00";
    final String r5Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.fiveYear ?? "0.00"
        : (entity as MutualFundListEntity).returnsEntity?.fiveYear ?? "0.00";
    final String r10Y = isWishlistType
        ? (entity as WishlistDataEntity).returns?.tenYear ?? "0.00"
        : (entity as MutualFundListEntity).returnsEntity?.tenYear ?? "0.00";

    return GestureDetector(
      onTap: () {
        // 🚀 FIX: Web Nested Routing Handling
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
          mutualFundController.addToLocalRecentlyViewed(
            MutualFundListEntity(
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
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16), // Slightly padded for better look
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ), // Added border for crisp look
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.04), // Lighter shadow
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

                // Delete Action
                Obx(() {
                  final String currentId = isWishlistType
                      ? (entity as WishlistDataEntity).wishlistId.toString()
                      : "";
                  bool isThisItemDeleting =
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

                // Add to Cart Action
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
                          : "";
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
                    "Trailing Return",
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
              // Returns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ReturnItem(
                    isNegative: double.parse(r1Y) < 0,
                    title: '1Y',
                    value: '$r1Y%',
                  ),
                  _ReturnItem(
                    isNegative: double.parse(r3Y) < 0,
                    title: '3Y',
                    value: '$r3Y%',
                  ),
                  _ReturnItem(
                    isNegative: double.parse(r5Y) < 0,
                    title: '5Y',
                    value: '$r5Y%',
                  ),
                  _ReturnItem(
                    isNegative: double.parse(r10Y) < 0,
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
