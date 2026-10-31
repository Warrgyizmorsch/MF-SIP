import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../../navigation_menu_bar.dart';
import '../../../goal/domain/entity/goal_entity.dart';
import '../../../goal/presentation/controller/goal_sip_controller.dart';
import '../../../goal/presentation/pages/goaldetails.dart';
import '../../../goal/presentation/widget/goal_progress_indicator.dart';

class HomeActiveGoalsSection extends StatelessWidget {
  const HomeActiveGoalsSection({super.key, this.isDesktop = false});

  final bool isDesktop;

  Future<void> _openGoal(
    GoalSipController controller,
    UserGoalEntity goal,
  ) async {
    final summary = _GoalSummary(goal);
    final data = <String, dynamic>{
      'goal': goal,
      'target': summary.target,
      'invested': summary.saved,
      'logo': summary.cover,
    };
    GoalDetailsPage.tempData = data;
    await Get.toNamed(
      AppRoutes.goaldetails,
      id: isDesktop ? 1 : null,
      arguments: data,
    );
    if (!controller.isClosed) await controller.getAllGoals();
  }

  void _viewAll() {
    if (Get.isRegistered<NavigationBarController>()) {
      Get.find<NavigationBarController>().changePage(3, isDesktop: isDesktop);
    } else {
      Get.toNamed(AppRoutes.goalScreen, id: isDesktop ? 1 : null);
    }
  }

  Future<void> _createGoal(GoalSipController controller) async {
    controller.resetStateForNewGoal();
    await controller.getMasterGoals();
    if (controller.isClosed) return;
    await Get.toNamed(
      isDesktop ? AppRoutes.webMasterGoalsPage : AppRoutes.masterGoalsPage,
      id: isDesktop ? 1 : null,
    );
    if (!controller.isClosed) await controller.getAllGoals();
  }

  HomeActiveGoalCard _card(GoalSipController controller, UserGoalEntity goal) {
    final type = '${goal.goalType?.typeName ?? ''} ${goal.goalName}';
    final bike = type.toLowerCase().contains('bike');
    return HomeActiveGoalCard(
      key: ValueKey('home-goal-${goal.id}'),
      goal: goal,
      emoji: bike ? '🏍️' : controller.getGoalEmoji(type),
      fallbackIcon: bike
          ? Icons.two_wheeler_rounded
          : controller.getGoalIcon(type),
      onTap: () => _openGoal(controller, goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GoalSipController>()) return const SizedBox.shrink();
    final controller = Get.find<GoalSipController>();
    final inset = isDesktop ? 0.0 : 16.0;
    return Obx(() {
      final goals =
          controller.goalResponse.value?.data ?? const <UserGoalEntity>[];
      final loading = controller.isLoadingGoals.value && goals.isEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: inset),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your Active Goals',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF171717),
                      ),
                    ),
                  ),
                  if (goals.isNotEmpty)
                    TextButton(
                      onPressed: _viewAll,
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 13,
                          color: Ucolors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (loading)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: inset),
              child: const _ActiveGoalPlaceholder(),
            )
          else if (goals.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: inset),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _createGoal(controller),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 116),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            color: GoalProgressIndicator.defaultColor,
                            size: 36,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Create your first goal',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Ucolors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth - 2 * inset;
                if (isDesktop) {
                  final columns = ((width + 12) / 332).floor().clamp(1, 3);
                  final cardWidth = (width - (columns - 1) * 12) / columns;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final goal in goals)
                        SizedBox(
                          width: cardWidth,
                          child: _card(controller, goal),
                        ),
                    ],
                  );
                }
                if (goals.length == 1) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: inset,
                      vertical: 8,
                    ),
                    child: _card(controller, goals.single),
                  );
                }
                final cardWidth = math.min(400.0, width - 20);
                final height = goals.fold<double>(
                  128,
                  (height, goal) => math.max(
                    height,
                    HomeActiveGoalCard.heightFor(context, goal, cardWidth),
                  ),
                );
                return ClipRect(
                  clipper: const _CarouselShadowClipper(),
                  child: SizedBox(
                    height: height + 16,
                    child: ListView.separated(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: inset,
                        vertical: 8,
                      ),
                      itemCount: goals.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (_, index) => SizedBox(
                        width: cardWidth,
                        child: _card(controller, goals[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: isDesktop ? 0 : 16),
        ],
      );
    });
  }
}

