import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/presentation/pages/cart_page.dart';
import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_growth_chart.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';

class IhavegoalPage extends StatelessWidget {
  IhavegoalPage({super.key});

  final Map<String, Map<String, dynamic>> goalConfig = {
    'car': {
      'amount': 1000000, // 10 L
      'duration': 5,
      'rate': 12,
      'name': 'Car',
    },
    'bike': {
      'amount': 150000, // 1.5 L
      'duration': 3,
      'rate': 12,
      'name': 'Bike',
    },
    'home': {
      'amount': 3000000, // 30 L
      'duration': 10,
      'rate': 12,
      'name': 'Home',
    },
    'marriage': {
      'amount': 500000, // 5 L
      'duration': 5,
      'rate': 12,
      'name': 'Marriage',
    },
    'vacation': {
      'amount': 100000, // 1 L
      'duration': 2,
      'rate': 12,
      'name': 'Vacation',
    },
    'custom': {
      'amount': 100000, // 1 L
      'duration': 2,
      'rate': 12,
      'name': 'Custom',
    },
  };

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String goalType = args['goalType'] ?? 'custom';

    final goalData = goalConfig[goalType]!;

    final double amount = goalData['amount']!.toDouble();
    final int duration = goalData['duration']!.toInt();
    final double rate = goalData['rate']!.toDouble();
    final String name = goalData['name']!;

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),
      appBar: CustomAppBarNormal(
        title: 'Create $name Goal',
        action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
        actionsPadding: 15,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Gap(12),

              ///Add Cover
              CoverSection(),

              ///Goal Name Select
              GoalNameSelect(goalName: name),

              //SIP section
              SIPSection(amount: amount, duration: duration),

              const Gap(20),

              //Projection Graph
              ProjectionGraph(),

              const Gap(9),

              //Popular Fund  Grid
              const USectionHeading(
                title: 'Popular Funds',
                showActionButton: true,
              ),

              PopularFund(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CartBottomBar(
          ontap: () => Get.toNamed(
            AppRoutes.successfullcreategoal,
            arguments: {
              'textButton': 'See Details',

              'nextroute': AppRoutes.goalviewcard,
            },
          ),
          amountColor: Ucolors.blue,
          title: 'Installment Amount',
          buttonText: 'Start SIP',
        ),
      ),
    );
  }
}

class PopularFund extends StatelessWidget {
  const PopularFund({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: 1.55,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,

        // physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: [
          PopularFundCard(
            onTap: () => Get.toNamed(AppRoutes.funddetails),

            name: 'SBI Gold Fund',
            imgPath: UImages.sbi,
          ),
          PopularFundCard(
            onTap: () => Get.toNamed(AppRoutes.funddetails),
            name: 'Parag Parikh Flexi Cap Fund',
            imgPath: UImages.sbi,
          ),
          PopularFundCard(
            name: 'Motilal Ostwal Midcap Fund',
            imgPath: UImages.motilal,
          ),
          PopularFundCard(
            name: 'Bandhan Small Cap Fund',
            imgPath: UImages.motilal,
          ),
        ],
      ),
    );
  }
}

class ProjectionGraph extends StatefulWidget {
  const ProjectionGraph({super.key});

  @override
  State<ProjectionGraph> createState() => _ProjectionGraphState();
}

class _ProjectionGraphState extends State<ProjectionGraph> {
  int selectedView = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Ucolors.light,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projection',
                style: UTextStyles.medium.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ProjectionIcon(
                      onTap: () {
                        setState(() {
                          selectedView = 0;
                        });
                      },
                      isSelected: selectedView == 0,
                      icon: Icons.trending_up,
                    ),

                    ProjectionIcon(
                      onTap: () {
                        setState(() {
                          selectedView = 1;
                        });
                      },
                      isSelected: selectedView == 1,
                      icon: Icons.grid_on_sharp,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Gap(20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '● Invest',
                style: UTextStyles.small.copyWith(color: Color(0xff868686)),
              ),
              Text(
                '● Value',
                style: UTextStyles.small.copyWith(color: Color(0xff213C73)),
              ),
            ],
          ),

          // const Gap(15),
          SipGrowthChart(),
        ],
      ),
    );
  }
}

