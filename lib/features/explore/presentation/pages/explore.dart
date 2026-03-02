// import 'dart:developer';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
// import 'package:my_sip/common/widget/images/custom_cached_image.dart';
// import 'package:my_sip/common/widget/shimmer/shimmer.dart';
// import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
// import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
// import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
// import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
// import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
//
// import '../../../dashboard/presentation/pages/dashboard.dart';
//
// class ExploreScreen extends StatefulWidget {
//   const ExploreScreen({super.key});
//
//   @override
//   State<ExploreScreen> createState() => _ExploreScreenState();
// }
//
// class _ExploreScreenState extends State<ExploreScreen> {
//   final items = [
//     'Popularity',
//     '1Y Returns',
//     '3Y Returns',
//     '5Y Returns',
//     'Rating',
//   ];
//
//   final TextEditingController sort = TextEditingController();
//   final MutualFundController controller = Get.find();
//   final CartController cartController = Get.find();
//
//   late FocusNode _searchFocus;
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchFocus = FocusNode();
//
//     _searchFocus.addListener(() {
//       setState(() {});
//     });
//
//     _scrollController = ScrollController();
//
//     _scrollController.addListener(() {
//       // Check if we are at max scroll extent (bottom)
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         // Buffer of 200px
//
//         // Trigger Load More
//         // controller.fetchMutualFund(isLoadMore: true);
//         controller.fetchData(isLoadMore: true);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchFocus.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Ucolors.borderColor,
//       body: CustomScrollView(
//         controller: _scrollController,
//         slivers: [
//           //////----------Appbar---------------///
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             pinned: true,
//
//             flexibleSpace: CustomAppBarNormal(
//               title: 'All Mutual Funds',
//               backgroundColor: Ucolors.light,
//               actionsPadding: 15,
//               action: [
//                 Obx(
//                   () => Stack(
//                     children: [
//                       CompactIcon(
//                         icon: Iconsax.shopping_cart,
//                         onPressed: () => Get.toNamed(AppRoutes.cart),
//                         iconColor: Ucolors.dark,
//                       ),
//                       if (cartController.itemsCount > 0)
//                         Positioned(
//                           right: 0,
//                           top: -5,
//
//                           // bottom: 0,
//                           child: Container(
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: Ucolors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Text(
//                               cartController.itemsCount.toString(),
//
//                               style: UTextStyles.buttonText.copyWith(
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 CompactIcon(
//                   icon: Iconsax.archive_tick,
//                   onPressed: () => Get.toNamed(AppRoutes.watchlist),
//                   iconColor: Ucolors.dark,
//                 ),
//               ],
//             ),
//           ),
//
//           ////----------TabBar-------------///
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Ucolors.borderColor),
//                       // borderRadius: BorderRadius.circular(2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: CompactIcon(
//                       icon: Icons.tune,
//                       // onPressed: () => Get.toNamed(AppRoutes.filterpage),
//                       onPressed: () async {
//                         final result = await Get.toNamed(AppRoutes.filterpage);
//
//                         // if (result != null && result is List<int>) {
//                         //   await controller.fetchFundsByAmc(result);
//                         //   // await controller.fetchFundsByCategories(
//                         //   //   result.toString(),
//                         //   // );
//                         // }
//                         if (result != null && result is Map<String, dynamic>) {
//                           // await controller.fetchFunds(result);
//                           // await Get.find<MutualFundController>().fetchFunds(
//                           //   result,
//                           // );
//                           controller.applyFilters(result);
//                         }
//                       },
//                     ),
//                   ),
//
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     height: 30, // controls line height
//                     width: 1, // controls thickness
//                     color: Ucolors.borderside,
//                   ),
//
//                   Expanded(
//                     child: SizedBox(
//                       height: 40,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: SearchBar(
//                               onTapOutside: (event) => _searchFocus.unfocus(),
//                               focusNode: _searchFocus,
//                               backgroundColor: MaterialStateProperty.all(
//                                 Colors.white,
//                               ),
//                               leading: Icon(Icons.search),
//                               hintText: 'Search',
//                               onChanged: (value) {
//                                 // controller.searchFundFn(value);
//                                 // controller.searchFundApi(value);
//                                 controller.onSearchQueryChanged(value);
//                               },
//                             ),
//                           ),
//                           Gap(2),
//                           !_searchFocus.hasFocus
//                               ? InkWell(
//                                   onTap: () => showSelectionBottomSheet(
//                                     // imgLogo:,
//                                     selectedValue: sort.text,
//                                     search: false,
//                                     context: context,
//
//                                     title: 'Sort by ${sort.text}',
//                                     items: items,
//                                     controller: sort,
//                                   ),
//                                   child: _FilterChip(
//                                     label:
//                                         // '${sort.text.isEmpty ? 'Sort by ' : sort.text}',
//                                         'Sort by',
//                                     icon: Icons.filter_list_sharp,
//                                   ),
//                                 )
//                               : SizedBox.shrink(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           Obx(
//             () => SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       controller.selectedFundCount.value == 0
//                           ? '${controller.mutualfund.length} funds'
//                           : '${controller.selectedFundCount}  funds',
//                       style: UTextStyles.small,
//                     ),
//                     Text('‹› 3 Year Returns', style: UTextStyles.small),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Obx(() {
//           //   if (controller.isLoading.value) {
//           //     return const SliverFillRemaining(
//           //       hasScrollBody: false,
//           //       child: Center(
//           //         child: CircularProgressIndicator(color: Ucolors.primary),
//           //       ),
//           //     );
//           //   }
//           //   if (controller.mutualfund.isEmpty) {
//           //     return const SliverFillRemaining(
//           //       hasScrollBody: false,
//           //       child: Center(child: Text("No mutual funds found")),
//           //     );
//           //   }
//
//           //   return
//           //   ///  MUTUAL FUND LIST
//           //   SliverList(
//           //     delegate: SliverChildBuilderDelegate((context, index) {
//           //       final fund = controller.searchFund[index];
//           //       // print()
//
//           //       return MutualFundCard(entity: fund);
//           //     }, childCount: controller.searchFund.length),
//           //   );
//           // }),
//           // Obx(() {
//           //   // Initial Loading
//           //   if (controller.isLoading.value) {
//           //     return const SliverFillRemaining(
//           //       child: Center(child: CircularProgressIndicator()),
//           //     );
//           //   }
//
//           //   return SliverList(
//           //     delegate: SliverChildBuilderDelegate(
//           //       (context, index) {
//           //         // If we are at the last item AND loading more, show Spinner
//           //         if (index == controller.searchFund.length) {
//           //           if (controller.isMoreLoading.value) {
//           //             return const Padding(
//           //               padding: EdgeInsets.all(20),
//           //               child: Center(child: CircularProgressIndicator()),
//           //             );
//           //           } else {
//           //             return const SizedBox.shrink(); // Hide if not loading
//           //           }
//           //         }
//
//           //         // Normal Item
//           //         final fund = controller.searchFund[index];
//           //         return MutualFundCard(entity: fund);
//           //       },
//           //       // Add +1 to length for the Loader widget at the bottom
//           //       childCount: controller.searchFund.length + 1,
//           //     ),
//           //   );
//           // }),
//           Obx(() {
//             if (controller.isLoading.value) {
//               return const SliverFillRemaining(
//                 hasScrollBody: false,
//                 child: Center(
//                   child: CircularProgressIndicator(color: Ucolors.primary),
//                 ),
//               );
//             }
//
//             // Initial Full Screen Loader (First Load Only)
//             if (controller.isLoading.value && controller.searchFund.isEmpty) {
//               return const SliverFillRemaining(
//                 hasScrollBody: false,
//                 child: Center(
//                   child: CircularProgressIndicator(color: Ucolors.primary),
//                 ),
//               );
//             }
//             // Empty State
//             if (controller.searchFund.isEmpty) {
//               return const SliverFillRemaining(
//                 hasScrollBody: false,
//                 child: Center(child: Text("No mutual funds found")),
//               );
//             }
//
//             return SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   final fund = controller.searchFund[index];
//                   return MutualFundCard(entity: fund);
//                 },
//                 // Exact length (No +1 needed here anymore)
//                 childCount: controller.searchFund.length,
//               ),
//             );
//           }),
//           Obx(() {
//             if (controller.isMoreLoading.value) {
//               return const SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 24),
//                   child: Center(
//                     child: SizedBox(
//                       height: 24,
//                       width: 24,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                         color: Ucolors.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//             // Return empty space if not loading
//             return const SliverToBoxAdapter(child: SizedBox.shrink());
//           }),
//           const SliverToBoxAdapter(child: SizedBox(height: 20)),
//         ],
//       ),
//     );
//   }
// }
//
// class MutualFundCard extends StatelessWidget {
//   MutualFundCard({
//     super.key,
//     this.isDelete = false,
//     this.containercolor,
//     required this.entity,
//   });
//
//   final bool isDelete;
//   final Color? containercolor;
//   final MutualFundListEntity entity;
//   final CartController controller = Get.find<CartController>();
//   final MutualFundController mutualFundController =
//       Get.find<MutualFundController>();
//
//   @override
//   Widget build(BuildContext context) {
//     // createLog("ffff${Appurl.baseUrl}${entity.amc?.amcLogoUrl}");
//     return GestureDetector(
//       // onTap: () => Get.to(() => FundDeatailsScreen()),
//       onTap: () {
//         Get.toNamed(
//           AppRoutes.funddetails,
//           arguments: {
//             'scheme': entity.baseSchemeName,
//             'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
//             'scheme_code': entity.schemeCode.toString(),
//           },
//         );
//       },
//
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Top Row
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   // radius: 18,
//                   maxRadius: 20,
//                   backgroundColor: Colors.transparent,
//                   // backgroundImage: AssetImage(UImages.sbi),
//                   // backgroundImage:  NetworkImage(entity!.amc!.amcLogoUrl!),
//                   child: ClipOval(
//                     child: CustomCachedImage(
//                       imageUrl:
//                           "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
//
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         // 'Nippon India Large Cap Fund - Growth Plan',
//                         entity.baseSchemeName ?? 'Unknown Fund',
//                         // entity.baseSchemeName.toString(),
//                         style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xff383838),
//                         ),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Risk:',
//                               style: Theme.of(context).textTheme.labelSmall!
//                                   .copyWith(fontWeight: FontWeight.normal),
//                             ),
//                             TextSpan(
//                               text: 'Very High',
//                               style: Theme.of(context).textTheme.labelMedium!
//                                   .copyWith(color: Ucolors.red),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 !isDelete
//                     ? PopupMenuButton<PortfolioMenuAction>(
//                         color: Ucolors.light,
//                         icon: const Icon(Icons.more_vert, color: Colors.grey),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         // elevation: 6,
//                         offset: const Offset(0, 40),
//                         onSelected: (value) {
//                           switch (value) {
//                             //Add to cart
//                             case PortfolioMenuAction.topUp:
//                               controller.addItem(
//                                 CartItem(
//                                   fundId: entity.amc?.id?.toString() ?? '',
//                                   fundName: entity.baseSchemeName ?? '',
//                                   logoUrl: entity.amc?.amcLogoUrl ?? '',
//                                 ),
//                               );
//                               Get.snackbar(
//                                 margin: EdgeInsets.symmetric(
//                                   vertical: 15,
//                                   horizontal: 15,
//                                 ),
//                                 colorText: Ucolors.light,
//                                 'Add to cart',
//                                 entity.baseSchemeName.toString(),
//                                 snackPosition: SnackPosition.BOTTOM,
//                                 backgroundColor: Ucolors.primary,
//                               );
//
//                               // log('top up');
//                               break;
//
//                             ///Buy sip
//                             case PortfolioMenuAction.modify:
//                               controller.addItem(
//                                 CartItem(
//                                   fundId: entity.amc?.id?.toString() ?? '',
//                                   fundName: entity.baseSchemeName ?? '',
//                                   logoUrl: entity.amc?.amcLogoUrl ?? '',
//                                 ),
//                               );
//                               Get.toNamed(AppRoutes.cart);
//
//                               break;
//
//                             //buy lumsum
//                             case PortfolioMenuAction.pause:
//                               controller.addItem(
//                                 CartItem(
//                                   fundId: entity.amc?.id?.toString() ?? '',
//                                   fundName: entity.baseSchemeName ?? '',
//                                   logoUrl: entity.amc?.amcLogoUrl ?? '',
//                                 ),
//                               );
//                               Get.toNamed(AppRoutes.cart);
//
//                               break;
//                             //add to wishlist
//                             case PortfolioMenuAction.cancel:
//                               break;
//                             //fund detailss
//                             case PortfolioMenuAction.redemption:
//                               Get.toNamed(
//                                 AppRoutes.funddetails,
//                                 arguments: {
//                                   'scheme': entity.baseSchemeName,
//                                   // Fixed string interpolation null check
//                                   'imgUrl':
//                                       "${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}",
//                                 },
//                               );
//
//                               // log('object');
//
//                               break;
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           buildMenuItem(
//                             icon: Iconsax.card_send,
//                             text: 'Add to cart',
//                             value: PortfolioMenuAction.topUp,
//                           ),
//                           buildMenuItem(
//                             icon: Iconsax.edit_2,
//                             text: 'Buy SIP',
//                             value: PortfolioMenuAction.modify,
//                           ),
//                           buildMenuItem(
//                             icon: Iconsax.pause,
//                             text: 'Buy Lumpsum',
//                             value: PortfolioMenuAction.pause,
//                           ),
//                           buildMenuItem(
//                             icon: Iconsax.add,
//                             text: 'Add to watchlist',
//                             value: PortfolioMenuAction.cancel,
//                           ),
//                           buildMenuItem(
//                             icon: Iconsax.receipt,
//                             text: 'Fund Details',
//                             value: PortfolioMenuAction.redemption,
//                           ),
//                         ],
//                       )
//                     : Deleteiconwithcontainer(containercolor: containercolor),
//                 // const Icon(Icons.more_vert),
//               ],
//             ),
//
//             // const SizedBox(height: 8),
//
//             // RichText(
//             //   text: TextSpan(
//             //     children: [
//             //       TextSpan(
//             //         text: 'Risk:',
//             //         style: Theme.of(context).textTheme.labelSmall!.copyWith(),
//             //       ),
//             //       TextSpan(
//             //         text: 'Very High',
//             //         style: Theme.of(
//             //           context,
//             //         ).textTheme.labelMedium!.copyWith(color: Ucolors.red),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             /// Risk
//             // const Text(
//             //   'Risk: Very High',
//             //   style: TextStyle(fontSize: 13, color: Colors.red),
//             // ),
//             const SizedBox(height: 5),
//             // const Divider(height: 0),
//             Text(
//               maxLines: 1,
//               'Trailing Return -------------------------------------------------------------------------------------------------------',
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 color: Ucolors.borderside,
//                 fontSize: 10,
//                 height: 0,
//               ),
//             ),
//
//             const SizedBox(height: 5),
//
//             /// Returns Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: const [
//                 _ReturnItem(title: '1W', value: '-0.15%', isNegative: true),
//                 _ReturnItem(title: '1Y', value: '5.20%'),
//                 _ReturnItem(title: '3Y', value: '18.42%'),
//                 _ReturnItem(title: '5Y', value: '20.89%'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ReturnItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isNegative;
//
//   const _ReturnItem({
//     required this.title,
//     required this.value,
//     this.isNegative = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(title, style: Theme.of(context).textTheme.labelMedium!.copyWith()),
//         const SizedBox(height: 4),
//         Text(
//           value,
//
//           style: Theme.of(context).textTheme.labelMedium!.copyWith(
//             color: isNegative ? Colors.red : Colors.green,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _FilterChip extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final bool isSelected;
//
//   const _FilterChip({required this.label, this.icon, this.isSelected = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         margin: EdgeInsets.only(left: 5),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected ? Ucolors.textFormEnabled : Colors.grey.shade300,
//           ),
//         ),
//         child: Row(
//           children: [
//             if (icon != null) ...[
//               Icon(icon, size: 16),
//               const SizedBox(width: 6),
//             ],
//             Text(
//               label,
//               style: Theme.of(
//                 context,
//               ).textTheme.labelSmall!.copyWith(fontSize: 10),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/empty_filled.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart'; // Ensure this import exists for Deleteiconwithcontainer
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum FundMenuAction {
  addToCart,
  buySIP,
  buyLumpsum,
  addToWatchlist,
  fundDetails,
}

PopupMenuItem<FundMenuAction> buildFundMenuItem({
  required IconData icon,
  required String text,
  required FundMenuAction value,
}) {
  return PopupMenuItem<FundMenuAction>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

// --- ANIMATION WRAPPER FOR WEB ROWS ---
class WebHoverRow extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final VoidCallback? onTap;

  const WebHoverRow({super.key, required this.builder, this.onTap});

  @override
  State<WebHoverRow> createState() => _WebHoverRowState();
}

class _WebHoverRowState extends State<WebHoverRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isHovered
                ? Ucolors.primary.withOpacity(0.04)
                : Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: widget.builder(_isHovered),
        ),
      ),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final items = ['1Y Returns', '3Y Returns', '5Y Returns'];

  final TextEditingController sort = TextEditingController();
  final MutualFundController controller = Get.find();
  final CartController cartController = Get.find();

  late FocusNode _searchFocus;
  late ScrollController _scrollController;

  // Inside _ExploreScreenState
  final Map<String, int> sortYearMapping = {
    '1Y Returns': 1,
    '3Y Returns': 3,
    '5Y Returns': 5,
  };

  // Use this for the bottom sheet items
  late List<String> sortItems;

  @override
  void initState() {
    super.initState();
    sortItems = sortYearMapping.keys
        .toList(); // ['1Y Returns', '3Y Returns', '5Y Returns']
    _searchFocus = FocusNode();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.fetchData(isLoadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      body: isDesktop
          ? _WebExploreLayout(
              scrollController: _scrollController,
              searchFocus: _searchFocus,
              sortController: sort,
              sortItems: items,
            )
          : _MobileExploreLayout(
              scrollController: _scrollController,
              searchFocus: _searchFocus,
              sortController: sort,
              sortItems: items,
            ),
    );
  }
}

