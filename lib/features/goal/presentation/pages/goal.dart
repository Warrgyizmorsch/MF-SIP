import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../widget/goal_progress_indicator.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/shimmer/shimmer.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../domain/entity/goal_entity.dart';
import '../controller/goal_sip_controller.dart';
import '../widget/goal_card.dart';
import '../widget/goal_beyond_saving_view.dart';
import 'goaldetails.dart';

class GoalScreen extends GetView<GoalSipController> {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user goals immediately after rendering frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllGoals();
    });

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    if (isDesktop) {
      return const GoalScreenWeb();
    } else {
      return const GoalScreenMobile();
    }
  }
}

class GoalScreenMobile extends GetView<GoalSipController> {
  const GoalScreenMobile({super.key});

  Future<void> _createGoal() async {
    controller.resetStateForNewGoal();
    await controller.getMasterGoals();
    Get.toNamed(AppRoutes.masterGoalsPage);
  }

  void _open(UserGoalEntity goal) {
    GoalDetailsPage.tempData = {
      'goal': goal,
      'target': _target(goal),
      'invested': _saved(goal),
      'logo': goal.goalCover.isNotEmpty ? goal.goalCover : goal.goalType?.logo,
    };
    Get.toNamed(AppRoutes.goaldetails);
  }

  static const _background = Color(0xFFF5F6FA);
  static const _purple = Color(0xFF441D9E);
  static const _muted = Color(0xFF5E6175);
  static const _line = Color(0xFFE4E6EE);
  static const _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E176F), Color(0xFF5B3FE0)],
  );

  static TextStyle _text(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color color = const Color(0xFF12121A),
  }) => TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
  static double _target(UserGoalEntity goal) => goal.targetAmount > 0
      ? goal.targetAmount
      : goal.goalType?.targetAmount ?? 0;
  static double _saved(UserGoalEntity goal) => goal.investedAmount > 0
      ? goal.investedAmount
      : _target(goal) * goal.progressPercent / 100;
  static double _progress(UserGoalEntity goal) => calculateGoalProgress(
    targetAmount: _target(goal),
    investedAmount: _saved(goal),
    progressPercent: goal.progressPercent,
  );
  static String _money(num value) =>
      '₹${NumberFormat.decimalPattern('en_IN').format(value.round())}';
  static String _short(num value) => value >= 10000000
      ? '₹${(value / 10000000).toStringAsFixed(1)}Cr'
      : value >= 100000
      ? '₹${(value / 100000).toStringAsFixed(1)}L'
      : _money(value);
  static String _status(UserGoalEntity goal) => goal.goalHealthStatus;
  static bool _behind(UserGoalEntity goal) => goal.isBehind;
  static bool _onTrack(UserGoalEntity goal) => goal.isOnTrack;

  @override
  Widget build(BuildContext context) => Obx(() {
    final goals = controller.goalResponse.value?.data ?? <UserGoalEntity>[];
    if (!controller.isLoadingGoals.value && goals.isEmpty) {
      return Scaffold(
        backgroundColor: _background,
        body: _buildMobileEmptyState(),
      );
    }
    if (controller.isLoadingGoals.value && goals.isEmpty) {
      return const Scaffold(
        backgroundColor: _background,
        body: SafeArea(child: GoalShimmerGrid()),
      );
    }
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: _purple,
          onRefresh: controller.getAllGoals,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(context, goals),
                      const SizedBox(height: 20),
                      _summary(goals),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _line),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Active Goals',
                        style: _text(18, weight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5484D),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${goals.length}',
                          style: _text(
                            12,
                            color: Colors.white,
                            weight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        constraints: const BoxConstraints.tightFor(
                          width: 44,
                          height: 44,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: 'Add new goal',
                        onPressed: _createGoal,
                        icon: const Icon(
                          Icons.add,
                          size: 22,
                          color: Color(0xFF12121A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DecoratedSliver(
                decoration: const BoxDecoration(color: Colors.white),
                sliver: SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.separated(
                    itemCount: goals.length,
                    separatorBuilder: (_, i) => const SizedBox(height: 14),
                    itemBuilder: (context, index) =>
                        _goalCard(context, goals[index]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(height: 36, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  });

  Widget _header(BuildContext context, List<UserGoalEntity> goals) => SizedBox(
    height: 44,
    child: Row(
      children: [
        Material(
          color: const Color(0xFFF0F1F6),
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => showSearch<UserGoalEntity?>(
              context: context,
              delegate: _GoalSearch(goals: goals, onSelect: _open),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text('Goals', style: _text(15, weight: FontWeight.w800)),
            ),
          ),
        ),
        const Spacer(),
        _circle(
          Icons.notifications_none_rounded,
          'Notifications',
          () => Get.toNamed(AppRoutes.notification),
        ),
      ],
    ),
  );

  Widget _circle(IconData icon, String label, VoidCallback onTap) => Material(
    color: const Color(0xFFF0F1F6),
    shape: const CircleBorder(),
    child: IconButton(
      tooltip: label,
      onPressed: onTap,
      icon: Icon(icon, size: 22, color: const Color(0xFF12121A)),
    ),
  );

  Widget _summary(List<UserGoalEntity> goals) {
    final behind = goals.where(_behind).length;
    final onTrack = goals.where(_onTrack).length;
    final monthly = goals.fold<double>(
      0,
      (sum, g) => sum + g.effectiveMonthlySip,
    );
    final next = _nextSip(goals);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                _summaryTile(
                  Icons.warning_amber_rounded,
                  '$behind Goal${behind == 1 ? '' : 's'}',
                  behind == 0 ? 'No top-ups flagged' : 'Needs a top-up',
                ),
                const SizedBox(height: 12),
                _summaryTile(
                  Icons.calendar_today_outlined,
                  _money(monthly),
                  next == null
                      ? 'Monthly SIP'
                      : 'Next SIP · ${DateFormat('d MMM').format(next)}',
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 132,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFF3F2FA)],
              ),
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: goals.isEmpty ? 0 : onTrack / goals.length,
                          ),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (context, value, child) =>
                              CircularProgressIndicator(
                                value: value,
                                strokeWidth: 6,
                                color: const Color(0xFFF5A524),
                                backgroundColor: _line,
                              ),
                        ),
                      ),
                      Text(
                        '$onTrack/${goals.length}',
                        style: _text(13, weight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text('On track', style: _text(13, weight: FontWeight.w700)),
                Text('Goals this month', style: _text(8, color: _muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(IconData icon, String value, String label) => Container(
    constraints: const BoxConstraints(minHeight: 52),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      gradient: _gradient,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0x38FFFFFF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: _text(15, color: Colors.white, weight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(label, style: _text(10, color: const Color(0xFFEDE8FF))),
            ],
          ),
        ),
      ],
    ),
  );

  DateTime? _nextSip(List<UserGoalEntity> goals) {
    final now = DateTime.now();
    final dates = <DateTime>[];
    for (final goal in goals) {
      if (goal.txnType.toLowerCase() != 'sip') continue;
      for (final fund in goal.goalFunds) {
        if (fund.sipDay < 1 || fund.sipDay > 31) continue;
        var date = DateTime(now.year, now.month, fund.sipDay);
        if (!date.isAfter(now)) {
          date = DateTime(now.year, now.month + 1, fund.sipDay);
        }
        final start = DateTime.tryParse(fund.sipStartDate);
        final end = DateTime.tryParse(fund.sipEndDate);
        if (start != null && start.isAfter(date)) date = start;
        if (end == null || !date.isAfter(end)) dates.add(date);
      }
    }
    dates.sort();
    return dates.isEmpty ? null : dates.first;
  }

  Widget _goalCard(BuildContext context, UserGoalEntity goal) {
    final progress = _progress(goal);
    final cover = goal.goalCover.trim();
    final image = cover.isEmpty
        ? null
        : Uri.parse(cover).hasScheme
        ? cover
        : '${Appurl.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/${cover.replaceFirst(RegExp(r'^/+'), '')}';
    final endDates =
        goal.goalFunds
            .map((fund) => DateTime.tryParse(fund.sipEndDate))
            .whereType<DateTime>()
            .toList()
          ..sort();
    final end = endDates.isEmpty
        ? DateTime.tryParse(goal.endDate)
        : endDates.last;
    final now = DateTime.now();
    final monthsLeft = end != null
        ? ((end.year - now.year) * 12 + end.month - now.month).clamp(0, 1200)
        : (goal.effectiveTenureYears > 0
              ? (goal.effectiveTenureYears * 12).round()
              : null);
    final badgeText = monthsLeft != null
        ? '$monthsLeft month${monthsLeft == 1 ? '' : 's'} left'
        : (goal.duration.isNotEmpty ? goal.duration : 'Target based');
    return Semantics(
      button: true,
      label: '${goal.goalName}, ${(progress * 100).round()} percent complete',
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: _line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _open(goal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, bounds) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: SizedBox(
                        height: bounds.maxWidth * 170 / 388,
                        width: bounds.maxWidth,
                        child: image == null
                            ? ColoredBox(
                                color: const Color(0xFFF0F1F6),
                                child: Center(
                                  child: Icon(
                                    controller.getGoalIcon(goal.goalName),
                                    size: 56,
                                    color: _purple.withValues(alpha: 0.25),
                                  ),
                                ),
                              )
                            : CustomCachedImage(
                              
                                imageUrl: image,
                                width: bounds.maxWidth,
                                height: bounds.maxWidth * 170 / 388,
                                radius: 22,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _behind(goal)
                              ? const Color(0xFFE5484D).withValues(alpha: 0.92)
                              : const Color(0xFF10B981).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _behind(goal)
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              switch (goal.goalHealthStatus) {
                                'completed' => 'Completed',
                                'behind' => 'Needs Attention',
                                'ahead' => 'Ahead',
                                _ => 'On Track',
                              },
                              style: _text(
                                11,
                                color: Colors.white,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (goal.effectiveMonthlySip > 0)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'SIP · ${_money(goal.effectiveMonthlySip)}/mo',
                            style: _text(
                              11,
                              color: Colors.white,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 16, 26, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayoutBuilder(
                      builder: (context, bounds) {
                        final title = Text(
                          goal.capitalizedGoalName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _text(16, weight: FontWeight.w700),
                        );
                        final badge = Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EAF2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeText,
                            style: _text(10, weight: FontWeight.w700),
                          ),
                        );
                        if (bounds.maxWidth < 290 ||
                            MediaQuery.textScalerOf(context).scale(1) > 1.2) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [title, const SizedBox(height: 8), badge],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: title),
                            const SizedBox(width: 8),
                            badge,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) =>
                          LinearProgressIndicator(
                            value: value,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                            color: const Color(0xFFF5A524),
                            backgroundColor: const Color(0xFFE9EAF2),
                          ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 15,
                                color: _purple,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                end == null
                                    ? 'Target based'
                                    : DateFormat('MMM yyyy').format(end),
                                style: _text(12, color: _muted),
                              ),
                            ],
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: _money(_saved(goal)),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF12121A),
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' of ${_short(_target(goal))} · ${(progress * 100).round()}%',
                                ),
                              ],
                            ),
                            style: _text(12, color: _muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileEmptyState() => GoalBeyondSavingView(
    onRefresh: controller.getAllGoals,
    onNext: _createGoal,
    onSkip: _createGoal,
  );
}

class _GoalSearch extends SearchDelegate<UserGoalEntity?> {
  _GoalSearch({required this.goals, required this.onSelect});
  final List<UserGoalEntity> goals;
  final ValueChanged<UserGoalEntity> onSelect;
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context, null),
    icon: const Icon(Icons.arrow_back),
  );
  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);
  @override
  Widget buildSuggestions(BuildContext context) {
    final matches = goals
        .where(
          (goal) => goal.goalName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(matches[index].capitalizedGoalName),
        onTap: () {
          close(context, null);
          onSelect(matches[index]);
        },
      ),
    );
  }
}

