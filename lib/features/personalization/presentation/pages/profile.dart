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
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/document.dart';
import 'package:my_sip/features/personalization/presentation/widgets/help_support.dart';
import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/nominee_list.dart';
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
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : null, // Professional Web Grey
      appBar: CustomAppBarNormal(
        title: 'Profile',
        backIcon: !isDesktop,
        backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : null,
      ),
      body: isDesktop
          ? const _WebProfileDashboard()
          : const _MobileProfileLayout(),
    );
  }
}

// ==========================================
// 📱 MOBILE LAYOUT (Your Original Code)
// ==========================================
class _MobileProfileLayout extends StatelessWidget {
  const _MobileProfileLayout();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.getUserData;
    return Padding(
      padding: UPadding.screenPadding,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kToolbarHeight / 2),
              ProfileHeader(
                onTap: () {},
                name: user?.name,
                img: UImages.avatar,
                subtitle: user?.email ?? '',
                icon: Icons.edit,
              ),
              const SizedBox(height: 20),
              const Upgradebanner(),
              const SizedBox(height: 20),
              const ActivityGeneralSectionMobile(),
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
        child: SingleChildScrollView( // Allow scrolling on smaller laptops
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
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4)),
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
                          Text(user?.name ?? 'User Name', style: UTextStyles.heading1.copyWith(fontSize: 24)),
                          Text(user?.email ?? 'email@address.com', style: UTextStyles.subtitle2.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 150, child: LogoutButton(compact: true)),
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
                        const Text("Account Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      _GridItem('KYC Details', UImages.archiveadd, () => Get.to(() => const KycDetailsScreen())),
      _GridItem('Personal Details', UImages.verify, () => Get.toNamed(AppRoutes.personaldetails)),
      _GridItem('Bank Account', UImages.arrow, () => Get.to(() => const BankDetailsScreen())),
      _GridItem('Nominee Details', UImages.verify, () => Get.to(() => const NomineeListScreen())),
      _GridItem('Documents', UImages.cardtick, () => Get.to(() => const DocumentScreen())),
      _GridItem('Help & Support', UImages.eye, () => Get.to(() => const HelpSupportScreen())),
      _GridItem('About Us', UImages.msgques, () => Navigator.push(context, MaterialPageRoute(builder: (c) => const HtmlWebViewPage(title: 'About us', url: 'https://sip.londonstreetstore.com/about-us?mobile=true')))),
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
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
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
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
  const LogoutButton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return SizedBox(
      width: double.infinity,
      height: compact ? 45 : Get.height * 0.063,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: compact ? Colors.white : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(14),
            side: const BorderSide(color: Ucolors.darkgrey),
          ),
        ),
        onPressed: () => controller.logOut(),
        icon: Image.asset(UImages.logout, height: 20),
        label: Text(
          'Logout',
          style: UTextStyles.buttonText.copyWith(
            color: Ucolors.blue,
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
        Text('Ridit Finworld', style: UTextStyles.small.copyWith(fontWeight: FontWeight.bold)),
        Text('AMFI registered mutual fund distributor', style: UTextStyles.small),
        Text('AMFI ARN NO: 123456', style: UTextStyles.small),
      ],
    );
  }
}

// Renamed to avoid confusion with the web grid logic
class ActivityGeneralSectionMobile extends StatelessWidget {
  const ActivityGeneralSectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Ucolors.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Row(children: [SizedBox(width: 16), SectionHeading(sectionTitle: 'Activity', fontWeight: FontWeight.w700)]),
          Listtilecustom(onTap: () => Get.to(() => const KycDetailsScreen()), title: 'KYC Details', images: UImages.archiveadd),
          Listtilecustom(onTap: () => Get.toNamed(AppRoutes.personaldetails), title: 'Personal Details', images: UImages.verify),
          Listtilecustom(onTap: () => Get.to(() => const BankDetailsScreen()), title: 'Bank Account', images: UImages.arrow),
          Listtilecustom(onTap: () => Get.to(() => const NomineeListScreen()), title: 'Nominee Details', images: UImages.verify),
          Listtilecustom(onTap: () => Get.to(() => const DocumentScreen()), title: 'Documents', images: UImages.cardtick),
          const Row(children: [SizedBox(width: 16), SectionHeading(sectionTitle: 'General', fontWeight: FontWeight.w700)]),
          Listtilecustom(title: 'Applock', images: UImages.setting, onTap: () {}),
          Listtilecustom(title: 'Help & Support', images: UImages.eye, onTap: () => Get.to(() => const HelpSupportScreen())),
          Listtilecustom(title: 'About Us', images: UImages.msgques, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HtmlWebViewPage(title: 'About us', url: 'https://sip.londonstreetstore.com/about-us?mobile=true')))),
          Listtilecustom(onTap: () {}, title: 'Rate Us', images: UImages.likedislike),
        ],
      ),
    );
  }
}

class Listtilecustom extends StatelessWidget {
  const Listtilecustom({super.key, required this.title, this.images, required this.onTap});
  final String title;
  final String? images;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
      leading: images != null ? Image.asset(images!) : null,
      title: Text(title, style: UTextStyles.subtitle2.copyWith(color: Ucolors.dark, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Ucolors.darkgrey, size: 14),
    );
  }
}

class Upgradebanner extends StatelessWidget {
  const Upgradebanner({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return UElevatedBUtton(
      onPressed: () => Get.toNamed(AppRoutes.riskProfile),
      height: isDesktop ? 80 : sz.height * 0.08,
      child: Center(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.amber, backgroundImage: AssetImage(UImages.crown)),
          title: SubtitleText(fontWeight: FontWeight.w600, textcolor: Ucolors.light, subtitle: 'Check Your Risk Profile Now!', textAlignCenter: TextAlign.left),
          trailing: const Icon(Icons.arrow_forward_ios, color: Ucolors.light),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.img, this.name, required this.subtitle, required this.icon, required this.onTap});
  final String img;
  final String? name;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(onTap: onTap, child: Center(child: CircleAvatar(backgroundImage: AssetImage(img), radius: 60))),
            Positioned(
              left: 70, right: 0, bottom: 5,
              child: CircleAvatar(backgroundColor: Ucolors.light, radius: 14, child: Center(child: Icon(icon, color: Ucolors.dark))),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SectionHeading(sectionTitle: name ?? '', textcolor: Ucolors.dark, fontWeight: FontWeight.w700),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
      ],
    );
  }
}
