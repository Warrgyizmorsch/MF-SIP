import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/cart/presentation/pages/cart_page.dart';
import 'package:my_sip/features/freedom_sip/presentation/widgets/sip_growth_chart.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';

class IhavegoalPage extends StatelessWidget {
  IhavegoalPage({super.key});

  final List<String> goal = [
    'Car',
    'Home Purchase',
    'Marriage',
    'Vacation',
    'Educatoin',
    'Bike',
    'Personalize',
  ];

  final TextEditingController goalName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> item = [
      'Daily',
      'Weekly',
      'Monthly',
      'Quartly',
      'Yearly',
    ];

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),
      appBar: CustomAppBarNormal(
        title: 'Create New Goal',
        action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
        actionsPadding: 15,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Gap(12),
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.black),
                  ),

                  Gap(5),
                  Text('Add Cover', style: UTextStyles.medium),
                ],
              ),
              Column(
                children: [
                  Row(children: [SmallHeading(smallheading: 'Goal Name')]),
                  Gap(5),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      showSelectionBottomSheet(
                        search: false,
                        context: context,
                        title: 'Select Goal Name',
                        items: goal,
                        controller: goalName,
                        selectedValue: goalName.text,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        controller: goalName,
                        backgroundColor: Colors.white,
                        hintText: 'e.g. New Car, Buy House, Investment, etc',
                        sufixIcon: Icons.arrow_drop_down,
                        prefixIcon: null,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
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
                      value: 100,
                      min: 100,
                      max: 100000,
                      suffix: '',
                      onChanged: (value) {},
                    ),

                    SmallHeading(
                      smallheading: 'Frequency',
                      fontWeight: FontWeight.w700,
                    ),

                    Gap(10),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(
                            item.length,
                            (index) => InstallmentContainer(title: item[index]),
                          ),
                        ],
                      ),
                    ),

                    Gap(15),

                    SipSliderTile2(
                      title: 'Duration',
                      value: 1,
                      min: 1,
                      max: 30,
                      suffix: 'Yrs',
                      onChanged: (value) {},
                    ),

                    Gap(15),

                    SipSliderTile2(
                      title: 'Expected Returns',
                      value: 1,
                      min: 1,
                      max: 30,
                      suffix: '%',
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),

              Gap(20),

              Container(
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
                          style: UTextStyles.medium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                // height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.trending_up),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                // height: 35,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.grid_on_sharp),
                                ),
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
                          style: UTextStyles.small.copyWith(
                            color: Color(0xff868686),
                          ),
                        ),
                        Text(
                          '● Value',
                          style: UTextStyles.small.copyWith(
                            color: Color(0xff213C73),
                          ),
                        ),
                      ],
                    ),

                    // const Gap(15),
                    SipGrowthChart(),
                  ],
                ),
              ),

              Gap(9),

              const USectionHeading(
                title: 'Popular Funds',
                showActionButton: true,
              ),

              SizedBox(
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
                      name: 'SBI Gold Fund',
                      imgPath: UImages.sbi,
                    ),
                    PopularFundCard(
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CartBottomBar(
          title: 'Installment Amount',
          buttonText: 'Start SIP',
        ),
      ),
    );
  }
}

class InstallmentContainer extends StatelessWidget {
  const InstallmentContainer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xff64748B)),
      ),
      height: 40,
      child: Center(child: Text(title)),
    );
  }
}
