import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';

import '../home_active_goals.dart';
import 'home_collections.dart';
import 'home_design.dart';
import 'home_fund_navigation.dart';
import 'home_fund_strip.dart';
import 'home_goal_shortcuts.dart';
import 'home_kyc_banner.dart';
import 'home_tools_panel.dart';

class MobileHomeMiddleSection extends StatelessWidget {
  const MobileHomeMiddleSection({
    super.key,
    required this.mutualController,
    required this.personalisationController,
    required this.navController,
  });

  final MutualFundController mutualController;
  final PersonalisationController personalisationController;
  final NavigationBarController navController;

  void _openCollection(HomeCollection collection) {
    final funds = Get.find<FundhouseController>();
    navController.navigateToExploreWithFilter(() {
      switch (collection) {
        case HomeCollection.bestSip:
          funds.applyBestSipFilter(1);
          break;
        case HomeCollection.highReturns:
          funds.applyHighReturnFilter();
          break;
        case HomeCollection.international:
          funds.applyInternationalFilter();
          break;
        case HomeCollection.indexFunds:
          funds.applyCustomSearch('index');
          break;
        case HomeCollection.commodities:
          funds.applyCommodityFilter();
          break;
        case HomeCollection.equity:
          // Match the actual category strings already supplied to the filter UI.
          final categories = funds.categoryList
              .expand((group) => group.categories)
              .where(
                (category) =>
                    category.trim().toLowerCase().startsWith('equity'),
              )
              .toSet()
              .toList();
          funds.resetUiStatesOnly();
          funds.selectedSchemeTypes.assignAll(categories);
          mutualController.applyFreshFilter(
            categories.isEmpty
                ? {'asset_class': 'equity'}
                : {'scheme_category': categories.join(',')},
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = (constraints.maxWidth / HomeMetrics.referenceWidth)
          .clamp(0.7, 1.2)
          .toDouble();
      final inset = HomeMetrics.sectionInset * scale;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(inset, 20 * scale, inset, 0),
            child: HomeCollections(scale: scale, onSelected: _openCollection),
          ),
          SizedBox(height: 24 * scale),
          Obx(
            () => HomeFundStrip(
              funds: mutualController.searchFund.toList(),
              scale: scale,
              isLoading: mutualController.isLoading.value,
              errorMessage: mutualController.errorMessage.value,
              onRetry: () => mutualController.retryFetch(),
              onFundTap: (fund) =>
                  HomeFundNavigation.open(fund, controller: mutualController),
            ),
          ),
          SizedBox(
            height: (20 * scale - 8).clamp(0.0, double.infinity).toDouble(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inset),
            child: HomeToolsPanel(scale: scale),
          ),
          SizedBox(height: 20 * scale),
          if (Get.isRegistered<GoalSipController>())
            Obx(() {
              final goals =
                  Get.find<GoalSipController>().goalResponse.value?.data;
              if (goals == null || goals.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  const HomeActiveGoalsSection(),
                  SizedBox(height: 20 * scale),
                ],
              );
            }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inset),
            child: HomeGoalShortcuts(scale: scale),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inset),
            child: HomeKycBanner(
              controller: personalisationController,
              scale: scale,
            ),
          ),
          // The next heading has 10px of visual inset within its tap target.
          SizedBox(height: 10 * scale),
        ],
      );
    },
  );
}
