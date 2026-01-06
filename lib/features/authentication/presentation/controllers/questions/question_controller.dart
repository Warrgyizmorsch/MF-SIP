import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_sip/features/authentication/data/models/questions_model.dart';
import 'package:my_sip/features/dashboard/screen/comparison_screen.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class QuestionController extends GetxController {
  // Observables
  final RxInt currentStep = 0.obs;
  final RxMap<String, String> answers = <String, String>{}.obs;

  final RxDouble queInidcator = 0.0.obs;

  final RxSet<int> _answeredSteps = <int>{}.obs;

  // Questions data
  final List<QuestionModel> questions = [
    QuestionModel(
      step: 1,
      title: "Select Age Group",
      subtitle: "This helps us personalize your investment horizon.",
      options: [
        Option(label: "20–35 Years"),
        Option(label: "36–50 Years"),
        Option(label: "51+ Years"),
      ],
    ),
    QuestionModel(
      step: 2,
      title: "Risk Appetite",
      subtitle: "How comfortable are you with market ups and downs?",
      options: [
        Option(label: "High"),
        Option(label: "Medium"),
        Option(label: "Low"),
      ],
    ),
    QuestionModel(
      step: 3,
      title: "What is your yearly income?",
      subtitle:
          "We need this to check if you are investing the correct amount each month",
      options: [
        Option(label: "Less then ₹12 Lakhs"),
        Option(label: "₹12L to ₹50 Lakhs"),
        Option(label: "More than ₹50 Lakhs"),
      ],
    ),
    QuestionModel(
      step: 4,
      title: "What is your primary source of income?",
      subtitle: "To evaluate how stable your income is",
      options: [
        Option(label: "I’m a Salaried employee"),
        Option(label: "I run a business"),
        Option(label: "I’m retired with pension"),
      ],
    ),
  ];

  // Getters
  QuestionModel get currentQuestion => questions[currentStep.value];
  String? get currentAnswer => answers[currentQuestion.title];
  bool get canContinue => currentAnswer != null;
  bool get isLastStep => currentStep.value == questions.length - 1;

  // Actions
  void selectOption(String label) {
    answers[currentQuestion.title] = label;

    answers.refresh(); // or update() - refresh is preferred for RxMap
    if (!_answeredSteps.contains(currentStep.value)) {
      _answeredSteps.add(currentStep.value);
      queInidcator.value = _answeredSteps.length / questions.length;
    }
  }

  void nextStep() {
    if (!isLastStep) {
      currentStep.value++;

      log('${currentStep.value}');
    } else {
      // Get.offAll(() => ComparisonScreen());
      Get.offAll(() => NavigationMenuBar());
      log('DashBoard Screen');
      log('${currentStep.value}');
    }
  }

  @override
  void onClose() {
    currentStep.value = 0;
    // queInidcator.value = 0.0;
    answers.clear();
    // super.onClose();
  }
}
