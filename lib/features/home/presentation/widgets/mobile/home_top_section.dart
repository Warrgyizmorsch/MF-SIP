import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/services/session_manager.dart';

import 'home_design.dart';
import 'home_fund_navigation.dart';
import 'home_fund_ticker.dart';
import 'home_header.dart';
import 'home_onboarding_card.dart';

class MobileHomeTopSection extends StatelessWidget {
  const MobileHomeTopSection({
    super.key,
    required this.mutualController,
    required this.personalisationController,
    required this.navController,
    required this.onSearch,
  });

  final MutualFundController mutualController;
  final PersonalisationController personalisationController;
  final NavigationBarController navController;
  final VoidCallback onSearch;

  void _openExplore() {
    navController.navigateToExploreWithFilter(mutualController.resetToDefault);
  }

  void _openHeaderRoute(String route) {
    navController.customHeaderTitle.value = '';
    navController.openNestedRoute(route);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = (constraints.maxWidth / HomeMetrics.referenceWidth)
          .clamp(0.7, 1.2)
          .toDouble();
      return ColoredBox(
        color: Ucolors.homeBackground,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MobileHomeHeader(
              onSearch: onSearch,
              onCart: () {
                Get.find<CartController>().filterGoalId.value = null;
                _openHeaderRoute(AppRoutes.cart);
              },
              onNotifications: () => Get.toNamed(AppRoutes.notification),
              onProfile: () => Get.toNamed(AppRoutes.personaldetails),
              avatar: Obx(() {
                final picked = personalisationController.imagePath.value.trim();
                final profile = SessionManager.instance.getUserData?.img ?? '';
                return UCircularImage(
                  image: picked.isNotEmpty
                      ? picked
                      : profile.isNotEmpty
                      ? profile
                      : UImages.avatar,
                  radius: 15.5 * scale,
                );
              }),
              actions: [
                HomeQuickAction(
                  label: 'Mutual Funds',
                  asset: UImages.homeMutualFunds,
                  iconSize: const Size(35, 35),
                  onTap: _openExplore,
                ),
                HomeQuickAction(
                  label: 'Lumpsum',
                  asset: UImages.homeLumpsum,
                  iconSize: const Size(32, 25),
                  onTap: () => Get.toNamed(
                    AppRoutes.startSipScreen,
                    arguments: {'isLumpsum': true},
                  ),
                ),
                HomeQuickAction(
                  label: 'Start SIP',
                  asset: UImages.homeSip,
                  iconSize: const Size(27, 31),
                  onTap: () => Get.toNamed(
                    AppRoutes.startSipScreen,
                    arguments: {'isLumpsum': false},
                  ),
                ),
                HomeQuickAction(
                  label: 'Index Funds',
                  asset: UImages.homeIndexFundsAction,
                  iconSize: const Size(29, 27),
                  onTap: () => navController.navigateToExploreWithFilter(
                    () => Get.find<FundhouseController>().applyCustomSearch(
                      'index',
                    ),
                  ),
                ),
                HomeQuickAction(
                  label: 'NFO',
                  asset: UImages.homeNfo,
                  iconSize: const Size(34, 34),
                  onTap: () => Get.toNamed(AppRoutes.nfolist),
                ),
                HomeQuickAction(
                  label: 'Compare Funds',
                  asset: UImages.homeCompareFundsAction,
                  iconSize: const Size(34, 23),
                  onTap: () => Get.toNamed(AppRoutes.comparefund),
                ),
              ],
            ),
            SizedBox(height: 16 * scale),
            Obx(
              () => HomeFundTicker(
                funds: mutualController.searchFund.toList(),
                isLoading: mutualController.isLoading.value,
                errorMessage: mutualController.errorMessage.value,
                onFundTap: (fund) =>
                    HomeFundNavigation.open(fund, controller: mutualController),
                onRetry: () => mutualController.retryFetch(),
              ),
            ),
            Padding(
              // The ticker's 8px shadow allowance is part of this visual gap.
              padding: EdgeInsets.fromLTRB(
                21 * scale,
                (27 * scale - 8).clamp(0.0, double.infinity).toDouble(),
                21 * scale,
                10 * scale,
              ),
              child: HomeOnboardingCard(
                controller: personalisationController,
                onExplore: _openExplore,
                scale: scale,
              ),
            ),
          ],
        ),
      );
    },
  );
}
