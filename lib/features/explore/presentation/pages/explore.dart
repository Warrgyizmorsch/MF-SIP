// ignore_for_file: dead_null_aware_expression, dead_code, unused_element_parameter

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/core/utils/helper/purchase_scenario.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import 'package:my_sip/features/mfu/presentation/pages/purchase_page.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart'; // Ensure this import exists for Deleteiconwithcontainer
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/shimmer/shimmer.dart';
import '../../../fund_details/presentation/controllers/fund_details_controller.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';

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
                ? Ucolors.primary.withValues(alpha: 0.04)
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

enum WebFundViewType { grid, list }

class _WebExploreLayout extends StatefulWidget {
  final ScrollController scrollController;
  final FocusNode searchFocus;
  final TextEditingController sortController;
  final List<String> sortItems;

  const _WebExploreLayout({
    super.key,
    required this.scrollController,
    required this.searchFocus,
    required this.sortController,
    required this.sortItems,
  });

  @override
  State<_WebExploreLayout> createState() => _WebExploreLayoutState();
}

class _WebExploreLayoutState extends State<_WebExploreLayout> {
  WebFundViewType selectedView = WebFundViewType.grid;
 
  bool showViewButtons = true;
  double lastScrollOffset = 0;
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScrollDirection);
  }

  void _handleScrollDirection() {
    if (!widget.scrollController.hasClients) return;

    final currentOffset = widget.scrollController.offset;

    // Scroll down = hide buttons
    if (currentOffset > lastScrollOffset + 8 && showViewButtons) {
      setState(() => showViewButtons = false);
    }

    // Scroll up = show buttons
    if (currentOffset < lastScrollOffset - 8 && !showViewButtons) {
      setState(() => showViewButtons = true);
    }

    lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScrollDirection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MutualFundController controller = Get.find();

    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            int getCrossAxisCount() {
              if (width > 1100) return 3;
              if (width >= 800) return 2;
              return 1;
            }

            final int crossAxisCount = getCrossAxisCount();

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     _viewButton(
                  //       icon: Icons.grid_view_rounded,
                  //       isSelected: selectedView == WebFundViewType.grid,
                  //       onTap: () {
                  //         setState(() => selectedView = WebFundViewType.grid);
                  //       },
                  //     ),
                  //     const Gap(8),
                  //     _viewButton(
                  //       icon: Icons.view_list_rounded,
                  //       isSelected: selectedView == WebFundViewType.list,
                  //       onTap: () {
                  //         setState(() => selectedView = WebFundViewType.list);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: showViewButtons
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _viewButton(
                                icon: Icons.grid_view_rounded,
                                isSelected:
                                    selectedView == WebFundViewType.grid,
                                onTap: () {
                                  setState(
                                    () => selectedView = WebFundViewType.grid,
                                  );
                                },
                              ),
                              const Gap(8),
                              _viewButton(
                                icon: Icons.view_list_rounded,
                                isSelected:
                                    selectedView == WebFundViewType.list,
                                onTap: () {
                                  setState(
                                    () => selectedView = WebFundViewType.list,
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),

                  if (showViewButtons) const Gap(14),

                  const Gap(14),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return _buildLoadingGrid(crossAxisCount);
                      }

                      if (controller.searchFund.isEmpty) {
                        return _buildEmptyState();
                      }

                      // if (selectedView == WebFundViewType.list) {
                      //   return ListView.builder(
                      //     controller: widget.scrollController,
                      //     padding: const EdgeInsets.only(bottom: 20),
                      //     itemCount: controller.searchFund.length,
                      //     itemBuilder: (context, index) {
                      //       final fund = controller.searchFund[index];
                      //       return WebFundListCard(entity: fund);
                      //     },
                      //   );
                      // }
                      // if (selectedView == WebFundViewType.list) {
                      //   return Column(
                      //     children: [
                      //       Container(
                      //         height: 50,
                      //         padding: const EdgeInsets.symmetric(
                      //           horizontal: 18,
                      //           vertical: 10,
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xFFF5F7FA),
                      //           borderRadius: BorderRadius.circular(12),
                      //           border: Border.all(color: Colors.grey.shade300),
                      //         ),
                      //         child: Row(
                      //           children: [
                      //             const SizedBox(width: 40),

                      //             const Expanded(
                      //               flex: 3,
                      //               child: Text(
                      //                 "Fund Name",
                      //                 style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 13,
                      //                 ),
                      //               ),
                      //             ),

                      //             _headerText("1W"),
                      //             _headerText("1M"),
                      //             _headerText("1Y"),
                      //             _headerText("3Y"),
                      //             _headerText("5Y"),
                      //             _headerText("10Y"),
                      //             _headerText("NAV"),

                      //             const Expanded(
                      //               child: Text(
                      //                 "",
                      //                 textAlign: TextAlign.center,
                      //                 style: TextStyle(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 13,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),

                      //       const SizedBox(height: 8),

                      //       Expanded(
                      //         child: ListView.builder(
                      //           controller: widget.scrollController,
                      //           itemCount: controller.searchFund.length,
                      //           itemBuilder: (context, index) {
                      //             final fund = controller.searchFund[index];
                      //             return WebFundListCard(entity: fund);
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   );
                      // }
                      if (selectedView == WebFundViewType.list) {
                        return Column(
                          children: [
                            _listHeader(),

                            const Gap(8),

                            Expanded(
                              child: ListView.builder(
                                controller: widget.scrollController,
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: controller.searchFund.length,
                                itemBuilder: (context, index) {
                                  final fund = controller.searchFund[index];
                                  return WebFundListCard(entity: fund);
                                },
                              ),
                            ),
                          ],
                        );
                      }

                      return GridView.builder(
                        controller: widget.scrollController,
                        itemCount: controller.searchFund.length,
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 8,
                          right: 8,
                          top: 8,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 170,
                        ),
                        itemBuilder: (context, index) {
                          final fund = controller.searchFund[index];
                          return ResponsiveFundCard(
                            entity: fund,
                            isMobile: crossAxisCount == 1,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _listHeader() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const SizedBox(width: 54),

          const Expanded(
            flex: 4,
            child: Text(
              "Fund Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),

          // _headerText("1W"),
          _headerText("1M"),
          _headerText("1Y"),
          _headerText("3Y"),
          _headerText("5Y"),
          _headerText("10Y"),
          _headerText("NAV"),

          const Expanded(
            flex:2,
            child: Text(
              " ",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _viewButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        width: 42,
        decoration: BoxDecoration(
          color: isSelected ? Ucolors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Ucolors.primary : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLoadingGrid(int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 150,
      ),
      itemCount: 20,
      itemBuilder: (_, __) => const FundShimmerCard(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.red.shade200),
          const Gap(16),
          const Text(
            "No Funds Found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class WebFundListCard extends StatelessWidget {
  final MutualFundListEntity entity;

  const WebFundListCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final RxBool isPressed = false.obs;
    return WebHoverRow(
      onTap: () {
        Get.delete<FundDetailsController>();
        FundDetailsScreen.navData = {
          'scheme': entity.baseSchemeName,
          'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
          'scheme_code': entity.schemeCode.toString(),
        };

        Get.toNamed(AppRoutes.funddetails, id: 1);
      },
      builder: (isHovered) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: CustomCachedImage(
                    imageUrl: "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
                  ),
                ),
              ),

              const Gap(14),

              Expanded(
                flex: 4,
                child: Text(
                  entity.baseSchemeName ?? 'Unknown Fund',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isHovered ? Ucolors.primary : Colors.black87,
                  ),
                ),
              ),

              // Expanded(child: _valueText(entity.returnsEntity?.oneWeek)),
              Expanded(child: _valueText(entity.returnsEntity?.oneMonth)),
              Expanded(child: _valueText(entity.returnsEntity?.oneYear)),
              Expanded(child: _valueText(entity.returnsEntity?.threeYear)),
              Expanded(child: _valueText(entity.returnsEntity?.fiveYear)),
              Expanded(child: _valueText(entity.returnsEntity?.tenYear)),
              Expanded(child: _navValue(entity.nav)),

              const Gap(12),

              // _riskChip(entity),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final wishlistController = Get.find<WishlistController>();
                      final String code = entity.schemeCode ?? '';
                      final String name = entity.baseSchemeName ?? "";
                      final bool isFav = wishlistController.isFavorite(code);

                      return PremiumHeartButton(
                        isFav: isFav,
                        onTap: () => wishlistController.toggleWishlist(code, name),
                      );
                    }),
                    Obx(() {
                      final cartController = Get.find<CartController>();
                      final String code = entity.schemeCode ?? "";

                      final matchingItems = cartController.displayedItems.where(
                              (item) => item.schemeCode.toString() == code
                      ).toList();

                      final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
                      final bool isInCart = cartItem != null;

                      return AnimatedScale(
                        // A more dramatic shrink when processing, with a 'pull back' curve
                        scale: isPressed.value ? 0.6 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInBack,

                        child: AnimatedSwitcher(
                          // Extended duration to let the elastic spring finish its movement
                          duration: const Duration(milliseconds: 650),
                          switchInCurve: Curves.elasticOut, // The secret sauce for the bouncy feel
                          switchOutCurve: Curves.easeOut,

                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              // Adds a dynamic 180-degree flip as it scales in
                              child: RotationTransition(
                                turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: CompactIcon(
                            key: ValueKey<bool>(isInCart),
                            icon: isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
                            iconColor: isInCart ? Ucolors.primary : Ucolors.darkgrey,

                            onPressed: () async {
                              if (isPressed.value) return;

                              isPressed.value = true;

                              try {
                                if (isInCart) {
                                  final itemId = cartItem?.id;
                                  if (itemId != null) {
                                    await cartController.deleteCartItem(
                                        itemId,
                                        entity.schemeCode ?? ""
                                    );
                                  }
                                } else {
                                  await cartController.addToCart(
                                    code,
                                    entity.baseSchemeName ?? "",
                                    entity.minSipAmount ?? 5000,
                                    transType: 'sip',
                                    null,
                                  );
                                }
                              } finally {
                                isPressed.value = false;
                              }
                            },
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () {
                          GatekeeperHelper.runWithPrerequisites(
                            onSuccess: () {
                              final purchaseArgs = SipPurchaseArgs(
                                schemeCode: entity.schemeCode ?? '',
                                fundName: entity.baseSchemeName ?? '',
                                category: "Unknown",
                                riskLabel: entity.riskLevel ?? "",
                                minSip: entity.minSipAmount ?? 1000,
                                minLumpsum: entity.minLumpsum ?? 1000,
                                minTopup: entity.minTopUp ?? 5000,
                                folio: null,
                                imgUrl:
                                    '${Appurl.baseUrl}${entity.amc?.amcLogoUrl}',
                              );

                              SIPPurchasePage.tempData = purchaseArgs;

                              Get.toNamed(
                                AppRoutes.investNowPage,
                                id: kIsWeb ? 1 : null,
                                arguments: purchaseArgs,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Ucolors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Invest",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _valueText(dynamic value) {
    final double val = double.tryParse(value?.toString() ?? '0') ?? 0;

    return Center(
      child: Text(
        "${val > 0 ? '+' : ''}$val%",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: val < 0 ? Colors.redAccent : const Color(0xFF00C853),
        ),
      ),
    );
  }

  Widget _navValue(dynamic value) {
    return Center(
      child: Text(
        value?.toString() ?? "N/A",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Widget _returnText(String label, dynamic value) {
  //   final double val = double.tryParse(value?.toString() ?? '0') ?? 0;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
  //       ),
  //       const Gap(3),
  //       Text(
  //         "${val > 0 ? '+' : ''}$val%",
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //           color: val < 0 ? Colors.redAccent : const Color(0xFF00C853),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _navText(String label, dynamic value) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
  //       ),
  //       const Gap(3),
  //       Text(
  //         value == null ? "N/A" : value.toString(),
  //         style: const TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _riskChip(MutualFundListEntity entity) {
    final risk = getRiskMeter(entity.riskLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: risk.color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        entity.riskLevel ?? "N/A",
        style: TextStyle(
          color: risk.color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

// class _WebExploreLayout extends StatelessWidget {
//   final ScrollController scrollController;
//   final FocusNode searchFocus;
//   final TextEditingController sortController;
//   final List<String> sortItems;

//   const _WebExploreLayout({
//     super.key,
//     required this.scrollController,
//     required this.searchFocus,
//     required this.sortController,
//     required this.sortItems,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final MutualFundController controller = Get.find();

//     return Scaffold(
//       body: Center(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double width = constraints.maxWidth;

//             // Logic: >1100 (3 col), 800-1100 (2 col), <800 (1 col)
//             int getCrossAxisCount() {
//               if (width > 1100) return 3;
//               if (width >= 800) return 2;
//               return 1;
//             }

//             final int crossAxisCount = getCrossAxisCount();
//             final bool isMobileWidth = width < 600;

//             return Padding(
//               padding: EdgeInsets.all(isMobileWidth ? 14 : 24),
//               child: Column(
//                 children: [
//                   if (isMobileWidth) ...[
//                     SizedBox(
//                       height: 48,
//                       child: SearchBar(
//                         focusNode: searchFocus,
//                         hintText: "Search funds...",
//                         elevation: WidgetStateProperty.all(0),
//                         backgroundColor: WidgetStateProperty.all(Colors.white),
//                         leading: const Icon(Icons.search),
//                         onChanged: controller.onSearchQueryChanged,
//                       ),
//                     ),
//                     const Gap(18),
//                   ],

//                   const Gap(10),

//                   Expanded(
//                     child: Obx(() {
//                       if (controller.isLoading.value) {
//                         return _buildLoadingGrid(crossAxisCount);
//                       }

//                       if (controller.searchFund.isEmpty) {
//                         return _buildEmptyState();
//                       }

//                       return GridView.builder(
//                         controller: scrollController,
//                         itemCount: controller.searchFund.length,
//                         // padding: const EdgeInsets.only(bottom: 20),
//                         padding: const EdgeInsets.only(
//                           bottom: 20,
//                           left: 8,
//                           right: 8,
//                           top: 8,
//                         ),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                           // Increased height to accommodate 3 rows of data comfortably
//                           mainAxisExtent: 170,
//                         ),
//                         itemBuilder: (context, index) {
//                           final fund = controller.searchFund[index];
//                           return ResponsiveFundCard(
//                             entity: fund,
//                             // Use mobile UI if only 1 column is showing
//                             isMobile: crossAxisCount == 1,
//                           );
//                         },
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingGrid(int crossAxisCount) {
//     return GridView.builder(
//       // Ensure the grid stays within the 1200px constraint set in the parent
//       padding: const EdgeInsets.only(bottom: 20),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         // Matches the mainAxisExtent of your real cards for a smooth transition
//         mainAxisExtent: 150,
//       ),
//       itemCount: 20, // Multiple of 3 looks better on desktop
//       itemBuilder: (_, __) => const FundShimmerCard(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.search_off_rounded, size: 80, color: Colors.red.shade200),
//           const Gap(16),
//           const Text(
//             "No Funds Found",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ResponsiveFundCard extends StatefulWidget {
  final MutualFundListEntity entity;
  final bool isMobile;

  const ResponsiveFundCard({
    super.key,
    required this.entity,
    required this.isMobile,
  });

  @override
  State<ResponsiveFundCard> createState() => _ResponsiveFundCardState();
}

class _ResponsiveFundCardState extends State<ResponsiveFundCard>
    with SingleTickerProviderStateMixin {
  bool isHover = false;

  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.015,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.01),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find<CartController>();

    final MutualFundController mutualFundController =
        Get.find<MutualFundController>();

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHover = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHover = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value.dy * 100),

            child: Transform.scale(
              scale: _scaleAnimation.value,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,

                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  /// =========================
                  /// BACKGROUND COLOR ANIMATION
                  /// =========================
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: isHover
                        ? [const Color(0xFFF5F9FF), const Color(0xFFEAF3FF)]
                        : [Colors.white, Colors.white],
                  ),

                  borderRadius: BorderRadius.circular(22),
                  //
                  border: Border.all(
                    color: isHover
                        ? Ucolors.primary.withValues(alpha: .35)
                        : Colors.grey.shade200,
                    width: 1.2,
                  ),

                  /// =========================
                  /// SHADOW ANIMATION
                  /// =========================
                  boxShadow: [
                    BoxShadow(
                      blurRadius: isHover ? 22 : 6,
                      spreadRadius: isHover ? 1 : 0,
                      offset: Offset(0, isHover ? 10 : 4),

                      color: isHover
                          ? Ucolors.primary.withValues(alpha: .10)
                          : Colors.black.withValues(alpha: .03),
                    ),
                  ],
                ),

                child: widget.isMobile
                    ? _buildMobileLayout(controller)
                    : _buildDesktopLayout(controller, mutualFundController),
              ),
            ),
          );
        },
      ),
    );
  }

  // =======================================================
  // DESKTOP LAYOUT
  // =======================================================

  Widget _buildDesktopLayout(
    CartController controller,
    MutualFundController mutualFundController,
  ) {
    final entity = widget.entity;

    final double width = MediaQuery.of(context).size.width;

    double scale(double baseSize) =>
        (baseSize * (width / 1200)).clamp(baseSize * 0.8, baseSize * 1.1);
    final RxBool isPressed = false.obs;

    return GestureDetector(
      onTap: () {
        Get.delete<FundDetailsController>();
        FundDetailsScreen.navData = {
          'scheme': entity.baseSchemeName,
          'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
          'scheme_code': entity.schemeCode.toString(),
        };

        Get.toNamed(AppRoutes.funddetails, id: 1);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: scale(isHover ? 38 : 32),
                      height: scale(isHover ? 38 : 32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: isHover
                            ? [
                          BoxShadow(
                            blurRadius: 10,
                            color: Ucolors.primary.withValues(alpha: .18),
                          ),
                        ]
                            : [],
                      ),
                      child: ClipOval(
                        child: CustomCachedImage(
                          imageUrl: "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
                        ),
                      ),
                    ),
                    Gap(scale(12)),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: scale(isHover ? 16 : 15),
                          color: isHover
                              ? Ucolors.primary
                              : const Color(0xff383838),
                        ),
                        child: Text(
                          entity.baseSchemeName ?? 'Unknown Fund',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(scale(12)),
                Padding(
                  padding: EdgeInsets.only(left: scale(44)),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Risk: ',
                          style: TextStyle(
                            fontSize: scale(12),
                            color: Colors.grey.shade600,
                          ),
                        ),
                        TextSpan(
                          text: entity.riskLevel ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: scale(12),
                            color: getRiskMeter(entity.riskLevel).color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(scale(8)),
                Padding(
                  padding: EdgeInsets.only(left: scale(44)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _miniReturnRow("1Y", entity.returnsEntity?.oneYear, scale),
                      Gap(scale(12)),
                      _miniReturnRow("3Y", entity.returnsEntity?.threeYear, scale),
                      Gap(scale(12)),
                      _miniReturnRow("5Y", entity.returnsEntity?.fiveYear, scale),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(scale(12)),

          // Right side: Icons + Invest Button stacked
          // Right side: Icons + Invest Button stacked
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Wishlist & Cart Icons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Wishlist Icon
                  Obx(() {
                    final wishlistController = Get.find<WishlistController>();
                    final String code = entity.schemeCode ?? '';
                    final String name = entity.baseSchemeName ?? "";
                    final bool isFav = wishlistController.isFavorite(code);

                    return PremiumHeartButton(
                      isFav: isFav,
                      onTap: () => wishlistController.toggleWishlist(code, name),
                    );
                  }),

                  Gap(scale(12)),

                  // Add to Cart / Go to Cart Icon
                  // Add to Cart / Go to Cart Icon
                  Obx(() {
                    final cartController = Get.find<CartController>();
                    final String code = entity.schemeCode ?? "";

                    final matchingItems = cartController.displayedItems.where(
                            (item) => item.schemeCode.toString() == code
                    ).toList();

                    final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
                    final bool isInCart = cartItem != null;

                    return AnimatedScale(
                      // A more dramatic shrink when processing, with a 'pull back' curve
                      scale: isPressed.value ? 0.6 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInBack,

                      child: AnimatedSwitcher(
                        // Extended duration to let the elastic spring finish its movement
                        duration: const Duration(milliseconds: 650),
                        switchInCurve: Curves.elasticOut, // The secret sauce for the bouncy feel
                        switchOutCurve: Curves.easeOut,

                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            // Adds a dynamic 180-degree flip as it scales in
                            child: RotationTransition(
                              turns: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: CompactIcon(
                          key: ValueKey<bool>(isInCart),
                          icon: isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
                          iconColor: isInCart ? Ucolors.primary : Ucolors.darkgrey,

                          onPressed: () async {
                            if (isPressed.value) return;

                            isPressed.value = true;

                            try {
                              if (isInCart) {
                                final itemId = cartItem?.id;
                                if (itemId != null) {
                                  await cartController.deleteCartItem(
                                      itemId,
                                      entity.schemeCode ?? ""
                                  );
                                }
                              } else {
                                await cartController.addToCart(
                                  code,
                                  entity.baseSchemeName ?? "",
                                  entity.minSipAmount ?? 5000,
                                  transType: 'sip',
                                  null,
                                );
                              }
                            } finally {
                              isPressed.value = false;
                            }
                          },
                        ),
                      ),
                    );
                  })
                ],
              ),

              Gap(scale(12)),

              // Original Invest Button
              AnimatedScale(
                scale: isHover ? 1.04 : 1,
                duration: const Duration(milliseconds: 220),
                child: _investButton(controller, entity, scale),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// =======================================================
  /// MINI RETURN ROW
  /// =======================================================

  Widget _miniReturnRow(
    String label,
    dynamic value,
    double Function(double) scale,
  ) {
    final double val = double.tryParse(value?.toString() ?? '0') ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",

          style: TextStyle(color: Colors.grey.shade500, fontSize: scale(11)),
        ),

        const Gap(2),

        Text(
          "${val > 0 ? '+' : ''}$val%",

          style: TextStyle(
            color: val < 0 ? Colors.redAccent : const Color(0xFF00C853),

            fontWeight: FontWeight.bold,
            fontSize: scale(12),
          ),
        ),
      ],
    );
  }

  /// =======================================================
  /// INVEST BUTTON
  /// =======================================================

  Widget _investButton(
    CartController controller,
    MutualFundListEntity entity,
    double Function(double) scale,
  ) {
    return SizedBox(
      height: scale(38),

      child: ElevatedButton(
        onPressed: () async {
          // await controller.addToCart(
          //   entity.schemeCode ?? '',
          //   entity.baseSchemeName ?? '',
          //   entity.minSipAmount ?? 0,
          //   null,
          // );

          // // await controller.fetchCart();
          GatekeeperHelper.runWithPrerequisites(
            onSuccess: () {
              // This ONLY runs if KYC, Bank, CAN, and Mandate are all good!
              final argVal = controller.fundDetail.value;

              final purchaseArgs = SipPurchaseArgs(
                schemeCode: entity.schemeCode ?? '',
                fundName: entity.baseSchemeName ?? '',
                category: '' ?? "Unknown",
                riskLabel: entity.riskLevel ?? "",
                minSip: entity.minSipAmount ?? 1000,
                minLumpsum: entity.minLumpsum ?? 1000,
                minTopup: entity.minTopUp ?? 5000,
                folio: null,
                imgUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl}' ?? "",
              );

              SIPPurchasePage.tempData = purchaseArgs;

              Get.toNamed(
                AppRoutes.investNowPage,
                // id: 1,
                id: kIsWeb ? 1 : null,

                arguments: purchaseArgs,
              );
            },
          );
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: Ucolors.primary,
          foregroundColor: Colors.white,
          elevation: 0,

          padding: EdgeInsets.symmetric(horizontal: scale(20)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scale(10)),
          ),
        ),

        child: Text(
          "Invest",

          style: TextStyle(fontSize: scale(12), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// =======================================================
  /// MOBILE LAYOUT
  /// =======================================================

  Widget _buildMobileLayout(CartController controller) {
    final entity = widget.entity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP INFO
        Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.grey.shade200),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: CustomCachedImage(
                  imageUrl: "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
                ),
              ),
            ),

            const Gap(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    entity.baseSchemeName ?? "Unknown Fund",

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const Gap(4),

                  Text(
                    entity.amc?.amcName ?? '',

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),

        const Gap(18),

        /// RETURNS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            _miniReturn("1Y", entity.returnsEntity?.oneYear),

            _miniReturn("3Y", entity.returnsEntity?.threeYear),

            _miniReturn("5Y", entity.returnsEntity?.fiveYear),
          ],
        ),

        const Gap(14),

        /// BOTTOM ACTION
        Row(
          children: [
            Expanded(child: _riskChip(entity)),

            const Gap(12),

            Expanded(child: _investButton(controller, entity, (size) => size)),

          ],
        ),
      ],
    );
  }

  /// =======================================================
  /// MINI RETURN MOBILE
  /// =======================================================

  Widget _miniReturn(String label, dynamic value) {
    final double val = double.tryParse(value?.toString() ?? '0') ?? 0;

    return Column(
      children: [
        Text(
          label,

          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),

        const Gap(4),

        Text(
          "${val > 0 ? '+' : ''}$val%",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,

            color: val < 0 ? Colors.red : const Color(0xFF00C853),
          ),
        ),
      ],
    );
  }

  /// =======================================================
  /// RISK CHIP
  /// =======================================================

  Widget _riskChip(MutualFundListEntity entity) {
    final risk = getRiskMeter(entity.riskLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

      decoration: BoxDecoration(
        color: risk.color.withValues(alpha: .1),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        entity.riskLevel ?? "N/A",

        textAlign: TextAlign.center,

        style: TextStyle(
          color: risk.color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
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
                const SizedBox(width: 5),
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
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.white,
                                ),
                                leading: const Icon(Icons.search),
                                hintText: 'Search',
                                onChanged: (value) =>
                                    controller.onSearchQueryChanged(value),
                                elevation: WidgetStateProperty.all(0),
                                side: WidgetStateProperty.all(
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
                                      "1Y,3Y,5Y",
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

          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                hasScrollBody: true,
                child: ShimmerListView(),
              );
            }
            if (controller.searchFund.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: AnimatedEmptyState(
                    title: 'NO fund',
                    message: 'No mutual funds found',
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
    this.onTapOverride,
    this.showTrainlings = true,
  });

  final bool isDelete;
  final Color? containercolor;
  final MutualFundListEntity entity;
  final VoidCallback? onTapOverride;
  final bool showTrainlings;
  final CartController controller = Get.find<CartController>();
  final MutualFundController mutualFundController =
      Get.find<MutualFundController>();

  final WishlistController wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTapOverride ??
          () {
            // mutualFundController.addToRecentlyViewed(entity);
            mutualFundController.addToLocalRecentlyViewed(entity);
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
              color: Colors.black.withValues(alpha: 0.15),
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
                  maxRadius: 18,
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
                          fontSize: 12,
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
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 11,
                                  ),
                            ),
                            TextSpan(
                              text: entity.riskLevel,
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
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
                                entity.minLumpsum ?? 0,
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
                              mutualFundController.addToLocalRecentlyViewed(
                                entity,
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
                          if (showTrainlings) ...[
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
                          ],
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

            if (showTrainlings) ...[
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
                    isNegative:
                        parseIntSafe(entity.returnsEntity?.threeYear) < 0
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
        Text(title, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: isNegative ? Colors.red : Colors.green,
            fontSize: 11,
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
class PremiumHeartButton extends StatefulWidget {
  final bool isFav;
  final VoidCallback onTap;

  const PremiumHeartButton({
    super.key,
    required this.isFav,
    required this.onTap,
  });

  @override
  State<PremiumHeartButton> createState() => _PremiumHeartButtonState();
}

class _PremiumHeartButtonState extends State<PremiumHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // This sequence creates the "Shrink -> Explode -> Settle" effect
    _scaleAnimation = TweenSequence<double>([
      // 1. Instantly shrink down slightly when tapped
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.6)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20.0,
      ),
      // 2. Explode outwards past the normal size
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 1.3)
            .chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 40.0,
      ),
      // 3. Wobble back down to standard size
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40.0,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant PremiumHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger the animation only when changing FROM false TO true
    if (widget.isFav && !oldWidget.isFav) {
      _controller.forward(from: 0.0);
    }
    // Optional: play in reverse when un-favoriting, or leave it as is
    else if (!widget.isFav && oldWidget.isFav) {
      _controller.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // We use behavior: HitTestBehavior.opaque to ensure the whole area is clickable
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Icon(
          widget.isFav ? Iconsax.heart5 : Iconsax.heart,
          color: widget.isFav ? Colors.red : Colors.grey, // Update with your Ucolors
          size: 24, // Update with your standard CompactIcon size
        ),
      ),
    );
  }
}