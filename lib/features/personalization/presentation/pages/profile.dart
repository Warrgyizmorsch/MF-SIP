import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/download_statement.dart';
import 'package:my_sip/features/personalization/presentation/widgets/help_support.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop
          ? const Color(0xFFF5F7FA)
          : null, // Professional Web Grey
      appBar: CustomAppBarNormal(
        title: 'Profile',
        backIcon: !isDesktop ? false : !isDesktop,
        backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : null,
      ),
      body: isDesktop ? const _WebProfileDashboard() : _MobileProfileLayout(),
    );
  }
}

// ==========================================
// 📱 MOBILE LAYOUT (Your Original Code)
// ==========================================
class _MobileProfileLayout extends StatelessWidget {
  _MobileProfileLayout();

  final controller = Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.userObs.value;
    return Padding(
      padding: UPadding.screenPadding,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kToolbarHeight / 2),
              // ProfileHeader(
              //   onTap: () =>  controller.pickImage,
              //   name: user?.name,
              //   img: UImages.avatar,
              //   subtitle: user?.email ?? '',
              //   icon: Icons.edit,
              // ),
              Obx(() {
                final user1 = SessionManager.instance.userObs.value;

                final reactiveUser = SessionManager.instance.userObs.value;

                String displayImage = controller.imagePath.isNotEmpty
                    ? controller.imagePath.value
                    : (reactiveUser?.img ?? UImages.avatar);

                log(user1?.img ?? ' not ');

                return ProfileHeader(
                  // onTap: () => controller.pickImage(
                  //   ImageSource.gallery,
                  // ), // Trigger image picker
                  // onTap: () => UImagePicker.showImageSourceOptions(
                  //   context: context,
                  //   onImageSelected: (source) => controller.pickImage(source),
                  // ),
                  onTap: () => Get.toNamed(AppRoutes.personaldetails),
                  // img: controller.imagePath.isEmpty
                  //     ? UImages.avatar
                  //     : controller.imagePath.toString(),
                  // img: user!.img == null ? UImages.avatar : user.img.toString(),
                  // img: controller.imagePath.isEmpty
                  //     ? (user?.img ?? UImages.avatar)
                  //     : controller.imagePath.value,
                  img: displayImage,

                  // : '${Appurl.baseUrl}${personalisationController}',
                  subtitle: user?.name ?? '',
                  icon: Icons.edit,
                );
              }),
              const SizedBox(height: 20),
              const Upgradebanner(),
              const SizedBox(height: 20),
              ActivityGeneralSectionMobile(),
              const SizedBox(height: 20),
              const LogoutButton(),
              const Gap(15),
              const FooterSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebProfileDashboard extends StatelessWidget {
  const _WebProfileDashboard();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.getUserData;

    return Center(
      child: MaxWidthBox(
        maxWidth: 1000,
        child: SingleChildScrollView(
          // Allow scrolling on smaller laptops
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(UImages.avatar),
                      radius: 40,
                    ),
                    const Gap(24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'User Name',
                            style: UTextStyles.heading1.copyWith(fontSize: 24),
                          ),
                          Text(
                            user?.email ?? 'email@address.com',
                            style: UTextStyles.subtitle2.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 150,
                      child: LogoutButton(compact: true),
                    ),
                  ],
                ),
              ),

              const Gap(30),

              // 2. Main Content Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Upgrade Banner

