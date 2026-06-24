import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../common/widget/appbar/custom_appbar_normal.dart';
import '../../../../common/widget/appbar/widget/compact_icon.dart';
import '../../../../common/widget/button/elevated_button.dart';
import '../../../../common/widget/shimmer/shimmer.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../domain/entity/goal_entity.dart';
import '../controller/goal_sip_controller.dart';
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
    return Scaffold(
      backgroundColor: Ucolors.light,
      appBar: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        title: 'Goals',
        backIcon: false,
        actionsPadding: 10,
        action: [
          CompactIcon(icon: Iconsax.info_circle, onPressed: () {}),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 400;

          int crossAxisCount;
          double aspectRatio;
          double titleFontSize;

          if (availableWidth < 500) {
            crossAxisCount = 2;
            aspectRatio = 0.82;
            titleFontSize = 12.0;
          } else {
            crossAxisCount = 3;
            aspectRatio = 0.85;
            titleFontSize = 14.0;
          }

          return Obx(() {
            if (controller.isLoadingGoals.value) {
              return const GoalShimmerGrid();
            }

            final goals = controller.goalResponse.value?.data ?? [];

            if (goals.isEmpty) {
              return _buildMobileEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () => controller.getAllGoals(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        '${goals.length} Active Goal${goals.length == 1 ? '' : 's'}',
                        style: UTextStyles.bodySmall.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final goal = goals[index];
                        final double target = double.tryParse(goal.goalType?.targetAmount.toString() ?? '0') ?? 0.0;
                        final double invested = double.tryParse(goal.goalType?.investedAmount.toString() ?? '0') ?? 0.0;
                        final String name = goal.goalName ?? 'Goal ${index + 1}';
                        final String logo = goal.goalType?.logo ?? '';

                        return MobileGoalCard(
                          goalEntity: goal,
                          goalName: name,
                          targetAmount: target,
                          investedAmount: invested,
                          iconUrl: logo,
                          titleFontSize: titleFontSize,
                        );
                      }, childCount: goals.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: aspectRatio,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            );
          });
        },
      ),
      floatingActionButton: Obx(() {
        final hasGoals = (controller.goalResponse.value?.data ?? []).isNotEmpty;
        if (!hasGoals || controller.isLoadingGoals.value) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: () async {
            await controller.getMasterGoals();
            controller.selectedGoalIndex.value = -1;
            controller.isGoalSaved.value = false;
            Get.toNamed(AppRoutes.masterGoalsPage);
          },
          backgroundColor: Ucolors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }

  Widget _buildMobileEmptyState() {
    return RefreshIndicator(
      onRefresh: () => controller.getAllGoals(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Ucolors.skyblue1,
                        child: Icon(Iconsax.note_remove5, color: Ucolors.blue, size: 45),
                      ),
                      const Gap(24),
                      Text('Ready to start saving?', style: UTextStyles.large.copyWith(fontSize: 22), textAlign: TextAlign.center),
                      const Gap(8),
                      Text('You haven\'t set any savings goals yet. Start small and watch your wealth grow.', style: UTextStyles.bodySmall.copyWith(fontSize: 14), textAlign: TextAlign.center),
                      const Gap(32),
                      UElevatedBUtton(
                        color: Ucolors.primary,
                        onPressed: () => Get.toNamed(AppRoutes.masterGoalsPage),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Create Your First Goal', style: UTextStyles.buttonText), const Gap(10), const Icon(Icons.add, color: Ucolors.light)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MobileGoalCard extends StatelessWidget {
  final UserGoalEntity? goalEntity;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconUrl;
  final double titleFontSize;

  const MobileGoalCard({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconUrl,
    this.goalEntity,
    required this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final GoalSipController controller = Get.find<GoalSipController>();

    final double safeTarget = targetAmount > 0 ? targetAmount : 1;
    final double percentage = (investedAmount / safeTarget).clamp(0.0, 1.0);
    final String percentString = "${(percentage * 100).toStringAsFixed(0)}%";

    final Color goalColor = controller.getGoalColor(goalEntity?.goalType?.typeName ?? '');

    return GestureDetector(
      onTap: () {
        GoalDetailsPage.tempData = {
          'goal': goalEntity,
          'target': targetAmount,
          'invested': investedAmount,
          'logo': iconUrl,
        };
        Get.toNamed(AppRoutes.goaldetails);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double rawSize = constraints.maxHeight * 0.45;
            final double circleSize = rawSize.clamp(20.0, 300.0);

            final imageWidget = (iconUrl != null && iconUrl!.isNotEmpty)
                ? Image.network(
              iconUrl!.startsWith('http') ? iconUrl! : '${Appurl.baseUrl}/$iconUrl',
              width: circleSize * 0.55,
              height: circleSize * 0.55,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(Icons.flag, size: circleSize * 0.25, color: Colors.grey),
            )
                : Icon(Icons.flag, size: circleSize * 0.25, color: Colors.grey);

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: circleSize / 1.3,
                      lineWidth: 8,
                      percent: 1,
                      backgroundColor: Colors.transparent,
                      progressColor: Colors.grey.shade200,
                    ),
                    CircularPercentIndicator(
                      radius: circleSize / 1.3,
                      lineWidth: 8,
                      percent: percentage,
                      animation: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.transparent,
                      progressColor: goalColor,
                      center: Container(
                        width: circleSize * 0.9,
                        height: circleSize * 0.9,
                        decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(Colors.grey.shade300, BlendMode.modulate),
                                child: imageWidget,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [0.0, percentage, percentage, 1.0],
                                  colors: [goalColor, goalColor, Colors.transparent, Colors.transparent],
                                ).createShader(bounds),
                                child: imageWidget,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Text(
                          percentString,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: FontFamily.medium),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                FittedBox(
                  child: Text(
                    goalName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: UTextStyles.large.copyWith(fontSize: titleFontSize),
                  ),
                ),
                FittedBox(
                  child: Text(
                    '₹ ${targetAmount.toStringAsFixed(0)}',
                    style: UTextStyles.medium.copyWith(color: Colors.grey.shade600, fontSize: titleFontSize - 2),
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




class GoalScreenWeb extends GetView<GoalSipController> {
  const GoalScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double safeHeight = size.height - kToolbarHeight;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
                            fontWeight: FontWeight.bold,
                            color: Color(0xff111827),
                          ),
                        ),
                        const Gap(6),
                        Text(
                          "Track and manage your financial milestones",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.getMasterGoals();
                        controller.selectedGoalIndex.value = -1;
                        controller.isGoalSaved.value = false;
                        Get.toNamed(AppRoutes.webMasterGoalsPage, id: 1);
                        controller.resetStateForNewGoal();
                        controller.update();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(32),
                const Expanded(
                  child: WebGoalGridContent(),
                ),
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
        final double availableWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 400;

        int crossAxisCount;
        double aspectRatio;

        if (availableWidth > 1200) {
          crossAxisCount = 4;
          aspectRatio = 1.38;
        } else if (availableWidth > 900) {
          crossAxisCount = 3;
          aspectRatio = 1.30;
        } else {
          crossAxisCount = 2;
          aspectRatio = 1.25;
        }

        return Obx(() {
          if (controller.isLoadingGoals.value) {
            return const GoalShimmerGrid();
          }

          final goals = controller.goalResponse.value?.data ?? [];

          if (goals.isEmpty) {
            return const Center(child: Text("No dynamic milestones saved yet."));
          }

          return GridView.builder(
            itemCount: goals.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final goal = goals[index];
              final double target = double.tryParse(goal.goalType?.targetAmount.toString() ?? '0') ?? 0.0;
              final double invested = double.tryParse(goal.goalType?.investedAmount.toString() ?? '0') ?? 0.0;
              final String name = goal.goalName ?? 'Goal ${index + 1}';
              final String logo = goal.goalType?.logo ?? '';

              return WebGoalCard(
                goalEntity: goal,
                goalName: name,
                targetAmount: target,
                investedAmount: invested,
                iconUrl: logo,
                showActiveBadge: index == 0,
              );
            },
          );
        });
      },
    );
  }
}

class WebGoalCard extends StatefulWidget {
  final UserGoalEntity? goalEntity;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconUrl;
  final bool showActiveBadge;

  const WebGoalCard({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconUrl,
    this.goalEntity,
    this.showActiveBadge = false,
  });

  @override
  State<WebGoalCard> createState() => _WebGoalCardState();
}

class _WebGoalCardState extends State<WebGoalCard> {
  bool _isHovered = false;

  String _formatIndianCurrency(double amount) {
    String str = amount.toStringAsFixed(0);
    if (str.length <= 3) return str;
    String lastThree = str.substring(str.length - 3);
    String otherNumbers = str.substring(0, str.length - 3);
    final regExp = RegExp(r'\d{1,2}(?=(\d{2})+(?!\d))');
    otherNumbers = otherNumbers.replaceAllMapped(regExp, (Match m) => '${m[0]},');
    return '$otherNumbers,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    final GoalSipController controller = Get.find<GoalSipController>();

    final double safeTarget = widget.targetAmount > 0 ? widget.targetAmount : 1;
    final double percentage = (widget.investedAmount / safeTarget).clamp(0.0, 1.0);
    final String percentString = "${(percentage * 100).toStringAsFixed(0)}%";

    final Color goalColor = controller.getGoalColor(widget.goalEntity?.goalType?.typeName ?? '');

    final bool isNeedsAttention = widget.goalName.toLowerCase().contains("marriage");
    final String statusText = isNeedsAttention ? "Needs Attention" : "On Track";
    final Color statusTextColor = isNeedsAttention ? const Color(0xFFEF4444) : goalColor;
    final Color statusBgColor = isNeedsAttention ? const Color(0xFFFEE2E2) : goalColor.withOpacity(0.1);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          GoalDetailsPage.tempData = {
            'goal': widget.goalEntity,
            'target': widget.targetAmount,
            'invested': widget.investedAmount,
            'logo': widget.iconUrl,
          };
          Get.toNamed(AppRoutes.goaldetails, id: 1);
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.01 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.06 : 0.02),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: Offset(0, _isHovered ? 8 : 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 4.5,
                          percent: percentage,
                          center: CircleAvatar(
                            radius: 26,
                            backgroundColor: const Color(0xFFF8FAFC),
                            child: widget.iconUrl != null && widget.iconUrl!.isNotEmpty
                                ? Image.network(
                              widget.iconUrl!.startsWith('http') ? widget.iconUrl! : '${Appurl.baseUrl}/${widget.iconUrl}',
                              width: 30,
                              height: 30,
                              color: goalColor,
                              errorBuilder: (_, __, ___) => Icon(Icons.flag, color: goalColor),
                            )
                                : Icon(Icons.flag, color: goalColor),
                          ),
                          progressColor: goalColor,
                          backgroundColor: const Color(0xFFE2E8F0),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.goalName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: statusBgColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: statusTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(4),
                              Text(
                                "$percentString completed",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Gap(14),
                    _buildDataRow(Iconsax.radar, "Target:", "₹ ${_formatIndianCurrency(widget.targetAmount)}"),
                    const Gap(8),
                    _buildDataRow(Iconsax.wallet_3, "Saved:", "₹ ${_formatIndianCurrency(widget.investedAmount)}"),
                    const Gap(12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(goalColor),
                      ),
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            GoalDetailsPage.tempData = {
                              'goal': widget.goalEntity,
                              'target': widget.targetAmount,
                              'invested': widget.investedAmount,
                              'logo': widget.iconUrl,
                            };
                            Get.toNamed(AppRoutes.goaldetails, id: 1);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text(
                            "View Details",
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            GoalDetailsPage.tempData = {
                              'goal': widget.goalEntity,
                              'target': widget.targetAmount,
                              'invested': widget.investedAmount,
                              'logo': widget.iconUrl,
                            };
                            Get.toNamed(AppRoutes.goaldetails, id: 1);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Ucolors.primary, width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text(
                            "Add Fund",
                            style: TextStyle(
                              color: Ucolors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              if (widget.showActiveBadge)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const Gap(8),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}