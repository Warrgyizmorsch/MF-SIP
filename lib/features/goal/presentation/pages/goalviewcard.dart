import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../config/routes/app_routes.dart';
import '../controller/goal_sip_controller.dart';
import '../widget/goal_card.dart';

/// A standalone preview of the shared card using the reference's sample goals.
class GoalviewcardPage extends StatelessWidget {
  const GoalviewcardPage({super.key});

  static const _goals = [
    (name: 'Car', target: 30000.0, saved: 9900.0, emoji: '🚗'),
    (name: 'Home Purchase', target: 2000000.0, saved: 500000.0, emoji: '🏠'),
    (name: 'Marriage', target: 1000000.0, saved: 750000.0, emoji: '💍'),
    (name: 'Vacation', target: 3000.0, saved: 1500.0, emoji: '✈️'),
    (name: 'Education', target: 10000.0, saved: 1000.0, emoji: '🎓'),
    (name: 'Bike', target: 10000.0, saved: 5000.0, emoji: '🏍️'),
    (name: 'Personalize', target: 25000.0, saved: 17500.0, emoji: '🎯'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoalCard.backgroundColor,
      appBar: const CustomAppBarNormal(
        title: 'Goal',
        backgroundColor: GoalCard.backgroundColor,
        backIcon: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.builder(
                itemCount: _goals.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (constraints.maxWidth / 200).floor().clamp(
                    2,
                    4,
                  ),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: GoalCard.aspectRatio,
                ),
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return GoalCard(
                    goalName: goal.name,
                    targetAmount: goal.target,
                    investedAmount: goal.saved,
                    emoji: goal.emoji,
                    fallbackIcon: Icons.image_rounded,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: AddNewGoalButton(
                    onPressed: () async {
                      if (Get.isRegistered<GoalSipController>()) {
                        final controller = Get.find<GoalSipController>();
                        controller.resetStateForNewGoal();
                        await controller.getMasterGoals();
                      }
                      Get.toNamed(AppRoutes.masterGoalsPage);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
