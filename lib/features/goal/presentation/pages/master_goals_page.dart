import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/goal_sip_controller.dart';

class MasterGoalsPage extends  GetView<GoalSipController> {
  const MasterGoalsPage({super.key});

  IconData getGoalIcon(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'house':
        return Icons.home_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'marriage':
        return Icons.favorite_rounded;
      case 'retirement':
        return Icons.elderly_rounded;
      case 'vacation':
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  Color getGoalColor(String goalType) {
    switch (goalType.toLowerCase()) {
      case 'car':
        return Colors.blue;
      case 'house':
        return Colors.orange;
      case 'education':
        return Colors.green;
      case 'marriage':
        return Colors.pink;
      case 'retirement':
        return Colors.deepPurple;
      case 'vacation':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GoalSipController>(
      initState: (_) async {
       await controller.getMasterGoals();
      },
      builder: (controller) {

        if (controller.isMasterGoalLoading.value) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (controller.masterGoals.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text("No Goals Found"),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xffF5F7FB),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Master Goals',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          body: LayoutBuilder(
            builder: (context, constraints) {

              final width = constraints.maxWidth;

              int crossAxisCount = 1;

              if (width > 1200) {
                crossAxisCount = 4;
              } else if (width > 900) {
                crossAxisCount = 3;
              } else if (width > 600) {
                crossAxisCount = 2;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: controller.masterGoals.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {

                  final goal = controller.masterGoals[index];

                  final isSelected =
                      controller.selectedGoalIndex.value == index;

                  return AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: isSelected ? 1.03 : 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isSelected
                              ? getGoalColor(goal.goalType)
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? getGoalColor(goal.goalType)
                                .withOpacity(.25)
                                : Colors.black.withOpacity(.06),
                            blurRadius: isSelected ? 20 : 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () {

                          controller.selectedGoalIndex.value = index;

                          controller.update();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              /// TOP
                              Row(
                                children: [

                                  Container(
                                    height: 58,
                                    width: 58,
                                    decoration: BoxDecoration(
                                      color: getGoalColor(goal.goalType)
                                          .withOpacity(.12),
                                      borderRadius:
                                      BorderRadius.circular(18),
                                    ),
                                    child: Icon(
                                      getGoalIcon(goal.goalType),
                                      color:
                                      getGoalColor(goal.goalType),
                                      size: 30,
                                    ),
                                  ),

                                  const Spacer(),

                                  AnimatedContainer(
                                    duration: const Duration(
                                        milliseconds: 300),
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? getGoalColor(goal.goalType)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? getGoalColor(goal.goalType)
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                        : null,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              /// TITLE
                              Text(
                                goal.goalType.capitalizeFirst ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// DESCRIPTION
                              Text(
                                goal.goalDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                ),
                              ),

                              const Spacer(),

                              /// BOTTOM CARD
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [

                                    /// TARGET
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [

                                          Text(
                                            'Target Amount',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                              Colors.grey.shade600,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            '₹${goal.targetAmount.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.grey.shade300,
                                    ),

                                    /// TENURE
                                    Expanded(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [

                                            Text(
                                              'Tenure',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors
                                                    .grey.shade600,
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              '${goal.goalTenure} Years',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}