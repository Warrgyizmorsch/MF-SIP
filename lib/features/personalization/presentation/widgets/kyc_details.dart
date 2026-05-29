import 'package:flutter/material.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';

import '../../../../core/utils/constant/text_style.dart';

class KycDetailsScreen extends StatelessWidget {
  const KycDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: isDesktop ? null : CustomAppBarNormal(title: 'KYC Details'),
      body: SingleChildScrollView(
        padding: isDesktop ? const EdgeInsets.all(40) : UPadding.screenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200), // Max web width
            child: isDesktop
                ? _buildWebDashboardLayout() // 💻 Desktop Layout
                : _buildMobileLayout(), // 📱 Mobile Layout
          ),
        ),
      ),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (Side-by-Side)
  // =========================================
  Widget _buildWebDashboardLayout() {
    final user = SessionManager.instance.userObs.value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LEFT COLUMN: Profile Summary ---
        Expanded(
          flex: 4,
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  ProfileHeader(
                    img: user?.img ?? UImages.avatar,
                    name: user?.name ?? 'Guest User',
                    subtitle:
                        'Ready to invest since ${user?.customerDetailsModel?.dob?.split('-')[0] ?? ''}',
                    icon: Icons.verified,
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Your account is fully verified and ready for investments.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: FontFamily.medium,color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 30), // Gap between columns
        // --- RIGHT COLUMN: KYC Cards Grid ---
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "KYC Information",
              //   style: TextStyle(fontFamily: FontFamily.medium,fontSize: 22, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 20),
              // Grid for displaying cards side by side on Web
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 cards in one row
                childAspectRatio: 2.5, // Controls card height
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  InfoCard(
                    title: 'Tax Status',
                    subtitle: ProfileUtils.getWealthSourceName(
                      int.tryParse(
                        user?.customerDetailsModel?.wealthSource ?? '',
                      ),
                    ),
                  ),
                  InfoCard(
                    title: 'Pan Number',
                    subtitle: user?.panCard ?? 'Not Available',
                  ),
                  InfoCard(
                    title: 'Risk Profile',
                    subtitle: user?.riskProfileModel?.profileName ?? 'Balanced',
                  ),
                  InfoCard(
                    title: 'Aadhaar (Last 4)',
                    subtitle: user?.customerDetailsModel?.adhar ?? 'XXXX',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT (Stacked)
  // =========================================
  Widget _buildMobileLayout() {
    final user = SessionManager.instance.userObs.value;

    return Column(
      children: [
        SizedBox(height: kToolbarHeight - kToolbarHeight / 2),
        ProfileHeader(
          img: user?.img ?? UImages.avatar,
          name: user?.name ?? 'Guest User',
          subtitle:
              'Ready to invest since ${user?.customerDetailsModel?.dob?.split('-')[0] ?? ''}',
          icon: Icons.verified,
          onTap: () {},
          iconColor: user?.kycStatus?.toLowerCase() == 'approved'
              ? Colors.green
              : Colors.black,
        ),
        const SizedBox(height: 30),

        InfoCard(
          title: 'Kyc Status',
          // subtitle: user?.customerDetailsModel?.wealthSource ?? 'Not Available',
          // subtitle: ProfileUtils.getWealthSourceName(
          //   int.tryParse(user?.customerDetailsModel?.wealthSource ?? ''),
          // ),
          subtitle: user?.kycStatus ?? 'NO KYC',
          trailing: user?.kycStatus?.toLowerCase() == 'approved'
              ? Icon(Icons.verified, color: Colors.green)
              : null,
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            // final responseData =
            //     SessionManager.instance.onboardingRespone.value;

            // if (responseData != null) {
            //   String prettyPrint = const JsonEncoder.withIndent(
            //     '  ',
            //   ).convert(responseData.toJson());
            //   log('✅ Onboarding Response:\n$prettyPrint');
            // } else {
            //   log('❌ Onboarding Response is currently NULL');
            //   log(
            //     '${SessionManager.instance.tokenDataModel.value?.id}----------${SessionManager.instance.getTokenData?.id}',
            //   );
            // }
          },

          child: InfoCard(
            title: 'Pan Number',
            subtitle:
                SessionManager.instance.getUserData?.panCard ?? 'Not Available',
          ),
        ),
      ],
    );
  }
}

// Keep your existing InfoCard here
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.colum1,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget? colum1;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Ucolors.light,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SectionHeading(
                      sectionTitle: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 6),
                    SubtitleText(subtitle: subtitle, fontSize: 12),
                    if (colum1 != null) ...[const SizedBox(height: 8), colum1!],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 10), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
