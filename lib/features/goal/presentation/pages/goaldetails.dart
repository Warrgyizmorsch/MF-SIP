import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/goal/presentation/widget/GoalDetailsIndicator.dart';

import '../../domain/entity/goal_entity.dart';

class GoaldetailsPage extends StatelessWidget {
  const GoaldetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final UserGoalEntity? goal = args['goal'];
    final String emoji = args['emoji'] ?? '🎯';
    final double target = args['target'] ?? 0.0;
    final double invested = args['invested'] ?? 0.0;

    final String title = goal?.goalName ?? 'Goal Details';

    return Scaffold(
      backgroundColor: Color(0xffF3F4F6),

      appBar: CustomAppBarNormal(
        title: title,
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
                    GoalDetailSection(
                      goal: goal,
                      target: target,
                      invested: invested,
                      emoji: emoji,
                    ),
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
  final UserGoalEntity? goal;
  final double target;
  final double invested;
  final String emoji;
  const GoalDetailSection({
    super.key,
    required this.goal,
    required this.target,
    required this.invested,
    required this.emoji,
  });

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final double remaining = (target - invested).clamp(0.0, double.infinity);
    final double monthly = goal?.monthlyInvestment ?? 0.0;
    final double weekly = (monthly * 12) / 52;
    final double daily = (monthly * 12) / 365;

    // Calculate deadline year
    final currentYear = DateTime.now().year;
    final deadlineYear = currentYear + (goal?.goalTenure ?? 0) / 12;

    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(15),

          CircularGoalIndicatorDetails(
            percentage: true, // Uses the large layout
            goalName: goal?.goalName ?? '',
            targetAmount: target,
            investedAmount: invested,
            emoji: emoji,
            // If they uploaded a cover image, pass the URL here!
            // imageUrl: goal?.goalCover != null && goal!.goalCover.isNotEmpty
            //     ? "${Appurl.baseUrl}${goal!.goalCover}"
            //     : null,
          ),
          // SizedBox(
          //   height: 200, // Give it constraints
          //   child: CircularUploadIndicator(

          //     goalName: goal?.goalName ?? '',
          //     targetAmount: target,
          //     investedAmount: invested,
          //     iconEmoji: emoji,
          //   ),
          // ),
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
                    ValueTitleGoal(value: _fmt(invested), title: 'Saved'),
                    ValueTitleGoal(value: _fmt(remaining), title: 'Remaining'),
                    ValueTitleGoal(value: _fmt(target), title: 'Goal'),
                  ],
                ),
                Gap(20),
                SmallHeading(
                  smallheading: 'Deadline (Est. Year ${deadlineYear.floor()})',
                ),
                Gap(12),
                Row(
                  children: [
                    ValueTitleGoal(value: _fmt(daily), title: 'Daily Savings'),
                    ValueTitleGoal(
                      value: _fmt(weekly),
                      title: 'Weekly Savings',
                    ),
                    ValueTitleGoal(
                      value: _fmt(monthly),
                      title: 'Monthly Savings',
                    ),
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
                if (goal?.goalFunds.isEmpty ?? true)
                  const Text(
                    'No mutual funds linked yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                // ...List.generate(
                //   5,
                //   (index) => ListTile(
                //     contentPadding: EdgeInsets.symmetric(vertical: 5),
                //     dense: true,

                //     leading: CircleAvatar(
                //       backgroundImage: AssetImage(UImages.sbi),
                //     ),
                //     title: Text(
                //       'Parag Parikh Flexi Cap Fund',
                //       style: UTextStyles.medium.copyWith(
                //         color: Ucolors.dark,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     trailing: Text(
                //       '1,500',
                //       style: UTextStyles.medium.copyWith(
                //         color: Ucolors.dark,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                ...?goal?.goalFunds.map((fund) {
                  final String imgUrl =
                      "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      // Ensure you have a CachedNetworkImage here in reality for remote images
                      backgroundImage: NetworkImage(imgUrl),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.broken_image),
                    ),
                    title: Text(
                      fund.mutualFund?.schemeName ?? 'Unknown Fund',
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      _fmt(fund.sipAmount),
                      style: UTextStyles.medium.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
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
