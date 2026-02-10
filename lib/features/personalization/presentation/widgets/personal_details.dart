import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/showbottomsheet/datepicker.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';

class PersonalDetailsScreen extends GetView<AuthController> {
  PersonalDetailsScreen({super.key});

  final TextEditingController dobController = TextEditingController();
  final List<String> wealthSources = [
    'Salary',
    'Business Income',
    'Freelancing',
    'Mutual Funds',
    'Stocks',
    'Real Estate',
    'Rental Income',
    'Fixed Deposits',
    'Gold',
    'Digital Products',
  ];
  final TextEditingController wealthSourcesController = TextEditingController();
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.getUserData;

    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Personal Info'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

              //Profile Header
              ProfileHeader(
                onTap: () {},
                // left: 0,
                // bottom: 0,
                img: UImages.avatar,
                subtitle: 'Change Photo',
                icon: Iconsax.export,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Details
                  const SmallHeading(smallheading: 'Full Name'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    readOnly: true,

                    prefixIcon: null,
                    hintText: 'Pratik Hinger',
                    // controller: controller.nameController,
                    controller: TextEditingController(text: user?.name ?? ''),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Date of Birth'),
                  const SizedBox(height: 5),
                  // UTextFormField(
                  //   prefixIcon: null,
                  //   hintText: '12/12/2000',
                  //   sufixIcon: Icons.calendar_month,
                  // ),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      showDOBPickerBottomSheet(
                        context: context,
                        controller: dobController,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        controller: dobController,
                        readOnly: true,

                        prefixIcon: null,
                        hintText: 'DD/MM/YYYY',

                        sufixIcon: Icons.calendar_month,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Email'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    readOnly: true,
                    prefixIcon: null,
                    hintText: 'abc@123gmail.com',
                    controller: TextEditingController(text: user?.email ?? ''),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Phone Number'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: '+91 9283637219',
                    controller: TextEditingController(
                      text: user?.mobile ?? ' ',
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'PAN Number'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    prefixIcon: null,
                    hintText: 'CCMS2373IM',
                    controller: TextEditingController(
                      text: user?.panCard ?? 'None',
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Wealth Source'),
                  const SizedBox(height: 5),

                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      showSelectionBottomSheet(
                        search: false,
                        context: context,
                        title: 'Select Wealth Source',
                        items: wealthSources,
                        controller: wealthSourcesController,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        controller: wealthSourcesController,
                        prefixIcon: Icons.mail,
                        hintText: 'Individual',
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Income Yearly'),
                  const SizedBox(height: 5),
                  UTextFormField(prefixIcon: Icons.mail, hintText: '3481'),
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
