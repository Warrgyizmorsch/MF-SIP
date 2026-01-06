import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/personalization/screen/profile/details/kyc_details.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Document'),
      body: Padding(
        padding: UPadding.screenPadding.copyWith(),
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

            ProfileHeader(
              iconcolor: Ucolors.primary,
              name: 'Pratik',
              img: UImages.avatar,
              subtitle: 'Ready to invest since 2025',
              icon: Icons.verified,
              onTap: () {},
            ),

            SizedBox(height: 10),

            InfoCard(onTap: () {}, title: 'PAN Card', subtitle: 'ADBPH2798C'),
            SizedBox(height: 10),
            InfoCard(
              onTap: () {},
              trailing: Image.asset(UImages.signature, fit: BoxFit.contain),
              title: 'Bank Signature',
              subtitle: 'Upload Individual’s Signature',
              colum1: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade100),
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),
                child: FittedBox(
                  child: Text(
                    'View',
                    style: UTextStyles.subtitle2.copyWith(
                      color: Ucolors.dark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
