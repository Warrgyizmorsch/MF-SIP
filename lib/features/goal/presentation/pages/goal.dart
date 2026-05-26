import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/utils/constant/appUrl.dart';
import '../controller/goal_sip_controller.dart';
import 'ihavegoal.dart';


class GoalScreen extends GetView<GoalSipController> {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllGoals();
    });

    return Scaffold(
      backgroundColor: Ucolors.light,
      appBar: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        title: 'Goals',
        backIcon: false,
        actionsPadding: 10,
        action: [
          CompactIcon(icon: Iconsax.info_circle, onPressed: () {})
        ],
      ),

      body: Obx(() {
        if (controller.isLoadingGoals.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final goals = controller.goalResponse.value?.data ?? [];

        if (goals.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Ucolors.skyblue1,
                  child: Icon(Iconsax.note_remove5,
                      color: Ucolors.blue, size: 35),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ready to start saving?',
                  style: UTextStyles.large.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  'You haven\'t set any savings goals yet',
                  style: UTextStyles.bodySmall,
                ),
                const SizedBox(height: 25),
                UElevatedBUtton(
                  onPressed: () => Get.toNamed(AppRoutes.masterGoalsPage),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Create Your First Goal',
                          style: UTextStyles.buttonText),
                      const SizedBox(width: 10),
                      const Icon(Icons.add, color: Ucolors.light),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getAllGoals(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Static header outside scroll
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${goals.length} Active Goal${goals.length == 1 ? '' : 's'}',
                  style: UTextStyles.bodySmall,
                ),
              ),

              // ✅ Expanded so CustomScrollView takes remaining space
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final goal = goals[index];
                            final double target = double.tryParse(
                                goal.goalType?.targetAmount.toString() ?? '0') ??
                                0.0;
                            final double invested = double.tryParse(
                                goal.goalType?.investedAmount.toString() ?? '0') ??
                                0.0;
                            final String name = goal.goalName ?? 'Goal ${index + 1}';
                            final String logo = goal.goalType?.logo ?? '';

                            return CircularUploadIndicator(
                              goalEntity: goal,
                              goalName: name,
                              targetAmount: target,
                              investedAmount: invested,
                              iconUrl: logo,
                            );
                          },
                          childCount: goals.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.82,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              ),
            ],
          ),
        );
      }),

      floatingActionButton: Obx(() {
        final hasGoals =
            (controller.goalResponse.value?.data ?? []).isNotEmpty;

        if (!hasGoals || controller.isLoadingGoals.value) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: () async {
            await controller.getMasterGoals();
            controller.selectedGoalIndex.value = -1;
            Get.toNamed(AppRoutes.masterGoalsPage);
          },
          backgroundColor: Ucolors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }
}
class CircularUploadIndicator extends StatelessWidget {
  final UserGoalEntity? goalEntity;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconUrl;

  const CircularUploadIndicator({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconUrl,
    this.goalEntity,
  });

