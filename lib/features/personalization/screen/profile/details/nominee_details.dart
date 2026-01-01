import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/features/dashboard/screen/comparison_screen.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/utils/constant/images.dart';

class NomineeDetailsScreen extends StatelessWidget {
  const NomineeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Nominee Detail'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

              //Profile
              ProfileHeader(
                left: 0,
                bottom: 0,
                img: UImages.avatar,
                subtitle: 'Change Photo',
                icon: Iconsax.export,
                onTap: () {},
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Details
                  const SmallHeading(smallheading: 'Full Name'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'Pratik Hinger',
                    // controller: TextEditingController(text: 'Pr'),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Date of Birth'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: '12/12/2000',
                    sufixIcon: Icons.calendar_month,
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Email'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'abc@123gmail.com',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Phone Number(Optional)'),
                  const SizedBox(height: 5),
                  UTextFormField(prefixIcon: null, hintText: '+91 9283637219'),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Document type'),
                  const SizedBox(height: 5),
                  UTextFormField(prefixIcon: null, hintText: 'Aadhar'),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Aadhar Number'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.mail,
                    hintText: '542191187840',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Relation'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.mail,
                    hintText: 'Spouse (Husband / Wife)',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Address'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    // controller: TextEditingController(text: 'daddab'),
                    prefixIcon: Icons.mail,
                    hintText: 'Udaipur, Rajasthan, 313001',
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomBarButton(
          firstButton: 'Cancel',
          secondButton: 'Save Changes',
        ),
      ),
    );
  }
}
