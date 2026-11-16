import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/download_statement.dart';
import 'package:my_sip/features/personalization/presentation/widgets/help_support.dart';
import 'package:my_sip/features/personalization/presentation/pages/amc_list_screen.dart';
import 'package:my_sip/features/support_tickets/presentation/pages/tickets_list_page.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

class _ProfileOverviewStyle {
  static const background = Color(0xFFF7F7FC);
  static const border = Color(0xFFE7E8EE);
  static const ink = Color(0xFF202A3A);
  static const muted = Color(0xFF8B8BA4);
  static const blue = Color(0xFF357CFF);
  static const blueSurface = Color(0xFFEDF4FF);

  static TextStyle text(
    double size, {
    Color color = ink,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: size,
    height: 1.4,
    color: color,
    fontWeight: weight,
  );
}

class _ProfileOverviewCard extends StatelessWidget {
  const _ProfileOverviewCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color = Colors.white,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26),
      side: const BorderSide(color: _ProfileOverviewStyle.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Padding(padding: padding, child: child),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop
          ? const Color(0xFFF5F7FA)
          : _ProfileOverviewStyle.background, // Professional Web Grey
      appBar: CustomAppBarNormal(
        title: 'Profile',
        backIcon: !isDesktop ? false : !isDesktop,
        backgroundColor: isDesktop
            ? const Color(0xFFF5F7FA)
            : _ProfileOverviewStyle.background,
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
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_ProfileOverviewStyle.background, Colors.white],
          ),
        ),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                constraints.maxWidth < 360 ? 16 : 24,
                20,
                constraints.maxWidth < 360 ? 16 : 24,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ProfileHeader(
                      //   onTap: () =>  controller.pickImage,
                      //   name: user?.name,
                      //   img: UImages.avatar,
                      //   subtitle: user?.email ?? '',
                      //   icon: Icons.edit,
                      // ),
                      Obx(() {
                        final reactiveUser =
                            SessionManager.instance.userObs.value;
                        final canNumber =
                            (controller.userData.value?.canNumber ??
                                    reactiveUser?.canNumber ??
                                    '')
                                .trim();

                        String displayImage = controller.imagePath.isNotEmpty
                            ? controller.imagePath.value
                            : (reactiveUser?.img ?? UImages.avatar);

                        return ProfileHeader(
                          overview: true,
                          onTap: () => Get.toNamed(AppRoutes.personaldetails),
                          img: displayImage,
                          name: reactiveUser?.name,
                          subtitle:
                              reactiveUser?.email ??
                              reactiveUser?.mobile?.toString() ??
                              '',
                          canNumber: canNumber,
                          icon: Icons.edit,
                        );
                      }),
                      const SizedBox(height: 12),
                      const Upgradebanner(overview: true),
                      const SizedBox(height: 12),
                      ActivityGeneralSectionMobile(),
                      const SizedBox(height: 24),
                      const Center(child: LogoutButton(overview: true)),
                      const Gap(24),
                      const FooterSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
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
                      child: Obx(() {
                        final reactiveUser =
                            SessionManager.instance.userObs.value;
                        final controller =
                            Get.find<PersonalisationController>();
                        final canNumber =
                            (controller.userData.value?.canNumber ??
                                    reactiveUser?.canNumber ??
                                    '')
                                .trim();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reactiveUser?.name ?? user?.name ?? 'User Name',
                              style: UTextStyles.heading1.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              reactiveUser?.email ??
                                  user?.email ??
                                  'email@address.com',
                              style: UTextStyles.subtitle2.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            if (canNumber.isNotEmpty) ...[
                              const Gap(8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFBFDBFE),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.verified_outlined,
                                      size: 14,
                                      color: Color(0xFF2563EB),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'CAN: $canNumber',
                                      style: const TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D4ED8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
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
        'Wishlist',
        null,
        () => Get.toNamed(AppRoutes.watchlist),
        icon: Icons.favorite_border_rounded,
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
        'Support Tickets',
        null,
        () => Get.to(() => const TicketsListPage()),
        icon: Icons.confirmation_number_outlined,
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
      _GridItem(
        'AMCs, SEBI & AMFI',
        null,
        () => Get.to(() => const AmcListScreen()),
        icon: Icons.account_balance_outlined,
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
                    if (item.image != null)
                      Image.asset(item.image!, height: 32, width: 32)
                    else if (item.icon != null)
                      Icon(item.icon, size: 32, color: Ucolors.primary),
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
  final String? image;
  final IconData? icon;
  final VoidCallback onTap;
  _GridItem(this.title, this.image, this.onTap, {this.icon});
}

class LogoutButton extends StatelessWidget {
  final bool compact;
  const LogoutButton({
    super.key,
    this.compact = false,
    this.web = false,
    this.overview = false,
  });
  final bool web;
  final bool overview;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    if (overview) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 190, minHeight: 54),
          child: OutlinedButton.icon(
            onPressed: () => controller.logOut(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE21D2B),
              backgroundColor: const Color(0xFFFFF6F6),
              side: const BorderSide(color: Color(0xFFFFD6DA)),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              textStyle: _ProfileOverviewStyle.text(
                14,
                weight: FontWeight.w500,
              ),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Logout'),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: compact ? 45 : Get.height * 0.063,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: compact
              ? Colors.white
              : web
              ? Ucolors.primary
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
          'Kriti Hinger',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileMenuSection(
          title: 'Activity',
          children: [
            // Listtilecustom(
            //   // onTap: () => Get.to(() => const KycDetailsScreen()),
            //   onTap: () => Get.toNamed(AppRoutes.kycDeatailScreen),
            //   title: 'KYC Details',
            //   images: UImages.archiveadd,
            // ),
            Listtilecustom(
              onTap: () => Get.toNamed(AppRoutes.personaldetails),
              title: 'Personal Details',
              icon: Icons.thumb_up_outlined,
            ),
            Listtilecustom(
              onTap: () => Get.to(() => const BankDetailsScreen()),
              title: 'Bank Account',
              icon: Icons.description_outlined,
            ),
            Listtilecustom(
              onTap: () => Get.toNamed(AppRoutes.nomineeList),
              title: 'Nominee Details',
              icon: Icons.info_outline_rounded,
            ),
            Listtilecustom(
              onTap: () => Get.toNamed(AppRoutes.watchlist),
              title: 'Wishlist',
              icon: Icons.chat_bubble_outline_rounded,
            ),
            // Listtilecustom(
            //   onTap: () => Get.to(() => const DocumentScreen()),
            //   title: 'Documents',
            //   images: UImages.cardtick,
            // ),
          ],
        ),
        const SizedBox(height: 12),
        _ProfileMenuSection(
          title: 'Reports',
          children: [
            Listtilecustom(
              onTap: () {
                Get.find<PersonalisationController>().setStatementMode(
                  isCapital: false,
                );
                DownloadStatementsScreen.forcedIsCapitalMode = false;
                Get.to(() => DownloadStatementsScreen());
              },
              title: 'Account Statement',
              icon: Icons.receipt_long_outlined,
            ),
            Listtilecustom(
              onTap: () {
                Get.find<PersonalisationController>().setStatementMode(
                  isCapital: true,
                );
                DownloadStatementsScreen.forcedIsCapitalMode = true;
                Get.to(() => DownloadStatementsScreen());
              },
              title: 'ELSS Report',
              icon: Icons.description_outlined,
              // images: UImages.likedislike,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ProfileMenuSection(
          title: 'General',
          children: [
            Listtilecustom(
              isLock: true,
              title: 'Applock',
              icon: Icons.lock_outline_rounded,
              onTap: () {},
            ),
            Listtilecustom(
              title: 'Support & Helpdesk Tickets',
              icon: Icons.confirmation_number_outlined,
              onTap: () => Get.to(() => const TicketsListPage()),
            ),
            Listtilecustom(
              title: 'Help & Support',
              icon: Icons.help_outline_rounded,
              onTap: () => Get.to(() => const HelpSupportScreen()),
            ),
            Listtilecustom(
              title: 'About Us',
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HtmlWebViewPage(
                    title: 'About us',
                    url:
                        'https://sip.londonstreetstore.com/about-us?mobile=true',
                  ),
                ),
              ),
            ),
            Listtilecustom(
              onTap: () {},
              title: 'Rate Us',
              icon: Icons.star_outline_rounded,
            ),
            Listtilecustom(
              title: 'AMCs, SEBI & AMFI',
              icon: Icons.verified_user_outlined,
              iconColor: Ucolors.homePositive,
              onTap: () => Get.to(() => const AmcListScreen()),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileMenuSection extends StatelessWidget {
  const _ProfileMenuSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => _ProfileOverviewCard(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: _ProfileOverviewStyle.text(18, weight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    ),
  );
}

class Listtilecustom extends StatelessWidget {
  const Listtilecustom({
    super.key,
    required this.title,
    this.images,
    required this.onTap,
    this.isLock = false,
    this.icon = Icons.bar_chart,
    this.iconColor = _ProfileOverviewStyle.blue,
  });
  final String title;
  final String? images;
  final VoidCallback onTap;
  final bool isLock;
  final IconData icon;
  final Color iconColor;
  // final PersonalisationController controller =
  //     Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor == _ProfileOverviewStyle.blue
                    ? _ProfileOverviewStyle.blueSurface
                    : iconColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: images != null
                  ? Image.asset(images!, width: 20, height: 20)
                  : Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: _ProfileOverviewStyle.text(16))),
            const SizedBox(width: 8),
            !isLock
                ? const Icon(
                    Icons.open_in_new_rounded,
                    color: Color(0xFF98A2B3),
                    size: 18,
                  )
                : Obx(
                    () => Switch(
                      activeThumbColor: Ucolors.primary,
                      // value: controller.applock.value,
                      value: SessionManager.instance.isAppLockEnabled.value,
                      onChanged: (bool value) async {
                        // controller.applock.toggle();
                        await SessionManager.instance.toggleAppLock(value);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class Upgradebanner extends StatelessWidget {
  const Upgradebanner({super.key, this.overview = false});

  final bool overview;

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    final sz = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // WRAP IN OBX FOR REAL-TIME UPDATES
    return Obx(() {
      // Accessing the reactive getter triggers the listener
      final riskData = session.getRiskScore;

      if (overview) {
        void openAssessment() => Get.toNamed(AppRoutes.riskProfile);
        return _ProfileOverviewCard(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: openAssessment,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.speed_outlined,
                        size: 20,
                        color: _ProfileOverviewStyle.ink,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your Risk Profile',
                          style: _ProfileOverviewStyle.text(
                            14,
                            color: _ProfileOverviewStyle.muted,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: riskData == null
                            ? 'Assess risk profile'
                            : 'Retake risk assessment',
                        onPressed: openAssessment,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: _ProfileOverviewStyle.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (riskData == null)
                    TextButton(
                      onPressed: openAssessment,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        foregroundColor: Ucolors.primary,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        'Check Your Risk Profile Now!',
                        style: _ProfileOverviewStyle.text(
                          16,
                          color: Ucolors.primary,
                          weight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${riskData.totalScore}',
                                style: const TextStyle(
                                  color: Ucolors.homeProgress,
                                ),
                              ),
                              const TextSpan(text: ' / 150'),
                            ],
                          ),
                          style: _ProfileOverviewStyle.text(
                            40,
                            color: Colors.black,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          riskData.profileName.toUpperCase(),
                          style: _ProfileOverviewStyle.text(
                            14,
                            color: Colors.black,
                            weight: FontWeight.w600,
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
    this.subtitle,
    this.canNumber,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
    this.overview = false,
  });

  final String img;
  final String? name;
  final String? subtitle;
  final String? canNumber;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final bool overview;

  @override
  Widget build(BuildContext context) {
    if (overview) return _buildOverview(context);
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
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          Text(
            subtitle!,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
        if (canNumber != null && canNumber!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 14,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 5),
                Text(
                  'CAN: $canNumber',
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOverview(BuildContext context) => _ProfileOverviewCard(
    color: const Color(0xFFF8F9FB),
    padding: const EdgeInsets.all(20),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < 270 ||
            MediaQuery.textScalerOf(context).scale(16) > 24;
        final avatarSize = stacked ? 76.0 : 100.0;
        final avatar = Tooltip(
          message: 'Edit profile',
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: avatarSize,
              child: ClipOval(child: _buildImage()),
            ),
          ),
        );
        final edit = IconButton(
          tooltip: 'Edit personal details',
          visualDensity: VisualDensity.compact,
          onPressed: onTap,
          icon: const Icon(
            Icons.edit_outlined,
            size: 18,
            color: Color(0xFF526581),
          ),
        );
        final details = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    name?.trim().isNotEmpty == true ? name! : 'Profile',
                    style: _ProfileOverviewStyle.text(
                      20,
                      color: const Color(0xFF303030),
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!stacked) edit,
              ],
            ),
            if (subtitle?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: _ProfileOverviewStyle.text(
                  14,
                  color: const Color(0xFF425675),
                ),
              ),
            ],
            if (canNumber?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _ProfileOverviewStyle.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_outlined,
                      size: 16,
                      color: _ProfileOverviewStyle.blue,
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        'CAN: $canNumber',
                        style: _ProfileOverviewStyle.text(
                          12,
                          color: _ProfileOverviewStyle.blue,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [avatar, const Spacer(), edit]),
              const SizedBox(height: 16),
              details,
            ],
          );
        }
        return Row(
          children: [
            avatar,
            const SizedBox(width: 16),
            Expanded(child: details),
          ],
        );
      },
    ),
  );

  //
  Widget _buildImage() {
    // 1. Agar image empty/null hai
    if (img.isEmpty || img == 'null') {
      return Image.asset(
        UImages.avatar,
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
