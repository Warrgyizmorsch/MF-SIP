// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/images/image_picker.dart';
// import 'package:my_sip/common/widget/showbottomsheet/datepicker.dart';
// import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
// import 'package:my_sip/common/widget/text/small_heading.dart';
// import 'package:my_sip/common/widget/text_form/text_field_component.dart';
// import 'package:my_sip/common/widget/text_form/text_form_field.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/enums/enums.dart';
// import 'package:my_sip/core/utils/helper/helpers.dart';
// import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
// import 'package:my_sip/features/dashboard/presentation/pages/comparison_screen.dart';
// import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
// import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/services/session_manager.dart';

// class PersonalDetailsScreen extends GetView<AuthController> {
//   PersonalDetailsScreen({super.key});

//   final TextEditingController dobController = TextEditingController();
//   final List<String> wealthSources = [
//     'Salary',
//     'Business Income',
//     'Freelancing',
//     'Mutual Funds',
//     'Stocks',
//     'Real Estate',
//     'Rental Income',
//     'Fixed Deposits',
//     'Gold',
//     'Digital Products',
//   ];
//   final TextEditingController wealthSourcesController = TextEditingController();
//   final AuthController controller = Get.find<AuthController>();
//   final PersonalisationController personalisationController =
//       Get.find<PersonalisationController>();

//   @override
//   Widget build(BuildContext context) {
//     final user = SessionManager.instance.userObs.value;
//     if (personalisationController.nameController.text.isEmpty) {
//       personalisationController.nameController.text = user?.name ?? '';
//       personalisationController.emailController.text = user?.email ?? '';
//       personalisationController.mobileController.text = user?.mobile ?? '';
//       personalisationController.panController.text = user?.panCard ?? '';
//       personalisationController.yearlyIncome.text =
//           user?.customerDetailsModel?.yearlyIncome ?? '';
//       personalisationController.wealthSource.text =
//           user?.customerDetailsModel?.wealthSource ?? '';
//       personalisationController.dobController.text =
//           user?.customerDetailsModel?.dob ?? '';
//       personalisationController.addressController.text =
//           user?.customerDetailsModel?.address ?? '';
//       personalisationController.adharController.text =
//           user?.customerDetailsModel?.adhar ?? '';
//     }

//     return Scaffold(
//       appBar: CustomAppBarNormal(title: 'Personal Info'),
//       body: Padding(
//         padding: UPadding.screenPadding,
//         child: SingleChildScrollView(
//           child: Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: 600),
//               child: Column(
//                 children: [
//                   SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),

//                   //Profile Header
//                   // ProfileHeader(
//                   //   onTap: () {},
//                   //   // left: 0,
//                   //   // bottom: 0,
//                   //   img: UImages.avatar,
//                   //   subtitle: 'Change Photo',
//                   //   icon: Iconsax.export,
//                   // ),
//                   // Obx(
//                   //   () => ProfileHeader(
//                   //     onTap: () => personalisationController.pickImage(
//                   //       ImageSource.gallery,
//                   //     ), // Trigger image picker
//                   //     img: personalisationController.imagePath.isEmpty
//                   //         ? UImages.avatar
//                   //         : personalisationController.imagePath.toString(),
//                   //     // : '${Appurl.baseUrl}${personalisationController}',

//                   //     // isNetwork: personalisationController.imagePath.isEmpty, // Helper logic for local vs network image
//                   //     subtitle: 'Change Photo',
//                   //     icon: Iconsax.export,
//                   //   ),
//                   // ),
//                   Obx(() {
//                     final reactiveUser = SessionManager.instance.userObs.value;

//                     String displayImage =
//                         personalisationController.imagePath.isNotEmpty
//                         ? personalisationController.imagePath.value
//                         : (reactiveUser?.img ?? UImages.avatar);

//                     return ProfileHeader(
//                       onTap: () => UImagePicker.showImageSourceOptions(
//                         context: context,
//                         onImageSelected: (source) =>
//                             personalisationController.pickImage(source),
//                       ),
//                       img: displayImage,

