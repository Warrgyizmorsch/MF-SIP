import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/filterpage.dart';
import 'package:my_sip/navigation_menu_bar.dart';

import '../../../../core/utils/constant/text_style.dart';

class WebFilterDrawer {
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'WebFilterDrawer',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Material(
              elevation: 16,
              child: Container(
                width: 380,
                height: double.infinity,
                color: Colors.white,
                child: const WebFilterContent(),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }
}

class WebFilterContent extends StatefulWidget {
  const WebFilterContent({
    super.key,
    this.showCloseButton = false,
    this.showSearchBar = true,
    this.autoApply = true,
  });

  final bool showCloseButton;
  final bool showSearchBar;
  final bool autoApply;

  @override
  State<WebFilterContent> createState() => _WebFilterContentState();
}

class _WebFilterContentState extends State<WebFilterContent> {
  final FundhouseController controller = Get.find();
  final MutualFundController mutualController = Get.find();

  final List<Worker> _workers = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    if (widget.autoApply) {
      _workers.addAll([
        ever(controller.indexFundOnly, (_) => _autoApplyFilters()),
        ever(controller.selectedSchemeTypes, (_) => _autoApplyFilters()),
        ever(controller.selectedRisks, (_) => _autoApplyFilters()),
        ever(controller.selectedAmcIds, (_) => _autoApplyFilters()),
        ever(controller.selectedReturnFilterYear, (_) => _autoApplyFilters()),
        ever(controller.returnRange, (_) => _autoApplyFilters()),
        ever(controller.isReturnRangeActive, (_) => _autoApplyFilters()),
      ]);
    }
  }

  void _autoApplyFilters() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () {
      final params = controller.buildParam();

      if (Get.isRegistered<MutualFundController>()) {
        Get.find<MutualFundController>().syncFilterPageParams(params);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();

    for (final worker in _workers) {
      worker.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.showSearchBar ? 130 : 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.filter, size: 20, color: Ucolors.primary),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Filters by',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Obx(() {
                    final count = controller.activeFilterCount;

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
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                  if (widget.showCloseButton)
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),

              if (widget.showSearchBar) ...[
                const SizedBox(height: 14),
                SizedBox(
                  height: 44,
                  child: SearchBar(
                    elevation: WidgetStateProperty.all(0),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    side: WidgetStateProperty.all(
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    leading: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    hintText: 'Search funds...',
                    onChanged: mutualController.onSearchQueryChanged,
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                initiallyExpanded: true,
                title: const Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                children: [SizedBox(height: 320, child: CategoriesPanel())],
              ),

              ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                initiallyExpanded: false,
                title: const Text(
                  'Risk Profile',
                  style: TextStyle(
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                children: [SizedBox(height: 250, child: RiskPanel())],
              ),

              ExpansionTile(
                initiallyExpanded: false,
                shape: const Border(),
                collapsedShape: const Border(),
                title: const Text(
                  'Fund House (AMC)',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [SizedBox(height: 400, child: FundHousePanel())],
              ),

              ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                initiallyExpanded: false,
                title: const Text(
                  'Returns Range',
                  style: TextStyle(
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                children: [SizedBox(height: 400, child: ReturnRangePanel())],
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.clearAllFilters();

                    if (Get.isRegistered<MutualFundController>()) {
                      Get.find<MutualFundController>().syncFilterPageParams(
                        controller.buildParam(),
                      );
                    }

                    if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
                      Get.find<NavigationBarController>()
                          .clearExploreFilterUrl();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Ucolors.primary),
                  ),
                  child: const Text(
                    'Reset All',
                    style: TextStyle(
                      fontFamily: FontFamily.regular,
                      color: Ucolors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       final params = controller.buildParam();

              //       if (Get.isRegistered<MutualFundController>()) {
              //         Get.find<MutualFundController>().syncFilterPageParams(
              //           params,
              //         );
              //       }

              //       if (widget.showCloseButton) {
              //         Navigator.pop(context);
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Ucolors.primary,
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //     ),
              //     child: const Text(
              //       'Apply',
              //       style: TextStyle(
              //         fontFamily: FontFamily.medium,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

// class WebFilterContent extends StatelessWidget {
//   const WebFilterContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final FundhouseController controller = Get.find();

//     return Column(
//       children: [
//         // 1. HEADER
//         Container(
//           height: 70,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   const Icon(Iconsax.filter, size: 20, color: Ucolors.primary),
//                   const SizedBox(width: 10),
//                   const Text(
//                     'Filters',
//                     style: TextStyle(
//                       fontFamily: FontFamily.medium,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               IconButton(
//                 onPressed: () => Get.back(), // Close Icon
//                 icon: const Icon(Icons.close),
//               ),
//             ],
//           ),
//         ),

//         // 2. SCROLLABLE BODY (Expansion Tiles)
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(0),
//             children: [
//               // Categories Section
//               ExpansionTile(
//                 initiallyExpanded: true,
//                 title: const Text(
//                   'Categories',
//                   style: TextStyle(
//                     fontFamily: FontFamily.medium,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 children: [
//                   SizedBox(
//                     height: 300,
//                     child: CategoriesPanel(),
//                   ), // Reusing your widget
//                 ],
//               ),

//               // Risk Section
//               ExpansionTile(
//                 initiallyExpanded: false,
//                 title: const Text(
//                   'Risk Profile',
//                   style: TextStyle(
//                     fontFamily: FontFamily.medium,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 children: [
//                   SizedBox(
//                     height: 250,
//                     child: RiskPanel(),
//                   ), // Reusing your widget
//                 ],
//               ),

//               // Fund House Section
//               ExpansionTile(
//                 initiallyExpanded: false,
//                 title: const Text(
//                   'Fund House (AMC)',
//                   style: TextStyle(
//                     fontFamily: FontFamily.medium,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 children: [
//                   SizedBox(
//                     height: 400,
//                     child: FundHousePanel(),
//                   ), // Reusing your widget
//                 ],
//               ),
//               ExpansionTile(
//                 initiallyExpanded: false,
//                 title: const Text(
//                   'Returns Range',
//                   style: TextStyle(
//                     fontFamily: FontFamily.medium,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 children: [
//                   SizedBox(
//                     height: 400,
//                     child: ReturnRangePanel(),
//                   ), // Reusing your widget
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // 3. BOTTOM ACTION BAR
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border(top: BorderSide(color: Colors.grey.shade200)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Reset Button
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () {
//                     controller.clearAllFilters();
//                   },
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     side: const BorderSide(color: Ucolors.primary),
//                   ),
//                   child: const Text(
//                     'Reset All',
//                     style: TextStyle(
//                       fontFamily: FontFamily.medium,
//                       color: Ucolors.primary,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               // Apply Button
//               Expanded(
//                 child:
//                     //  Obx(
//                     //   () =>
//                     ElevatedButton(
//                       onPressed: () {
//                                                 Navigator.pop(context);

//                         // Sync params aur close dialog
//                         final params = controller.buildParam();
//                         if (Get.isRegistered<MutualFundController>()) {
//                           Get.find<MutualFundController>().syncFilterPageParams(
//                             params,
//                           );
//                         }
//                         // Get.back(); // Close sliding panel
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Ucolors.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                       ),
//                       child: Text(
//                         'Apply',
//                         // 'Apply (${controller.selectedFundCount})',
//                         style: const TextStyle(
//                           fontFamily: FontFamily.medium,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                 // ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