                  // Right Side: Action Grid
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Account Settings",
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(16),
                        _buildGrid(context),
                      ],
                    ),
                  ),
                  const Gap(30),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        const Gap(40),
                        const Upgradebanner(),
                        const Gap(24),
                        const FooterSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    // Grid Items Data
    final items = [
      _GridItem(
        'KYC Details',
        UImages.archiveadd,
        // () => Get.to(() => const KycDetailsScreen()),
        () => Get.toNamed(AppRoutes.kycDeatailScreen),
      ),
      _GridItem(
        'Personal Details',
        UImages.verify,
        () => Get.toNamed(AppRoutes.personaldetails),
      ),
      _GridItem(
        'Bank Account',
        UImages.arrow,
        () => Get.to(() => const BankDetailsScreen()),
      ),
      _GridItem(
        'Nominee Details',
        UImages.verify,
        () => Get.toNamed(AppRoutes.nomineeList),
      ),
      _GridItem(
        'Documents',
        UImages.cardtick,
        // () => Get.to(() => const DocumentScreen()),
        () => Get.toNamed(AppRoutes.documentsScreen),
      ),
      _GridItem(
        'Help & Support',
        UImages.eye,
        () => Get.to(() => const HelpSupportScreen()),
      ),
      _GridItem(
        'About Us',
        UImages.msgques,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => const HtmlWebViewPage(
              title: 'About us',
              url: 'https://sip.londonstreetstore.com/about-us?mobile=true',
            ),
          ),
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) {
            // Calculate width for 3 items per row roughly
            final width = (constraints.maxWidth - 32) / 3;
            return InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(item.image, height: 32, width: 32),
                    const Gap(12),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _GridItem {
  final String title;
  final String image;
  final VoidCallback onTap;
  _GridItem(this.title, this.image, this.onTap);
}

class LogoutButton extends StatelessWidget {
  final bool compact;
  const LogoutButton({super.key, this.compact = false, this.web = false});
  final bool web;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return SizedBox(
      width: double.infinity,
      height: compact ? 45 : Get.height * 0.063,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: compact
              ? Colors.white
              : web
              ? Ucolors.blue
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(14),
            side: const BorderSide(color: Ucolors.darkgrey),
          ),
        ),
        onPressed: () => controller.logOut(),
        icon: web
            ? Icon(Icons.logout, color: Colors.white)
            : Image.asset(UImages.logout, height: 20),
        label: Text(
          'Logout',
          style: UTextStyles.buttonText.copyWith(
            color: web ? Colors.white : Ucolors.blue,
            fontWeight: FontWeight.w500,
            fontSize: compact ? 14 : 16,
          ),
        ),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Version 1.0.0', style: UTextStyles.small),
        const Gap(12),
        Text(
          'Ridit Finworld',
          style: UTextStyles.small.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          'AMFI registered mutual fund distributor',
          style: UTextStyles.small.copyWith(fontSize: 12),
        ),
        Text(
          'AMFI ARN NO: 104807',
          style: UTextStyles.small.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

// Renamed to avoid confusion with the web grid logic
class ActivityGeneralSectionMobile extends StatelessWidget {
  ActivityGeneralSectionMobile({super.key});

  final PersonalisationController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Ucolors.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Row(
            children: [
              SizedBox(width: 16),
              SectionHeading(
                sectionTitle: 'Activity',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Listtilecustom(
            // onTap: () => Get.to(() => const KycDetailsScreen()),
            onTap: () => Get.toNamed(AppRoutes.kycDeatailScreen),
            title: 'KYC Details',
            images: UImages.archiveadd,
          ),
          Listtilecustom(
            onTap: () => Get.toNamed(AppRoutes.personaldetails),
            title: 'Personal Details',
            images: UImages.verify,
          ),
          Listtilecustom(
            onTap: () => Get.to(() => const BankDetailsScreen()),
            title: 'Bank Account',
            images: UImages.arrow,
          ),
          Listtilecustom(
            onTap: () => Get.toNamed(AppRoutes.nomineeList),
            title: 'Nominee Details',
            images: UImages.verify,
          ),
          // Listtilecustom(
          //   onTap: () => Get.to(() => const DocumentScreen()),
          //   title: 'Documents',
          //   images: UImages.cardtick,
          // ),
          const Row(
            children: [
              SizedBox(width: 16),
              SectionHeading(
                sectionTitle: 'General',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Listtilecustom(
            isLock: true,
            title: 'Applock',
            images: UImages.setting,
            onTap: () {},
          ),
          Listtilecustom(
            title: 'Help & Support',
            images: UImages.eye,
            onTap: () => Get.to(() => const HelpSupportScreen()),
          ),
          Listtilecustom(
            title: 'About Us',
            images: UImages.msgques,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HtmlWebViewPage(
                  title: 'About us',
                  url: 'https://sip.londonstreetstore.com/about-us?mobile=true',
                ),
              ),
            ),
          ),
          Listtilecustom(
            onTap: () {},
            title: 'Rate Us',
            images: UImages.likedislike,
          ),
          const Row(
            children: [
              SizedBox(width: 16),
              SectionHeading(
                sectionTitle: 'Reports',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Listtilecustom(
            onTap: () {
              Get.find<PersonalisationController>().setStatementMode(
                isCapital: false,
              );
              Get.to(() => DownloadStatementsScreen());
            },
            title: 'Account Statement',
            // images: UImages.likedislike,
            icon: Icons.sip_outlined,
          ),
          Listtilecustom(
            onTap: () {
              Get.find<PersonalisationController>().setStatementMode(
                isCapital: true,
              );
              Get.to(() => DownloadStatementsScreen());
            },
            title: 'ElSS Report',
            // images: UImages.likedislike,
          ),
        ],
      ),
    );
  }
}

class Listtilecustom extends StatelessWidget {
  const Listtilecustom({
    super.key,
    required this.title,
    this.images,
    required this.onTap,
    this.isLock = false,
    this.icon = Icons.bar_chart,
  });
  final String title;
  final String? images;
  final VoidCallback onTap;
  final bool isLock;
  final IconData icon;
  // final PersonalisationController controller =
  //     Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
      leading: images != null ? Image.asset(images!) : Icon(icon),
      title: Text(
        title,
        style: UTextStyles.bodyMedium.copyWith(
          color: Ucolors.dark,
          fontSize: 12,
          // fontWeight: FontWeight.w500,
          fontFamily: UTextStyles.font,
        ),
      ),
      trailing: !isLock
          ? const Icon(
              Icons.arrow_forward_ios,
              color: Ucolors.darkgrey,
              size: 14,
            )
          : Obx(
              () => Switch(
                activeColor: Colors.blue,
                // value: controller.applock.value,
                value: SessionManager.instance.isAppLockEnabled.value,
                onChanged: (bool value) async {
                  // controller.applock.toggle();
                  await SessionManager.instance.toggleAppLock(value);
                },
              ),
            ),
    );
  }
}

class Upgradebanner extends StatelessWidget {
  const Upgradebanner({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    final sz = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // WRAP IN OBX FOR REAL-TIME UPDATES
    return Obx(() {
      // Accessing the reactive getter triggers the listener
      final riskData = session.getRiskScore;

      return riskData == null
          ? UElevatedBUtton(
              onPressed: () => Get.toNamed(AppRoutes.riskProfile),
              height: isDesktop ? 80 : sz.height * 0.08,
              child: Center(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.amber,
                    backgroundImage: AssetImage(UImages.crown),
                  ),
                  title: SubtitleText(
                    fontWeight: FontWeight.w600,
                    textcolor: Ucolors.light,
                    subtitle: 'Check Your Risk Profile Now!',
                    textAlignCenter: TextAlign.left,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Ucolors.light,
                  ),
                ),
              ),
            )
          : UElevatedBUtton(
              // Allow users to re-take the test/refresh if they wish
              onPressed: () => Get.toNamed(AppRoutes.riskProfile),
              height: isDesktop ? 80 : sz.height * 0.1,
              color: Ucolors.blue, // 'Completed' state color
              child: Center(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user, color: Colors.white),
                  ),
                  title: SubtitleText(
                    fontWeight: FontWeight.w400,
                    textcolor: Ucolors.light.withValues(alpha: 0.8),
                    subtitle: 'Your Risk Profile',
                    textAlignCenter: TextAlign.left,
                  ),
                  subtitle: Text(
                    "${riskData.profileName} (${riskData.totalScore}/150)",
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.refresh,
                    color: Ucolors.light,
                    size: 20,
                  ),
                ),
              ),
            );
    });
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.img,
    this.name,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
  });

  final String img;
  final String? name;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(child: _buildImage()),
                ),
              ),
            ),
            Positioned(
              left: 70,
              right: 0,
              bottom: 5,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 14,
                child: Center(child: Icon(icon, color: iconColor, size: 16)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (name != null && name!.isNotEmpty) ...[
          Text(
            name!,
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  //
  Widget _buildImage() {
    // 1. Agar image empty/null hai
    if (img.isEmpty || img == 'null') {
      return Image.asset(
        'assets/images/avatar.png',
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    }

    // 2. 🌐 WEB BLOB (Local Web Picker)
    if (kIsWeb && img.startsWith('blob:')) {
      return Image.network(
        img,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 50, color: Colors.grey),
      );
    }

    // 3. ☁️ NETWORK IMAGE (API)
    if (img.startsWith('http') || img.contains('storage/')) {
      String fullUrl = img;

      if (!img.startsWith('http') && !img.startsWith('blob:')) {
        fullUrl = "https://sip-backend.londonstreetstore.com/$img";
        // log("Image full url: $fullUrl");
      }

      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) {
          // log("Image Blocked by CORS/Network Error: $error");
          return const Icon(Icons.person, size: 50, color: Colors.grey);
        },
      );
    }

    // 4. 📱 MOBILE LOCAL FILE (Web par nahi chalega)
    if (!kIsWeb && !img.startsWith('assets/')) {
      try {
        final file = File(img);
        if (file.existsSync()) {
          return Image.file(file, fit: BoxFit.cover, width: 120, height: 120);
        }
      } catch (e) {
        // log("File error: $e");
      }
    }

    // 5. Default Fallback
    return Image.asset(
      img,
      fit: BoxFit.cover,
      width: 120,
      height: 120,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }
}