/// Adapts live goals and existing navigation to the shared reference card.
class MobileGoalCard extends StatelessWidget {
  final UserGoalEntity? goalEntity;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconUrl;

  const MobileGoalCard({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconUrl,
    this.goalEntity,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final type = '${goalEntity?.goalType?.typeName ?? ''} $goalName';
    final bike = type.toLowerCase().contains('bike');
    return GoalCard(
      goalName: goalName,
      targetAmount: targetAmount,
      investedAmount: investedAmount,
      progressPercent: goalEntity?.progressPercent,
      iconUrl: iconUrl,
      emoji: bike ? '🏍️' : controller.getGoalEmoji(type),
      fallbackIcon: bike
          ? Icons.two_wheeler_rounded
          : controller.getGoalIcon(type),
      onTap: () {
        GoalDetailsPage.tempData = {
          'goal': goalEntity,
          'target': targetAmount,
          'invested': investedAmount,
          'logo': iconUrl,
        };
        Get.toNamed(AppRoutes.goaldetails);
      },
    );
  }
}

class GoalScreenWeb extends GetView<GoalSipController> {
  const GoalScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double safeHeight = size.height - kToolbarHeight;

    return Scaffold(
      backgroundColor: GoalCard.backgroundColor,
      body: Center(
        child: SizedBox(
          width: size.width > 1500 ? 1500 : size.width,
          height: safeHeight > 0 ? safeHeight : 800,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Active Goals",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff111827),
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          "Track and manage your financial milestones",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        controller.resetStateForNewGoal();
                        await controller.getMasterGoals();
                        Get.toNamed(AppRoutes.webMasterGoalsPage, id: 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Create New Goal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: FontFamily.regular,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(32),
                const Expanded(child: WebGoalGridContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebGoalGridContent extends GetView<GoalSipController> {
  const WebGoalGridContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : 400;

        final crossAxisCount = (availableWidth / 260).floor().clamp(1, 4);
        final cardWidth =
            (availableWidth - (crossAxisCount - 1) * 24) / crossAxisCount;

        return Obx(() {
          if (controller.isLoadingGoals.value) {
            return const GoalShimmerGrid();
          }

          final goals = controller.goalResponse.value?.data ?? [];

          if (goals.isEmpty) {
            return const Center(
              child: Text(
                "No dynamic milestones saved yet.",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: FontFamily.regular,
                ),
              ),
            );
          }

          return GridView.builder(
            itemCount: goals.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              mainAxisExtent: cardWidth / GoalCard.aspectRatio + 56,
            ),
            itemBuilder: (context, index) {
              final goal = goals[index];
              final double target = goal.targetAmount > 0
                  ? goal.targetAmount
                  : (double.tryParse(
                          goal.goalType?.targetAmount.toString() ?? '0',
                        ) ??
                        0.0);
              final double invested = goal.investedAmount > 0
                  ? goal.investedAmount
                  : (target * (goal.progressPercent / 100));
              final String name = goal.capitalizedGoalName.isNotEmpty
                  ? goal.capitalizedGoalName
                  : 'Goal ${index + 1}';
              final String logo = goal.goalCover.isNotEmpty
                  ? goal.goalCover
                  : (goal.goalType?.logo ?? '');

              return WebGoalCard(
                goalEntity: goal,
                goalName: name,
                targetAmount: target,
                investedAmount: invested,
                iconUrl: logo,
              );
            },
          );
        });
      },
    );
  }
}

class WebGoalCard extends StatelessWidget {
  final UserGoalEntity? goalEntity;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconUrl;

  const WebGoalCard({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconUrl,
    this.goalEntity,
  });

  void _openDetails({bool addFund = false}) {
    GoalDetailsPage.tempData = {
      'goal': goalEntity,
      'target': targetAmount,
      'invested': investedAmount,
      'logo': iconUrl,
    };
    if (addFund) Get.find<GoalSipController>().isAddFund.value = false;
    Get.toNamed(AppRoutes.goaldetails, id: 1);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();
    final type = '${goalEntity?.goalType?.typeName ?? ''} $goalName';
    final bike = type.toLowerCase().contains('bike');
    return Column(
      children: [
        Expanded(
          child: GoalCard(
            goalName: goalName,
            targetAmount: targetAmount,
            investedAmount: investedAmount,
            progressPercent: goalEntity?.progressPercent,
            iconUrl: iconUrl,
            emoji: bike ? '🏍️' : controller.getGoalEmoji(type),
            fallbackIcon: bike
                ? Icons.two_wheeler_rounded
                : controller.getGoalIcon(type),
            onTap: _openDetails,
          ),
        ),
        SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _openDetails,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('View Details'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openDetails(addFund: true),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Add Fund'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
