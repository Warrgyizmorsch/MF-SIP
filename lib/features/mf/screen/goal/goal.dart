import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(
        backgroundColor: Ucolors.light,
        title: 'Goal',
        backIcon: false,
        actionsPadding: 10,
        action: [CompactIcon(icon: Iconsax.info_circle, onPressed: () {})],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Ucolors.skyblue1,
                child: Icon(
                  Iconsax.note_remove5,
                  color: Ucolors.blue,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ready to start saving?',
              style: UTextStyles.large.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),

            Text(
              'You haven’t set any savings goals yet',
              style: UTextStyles.small_heading.copyWith(
                color: Ucolors.darkgrey,
              ),
            ),
            const SizedBox(height: 25),

            UElevatedBUtton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create Your First Goal', style: UTextStyles.buttonText),
                  const SizedBox(width: 10),
                  const Icon(Icons.add, color: Ucolors.light),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
