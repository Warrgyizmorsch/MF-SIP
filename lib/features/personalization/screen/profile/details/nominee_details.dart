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
  NomineeDetailsScreen({super.key});
  final TextEditingController relationController = TextEditingController();
  final TextEditingController documnetController = TextEditingController();

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
                    prefixIcon: Icons.mail_outline,
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
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _documnetMenu(context); // no keyboard
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        controller: documnetController,
                        prefixIcon: Iconsax.document,
                        hintText: 'Aadhar / PAN / DL',
                        sufixIcon: Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Document Number',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.document_scanner_outlined,
                    hintText: '542191187840',
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Relation',
                  ),
                  const SizedBox(height: 5),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      FocusScope.of(context).unfocus(); // no keyboard
                      _showRelationMenu(context);
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        sufixIcon: Icons.arrow_drop_down,
                        controller: relationController,
                        prefixIcon: Iconsax.user,
                        hintText: 'Select Relation',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(
                    fontWeight: FontWeight.w600,

                    smallheading: 'Address',
                  ),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: Icons.location_on_outlined,
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

  void _showRelationMenu(BuildContext context) async {
    final value = await showMenu<String>(
      color: Colors.white,
    
      context: context,
      

      position: const RelativeRect.fromLTRB(100, 300, 100, 100),
      items: const [
        PopupMenuItem(value: 'Father', child: Text('Father')),
        PopupMenuItem(value: 'Mother', child: Text('Mother')),
        PopupMenuItem(value: 'Wife', child: Text('Wife')),
        PopupMenuItem(value: 'Husband', child: Text('Husband')),
        PopupMenuItem(value: 'Son', child: Text('Son')),
        PopupMenuItem(value: 'Daughter', child: Text('Daughter')),
      ],
    );

    if (value != null) {
      relationController.text = value;
    }
  }

  void _documnetMenu(BuildContext context) async {
    final value = await showMenu<String>(
      context: context,
      color: Ucolors.light,
      position: const RelativeRect.fromLTRB(100, 300, 100, 100),
      items: const [
        PopupMenuItem(value: 'Aadhar', child: Text('Aadhar')),
        PopupMenuItem(value: 'Pan', child: Text('PAN')),
        PopupMenuItem(value: 'Driving Licence', child: Text('Driving Licence')),
      ],
    );

    if (value != null) {
      documnetController.text = value;
    }
  }
}
