// import 'package:flutter/material.dart';

// // ── Main Flow ────────────────────────────────────────────────────────────────
// class OnboardingFlow extends StatefulWidget {
//   const OnboardingFlow({super.key});

//   @override
//   State<OnboardingFlow> createState() => _OnboardingFlowState();
// }

// class _OnboardingFlowState extends State<OnboardingFlow> {
//   int _currentStep = 0;

//   // Store answers
//   final Map<String, String> _answers = {};

//   final List<QuestionModel> _questions = [
//     QuestionModel(
//       step: 1,
//       title: "Select Age Group",
//       subtitle: "This helps us personalize your investment horizon.",
//       options: [
//         Option(label: "20–35 Years", value: "20-35"),
//         Option(label: "36–50 Years", value: "36-50"),
//         Option(label: "51+ Years", value: "51+"),
//       ],
//     ),
//     QuestionModel(
//       step: 2,
//       title: "What's your investment goal?",
//       subtitle: "Choose the main purpose of your investment.",
//       options: [
//         Option(label: "Build long-term wealth", value: "wealth"),
//         Option(label: "Save for retirement", value: "retirement"),
//         Option(label: "Buy a house / car", value: "property"),
//         Option(label: "Generate passive income", value: "income"),
//       ],
//     ),
//     QuestionModel(
//       step: 3,
//       title: "Risk Tolerance",
//       subtitle: "How comfortable are you with market ups and downs?",
//       options: [
//         Option(label: "Very conservative", value: "very_low"),
//         Option(label: "Moderate", value: "moderate"),
//         Option(label: "Aggressive / Growth focused", value: "high"),
//       ],
//     ),
//     QuestionModel(
//       step: 4,
//       title: "Monthly Investment Amount",
//       subtitle: "How much are you planning to invest monthly?",
//       options: [
//         Option(label: "Under ₹5,000", value: "under_5k"),
//         Option(label: "₹5,000 – ₹20,000", value: "5k_20k"),
//         Option(label: "₹20,000 – ₹50,000", value: "20k_50k"),
//         Option(label: "Above ₹50,000", value: "above_50k"),
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final question = _questions[_currentStep];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Step ${question.step} of 4"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: QuestionScreen(
//             question: question,
//             selectedValue: _answers[question.title],
//             onSelected: (value) {
//               setState(() {
//                 _answers[question.title] = value;
//               });
//             },
//             onContinue: () {
//               if (_currentStep < _questions.length - 1) {
//                 setState(() => _currentStep++);
//               } else {
//                 // Finish onboarding
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const SuccessScreen()),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Reusable Question Screen ─────────────────────────────────────────────────
// class QuestionScreen extends StatelessWidget {
//   final QuestionModel question;
//   final String? selectedValue;
//   final ValueChanged<String> onSelected;
//   final VoidCallback onContinue;

//   const QuestionScreen({
//     required this.question,
//     required this.selectedValue,
//     required this.onSelected,
//     required this.onContinue,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 32),

//         Text(
//           'STEP ${question.step} OF 4',
//           style: const TextStyle(
//             color: Colors.grey,
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           question.title,
//           style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           question.subtitle,
//           style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//         ),

//         const Spacer(),

//         ...question.options.map((opt) {
//           final isSelected = selectedValue == opt.value;

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: GestureDetector(
//               onTap: () => onSelected(opt.value),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 220),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? theme.colorScheme.primaryContainer
//                       : Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: isSelected
//                         ? theme.colorScheme.primary
//                         : Colors.grey.shade300,
//                     width: 2,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       opt.label,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: isSelected
//                             ? FontWeight.bold
//                             : FontWeight.w500,
//                         color: isSelected
//                             ? theme.colorScheme.primary
//                             : Colors.black87,
//                       ),
//                     ),
//                     if (isSelected)
//                       Icon(
//                         Icons.check_circle,
//                         color: theme.colorScheme.primary,
//                         size: 28,
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),

//         const Spacer(flex: 2),

//         // const SizedBox(height: 16),
//         SizedBox(
//           width: double.infinity,
//           height: 56,
//           child: FilledButton(
//             onPressed: selectedValue == null ? null : onContinue,
//             style: FilledButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: const Text('Continue', style: TextStyle(fontSize: 17)),
//           ),
//         ),
//         SizedBox(height: 10),
//         Center(
//           child: Text(
//             'Your data 100% safe & secure',
//             style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//           ),
//         ),

//         const SizedBox(height: 24),
//       ],
//     );
//   }
// }

