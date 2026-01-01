import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/top_bottom_style/top_bottom_style.dart';
import 'package:my_sip/utils/constant/colors.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: TopBottomDecoration(
        design: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              Text(
                "STEP 1 OF 4",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),

              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Color(0xffEBF4FF)),
                    width: width / 2,
                    height: 10,
                  ),

                  Positioned(
                    child: Container(
                      height: 10,
                      width: width / 3,
                      decoration: BoxDecoration(color: Ucolors.primary),
                    ),
                  ),
                ],
              ),
              Text(
                "Select Age Group",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "This helps us personalize your investment horizon.",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RadioGroup(
                onChanged: (onChanged) {},
                child: Column(
                  spacing: 10,
                  children: [
                    UElevatedBUtton(
                      outlined: true,
                      onPressed: () {},
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "20-35 Years",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Radio(value: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    UElevatedBUtton(
                      outlined: true,
                      onPressed: () {},
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "36-50 Years",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Radio(value: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    UElevatedBUtton(
                      outlined: true,
                      onPressed: () {},
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "51+ Years",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                              Radio(value: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              UElevatedBUtton(
                // onPressed: () => Get.to(() => OnboardingFlow()),
                onPressed: () {
                  
                },
                child: Text('Continue', style: TextStyle(color: Colors.white)),
              ),
              Center(
                child: SubtitleText(
                  subtitle: "Your data is 100% safe & secure",
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