//                       subtitle: 'Change Photo',
//                       icon: Iconsax.export,
//                     );
//                   }),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //Details
//                       const SmallHeading(smallheading: 'Full Name'),
//                       const SizedBox(height: 5),
//                       UTextFormField(
//                         // readOnly: true,
//                         prefixIcon: null,
//                         hintText: 'Pratik Hinger',
//                         // controller: TextEditingController(text: user?.name ?? ''),
//                         controller: personalisationController.nameController,
//                       ),
//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'Date of Birth'),
//                       const SizedBox(height: 5),

//                       InkWell(
//                         onTap: () {
//                           FocusScope.of(context).unfocus();

//                           showDOBPickerBottomSheet(
//                             context: context,
//                             // controller: dobController,
//                             controller: personalisationController.dobController,
//                           );
//                         },
//                         child: AbsorbPointer(
//                           absorbing: true,
//                           child: UTextFormField(
//                             // controller: dobController,
//                             controller: personalisationController.dobController,

//                             readOnly: true,

//                             prefixIcon: null,
//                             hintText: 'DD/MM/YYYY',

//                             sufixIcon: Icons.calendar_month,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'Email'),
//                       const SizedBox(height: 5),
//                       UTextFormField(
//                         // readOnly: true,
//                         prefixIcon: null,
//                         hintText: 'abc@123gmail.com',
//                         // controller: TextEditingController(text: user?.email ?? ''),
//                         controller: personalisationController.emailController,
//                       ),
//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'Phone Number'),
//                       const SizedBox(height: 5),
//                       // UTextFormField(
//                       //   prefixIcon: null,
//                       //   hintText: '+91 9283637219',
//                       //   // controller: TextEditingController(
//                       //   //   text: user?.mobile ?? ' ',
//                       //   // ),
//                       //   controller: personalisationController.mobileController,
//                       // ),
//                       CustomTextField(
//                         borderColor: Colors.grey.shade200,
//                         keyboardType: TextInputType.number,

//                         height: 60,

//                         controller: personalisationController.mobileController,
//                         hint: '+91 Enter nominee mobile no.',
//                         validationType: ValidationType.phone,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                       ),
//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'PAN Number'),
//                       const SizedBox(height: 5),
//                       // UTextFormField(
//                       //   prefixIcon: null,
//                       //   hintText: 'CCMS2373IM',

//                       //   controller: personalisationController.panController,
//                       // ),
//                       // Wrap the CustomTextField in an Obx widget
//                       Obx(() {
//                         return CustomTextField(
//                           borderColor: Colors.grey.shade200,

//                           height: MediaQuery.of(context).size.height * 0.065,
//                           hint: DocumentFormatterFactory.getHint("Pan"),

//                           controller: personalisationController.panController,
//                           focusNode: personalisationController
//                               .panFocusNode, // Link the FocusNode
//                           // Read the observable value here (.value)
//                           keyboardType:
//                               personalisationController.panKeyboardType.value,

//                           validationType: ValidationType.custom,
//                           inputFormatters:
//                               DocumentFormatterFactory.getFormatters("Pan"),
//                           customValidator: (value) =>
//                               DocumentFormatterFactory.validate("Pan", value),
//                         );
//                       }),
//                       // CustomTextField(
//                       //   height: MediaQuery.of(context).size.height * 0.065,

//                       //   hint: DocumentFormatterFactory.getHint("Pan"),
//                       //   controller: personalisationController.panController,
//                       //   validationType: ValidationType.custom,

//                       //   inputFormatters: DocumentFormatterFactory.getFormatters(
//                       //     "Pan",
//                       //   ),
//                       //   customValidator: (value) =>
//                       //       DocumentFormatterFactory.validate(
//                       //         personalisationController.pageController.toString(),
//                       //         value,
//                       //       ),
//                       // ),
//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'Wealth Source'),
//                       const SizedBox(height: 5),