// // ── Models ───────────────────────────────────────────────────────────────────
// class QuestionModel {
//   final int step;
//   final String title;
//   final String subtitle;
//   final List<Option> options;

//   QuestionModel({
//     required this.step,
//     required this.title,
//     required this.subtitle,
//     required this.options,
//   });
// }

// class Option {
//   final String label;
//   final String value;

//   Option({required this.label, required this.value});
// }

// // ── Final Screen (example) ───────────────────────────────────────────────────
// class SuccessScreen extends StatelessWidget {
//   const SuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.check_circle, size: 100, color: Colors.green),
//             const SizedBox(height: 24),
//             const Text(
//               "All set!",
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Your personalized plan is ready",
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             const SizedBox(height: 40),
//             FilledButton(
//               onPressed: () {
//                 // Go to dashboard or home
//               },
//               child: const Text("Start Investing"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// views/question_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/features/authentication/controller/questions/question_controller.dart';

// class QuestionScreen extends GetView<QuestionController> {
//   const QuestionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Obx(() {
//       final question = controller.currentQuestion;
//       final selectedValue = controller.currentAnswer;

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 32),

//           Text(
//             'STEP ${question.step} OF 4',
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             question.title,
//             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             question.subtitle,
//             style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//           ),

//           const Spacer(),

//           ...question.options.map((opt) {
//             final isSelected = selectedValue == opt.value;

//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: GestureDetector(
//                 onTap: () => controller.selectOption(opt.value),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 220),
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? theme.colorScheme.primaryContainer
//                         : Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: isSelected
//                           ? theme.colorScheme.primary
//                           : Colors.grey.shade300,
//                       width: 2,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         opt.label,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                           color: isSelected ? theme.colorScheme.primary : Colors.black87,
//                         ),
//                       ),
//                       if (isSelected)
//                         Icon(
//                           Icons.check_circle,
//                           color: theme.colorScheme.primary,
//                           size: 28,
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }),

//           const Spacer(flex: 2),

//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: Obx(
//               () => FilledButton(
//                 onPressed: controller.canContinue ? controller.nextStep : null,
//                 style: FilledButton.styleFrom(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 ),
//                 child: const Text('Continue', style: TextStyle(fontSize: 17)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Center(
//             child: Text(
//               'Your data 100% safe & secure',
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       );
//     });
//   }
// }

// views/question_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/heading_section.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/features/authentication/controller/questions/question_controller.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class QuestionScreen extends GetView<QuestionController> {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopBottomDecoration(
        design: true,
        child: Obx(() {
          final question = controller.currentQuestion;
          final selectedValue = controller.currentAnswer;

          return Padding(
            padding: UPadding.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //STEP 1 OF 4
                SubtitleText(subtitle: 'STEP ${question.step} OF 4'),
                SizedBox(height: Get.height * 0.007),

                //STEP 1 OF 4 Indicator
                Stack(
                  children: [
                    Container(
                      height: 10,
                      width: Get.width / 2,
                      decoration: BoxDecoration(
                        color: Color(0xffEBF4FF),

                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    Positioned(
                      child: Obx(
                        () => Container(
                          height: 10,
                          width: Get.width / 2 * controller.queInidcator.value,
                          decoration: BoxDecoration(
                            gradient: Ucolors.backgroundGradient,
                            color: Color(0xffEBF4FF),

                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Get.height * 0.002),

                //question
                HeadingText(title: question.title),

                //Subtitle
                SubtitleText(
                  subtitle: question.subtitle,
                  textAlignCenter: TextAlign.start,
                ),
                SizedBox(height: Get.height * 0.006),

                ...question.options.map((opt) {
                  final isSelected = selectedValue == opt.label;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => controller.selectOption(opt.label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? Ucolors.textFormEnabled
                                : const Color(0xFFE0E0E0),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              opt.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w400
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF1976D2)
                                    : Ucolors.darkgrey,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Ucolors.primary,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                //Continue Button
                UElevatedBUtton(
                  onPressed: controller.canContinue
                      ? controller.nextStep
                      : () {},
                  child: Center(
                    child: Text('Continue', style: UTextStyles.buttonText),
                  ),
                ),

                const SizedBox(height: 10),

                //Button Title
                const Center(
                  child: Text(
                    'Your data 100% safe & secure',
                    style: TextStyle(color: Ucolors.dark, fontSize: 13),
                  ),
                ),

                const SizedBox(height: kBottomNavigationBarHeight),
              ],
            ),
          );
        }),
      ),
    );
  }
}