class ProjectionIcon extends StatelessWidget {
  const ProjectionIcon({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
  });

  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      // height: 35,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: isSelected ? Ucolors.blue : Colors.grey),
      ),
    );
  }
}

class SIPSection extends StatelessWidget {
  const SIPSection({
    super.key,
    required this.amount,
    required this.duration,
    this.rate = 12,
  });

  final double amount;
  final int duration;
  final double rate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Ucolors.light,
        boxShadow: [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SipSliderTile2(
            prefix: '₹',
            title: 'I need',
            value: amount,
            min: 100,
            max: 3000000,
            suffix: '',
            onChanged: (value) {},
          ),

          // SmallHeading(smallheading: 'Frequency', fontWeight: FontWeight.w700),
          // Gap(10),

          // FrequencySelector(),
          // Gap(15),
          SipSliderTile2(
            title: 'Duration',
            value: duration.toDouble(),
            min: 1,
            max: 30,
            suffix: 'Yrs',
            onChanged: (value) {},
          ),

          Gap(15),

          SipSliderTile2(
            title: 'Expected Returns',
            value: rate,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}

class FrequencySelector extends StatefulWidget {
  const FrequencySelector({super.key});

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  final List<String> item = ['Daily', 'Weekly', 'Monthly', 'Quartly', 'Yearly'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            item.length,
            (index) => InstallmentContainer(
              title: item[index],
              isSelected: selectedIndex == index,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoalNameSelect extends StatelessWidget {
  GoalNameSelect({super.key, required this.goalName});

  final List<String> goal = [
    'Car',
    'Home Purchase',
    'Marriage',
    'Vacation',
    'Education',
    'Bike',
    'Personalize',
    'Other',
  ];

  // final TextEditingController goalName = TextEditingController();
  final String goalName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [SmallHeading(smallheading: 'Goal Name')]),
        Gap(5),
        // InkWell(
        //   onTap: () {
        //     FocusScope.of(context).unfocus();
        //     showSelectionBottomSheet(
        //       search: false,
        //       context: context,
        //       title: 'Select Goal Name',
        //       items: goal,
        //       controller: goalName,
        //       selectedValue: goalName.text,
        //     );
        //   },
        //   child: AbsorbPointer(
        //     absorbing: true,
        //     child: UTextFormField(
        //       controller: goalName,
        //       backgroundColor: Colors.white,
        //       hintText: 'e.g. New Car, Buy House, Investment, etc',
        //       sufixIcon: Icons.arrow_drop_down,
        //       prefixIcon: null,
        //     ),w
        //   ),
        // ),
        UTextFormField(
          prefixIcon: null,

          controller: TextEditingController(text: goalName),
          backgroundColor: Colors.white,
        ),
        if (goalName == 'Other')
          UTextFormField(
            backgroundColor: Colors.white,
            prefixIcon: null,
            hintText: 'Enter your Goal',
          ),
      ],
    );
  }
}

class CoverSection extends StatelessWidget {
  const CoverSection({super.key, this.recentPhoto = false});

  final bool recentPhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddCoverBottomSheet(recentPhoto: recentPhoto),

        Gap(5),
        Text('Add Cover', style: UTextStyles.medium),
      ],
    );
  }
}

class AddCoverBottomSheet extends StatelessWidget {
  const AddCoverBottomSheet({super.key, required this.recentPhoto});