// ==========================================
// 💻 WEB LAYOUT (Professional Table View)
// ==========================================
class _WebExploreLayout extends StatelessWidget {
  final ScrollController scrollController;
  final FocusNode searchFocus;
  final TextEditingController sortController;
  final List<String> sortItems;

  const _WebExploreLayout({
    required this.scrollController,
    required this.searchFocus,
    required this.sortController,
    required this.sortItems,
  });

  @override
  Widget build(BuildContext context) {
    final MutualFundController controller = Get.find();
    final CartController cartController = Get.find();

    return Column(
      children: [
        // 1. COMPACT DASHBOARD HEADER
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Text(
                "Explore Funds",
                style: UTextStyles.heading2.copyWith(fontSize: 20),
              ),
              const Spacer(),

              // Search
              SizedBox(
                width: 300,
                height: 40,
                child: SearchBar(
                  focusNode: searchFocus,
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFFF0F2F5),
                  ),
                  leading: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.grey,
                  ),
                  hintText: 'Search funds...',
                  onChanged: (value) => controller.onSearchQueryChanged(value),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const Gap(16),

              // Filter & Sort
              OutlinedButton.icon(
                onPressed: () async {
                  final result = await Get.toNamed(AppRoutes.filterpage);
                  if (result != null && result is Map<String, dynamic>) {
                    controller.applyFilters(result);
                  }
                },
                icon: Icon(Icons.tune, size: 16, color: Ucolors.primary),
                label: Text("Filters", style: UTextStyles.medium),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const Gap(10),

              // Cart
              Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () => Get.toNamed(AppRoutes.cart),
                      icon: const Icon(Iconsax.shopping_cart),
                      hoverColor: Ucolors.primary.withOpacity(0.1),
                    ),
                    if (cartController.itemsCount1 > 0)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Ucolors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartController.itemsCount1.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2. MAIN CONTENT (CENTERED TABLE)
        Expanded(
          child: Center(
            child: MaxWidthBox(
              maxWidth: 1100, // Constrain width for readability
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Count & Sort
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            "${controller.selectedFundCount.value == 0 ? controller.mutualfund.length : controller.selectedFundCount} funds found",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => showSelectionBottomSheet(
                            selectedValue: sortController.text,
                            search: false,
                            context: context,
                            title: 'Sort by',
                            items: sortItems,
                            controller: sortController,
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "Sort by: Popularity",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Icon(Icons.keyboard_arrow_down, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),

                    // TABLE HEADER
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EBF1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Fund Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Risk",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "1Y",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "3Y",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "5Y",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Action",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TABLE LIST
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value &&
                            controller.searchFund.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.searchFund.isEmpty) {
                          return const Center(child: Text("No funds found."));
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount:
                              controller.searchFund.length +
                              (controller.isMoreLoading.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.searchFund.length) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final fund = controller.searchFund[index];
                            return WebFundTableRow(entity: fund);
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 📊 WEB COMPONENT: Table Row
// ==========================================
class WebFundTableRow extends StatelessWidget {
  final MutualFundListEntity entity;
  const WebFundTableRow({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return WebHoverRow(
      onTap: () {
        Get.toNamed(
          AppRoutes.funddetails,
          arguments: {
            'scheme': entity.baseSchemeName,
            'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
            'scheme_code': entity.schemeCode.toString(),
          },
        );
      },
      builder: (isHovered) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // 1. FUND NAME & LOGO
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomCachedImage(
                      imageUrl:
                          "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entity.baseSchemeName ?? "Unknown Fund",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Equity • Growth",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. RISK BADGE
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Ucolors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Ucolors.red.withOpacity(0.2)),
                    ),
                    child: Text(
                      "Very High",
                      style: TextStyle(
                        color: Ucolors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. RETURNS COLUMNS
            Expanded(
              flex: 1,
              child: Text(
                "15.2%",
                style: TextStyle(
                  color: Ucolors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "18.5%",
                style: TextStyle(
                  color: Ucolors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "22.1%",
                style: TextStyle(
                  color: Ucolors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 4. ACTION BUTTON
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isHovered ? 1.0 : 0.7,
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addItem(
                          CartItem(
                            fundId: entity.amc?.id?.toString() ?? '',
                            fundName: entity.baseSchemeName ?? '',
                            logoUrl: entity.amc?.amcLogoUrl ?? '',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Invest",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
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

// ==========================================
// 📱 MOBILE LAYOUT (Original Logic Preserved)
// ==========================================
class _MobileExploreLayout extends StatelessWidget {
  final ScrollController scrollController;
  final FocusNode searchFocus;
  final TextEditingController sortController;
  final List<String> sortItems;

  const _MobileExploreLayout({
    required this.scrollController,
    required this.searchFocus,
    required this.sortController,
    required this.sortItems,
  });

  @override
  Widget build(BuildContext context) {
    final MutualFundController controller = Get.find();
    final CartController cartController = Get.find();
    return RefreshIndicator(
      onRefresh: () => controller.handleRefresh(),
      color: Ucolors.primary, // Use your app's primary theme color
      backgroundColor: Colors.white,
      displacement: CircularProgressIndicator.strokeAlignCenter,

      // displacement: 100,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            flexibleSpace: CustomAppBarNormal(
              backIcon: false,
              title: 'All Mutual Funds',
              backgroundColor: Ucolors.light,
              actionsPadding: 15,
              action: [
                // Obx(() {
                //   final count = cartController.itemsCount1;
                //   return Stack(
                //     children: [
                //       CompactIcon(
                //         icon: Iconsax.shopping_cart,
                //         onPressed: () => Get.toNamed(AppRoutes.cart),
                //         iconColor: Ucolors.dark,
                //       ),
                //       if (count > 0)
                //         Positioned(
                //           right: 0,
                //           top: -5,
                //           child: Container(
                //             padding: const EdgeInsets.all(5),
                //             decoration: const BoxDecoration(
                //               color: Ucolors.red,
                //               shape: BoxShape.circle,
                //             ),
                //             child: Text(
                //               count.toString(),
                //               style: UTextStyles.buttonText.copyWith(
                //                 fontSize: 10,
                //               ),
                //             ),
                //           ),
                //         ),
                //     ],
                //   );
                // }),'
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
                              style: UTextStyles.buttonText.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                CompactIcon(
                  icon: Iconsax.archive_tick,
                  onPressed: () => Get.toNamed(AppRoutes.watchlist),
                  iconColor: Ucolors.dark,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Ucolors.borderColor),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: CompactIcon(
                  //     icon: Icons.tune,
                  //     onPressed: () async {
                  //       final result = await Get.toNamed(AppRoutes.filterpage);
                  //       if (result != null && result is Map<String, dynamic>) {
                  //         controller.applyFilters(result);
                  //       }
                  //     },
                  //   ),
                  // ),
                  // Obx(
                  //   () => Badge(
                  //     isLabelVisible:
                  //         Get.find<FundhouseController>().isFilterActive,
                  //     backgroundColor: Colors.redAccent,
                  //     alignment: const Alignment(
                  //       0.6,
                  //       -0.6,
                  //     ), // Adjusts dot position
                  //     child: Container(
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Ucolors.borderColor),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: CompactIcon(
                  //         icon: Icons.tune,
                  //         onPressed: () async {
                  //           final result = await Get.toNamed(
                  //             AppRoutes.filterpage,
                  //           );
                  //           if (result != null &&
                  //               result is Map<String, dynamic>) {
                  //             controller.applyFilters(result);
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Obx(() {
                    final fundController = Get.find<FundhouseController>();
                    final int filterCount = fundController.activeFilterCount;

                    return Badge(
                      // Only show the badge if count > 0
                      isLabelVisible: filterCount > 0,
                      backgroundColor: Ucolors.primary, // Or Colors.redAccent
                      label: Text(
                        '$filterCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: const Alignment(
                        0.7,
                        -0.7,
                      ), // Adjusts position for text
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Ucolors.borderColor),
                          shape: BoxShape.circle,
                        ),
                        child: CompactIcon(
                          icon: Icons.tune,
                          onPressed: () async {
                            final result = await Get.toNamed(
                              AppRoutes.filterpage,
                            );
                            if (result != null &&
                                result is Map<String, dynamic>) {
                              controller.applyFilters(result);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 30,
                    width: 1,
                    color: Ucolors.borderside,
                  ),
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 40,
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: SearchBar(
                  //             onTapOutside: (event) => searchFocus.unfocus(),
                  //             focusNode: searchFocus,
                  //             backgroundColor: MaterialStateProperty.all(
                  //               Colors.white,
                  //             ),
                  //             leading: const Icon(Icons.search),
                  //             hintText: 'Search',
                  //             onChanged: (value) =>
                  //                 controller.onSearchQueryChanged(value),
                  //           ),
                  //         ),
                  //         const Gap(2),
                  //         // !searchFocus.hasFocus
                  //         //     ? InkWell(
                  //         //         onTap: () => showSelectionBottomSheet(
                  //         //           selectedValue: sortController.text,
                  //         //           search: false,
                  //         //           context: context,
                  //         //           title: 'Sort by ${sortController.text}',
                  //         //           items: sortItems,
                  //         //           controller: sortController,
                  //         //         ),
                  //         //         child: const _FilterChip(
                  //         //           label: 'Sort by',
                  //         //           icon: Icons.filter_list_sharp,
                  //         //         ),
                  //         //       )
                  //         //     : const SizedBox.shrink(),
                  //         Obx(
                  //           () => InkWell(
                  //             onTap: () => controller.cycleGlobalSort(),
                  //             child: _FilterChip(
                  //               label: controller.currentSortLabel.value,
                  //               icon: Icons.sort,
                  //               // Visually highlight if a sort is active (not Popularity)
                  //               isSelected:
                  //                   controller.currentSortLabel.value !=
                  //                   "Popularity",
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Obx(() {
                        final bool isSearching =
                            controller.hasSearchFocus.value;

                        return Row(
                          children: [
                            // This Expanded child will take up all available space
                            Expanded(
                              child: SearchBar(
                                onTap: () => controller.setSearchFocus(true),
                                onTapOutside: (event) {
                                  searchFocus.unfocus();
                                  controller.setSearchFocus(false);
                                },
                                focusNode: searchFocus,
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                leading: const Icon(Icons.search),
                                hintText: 'Search',
                                onChanged: (value) =>
                                    controller.onSearchQueryChanged(value),
                                elevation: MaterialStateProperty.all(0),
                                side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                            ),

                            // The Sort Chip and its Gap only exist when NOT searching
                            if (!isSearching) ...[
                              const Gap(8),
                              InkWell(
                                onTap: () => controller.cycleGlobalSort(),
                                child: _FilterChip(
                                  label: controller.currentSortLabel.value,
                                  icon: Icons.sort,
                                  isSelected:
                                      controller.currentSortLabel.value !=
                                      "All Fund",
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Obx(
            () => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dynamic Fund Count
                    Text(
                      controller.selectedFundCount.value == 0
                          ? '${controller.mutualfund.length} funds'
                          : '${controller.selectedFundCount.value} funds',
                      style: UTextStyles.small,
                    ),

                    // CLICKABLE TOGGLE: Cycle through 1Y, 3Y, 5Y
                    // InkWell(
                    //   onTap: () => controller.cycleReturnYear(),
                    //   borderRadius: BorderRadius.circular(4),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 4,
                    //       vertical: 2,
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         const Icon(
                    //           Icons.swap_horiz,
                    //           size: 14,
                    //           color: Colors.black54,
                    //         ),
                    //         const SizedBox(width: 4),
                    //         Text(
                    //           controller.returnYearLabel,
                    //           style: UTextStyles.small.copyWith(
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.black87,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // Obx(
          //   () => SliverToBoxAdapter(
          //     child: Padding(
          //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             controller.selectedFundCount.value == 0
          //                 ? '${controller.mutualfund.length} funds'
          //                 : '${controller.selectedFundCount}  funds',
          //             style: UTextStyles.small,
          //           ),
          //           Text('‹› 3 Year Returns', style: UTextStyles.small),
          //           // Obx(() {
          //           //   final mutualController = Get.find<MutualFundController>();

          //           //   return Padding(
          //           //     padding: EdgeInsets.zero,
          //           //     // const EdgeInsets.symmetric(
          //           //     //   // horizontal: 16,
          //           //     //   // vertical: 8,
          //           //     // ),
          //           //     child:
          //           // Row(
          //           //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           //       children: [
          //           //         // Left Side: Fund Count
          //           //         // Text(
          //           //         //   '${mutualController.selectedFundCount.value} funds',
          //           //         //   style: const TextStyle(fontSize: 13, color: Colors.black54),
          //           //         // ),

          //           //         // Right Side: Clickable Returns Toggle
          //           //         // InkWell(
          //           //         //   onTap: () => mutualController.cycleReturnYear(),
          //           //         //   borderRadius: BorderRadius.circular(4),
          //           //         //   child: Padding(
          //           //         //     padding: const EdgeInsets.all(4.0),
          //           //         //     child: Row(
          //           //         //       mainAxisSize: MainAxisSize.min,
          //           //         //       children: [
          //           //         //         const Icon(
          //           //         //           Icons.swap_horiz,
          //           //         //           size: 14,
          //           //         //           color: Colors.black87,
          //           //         //         ),
          //           //         //         const SizedBox(width: 4),
          //           //         //         Text(
          //           //         //           mutualController.returnYearLabel,
          //           //         //           style: const TextStyle(
          //           //         //             fontSize: 13,
          //           //         //             fontWeight: FontWeight.w600,
          //           //         //             color: Colors.black87,
          //           //         //           ),
          //           //         //         ),
          //           //         //       ],
          //           //         //     ),
          //           //         //   ),
          //           //         // ),
          //           //       ],
          //           //     ),
          //           //   );
          //           // }),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Obx(() {
            if (controller.isLoading.value
            //  || controller.searchFund.isEmpty
            ) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: Ucolors.primary),
                ),
              );
            }
            if (controller.searchFund.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: AnimatedEmptyState(
                    title: 'NO fund',
                    message: 'No mutual funds foun',
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final fund = controller.searchFund[index];
                return MutualFundCard(entity: fund);
              }, childCount: controller.searchFund.length),
            );
          }),
          Obx(() {
            if (controller.isMoreLoading.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Ucolors.primary,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// ==========================================
// 📱 FULL MOBILE CARD RESTORED
// ==========================================
class MutualFundCard extends StatelessWidget {
  MutualFundCard({
    super.key,
    this.isDelete = false,
    this.containercolor,
    required this.entity,
  });

  final bool isDelete;
  final Color? containercolor;
  final MutualFundListEntity entity;
  final CartController controller = Get.find<CartController>();
  final MutualFundController mutualFundController =
      Get.find<MutualFundController>();

  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.funddetails,
          arguments: {
            'scheme': entity.baseSchemeName,
            'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
            'scheme_code': entity.schemeCode.toString(),
            'email': entity.amc?.email,
            'address': entity.amc?.address,
            'contact': entity.amc?.contact,
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
            /// Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CustomCachedImage(
                      imageUrl:
                          "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.baseSchemeName ?? 'Unknown Fund',
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
                              // text: entity.riskLevel,
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: entity.riskLevel,
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: getRiskMeter(entity.riskLevel).color,
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
                            // Add to cart
                            case FundMenuAction.addToCart:
                              await controller.addToCart(
                                entity.schemeCode ?? '',
                                entity.baseSchemeName ?? '',
                                entity.minSipAmount ?? 0,
                                null,
                              );
                              await controller.fetchCart();

                              // controller.addItem(
                              //   CartItem(
                              //     fundId: entity.amc?.id?.toString() ?? '',
                              //     fundName: entity.baseSchemeName ?? '',
                              //     logoUrl: entity.amc?.amcLogoUrl ?? '',
                              //   ),
                              // );
                              // Get.snackbar(
                              //   'Add to cart',
                              //   entity.baseSchemeName.toString(),
                              //   margin: const EdgeInsets.symmetric(
                              //     vertical: 15,
                              //     horizontal: 15,
                              //   ),
                              //   colorText: Ucolors.light,
                              //   snackPosition: SnackPosition.BOTTOM,
                              //   backgroundColor: Ucolors.primary,
                              // );
                              break;

                            case FundMenuAction.buySIP:
                              await controller.addToCart(
                                entity.schemeCode ?? '',
                                entity.baseSchemeName ?? '',
                                entity.minSipAmount ?? 0,
                                null,
                              );
                              await controller.fetchCart();

                              Get.toNamed(AppRoutes.cart);
                            case FundMenuAction.buyLumpsum:
                              await controller.addToCart(
                                entity.schemeCode ?? '',
                                entity.baseSchemeName ?? '',
                                entity.minSipAmount ?? 0,
                                null,
                                transType: 'lumpsum',
                              );
                              await controller.fetchCart();

                              Get.toNamed(AppRoutes.cart);
                              break;

                            case FundMenuAction.addToWatchlist:
                              await wishlistController.addToWishList(
                                entity.schemeCode.toString(),
                                entity.baseSchemeName.toString(),
                              );
                              break;
                            case FundMenuAction.fundDetails:
                              Get.toNamed(
                                AppRoutes.funddetails,
                                arguments: {
                                  'scheme': entity.baseSchemeName,
                                  'imgUrl':
                                      "${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}",
                                  'scheme_code': entity.schemeCode.toString(),
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
                            icon: Iconsax.pause, // Or Iconsax.convert_card
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
                    : Deleteiconwithcontainer(containercolor: containercolor),
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

            /// Returns Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ReturnItem(
                  isNegative: parseIntSafe(entity.returnsEntity?.oneMonth) < 0
                      ? true
                      : false,
                  title: '1M',
                  value: '${entity.returnsEntity?.oneMonth}%',
                  // isNegative: true,
                ),
                _ReturnItem(
                  isNegative: parseIntSafe(entity.returnsEntity?.oneYear) < 0
                      ? true
                      : false,
                  title: '1Y',
                  value: '${entity.returnsEntity?.oneYear}%',
                ),
                _ReturnItem(
                  isNegative: parseIntSafe(entity.returnsEntity?.threeYear) < 0
                      ? true
                      : false,
                  title: '3Y',
                  value: '${entity.returnsEntity?.threeYear}%',
                ),
                _ReturnItem(
                  isNegative: parseIntSafe(entity.returnsEntity?.fiveYear) < 0
                      ? true
                      : false,
                  title: '5Y',
                  value: '${entity.returnsEntity?.fiveYear}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ♻️ REUSABLE HELPERS
// ==========================================
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

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  const _FilterChip({required this.label, this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Ucolors.textFormEnabled : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
