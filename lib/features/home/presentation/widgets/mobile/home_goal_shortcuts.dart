import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';

import 'home_adaptive_grid.dart';
import 'home_design.dart';

class HomeGoalShortcuts extends StatelessWidget {
  const HomeGoalShortcuts({super.key, required this.scale});

  final double scale;

  static const _goals = [
    ('car', 'Car Goal', UImages.homeCarGoal, Size(20, 11)),
    ('bike', 'Bike Goal', UImages.homeBikeGoal, Size(32, 31)),
    ('marriage', 'Marriage Goal', UImages.homeMarriageGoal, Size(19, 17)),
    ('vacation', 'Vacation Goal', UImages.homeVacationGoal, Size(21.5, 14.5)),
    ('home', 'Home Goal', UImages.homeGoal, Size(20, 19)),
    ('education', 'Education Goal', UImages.homeEducationGoal, Size(20, 16)),
  ];

  void _open(String type) {
    final controller = Get.isRegistered<GoalSipController>()
        ? Get.find<GoalSipController>()
        : null;
    final master = controller?.masterGoals.firstWhereOrNull(
      (goal) => goal.goalType.trim().toLowerCase() == type,
    );
    // A shortcut only preselects a goal if that master exists. Missing types,
    // including a bike goal not yet offered by the API, open the normal chooser.
    Get.toNamed(
      AppRoutes.masterGoalsPage,
      arguments: master == null
          ? {'isHome': false}
          : {'goalType': master.goalType, 'isHome': true},
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Create Goal',
        textAlign: TextAlign.center,
        style: UTextStyles.homeText(
          size: (22 * scale).clamp(18.0, 25.0).toDouble(),
          weight: FontWeight.w600,
          color: Ucolors.homeGoalHeading,
          height: 24 / 22,
        ),
      ),
      SizedBox(height: 19 * scale),
      HomeAdaptiveGrid(
        maximumColumns: 2,
        minimumTileWidth:
            HomeTextLayout.widestWord(
              context,
              _goals.map((goal) => goal.$2),
              style: UTextStyles.homeText(
                size: (11 * scale).clamp(9.0, 13.0).toDouble(),
                height: 15 / 11,
              ),
            ) +
            86.5 * scale +
            1.272,
        columnGap: 12 * scale,
        rowGap: 10 * scale,
        children: [
          for (final goal in _goals)
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  USizes.homeTileRadius * scale,
                ),
                boxShadow: UShadows.homeGoal,
              ),
              child: Material(
                color: Ucolors.white,
                borderRadius: BorderRadius.circular(
                  USizes.homeTileRadius * scale,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _open(goal.$1),
                  borderRadius: BorderRadius.circular(
                    USizes.homeTileRadius * scale,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: (HomeMetrics.goalTileHeight * scale)
                          .clamp(44.0, 60.0)
                          .toDouble(),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Ucolors.homeGoalBorder,
                        width: 0.636,
                      ),
                      borderRadius: BorderRadius.circular(
                        USizes.homeTileRadius * scale,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * scale,
                      vertical: 7 * scale,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32 * scale,
                          child: Center(
                            child: SvgPicture.asset(
                              goal.$3,
                              width: goal.$4.width * scale,
                              height: goal.$4.height * scale,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 10 * scale),
                        Expanded(
                          child: Text(
                            goal.$2,
                            style: UTextStyles.homeText(
                              size: (11 * scale).clamp(9.0, 13.0).toDouble(),
                              color: Ucolors.homeTextSecondary,
                              height: 15 / 11,
                            ),
                          ),
                        ),
                        SizedBox(width: 6 * scale),
                        SvgPicture.asset(
                          UImages.homeGoalChevron,
                          width: 6.5 * scale,
                          height: 11.5 * scale,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ],
  );
}
