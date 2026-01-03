import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/subtitle_section.dart';
import 'package:my_sip/features/personalization/screen/profile/details/bank_details.dart';
import 'package:my_sip/features/personalization/screen/profile/details/document.dart';
import 'package:my_sip/features/personalization/screen/profile/details/help_support.dart';
import 'package:my_sip/features/personalization/screen/profile/details/kyc_details.dart';
import 'package:my_sip/features/personalization/screen/profile/details/nominee_list.dart';
import 'package:my_sip/features/personalization/screen/profile/details/personal_details.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final sz = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: UPadding.screenPadding,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: kToolbarHeight),

                /// Profile Header
                ProfileHeader(
                  onTap: () {},
                  name: 'Pratik',
                  img: UImages.avatar,
                  subtitle: 'abc@gmail.com',
                  icon: Icons.edit,
                ),

                /// Personal Details Button
                PersonalDetailsButton(
                  onPressed: () => Get.to(() => PersonalDetailsScreen()),
                ),

                SizedBox(height: 20),

                /// Upgrade Banner
                Upgradebanner(),

                SizedBox(height: 20),

                /// Activity Section  &&  General Section
                ActivityGeneralSection(),
                SizedBox(height: 20),

                /// Logout Button
                LogoutButton(),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.063,
      // height: 52,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(14),
            side: BorderSide(color: Ucolors.darkgrey),
          ),
          // fixedSize: Size(double.infinity, 44),
        ),
        iconAlignment: IconAlignment.end,
        onPressed: () {},

        icon: Image.asset(UImages.logout),
        label: Text(
          'Logout',
          style: UTextStyles.buttonText.copyWith(
            color: Ucolors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ActivityGeneralSection extends StatelessWidget {
  const ActivityGeneralSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      color: Ucolors.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 16),

              SectionHeading(
                sectionTitle: 'Activity',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Listtilecustom(
            onTap: () => Get.to(() => KycDetailsScreen()),
            title: 'KYC Details',
            images: UImages.archiveadd,
          ),
          Listtilecustom(
            onTap: () => Get.to(() => BankDetailsScreen()),
            title: 'Bank Account',
            images: UImages.arrow,
          ),
          Listtilecustom(
            // onTap: () => Get.to(() => NomineeDetailsScreen()),
            onTap: () => Get.to(() => NomineeListScreen()),
            title: 'Nominee Details',
            images: UImages.verify,
          ),
          Listtilecustom(
            onTap: () => Get.to(() => DocumentScreen()),
            title: 'Documents',
            images: UImages.cardtick,
          ),
          Row(
            children: [
              SizedBox(width: 16),
              SectionHeading(
                sectionTitle: 'General',
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Listtilecustom(
            title: 'Applock',
            images: UImages.setting,
            onTap: () {},
          ),
          Listtilecustom(
            title: 'Help & Support',
            images: UImages.eye,
            onTap: () => Get.to(() => HelpSupportScreen()),
          ),
          Listtilecustom(
            title: 'About Us',
            images: UImages.msgques,
            onTap: () {},
          ),
          Listtilecustom(
            onTap: () {},
            title: 'Rate Us',
            images: UImages.likedislike,
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
    this.child,
  });

  final String title;
  final String? images;
  final VoidCallback onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity(vertical: -1),
      onTap: onTap,
      isThreeLine: false,
      leading: images != null ? Image.asset(images!) : null,
      title: Text(
        title,
        style: UTextStyles.subtitle2.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          child ??
          Icon(Icons.arrow_forward_ios, color: Ucolors.darkgrey, size: 14),
    );
  }
}

class PersonalDetailsButton extends StatelessWidget {
  const PersonalDetailsButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),

          // side: BorderSide(color: Colors.green),
        ),
        fixedSize: Size(Get.width / 2.5, sz.height * 0.06),
      ),
      child: FittedBox(
        child: Text(
          'Personal Details',
          style: TextStyle(fontSize: 14, color: Ucolors.dark),
        ),
      ),
    );
  }
}

class Upgradebanner extends StatelessWidget {
  const Upgradebanner({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return UElevatedBUtton(
      onPressed: () {},
      height: sz.height * 0.08,
      child: ListTile(
        leading: CircleAvatar(
          // radius: 30,
          backgroundColor: Colors.amber,
          backgroundImage: AssetImage(UImages.crown),
        ),
        title: SubtitleText(
          fontWeight: FontWeight.w600,
          textcolor: Ucolors.light,
          subtitle: 'Upgrade Your Plan Now!',
          textAlignCenter: TextAlign.left,
        ),
        subtitle: FittedBox(
          child: SubtitleText(
            textAlignCenter: TextAlign.left,
            textcolor: Ucolors.light,
            subtitle: 'Enjoy all the benefits and explore more possibilities',
          ),
        ),
        trailing: InkWell(
          child: Icon(Icons.arrow_forward_ios, color: Ucolors.light),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.img,
    this.name,
    required this.subtitle,
    required this.icon,
    this.left,
    this.bottom,
    required this.onTap,
    this.iconcolor,
  });
  final String img;
  final String? name;
  final String subtitle;
  final IconData icon;
  final double? left;
  final double? bottom;
  final VoidCallback onTap;
  final Color? iconcolor;

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage(img),
                  radius: 60,
                ),
              ),
            ),
            Positioned(
              left: left ?? 70,
              right: 0,
              bottom: bottom ?? 5,

              child: CircleAvatar(
                backgroundColor: Ucolors.light,
                radius: 14,
                child: Center(
                  child: Icon(icon, color: iconcolor ?? Ucolors.dark),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: sz.height * 0.01),

        SectionHeading(
          sectionTitle: name ?? '',
          textcolor: Ucolors.dark,
          fontWeight: FontWeight.w700,
        ),

        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: (Get.width * 0.035).clamp(12, 14),
          ),
        ),

        SizedBox(height: sz.height * 0.01),
      ],
    );
  }
}
