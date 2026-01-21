import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/goal/presentation/pages/goalviewcard.dart';

class GoaldetailsPage extends StatelessWidget {
  const GoaldetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),

      appBar: CustomAppBarNormal(
        title: 'Car',
        action: [CompactIcon(icon: Icons.more_vert, onPressed: () {})],
      ),
      body: Padding(
        padding: UPadding.screenPadding,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),

                child: Tab(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,

                    unselectedLabelColor: Colors.grey.shade700,
                    dividerColor: Colors.transparent,
                    labelColor: Ucolors.light,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(vertical: 10),

                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                      color: Ucolors.primary,
                    ),

                    tabs: [Text('Goal'), Text('Record')],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GoalDetailSection(),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(10, (index) => TransactionCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBarButton(
        firstButton: 'Remove Funds',
        secondButton: 'Add Funds',
      ),
    );
  }
}

class GoalDetailSection extends StatelessWidget {
  const GoalDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(15),
          CircularUploadIndicator(percentage: true),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SmallHeading(smallheading: 'Saving'),
                Gap(10),
                Row(
                  children: [
                    ValueTitleGoal(value: '₹ 5,000', title: 'Saved'),

                    ValueTitleGoal(value: '₹ 5,000', title: 'Remaining'),
                    ValueTitleGoal(value: '₹ 5,000', title: 'Goal'),
                  ],
                ),
                Gap(20),
                SmallHeading(smallheading: 'Deadline (January 01, 2024)'),
                Gap(12),
                Row(
                  children: [
                    ValueTitleGoal(value: '₹ 176.78', title: 'Daily Savings'),

                    ValueTitleGoal(value: '₹ 5,000', title: 'Weekly Savings'),
                    ValueTitleGoal(value: '₹ 5,000', title: 'Monthly Savings'),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          const Row(
            children: [SmallHeading(smallheading: 'Linked Mutual Funds')],
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ...List.generate(
                  5,
                  (index) => ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    dense: true,

                    leading: CircleAvatar(
                      backgroundImage: AssetImage(UImages.sbi),
                    ),
                    title: Text(
                      'Parag Parikh Flexi Cap Fund',
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      '1,500',
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(22),
        ],
      ),
    );
  }
}

class ValueTitleGoal extends StatelessWidget {
  const ValueTitleGoal({super.key, required this.value, required this.title});
  final String value;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: UTextStyles.large.copyWith(
              color: Colors.black,
              // fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
          ),
        ],
      ),
    );
  }
}
