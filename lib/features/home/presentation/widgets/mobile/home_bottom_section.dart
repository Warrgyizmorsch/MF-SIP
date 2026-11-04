import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

import 'home_design.dart';
import 'home_fund_navigation.dart';
import 'home_popular_funds.dart';
import 'home_relationship_card.dart';
import 'home_trust_footer.dart';
import 'home_videos.dart';

class MobileHomeBottomSection extends StatelessWidget {
  const MobileHomeBottomSection({
    super.key,
    required this.mutualController,
    required this.onViewAllFunds,
  });

  final MutualFundController mutualController;
  final VoidCallback onViewAllFunds;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = (constraints.maxWidth / HomeMetrics.referenceWidth)
          .clamp(0.7, 1.2)
          .toDouble();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30 * scale),
            child: Obx(
              () => HomePopularFunds(
                funds: mutualController.searchFund.toList(),
                scale: scale,
                isLoading: mutualController.isLoading.value,
                errorMessage: mutualController.errorMessage.value,
                onFundTap: (fund) =>
                    HomeFundNavigation.open(fund, controller: mutualController),
                onViewAll: onViewAllFunds,
                onRetry: () => mutualController.retryFetch(),
              ),
            ),
          ),
          SizedBox(height: 10 * scale),
          HomeVideos(scale: scale),
          SizedBox(height: 20 * scale),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: HomeMetrics.sectionInset * scale,
            ),
            child: HomeRelationshipCard(scale: scale),
          ),
          SizedBox(height: 14 * scale),
          HomeTrustFooter(scale: scale),
        ],
      );
    },
  );
}
