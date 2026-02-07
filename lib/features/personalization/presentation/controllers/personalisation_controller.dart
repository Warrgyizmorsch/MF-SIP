import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entity/risk_entity.dart';

import 'dart:async';

class PersonalisationController extends GetxController {

  // UI State
  final PageController pageController = PageController();

  // Observables for Progress & Selection
  var currentQuestionIndex = 0.obs;
  var selectedAnswers = <int, String>{}.obs;

  // Observables for Analysis Screen
  var isAnalyzing = false.obs;
  var analysisText = "Initializing analysis...".obs;

  final List<RiskQuestion> riskQuestions = [
    RiskQuestion(
      id: 1,
      question: "Your Income (Only from Salary, Profession or business and not from investments) is :",
      options: [
        RiskOption(id: 'a', text: "Much more than household expense."),
        RiskOption(id: 'b', text: "Almost equal to household expenses."),
        RiskOption(id: 'c', text: "Less than household expenses that you have to borrow or depend on your investments."),
        RiskOption(id: 'd', text: "There is no income in form of salary or professional income and you are entirely dependent on income from investments."),
      ],
    ),
    RiskQuestion(
      id: 2,
      question: "How much debt outstanding you have as % of total investments?",
      options: [
        RiskOption(id: 'a', text: "More than 75%."),
        RiskOption(id: 'b', text: "Between 50% and 75%."),
        RiskOption(id: 'c', text: "Between 25% and 50%."),
        RiskOption(id: 'd', text: "Less than 25%."),
      ],
    ),
    RiskQuestion(
      id: 3,
      question: "Number of people (other than yourself) dependent on your income?",
      options: [
        RiskOption(id: 'a', text: "None"),
        RiskOption(id: 'b', text: "1 or 2"),
        RiskOption(id: 'c', text: "3 to 5"),
        RiskOption(id: 'd', text: "More than 5."),
      ],
    ),
    RiskQuestion(
      id: 4,
      question: "Approximately when would you need the money being invested right now?",
      options: [
        RiskOption(id: 'a', text: "Within 3 years."),
        RiskOption(id: 'b', text: "Between 3 and 5 years."),
        RiskOption(id: 'c', text: "In 5 to 10 years."),
        RiskOption(id: 'd', text: "More than 10 years."),
      ],
    ),
    RiskQuestion(
      id: 5,
      question: "What has been your experience with investments?",
      options: [
        RiskOption(id: 'a', text: "I have been very comfortable with my investments and I know all that I need to know."),
        RiskOption(id: 'b', text: "I have been investing for a long time but I do not understand much."),
        RiskOption(id: 'c', text: "I only rely on my advisor and do not ask any questions."),
        RiskOption(id: 'd', text: "I only invest in bank deposits and Govt. guaranteed investment schemes."),
      ],
    ),
    RiskQuestion(
      id: 6,
      question: "What is your view regarding the stability of your income?",
      options: [
        RiskOption(id: 'a', text: "Very Stable"),
        RiskOption(id: 'b', text: "Not so Stable"),
        RiskOption(id: 'c', text: "Uncertain"),
        RiskOption(id: 'd', text: "I do not have any professional income."),
      ],
    ),
    RiskQuestion(
      id: 7,
      question: "You have three investment options to choose from:",
      options: [
        RiskOption(id: 'a', text: "Where the value of your investment may go up and down significantly on a monthly basis. However, there is a possibility to be able to improve your living standard."),
        RiskOption(id: 'b', text: "The value of investment may go up and down but not as much as option A. You may barely be able to maintain your lifestyle with such an investment approach"),
        RiskOption(id: 'c', text: "The value of your portfolio will see a slow and steady increase, but your ability to maintain your living standards will be seriously hampered"),
      ],
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }


  void selectOption(int questionId, String optionId) {
    selectedAnswers[questionId] = optionId;

    Future.delayed(const Duration(milliseconds: 300), () {
      nextPage();
    });
  }

  void nextPage() {
    if (currentQuestionIndex.value < riskQuestions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      startRiskAnalysis();
    }
  }

  void previousPage() {
    if (currentQuestionIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  void onPageChanged(int index) {
    currentQuestionIndex.value = index;
  }

  void startRiskAnalysis() async {
    isAnalyzing.value = true;

    analysisText.value = "Securing your responses...";
    await Future.delayed(const Duration(milliseconds: 1500));

    analysisText.value = "Analyzing financial patterns...";
    await Future.delayed(const Duration(milliseconds: 1500));

    analysisText.value = "Calculating risk appetite...";
    await Future.delayed(const Duration(milliseconds: 1500));

    analysisText.value = "Finalizing your profile...";
    await Future.delayed(const Duration(milliseconds: 1000));

    isAnalyzing.value = false;
    submitRiskProfile();
  }

  void submitRiskProfile() {
    Get.back();
    Get.snackbar(
        "Assessment Complete",
        "Your risk profile has been generated successfully.",
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        icon: Icon(Icons.check_circle, color: Colors.green.shade800)
    );
  }
}