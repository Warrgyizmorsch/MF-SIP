import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/appbar/custom_appbar_normal.dart';
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final goals = controller.goalResponse.value?.data ?? [];

      if (!controller.isLoadingGoals.value && goals.isEmpty) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F8),
          body: _buildMobileEmptyState(),
        );
      }

      return Scaffold(
        backgroundColor: GoalCard.backgroundColor,
        appBar: CustomAppBarNormal(
          backgroundColor: GoalCard.backgroundColor,
          title: 'Goal',
          backIcon: false,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth > 0
                ? constraints.maxWidth
                : 400;

            final crossAxisCount = availableWidth < 500 ? 2 : 3;

            if (controller.isLoadingGoals.value) {
              return const GoalShimmerGrid();
            }

            return RefreshIndicator(
              onRefresh: () => controller.getAllGoals(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        '${goals.length} Active Goal${goals.length == 1 ? '' : 's'}',
                        style: UTextStyles.bodySmall.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final goal = goals[index];
                        final double target = goal.targetAmount > 0
                            ? goal.targetAmount
                            : (double.tryParse(
                                    goal.goalType?.targetAmount.toString() ??
                                        '0',
                                  ) ??
                                  0.0);
                        final double invested = goal.investedAmount > 0
                            ? goal.investedAmount
                            : (target * (goal.progressPercent / 100));
                        final String name = goal.goalName.isNotEmpty
                            ? goal.goalName
                            : 'Goal ${index + 1}';
                        final String logo = goal.goalCover.isNotEmpty
                            ? goal.goalCover
                            : (goal.goalType?.logo ?? '');

                        return MobileGoalCard(
                          goalEntity: goal,
                          goalName: name,
                          targetAmount: target,
                          investedAmount: invested,
                          iconUrl: logo,
                        );
                      }, childCount: goals.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: GoalCard.aspectRatio,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            );
          },
        ),
        floatingActionButton: controller.isLoadingGoals.value
            ? const SizedBox.shrink()
            : FloatingActionButton(
                tooltip: 'Add new goal',
                onPressed: () async {
                  controller.resetStateForNewGoal();
                  await controller.getMasterGoals();
                  Get.toNamed(AppRoutes.masterGoalsPage);
                },
                backgroundColor: Ucolors.primary,
                child: const Icon(Icons.add, color: Colors.white),
              ),
      );
    });
  }

  Widget _buildMobileEmptyState() {
    return GoalBeyondSavingView(
      onRefresh: () => controller.getAllGoals(),
      onNext: () async {
        controller.resetStateForNewGoal();
        await controller.getMasterGoals();
        Get.toNamed(AppRoutes.masterGoalsPage);
      },
      onSkip: () async {
        controller.resetStateForNewGoal();
        await controller.getMasterGoals();
        Get.toNamed(AppRoutes.masterGoalsPage);
      },
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
              final String name = goal.goalName.isNotEmpty
                  ? goal.goalName
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
