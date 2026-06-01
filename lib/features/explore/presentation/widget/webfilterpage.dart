import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/filterpage.dart';

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

class WebFilterContent extends StatelessWidget {
  const WebFilterContent({super.key});

  @override
  Widget build(BuildContext context) {
    final FundhouseController controller = Get.find();

    return Column(
      children: [
        // 1. HEADER
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.filter, size: 20, color: Ucolors.primary),
                  const SizedBox(width: 10),
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Get.back(), // Close Icon
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        // 2. SCROLLABLE BODY (Expansion Tiles)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              // Categories Section
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  SizedBox(
                    height: 300,
                    child: CategoriesPanel(),
                  ), // Reusing your widget
                ],
              ),

              // Risk Section
              ExpansionTile(
                initiallyExpanded: false,
                title: const Text(
                  'Risk Profile',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  SizedBox(
                    height: 250,
                    child: RiskPanel(),
                  ), // Reusing your widget
                ],
              ),

              // Fund House Section
              ExpansionTile(
                initiallyExpanded: false,
                title: const Text(
                  'Fund House (AMC)',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  SizedBox(
                    height: 400,
                    child: FundHousePanel(),
                  ), // Reusing your widget
                ],
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: const Text(
                  'Returns Range',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  SizedBox(
                    height: 400,
                    child: ReturnRangePanel(),
                  ), // Reusing your widget
                ],
              ),
            ],
          ),
        ),

        // 3. BOTTOM ACTION BAR
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
              // Reset Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    controller.clearAllFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(color: Ucolors.primary),
                  ),
                  child: const Text(
                    'Reset All',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Ucolors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Apply Button
              Expanded(
                child:
                    //  Obx(
                    //   () =>
                    ElevatedButton(
                      onPressed: () {
                        // Sync params aur close dialog
                        final params = controller.buildParam();
                        if (Get.isRegistered<MutualFundController>()) {
                          Get.find<MutualFundController>().syncFilterPageParams(
                            params,
                          );
                        }
                        Get.back(); // Close sliding panel
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        'Apply',
                        // 'Apply (${controller.selectedFundCount})',
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