//                       InkWell(
//                         onTap: () {
//                           FocusScope.of(context).unfocus();
//                           showSelectionBottomSheet(
//                             search: false,
//                             context: context,
//                             title: 'Select Wealth Source',
//                             items: wealthSources,
//                             // controller: wealthSourcesController,
//                             controller: personalisationController.wealthSource,
//                           );
//                         },
//                         child: AbsorbPointer(
//                           absorbing: true,
//                           child: UTextFormField(
//                             // controller: wealthSourcesController,
//                             controller: personalisationController.wealthSource,

//                             prefixIcon: Icons.mail,
//                             hintText: 'Individual',
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'Income Yearly'),
//                       const SizedBox(height: 5),
//                       UTextFormField(
//                         keyboardType: TextInputType.number,
//                         prefixIcon: Icons.mail,
//                         hintText: '3481',
//                         controller: personalisationController.yearlyIncome,
//                       ),
//                       const SizedBox(height: 10),

//                       const SmallHeading(smallheading: 'Address'),
//                       const SizedBox(height: 5),
//                       UTextFormField(
//                         // controller: TextEditingController(text: 'daddab'),
//                         controller: personalisationController.addressController,

//                         prefixIcon: Icons.mail,
//                         hintText: 'Udaipur, Rajasthan, 313001',
//                       ),

//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),

//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Obx(
//           () => BottomBarButton(
//             isLoading: personalisationController
//                 .isLoading
//                 .value, // Show loading spinner
//             firstButton: 'Cancel',
//             secondButton: 'Save Changes',
//             firstButtonP: () => Get.back(),
//             secondButtonP: () => personalisationController.updateProfile(),
//             // onFirstTap: () => Get.back(),
//             // onSecondTap: () => controller.updateProfile(), // Call the API
//           ),
//         ),
//       ),
//       // bottomNavigationBar: SafeArea(
//       //   top: false,
//       //   child: BottomBarButton(
//       //     firstButton: 'Cancel',
//       //     secondButton: 'Save Changes',
//       //   ),
//       // ),
//     );
//   }

//   void showImageSourceSheet(BuildContext context) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Select Image Source",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildSourceOption(
//                   icon: Icons.camera_alt,
//                   label: "Camera",
//                   onTap: () {
//                     Get.back();
//                     personalisationController.pickImage(ImageSource.camera);
//                   },
//                 ),
//                 _buildSourceOption(
//                   icon: Icons.photo_library,
//                   label: "Gallery",
//                   onTap: () {
//                     Get.back();
//                     personalisationController.pickImage(ImageSource.gallery);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSourceOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.grey.shade100,
//             child: Icon(icon, color: Colors.black),
//           ),
//           const SizedBox(height: 8),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }

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
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';

class PersonalDetailsScreen extends GetView<AuthController> {
  PersonalDetailsScreen({super.key});

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

  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.userObs.value;

    // Initialize controllers only if empty
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

    // 🚀 Check if Desktop or Mobile
    final bool isDesktop = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: CustomAppBarNormal(title: 'Personal Info'),

      // 🚀 FIX: Removed bottomNavigationBar for Web. It feels unnatural on desktop.
      bottomNavigationBar: isDesktop
          ? null
          : SafeArea(
              top: false,
              child: Obx(
                () => BottomBarButton(
                  isLoading: personalisationController.isLoading.value,
                  firstButton: 'Cancel',
                  secondButton: 'Save Changes',
                  firstButtonP: () => Get.back(),
                  secondButtonP: () =>
                      personalisationController.updateProfile(),
                ),
              ),
            ),

