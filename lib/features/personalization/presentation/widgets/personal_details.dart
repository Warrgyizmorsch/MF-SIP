import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/images/image_picker.dart';
import 'package:my_sip/common/widget/showbottomsheet/datepicker.dart';
import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
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
  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.userObs.value;
    if (personalisationController.nameController.text.isEmpty) {
      personalisationController.nameController.text = user?.name ?? '';
      personalisationController.emailController.text = user?.email ?? '';
      personalisationController.mobileController.text = user?.mobile ?? '';
      personalisationController.panController.text = user?.panCard ?? '';
      personalisationController.yearlyIncome.text =
          user?.customerDetailsModel?.yearlyIncome ?? '';
      personalisationController.wealthSource.text =
          user?.customerDetailsModel?.wealthSource ?? '';
      personalisationController.dobController.text =
          user?.customerDetailsModel?.dob ?? '';
      personalisationController.addressController.text =
          user?.customerDetailsModel?.address ?? '';
      personalisationController.adharController.text =
          user?.customerDetailsModel?.adhar ?? '';
    }

    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Personal Info'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

              //Profile Header
              // ProfileHeader(
              //   onTap: () {},
              //   // left: 0,
              //   // bottom: 0,
              //   img: UImages.avatar,
              //   subtitle: 'Change Photo',
              //   icon: Iconsax.export,
              // ),
              // Obx(
              //   () => ProfileHeader(
              //     onTap: () => personalisationController.pickImage(
              //       ImageSource.gallery,
              //     ), // Trigger image picker
              //     img: personalisationController.imagePath.isEmpty
              //         ? UImages.avatar
              //         : personalisationController.imagePath.toString(),
              //     // : '${Appurl.baseUrl}${personalisationController}',

              //     // isNetwork: personalisationController.imagePath.isEmpty, // Helper logic for local vs network image
              //     subtitle: 'Change Photo',
              //     icon: Iconsax.export,
              //   ),
              // ),
              Obx(() {
                final reactiveUser = SessionManager.instance.userObs.value;

                String displayImage =
                    personalisationController.imagePath.isNotEmpty
                    ? personalisationController.imagePath.value
                    : (reactiveUser?.img ?? UImages.avatar);

                return ProfileHeader(
                  onTap: () => UImagePicker.showImageSourceOptions(
                    context: context,
                    onImageSelected: (source) =>
                        personalisationController.pickImage(source),
                  ),
                  img: displayImage,

                  subtitle: 'Change Photo',
                  icon: Iconsax.export,
                );
              }),
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
                    // controller: TextEditingController(text: user?.name ?? ''),
                    controller: personalisationController.nameController,
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Date of Birth'),
                  const SizedBox(height: 5),

                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      showDOBPickerBottomSheet(
                        context: context,
                        // controller: dobController,
                        controller: personalisationController.dobController,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        // controller: dobController,
                        controller: personalisationController.dobController,

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
                    // controller: TextEditingController(text: user?.email ?? ''),
                    controller: personalisationController.emailController,
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Phone Number'),
                  const SizedBox(height: 5),
                  // UTextFormField(
                  //   prefixIcon: null,
                  //   hintText: '+91 9283637219',
                  //   // controller: TextEditingController(
                  //   //   text: user?.mobile ?? ' ',
                  //   // ),
                  //   controller: personalisationController.mobileController,
                  // ),
                  CustomTextField(
                    borderColor: Colors.grey.shade200,
                    keyboardType: TextInputType.number,

                    height: 60,

                    controller: personalisationController.mobileController,
                    hint: '+91 Enter nominee mobile no.',
                    validationType: ValidationType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'PAN Number'),
                  const SizedBox(height: 5),
                  // UTextFormField(
                  //   prefixIcon: null,
                  //   hintText: 'CCMS2373IM',

                  //   controller: personalisationController.panController,
                  // ),
                  // Wrap the CustomTextField in an Obx widget
                  Obx(() {
                    return CustomTextField(
                      borderColor: Colors.grey.shade200,

                      height: MediaQuery.of(context).size.height * 0.065,
                      hint: DocumentFormatterFactory.getHint("Pan"),

                      controller: personalisationController.panController,
                      focusNode: personalisationController
                          .panFocusNode, // Link the FocusNode
                      // Read the observable value here (.value)
                      keyboardType:
                          personalisationController.panKeyboardType.value,

                      validationType: ValidationType.custom,
                      inputFormatters: DocumentFormatterFactory.getFormatters(
                        "Pan",
                      ),
                      customValidator: (value) =>
                          DocumentFormatterFactory.validate("Pan", value),
                    );
                  }),
                  // CustomTextField(
                  //   height: MediaQuery.of(context).size.height * 0.065,

                  //   hint: DocumentFormatterFactory.getHint("Pan"),
                  //   controller: personalisationController.panController,
                  //   validationType: ValidationType.custom,

                  //   inputFormatters: DocumentFormatterFactory.getFormatters(
                  //     "Pan",
                  //   ),
                  //   customValidator: (value) =>
                  //       DocumentFormatterFactory.validate(
                  //         personalisationController.pageController.toString(),
                  //         value,
                  //       ),
                  // ),
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
                        // controller: wealthSourcesController,
                        controller: personalisationController.wealthSource,
                      );
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: UTextFormField(
                        // controller: wealthSourcesController,
                        controller: personalisationController.wealthSource,

                        prefixIcon: Icons.mail,
                        hintText: 'Individual',
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Income Yearly'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.mail,
                    hintText: '3481',
                    controller: personalisationController.yearlyIncome,
                  ),
                  const SizedBox(height: 10),

                  const SmallHeading(smallheading: 'Address'),
                  const SizedBox(height: 5),
                  UTextFormField(
                    // controller: TextEditingController(text: 'daddab'),
                    controller: personalisationController.addressController,

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
        child: Obx(
          () => BottomBarButton(
            isLoading: personalisationController
                .isLoading
                .value, // Show loading spinner
            firstButton: 'Cancel',
            secondButton: 'Save Changes',
            firstButtonP: () => Get.back(),
            secondButtonP: () => personalisationController.updateProfile(),
            // onFirstTap: () => Get.back(),
            // onSecondTap: () => controller.updateProfile(), // Call the API
          ),
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   top: false,
      //   child: BottomBarButton(
      //     firstButton: 'Cancel',
      //     secondButton: 'Save Changes',
      //   ),
      // ),
    );
  }

  void showImageSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Image Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Get.back();
                    personalisationController.pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Get.back();
                    personalisationController.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
