// ignore_for_file: dead_null_aware_expression, dead_code, unused_element_parameter

import 'dart:developer';

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
import 'package:my_sip/features/explore/presentation/widget/webfilterpage.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import 'package:my_sip/features/mfu/presentation/pages/purchase_page.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart'; // Ensure this import exists for Deleteiconwithcontainer
import 'package:my_sip/features/wishlist/presentation/controller/wishlist_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';
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
            borderRadius: BorderRadius.circular(10),
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
          ? WebExploreLayout(
              scrollController: _scrollController,
              searchFocus: _searchFocus,
              sortController: sort,
              sortItems: items,
            )
          : MobileExploreLayout(
              scrollController: _scrollController,
              searchFocus: _searchFocus,
              sortController: sort,
              sortItems: items,
            ),
    );
  }
}

enum WebFundViewType { grid, list }

class WebExploreLayout extends StatefulWidget {
  final ScrollController scrollController;
  final FocusNode searchFocus;
  final TextEditingController sortController;
  final List<String> sortItems;

  const WebExploreLayout({
    super.key,
    required this.scrollController,
    required this.searchFocus,
    required this.sortController,
    required this.sortItems,
  });

  @override
  State<WebExploreLayout> createState() => _WebExploreLayoutState();
}

class _WebExploreLayoutState extends State<WebExploreLayout> {
  WebFundViewType selectedView = WebFundViewType.grid;

  bool showViewButtons = true;
  double lastScrollOffset = 0;
  @override
  void initState() {
    super.initState();
    // widget.scrollController.addListener(_handleScrollDirection);
  }

  // void _handleScrollDirection() {
  //   if (!widget.scrollController.hasClients) return;

  //   final currentOffset = widget.scrollController.offset;

  //   // Scroll down = hide buttons
  //   if (currentOffset > lastScrollOffset + 8 && showViewButtons) {
  //     setState(() => showViewButtons = false);
  //   }

  //   // Scroll up = show buttons
  //   if (currentOffset < lastScrollOffset - 8 && !showViewButtons) {
  //     setState(() => showViewButtons = true);
  //   }

  //   lastScrollOffset = currentOffset;
  // }

  @override
  void dispose() {
    // widget.scrollController.removeListener(_handleScrollDirection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MutualFundController controller = Get.find();
    // log("WEB UI CTRL HASH: ${identityHashCode(controller)}");
    return Row(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: Colors.grey.shade200)),
          ),
          child: const WebFilterContent(
            showCloseButton: false,
            showSearchBar: true,
          ),
        ),

        Expanded(
          child: Scaffold(
            // backgroundColor: const Color(0xFFF5F7FA),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Invest in the right fund for you',
                                    style: TextStyle(
                                      fontFamily: FontFamily.medium,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Ucolors.dark,
                                      letterSpacing: -0.4,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Browse all fund categories and find the best match for your goals.',
                                    style: TextStyle(
                                      fontFamily: FontFamily.medium,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
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
                            ),
                          ],
                        ),

                        const Gap(18),

                        Expanded(
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return _buildLoadingGrid(crossAxisCount);
                            }

                            if (controller.searchFund.isEmpty) {
                              return _buildEmptyState();
                            }

                            if (selectedView == WebFundViewType.list) {
                              return ListView.builder(
                                controller: widget.scrollController,
                                padding: EdgeInsets.zero,
                                itemCount: controller.searchFund.length,
                                itemBuilder: (context, index) {
                                  final fund = controller.searchFund[index];

                                  return WebFundListCard(
                                    entity: fund,
                                    key: ValueKey(
                                      '${fund.schemeCode}_${fund.baseSchemeName}',
                                    ),
                                  );
                                },
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    // mainAxisExtent: 170,
                                    mainAxisExtent: 225,
                                  ),
                              itemBuilder: (context, index) {
                                final fund = controller.searchFund[index];
                                return ResponsiveFundCard(
                                  key: ValueKey(
                                    '${fund.schemeCode}_${fund.baseSchemeName}',
                                  ),
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
          ),
        ),
      ],
    );
    // return Row(
    //   children: [
    //     SizedBox(
    //       width: 300,
    //       child: WebExploreFilterPanel(searchFocus: widget.searchFocus),
    //     ),

    //     Container(width: 1, color: Colors.grey.shade200),

    //     Expanded(
    //       child: Scaffold(
    //         backgroundColor: const Color(0xFFF5F7FA),
    //         body: Center(
    //           child: LayoutBuilder(
    //             builder: (context, constraints) {
    //               final double width = constraints.maxWidth;

    //               int getCrossAxisCount() {
    //                 if (width > 1100) return 3;
    //                 if (width >= 800) return 2;
    //                 return 1;
    //               }

    //               final int crossAxisCount = getCrossAxisCount();

    //               return Padding(
    //                 padding: const EdgeInsets.all(24),
    //                 child: Column(
    //                   children: [
    //                     AnimatedSize(
    //                       duration: const Duration(milliseconds: 250),
    //                       curve: Curves.easeInOut,
    //                       child: showViewButtons
    //                           ? Row(
    //                               mainAxisAlignment: MainAxisAlignment.end,
    //                               children: [
    //                                 _viewButton(
    //                                   icon: Icons.grid_view_rounded,
    //                                   isSelected:
    //                                       selectedView == WebFundViewType.grid,
    //                                   onTap: () {
    //                                     setState(
    //                                       () => selectedView =
    //                                           WebFundViewType.grid,
    //                                     );
    //                                   },
    //                                 ),
    //                                 const Gap(8),
    //                                 _viewButton(
    //                                   icon: Icons.view_list_rounded,
    //                                   isSelected:
    //                                       selectedView == WebFundViewType.list,
    //                                   onTap: () {
    //                                     setState(
    //                                       () => selectedView =
    //                                           WebFundViewType.list,
    //                                     );
    //                                   },
    //                                 ),
    //                               ],
    //                             )
    //                           : const SizedBox.shrink(),
    //                     ),

    //                     if (showViewButtons) const Gap(14),

    //                     Expanded(
    //                       child: Obx(() {
    //                         if (controller.isLoading.value) {
    //                           return _buildLoadingGrid(crossAxisCount);
    //                         }

    //                         if (controller.searchFund.isEmpty) {
    //                           return _buildEmptyState();
    //                         }

    //                         if (selectedView == WebFundViewType.list) {
    //                           return Column(
    //                             children: [
    //                               _listHeader(),
    //                               const Gap(8),
    //                               Expanded(
    //                                 child: ListView.builder(
    //                                   controller: widget.scrollController,
    //                                   padding: const EdgeInsets.only(
    //                                     bottom: 20,
    //                                   ),
    //                                   itemCount: controller.searchFund.length,
    //                                   itemBuilder: (context, index) {
    //                                     final fund =
    //                                         controller.searchFund[index];
    //                                     return WebFundListCard(
    //                                       entity: fund,
    //                                       key: ValueKey(
    //                                         '${fund.schemeCode}_${fund.baseSchemeName}',
    //                                       ),
    //                                     );
    //                                   },
    //                                 ),
    //                               ),
    //                             ],
    //                           );
    //                         }

    //                         return GridView.builder(
    //                           controller: widget.scrollController,
    //                           itemCount: controller.searchFund.length,
    //                           padding: const EdgeInsets.only(
    //                             bottom: 20,
    //                             left: 8,
    //                             right: 8,
    //                             top: 8,
    //                           ),
    //                           gridDelegate:
    //                               SliverGridDelegateWithFixedCrossAxisCount(
    //                                 crossAxisCount: crossAxisCount,
    //                                 crossAxisSpacing: 16,
    //                                 mainAxisSpacing: 16,
    //                                 mainAxisExtent: 170,
    //                               ),
    //                           itemBuilder: (context, index) {
    //                             final fund = controller.searchFund[index];
    //                             return ResponsiveFundCard(
    //                               key: ValueKey(
    //                                 '${fund.schemeCode}_${fund.baseSchemeName}',
    //                               ),
    //                               entity: fund,
    //                               isMobile: crossAxisCount == 1,
    //                             );
    //                           },
    //                         );
    //                       }),
    //                     ),
    //                   ],
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    // return Scaffold(
    //   body: Center(
    //     child: LayoutBuilder(
    //       builder: (context, constraints) {
    //         final double width = constraints.maxWidth;

    //         int getCrossAxisCount() {
    //           if (width > 1100) return 3;
    //           if (width >= 800) return 2;
    //           return 1;
    //         }

    //         final int crossAxisCount = getCrossAxisCount();

    //         return Padding(
    //           padding: const EdgeInsets.all(24),
    //           child: Column(
    //             children: [
    //               // Row(
    //               //   mainAxisAlignment: MainAxisAlignment.end,
    //               //   children: [
    //               //     _viewButton(
    //               //       icon: Icons.grid_view_rounded,
    //               //       isSelected: selectedView == WebFundViewType.grid,
    //               //       onTap: () {
    //               //         setState(() => selectedView = WebFundViewType.grid);
    //               //       },
    //               //     ),
    //               //     const Gap(8),
    //               //     _viewButton(
    //               //       icon: Icons.view_list_rounded,
    //               //       isSelected: selectedView == WebFundViewType.list,
    //               //       onTap: () {
    //               //         setState(() => selectedView = WebFundViewType.list);
    //               //       },
    //               //     ),
    //               //   ],
    //               // ),
    //               AnimatedSize(
    //                 duration: const Duration(milliseconds: 250),
    //                 curve: Curves.easeInOut,
    //                 child: showViewButtons
    //                     ? Row(
    //                         mainAxisAlignment: MainAxisAlignment.end,
    //                         children: [
    //                           _viewButton(
    //                             icon: Icons.grid_view_rounded,
    //                             isSelected:
    //                                 selectedView == WebFundViewType.grid,
    //                             onTap: () {
    //                               setState(
    //                                 () => selectedView = WebFundViewType.grid,
    //                               );
    //                             },
    //                           ),
    //                           const Gap(8),
    //                           _viewButton(
    //                             icon: Icons.view_list_rounded,
    //                             isSelected:
    //                                 selectedView == WebFundViewType.list,
    //                             onTap: () {
    //                               setState(
    //                                 () => selectedView = WebFundViewType.list,
    //                               );
    //                             },
    //                           ),
    //                         ],
    //                       )
    //                     : const SizedBox.shrink(),
    //               ),

    //               if (showViewButtons) const Gap(14),

    //               const Gap(14),

    //               Expanded(
    //                 child: Obx(() {
    //                   if (controller.isLoading.value) {
    //                     return _buildLoadingGrid(crossAxisCount);
    //                   }

    //                   if (controller.searchFund.isEmpty) {
    //                     return _buildEmptyState();
    //                   }

    //                   // if (selectedView == WebFundViewType.list) {
    //                   //   return ListView.builder(
    //                   //     controller: widget.scrollController,
    //                   //     padding: const EdgeInsets.only(bottom: 20),
    //                   //     itemCount: controller.searchFund.length,
    //                   //     itemBuilder: (context, index) {
    //                   //       final fund = controller.searchFund[index];
    //                   //       return WebFundListCard(entity: fund);
    //                   //     },
    //                   //   );
    //                   // }
    //                   // if (selectedView == WebFundViewType.list) {
    //                   //   return Column(
    //                   //     children: [
    //                   //       Container(
    //                   //         height: 50,
    //                   //         padding: const EdgeInsets.symmetric(
    //                   //           horizontal: 18,
    //                   //           vertical: 10,
    //                   //         ),
    //                   //         decoration: BoxDecoration(
    //                   //           color: const Color(0xFFF5F7FA),
    //                   //           borderRadius: BorderRadius.circular(12),
    //                   //           border: Border.all(color: Colors.grey.shade300),
    //                   //         ),
    //                   //         child: Row(
    //                   //           children: [
    //                   //             const SizedBox(width: 40),

    //                   //             const Expanded(
    //                   //               flex: 3,
    //                   //               child: Text(
    //                   //                 "Fund Name",
    //                   //                 style: TextStyle(
    //                   //                   fontWeight: FontWeight.bold,
    //                   //                   fontSize: 13,
    //                   //                 ),
    //                   //               ),
    //                   //             ),

    //                   //             _headerText("1W"),
    //                   //             _headerText("1M"),
    //                   //             _headerText("1Y"),
    //                   //             _headerText("3Y"),
    //                   //             _headerText("5Y"),
    //                   //             _headerText("10Y"),
    //                   //             _headerText("NAV"),

    //                   //             const Expanded(
    //                   //               child: Text(
    //                   //                 "",
    //                   //                 textAlign: TextAlign.center,
    //                   //                 style: TextStyle(
    //                   //                   fontWeight: FontWeight.bold,
    //                   //                   fontSize: 13,
    //                   //                 ),
    //                   //               ),
    //                   //             ),
    //                   //           ],
    //                   //         ),
    //                   //       ),

    //                   //       const SizedBox(height: 8),

    //                   //       Expanded(
    //                   //         child: ListView.builder(
    //                   //           controller: widget.scrollController,
    //                   //           itemCount: controller.searchFund.length,
    //                   //           itemBuilder: (context, index) {
    //                   //             final fund = controller.searchFund[index];
    //                   //             return WebFundListCard(entity: fund);
    //                   //           },
    //                   //         ),
    //                   //       ),
    //                   //     ],
    //                   //   );
    //                   // }
    //                   if (selectedView == WebFundViewType.list) {
    //                     return Column(
    //                       children: [
    //                         _listHeader(),

    //                         const Gap(8),

    //                         Expanded(
    //                           child: ListView.builder(
    //                             controller: widget.scrollController,
    //                             padding: const EdgeInsets.only(bottom: 20),
    //                             itemCount: controller.searchFund.length,
    //                             itemBuilder: (context, index) {
    //                               final fund = controller.searchFund[index];
    //                               return WebFundListCard(
    //                                 entity: fund,
    //                                 key: ValueKey(
    //                                   '${fund.schemeCode}_${fund.baseSchemeName}',
    //                                 ),
    //                               );
    //                             },
    //                           ),
    //                         ),
    //                       ],
    //                     );
    //                   }

    //                   return GridView.builder(
    //                     controller: widget.scrollController,
    //                     itemCount: controller.searchFund.length,
    //                     padding: const EdgeInsets.only(
    //                       bottom: 20,
    //                       left: 8,
    //                       right: 8,
    //                       top: 8,
    //                     ),
    //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                       crossAxisCount: crossAxisCount,
    //                       crossAxisSpacing: 16,
    //                       mainAxisSpacing: 16,
    //                       mainAxisExtent: 170,
    //                     ),
    //                     itemBuilder: (context, index) {
    //                       final fund = controller.searchFund[index];
    //                       return ResponsiveFundCard(
    //                         key: ValueKey(
    //                           '${fund.schemeCode}_${fund.baseSchemeName}',
    //                         ),
    //                         entity: fund,
    //                         isMobile: crossAxisCount == 1,
    //                       );
    //                     },
    //                   );
    //                 }),
    //               ),
    //             ],
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
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
            flex: 2,
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

