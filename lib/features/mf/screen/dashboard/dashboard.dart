import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/features/mf/controller/dashboard_controller/dashboard_controller.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

enum PortfolioMenuAction { topUp, modify, pause, cancel, redemption }

/// --- PopMenuItem
PopupMenuItem<PortfolioMenuAction> buildMenuItem({
  required IconData icon,
  required String text,
  required PortfolioMenuAction value,
}) {
  return PopupMenuItem<PortfolioMenuAction>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

///------Bottom Dashed Painter----------//
class BottomDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height - 10);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 10,
      size.width * 0.5,
      size.height - 5,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 20,
      size.width,
      size.height - 10,
    );

    /// Dash logic
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

///-----------Bottom Clliper ----------///
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 20,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 20,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PortfolioTabController());
    return Scaffold(
      backgroundColor: Ucolors.light,
      body: CustomScrollView(
        slivers: [
          /// 1️⃣ App Bar
          ///
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: false,
            pinned: true,
            flexibleSpace: CustomProfileAppbar(
              onProfiletap: () => Get.to(() => ProfileScreen()),
              backgroundColor: Color(0xffE8F5FF),
              // backgroundColor: Colors.amber,
              greetingName: 'Nazzu',
              role: 'Developer',
              avatar: AssetImage(UImages.avatar),
              iconColor: Ucolors.blue,
              roleColor: Ucolors.blue,
              greetingNameColor: Ucolors.blue,
              action: [
                CompactIcon(
                  icon: Iconsax.notification,
                  onPressed: () {},
                  iconColor: Ucolors.dark,
                ),
                CompactIcon(
                  icon: Iconsax.shopping_cart,
                  onPressed: () {},
                  iconColor: Ucolors.dark,
                ),
                CompactIcon(
                  icon: Iconsax.archive_tick,
                  onPressed: () {},
                  iconColor: Ucolors.dark,
                ),
              ],
              actionsPadding: EdgeInsets.only(right: 16),
            ),
          ),

          /// 2️⃣ Portfolio Summary Card
          SliverToBoxAdapter(
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                width: double.infinity,
                color: Color(0xffE8F5FF),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    // bottom: 16,
                  ),
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff0B3C5D), Color(0xff072A40)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Value',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: Ucolors.skyblue),
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹32,580',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CompactIcon(
                                icon: Icons.remove_red_eye,
                                onPressed: () {},
                                iconColor: Ucolors.light,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SummaryItem(title: 'Invested', value: '₹30,000'),
                              SummaryItem(
                                title: 'Total Returns',
                                value: '₹2,580',
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Dashed Painter
          SliverToBoxAdapter(
            child: CustomPaint(
              painter: BottomDashedLinePainter(),
              size: const Size(double.infinity, 0.01),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          /// My portfolio &  Transactions Tabbar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F6F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() {
                  final controller = Get.find<PortfolioTabController>();

                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedIndex.value == 0
                                  ? Ucolors.light
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'My Portfolio',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: controller.selectedIndex.value == 0
                                    ? Ucolors.primary
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.changeTab(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: controller.selectedIndex.value == 1
                                  ? Ucolors.light
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Transactions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: controller.selectedIndex.value == 1
                                    ? Ucolors.primary
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          Obx(() {
            final controller = Get.find<PortfolioTabController>();

            if (controller.selectedIndex.value == 0) {
              /// 🟦 MY PORTFOLIO TAB
              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: SectionHeading(
                      sectionTitle: 'My Portfolio',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      textcolor: const Color(0xff787878),
                    ),
                  ),
                  ...List.generate(6, (index) => const PortfolioCard()),
                ]),
              );
            } else {
              /// 🟩 TRANSACTIONS TAB
              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: SectionHeading(
                      sectionTitle: 'Transactions',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      textcolor: const Color(0xff787878),
                    ),
                  ),
                  ...List.generate(6, (index) => TransactionCard()),
                ]),
              );
            }
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Top Row (Date + Amount)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'January 10, 2024',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 14),
              ),
              Text(
                '₹1000',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Ucolors.success),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 Bottom Row (Description + Source)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,

                  'Funding from salary',
                  style: UTextStyles.small.copyWith(color: Color(0xff9A9A9A)),
                  // style: TextStyle(fontSize: 14, color: Colors.grey),
                  // style: Theme.of(
                  //   context,
                  // ).textTheme.labelLarge!.copyWith(color: Color(0xff9A9A9A)),
                ),
              ),
              // Gap(12),
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  'Savings from Local Bank 1',
                  style: UTextStyles.small.copyWith(color: Color(0xff9A9A9A)),

                  // style: TextStyle(fontSize: 14, color: Colors.grey),
                  // style: Theme.of(
                  //   context,
                  // ).textTheme.labelLarge!.copyWith(color: Color(0xff9A9A9A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    this.subtitle = true,
    this.iconButton = true,
  });

  final bool subtitle;
  final bool iconButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => FundDeatailsScreen()),

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// 🔹 Top Row (Icon + Title + Menu)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // / Fund Icon
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: ClipOval(
                    child: Image.asset(UImages.sbi, fit: BoxFit.cover),
                  ),
                ),

                // CircleAvatar(backgroundImage: AssetImage(UImages.sbi)),
                const SizedBox(width: 12),

                /// Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (subtitle) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Text(
                              '1D Change:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '-₹24.2',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 18,
                              color: Colors.red,
                            ),
                            Text(
                              '0.44%',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                /// Menu
                // const Icon(Icons.more_vert, color: Colors.grey),
                iconButton
                    ? PopupMenuButton<PortfolioMenuAction>(
                        color: Ucolors.light,
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        // elevation: 6,
                        offset: const Offset(0, 40),
                        onSelected: (value) {
                          switch (value) {
                            case PortfolioMenuAction.topUp:
                              log('top up');
                              break;

                            case PortfolioMenuAction.modify:
                              break;
                            case PortfolioMenuAction.pause:
                              break;
                            case PortfolioMenuAction.cancel:
                              break;
                            case PortfolioMenuAction.redemption:
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          buildMenuItem(
                            icon: Iconsax.card_send,
                            text: 'Top Up',
                            value: PortfolioMenuAction.topUp,
                          ),
                          buildMenuItem(
                            icon: Iconsax.edit_2,
                            text: 'Modify',
                            value: PortfolioMenuAction.modify,
                          ),
                          buildMenuItem(
                            icon: Iconsax.pause,
                            text: 'Pause',
                            value: PortfolioMenuAction.pause,
                          ),
                          buildMenuItem(
                            icon: Iconsax.trash,
                            text: 'Cancel',
                            value: PortfolioMenuAction.cancel,
                          ),
                          buildMenuItem(
                            icon: Iconsax.receipt,
                            text: 'Redemption',
                            value: PortfolioMenuAction.redemption,
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 Bottom Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatItem1(title: 'Invested', amount: '₹5K', percentage: ''),
                StatItem1(
                  percentage: '',
                  title: 'Current Value',
                  amount: '₹5.43K',
                ),

                StatItem1(
                  percentage: '8.55 %',
                  title: 'Gain/Loss',

                  amount: '₹427.35',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem1 extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final Color percentageColor;
  final Color amountColor;

  const StatItem1({
    required this.title,
    required this.amount,
    required this.percentage,
    this.percentageColor = Colors.green,
    this.amountColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: amount,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: amountColor,
                ),
              ),
              const TextSpan(text: '  '),
              TextSpan(
                text: percentage,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: percentageColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 🔹 Summary Item Widget
class SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          //  style: const TextStyle(color: Colors.white70)
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: Ucolors.skyblue),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
