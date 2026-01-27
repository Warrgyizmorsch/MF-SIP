import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';

import '../../../dashboard/presentation/pages/dashboard.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final items = [
    'Popularity',
    '1Y Returns',
    '3Y Returns',
    '5Y Returns',
    'Rating',
  ];

  final TextEditingController sort = TextEditingController();
  final MutualFundController controller = Get.find();
  final CartController cartController = Get.find();

  late FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchFocus = FocusNode();

    _searchFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Ucolors.borderColor,
      body: CustomScrollView(
        slivers: [
          //////----------Appbar---------------///
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            // expandedHeight: 80,

            // leadingWidth: 20,
            // expandedHeight: 200,
            flexibleSpace: CustomAppBarNormal(
              title: 'All Mutual Funds',
              backgroundColor: Ucolors.light,
              actionsPadding: 15,
              // backIcon: ,
              action: [
                Obx(
                  () => Stack(
                    children: [
                      CompactIcon(
                        icon: Iconsax.shopping_cart,
                        onPressed: () => Get.toNamed(AppRoutes.cart),
                        iconColor: Ucolors.dark,
                      ),
                      if (cartController.itemsCount > 0)
                        Positioned(
                          right: 0,
                          top: -5,

                          // bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Ucolors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cartController.itemsCount.toString(),

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

          ////----------TabBar-------------///
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Ucolors.borderColor),
                      // borderRadius: BorderRadius.circular(2),
                      shape: BoxShape.circle,
                    ),
                    child: CompactIcon(
                      icon: Icons.tune,
                      onPressed: () => Get.toNamed(AppRoutes.filterpage),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 30, // controls line height
                    width: 1, // controls thickness
                    color: Ucolors.borderside,
                  ),

                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchBar(
                              onTapOutside: (event) => _searchFocus.unfocus(),
                              focusNode: _searchFocus,
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              leading: Icon(Icons.search),
                              hintText: 'Search',
                            ),
                          ),
                          Gap(2),
                          !_searchFocus.hasFocus
                              ? InkWell(
                                  onTap: () => showSelectionBottomSheet(
                                    // imgLogo:,
                                    selectedValue: sort.text,
                                    search: false,
                                    context: context,

                                    title: 'Sort by ${sort.text}',
                                    items: items,
                                    controller: sort,
                                  ),
                                  child: _FilterChip(
                                    label:
                                        // '${sort.text.isEmpty ? 'Sort by ' : sort.text}',
                                        'Sort by',
                                    icon: Icons.filter_list_sharp,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1,601 funds', style: UTextStyles.small),
                  Text('‹› 3 Year Returns', style: UTextStyles.small),
                ],
              ),
            ),
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(color: Ucolors.primary),
                ),
              );
            }
            if (controller.mutualfund.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text("No mutual funds found")),
              );
            }

            return
            ///  MUTUAL FUND LIST
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final fund = controller.mutualfund[index];

                return MutualFundCard(entity: fund);
              }, childCount: controller.mutualfund.length),
            );
          }),
        ],
      ),
    );
  }
}

class MutualFundCard extends StatelessWidget {
  MutualFundCard({
    super.key,
    this.isDelete = false,
    this.containercolor,
    this.entity,
  });

  final bool isDelete;
  final Color? containercolor;
  final MutualFundListEntity? entity;
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => FundDeatailsScreen()),

      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  // radius: 18,
                  maxRadius: 20,
                  backgroundColor: Colors.grey,
                  // backgroundImage: AssetImage(UImages.sbi),
                  // backgroundImage:  NetworkImage(entity!.amc!.amcLogoUrl!),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: entity!.amc!.amcLogoUrl!,
                      fadeInDuration: const Duration(milliseconds: 300),

                      placeholder: (context, url) =>
                          UShimmerEffect(width: 40, height: 40, radius: 20),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 'Nippon India Large Cap Fund - Growth Plan',
                        entity!.baseSchemeName.toString(),
                        // entity.baseSchemeName.toString(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff383838),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Risk:',
                              style: Theme.of(context).textTheme.labelSmall!
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: 'Very High',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(color: Ucolors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                !isDelete
                    ? PopupMenuButton<PortfolioMenuAction>(
                        color: Ucolors.light,
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        // elevation: 6,
                        offset: const Offset(0, 40),
                        onSelected: (value) {
                          switch (value) {
                            case PortfolioMenuAction.topUp:
                              controller.addItem(
                                CartItem(
                                  fundId: entity!.amc!.id.toString(),
                                  fundName: entity!.baseSchemeName.toString(),
                                  logoUrl: entity!.amc!.amcLogoUrl.toString(),
                                ),
                              );
                              Get.snackbar(
                                margin: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 15,
                                ),
                                colorText: Ucolors.light,
                                'Add to cart',
                                entity!.baseSchemeName.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Ucolors.primary,
                              );

                              // log('top up');
                              break;

                            case PortfolioMenuAction.modify:
                              break;
                            case PortfolioMenuAction.pause:
                              break;
                            case PortfolioMenuAction.cancel:
                              break;
                            case PortfolioMenuAction.redemption:
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          buildMenuItem(
                            icon: Iconsax.card_send,
                            text: 'Add to cart',
                            value: PortfolioMenuAction.topUp,
                          ),
                          buildMenuItem(
                            icon: Iconsax.edit_2,
                            text: 'Buy SIP',
                            value: PortfolioMenuAction.modify,
                          ),
                          buildMenuItem(
                            icon: Iconsax.pause,
                            text: 'Buy Lumpsum',
                            value: PortfolioMenuAction.pause,
                          ),
                          buildMenuItem(
                            icon: Iconsax.add,
                            text: 'Add to watchlist',
                            value: PortfolioMenuAction.cancel,
                          ),
                          buildMenuItem(
                            icon: Iconsax.receipt,
                            text: 'Fund Details',
                            value: PortfolioMenuAction.redemption,
                          ),
                        ],
                      )
                    : Deleteiconwithcontainer(containercolor: containercolor),
                // const Icon(Icons.more_vert),
              ],
            ),

            // const SizedBox(height: 8),

            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         text: 'Risk:',
            //         style: Theme.of(context).textTheme.labelSmall!.copyWith(),
            //       ),
            //       TextSpan(
            //         text: 'Very High',
            //         style: Theme.of(
            //           context,
            //         ).textTheme.labelMedium!.copyWith(color: Ucolors.red),
            //       ),
            //     ],
            //   ),
            // ),

            /// Risk
            // const Text(
            //   'Risk: Very High',
            //   style: TextStyle(fontSize: 13, color: Colors.red),
            // ),
            const SizedBox(height: 5),
            // const Divider(height: 0),
            Text(
              maxLines: 1,
              'Trailing Return -------------------------------------------------------------------------------------------------------',
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
              children: const [
                _ReturnItem(title: '1W', value: '-0.15%', isNegative: true),
                _ReturnItem(title: '1Y', value: '5.20%'),
                _ReturnItem(title: '3Y', value: '18.42%'),
                _ReturnItem(title: '5Y', value: '20.89%'),
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
        Text(title, style: Theme.of(context).textTheme.labelMedium!.copyWith()),
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
        margin: EdgeInsets.only(left: 5),
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