  @override
  Widget build(BuildContext context) {
    final GoalSipController controller = Get.find<GoalSipController>();
    final double percentage = targetAmount > 0
        ? (investedAmount / targetAmount).clamp(0.0, 1.0)
        : 0.0;

    final String percentString =
        "${(percentage * 100).toStringAsFixed(0)}%";
    final Color goalColor = controller.getGoalColor(goalEntity?.goalType?.typeName ?? '');
    return GestureDetector(
      onTap: () {

        Get.toNamed(
          AppRoutes.goaldetails,
          arguments: {
            'goal': goalEntity,
            'target': targetAmount,
            'invested': investedAmount,
            'logo': iconUrl,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double circleSize = constraints.maxHeight * 0.45;

            final imageWidget = (iconUrl != null && iconUrl!.isNotEmpty)
                ? Image.network(
              iconUrl!.startsWith('http')
                  ? iconUrl!
                  : '${Appurl.baseUrl}/$iconUrl',
              width: circleSize * 0.55,
              height: circleSize * 0.55,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return Icon(
                  Icons.flag,
                  size: circleSize * 0.25,
                  color: Colors.grey,
                );
              },
            )
                : Icon(
              Icons.flag,
              size: circleSize * 0.25,
              color: Colors.grey,
            );

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // BACK CIRCLE
                    CircularPercentIndicator(
                      radius: circleSize / 1.3,
                      lineWidth: 8,
                      percent: 1,
                      backgroundColor: Colors.transparent,
                      progressColor: Colors.grey.shade200,
                    ),

                    // PROGRESS CIRCLE
                    CircularPercentIndicator(
                      radius: circleSize / 1.3,
                      lineWidth: 8,
                      percent: percentage,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.transparent,
                      progressColor:goalColor,
                      center: Container(
                        width: circleSize * 0.9,
                        height: circleSize * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // BACK (GRAY VERSION)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.grey.shade300,
                                  BlendMode.modulate,
                                ),
                                child: imageWidget,
                              ),
                            ),

                            // FILL (BASED ON PERCENTAGE)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [
                                      0.0,
                                      percentage,
                                      percentage,
                                      1.0
                                    ],
                                    colors: [
                                      goalColor,
                                      goalColor,
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ).createShader(bounds);
                                },
                                child: imageWidget,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // PERCENT LABEL
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          percentString,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                FittedBox(
                  child: Text(
                    goalName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: UTextStyles.large.copyWith(fontSize: 14),
                  ),
                ),

                FittedBox(
                  child: Text(
                    '₹ ${targetAmount.toStringAsFixed(0)}',
                    style: UTextStyles.medium.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/config/routes/app_routes.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/goal/domain/entity/goal_entity.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// import '../controller/goal_sip_controller.dart';
// import 'ihavegoal.dart';
//
// class GoalScreen extends GetView<GoalSipController> {
//   const GoalScreen({super.key});
//
//   String _goalEmoji(String goalName) {
//     final lower = goalName.toLowerCase();
//     if (lower.contains('car')) return '🚗';
//     if (lower.contains('bike')) return '🏍️';
//     if (lower.contains('home') || lower.contains('house')) return '🏠';
//     if (lower.contains('marriage') || lower.contains('wedding')) return '💍';
//     if (lower.contains('vacation') || lower.contains('travel')) return '✈️';
//     if (lower.contains('education') || lower.contains('study')) return '📚';
//     if (lower.contains('retirement')) return '🏖️';
//     return '🎯';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Fetch goals when screen opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getAllGoals();
//     });
//
//     return Scaffold(
//       backgroundColor: Ucolors.light,
//       appBar: CustomAppBarNormal(
//         backgroundColor: Ucolors.light,
//         title: 'Goals',
//         backIcon: false,
//         actionsPadding: 10,
//         action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
//       ),
//       body: Obx(() {
//         // ── Loading ──────────────────────────────────────────────
//         if (controller.isLoadingGoals.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final goals = controller.goalResponse.value?.data ?? [];
//
//         // ── Empty State ──────────────────────────────────────────
//         if (goals.isEmpty) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Center(
//                   child: CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Ucolors.skyblue1,
//                     child: Icon(
//                       Iconsax.note_remove5,
//                       color: Ucolors.blue,
//                       size: 35,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Ready to start saving?',
//                   style: UTextStyles.large.copyWith(fontSize: 20),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'You haven\'t set any savings goals yet',
//                   style: UTextStyles.bodySmall,
//                 ),
//                 const SizedBox(height: 25),
//                 UElevatedBUtton(
//                   onPressed: () => Get.toNamed(AppRoutes.ihavegoal),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Create Your First Goal',
//                         style: UTextStyles.buttonText,
//                       ),
//                       const SizedBox(width: 10),
//                       const Icon(Icons.add, color: Ucolors.light),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // ── Goals Grid ───────────────────────────────────────────
//         return RefreshIndicator(
//           onRefresh: () => controller.getAllGoals(),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Subtitle count
//                 Text(
//                   '${goals.length} Active Goal${goals.length == 1 ? '' : 's'}',
//                   style: UTextStyles.bodySmall,
//                 ),
//                 const SizedBox(height: 16),
//
//                 // 2-column grid
//                 Expanded(
//                   child: GridView.builder(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     itemCount: goals.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 16,
//                           crossAxisSpacing: 16,
//                           childAspectRatio: 0.88,
//                         ),
//                     itemBuilder: (context, index) {
//                       final goal = goals[index];
//
//                       final double target =
//                           double.tryParse(
//                             goal.goalType?.targetAmount.toString() ?? '0',
//                           ) ??
//                           0.0;
//                       final double invested =
//                           double.tryParse(
//                             goal.goalType?.investedAmount.toString() ?? '0',
//                           ) ??
//                           0.0;
//                       final String name = goal.goalName ?? 'Goal ${index + 1}';
//
//                       return CircularUploadIndicator(
//                         goalEntity: goal,
//                         goalName: name,
//                         targetAmount: target,
//                         investedAmount: invested,
//                         iconEmoji: _goalEmoji(goal.goalType?.logo ?? ''),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//
//       // FAB only visible when goals exist
//       floatingActionButton: Obx(() {
//         final hasGoals = (controller.goalResponse.value?.data ?? []).isNotEmpty;
//         if (!hasGoals || controller.isLoadingGoals.value)
//           return const SizedBox.shrink();
//         return FloatingActionButton(
//           onPressed: () async {
//            await controller.getMasterGoals();
//            controller.selectedGoalIndex.value = -1;
//
//            Get.toNamed(AppRoutes.masterGoalsPage);},
//           backgroundColor: Ucolors.primary,
//           child: const Icon(Icons.add, color: Colors.white),
//         );
//       }),
//     );
//   }
// }
//
// class CircularUploadIndicator extends StatelessWidget {
//   final UserGoalEntity? goalEntity;
//   final String goalName;
//   final double targetAmount;
//   final double investedAmount;
//   final String? iconEmoji; // Optional: e.g., "🚗"
//
//   const CircularUploadIndicator({
//     super.key,
//     required this.goalName,
//     required this.targetAmount,
//     required this.investedAmount,
//     this.iconEmoji,
//     this.goalEntity,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Calculate percentage (0.0 to 1.0)
//     final double percentage = targetAmount > 0
//         ? (investedAmount / targetAmount).clamp(0.0, 1.0)
//         : 0.0;
//
//     // Format percentage string (e.g., "33%")
//     final String percentString = "${(percentage * 100).toStringAsFixed(0)}%";
//
//     final size = MediaQuery.of(context).size;
//
//     return GestureDetector(
//       onTap: () {
//         // Navigate to details if needed, passing ID or data
//         Get.toNamed(
//           AppRoutes.goaldetails,
//           //  arguments: {'goalName': goalName}
//           arguments: {
//             'goal': goalEntity,
//             'emoji': iconEmoji,
//             'target': targetAmount,
//             'invested': investedAmount,
//           },
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final double circleSize = constraints.maxHeight * 0.45;
//
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     CircularPercentIndicator(
//                       radius: circleSize / 1.3,
//                       lineWidth: 8,
//                       percent: 1,
//                       backgroundColor: Colors.transparent,
//                       progressColor: Colors.grey.shade200,
//                     ),
//
//                     CircularPercentIndicator(
//                       radius: circleSize / 1.3,
//                       lineWidth: 8,
//                       percent: percentage,
//                       animation: true,
//                       circularStrokeCap: CircularStrokeCap.round,
//                       backgroundColor: Colors.transparent,
//                       progressColor: Ucolors.blue,
//
//                       center: Container(
//                         width: circleSize * 0.9,
//                         height: circleSize * 0.9,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade50,
//                           shape: BoxShape.circle,
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           iconEmoji ?? "🎯",
//                           style: TextStyle(
//                             fontSize: circleSize * 0.22,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Positioned(
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 5,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 4,
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           percentString,
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 4),
//
//                 FittedBox(
//                   child: Text(
//                     goalName,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: UTextStyles.large.copyWith(
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//
//                 FittedBox(
//                   child: Text(
//                     '₹ ${targetAmount.toStringAsFixed(0)}',
//                     style: UTextStyles.medium.copyWith(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
