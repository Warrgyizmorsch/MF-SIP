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
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/wishlist/domain/entity/wishlist_entity.dart';
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';

import '../../../explore/presentation/pages/explore.dart';

class WatchlistPage extends StatelessWidget {
  WatchlistPage({super.key});

  final MutualFundController controller = Get.find();

  final WishlistController controllerr = Get.find<WishlistController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(
        actionsPadding: 15,
        title: 'Wishlist',
        action: [
          Obx(
            () => Stack(
              children: [
                CompactIcon(
                  icon: Iconsax.shopping_cart,
                  onPressed: () {
                    Get.find<CartController>().filterGoalId.value = null;
                    Get.toNamed(AppRoutes.cart);
                    // cartController.fetchCart();
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
                        style: UTextStyles.buttonText.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controllerr.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Ucolors.primary),
          );
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controllerr.fetchWishlist(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        final wishlistItems =
            controllerr.wishlistResponseEntity.value?.data ?? [];
        if (wishlistItems.isEmpty) {
          // return const Center(child: Text("No mutual funds in your wishlist"));
          return Center(
            child: AnimatedEmptyState(
              title: 'Empty Wishlist',
              message: 'There is no fund in your wishlist',
              icon: Icons.favorite_border,
            ),
          );
        }

        return ListView.builder(
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            final item = wishlistItems[index];
            return MutualFundCard1(
              isDelete: true,
              containercolor: Color(0xffFEF0F0),
              entity: item,
            );
          },
        );
      }),
    );
  }
}

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
    final String r1M = isWishlistType
        ? "0.00"
        : (entity as MutualFundListEntity).returnsEntity?.oneMonth ?? "0.00";
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
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
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

                !isDelete
                    ? PopupMenuButton<FundMenuAction>(
                        color: Ucolors.light,
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        offset: const Offset(0, 40),
                        onSelected: (value) async {
                          switch (value) {
                            case FundMenuAction.addToCart:
                              await controller.addToCart(
                                displaySchemeCode,
                                displaySchemeName,
                                !isWishlistType
                                    ? (entity as MutualFundListEntity)
                                              .minSipAmount ??
                                          0
                                    : 0,
                                null,
                              );
                              await controller.fetchCart();
                              break;
                            case FundMenuAction.buySIP:
                            case FundMenuAction.buyLumpsum:
                              // Handle accordingly
                              break;
                            case FundMenuAction.addToWatchlist:
                              await wishlistController.addToWishList(
                                displaySchemeCode,
                                displaySchemeName,
                              );
                              break;
                            case FundMenuAction.fundDetails:
                              Get.toNamed(
                                AppRoutes.funddetails,
                                arguments: {
                                  'scheme': displaySchemeName,
                                  'imgUrl': displayImgUrl,
                                  'scheme_code': displaySchemeCode,
                                },
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          buildFundMenuItem(
                            icon: Iconsax.card_send,
                            text: 'Add to cart',
                            value: FundMenuAction.addToCart,
                          ),
                          buildFundMenuItem(
                            icon: Iconsax.edit_2,
                            text: 'Buy SIP',
                            value: FundMenuAction.buySIP,
                          ),
                          buildFundMenuItem(
                            icon: Iconsax.pause,
                            text: 'Buy Lumpsum',
                            value: FundMenuAction.buyLumpsum,
                          ),
                          buildFundMenuItem(
                            icon: Iconsax.add,
                            text: 'Add to watchlist',
                            value: FundMenuAction.addToWatchlist,
                          ),
                          buildFundMenuItem(
                            icon: Iconsax.receipt,
                            text: 'Fund Details',
                            value: FundMenuAction.fundDetails,
                          ),
                        ],
                      )
                    : Obx(() {
                        // Get the ID for this specific card
                        final String currentId = isWishlistType
                            ? (entity as WishlistDataEntity).wishlistId
                                  .toString()
                            : "";
                        bool isThisItemDeleting =
                            wishlistController.deletingItemId.value ==
                            currentId;
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
                SizedBox(width: 5),
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
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Trailing Return -------------------------------------------------------------------------------------------------------',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Ucolors.borderside,
                fontSize: 10,
                height: 0,
              ),
            ),
            const SizedBox(height: 5),
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
        Text(title, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: isNegative ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
