import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
import 'master_goals_page.dart';

// TODO: Add your internal project imports here (AppRoutes, Ucolors, UTextStyles, etc.)
// import 'master_goals_page.dart'; // Import this to use it in the Drawer

class GoalScreen extends GetView<GoalSipController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllGoals();
    });

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Ucolors.light,
      appBar: isDesktop
          ? null
          : CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        title: 'Goals',
        backIcon: false,
        actionsPadding: 10,
        action: [
          CompactIcon(icon: Iconsax.info_circle, onPressed: () {}),
        ],
      ),
      endDrawer: isDesktop
          ? Drawer(
        width: MediaQuery.of(context).size.width * 0.42,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 30,
                  offset: const Offset(-4, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: MasterGoalsPage(),
                ),
              ],
            ),
          ),
        ),
      )
          : null,
      body: isDesktop ? const _WebLayout() : const _MobileLayout(),
      floatingActionButton: Obx(() {
        final hasGoals = (controller.goalResponse.value?.data ?? []).isNotEmpty;

        if (!hasGoals || controller.isLoadingGoals.value) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: () async {
            await controller.getMasterGoals();
            controller.selectedGoalIndex.value = -1;

            if (isDesktop) {
              _scaffoldKey.currentState?.openEndDrawer();
            } else {
              Get.toNamed(AppRoutes.masterGoalsPage);
            }
          },
          backgroundColor: Ucolors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }
}

class _WebLayout extends StatelessWidget {
  const _WebLayout();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double safeHeight = size.height - kToolbarHeight;

    return Center(
      child: SizedBox(
        width: size.width > 1500 ? 1500 : size.width,
        height: safeHeight > 0 ? safeHeight : 800,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Active Goals",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111827),
                ),
              ),
              const Gap(6),
              Text(
                "Track and manage your financial milestones",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(24),
              const Expanded(child: GoalGridContent(isDesktop: true)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return const GoalGridContent(isDesktop: false);
  }
}

class GoalGridContent extends GetView<GoalSipController> {
  final bool isDesktop;

  const GoalGridContent({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth > 0 ? constraints.maxWidth : 400;

        int crossAxisCount;
        double aspectRatio;
        double titleFontSize;

        if (availableWidth < 500) {
          crossAxisCount = 2;
          aspectRatio = 0.82;
          titleFontSize = 12.0;
        } else if (availableWidth < 900) {
          crossAxisCount = 3;
          aspectRatio = 0.85;
          titleFontSize = 14.0;
        } else if (availableWidth < 1200) {
          crossAxisCount = 4;
          aspectRatio = 0.90;
          titleFontSize = 16.0;
        } else {
          crossAxisCount = 5;
          aspectRatio = 0.95;
          titleFontSize = 16.0;
        }

        return Obx(() {
          if (controller.isLoadingGoals.value) {
            return const GoalShimmerGrid();
          }

          final goals = controller.goalResponse.value?.data ?? [];

          if (goals.isEmpty) {
            return _buildEmptyState();
          }

          Widget gridContent = CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (!isDesktop)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      '${goals.length} Active Goal${goals.length == 1 ? '' : 's'}',
                      style: UTextStyles.bodySmall.copyWith(fontSize: availableWidth > 600 ? 16 : 14),
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16.0, vertical: 8.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final goal = goals[index];
                    final double target = double.tryParse(goal.goalType?.targetAmount.toString() ?? '0') ?? 0.0;
                    final double invested = double.tryParse(goal.goalType?.investedAmount.toString() ?? '0') ?? 0.0;
                    final String name = goal.goalName ?? 'Goal ${index + 1}';
                    final String logo = goal.goalType?.logo ?? '';

                    return CircularUploadIndicator(
                      goalEntity: goal,
                      goalName: name,
                      targetAmount: target,
                      investedAmount: invested,
                      iconUrl: logo,
                      titleFontSize: titleFontSize,
                      isDesktop: isDesktop,
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
          );

          if (isDesktop) {
            return gridContent;
          } else {
            return RefreshIndicator(
              onRefresh: () => controller.getAllGoals(),
              child: gridContent,
            );
          }
        });
      },
    );
  }

