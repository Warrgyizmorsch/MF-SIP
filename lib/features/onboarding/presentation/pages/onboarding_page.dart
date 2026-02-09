import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/features/onboarding/presentation/controller/onboarding_controller.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/utils/constant/text.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Ucolors.skyblue,

      body: TopBottomDecoration(
        opacity: 1,
        design: true,
        child: SafeArea(
          // bottom: true,
          child: Stack(
            children: [
              // Main Content: Image + Title + Subtitle
              // Gap(20),
              PageView(
                // physics: BouncingScrollPhysics(),
                controller: controller.pagecontroller,
                onPageChanged: controller.updatePage,
                children: [
                  OnBoardingContent(
                    image: UImages.onboarding1,
                    title: UText.onboardingTitle1,
                    subtitle: UText.onboardingSubtitle1,
                  ),
                  OnBoardingContent(
                    image: UImages.onboarding2,
                    title: UText.onboardingTitle2,
                    subtitle: UText.onboardingSubtitle2,
                  ),
                  OnBoardingContent(
                    image: UImages.onboarding3,
                    title: UText.onboardingTitle3,
                    subtitle: UText.onboardingSubtitle3,
                  ),
                  // OnBoardingContent(
                  //   image: UImages.onboarding4,
                  //   title: UText.onboardingTitle4,
                  //   subtitle: UText.onboardingSubtitle4,
                  // ),
                ],
              ),

              // Bottom Buttons (Next + Skip)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                // size.height * 0.02, // Consistent from bottom on all devices
                child: Obx(() {
                  final isLastPage = controller.currentIndex.value == 2;
                  final index = controller.currentIndex.value;
                  final data = onboardingData[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    height: size.height / 2,
                    // width: /,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(
                            0,
                            -4,
                          ), // shadow on top (card effect)
                        ),
                      ],
                      color: Ucolors.light,
                      // color: Colors.grey.shade200,
                      // color: Colors.lightBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        // topLeft: Radius.elliptical(50, 30),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity == null) return;

                        /// Swipe LEFT → Next page
                        if (details.primaryVelocity! < 0) {
                          controller.pagecontroller.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOut,
                          );
                        }
                        /// Swipe RIGHT → Previous page
                        else if (details.primaryVelocity! > 0) {
                          controller.pagecontroller.previousPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOut,
                          );
                        }
                      },

                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Gap(30),
                          // SmoothPageIndicator(
                          //   effect: ExpandingDotsEffect(
                          //     activeDotColor: Ucolors.blue,
                          //     dotWidth: 10,
                          //     dotHeight: 10,
                          //   ),

                          //   controller: controller.pagecontroller,
                          //   count: 4,
                          // ),
                          // Gap(25),
                          SizedBox(
                            height: 70,
                            child: RichTypewriterText(
                              key: ValueKey(data.title), // 🔥 REQUIRED
                              speed: const Duration(milliseconds: 50),
                              spans: [
                                TextSpan(
                                  text: '${data.title.split('\n').first}\n',
                                  style: UTextStyles.large.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${data.title.split('\n').last.split(' ').first} ',
                                  style: UTextStyles.large.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: data.title.split(' ').last,
                                  style: UTextStyles.large.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Ucolors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                    
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Text(
                              key: ValueKey(data.subtitle), // 🔥 REQUIRED
                              data.subtitle,
                              textAlign: TextAlign.center,
                              style: UTextStyles.medium.copyWith(
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          ),

                        
                          SmoothPageIndicator(
                            effect: ExpandingDotsEffect(
                              activeDotColor: Ucolors.blue,
                              dotWidth: 10,
                              dotHeight: 10,
                            ),

                            controller: controller.pagecontroller,
                            count: 3,
                          ),

                          // Next / Get Started Button
                          // Spacer(),
                          SizedBox(
                            width: size.width / 1.5,

                            child: UElevatedBUtton(
                              circular: 30,

                              // width: size.width / 1.6,
                              onPressed: controller.nextPage,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLastPage ? 'Get Started' : 'Next',
                                    style: UTextStyles.buttonText.copyWith(
                                      fontSize: isLastPage ? 16 : 14,
                                    ),
                                  ),
                                  if (!isLastPage) ...[
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Ucolors.light,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnBoardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: image == 'assets/images/onboarding/onboarding1.png'
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Gap(kToolbarHeight + 40),
        // Image - Takes ~45% of screen height
        SizedBox(
          // height: image != 'assets/images/onboarding/onboarding1.png'
          //     ? size.height * 0.3
          //     : null,
          height: size.height * 0.3,
          width: image == 'assets/images/onboarding/onboarding1.png'
              ? size.width * 0.8
              : size.height * 0.3,
          // width: image == 'assets/images/onboarding/onboarding1.png'
          //     ? double.infinity
          //     : size.width,
          child: Image.asset(image, fit: BoxFit.fitWidth),
        ),

        // SizedBox(height: size.height * 0.03),
        Gap(25),

        // // Title
        // Text(
        //   title,
        //   style: UTextStyles.large.copyWith(fontSize: 20),
        //   textAlign: TextAlign.left,
        // ),
        // SizedBox(height: size.height * 0.01),

        // Subtitle (Description)
        // Text(
        //   subtitle,
        //   // style: UTextStyles.subtitle1,
        //   style: UTextStyles.medium,
        //   // textAlign: TextAlign.justify
        //   textAlign: TextAlign.center,
        // ),
        // SizedBox(height: size.height * 0.15),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;

  OnboardingData(this.title, this.subtitle);
}

final onboardingData = [
  OnboardingData(
    UText.onboardingTitle1,
    // '“Small SIPs grow steadily through compounding.\n Start early to build long-term wealth.”',
    'Even small SIPs can grow into big wealth.\nStart early to maximize compounding returns.',
  ),
  OnboardingData(
    UText.onboardingTitle2,
    '“SIP removes market timing worries.\n Build disciplined, consistent investing habits.”',
  ),
  OnboardingData(
    UText.onboardingTitle3,
    // '“Invest more units at low prices and fewer at highs.\nSIPs average your costs and reduce market risk.”',
    '“Buy more at lows, less at highs.\nSIPs balance costs through market volatility.”',
  ),
  // OnboardingData(
  //   UText.onboardingTitle4,
  //   '“Flexible SIPs that fit your budget.\nStay in complete control of your investments.”',
  // ),
];

class RichTypewriterText extends StatefulWidget {
  final List<TextSpan> spans;
  final Duration speed;
  final TextAlign textAlign;

  const RichTypewriterText({
    super.key,
    required this.spans,
    this.speed = const Duration(milliseconds: 40),
    this.textAlign = TextAlign.center,
  });

  @override
  State<RichTypewriterText> createState() => _RichTypewriterTextState();
}

class _RichTypewriterTextState extends State<RichTypewriterText> {
  int _charCount = 0;
  late  List<_SpanChar> _characters;

  @override
  void initState() {
    super.initState();
    _prepareCharacters();
    _startTyping();
  }

  @override
  void didUpdateWidget(covariant RichTypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spans != widget.spans) {
      _charCount = 0;
      _prepareCharacters();
      _startTyping();
    }
  }

  void _prepareCharacters() {
    _characters = [];
    for (final span in widget.spans) {
      final text = span.text ?? '';
      for (final char in text.characters) {
        _characters.add(_SpanChar(char, span.style));
      }
    }
  }

  void _startTyping() async {
    for (int i = 0; i <= _characters.length; i++) {
      await Future.delayed(widget.speed);
      if (!mounted) return;
      setState(() => _charCount = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleSpans = <TextSpan>[];

    for (int i = 0; i < _charCount; i++) {
      final c = _characters[i];
      visibleSpans.add(TextSpan(text: c.char, style: c.style));
    }

    return RichText(
      // maxLines: 2,
      textAlign: widget.textAlign,
      text: TextSpan(children: visibleSpans),
    );
  }
}

class _SpanChar {
  final String char;
  final TextStyle? style;

  _SpanChar(this.char, this.style);
}