  final bool recentPhoto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          // backgroundColor: Color(0xffF3F4F6),
          backgroundColor: Colors.white,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding: UPadding.screenPadding,
                child: Column(
                  children: [
                    Text(
                      'Add Cover',
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Gap(10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Photos',
                        style: UTextStyles.medium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Ucolors.dark,
                        ),
                      ),
                    ),

                    const Gap(10),

                    Expanded(
                      child: recentPhoto == true
                          ? SingleChildScrollView(
                              child: Wrap(
                                children: List.generate(
                                  4,
                                  (index) => Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffF3F4F6),
                                    ),
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xffF3F4F6),
                                    child: Icon(
                                      Iconsax.gallery_remove,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Gap(15),
                                  Text(
                                    'Empty Photo Data',
                                    style: UTextStyles.medium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'No recent photos saved',
                                    style: UTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                    ),

                    const Gap(10),

                    /// Buttons stay OUTSIDE Expanded
                    UElevatedBUtton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Take a Photo', style: UTextStyles.buttonText),
                          const Gap(5),
                          const Icon(Iconsax.camera5, color: Ucolors.light),
                        ],
                      ),
                    ),

                    const Gap(12),

                    UElevatedBUtton(
                      outlined: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Upload from Gallery',
                            style: UTextStyles.buttonText.copyWith(
                              color: Ucolors.dark,
                            ),
                          ),
                          const Gap(5),
                          const Icon(
                            Iconsax.document_upload,
                            color: Ucolors.dark,
                          ),
                        ],
                      ),
                    ),

                    const Gap(kBottomNavigationBarHeight - 5),
                  ],
                ),

                //  Column(
                //   // crossAxisAlignment: CrossAxisAlignment.start,
                //   // mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Text(
                //       'Add Cover',
                //       style: UTextStyles.medium.copyWith(
                //         color: Ucolors.dark,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     Align(
                //       alignment: Alignment.topLeft,
                //       child: Text(
                //         'Recent Photos',
                //         style: UTextStyles.medium.copyWith(
                //           fontWeight: FontWeight.w600,
                //           color: Ucolors.dark,
                //         ),
                //       ),
                //     ),
                //     recentPhoto
                //         ? Wrap(
                //             children: [
                //               ...List.generate(
                //                 4,
                //                 (index) => Container(
                //                   margin: EdgeInsets.symmetric(
                //                     horizontal: 10,
                //                     vertical: 10,
                //                   ),
                //                   padding: EdgeInsets.all(15),
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10),
                //                     color: Color(0xffF3F4F6),
                //                   ),
                //                   child: Icon(Icons.image),
                //                 ),
                //               ),
                //             ],
                //           )
                //         : Expanded(
                //             child: Center(
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.min,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   const CircleAvatar(
                //                     radius: 30,
                //                     backgroundColor: Color(0xffF3F4F6),
                //                     child: Icon(
                //                       Iconsax.gallery_remove,
                //                       color: Colors.black,
                //                     ),
                //                   ),
                //                   const Gap(15),
                //                   Text(
                //                     'Empty Photo Data',
                //                     style: UTextStyles.medium.copyWith(
                //                       fontWeight: FontWeight.w600,
                //                       color: Colors.grey,
                //                     ),
                //                   ),
                //                   Text(
                //                     'No recent photos saved',
                //                     style: UTextStyles.caption,
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //     Spacer(),
                //     UElevatedBUtton(
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             'Take a Photo',
                //             style: UTextStyles.buttonText,
                //           ),
                //           const Gap(5),
                //           const Icon(Iconsax.camera5, color: Ucolors.light),
                //         ],
                //       ),
                //     ),
                //     const Gap(15),
                //     UElevatedBUtton(
                //       outlined: true,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             'Upload from Gallery',
                //             style: UTextStyles.buttonText.copyWith(
                //               color: Ucolors.dark,
                //             ),
                //           ),
                //           const Gap(5),
                //           const Icon(
                //             Iconsax.document_upload,
                //             color: Ucolors.dark,
                //           ),
                //         ],
                //       ),
                //     ),

                //     Gap(kBottomNavigationBarHeight),

                //     // Container(height: 200, color: Colors.amber),
                //   ],
                // ),
              ),
            );
          },
          showDragHandle: true,
          useSafeArea: true,
          enableDrag: true,
          // isScrollControlled: true,
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class InstallmentContainer extends StatelessWidget {
  const InstallmentContainer({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Ucolors.primary : Color(0xff64748B),
          ),
        ),
        height: 40,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Ucolors.primary : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