  Widget _buildEmptyState() {
    Widget content = Center(
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
    );

    if (isDesktop) return content;

    return RefreshIndicator(
      onRefresh: () => controller.getAllGoals(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(hasScrollBody: false, child: content),
        ],
      ),
    );
  }
}

class CircularUploadIndicator extends StatefulWidget {
  final UserGoalEntity? goalEntity;
  final String goalName;
  final double targetAmount;
  final double investedAmount;
  final String? iconUrl;
  final double titleFontSize;
  final bool isDesktop;

  const CircularUploadIndicator({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.investedAmount,
    this.iconUrl,
    this.goalEntity,
    required this.titleFontSize,
    required this.isDesktop,
  });

  @override
  State<CircularUploadIndicator> createState() => _CircularUploadIndicatorState();
}

class _CircularUploadIndicatorState extends State<CircularUploadIndicator> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final GoalSipController controller = Get.find<GoalSipController>();

    final double safeTarget = widget.targetAmount > 0 ? widget.targetAmount : 1;
    final double percentage = (widget.investedAmount / safeTarget).clamp(0.0, 1.0);
    final String percentString = "${(percentage * 100).toStringAsFixed(0)}%";

    final Color goalColor = controller.getGoalColor(widget.goalEntity?.goalType?.typeName ?? '');

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
          Get.toNamed(AppRoutes.goaldetails);
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: _isHovered ? 0.1 : 0.05), blurRadius: _isHovered ? 15 : 10, offset: Offset(0, _isHovered ? 6 : 4)),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double rawSize = constraints.maxHeight * 0.45;
                final double circleSize = rawSize.clamp(20.0, 300.0);

                final imageWidget = (widget.iconUrl != null && widget.iconUrl!.isNotEmpty)
                    ? Image.network(
                  widget.iconUrl!.startsWith('http') ? widget.iconUrl! : '${Appurl.baseUrl}/${widget.iconUrl}',
                  width: circleSize * 0.55, height: circleSize * 0.55, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(Icons.flag, size: circleSize * 0.25, color: Colors.grey),
                )
                    : Icon(Icons.flag, size: circleSize * 0.25, color: Colors.grey);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularPercentIndicator(radius: circleSize / 1.3, lineWidth: 8, percent: 1, backgroundColor: Colors.transparent, progressColor: Colors.grey.shade200),
                        CircularPercentIndicator(
                          radius: circleSize / 1.3, lineWidth: 8, percent: percentage, animation: true, circularStrokeCap: CircularStrokeCap.round, backgroundColor: Colors.transparent, progressColor: goalColor,
                          center: Container(
                            width: circleSize * 0.9, height: circleSize * 0.9,
                            decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(100), child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.grey.shade300, BlendMode.modulate), child: imageWidget)),
                                ClipRRect(borderRadius: BorderRadius.circular(100), child: ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (Rect bounds) => LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, stops: [0.0, percentage, percentage, 1.0], colors: [goalColor, goalColor, Colors.transparent, Colors.transparent]).createShader(bounds), child: imageWidget)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0, bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                            child: Text(percentString, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: FontFamily.medium)),
                          ),
                        ),
                      ],
                    ),
                    const Gap(4),
                    FittedBox(child: Text(widget.goalName, maxLines: 1, overflow: TextOverflow.ellipsis, style: UTextStyles.large.copyWith(fontSize: widget.titleFontSize))),
                    FittedBox(child: Text('₹ ${widget.targetAmount.toStringAsFixed(0)}', style: UTextStyles.medium.copyWith(color: Colors.grey.shade600, fontSize: widget.titleFontSize - 2))),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}