class _WebFilterTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget trailing;

  const _WebFilterTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Ucolors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Ucolors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Ucolors.dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _WebFilterCategoryTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _WebFilterCategoryTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_box_outline_blank_rounded,
                size: 20,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Ucolors.dark,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebFilterAccordionTitle extends StatelessWidget {
  final String title;

  const _WebFilterAccordionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Ucolors.dark,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}

class WebExploreFilterPanel extends StatelessWidget {
  final FocusNode searchFocus;

  const WebExploreFilterPanel({super.key, required this.searchFocus});

  @override
  Widget build(BuildContext context) {
    final MutualFundController mutualController = Get.find();
    final FundhouseController fundhouseController = Get.find();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.filter, color: Ucolors.primary, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Filters',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Ucolors.dark,
                ),
              ),
              const Spacer(),
              Obx(() {
                final count = fundhouseController.activeFilterCount;
                if (count == 0) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Ucolors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 46,
            child: SearchBar(
              focusNode: searchFocus,
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(Colors.white),
              side: WidgetStateProperty.all(
                BorderSide(color: Colors.grey.shade300),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              leading: const Icon(Icons.search, size: 20, color: Colors.grey),
              hintText: 'Search funds...',
              onChanged: mutualController.onSearchQueryChanged,
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _WebFilterTile(
                    title: 'Index Funds Only',
                    subtitle: 'Showing only index funds in filter',
                    icon: Icons.trending_up,
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {
                        fundhouseController.applyCustomSearch('index');
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  _WebFilterCategoryTile(title: 'Commodities', onTap: () {}),
                  _WebFilterCategoryTile(title: 'Debt', onTap: () {}),
                  _WebFilterCategoryTile(title: 'Equity', onTap: () {}),
                  _WebFilterCategoryTile(title: 'Fund of Funds', onTap: () {}),

                  const SizedBox(height: 18),

                  _WebFilterAccordionTitle(title: 'Risk Profile'),
                  _WebFilterAccordionTitle(title: 'Fund House (AMC)'),
                  _WebFilterAccordionTitle(title: 'Returns Range'),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    fundhouseController.clearAllFilters();
                    mutualController.onSearchQueryChanged('');
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: Ucolors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Reset All',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Ucolors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    fundhouseController.buildParam();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    backgroundColor: Ucolors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isLaptop = width < 1200;
        final bool isSmallLaptop = width < 980;
        final bool isVerySmall = width < 860;

        final bool show10Y = width >= 1050;
        final bool show5Y = width >= 900;

        final double cardHeight = isLaptop ? 94 : 104;
        final double logoSize = isLaptop ? 42 : 48;

        final double actionSize = isLaptop ? 34 : 40;
        final double investWidth = isLaptop ? 96 : 122;
        final double investHeight = isLaptop ? 32 : 38;

        return Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4),
          child: WebHoverRow(
            onTap: () => _openFundDetails(entity),
            builder: (isHovered) {
              return Container(
                height: cardHeight,
                // margin: const EdgeInsets.only(bottom: 8, top: 8),
                padding: EdgeInsets.symmetric(
                  horizontal: isLaptop ? 14 : 18,
                  vertical: isLaptop ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5EAF0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _fundLogo(size: logoSize),

                    SizedBox(width: isLaptop ? 12 : 16),

                    Expanded(
                      flex: isVerySmall ? 34 : 30,
                      child: _fundInfo(
                        isHovered: isHovered,
                        isLaptop: isLaptop,
                      ),
                    ),

                    SizedBox(width: isLaptop ? 8 : 14),

                    Expanded(
                      flex: isVerySmall ? 36 : 42,
                      child: _returnsRow(
                        show5Y: show5Y,
                        show10Y: show10Y,
                        isLaptop: isLaptop,
                      ),
                    ),

                    SizedBox(width: isLaptop ? 8 : 14),

                    _actions(
                      entity,
                      isPressed,
                      actionSize: actionSize,
                      investWidth: investWidth,
                      investHeight: investHeight,
                      isLaptop: isLaptop,
                      isSmallLaptop: isSmallLaptop,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _fundLogo({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade50,
      ),
      child: ClipOval(
        child: CustomCachedImage(
          imageUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
        ),
      ),
    );
  }

  Widget _fundInfo({required bool isHovered, required bool isLaptop}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entity.baseSchemeName ?? 'Unknown Fund',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: isLaptop ? 12.5 : 14,
            fontWeight: FontWeight.w600,
            color: isHovered ? Ucolors.primary : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 5),
        _riskPill(entity.riskLevel, isLaptop: isLaptop),
      ],
    );
  }

  Widget _riskPill(String? riskLevel, {required bool isLaptop}) {
    final risk = getRiskMeter(riskLevel);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLaptop ? 8 : 10,
        vertical: isLaptop ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: risk.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        riskLevel ?? 'N/A',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: FontFamily.medium,
          fontSize: isLaptop ? 10 : 11,
          fontWeight: FontWeight.w500,
          color: Ucolors.darkBlue,
        ),
      ),
    );
  }

  Widget _returnsRow({
    required bool show5Y,
    required bool show10Y,
    required bool isLaptop,
  }) {
    final items = <Widget>[
      Expanded(
        child: _returnColumn(
          '1Y',
          entity.returnsEntity?.oneYear,
          isLaptop: isLaptop,
        ),
      ),
      _divider(isLaptop),
      Expanded(
        child: _returnColumn(
          '3Y',
          entity.returnsEntity?.threeYear,
          isLaptop: isLaptop,
        ),
      ),
    ];

    if (show5Y) {
      items.add(_divider(isLaptop));
      items.add(
        Expanded(
          child: _returnColumn(
            '5Y',
            entity.returnsEntity?.fiveYear,
            isLaptop: isLaptop,
          ),
        ),
      );
    }

    if (show10Y) {
      items.add(_divider(isLaptop));
      items.add(
        Expanded(
          child: _returnColumn(
            '10Y',
            entity.returnsEntity?.tenYear,
            isLaptop: isLaptop,
          ),
        ),
      );
    }

    return Row(children: items);
  }

  Widget _returnColumn(String label, dynamic value, {required bool isLaptop}) {
    final double val =
        double.tryParse(value?.toString().replaceAll('%', '') ?? '0') ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: isLaptop ? 10.5 : 12,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade600,
          ),
        ),
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${val > 0 ? '+' : ''}${val.toStringAsFixed(2)}%',
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: isLaptop ? 12.5 : 14.5,
              fontWeight: FontWeight.w600,
              color: val < 0 ? Colors.redAccent : const Color(0xFF00B85C),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider(bool isLaptop) {
    return Container(
      width: 1,
      height: isLaptop ? 42 : 48,
      margin: EdgeInsets.symmetric(horizontal: isLaptop ? 3 : 6),
      color: Colors.grey.shade200,
    );
  }

  Widget _actions(
    MutualFundListEntity entity,
    RxBool isPressed, {
    required double actionSize,
    required double investWidth,
    required double investHeight,
    required bool isLaptop,
    required bool isSmallLaptop,
  }) {
    return SizedBox(
      width: isLaptop ? 225 : 270,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _wishlistButton(size: actionSize),

          SizedBox(width: isLaptop ? 8 : 12),

          _cartButton(entity, isPressed, size: actionSize),

          SizedBox(width: isLaptop ? 10 : 16),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _investNowButton(
                entity,
                width: isLaptop ? 96 : investWidth,
                height: investHeight,
                isLaptop: isLaptop,
              ),

              const SizedBox(height: 5),

              _viewDetailsButton(isLaptop: isLaptop),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _actions(
  //   MutualFundListEntity entity,
  //   RxBool isPressed, {
  //   required double actionSize,
  //   required double investWidth,
  //   required double investHeight,
  //   required bool isLaptop,
  //   required bool isSmallLaptop,
  // }) {
  //   return SizedBox(
  //     width: isLaptop ? 230 : 270,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         _wishlistButton(size: actionSize),

  //         SizedBox(width: isLaptop ? 8 : 12),

  //         _cartButton(entity, isPressed, size: actionSize),

  //         SizedBox(width: isLaptop ? 10 : 16),

  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             _investNowButton(
  //               entity,
  //               width: investWidth,
  //               height: investHeight,
  //               isLaptop: isLaptop,
  //             ),
  //             const SizedBox(height: 5),
  //             if (!isSmallLaptop) _viewDetailsButton(isLaptop: isLaptop),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _wishlistButton({required double size}) {
    return Obx(() {
      final wishlistController = Get.find<WishlistController>();
      final String code = entity.schemeCode ?? '';
      final String name = entity.baseSchemeName ?? '';
      final bool isFav = wishlistController.isFavorite(code);

      return _squareActionButton(
        size: size,
        child: PremiumHeartButton(
          isFav: isFav,
          onTap: () {
            wishlistController.toggleWishlist(code, name);
          },
        ),
      );
    });
  }

  Widget _squareActionButton({required Widget child, required double size}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
      ),
      child: child,
    );
  }

  Widget _cartButton(
    MutualFundListEntity entity,
    RxBool isPressed, {
    required double size,
  }) {
    return Obx(() {
      final cartController = Get.find<CartController>();
      final String code = entity.schemeCode ?? '';

      final matchingItems = cartController.displayedItems
          .where((item) => item.schemeCode.toString() == code)
          .toList();

      final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
      final bool isInCart = cartItem != null;

      return InkWell(
        onTap: () async {
          if (isPressed.value) return;

          isPressed.value = true;

          try {
            if (isInCart) {
              final itemId = cartItem?.id;

              if (itemId != null) {
                await cartController.deleteCartItem(
                  itemId,
                  entity.schemeCode ?? '',
                );
              }
            } else {
              await cartController.addToCart(
                code,
                entity.baseSchemeName ?? '',
                entity.minSipAmount ?? 5000,
                transType: 'sip',
                null,
              );
            }
          } finally {
            isPressed.value = false;
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
          ),
          child: Icon(
            isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
            size: size <= 36 ? 18 : 21,
            color: Ucolors.primary,
          ),
        ),
      );
    });
  }

  Widget _investNowButton(
    MutualFundListEntity entity, {
    required double width,
    required double height,
    required bool isLaptop,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          GatekeeperHelper.runWithPrerequisites(
            onSuccess: () {
              final purchaseArgs = SipPurchaseArgs(
                schemeCode: entity.schemeCode ?? '',
                fundName: entity.baseSchemeName ?? '',
                category: 'Unknown',
                riskLabel: entity.riskLevel ?? '',
                minSip: entity.minSipAmount ?? 1000,
                minLumpsum: entity.minLumpsum ?? 1000,
                minTopup: entity.minTopUp ?? 5000,
                folio: null,
                imgUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
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
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        child: Text(
          'Invest Now',
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: isLaptop ? 11.5 : 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _viewDetailsButton({required bool isLaptop}) {
    return InkWell(
      onTap: () => _openFundDetails(entity),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View Details',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: isLaptop ? 11 : 12.5,
                fontWeight: FontWeight.w600,
                color: Ucolors.primary,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 10,
              color: Ucolors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _openFundDetails(MutualFundListEntity entity) {
    if (Get.isRegistered<FundDetailsController>()) {
      Get.delete<FundDetailsController>();
    }

    FundDetailsScreen.navData = {
      'scheme': entity.baseSchemeName,
      'imgUrl': '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
      'scheme_code': entity.schemeCode.toString(),
    };

    Get.toNamed(AppRoutes.funddetails, id: 1);
  }
}

// class WebFundListCard extends StatelessWidget {
//   final MutualFundListEntity entity;

//   const WebFundListCard({super.key, required this.entity});

//   @override
//   Widget build(BuildContext context) {
//     final RxBool isPressed = false.obs;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double availableWidth = constraints.maxWidth;

//         /// Keeps the same single-line design.
//         /// If screen is very small, it will not break vertically.
//         final double rowWidth = availableWidth < 980 ? 980 : availableWidth;

//         final bool isLaptop = rowWidth < 1200;
//         final bool isLargeDesktop = rowWidth > 1500;

//         final double cardHeight = isLaptop ? 108 : 118;
//         final double logoSize = isLaptop ? 42 : 50;
//         final double titleFont = isLaptop ? 13 : 15;
//         final double returnFont = isLaptop ? 13 : 16;
//         final double actionBox = isLaptop ? 38 : 44;
//         final double investWidth = isLaptop ? 104 : 126;
//         final double investHeight = isLaptop ? 36 : 40;

//         return WebHoverRow(
//           onTap: () => _openFundDetails(entity),
//           builder: (isHovered) {
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               physics: availableWidth < 980
//                   ? const BouncingScrollPhysics()
//                   : const NeverScrollableScrollPhysics(),
//               child: Container(
//                 width: rowWidth,
//                 height: cardHeight,
//                 margin: const EdgeInsets.only(bottom: 8),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isLaptop ? 16 : 22,
//                   vertical: isLaptop ? 12 : 14,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: const Color(0xFFE5EAF0)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.025),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     /// LOGO
//                     Container(
//                       width: logoSize,
//                       height: logoSize,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey.shade50,
//                       ),
//                       child: ClipOval(
//                         child: CustomCachedImage(
//                           imageUrl:
//                               '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//                         ),
//                       ),
//                     ),

//                     SizedBox(width: isLaptop ? 14 : 18),

//                     /// FUND NAME + RISK
//                     SizedBox(
//                       width: isLargeDesktop
//                           ? 380
//                           : isLaptop
//                           ? 285
//                           : 330,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             entity.baseSchemeName ?? 'Unknown Fund',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontFamily: FontFamily.medium,
//                               fontSize: titleFont,
//                               height: 1.22,
//                               fontWeight: FontWeight.w800,
//                               color: isHovered
//                                   ? Ucolors.primary
//                                   : const Color(0xFF111827),
//                             ),
//                           ),
//                           const SizedBox(height: 7),
//                           _riskPill(entity.riskLevel, isLaptop: isLaptop),
//                         ],
//                       ),
//                     ),

//                     SizedBox(width: isLaptop ? 14 : 24),

//                     /// RETURNS AREA
//                     Expanded(
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _returnColumn(
//                               '1Y',
//                               entity.returnsEntity?.oneYear,
//                               fontSize: returnFont,
//                             ),
//                           ),
//                           _divider(),
//                           Expanded(
//                             child: _returnColumn(
//                               '3Y',
//                               entity.returnsEntity?.threeYear,
//                               fontSize: returnFont,
//                             ),
//                           ),
//                           _divider(),
//                           Expanded(
//                             child: _returnColumn(
//                               '5Y',
//                               entity.returnsEntity?.fiveYear,
//                               fontSize: returnFont,
//                             ),
//                           ),
//                           _divider(),
//                           Expanded(
//                             child: _returnColumn(
//                               '10Y',
//                               entity.returnsEntity?.tenYear,
//                               fontSize: returnFont,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(width: isLaptop ? 16 : 26),

//                     /// ACTIONS
//                     SizedBox(
//                       width: isLaptop ? 255 : 310,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Obx(() {
//                             final wishlistController =
//                                 Get.find<WishlistController>();
//                             final String code = entity.schemeCode ?? '';
//                             final String name = entity.baseSchemeName ?? '';
//                             final bool isFav = wishlistController.isFavorite(
//                               code,
//                             );

//                             return _squareActionButton(
//                               size: actionBox,
//                               child: PremiumHeartButton(
//                                 isFav: isFav,
//                                 onTap: () {
//                                   wishlistController.toggleWishlist(code, name);
//                                 },
//                               ),
//                             );
//                           }),

//                           SizedBox(width: isLaptop ? 10 : 14),

//                           _cartButton(entity, isPressed, size: actionBox),

//                           SizedBox(width: isLaptop ? 14 : 20),

//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               _investNowButton(
//                                 entity,
//                                 width: investWidth,
//                                 height: investHeight,
//                                 isLaptop: isLaptop,
//                               ),
//                               const SizedBox(height: 8),
//                               _viewDetailsButton(isLaptop: isLaptop),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _riskPill(String? riskLevel, {required bool isLaptop}) {
//     final risk = getRiskMeter(riskLevel);

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: isLaptop ? 9 : 11,
//         vertical: isLaptop ? 4 : 5,
//       ),
//       decoration: BoxDecoration(
//         color: risk.color.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         riskLevel ?? 'N/A',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           fontFamily: FontFamily.medium,
//           fontSize: isLaptop ? 10.5 : 11.5,
//           fontWeight: FontWeight.w700,
//           color: Ucolors.darkBlue,
//         ),
//       ),
//     );
//   }

//   Widget _returnColumn(
//     String label,
//     dynamic value, {
//     required double fontSize,
//   }) {
//     final double val =
//         double.tryParse(value?.toString().replaceAll('%', '') ?? '0') ?? 0;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           maxLines: 1,
//           softWrap: false,
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: fontSize - 2,
//             fontWeight: FontWeight.w600,
//             color: Colors.blueGrey.shade600,
//           ),
//         ),
//         const SizedBox(height: 7),
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             '${val > 0 ? '+' : ''}${val.toStringAsFixed(2)}%',
//             maxLines: 1,
//             softWrap: false,
//             style: TextStyle(
//               fontFamily: FontFamily.medium,
//               fontSize: fontSize,
//               fontWeight: FontWeight.w800,
//               color: val < 0 ? Colors.redAccent : const Color(0xFF00B85C),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _divider() {
//     return Container(
//       width: 1,
//       height: 48,
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       color: Colors.grey.shade200,
//     );
//   }

//   Widget _squareActionButton({required Widget child, required double size}) {
//     return Container(
//       width: size,
//       height: size,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(9),
//         border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
//       ),
//       child: child,
//     );
//   }

//   Widget _cartButton(
//     MutualFundListEntity entity,
//     RxBool isPressed, {
//     required double size,
//   }) {
//     return Obx(() {
//       final cartController = Get.find<CartController>();
//       final String code = entity.schemeCode ?? '';

//       final matchingItems = cartController.displayedItems
//           .where((item) => item.schemeCode.toString() == code)
//           .toList();

//       final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
//       final bool isInCart = cartItem != null;

//       return InkWell(
//         onTap: () async {
//           if (isPressed.value) return;

//           isPressed.value = true;

//           try {
//             if (isInCart) {
//               final itemId = cartItem?.id;

//               if (itemId != null) {
//                 await cartController.deleteCartItem(
//                   itemId,
//                   entity.schemeCode ?? '',
//                 );
//               }
//             } else {
//               await cartController.addToCart(
//                 code,
//                 entity.baseSchemeName ?? '',
//                 entity.minSipAmount ?? 5000,
//                 transType: 'sip',
//                 null,
//               );
//             }
//           } finally {
//             isPressed.value = false;
//           }
//         },
//         borderRadius: BorderRadius.circular(9),
//         child: Container(
//           width: size,
//           height: size,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(9),
//             border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
//           ),
//           child: Icon(
//             isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
//             size: size <= 38 ? 19 : 22,
//             color: Ucolors.primary,
//           ),
//         ),
//       );
//     });
//   }

//   Widget _investNowButton(
//     MutualFundListEntity entity, {
//     required double width,
//     required double height,
//     required bool isLaptop,
//   }) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: ElevatedButton(
//         onPressed: () {
//           GatekeeperHelper.runWithPrerequisites(
//             onSuccess: () {
//               final purchaseArgs = SipPurchaseArgs(
//                 schemeCode: entity.schemeCode ?? '',
//                 fundName: entity.baseSchemeName ?? '',
//                 category: 'Unknown',
//                 riskLabel: entity.riskLevel ?? '',
//                 minSip: entity.minSipAmount ?? 1000,
//                 minLumpsum: entity.minLumpsum ?? 1000,
//                 minTopup: entity.minTopUp ?? 5000,
//                 folio: null,
//                 imgUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//               );

//               SIPPurchasePage.tempData = purchaseArgs;

//               Get.toNamed(
//                 AppRoutes.investNowPage,
//                 id: kIsWeb ? 1 : null,
//                 arguments: purchaseArgs,
//               );
//             },
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Ucolors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           padding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
//         ),
//         child: Text(
//           'Invest Now',
//           maxLines: 1,
//           softWrap: false,
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: isLaptop ? 12 : 14,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _viewDetailsButton({required bool isLaptop}) {
//     return InkWell(
//       onTap: () => _openFundDetails(entity),
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'View Details',
//               maxLines: 1,
//               softWrap: false,
//               style: TextStyle(
//                 fontFamily: FontFamily.medium,
//                 fontSize: isLaptop ? 12 : 13,
//                 fontWeight: FontWeight.w700,
//                 color: Ucolors.primary,
//               ),
//             ),
//             const SizedBox(width: 7),
//             const Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 11,
//               color: Ucolors.primary,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _openFundDetails(MutualFundListEntity entity) {
//     if (Get.isRegistered<FundDetailsController>()) {
//       Get.delete<FundDetailsController>();
//     }

//     FundDetailsScreen.navData = {
//       'scheme': entity.baseSchemeName,
//       'imgUrl': '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//       'scheme_code': entity.schemeCode.toString(),
//     };

//     Get.toNamed(AppRoutes.funddetails, id: 1);
//   }
// }

// class WebFundListCard extends StatelessWidget {
//   final MutualFundListEntity entity;

//   const WebFundListCard({super.key, required this.entity});

//   @override
//   Widget build(BuildContext context) {
//     final RxBool isPressed = false.obs;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth;

//         final bool isCompact = width < 1050;
//         final bool isSmallLaptop = width < 1250;

//         return WebHoverRow(
//           onTap: () => _openFundDetails(entity),
//           builder: (isHovered) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: EdgeInsets.symmetric(
//                 horizontal: isCompact ? 16 : 22,
//                 vertical: isCompact ? 16 : 18,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.grey.shade200),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.035),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: isCompact
//                   ? _compactLayout(isHovered, isPressed)
//                   : _wideLayout(isHovered, isPressed, isSmallLaptop),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _wideLayout(bool isHovered, RxBool isPressed, bool isSmallLaptop) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _fundLogo(size: isSmallLaptop ? 52 : 58),

//         SizedBox(width: isSmallLaptop ? 16 : 22),

//         Expanded(flex: isSmallLaptop ? 3 : 4, child: _fundInfo(isHovered)),

//         SizedBox(width: isSmallLaptop ? 14 : 24),

//         Expanded(flex: isSmallLaptop ? 5 : 6, child: _returnsRow()),

//         SizedBox(width: isSmallLaptop ? 16 : 28),

//         _actionButtons(isPressed, compact: isSmallLaptop),
//       ],
//     );
//   }

//   Widget _compactLayout(bool isHovered, RxBool isPressed) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             _fundLogo(size: 52),
//             const SizedBox(width: 14),
//             Expanded(child: _fundInfo(isHovered)),
//             const SizedBox(width: 12),
//             _miniActions(isPressed),
//           ],
//         ),

//         const SizedBox(height: 16),

//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF8FAFC),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: _returnsRow(),
//         ),

//         const SizedBox(height: 14),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _viewDetailsButton(),
//             _investNowButton(entity, width: 132, height: 40),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _fundLogo({required double size}) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.grey.shade50,
//       ),
//       child: ClipOval(
//         child: CustomCachedImage(
//           imageUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//         ),
//       ),
//     );
//   }

//   Widget _fundInfo(bool isHovered) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           entity.baseSchemeName ?? 'Unknown Fund',
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: 16,
//             height: 1.25,
//             fontWeight: FontWeight.w800,
//             color: isHovered ? Ucolors.primary : const Color(0xFF111827),
//           ),
//         ),
//         const SizedBox(height: 8),
//         _riskPill(entity.riskLevel),
//       ],
//     );
//   }

//   Widget _returnsRow() {
//     return Row(
//       children: [
//         Expanded(child: _returnColumn('1Y', entity.returnsEntity?.oneYear)),
//         _divider(),
//         Expanded(child: _returnColumn('3Y', entity.returnsEntity?.threeYear)),
//         _divider(),
//         Expanded(child: _returnColumn('5Y', entity.returnsEntity?.fiveYear)),
//         _divider(),
//         Expanded(child: _returnColumn('10Y', entity.returnsEntity?.tenYear)),
//       ],
//     );
//   }

//   Widget _actionButtons(RxBool isPressed, {required bool compact}) {
//     return SizedBox(
//       width: compact ? 265 : 310,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _wishlistButton(),
//           SizedBox(width: compact ? 12 : 16),
//           _cartButton(entity, isPressed),
//           SizedBox(width: compact ? 16 : 22),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               _investNowButton(
//                 entity,
//                 width: compact ? 120 : 145,
//                 height: compact ? 40 : 45,
//               ),
//               const SizedBox(height: 10),
//               _viewDetailsButton(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _miniActions(RxBool isPressed) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _wishlistButton(size: 42),
//         const SizedBox(width: 10),
//         _cartButton(entity, isPressed, size: 42),
//       ],
//     );
//   }

//   Widget _wishlistButton({double size = 48}) {
//     return Obx(() {
//       final wishlistController = Get.find<WishlistController>();
//       final String code = entity.schemeCode ?? '';
//       final String name = entity.baseSchemeName ?? '';
//       final bool isFav = wishlistController.isFavorite(code);

//       return _squareActionButton(
//         size: size,
//         child: PremiumHeartButton(
//           isFav: isFav,
//           onTap: () {
//             wishlistController.toggleWishlist(code, name);
//           },
//         ),
//       );
//     });
//   }

//   Widget _riskPill(String? riskLevel) {
//     final risk = getRiskMeter(riskLevel);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
//       decoration: BoxDecoration(
//         color: risk.color.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         riskLevel ?? 'N/A',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(
//           fontFamily: FontFamily.medium,
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           color: Ucolors.darkBlue,
//         ),
//       ),
//     );
//   }

//   Widget _returnColumn(String label, dynamic value) {
//     final double val =
//         double.tryParse(value?.toString().replaceAll('%', '') ?? '0') ?? 0;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           maxLines: 1,
//           softWrap: false,
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Colors.blueGrey.shade600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Text(
//             '${val > 0 ? '+' : ''}${val.toStringAsFixed(2)}%',
//             maxLines: 1,
//             softWrap: false,
//             style: TextStyle(
//               fontFamily: FontFamily.medium,
//               fontSize: 17,
//               fontWeight: FontWeight.w800,
//               color: val < 0 ? Colors.redAccent : const Color(0xFF00B85C),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _divider() {
//     return Container(
//       width: 1,
//       height: 48,
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       color: Colors.grey.shade200,
//     );
//   }

//   Widget _squareActionButton({required Widget child, double size = 48}) {
//     return Container(
//       width: size,
//       height: size,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(9),
//         border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
//       ),
//       child: child,
//     );
//   }

//   Widget _cartButton(
//     MutualFundListEntity entity,
//     RxBool isPressed, {
//     double size = 48,
//   }) {
//     return Obx(() {
//       final cartController = Get.find<CartController>();
//       final String code = entity.schemeCode ?? '';

//       final matchingItems = cartController.displayedItems
//           .where((item) => item.schemeCode.toString() == code)
//           .toList();

//       final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
//       final bool isInCart = cartItem != null;

//       return InkWell(
//         onTap: () async {
//           if (isPressed.value) return;

//           isPressed.value = true;

//           try {
//             if (isInCart) {
//               final itemId = cartItem?.id;

//               if (itemId != null) {
//                 await cartController.deleteCartItem(
//                   itemId,
//                   entity.schemeCode ?? '',
//                 );
//               }
//             } else {
//               await cartController.addToCart(
//                 code,
//                 entity.baseSchemeName ?? '',
//                 entity.minSipAmount ?? 5000,
//                 transType: 'sip',
//                 null,
//               );
//             }
//           } finally {
//             isPressed.value = false;
//           }
//         },
//         borderRadius: BorderRadius.circular(9),
//         child: Container(
//           width: size,
//           height: size,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(9),
//             border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
//           ),
//           child: Icon(
//             isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
//             size: size <= 42 ? 21 : 24,
//             color: Ucolors.primary,
//           ),
//         ),
//       );
//     });
//   }

//   Widget _investNowButton(
//     MutualFundListEntity entity, {
//     required double width,
//     required double height,
//   }) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: ElevatedButton(
//         onPressed: () {
//           GatekeeperHelper.runWithPrerequisites(
//             onSuccess: () {
//               final purchaseArgs = SipPurchaseArgs(
//                 schemeCode: entity.schemeCode ?? '',
//                 fundName: entity.baseSchemeName ?? '',
//                 category: 'Unknown',
//                 riskLabel: entity.riskLevel ?? '',
//                 minSip: entity.minSipAmount ?? 1000,
//                 minLumpsum: entity.minLumpsum ?? 1000,
//                 minTopup: entity.minTopUp ?? 5000,
//                 folio: null,
//                 imgUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//               );

//               SIPPurchasePage.tempData = purchaseArgs;

//               Get.toNamed(
//                 AppRoutes.investNowPage,
//                 id: kIsWeb ? 1 : null,
//                 arguments: purchaseArgs,
//               );
//             },
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Ucolors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           padding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
//         ),
//         child: Text(
//           'Invest Now',
//           maxLines: 1,
//           softWrap: false,
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: height < 42 ? 13 : 15,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _viewDetailsButton() {
//     return InkWell(
//       onTap: () => _openFundDetails(entity),
//       borderRadius: BorderRadius.circular(8),
//       child: const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'View Details',
//               maxLines: 1,
//               softWrap: false,
//               style: TextStyle(
//                 fontFamily: FontFamily.medium,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: Ucolors.primary,
//               ),
//             ),
//             SizedBox(width: 8),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 12,
//               color: Ucolors.primary,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _openFundDetails(MutualFundListEntity entity) {
//     Get.delete<FundDetailsController>();

//     FundDetailsScreen.navData = {
//       'scheme': entity.baseSchemeName,
//       'imgUrl': '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//       'scheme_code': entity.schemeCode.toString(),
//     };

//     Get.toNamed(AppRoutes.funddetails, id: 1);
//   }
// }

// class WebFundListCard extends StatelessWidget {
//   final MutualFundListEntity entity;

//   const WebFundListCard({super.key, required this.entity});

//   @override
//   Widget build(BuildContext context) {
//     final RxBool isPressed = false.obs;

//     return WebHoverRow(
//       onTap: () => _openFundDetails(entity),
//       builder: (isHovered) {
//         return Container(
//           height: 118,
//           margin: const EdgeInsets.only(bottom: 0),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border(
//               bottom: BorderSide(color: Colors.grey.shade200, width: 1),
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               /// LOGO
//               Container(
//                 width: 58,
//                 height: 58,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey.shade50,
//                 ),
//                 child: ClipOval(
//                   child: CustomCachedImage(
//                     imageUrl:
//                         '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 22),

//               /// FUND NAME + RISK
//               SizedBox(
//                 width: 360,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       entity.baseSchemeName ?? 'Unknown Fund',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontFamily: FontFamily.medium,
//                         fontSize: 17,
//                         height: 1.28,
//                         fontWeight: FontWeight.w800,
//                         color: isHovered
//                             ? Ucolors.primary
//                             : const Color(0xFF111827),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     _riskPill(entity.riskLevel),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 26),

//               /// RETURNS
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _returnColumn('1Y', entity.returnsEntity?.oneYear),
//                     ),
//                     _divider(),
//                     Expanded(
//                       child: _returnColumn(
//                         '3Y',
//                         entity.returnsEntity?.threeYear,
//                       ),
//                     ),
//                     _divider(),
//                     Expanded(
//                       child: _returnColumn(
//                         '5Y',
//                         entity.returnsEntity?.fiveYear,
//                       ),
//                     ),
//                     _divider(),
//                     Expanded(
//                       child: _returnColumn(
//                         '10Y',
//                         entity.returnsEntity?.tenYear,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 34),

//               /// ACTIONS
//               SizedBox(
//                 width: 330,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Obx(() {
//                       final wishlistController = Get.find<WishlistController>();
//                       final String code = entity.schemeCode ?? '';
//                       final String name = entity.baseSchemeName ?? '';
//                       final bool isFav = wishlistController.isFavorite(code);

//                       return _squareActionButton(
//                         child: PremiumHeartButton(
//                           isFav: isFav,
//                           onTap: () {
//                             wishlistController.toggleWishlist(code, name);
//                           },
//                         ),
//                       );
//                     }),

//                     const SizedBox(width: 18),

//                     _cartButton(entity, isPressed),

//                     const SizedBox(width: 24),

//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         _investNowButton(entity),
//                         const SizedBox(height: 12),
//                         InkWell(
//                           onTap: () => _openFundDetails(entity),
//                           borderRadius: BorderRadius.circular(8),
//                           child: const Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 4,
//                               vertical: 2,
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   'View Details',
//                                   style: TextStyle(
//                                     fontFamily: FontFamily.medium,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w700,
//                                     color: Ucolors.primary,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Icon(
//                                   Icons.arrow_forward_ios_rounded,
//                                   size: 13,
//                                   color: Ucolors.primary,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _riskPill(String? riskLevel) {
//     final risk = getRiskMeter(riskLevel);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//       decoration: BoxDecoration(
//         color: risk.color.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         riskLevel ?? 'N/A',
//         style: TextStyle(
//           fontFamily: FontFamily.medium,
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           color: Ucolors.darkBlue,
//         ),
//       ),
//     );
//   }

//   Widget _returnColumn(String label, dynamic value) {
//     final double val =
//         double.tryParse(value?.toString().replaceAll('%', '') ?? '0') ?? 0;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.blueGrey.shade600,
//           ),
//         ),
//         const SizedBox(height: 9),
//         Text(
//           '${val > 0 ? '+' : ''}${val.toStringAsFixed(2)}%',
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: 18,
//             fontWeight: FontWeight.w800,
//             color: val < 0 ? Colors.redAccent : const Color(0xFF00B85C),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _divider() {
//     return Container(width: 1, height: 54, color: Colors.grey.shade200);
//   }

//   Widget _squareActionButton({required Widget child}) {
//     return Container(
//       width: 48,
//       height: 48,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(9),
//         border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
//       ),
//       child: child,
//     );
//   }

//   Widget _cartButton(MutualFundListEntity entity, RxBool isPressed) {
//     return Obx(() {
//       final cartController = Get.find<CartController>();
//       final String code = entity.schemeCode ?? '';

//       final matchingItems = cartController.displayedItems
//           .where((item) => item.schemeCode.toString() == code)
//           .toList();

//       final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
//       final bool isInCart = cartItem != null;

//       return InkWell(
//         onTap: () async {
//           if (isPressed.value) return;

//           isPressed.value = true;

//           try {
//             if (isInCart) {
//               final itemId = cartItem?.id;

//               if (itemId != null) {
//                 await cartController.deleteCartItem(
//                   itemId,
//                   entity.schemeCode ?? '',
//                 );
//               }
//             } else {
//               await cartController.addToCart(
//                 code,
//                 entity.baseSchemeName ?? '',
//                 entity.minSipAmount ?? 5000,
//                 transType: 'sip',
//                 null,
//               );
//             }
//           } finally {
//             isPressed.value = false;
//           }
//         },
//         borderRadius: BorderRadius.circular(9),
//         child: Container(
//           width: 48,
//           height: 48,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(9),
//             border: Border.all(color: const Color(0xFFD8DEE8), width: 1),
//           ),
//           child: Icon(
//             isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
//             size: 25,
//             color: isInCart ? Ucolors.primary : Ucolors.primary,
//           ),
//         ),
//       );
//     });
//   }

//   Widget _investNowButton(MutualFundListEntity entity) {
//     return SizedBox(
//       width: 145,
//       height: 45,
//       child: ElevatedButton(
//         onPressed: () {
//           GatekeeperHelper.runWithPrerequisites(
//             onSuccess: () {
//               final purchaseArgs = SipPurchaseArgs(
//                 schemeCode: entity.schemeCode ?? '',
//                 fundName: entity.baseSchemeName ?? '',
//                 category: 'Unknown',
//                 riskLabel: entity.riskLevel ?? '',
//                 minSip: entity.minSipAmount ?? 1000,
//                 minLumpsum: entity.minLumpsum ?? 1000,
//                 minTopup: entity.minTopUp ?? 5000,
//                 folio: null,
//                 imgUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//               );

//               SIPPurchasePage.tempData = purchaseArgs;

//               Get.toNamed(
//                 AppRoutes.investNowPage,
//                 id: kIsWeb ? 1 : null,
//                 arguments: purchaseArgs,
//               );
//             },
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Ucolors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           padding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
//         ),
//         child: const Text(
//           'Invest Now',
//           style: TextStyle(
//             fontFamily: FontFamily.medium,
//             fontSize: 15,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   void _openFundDetails(MutualFundListEntity entity) {
//     Get.delete<FundDetailsController>();

//     FundDetailsScreen.navData = {
//       'scheme': entity.baseSchemeName,
//       'imgUrl': '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
//       'scheme_code': entity.schemeCode.toString(),
//     };

//     Get.toNamed(AppRoutes.funddetails, id: 1);
//   }
// }

// class WebFundListCard extends StatelessWidget {
//   final MutualFundListEntity entity;

//   const WebFundListCard({super.key, required this.entity});

//   @override
//   Widget build(BuildContext context) {
//     final RxBool isPressed = false.obs;
//     return WebHoverRow(
//       onTap: () {
//         Get.delete<FundDetailsController>();
//         FundDetailsScreen.navData = {
//           'scheme': entity.baseSchemeName,
//           'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
//           'scheme_code': entity.schemeCode.toString(),
//         };

//         Get.toNamed(AppRoutes.funddetails, id: 1);
//       },
//       builder: (isHovered) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.transparent,
//                 child: ClipOval(
//                   child: CustomCachedImage(
//                     imageUrl: "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
//                   ),
//                 ),
//               ),

//               const Gap(14),

//               Expanded(
//                 flex: 4,
//                 child: Text(
//                   entity.baseSchemeName ?? 'Unknown Fund',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: isHovered ? Ucolors.primary : Colors.black87,
//                   ),
//                 ),
//               ),

//               // Expanded(child: _valueText(entity.returnsEntity?.oneWeek)),
//               Expanded(child: _valueText(entity.returnsEntity?.oneMonth)),
//               Expanded(child: _valueText(entity.returnsEntity?.oneYear)),
//               Expanded(child: _valueText(entity.returnsEntity?.threeYear)),
//               Expanded(child: _valueText(entity.returnsEntity?.fiveYear)),
//               Expanded(child: _valueText(entity.returnsEntity?.tenYear)),
//               Expanded(child: _navValue(entity.nav)),

//               const Gap(12),

//               // _riskChip(entity),
//               Expanded(
//                 flex: 2,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Obx(() {
//                       final wishlistController = Get.find<WishlistController>();
//                       final String code = entity.schemeCode ?? '';
//                       final String name = entity.baseSchemeName ?? "";
//                       final bool isFav = wishlistController.isFavorite(code);

//                       return PremiumHeartButton(
//                         isFav: isFav,
//                         onTap: () =>
//                             wishlistController.toggleWishlist(code, name),
//                       );
//                     }),
//                     Obx(() {
//                       final cartController = Get.find<CartController>();
//                       final String code = entity.schemeCode ?? "";

//                       final matchingItems = cartController.displayedItems
//                           .where((item) => item.schemeCode.toString() == code)
//                           .toList();

//                       final cartItem = matchingItems.isNotEmpty
//                           ? matchingItems.first
//                           : null;
//                       final bool isInCart = cartItem != null;

//                       return AnimatedScale(
//                         // A more dramatic shrink when processing, with a 'pull back' curve
//                         scale: isPressed.value ? 0.6 : 1.0,
//                         duration: const Duration(milliseconds: 200),
//                         curve: Curves.easeInBack,

//                         child: AnimatedSwitcher(
//                           // Extended duration to let the elastic spring finish its movement
//                           duration: const Duration(milliseconds: 650),
//                           switchInCurve: Curves
//                               .elasticOut, // The secret sauce for the bouncy feel
//                           switchOutCurve: Curves.easeOut,

//                           transitionBuilder: (child, animation) {
//                             return ScaleTransition(
//                               scale: animation,
//                               // Adds a dynamic 180-degree flip as it scales in
//                               child: RotationTransition(
//                                 turns: Tween<double>(
//                                   begin: 0.5,
//                                   end: 1.0,
//                                 ).animate(animation),
//                                 child: FadeTransition(
//                                   opacity: animation,
//                                   child: child,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: CompactIcon(
//                             key: ValueKey<bool>(isInCart),
//                             icon: isInCart
//                                 ? Iconsax.shopping_cart5
//                                 : Iconsax.shopping_cart,
//                             iconColor: isInCart
//                                 ? Ucolors.primary
//                                 : Ucolors.darkgrey,

//                             onPressed: () async {
//                               if (isPressed.value) return;

//                               isPressed.value = true;

//                               try {
//                                 if (isInCart) {
//                                   final itemId = cartItem?.id;
//                                   if (itemId != null) {
//                                     await cartController.deleteCartItem(
//                                       itemId,
//                                       entity.schemeCode ?? "",
//                                     );
//                                   }
//                                 } else {
//                                   await cartController.addToCart(
//                                     code,
//                                     entity.baseSchemeName ?? "",
//                                     entity.minSipAmount ?? 5000,
//                                     transType: 'sip',
//                                     null,
//                                   );
//                                 }
//                               } finally {
//                                 isPressed.value = false;
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                     }),
//                     SizedBox(
//                       height: 34,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           GatekeeperHelper.runWithPrerequisites(
//                             onSuccess: () {
//                               final purchaseArgs = SipPurchaseArgs(
//                                 schemeCode: entity.schemeCode ?? '',
//                                 fundName: entity.baseSchemeName ?? '',
//                                 category: "Unknown",
//                                 riskLabel: entity.riskLevel ?? "",
//                                 minSip: entity.minSipAmount ?? 1000,
//                                 minLumpsum: entity.minLumpsum ?? 1000,
//                                 minTopup: entity.minTopUp ?? 5000,
//                                 folio: null,
//                                 imgUrl:
//                                     '${Appurl.baseUrl}${entity.amc?.amcLogoUrl}',
//                               );

//                               SIPPurchasePage.tempData = purchaseArgs;

//                               Get.toNamed(
//                                 AppRoutes.investNowPage,
//                                 id: kIsWeb ? 1 : null,
//                                 arguments: purchaseArgs,
//                               );
//                             },
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Ucolors.primary,
//                           foregroundColor: Colors.white,
//                           padding: EdgeInsets.zero,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           "Invest",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _valueText(dynamic value) {
//     final double val = double.tryParse(value?.toString() ?? '0') ?? 0;

//     return Center(
//       child: Text(
//         "${val > 0 ? '+' : ''}$val%",
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: val < 0 ? Colors.redAccent : const Color(0xFF00C853),
//         ),
//       ),
//     );
//   }

//   Widget _navValue(dynamic value) {
//     return Center(
//       child: Text(
//         value?.toString() ?? "N/A",
//         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//       ),
//     );
//   }

//   Widget _riskChip(MutualFundListEntity entity) {
//     final risk = getRiskMeter(entity.riskLevel);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//       decoration: BoxDecoration(
//         color: risk.color.withValues(alpha: .10),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         entity.riskLevel ?? "N/A",
//         style: TextStyle(
//           color: risk.color,
//           fontWeight: FontWeight.bold,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }
// }

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
                          : Colors.black.withValues(alpha: .15),
                    ),
                  ],
                ),

                // child: widget.isMobile
                //     ? _buildMobileLayout(controller)
                //     : _buildDesktopLayout(controller, mutualFundController),
                child: _buildDesktopLayout(controller, mutualFundController),
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
    final RxBool isPressed = false.obs;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipOval(
                  child: CustomCachedImage(
                    imageUrl:
                        '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
                  ),
                ),
              ),

              const Gap(14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity.baseSchemeName ?? 'Unknown Fund',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const Gap(8),

                    _webRiskPill(entity.riskLevel),
                  ],
                ),
              ),

              const Gap(10),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    final wishlistController = Get.find<WishlistController>();
                    final String code = entity.schemeCode ?? '';
                    final String name = entity.baseSchemeName ?? '';
                    final bool isFav = wishlistController.isFavorite(code);

                    return PremiumHeartButton(
                      isFav: isFav,
                      onTap: () =>
                          wishlistController.toggleWishlist(code, name),
                    );
                  }),

                  const Gap(10),

                  _webCartButton(entity, isPressed),
                ],
              ),
            ],
          ),

          const Gap(14),

          Divider(height: 1, color: Colors.grey.shade200),

          const Gap(10),

          /// RETURNS ROW
          Row(
            children: [
              Expanded(
                child: _webReturnItem('1Y', entity.returnsEntity?.oneYear),
              ),
              _verticalDivider(),
              Expanded(
                child: _webReturnItem('3Y', entity.returnsEntity?.threeYear),
              ),
              _verticalDivider(),
              Expanded(
                child: _webReturnItem('5Y', entity.returnsEntity?.fiveYear),
              ),
              _verticalDivider(),
              Expanded(
                child: _webReturnItem('10Y', entity.returnsEntity?.tenYear),
              ),
            ],
          ),

          const Gap(10),
          Divider(height: 1, color: Colors.grey.shade200),

          // const Gap(10),
          const Spacer(),

          /// BOTTOM ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _openFundDetails(entity);
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Ucolors.primary,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: Ucolors.primary,
                      ),
                    ],
                  ),
                ),
              ),

              _webInvestNowButton(controller, entity),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildDesktopLayout(
  //   CartController controller,
  //   MutualFundController mutualFundController,
  // ) {
  //   final entity = widget.entity;

  //   final double width = MediaQuery.of(context).size.width;

  //   double scale(double baseSize) =>
  //       (baseSize * (width / 1200)).clamp(baseSize * 0.8, baseSize * 1.1);
  //   final RxBool isPressed = false.obs;

  //   return GestureDetector(
  //     onTap: () {
  //       Get.delete<FundDetailsController>();
  //       FundDetailsScreen.navData = {
  //         'scheme': entity.baseSchemeName,
  //         'imgUrl': "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}" ?? '',
  //         'scheme_code': entity.schemeCode.toString(),
  //       };

  //       Get.toNamed(AppRoutes.funddetails, id: 1);
  //     },
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   AnimatedContainer(
  //                     duration: const Duration(milliseconds: 250),
  //                     width: scale(isHover ? 38 : 32),
  //                     height: scale(isHover ? 38 : 32),
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       boxShadow: isHover
  //                           ? [
  //                               BoxShadow(
  //                                 blurRadius: 10,
  //                                 color: Ucolors.primary.withValues(alpha: .18),
  //                               ),
  //                             ]
  //                           : [],
  //                     ),
  //                     child: ClipOval(
  //                       child: CustomCachedImage(
  //                         imageUrl:
  //                             "${Appurl.baseUrl}${entity.amc?.amcLogoUrl}",
  //                       ),
  //                     ),
  //                   ),
  //                   Gap(scale(12)),
  //                   Expanded(
  //                     child: AnimatedDefaultTextStyle(
  //                       duration: const Duration(milliseconds: 220),
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: scale(isHover ? 16 : 15),
  //                         color: isHover
  //                             ? Ucolors.primary
  //                             : const Color(0xff383838),
  //                       ),
  //                       child: Text(
  //                         entity.baseSchemeName ?? 'Unknown Fund',
  //                         maxLines: 3,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Gap(scale(12)),
  //               Padding(
  //                 padding: EdgeInsets.only(left: scale(44)),
  //                 child: RichText(
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                         text: 'Risk: ',
  //                         style: TextStyle(
  //                           fontSize: scale(12),
  //                           color: Colors.grey.shade600,
  //                         ),
  //                       ),
  //                       TextSpan(
  //                         text: entity.riskLevel ?? 'N/A',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.w700,
  //                           fontSize: scale(12),
  //                           color: getRiskMeter(entity.riskLevel).color,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Gap(scale(8)),
  //               Padding(
  //                 padding: EdgeInsets.only(left: scale(44)),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     _miniReturnRow(
  //                       "1Y",
  //                       entity.returnsEntity?.oneYear,
  //                       scale,
  //                     ),
  //                     Gap(scale(12)),
  //                     _miniReturnRow(
  //                       "3Y",
  //                       entity.returnsEntity?.threeYear,
  //                       scale,
  //                     ),
  //                     Gap(scale(12)),
  //                     _miniReturnRow(
  //                       "5Y",
  //                       entity.returnsEntity?.fiveYear,
  //                       scale,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Gap(scale(12)),

  //         // Right side: Icons + Invest Button stacked
  //         // Right side: Icons + Invest Button stacked
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             // Wishlist & Cart Icons
  //             Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Wishlist Icon
  //                 Obx(() {
  //                   final wishlistController = Get.find<WishlistController>();
  //                   final String code = entity.schemeCode ?? '';
  //                   final String name = entity.baseSchemeName ?? "";
  //                   final bool isFav = wishlistController.isFavorite(code);

  //                   return PremiumHeartButton(
  //                     isFav: isFav,
  //                     onTap: () =>
  //                         wishlistController.toggleWishlist(code, name),
  //                   );
  //                 }),

  //                 Gap(scale(12)),

  //                 // Add to Cart / Go to Cart Icon
  //                 // Add to Cart / Go to Cart Icon
  //                 Obx(() {
  //                   final cartController = Get.find<CartController>();
  //                   final String code = entity.schemeCode ?? "";

  //                   final matchingItems = cartController.displayedItems
  //                       .where((item) => item.schemeCode.toString() == code)
  //                       .toList();

  //                   final cartItem = matchingItems.isNotEmpty
  //                       ? matchingItems.first
  //                       : null;
  //                   final bool isInCart = cartItem != null;

  //                   return AnimatedScale(
  //                     // A more dramatic shrink when processing, with a 'pull back' curve
  //                     scale: isPressed.value ? 0.6 : 1.0,
  //                     duration: const Duration(milliseconds: 200),
  //                     curve: Curves.easeInBack,

  //                     child: AnimatedSwitcher(
  //                       // Extended duration to let the elastic spring finish its movement
  //                       duration: const Duration(milliseconds: 650),
  //                       switchInCurve: Curves
  //                           .elasticOut, // The secret sauce for the bouncy feel
  //                       switchOutCurve: Curves.easeOut,

  //                       transitionBuilder: (child, animation) {
  //                         return ScaleTransition(
  //                           scale: animation,
  //                           // Adds a dynamic 180-degree flip as it scales in
  //                           child: RotationTransition(
  //                             turns: Tween<double>(
  //                               begin: 0.5,
  //                               end: 1.0,
  //                             ).animate(animation),
  //                             child: FadeTransition(
  //                               opacity: animation,
  //                               child: child,
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       child: CompactIcon(
  //                         key: ValueKey<bool>(isInCart),
  //                         icon: isInCart
  //                             ? Iconsax.shopping_cart5
  //                             : Iconsax.shopping_cart,
  //                         iconColor: isInCart
  //                             ? Ucolors.primary
  //                             : Ucolors.darkgrey,

  //                         onPressed: () async {
  //                           if (isPressed.value) return;

  //                           isPressed.value = true;

  //                           try {
  //                             if (isInCart) {
  //                               final itemId = cartItem?.id;
  //                               if (itemId != null) {
  //                                 await cartController.deleteCartItem(
  //                                   itemId,
  //                                   entity.schemeCode ?? "",
  //                                 );
  //                               }
  //                             } else {
  //                               await cartController.addToCart(
  //                                 code,
  //                                 entity.baseSchemeName ?? "",
  //                                 entity.minSipAmount ?? 5000,
  //                                 transType: 'sip',
  //                                 null,
  //                               );
  //                             }
  //                           } finally {
  //                             isPressed.value = false;
  //                           }
  //                         },
  //                       ),
  //                     ),
  //                   );
  //                 }),
  //               ],
  //             ),

  //             Gap(scale(12)),

  //             // Original Invest Button
  //             AnimatedScale(
  //               scale: isHover ? 1.04 : 1,
  //               duration: const Duration(milliseconds: 220),
  //               child: _investButton(controller, entity, scale),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _webRiskPill(String? riskLevel) {
    final risk = getRiskMeter(riskLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: risk.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        riskLevel ?? 'N/A',
        style: TextStyle(
          fontFamily: FontFamily.medium,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _webReturnItem(String title, dynamic value) {
    final double val =
        double.tryParse(value?.toString().replaceAll('%', '') ?? '0') ?? 0;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(4),
        Text(
          '${val > 0 ? '+' : ''}${val.toStringAsFixed(2)}%',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: val < 0 ? Colors.redAccent : const Color(0xFF00A85A),
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 34, width: 1, color: Colors.grey.shade200);
  }

  Widget _webCartButton(MutualFundListEntity entity, RxBool isPressed) {
    return Obx(() {
      final cartController = Get.find<CartController>();
      final String code = entity.schemeCode ?? '';

      final matchingItems = cartController.displayedItems
          .where((item) => item.schemeCode.toString() == code)
          .toList();

      final cartItem = matchingItems.isNotEmpty ? matchingItems.first : null;
      final bool isInCart = cartItem != null;

      return InkWell(
        onTap: () async {
          if (isPressed.value) return;

          isPressed.value = true;

          try {
            if (isInCart) {
              final itemId = cartItem?.id;
              if (itemId != null) {
                await cartController.deleteCartItem(
                  itemId,
                  entity.schemeCode ?? '',
                );
              }
            } else {
              await cartController.addToCart(
                code,
                entity.baseSchemeName ?? '',
                entity.minSipAmount ?? 5000,
                transType: 'sip',
                null,
              );
            }
          } finally {
            isPressed.value = false;
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isInCart
                ? Ucolors.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isInCart ? Ucolors.primary : Colors.grey.shade300,
            ),
          ),
          child: Icon(
            isInCart ? Iconsax.shopping_cart5 : Iconsax.shopping_cart,
            size: 20,
            color: isInCart ? Ucolors.primary : Colors.grey.shade600,
          ),
        ),
      );
    });
  }

  Widget _webInvestNowButton(
    CartController controller,
    MutualFundListEntity entity,
  ) {
    return SizedBox(
      height: 34,
      width: 112,
      child: ElevatedButton(
        onPressed: () async {
          GatekeeperHelper.runWithPrerequisites(
            onSuccess: () {
              final purchaseArgs = SipPurchaseArgs(
                schemeCode: entity.schemeCode ?? '',
                fundName: entity.baseSchemeName ?? '',
                category: 'Unknown',
                riskLabel: entity.riskLevel ?? '',
                minSip: entity.minSipAmount ?? 1000,
                minLumpsum: entity.minLumpsum ?? 1000,
                minTopup: entity.minTopUp ?? 5000,
                folio: null,
                imgUrl: '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
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
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Invest Now',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // void _openFundDetails(MutualFundListEntity entity) {
  //   Get.delete<FundDetailsController>();

  //   FundDetailsScreen.navData = {
  //     'scheme': entity.baseSchemeName,
  //     'imgUrl': '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}',
  //     'scheme_code': entity.schemeCode.toString(),
  //   };

  //   Get.toNamed(AppRoutes.funddetails, id: 1);
  // }
  void _openFundDetails(MutualFundListEntity entity) {
    final schemeName = entity.baseSchemeName?.trim() ?? '';
    final schemeCode = entity.schemeCode?.toString().trim() ?? '';
    final imgUrl = '${Appurl.baseUrl}${entity.amc?.amcLogoUrl ?? ''}';

    if (schemeName.isEmpty || schemeCode.isEmpty) {
      debugPrint('Fund details missing: scheme=$schemeName code=$schemeCode');
      return;
    }

    if (Get.isRegistered<FundDetailsController>()) {
      Get.delete<FundDetailsController>();
    }

    FundDetailsScreen.navData = {
      'scheme': schemeName,
      'imgUrl': imgUrl,
      'scheme_code': schemeCode,
    };

    if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
      Get.find<NavigationBarController>().openNestedRoute(
        AppRoutes.funddetails,
        queryParameters: {'scheme': schemeName, 'scheme_code': schemeCode},
        arguments: {
          'scheme': schemeName,
          'imgUrl': imgUrl,
          'scheme_code': schemeCode,
        },
      );
    } else {
      Get.toNamed(AppRoutes.funddetails);
    }
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
class MobileExploreLayout extends StatelessWidget {
  final ScrollController scrollController;
  final FocusNode searchFocus;
  final TextEditingController sortController;
  final List<String> sortItems;

  const MobileExploreLayout({
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
        tween: Tween<double>(
          begin: 1.0,
          end: 0.6,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20.0,
      ),
      // 2. Explode outwards past the normal size
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.6,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 40.0,
      ),
      // 3. Wobble back down to standard size
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
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
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Icon(
          widget.isFav ? Iconsax.heart5 : Iconsax.heart,
          color: widget.isFav
              ? Colors.red
              : Colors.grey, // Update with your Ucolors
          size: 24, // Update with your standard CompactIcon size
        ),
      ),
    );
  }
}