/// Home keeps its labels outside the scaled progress illustration.
class HomeActiveGoalCard extends StatelessWidget {
  const HomeActiveGoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    this.emoji = '🎯',
    this.fallbackIcon = Icons.flag_rounded,
  });

  final UserGoalEntity goal;
  final VoidCallback onTap;
  final String emoji;
  final IconData fallbackIcon;

  static const _titleStyle = TextStyle(
    fontFamily: FontFamily.medium,
    fontSize: 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: Color(0xFF171717),
  );
  static const _amountStyle = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: 14,
    letterSpacing: 0,
    height: 1.35,
    color: Color(0xFF334155),
  );
  static const _progressStyle = TextStyle(
    fontFamily: FontFamily.medium,
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: GoalProgressIndicator.defaultColor,
  );

  static double heightFor(
    BuildContext context,
    UserGoalEntity goal,
    double width,
  ) {
    final summary = _GoalSummary(goal);
    final stacked = _stacked(context, width);
    final textWidth = math.max(1.0, width - (stacked ? 20 : 158));
    double measure(String text, TextStyle style, {int? maxLines}) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: DefaultTextStyle.of(context).style.merge(style),
        ),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: maxLines,
        ellipsis: maxLines != null ? '…' : null,
      )..layout(maxWidth: textWidth);
      final height = painter.height;
      painter.dispose();
      return height;
    }

    final textHeight =
        measure(summary.name, _titleStyle, maxLines: 2) +
        measure(summary.amounts, _amountStyle) +
        measure(summary.percentage, _progressStyle) +
        10;
    return math
        .max(
          128,
          textHeight +
              20 +
              (stacked
                  ? 108 / GoalProgressIndicator.compactAspectRatio + 12
                  : 0),
        )
        .ceilToDouble();
  }

  static bool _stacked(BuildContext context, double width) =>
      width < 360 && MediaQuery.textScalerOf(context).scale(16) > 24;

  Widget _illustration(_GoalSummary summary) => SizedBox(
    width: 108,
    child: GoalProgressIndicator(
      compact: true,
      progress: summary.progress,
      iconUrl: summary.cover,
      emoji: emoji,
      fallbackIcon: fallbackIcon,
    ),
  );

  Widget _labels(_GoalSummary summary) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        summary.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: _titleStyle,
      ),
      const SizedBox(height: 6),
      Text(summary.amounts, style: _amountStyle),
      const SizedBox(height: 4),
      Text(summary.percentage, style: _progressStyle),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final summary = _GoalSummary(goal);
    return Semantics(
      button: true,
      onTap: onTap,
      label: '${summary.name}, ${summary.amounts}, ${summary.percentage}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFEEF0F4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            excludeFromSemantics: true,
            child: ExcludeSemantics(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 128),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const arrow = Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Color(0xFF64748B),
                      );
                      if (_stacked(context, constraints.maxWidth + 20)) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _illustration(summary),
                                const Spacer(),
                                arrow,
                              ],
                            ),
                            const SizedBox(height: 12),
                            _labels(summary),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          _illustration(summary),
                          const SizedBox(width: 8),
                          Expanded(child: _labels(summary)),
                          const SizedBox(width: 4),
                          arrow,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keep adjacent cards inside the row while allowing the soft shadow to paint
/// vertically without adding a large empty gutter around every card.
class _CarouselShadowClipper extends CustomClipper<Rect> {
  const _CarouselShadowClipper();

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(0, -32, size.width, size.height + 32);

  @override
  bool shouldReclip(_CarouselShadowClipper oldClipper) => false;
}

class _GoalSummary {
  _GoalSummary(this.goal);
  final UserGoalEntity goal;
  static final _format = NumberFormat('#,##0', 'en_US');
  String get name => goal.goalName.trim().isEmpty ? 'Goal' : goal.goalName;
  double get target {
    final value = goal.targetAmount > 0
        ? goal.targetAmount
        : (goal.goalType?.targetAmount ?? 0);
    return value.isFinite && value > 0 ? value : 0;
  }

  double get saved {
    final value = goal.investedAmount > 0
        ? goal.investedAmount
        : target * goal.progressPercent / 100;
    return value.isFinite && value > 0 ? value : 0;
  }

  double get progress => calculateGoalProgress(
    targetAmount: target,
    investedAmount: saved,
    progressPercent: goal.progressPercent,
  );
  String get cover =>
      goal.goalCover.isNotEmpty ? goal.goalCover : (goal.goalType?.logo ?? '');
  String get amounts =>
      '₹${_format.format(saved)} of ₹${_format.format(target)}';
  String get percentage => '${(progress * 100).toStringAsFixed(0)}% complete';
}

class _ActiveGoalPlaceholder extends StatelessWidget {
  const _ActiveGoalPlaceholder();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Loading active goals',
    child: Container(
      height: 128,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 36, backgroundColor: Color(0xFFEDEDED)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 90,
                  color: const Color(0xFFEDEDED),
                ),
                const SizedBox(height: 10),
                Container(height: 10, color: const Color(0xFFF3F4F6)),
                const SizedBox(height: 10),
                Container(
                  height: 10,
                  width: 70,
                  color: const Color(0xFFF3F4F6),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
