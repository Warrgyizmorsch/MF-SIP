import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/features/dashboard/screen/comparison_screen.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

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
                  SmallHeading(
                    smallheading: 'Full Name',
                    fontWeight: FontWeight.w600,
                    // color: Colors.black87,
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'Enter nominees full name',
                    // controller: TextEditingController(text: 'Pr'),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    smallheading: 'Date of Birth',
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'DD/MM/YYYY',
                    sufixIcon: Icons.calendar_month,
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Email',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'Enter nominees email ID',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Phone Number(Optional)',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: '+91 Enter nominnes mobile no.',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Document type',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'Aadhar / PAN / DL',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Document Number',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.mail,
                    hintText: '542191187840',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Relation',
                  ),
                  const SizedBox(height: 5),

                  UTextFormField(
                    // sufixIcon: ,
                    // suffix: DropdownButton(
                    //   items: [
                    //     DropdownMenuItem(value: '', child: Text('Wife')),
                    //     DropdownMenuItem(value: '', child: Text('Husband')),
                    //     // DropdownMenuItem(child: Text('Husband')),
                    //   ],
                    //   onChanged: (value) {},
                    // ),
                    prefixIcon: Icons.mail,
                    hintText: 'Spouse (Husband / Wife / etc)',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Address',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    // controller: TextEditingController(text: 'daddab'),
                    prefixIcon: Icons.mail,
                    hintText: 'Enter your Full Address',
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
