import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';

class GoalStepItem {
  final String topTitle;
  final String imagePath;
  final String bottomTitle;
  final String description;
  final String buttonText;
  final bool isPrimaryButton;

  const GoalStepItem({
    required this.topTitle,
    required this.imagePath,
    required this.bottomTitle,
    required this.description,
    required this.buttonText,
    required this.isPrimaryButton,
  });
}

class GoalBeyondSavingView extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final Future<void> Function()? onRefresh;

  const GoalBeyondSavingView({
    super.key,
    this.onNext,
    this.onSkip,
    this.onRefresh,
  });

  @override
  State<GoalBeyondSavingView> createState() => _GoalBeyondSavingViewState();
}

class _GoalBeyondSavingViewState extends State<GoalBeyondSavingView>
    with TickerProviderStateMixin {
  late final AnimationController _transitionController;
  late final CurvedAnimation _transitionCurve;

  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  late final AnimationController _slabsEntranceController;
  bool _isStackPressed = false;

  static const String _topSlabAsset = 'assets/images/Isometric slabs.png';
  static const String _middleSlabAsset = 'assets/images/Isometric slabs (1).png';
  static const String _bottomSlabAsset = 'assets/images/Isometric slabs (2).png';

  static const String _topSlabFallback = 'assets/images/isometric_slab_top.png';
  static const String _middleSlabFallback = 'assets/images/isometric_slab_middle.png';
  static const String _bottomSlabFallback = 'assets/images/isometric_slab_bottom.png';

  int _currentPage = 0;
  int _previousPage = 0;

  static const List<GoalStepItem> _steps = [
    GoalStepItem(
      topTitle: 'Beyond\nSaving',
      imagePath: 'assets/images/goal_step1_3d.png',
      bottomTitle: 'Goals, Reimagined',
      description:
          'Stack every dream — car, home,education — into one plan that grows on its own.',
      buttonText: 'Next',
      isPrimaryButton: false,
    ),
    GoalStepItem(
      topTitle: 'Watch It\nGrow',
      imagePath: 'assets/images/goal_step2_3d.png',
      bottomTitle: 'Costs, Decoded',
      description:
          'See what your goal will really cost on the day you need it — and how your SIP closes the gap.',
      buttonText: 'Next',
      isPrimaryButton: false,
    ),
    GoalStepItem(
      topTitle: 'Set It &\nForget It',
      imagePath: 'assets/images/goal_step3_3d.png',
      bottomTitle: 'Autopay, Simplified',
      description:
          'Pick a date once. Your SIP invests every month while you get on with life.',
      buttonText: 'Start planning',
      isPrimaryButton: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _transitionCurve = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOutCubic,
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOutSine,
      ),
    );

    _slabsEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Automatically trigger staggered entrance animation on initial display
    _slabsEntranceController.forward();
  }

  @override
  void dispose() {
    _slabsEntranceController.dispose();
    _transitionController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _triggerSlabsCascade() {
    _slabsEntranceController.forward(from: 0.0);
  }

  void _goToPage(int targetPage) {
    if (_transitionController.isAnimating) return;
    if (targetPage < 0 || targetPage >= _steps.length) return;
    if (targetPage == _currentPage) return;

    setState(() {
      _previousPage = _currentPage;
      _currentPage = targetPage;
    });

    _transitionController.forward(from: 0.0);

    if (targetPage == 0) {
      _slabsEntranceController.forward(from: 0.0);
    }
  }

  void _handleFinish() async {
    if (widget.onNext != null) {
      widget.onNext!();
      return;
    }
    if (Get.isRegistered<GoalSipController>()) {
      final controller = Get.find<GoalSipController>();
      controller.resetStateForNewGoal();
      await controller.getMasterGoals();
    }
    Get.toNamed(AppRoutes.masterGoalsPage);
  }

  void _handleSkip() async {
    if (widget.onSkip != null) {
      widget.onSkip!();
      return;
    }
    if (Get.isRegistered<GoalSipController>()) {
      final controller = Get.find<GoalSipController>();
      controller.resetStateForNewGoal();
      await controller.getMasterGoals();
    }
    Get.toNamed(AppRoutes.masterGoalsPage);
  }

  void _onButtonPressed() {
    if (_currentPage < _steps.length - 1) {
      _goToPage(_currentPage + 1);
    } else {
      _handleFinish();
    }
  }

  Widget _buildSlabImage(String primaryPath, String fallbackPath) {
    return Image.asset(
      primaryPath,
      width: 260,
      height: 270,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackPath,
          width: 260,
          height: 270,
          fit: BoxFit.contain,
        );
      },
    );
  }

  Widget _buildStep1AnimatedSlabs({
    double scale = 1.0,
    Offset offset = Offset.zero,
    double opacity = 1.0,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slabsEntranceController, _floatController]),
      builder: (context, child) {
        final double entrance = _slabsEntranceController.value;
        final double floatVal = _floatAnimation.value;

        // 1. Bottom Foundation Slab (Golden/Orange) Interval: [0.0, 0.45] -> enters first from bottom
        final double bInterval = const Interval(0.0, 0.45, curve: Curves.easeOutBack)
            .transform(entrance);
        final double bOpacityVal = const Interval(0.0, 0.30, curve: Curves.easeIn)
            .transform(entrance);
        final double bScaleVal = 0.82 + (0.18 * bInterval);
        final double bTranslateY = (1.0 - bInterval) * 85.0 + (floatVal * 0.35);

        // 2. Middle Slab (Deep Purple) Interval: [0.25, 0.72] -> drops in second
        final double mInterval = const Interval(0.25, 0.72, curve: Curves.easeOutBack)
            .transform(entrance);
        final double mOpacityVal = const Interval(0.25, 0.50, curve: Curves.easeIn)
            .transform(entrance);
        final double mScaleVal = 0.85 + (0.15 * mInterval);
        final double mTranslateY = (1.0 - mInterval) * -80.0 + (floatVal * 0.65);

        // 3. Top Slab (Lavender Glass) Interval: [0.50, 1.00] -> drops in third to complete stack
        final double tInterval = const Interval(0.50, 1.00, curve: Curves.easeOutBack)
            .transform(entrance);
        final double tOpacityVal = const Interval(0.50, 0.78, curve: Curves.easeIn)
            .transform(entrance);
        final double tScaleVal = 0.85 + (0.15 * tInterval);
        final double tTranslateY = (1.0 - tInterval) * -95.0 + (floatVal * 1.0);

        // Ambient floor shadow beneath foundation slab
        final double shadowOpacityVal = bOpacityVal *
            (0.20 + 0.05 * (1.0 - (floatVal / 6.0).clamp(-1.0, 1.0)));
        final double shadowScaleVal =
            bScaleVal * (1.0 - 0.06 * (floatVal / 6.0).clamp(-1.0, 1.0));

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _isStackPressed = true),
          onTapUp: (_) => setState(() => _isStackPressed = false),
          onTapCancel: () => setState(() => _isStackPressed = false),
          onTap: _triggerSlabsCascade,
          child: AnimatedScale(
            scale: (_isStackPressed ? 0.94 : 1.0) * scale,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            child: Transform.translate(
              offset: offset,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: SizedBox(
                  width: 260,
                  height: 270,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Ambient Floor Glow/Shadow
                      Positioned(
                        bottom: 8,
                        child: Opacity(
                          opacity: shadowOpacityVal.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: shadowScaleVal,
                            child: Container(
                              width: 170,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0E176F)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 24,
                                    spreadRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 1. Foundation / Bottom Slab (Golden/Orange)
                      Opacity(
                        opacity: bOpacityVal.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, bTranslateY),
                          child: Transform.scale(
                            scale: bScaleVal,
                            child: _buildSlabImage(
                              _bottomSlabAsset,
                              _bottomSlabFallback,
                            ),
                          ),
                        ),
                      ),

                      // 2. Middle Slab (Deep Purple)
                      Opacity(
                        opacity: mOpacityVal.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, mTranslateY),
                          child: Transform.scale(
                            scale: mScaleVal,
                            child: _buildSlabImage(
                              _middleSlabAsset,
                              _middleSlabFallback,
                            ),
                          ),
                        ),
                      ),

                      // 3. Top Slab (Lavender Glass)
                      Opacity(
                        opacity: tOpacityVal.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, tTranslateY),
                          child: Transform.scale(
                            scale: tScaleVal,
                            child: _buildSlabImage(
                              _topSlabAsset,
                              _topSlabFallback,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMorphIllustration() {
    return AnimatedBuilder(
      animation: Listenable.merge([_transitionController, _floatController]),
      builder: (context, child) {
        final progress = _transitionCurve.value;
        final floatOffset = Offset(0, _floatAnimation.value);

        if (_transitionController.isAnimating || progress < 1.0) {
          final fromStep = _steps[_previousPage];
          final toStep = _steps[_currentPage];

          // Dynamic scale and translation parameters for Smart Animate feel
          final isMorph1to2 = (_previousPage == 0 && _currentPage == 1);
          final isMorph2to1 = (_previousPage == 1 && _currentPage == 0);

          double fromScale = 1.0;
          double toScale = 1.0;
          Offset fromOffset = Offset.zero;
          Offset toOffset = Offset.zero;

          if (isMorph1to2) {
            fromScale = 1.0 - (0.04 * progress);
            toScale = 0.96 + (0.04 * progress);
            fromOffset = Offset(-10 * progress, 6 * progress);
            toOffset = Offset(12 * (1 - progress), -8 * (1 - progress));
          } else if (isMorph2to1) {
            fromScale = 1.0 - (0.04 * progress);
            toScale = 0.96 + (0.04 * progress);
            fromOffset = Offset(12 * progress, -8 * progress);
            toOffset = Offset(-10 * (1 - progress), 6 * (1 - progress));
          } else {
            // General dissolve for Step 2 <-> Step 3
            fromScale = 1.0 - (0.03 * progress);
            toScale = 0.97 + (0.03 * progress);
          }

          final Widget outgoingWidget = _previousPage == 0
              ? _buildStep1AnimatedSlabs(
                  scale: fromScale,
                  offset: fromOffset,
                  opacity: (1.0 - progress).clamp(0.0, 1.0),
                )
              : Opacity(
                  opacity: (1.0 - progress).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: fromOffset,
                    child: Transform.scale(
                      scale: fromScale,
                      child: Image.asset(
                        fromStep.imagePath,
                        width: 260,
                        height: 270,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );

          final Widget incomingWidget = _currentPage == 0
              ? _buildStep1AnimatedSlabs(
                  scale: toScale,
                  offset: toOffset,
                  opacity: progress.clamp(0.0, 1.0),
                )
              : Opacity(
                  opacity: progress.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: toOffset,
                    child: Transform.scale(
                      scale: toScale,
                      child: Image.asset(
                        toStep.imagePath,
                        width: 260,
                        height: 270,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );

          return Transform.translate(
            offset: floatOffset,
            child: SizedBox(
              width: 260,
              height: 270,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  outgoingWidget,
                  incomingWidget,
                ],
              ),
            ),
          );
        }

        // Settled state for Step 1
        if (_currentPage == 0) {
          return _buildStep1AnimatedSlabs();
        }

        final currentStep = _steps[_currentPage];
        return Transform.translate(
          offset: floatOffset,
          child: SizedBox(
            width: 260,
            height: 270,
            child: Image.asset(
              currentStep.imagePath,
              width: 260,
              height: 270,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_currentPage];
    final isStep3 = _currentPage == 2;

    Widget content = SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -200) {
                  // Swiped left -> advance
                  if (_currentPage < _steps.length - 1) {
                    _goToPage(_currentPage + 1);
                  }
                } else if (details.primaryVelocity! > 200) {
                  // Swiped right -> previous
                  if (_currentPage > 0) {
                    _goToPage(_currentPage - 1);
                  }
                }
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Top Action: Skip button
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _handleSkip,
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 6.0,
                                ),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontFamily: FontFamily.regular,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6E6E73),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Gap(10),

                        // Animated Top Heading (In-place crossfade with subtle vertical slide)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 380),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.08),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            currentStep.topTitle,
                            key: ValueKey('top_${currentStep.topTitle}'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: FontFamily.bold,
                              fontSize: 36,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1D1D1F),
                              letterSpacing: -0.6,
                            ),
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Center 3D Illustration with Smart Animate Morph
                        _buildMorphIllustration(),

                        const Spacer(flex: 3),

                        // Animated Lower Title & Description (In-place crossfade)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Column(
                            key: ValueKey('bottom_${currentStep.bottomTitle}'),
                            children: [
                              Text(
                                currentStep.bottomTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: FontFamily.bold,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D1D1F),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const Gap(12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  currentStep.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: FontFamily.regular,
                                    fontSize: 14.5,
                                    height: 1.45,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF86868B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Animated Page Indicator Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_steps.length, (index) {
                            final isActive = _currentPage == index;
                            return GestureDetector(
                              onTap: () => _goToPage(index),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  width: isActive ? 20.0 : 6.0,
                                  height: 6.0,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? (isStep3
                                            ? Ucolors.goalPrimary
                                            : const Color(0xFF1D1D1F))
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const Gap(16),

                        // Animated Action Button (Outlined pill for steps 1 & 2 -> Gradient Theme for step 3)
                        Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 320),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: isStep3
                                ? InkWell(
                                    key: const ValueKey('step3_button'),
                                    onTap: _onButtonPressed,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 42,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: Ucolors.goalButtonGradient,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Ucolors.goalPrimary
                                                .withValues(alpha: 0.35),
                                            blurRadius: 14,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            currentStep.buttonText,
                                            style: const TextStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Gap(8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    key: const ValueKey('next_button'),
                                    onTap: _onButtonPressed,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 36,
                                        vertical: 12.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color(0xFF1D1D1F)
                                              .withValues(alpha: 0.65),
                                          width: 1.1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            currentStep.buttonText,
                                            style: const TextStyle(
                                              fontFamily: FontFamily.medium,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1D1D1F),
                                            ),
                                          ),
                                          const Gap(8),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 16,
                                            color: Color(0xFF1D1D1F),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),

                        const Gap(32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: content,
      );
    }

    return content;
  }
}