      body: SingleChildScrollView(
        padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isDesktop
                ? _buildWebLayout(context)
                : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (Split & Grid)
  // =========================================
  Widget _buildWebLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LEFT COLUMN: Profile Image ---
        Expanded(
          flex: 4,
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildProfileImagePicker(context),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Keep your profile updated. Your PAN and identity details are strictly encrypted.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 30),

        // --- RIGHT COLUMN: Form Fields in 2-Column Grid ---
        Expanded(
          flex: 8,
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit Personal Details",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Row 1: Name & DOB
                  Row(
                    children: [
                      Expanded(child: _buildNameField()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildDobField(context)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 2: Email & Phone
                  Row(
                    children: [
                      Expanded(child: _buildEmailField()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildPhoneField(context)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 3: PAN & Wealth Source
                  Row(
                    children: [
                      Expanded(child: _buildPanField(context)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildWealthSourceField(context)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Row 4: Income & Address
                  Row(
                    children: [
                      Expanded(child: _buildIncomeField()),
                      const SizedBox(width: 20),
                      Expanded(child: _buildAddressField()),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Web Action Buttons (Inside the card)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(
                        () => ElevatedButton(
                          onPressed: personalisationController.isLoading.value
                              ? null
                              : () => personalisationController.updateProfile(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: personalisationController.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Save Changes",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT (Stacked)
  // =========================================
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
        _buildProfileImagePicker(context),
        const SizedBox(height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildDobField(context),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPhoneField(context),
            const SizedBox(height: 16),
            _buildPanField(context),
            const SizedBox(height: 16),
            _buildWealthSourceField(context),
            const SizedBox(height: 16),
            _buildIncomeField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  // =========================================
  // 🧩 REUSABLE FORM COMPONENTS
  // =========================================

  Widget _buildProfileImagePicker(BuildContext context) {
    return Obx(() {
      final reactiveUser = SessionManager.instance.userObs.value;
      String displayImage = personalisationController.imagePath.isNotEmpty
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
    });
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Full Name'),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: 'Pratik Hinger',
          controller: personalisationController.nameController,
        ),
      ],
    );
  }

  Widget _buildDobField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Date of Birth'),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            showDOBPickerBottomSheet(
              context: context,
              controller: personalisationController.dobController,
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: UTextFormField(
              controller: personalisationController.dobController,
              readOnly: true,
              prefixIcon: null,
              hintText: 'DD/MM/YYYY',
              sufixIcon: Icons.calendar_month,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Email'),
        const SizedBox(height: 5),
        UTextFormField(
          prefixIcon: null,
          hintText: 'abc@gmail.com',
          controller: personalisationController.emailController,
        ),
      ],
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Phone Number'),
        const SizedBox(height: 5),
        CustomTextField(
          borderColor: Colors.grey.shade200,
          keyboardType: TextInputType.number,
          height: 60,
          controller: personalisationController.mobileController,
          hint: '+91 Enter mobile no.',
          validationType: ValidationType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      ],
    );
  }

  Widget _buildPanField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'PAN Number'),
        const SizedBox(height: 5),
        Obx(
          () => CustomTextField(
            borderColor: Colors.grey.shade200,
            height: MediaQuery.of(context).size.height * 0.065,
            hint: DocumentFormatterFactory.getHint("Pan"),
            controller: personalisationController.panController,
            focusNode: personalisationController.panFocusNode,
            keyboardType: personalisationController.panKeyboardType.value,
            validationType: ValidationType.custom,
            inputFormatters: DocumentFormatterFactory.getFormatters("Pan"),
            customValidator: (value) =>
                DocumentFormatterFactory.validate("Pan", value),
          ),
        ),
      ],
    );
  }

  Widget _buildWealthSourceField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              controller: personalisationController.wealthSource,
            );
          },
          child: AbsorbPointer(
            absorbing: true,
            child: UTextFormField(
              controller: personalisationController.wealthSource,
              prefixIcon: Icons.account_balance_wallet,
              hintText: 'Select Source',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Income Yearly'),
        const SizedBox(height: 5),
        UTextFormField(
          keyboardType: TextInputType.number,
          prefixIcon: Icons.currency_rupee,
          hintText: 'e.g. 500000',
          controller: personalisationController.yearlyIncome,
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SmallHeading(smallheading: 'Address'),
        const SizedBox(height: 5),
        UTextFormField(
          controller: personalisationController.addressController,
          prefixIcon: Icons.location_on,
          hintText: 'City, State, Pincode',
        ),
      ],
    );
  }
}
