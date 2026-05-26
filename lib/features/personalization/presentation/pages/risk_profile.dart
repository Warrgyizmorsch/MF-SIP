import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_question_entity.dart';
import 'package:my_sip/features/personalization/domain/usecases/personalisation_use_cases.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

import '../../domain/entity/risk_entity.dart';

class RiskProfile extends GetView<PersonalisationController> {
  const RiskProfile({super.key});

  // Helper to get a relevant icon for each question index
  IconData _getIconForQuestion(int index) {
    switch (index) {
      case 0:
        return Icons.account_balance_wallet_outlined; // Income
      case 1:
        return Icons.pie_chart_outline; // Debt
      case 2:
        return Icons.family_restroom_outlined; // Dependents
      case 3:
        return Icons.update; // Timeline
      case 4:
        return Icons.trending_up; // Experience
      case 5:
        return Icons.shield_outlined; // Stability
      case 6:
        return Icons.balance_outlined; // Risk Appetite
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Dependency Injection Safety Check
    if (!Get.isRegistered<PersonalisationController>()) {
      Get.put(PersonalisationController(Get.find<PersonalisationUseCases>()));
    }

    // 2. Main Obx to switch between Questions and Analysis View
    return Obx(() {
      if (controller.isAnalyzing.value) {
        return const _RiskAnalyzingView();
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              // --- Header: Question Counter ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Obx(
                      () => Text(
                        "Question ${controller.currentQuestionIndex.value + 1}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Ucolors.blue,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "/${controller.riskQuestions.length}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Body: Questions PageView ---
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // User must select option
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.riskQuestions.length,
                  itemBuilder: (context, index) {
                    final question = controller.riskQuestions[index];
                    return _buildQuestionPage(context, question, index);
                  },
                ),
              ),

              InkWell(
                onTap: () => controller.previousPage(),
                child: const Text('Back', style: TextStyle(color: Colors.blue)),
              ),

              // --- Footer: Trust Badge ---
              _buildSecurityFooter(),
            ],
          ),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Risk Assessment',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: Colors.black,
        ),
        onPressed: () => controller.previousPage(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Obx(() {
          if (controller.riskQuestions.isEmpty) return const SizedBox();

          // Calculate target progress (0.0 to 1.0)
          double targetProgress =
              (controller.currentQuestionIndex.value + 1) /
              controller.riskQuestions.length;

          // Smoothly animate the progress bar
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: targetProgress),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[100],
              valueColor: const AlwaysStoppedAnimation<Color>(Ucolors.blue),
              minHeight: 4,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuestionPage(
    BuildContext context,
    QuestionEnitity question,
    int index,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Topic Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Ucolors.blue.withValues(alpha:0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForQuestion(index),
              color: Ucolors.blue,
              size: 28,
            ),
          ),
          const SizedBox(height: 24),

          // 2. Question Text
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),

          // 3. Options List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: question.options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final option = question.options[index];

              return Obx(() {
                final isSelected =
                    controller.selectedAnswers[question.id] == option.id;

                return InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact(); // Haptic Feedback
                    controller.selectOption(question.id, option.id);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Ucolors.blue.withValues(alpha:0.05)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected ? Ucolors.blue : Colors.grey.shade200,
                        width: isSelected ? 2 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Ucolors.blue.withValues(alpha:0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha:0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        // Radio Circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Ucolors.blue
                                  : Colors.grey.shade300,
                              width: isSelected
                                  ? 7
                                  : 2, // Thicker border fills the circle
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text
                        Expanded(
                          child: Text(
                            option.text,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? Ucolors.blue : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSecurityFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.gpp_good_outlined, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 6),
          Text(
            "Encrypted & Secure Assessment",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Internal Widget: The "Premium" Loading Screen ---
class _RiskAnalyzingView extends StatefulWidget {
  const _RiskAnalyzingView();

  @override
  State<_RiskAnalyzingView> createState() => _RiskAnalyzingViewState();
}

class _RiskAnalyzingViewState extends State<_RiskAnalyzingView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutQuad),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PersonalisationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Animated Graphic
            SizedBox(
              height: 150,
              width: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse Ring
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Ucolors.blue.withValues(alpha:0.05),
                      ),
                    ),
                  ),
                  // Rotating Loader
                  const SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Ucolors.blue),
                    ),
                  ),
                  // Center Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Ucolors.blue.withValues(alpha:0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      size: 36,
                      color: Ucolors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // 2. Animated Status Text
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  controller.analysisText.value,
                  key: ValueKey<String>(controller.analysisText.value),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. Subtext
            Text(
              "Please do not close the app",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
