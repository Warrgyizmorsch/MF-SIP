import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/personalization/screen/profile/details/nominee_details.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class NomineeListScreen extends StatelessWidget {
  const NomineeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Nominee List'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: Column(
          children: [
            NomineeList(
              onTap: () => Get.to(() => NomineeDetailsScreen()),
              name: 'Kirti Hinger',
              relation: 'Wife',
              percentage: '50%',
            ),
            NomineeList(
              onTap: () => Get.to(() => NomineeDetailsScreen()),

              name: 'Kirti Hinger',
              relation: 'Wife',
              percentage: '50%',
            ),
            SizedBox(height: 30),
            UElevatedBUtton(
              outlined: true,
              onPressed: () => Get.to(() => NomineeDetailsScreen()),
              child: Center(
                child: Text(
                  'Add Another Nominee',
                  style: TextStyle(color: Ucolors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NomineeList extends StatelessWidget {
  const NomineeList({
    super.key,
    required this.name,
    required this.relation,
    required this.percentage,
    required this.onTap,
  });

  final String name;
  final String relation;
  final String percentage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Ucolors.light,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundImage: AssetImage(UImages.avatar)),
        title: Text(
          name,
          style: UTextStyles.medium.copyWith(
            color: Ucolors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Relation: ", style: UTextStyles.caption),
                  TextSpan(
                    text: relation,
                    style: UTextStyles.caption.copyWith(color: Ucolors.dark),
                  ),

                  TextSpan(text: ', Percentage: ', style: UTextStyles.caption),
                  TextSpan(
                    text: percentage,
                    style: UTextStyles.caption.copyWith(color: Ucolors.dark),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Ucolors.darkgrey,
        ),
      ),
    );
  }
}
