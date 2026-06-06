// ignore_for_file: unnecessary_brace_in_string_interps, unused_element_parameter, unused_local_variable

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/video/custom_inline_youtube_player.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

import 'package:my_sip/features/home/presentation/widgets/product_tool/top_up_calculator.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/sip_process/presentation/controllers/sip_process_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/product_tool/sip_calculator.dart';
import '../widgets/product_tool/swp_calci.dart';

class WebHoverScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  const WebHoverScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 1.05,
  });

  @override
  State<WebHoverScale> createState() => _WebHoverScaleState();
}

class _WebHoverScaleState extends State<WebHoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Changes background/border color on hover (Good for List Tiles)
class WebHoverTile extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final VoidCallback? onTap;

  const WebHoverTile({super.key, required this.builder, this.onTap});

  @override
  State<WebHoverTile> createState() => _WebHoverTileState();
}

class _WebHoverTileState extends State<WebHoverTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(_isHovered),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cartController = Get.find<CartController>();
  final mutualcontroller = Get.find<MutualFundController>();
  final navigation = Get.find<NavigationBarController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final shortestSide = MediaQuery.of(context).size.shortestSide;

    final bool isMobileDevice = kIsWeb ? false : shortestSide < 600;

    final bool isDesktop1 =
        !isMobileDevice && ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      body:
          isDesktop1 // change to isDesktop
          ? _WebDashboardLayout(
              authController: authController,
              cartController: cartController,
              mutualController: mutualcontroller,
              navController: navigation,
            )
          : _MobileLayout(
              authController: authController,
              cartController: cartController,
              mutualController: mutualcontroller,
              navController: navigation,
            ),
    );
  }
}

class _WebDashboardLayout extends StatelessWidget {
  final AuthController authController;
  final CartController cartController;
  final MutualFundController mutualController;
  final NavigationBarController navController;

  const _WebDashboardLayout({
    required this.authController,
    required this.cartController,
    required this.mutualController,
    required this.navController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PersonalisationController>();

    final isPending = controller.isKycPending.value;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isTablet = width < 800;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,

            child: isTablet
                /// TABLET LAYOUT
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildLeftSectionTable(context, isPending)],
                  )
                /// DESKTOP LAYOUT
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT SECTION
                      Expanded(
                        flex: 6,
                        child: _buildLeftSection(context, isPending),
                      ),

                      const SizedBox(width: 30),

                      /// RIGHT SECTION
                      Expanded(flex: 4, child: _buildRightSection(context)),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLeftSectionTable(BuildContext context, bool isPending) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        /// HERo
        isPending ? _buildHeroBanner() : _buildKycIsComplete(),

        const Gap(24),

        _buildQuickActionsCard(context),

        const Gap(24),

        _buildWebCollectionGrid(),

        const Gap(24),

        _buildRecentCard(),

        const Gap(24),

        _buildWebFundGrid(),

        const Gap(24),

        _buildWebGoalSection(),

        const Gap(24),

        _buildWebToolsSection(),

        /// FUNDS
        const Gap(30),

        /// VIDEOS
        _buildWebVideoRow(),
      ],
    );
  }

  // =========================================================
  // LEFT SECTION
  // =========================================================

  Widget _buildLeftSection(BuildContext context, bool isPending) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HERO
        ///
        isPending ? _buildHeroBanner() : _buildKycIsComplete(),

        const Gap(24),

        _buildWebCollectionGrid(),
        const Gap(24),

        _buildWebFundGrid(),

        const Gap(24),

        /// VIDEOS
        _buildWebVideoRow(),
      ],
    );
  }

  // =========================================================
  // RIGHT SECTION
  // =========================================================

  Widget _buildRightSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildQuickActionsCard(context),

        const Gap(24),

        _buildRecentCard(),
        const Gap(28),
        _buildWebGoalSection(),
        const Gap(24),

        _buildWebToolsSection(),
      ],
    );
  }

  Widget _buildRecentCard() {
    return Obx(() {
      final bool isLoading = mutualController.isLoading.value;
      final List recentList = mutualController.recentlyViewedFunds;

      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final bool isMobile = width < 700;
          final bool isTablet = width >= 700 && width < 1100;

          final int crossAxisCount = isMobile
              ? 1
              : isTablet
              ? 3
              : 4;

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const USectionHeading(
                  title: 'Recently Viewed',
                  fontSize: 22,
                  showActionButton: false,
                ),
                const SizedBox(height: 16),

                /// 1. LOADING STATE
                if (isLoading)
                  FundShimmerLoading(crossAxisCount: crossAxisCount)
                /// 2. EMPTY STATE
                else if (recentList.isEmpty)
                  Container(
                    width: double.infinity,
                    height: 340,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 44,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No recently viewed funds",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                            fontFamily: FontFamily.medium,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your history will appear here.",
                          style: TextStyle(
                            fontFamily: FontFamily.medium,

                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                /// 3. DATA LOADED (Sirf 2 Rows dikhenge, baki ke liye Scroll hoga)
                else
                  SizedBox(
                    height: 345,
                    child: GridView.builder(
                      shrinkWrap: false,
                      physics: const BouncingScrollPhysics(),
                      itemCount: recentList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisExtent: 160,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                      ),
                      itemBuilder: (context, index) {
                        final fund = recentList[index];

                        // Logo Image handling
                        final rawLogo = fund.amc?.amcLogoUrl ?? '';
                        final img = rawLogo.startsWith('http')
                            ? rawLogo
                            : "${Appurl.baseUrl}$rawLogo";

                        final name = fund.baseSchemeName ?? 'Unknown Name';

                        return PopularFundCard(
                          onTap: () {
                            Get.delete<FundDetailsController>();
                            FundDetailsScreen.navData = {
                              'scheme': name,
                              'imgUrl': img,
                              'scheme_code': fund.schemeCode.toString(),
                            };
                            Get.toNamed(AppRoutes.funddetails, id: 1);
                          },
                          isNetwork: true,
                          imgPath: img,
                          name: name,
                          threeYear: fund.returnsEntity?.threeYear ?? '--',
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  // =========================================================
  // VIDEO SECTION
  // =========================================================

  Widget _buildWebVideoRow() {
    final videos = [
      {
        "thumbnail": "https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg",
        "videoId": "yo5aL4Plbso",
      },
      {
        "thumbnail": "https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg",
        "videoId": "t7lUSiddFd4",
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bool isMobile = width < 600;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title inside the card
              const Text(
                "Learn & Grow",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.medium,
                ),
              ),
              const SizedBox(height: 20),

              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(videos.length, (index) {
                  final item = videos[index];

                  return Expanded(
                    flex: isMobile
                        ? 2
                        : videos
                              .length, // Mobile par fixed height, Web par equal width
                    child: Padding(
                      padding: EdgeInsets.only(
                        // Desktop par beech mein space, Mobile par niche space
                        right: (!isMobile && index == 0) ? 20 : 0,
                        bottom: (isMobile && index != videos.length - 1)
                            ? 20
                            : 0,
                      ),
                      child: SizedBox(
                        height: isMobile ? 180 : 220, // Fixed height for videos
                        child: WebHoverScale(
                          scale: 1.02,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // Sub-card border effect
                              border: Border.all(color: Colors.grey.shade50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: InlineYouTubePlayer(
                                thumbnailUrl: item['thumbnail'] as String,
                                videoId: item['videoId'] as String,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // GOAL SECTION
  // =========================================================

  Widget _buildWebGoalSection() {
    final goals = [
      {
        "title": "Car Goal",
        "icon": Icons.directions_car_filled_rounded,
        "goalType": "car",
      },
      {
        "title": "Marriage Goal",
        "icon": Icons.favorite_border_outlined,
        "goalType": "marriage",
      },
      {"title": "Home Goal", "icon": Icons.home_rounded, "goalType": "home"},
      {
        "title": "Vacation Goal",
        "icon": Icons.flight_takeoff_rounded,
        "goalType": "vacation",
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Plan Your Goals",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.medium,
            ),
          ),

          const Gap(20),

          /// ROW BUTTONS
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              /// MOBILE = 2
              /// WEB = 4

              final bool isMobile = width < 700;
              final bool isTablet = width >= 700 && width < 1100;

              final int crossAxisCount = width < 300
                  ? 1
                  : isMobile
                  ? 2
                  : isTablet
                  ? 3
                  : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: goals.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,

                  mainAxisExtent: 75,

                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),

                itemBuilder: (context, index) {
                  final item = goals[index];

                  return _buildGoalTile(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    goalType: item['goalType'] as String,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GOAL TILE
  // =========================================================

  Widget _buildGoalTile({
    required String title,
    required IconData icon,
    required String goalType,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;

        /// RESPONSIVE FONT
        final bool isMobile = width < 400;
        final bool isTablet = width >= 400 && width < 1800;

        final double titleFontSize = isMobile
            ? 12
            : isTablet
            ? 14
            : 16;

        final double iconBoxSize = isMobile ? 32 : 44;

        final double arrowSize = isMobile ? 13 : 16;
        final double iconSize = isMobile ? 16 : 20;

        return WebHoverTile(
          onTap: () {},

          builder: (isHovered) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),

              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 10,
                vertical: isMobile ? 8 : 10,
              ),

              decoration: BoxDecoration(
                color: isHovered
                    ? Ucolors.primary.withValues(alpha: 0.06)
                    : Colors.grey.shade50,

                borderRadius: BorderRadius.circular(14),

                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.15)
                      : Colors.grey.shade200,
                ),
              ),

              child: Row(
                children: [
                  /// ICON
                  Container(
                    height: iconBoxSize,
                    width: iconBoxSize,
                    decoration: BoxDecoration(
                      color: isHovered
                          ? Ucolors.primary.withValues(alpha: 0.12)
                          : Colors.white,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(
                      icon,
                      size: iconSize,
                      color: isHovered ? Ucolors.primary : Colors.grey.shade700,
                    ),
                  ),

                  SizedBox(width: isMobile ? 6 : 8),

                  /// TITLE
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        height: 1.2,
                        fontFamily: FontFamily.medium,

                        fontWeight: isHovered
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isHovered ? Ucolors.primary : Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(width: isMobile ? 6 : 10),

                  /// ARROW
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: arrowSize,
                    color: isHovered ? Ucolors.primary : Colors.grey.shade400,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // TOOLS SECTION
  // =========================================================

  Widget _buildWebToolsSection() {
    final tools = [
      {
        "title": "SIP Calculator",
        "img": UImages.sipcalci,
        "onTap": () => Get.toNamed(AppRoutes.sipCalculator, id: 1),
      },
      {
        "title": "SWP Calculator",
        "img": UImages.swpcali,
        "onTap": () => Get.toNamed(AppRoutes.swpCalculator, id: 1),
      },
      {
        "title": "Step-Up Calculator",
        "img": UImages.siptopcalci,
        "onTap": () => Get.toNamed(AppRoutes.stepUpCalculator, id: 1),
      },
      {
        "title": "Compare Fund",
        "img": UImages.comparefund,
        "onTap": () => Get.toNamed(AppRoutes.comparefund, id: 1),
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Financial Tools",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.medium,
            ),
          ),

          const Gap(20),

          /// GRID
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              /// MOBILE = 1
              /// TABLET/WEB = 2

              final bool isMobile = width < 700;
              final bool isTablet = width >= 700 && width < 1100;

              final int crossAxisCount = width < 300
                  ? 1
                  : isMobile
                  ? 2
                  : isTablet
                  ? 3
                  : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: tools.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,

                  mainAxisExtent: 75,

                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),

                itemBuilder: (context, index) {
                  final item = tools[index];

                  return _buildToolItem(
                    item['title'] as String,
                    item['img'] as String,
                    item['onTap'] as VoidCallback,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TOOL ITEM
  // =========================================================

  Widget _buildToolItem(String title, String img, VoidCallback onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;

        /// RESPONSIVE FONT
        /// RESPONSIVE FONT
        final bool isMobile = width < 400;
        final bool isTablet = width >= 400 && width < 1800;

        final double titleFontSize = isMobile
            ? 12
            : isTablet
            ? 14
            : 16;

        final double iconBoxSize = isMobile ? 32 : 44;

        final double arrowSize = isMobile ? 13 : 16;
        final double iconSize = isMobile ? 16 : 20;

        return WebHoverTile(
          onTap: onTap,
          builder: (isHovered) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 10,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? Ucolors.primary.withValues(alpha: 0.06)
                    : Colors.grey.shade50,

                borderRadius: BorderRadius.circular(14),

                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.15)
                      : Colors.grey.shade200,
                ),
              ),

              child: Row(
                children: [
                  /// IMAGE
                  Container(
                    height: iconBoxSize,
                    width: iconBoxSize,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(img, fit: BoxFit.contain),
                  ),

                  SizedBox(width: isMobile ? 6 : 8),

                  /// TITLE
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        height: 1.2,
                        fontFamily: FontFamily.medium,

                        fontWeight: isHovered
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isHovered ? Ucolors.primary : Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(width: isMobile ? 6 : 10),

                  /// ARROW
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: arrowSize,
                    color: isHovered ? Ucolors.primary : Colors.grey.shade400,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // =========================================================
  // HERO BANNER
  // =========================================================

  Widget _buildHeroBanner() {
    return WebHoverScale(
      scale: 1.01,
      onTap: () {
        if (kIsWeb) {
          // Show Dialog for Web Users
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.smartphone, color: Ucolors.primary),
                  const SizedBox(width: 10),
                  const Text("Mobile App Required"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "For security and verification purposes, the KYC process can only be completed via our Mobile Application.",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.medium,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Please download the app from the Play Store or App Store to continue.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: FontFamily.medium,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Got it",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.medium,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Navigate for Mobile Users
          Get.toNamed(AppRoutes.kycScreen, id: 1);
        }
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 180),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF07315C), Color(0xff0280C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Ucolors.primary.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            /// LEFT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back, ${authController.user.value?.name ?? 'Investor'}!",
                    style: UTextStyles.heading2.copyWith(color: Colors.white),
                  ),

                  const Gap(10),

                  Text(
                    "Track your investments and achieve your financial freedom.",
                    style: UTextStyles.medium.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const Gap(20),

            /// KYC CARD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: Colors.white),

                  const Gap(10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "KYC Status",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: FontFamily.medium,
                        ),
                      ),

                      Text(
                        "Pending Action",
                        style: UTextStyles.subtitle1.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKycIsComplete() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return Container(
          width: constraints.maxHeight * 0.4,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
          ),

          /// MOBILE = HORIZONTAL SCROLL
          child: isMobile
              ? SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          "icon": Icons.flag,
                          "title": "Plan your goals",
                          "subtitle": "Set clear financial targets",
                          "color": Colors.blueAccent,
                        },
                        {
                          "icon": Icons.person_search,
                          "title": "Know your investment personality",
                          "subtitle": "Discover your risk profile",
                          "color": Colors.deepPurpleAccent,
                        },
                        {
                          "icon": Icons.shopping_basket,
                          "title": "Explore your investment basket",
                          "subtitle": "Diversify across funds",
                          "color": Colors.green,
                        },
                      ];

                      final item = items[index];

                      return SizedBox(
                        width: constraints.maxWidth * 0.3,
                        child: WebActionCard(
                          icon: item["icon"] as IconData,
                          title: item["title"] as String,
                          subtitle: item["subtitle"] as String,
                          color: item["color"] as Color,
                        ),
                      );
                    },
                  ),
                )
              /// TABLET / WEB
              : Row(
                  children: [
                    Expanded(
                      child: WebActionCard(
                        icon: Icons.flag,
                        title: "Plan your goals",
                        subtitle: "Set clear financial targets",
                        color: Colors.blueAccent,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: WebActionCard(
                        icon: Icons.person_search,
                        title: "Know your investment personality",
                        subtitle: "Discover your risk profile",
                        color: Colors.deepPurpleAccent,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: WebActionCard(
                        icon: Icons.shopping_basket,
                        title: "Explore your investment basket",
                        subtitle: "Diversify across funds",
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // =========================================================
  // QUICK ACTIONS
  // =========================================================

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 5,
            child: _WebQuickActionItem("SIP", UImages.startsip, () {
              SipProcessController.navIsLumpsum = false;

              Get.toNamed(
                id: 1,
                AppRoutes.startSipScreen,
                arguments: {'isLumpsum': false},
              );
            }),
          ),
          Gap(20),
          Expanded(
            flex: 5,
            child: _WebQuickActionItem("Lumpsum", UImages.glyph, () {
              SipProcessController.navIsLumpsum = true;

              Get.toNamed(
                id: 1,
                AppRoutes.startSipScreen,
                arguments: {'isLumpsum': true},
              );
            }),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // COLLECTION GRID
  // =========================================================

  Widget _buildWebCollectionGrid() {
    final nav = Get.find<NavigationBarController>();
    final funds = Get.find<FundhouseController>();
    

    final items = [
      {
        't': 'Best SIP',
        'i': UImages.savingbank,
        'onTap': () =>
            nav.navigateToExploreWithFilter(() => funds.applyBestSipFilter(1)),
      },
      {
        't': 'High Return',
        'i': UImages.highreturn,
        'onTap': () => nav.navigateToExploreWithFilter(
          () => funds.applyHighReturnFilter(),
        ),
      },
      {
        't': 'International',
        'i': UImages.interfund,
        'onTap': () => nav.navigateToExploreWithFilter(
          () => funds.applyInternationalFilter(),
        ),
      },
      {
        't': 'Index Funds',
        'i': UImages.indexfund,
        'onTap': () => nav.navigateToExploreWithFilter(
          () => funds.applyCustomSearch('index'),
        ),
      },
      {
        't': 'Commodities',
        'i': UImages.moneygold,
        'onTap': () =>
            nav.navigateToExploreWithFilter(() => funds.applyCommodityFilter()),
      },
      {
        't': 'NFO',
        'i': UImages.equity,
        'onTap': () => Get.toNamed(AppRoutes.nfolist, id: 1),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bool isMobile = width < 600;
        final int crossAxisCount = isMobile ? 2 : 3;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explore Categories",
                style: TextStyle(
                  fontSize: 22, // Slightly adjusted for card look
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.medium,
                ),
              ),
              const SizedBox(height: 20),

              // Categories Grid (Buttons as Sub-cards)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  // Dynamic height based on screen size
                  mainAxisExtent: isMobile ? 130 : 160,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (ctx, i) {
                  return CollectionItem(
                    title: items[i]['t']! as String,
                    iconImg: items[i]['i']! as String,
                    onTap: items[i]['onTap'] as VoidCallback,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // FUND GRID
  // =========================================================

  Widget _buildWebFundGrid() {
    return Obx(() {
      final bool isLoading = mutualController.isLoading.value;
      final List funds = mutualController.searchFund;

      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final bool isMobile = width < 700;
          final bool isTablet = width >= 700 && width < 1100;

          final int crossAxisCount = isMobile
              ? 2
              : isTablet
              ? 3
              : 4;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Popular Funds",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.medium,
                  ),
                ),
                const SizedBox(height: 20),

                /// Loading State
                if (isLoading)
                  FundShimmerLoading(crossAxisCount: crossAxisCount)
                else if (funds.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Iconsax.folder_open,
                            size: 52,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "No Funds Found",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: FontFamily.medium,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Try exploring other funds or check back later.",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: FontFamily.medium,

                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                /// Data Loaded State
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: funds.length > 8 ? 8 : funds.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisExtent: 160,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                    ),
                    itemBuilder: (context, index) {
                      final fund = funds[index];
                      final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
                      final name = fund.baseSchemeName ?? 'Unknown Name';

                      return PopularFundCard(
                        threeYear: fund.returnsEntity?.threeYear ?? '--',
                        isNetwork: true,
                        imgPath: img,
                        name: name,
                        onTap: () {
                          Get.delete<FundDetailsController>();
                          FundDetailsScreen.navData = {
                            'scheme': name,
                            'imgUrl': img,
                            'scheme_code': fund.schemeCode.toString(),
                          };
                          Get.toNamed(AppRoutes.funddetails, id: 1);
                        },
                      );
                    },
                  ),
              ],
            ),
          );
        },
      );
    });
  }
}

class _WebQuickActionItem extends StatefulWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _WebQuickActionItem(this.label, this.icon, this.onTap, {super.key});

  @override
  State<_WebQuickActionItem> createState() => _WebQuickActionItemState();
}

class _WebQuickActionItemState extends State<_WebQuickActionItem> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// RESPONSIVE
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;
    final bool isWeb = width >= 1100;

    final double cardWidth = isMobile
        ? 90
        : isTablet
        ? 110
        : 130;

    final double iconBoxSize = isMobile
        ? 56
        : isTablet
        ? 64
        : 74;

    final double iconSize = isMobile
        ? 24
        : isTablet
        ? 28
        : 32;

    final double fontSize = isMobile
        ? 12
        : isTablet
        ? 13
        : 15;

    final double padding = isMobile ? 12 : 16;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        scale: isPressed
            ? 0.96
            : isHovered
            ? 1.03
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),

            splashColor: Ucolors.primary.withValues(alpha: 0.08),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,

            onTapDown: (_) => _setPressed(true),

            onTapCancel: () => _setPressed(false),

            onTap: () async {
              _setPressed(true);

              await Future.delayed(const Duration(milliseconds: 90));

              _setPressed(false);

              widget.onTap();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              constraints: const BoxConstraints(minHeight: 180),
              width: cardWidth,
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),

                /// BACKGROUND
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Colors.white, Ucolors.primary.withValues(alpha: 0.04)]
                      : [Colors.white, Colors.white],
                ),

                /// BORDER
                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.15)
                      : Colors.grey.shade200,
                ),

                /// SHADOW
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? Ucolors.primary.withValues(alpha: 0.14)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ICON BOX
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: iconBoxSize,
                    width: iconBoxSize,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isHovered
                            ? [
                                Ucolors.primary,
                                Ucolors.primary.withValues(alpha: 0.85),
                              ]
                            : [
                                Ucolors.primary,
                                Ucolors.primary.withValues(alpha: 0.92),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Ucolors.primary.withValues(
                            alpha: isHovered ? 0.30 : 0.18,
                          ),
                          blurRadius: isHovered ? 18 : 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      widget.icon,
                      width: iconSize,
                      height: iconSize,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 10 : 14),

                  /// LABEL
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: isHovered ? Ucolors.primary : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WebGoalTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String type;
  const _WebGoalTile(this.title, this.icon, this.type);

  @override
  Widget build(BuildContext context) {
    // Use WebHoverTile for background highlight effect
    return WebHoverTile(
      // onTap: () =>
      //     Get.toNamed(AppRoutes.ihavegoal, arguments: {'goalType': type}),
      onTap: () => Get.toNamed(AppRoutes.comingSoon, id: 1),
      builder: (isHovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHovered
              ? Ucolors.blue.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border.all(
            color: isHovered ? Ucolors.blue : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Ucolors.blue, size: 20),
            const Gap(12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.medium,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: isHovered ? Ucolors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final AuthController authController;
  final CartController cartController;
  final MutualFundController mutualController;
  final NavigationBarController navController;

  _MobileLayout({
    required this.authController,
    required this.cartController,
    required this.mutualController,
    required this.navController,
  });

  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = SessionManager.instance.getUserData;

    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          //Appbar
          SliverAppBar(
            pinned: true,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            expandedHeight: kToolbarHeight,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.8, -0.7),
                  end: Alignment(0.8, 0.7),
                  stops: [0.0, 0.5784],
                  colors: [Color(0xFF07315C), Color(0xff0280C0)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: CustomProfileAppbar(
                    // onProfiletap: () => navController.selectedIndex.value = 4,
                    // onProfiletap: () => navController.changePage(4),
                    onProfiletap: () => Get.toNamed(AppRoutes.personaldetails),
                    backgroundColor: Colors.transparent,
                    greetingName: authController.user.value?.name ?? '',
                    role: UHelperFunction.getGreetingMsg(),
                    iconColor: Ucolors.light,
                    roleColor: Ucolors.borderColor,
                    greetingNameColor: Ucolors.light,
                    avatar: const AssetImage(UImages.avatar),
                    // img: UCircularImage(image: user?.img ?? ''),
                    img: UCircularImage(
                      image: personalisationController.imagePath.isEmpty
                          ? (user?.img ?? UImages.avatar)
                          : personalisationController.imagePath.value,
                    ),
                    action: [
                      CompactIcon(
                        icon: Iconsax.notification,
                        onPressed: () => Get.toNamed(AppRoutes.notification),
                        iconColor: Ucolors.light,
                      ),
                      const SizedBox(width: 2),
                      Obx(
                        () => Stack(
                          children: [
                            CompactIcon(
                              icon: Iconsax.shopping_cart,
                              onPressed: () {
                                Get.find<CartController>().filterGoalId.value =
                                    null;
                                Get.toNamed(AppRoutes.cart);
                                // cartController.fetchCart();
                              },
                              iconColor: Ucolors.light,
                            ),
                            if (cartController.generalItemsCount > 0)
                              Positioned(
                                right: 0,
                                top: -5,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Ucolors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    cartController.generalItemsCount.toString(),
                                    style: UTextStyles.buttonText.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 2),

                      // Obx(
                      //   () => Stack(
                      //     children: [
                      //       IconButton(
                      //         color: Ucolors.light,
                      //         icon: const Icon(Iconsax.shopping_cart),
                      //         onPressed: () {
                      //           // Reset filter to ensure regular cart items are shown
                      //           Get.find<CartController>().filterGoalId.value =
                      //               null;
                      //           Get.toNamed(AppRoutes.cart);
                      //         },
                      //         hoverColor: Ucolors.primary.withValues(alpha:0.1),
                      //       ),
                      //       // Use the new getter here
                      //       if (cartController.generalItemsCount > 0)
                      //         Positioned(
                      //           right: 5,
                      //           top: 5,
                      //           child: Container(
                      //             padding: const EdgeInsets.all(4),
                      //             decoration: const BoxDecoration(
                      //               color: Ucolors.red,
                      //               shape: BoxShape.circle,
                      //             ),
                      //             child: Text(
                      //               // Display the count of goal_id: null items
                      //               cartController.generalItemsCount.toString(),
                      //               style: const TextStyle(
                      //                 fontSize: 10,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // ),
                      CompactIcon(
                        icon: Iconsax.archive_tick,
                        onPressed: () => Get.toNamed(AppRoutes.watchlist),
                        iconColor: Ucolors.light,
                      ),
                    ],
                    actionsPadding: const EdgeInsets.only(right: 16),
                  ),
                ),
              ),
            ),
          ),

          //Header Section
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(height: size.height * 0.3),
                Container(
                  height: size.height * 0.21,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.8, -1.0),
                      end: Alignment(0.1, 1.0),
                      stops: [0.0, 0.9784],
                      colors: [Color(0xFF07315C), Color(0xFF0280C0)],
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          // onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                          onTap: () {
                            // Get.find<SipProcessController>().setInvestmentMode(
                            //   false,
                            // );
                            // Get.toNamed(AppRoutes.startSipScreen);
                            Get.toNamed(
                              AppRoutes.startSipScreen,
                              arguments: {'isLumpsum': false},
                            );
                          },
                          child: const FeatureSection(
                            featureName: 'SIP',
                            iconPath: UImages.startsip,
                          ),
                        ),
                        // GestureDetector(
                        //     onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                        //     child: const FeatureSection(featureName: 'Freedom SIP', iconPath: UImages.freedomsip)),
                        GestureDetector(
                          // onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                          onTap: () {
                            // Get.find<SipProcessController>().setInvestmentMode(
                            //   true,
                            // );
                            // Get.toNamed(AppRoutes.startSipScreen);
                            Get.toNamed(
                              AppRoutes.startSipScreen,
                              arguments: {'isLumpsum': true},
                            );
                          },
                          child: const FeatureSection(
                            featureName: 'Lumpsum',
                            iconPath: UImages.glyph,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  final controller = Get.find<PersonalisationController>();
                  final size = MediaQuery.of(context).size;

                  final isPending = controller.isKycPending.value;
                  final isVerified = controller.isKycVerified.value;
                  final noRiskProfile = !controller.hasRiskProfile.value;
                  final noNominee = !controller.hasNominee.value;
                  final noBank = !controller.hasBank.value;
                  final noPersonalDetails =
                      !controller.hasPersonalDetails.value;

                  final canNumber = controller.userData.value?.canNumber ?? '';
                  final noCan = canNumber.isEmpty;

                  final noMandate = !controller.hasApprovedMandate;

                  final isAllComplete =
                      isVerified &&
                      !noPersonalDetails &&
                      !noRiskProfile &&
                      !noNominee &&
                      !noBank &&
                      !noCan &&
                      !noMandate;

                  // --- 1. DEFAULT STATE ---
                  Color bgColor = Ucolors.light;
                  Color iconColor = Colors.black;
                  Color titleColor = Ucolors.dark;
                  Color subTextColor = Colors.grey;

                  IconData leftIcon = Icons.person;
                  Widget? customLeftIcon;
                  IconData rightIcon = Icons.arrow_forward_ios;
                  String titleText = '';
                  String subText = '';
                  VoidCallback? onTapAction;

                  if (controller.isProfileLoading.value) {
                    return Positioned(
                      bottom: 0,
                      right: 20,
                      left: 20,
                      child: UShimmerEffect(
                        width: double.infinity,
                        height: size.height * 0.13,
                        text: "Fetching your profile...",
                      ),
                    );
                  }

                  // 1. If KYC hasn't even been started or failed
                  if (!isVerified && !isPending) {
                    bgColor = Ucolors.light;
                    iconColor = Colors.black;
                    titleColor = Ucolors.dark;
                    subTextColor = Colors.grey;
                    leftIcon = Icons.person;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Complete KYC & Profile';
                    subText = 'Verify your Identity to start Investing';
                    onTapAction = () => Get.toNamed(AppRoutes.kycScreen);
                  } else if (noPersonalDetails) {
                    bgColor = Ucolors.blue; // or any color you prefer
                    iconColor = Ucolors.light;
                    titleColor = Ucolors.light;
                    subTextColor = Ucolors.light.withValues(alpha: 0.8);
                    leftIcon = Icons.assignment_ind_rounded;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Complete Profile Details';
                    subText = 'Add your income and family details';
                    onTapAction = () => Get.toNamed(AppRoutes.additionalInfo);
                  }
                  // 2. If Risk Profile is missing (even if KYC is pending)
                  else if (noRiskProfile) {
                    bgColor = Ucolors.blue;
                    iconColor = Ucolors.light;
                    titleColor = Ucolors.light;
                    subTextColor = Ucolors.light.withValues(alpha: 0.8);
                    customLeftIcon = CircleAvatar(
                      backgroundColor: Colors.amber,
                      backgroundImage: AssetImage(UImages.crown),
                      radius: 14,
                    );
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Check Your Risk Profile Now!';
                    subText = 'Discover your investment style';
                    onTapAction = () => Get.toNamed(AppRoutes.riskProfile);
                  }
                  // 3. If Nominee is missing (even if KYC is pending)
                  else if (noNominee) {
                    bgColor = Ucolors.light;
                    iconColor = Ucolors.blue;
                    titleColor = Ucolors.blue;
                    subTextColor = Colors.grey;
                    leftIcon = Icons.family_restroom;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Add a Nominee';
                    subText = 'Secure your investments for your family';
                    onTapAction = () => Get.toNamed(AppRoutes.nomineeDetail);
                  }
                  // 4. If Bank is missing (even if KYC is pending)
                  else if (noBank) {
                    bgColor = Ucolors.primary;
                    iconColor = Ucolors.light;
                    titleColor = Ucolors.light;
                    subTextColor = Ucolors.light.withValues(alpha: 0.8);
                    leftIcon = Icons.account_balance;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Add Bank Account';
                    subText = 'Link your bank for fast transactions';
                    onTapAction = () => Get.toNamed(AppRoutes.addanotherbank);
                  }
                  // 5. If everything else is done, but KYC is STILL pending!
                  else if (isPending && !isVerified) {
                    bgColor = Colors.orange.shade50;
                    iconColor = Colors.orange.shade700;
                    titleColor = Colors.orange.shade900;
                    subTextColor = Colors.orange.shade800;
                    leftIcon = Icons.hourglass_top;
                    customLeftIcon = null;
                    rightIcon = Icons.access_time;
                    titleText = 'KYC in Progress';
                    subText = 'CAMS is reviewing your details ⏳';
                    onTapAction = () => ULoaders.info(
                      title: "Processing",
                      message:
                          "Your KYC is currently under review by CAMS. Please check back shortly.",
                    );
                  } else if (noCan) {
                    bgColor = Colors.purple.shade50;
                    iconColor = Colors.purple.shade700;
                    titleColor = Colors.purple.shade900;
                    subTextColor = Colors.purple.shade800;
                    leftIcon = Icons.app_registration_rounded;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Generate MFU CAN';
                    subText = 'Required to process your mutual fund orders';

                    onTapAction = () {
                      log('Manual CAN generation clicked');
                      Get.find<PersonalisationController>()
                          .checkAndTriggerCanRegistration(
                            isManualTrigger: true,
                          );
                      // controller.checkAndTriggerCanRegistration();
                    };
                  } else if (noMandate) {
                    bgColor = Colors.indigo.shade50;
                    iconColor = Colors.indigo.shade700;
                    titleColor = Colors.indigo.shade900;
                    subTextColor = Colors.indigo.shade800;
                    leftIcon = Icons.account_balance_wallet_rounded;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Setup Bank Mandate (AutoPay)';
                    subText =
                        'Link your bank to enable automatic SIP deductions';
                    onTapAction = () {
                      // Navigate to your Mandate / PaymentScreen
                      // Get.to(() => PaymentScreen());
                      Get.toNamed(AppRoutes.bankDetails);
                    };
                  }
                  // 6. SUCCESS STATE (All Tasks Complete & KYC Verified!)
                  else if (isAllComplete) {
                    bgColor = const Color(0xFFE8F5E9); // Very light green
                    iconColor = const Color(0xFF2E7D32); // Deep premium green
                    titleColor = const Color(0xFF1B5E20);
                    subTextColor = const Color(0xFF388E3C);
                    customLeftIcon = Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        color: iconColor,
                        size: 20,
                      ),
                    );
                    rightIcon = Icons.arrow_forward_rounded;
                    titleText = 'Ready to Invest! 🎉';
                    subText = 'Your profile is 100% complete.';
                    onTapAction = () {
                      navController.changePage(1, isDesktop: false);
                    };
                  } else {
                    return const SizedBox.shrink(); // Fallback
                  }

                  // --- UI RENDER ---
                  return Positioned(
                    left: 20,
                    right: 20,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: onTapAction,
                        child: Container(
                          height: size.height * 0.13,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 5,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                customLeftIcon ??
                                    Icon(leftIcon, size: 24, color: iconColor),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Onboarding task',
                                        style: UTextStyles.medium.copyWith(
                                          // fontSize: 12,
                                          color: subTextColor,
                                        ),
                                      ),
                                      Text(
                                        titleText,
                                        style: UTextStyles.medium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: titleColor,
                                          // fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        subText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: UTextStyles.caption.copyWith(
                                          fontSize: 10,
                                          color: subTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(rightIcon, size: 14, color: iconColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Collection
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SectionHeading(
                sectionTitle: 'Collection',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                mainAxisSpacing: 0,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildListDelegate([
                CollectionItemMob(
                  title: 'Best SIP Funds',
                  iconImg: UImages.savingbank,

                  onTap: () async {
                    // // navController.changePage(1);
                    // Get.find<NavigationBarController>().changePage(1);
                    // Get.find<FundhouseController>().applyBestSipFilter(1);
                    await Future.delayed(const Duration(milliseconds: 100));
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyBestSipFilter(1);
                    });
                  },
                ),
                CollectionItemMob(
                  title: 'High Returns',
                  iconImg: UImages.highreturn,
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyHighReturnFilter();
                    await Future.delayed(const Duration(milliseconds: 100));

                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyHighReturnFilter();
                    });
                  },
                ),
                CollectionItemMob(
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCustomSearch(
                    //   'international',
                    // );
                    await Future.delayed(const Duration(milliseconds: 100));

                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      // funds.applyCustomSearch('international');
                      funds.applyInternationalFilter();
                    });
                  },
                  title: 'International Funds',
                  iconImg: UImages.interfund,
                ),
                CollectionItemMob(
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCustomSearch('index');
                    await Future.delayed(const Duration(milliseconds: 100));

                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCustomSearch('index');
                    });
                  },

                  title: 'Index Funds',
                  iconImg: UImages.indexfund,
                ),
                CollectionItemMob(
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCommodityFilter();
                    await Future.delayed(const Duration(milliseconds: 100));
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCommodityFilter();
                    });
                  },
                  title: 'Commodities',
                  iconImg: UImages.moneygold,
                ),
                CollectionItemMob(
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    Get.toNamed(AppRoutes.nfolist);
                  },
                  title: 'NFO',
                  iconImg: UImages.equity,
                ),
              ]),
            ),
          ),

          // Create Goal Base SIP
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 5, 16, 12),
              child: USectionHeading(
                title: 'Create Goal Base SIP',
                showActionButton: false,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'car', 'isHome': true},
                  ),
                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Car Goal',
                  iconData: Icons.directions_car_filled_rounded,
                ),
                GoalBaseSIPCard(
                  title: 'Education Goal',
                  iconData: Icons.menu_book,
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'education', 'isHome': true},
                  ),
                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'marriage', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Marriage Goal',
                  iconData: Icons.favorite_border_outlined,
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'vacation', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Vacation Goal',
                  iconData: Icons.flight_takeoff_rounded,
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'home', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Home Goal',
                  iconData: Icons.home_rounded,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'other', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Ucolors.borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 20, color: Ucolors.blue),
                        // Container(
                        //   padding: const EdgeInsets.all(8),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFEEF5FF),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: const Icon(
                        //     Icons.add,
                        //     size: 20,
                        //     color: Ucolors.blue,
                        //   ),
                        // ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Custom Goal',
                            style: UTextStyles.small.copyWith(
                              color: Ucolors.dark,
                              fontSize: 11,
                              fontFamily: FontFamily.medium,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // Products & Tool
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: USectionHeading(
                title: 'Products & Tool',
                // buttonTitle: 'See all',
                showActionButton: false,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 5)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                ToolsItem(
                  title: "SIP Calculator",
                  imgUrl: UImages.sipcalci,
                  onTap: () => Get.to(() => const SipCalculatorPage()),
                ),
                ToolsItem(
                  title: "SWP Calculator",
                  imgUrl: UImages.swpcali,
                  onTap: () => Get.to(() => const SwpCalciScreen()),
                ),
                ToolsItem(
                  title: "Step-Up Calculator",
                  imgUrl: UImages.siptopcalci,
                  onTap: () => Get.to(() => const TopUpCalculatorPage()),
                ),
                ToolsItem(
                  title: "Compare Fund",
                  imgUrl: UImages.comparefund,
                  onTap: () => Get.toNamed(AppRoutes.comparefund),
                ),
              ]),
            ),
          ),
          // 1. POPULAR FUNDS SECTION (Horizontal Scroll)
          // ==============================================================
          // 2. POPULAR FUNDS SECTION (Auto-Cycling Groups of 4)
          // ==============================================================
          SliverToBoxAdapter(
            child: Obx(() {
              final popularList = mutualController.searchFund;

              if (popularList.isEmpty) {
                return const SizedBox.shrink();
              }

              // 🚀 1. Calculate the slice of 4 funds based on the timer index
              final currentIndex = mutualController.currentPopularIndex.value;
              final startIndex = currentIndex * 4;

              // Prevent out-of-bounds errors if the list isn't exactly a multiple of 4
              final endIndex = (startIndex + 4 > popularList.length)
                  ? popularList.length
                  : startIndex + 4;

              // The 4 funds currently visible
              final displayedFunds = popularList.sublist(startIndex, endIndex);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: USectionHeading(
                      title: 'Popular Funds',
                      showActionButton: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showPopularFundsSheet(context);
                      },
                    ),
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    key: ValueKey<int>(currentIndex),
                    child: SizedBox(
                      height: 110, // Keep this identical to your card height
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: displayedFunds.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final fund = displayedFunds[index];

                          final rawLogo = fund.amc?.amcLogoUrl ?? '';
                          final img = rawLogo.startsWith('http')
                              ? rawLogo
                              : "${Appurl.baseUrl}$rawLogo";

                          final name = fund.baseSchemeName ?? 'Unknown Name';
                          final threeyear = fund.returnsEntity?.threeYear ?? '';
                          final schemeCode = fund.schemeCode.toString();

                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: PopularFundCardMob(
                              onTap: () {
                                mutualController.addToLocalRecentlyViewed(fund);
                                Get.toNamed(
                                  AppRoutes.funddetails,
                                  arguments: {
                                    'scheme': name,
                                    'imgUrl': img,
                                    'scheme_code': schemeCode,
                                  },
                                );
                              },
                              isNetwork: true,
                              imgPath: img,
                              name: name,
                              threeYear: threeyear,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // SliverToBoxAdapter(
          //   child: Obx(() {
          //     final popularList = mutualController.searchFund;

          //     if (popularList.isEmpty) {
          //       return const SizedBox.shrink();
          //     }

          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          //           child: USectionHeading(
          //             title: 'Popular Funds',
          //             showActionButton: true,
          //             onPressed: () {
          //               FocusScope.of(context).unfocus();
          //               _showPopularFundsSheet(context);
          //             },
          //           ),
          //         ),
          //         SizedBox(
          //           height:
          //               120, // 🚀 Keep this identical to the Recently Viewed height
          //           child: ListView.separated(
          //             padding: const EdgeInsets.symmetric(horizontal: 16),
          //             scrollDirection: Axis.horizontal,
          //             // If you strictly want maximum 2 items in the whole list, use: popularList.length.clamp(0, 2)
          //             itemCount: popularList.length.clamp(0, 4),
          //             separatorBuilder: (context, index) =>
          //                 const SizedBox(width: 16),
          //             itemBuilder: (context, index) {
          //               final fund = popularList[index];

          //               final rawLogo = fund.amc?.amcLogoUrl ?? '';
          //               final img = rawLogo.startsWith('http')
          //                   ? rawLogo
          //                   : "${Appurl.baseUrl}$rawLogo";

          //               final name = fund.baseSchemeName ?? 'Unknown Name';
          //               final threeyear = fund.returnsEntity?.threeYear ?? '';
          //               final schemeCode = fund.schemeCode.toString();

          //               return SizedBox(
          //                 // 🚀 This makes exactly 2 cards fit on the screen at a time
          //                 width: MediaQuery.of(context).size.width * 0.42,
          //                 child: PopularFundCard(
          //                   onTap: () {
          //                     mutualController.addToLocalRecentlyViewed(fund);
          //                     Get.toNamed(
          //                       AppRoutes.funddetails,
          //                       arguments: {
          //                         'scheme': name,
          //                         'imgUrl': img,
          //                         'scheme_code': schemeCode,
          //                       },
          //                     );
          //                   },
          //                   isNetwork: true,
          //                   imgPath: img,
          //                   name: name,
          //                   threeYear: threeyear,
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //       ],
          //     );
          //   }),
          // ),

          // 2. RECENTLY VIEWED SECTION (Horizontal Scroll)
          SliverToBoxAdapter(
            child: Obx(() {
              final recentList = mutualController.recentlyViewedFunds;

              // Hide section entirely if there is no history
              if (recentList.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: USectionHeading(
                      title: 'Recently Viewed',
                      showActionButton: false,
                    ),
                  ),
                  SizedBox(
                    height:
                        110, // 🚀 Adjust this height based on your card's design
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      // If you strictly want maximum 2 items in the whole list, use: recentList.length.clamp(0, 2)
                      itemCount: recentList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final fund = recentList[index];

                        // Safe Image URL handler (fixes the double URL bug we discussed earlier)
                        final rawLogo = fund.amc?.amcLogoUrl ?? '';
                        final img = rawLogo.startsWith('http')
                            ? rawLogo
                            : "${Appurl.baseUrl}$rawLogo";

                        final name = fund.baseSchemeName ?? 'Unknown Name';
                        final threeyear = fund.returnsEntity?.threeYear ?? '';
                        final schemeCode = fund.schemeCode.toString();

                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: PopularFundCardMob(
                            onTap: () {
                              mutualController.addToLocalRecentlyViewed(fund);
                              Get.toNamed(
                                AppRoutes.funddetails,
                                arguments: {
                                  'scheme': name,
                                  'imgUrl': img,
                                  'scheme_code': schemeCode,
                                },
                              );
                            },
                            isNetwork: true,
                            imgPath: img,
                            name: name,
                            threeYear: threeyear,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),

          // Popular Funds
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          //     child: USectionHeading(
          //       title: 'Popular Funds',
          //       showActionButton: true,
          //       // onPressed: () => navController.selectedIndex.value = 1,
          //       // onPressed: () =>
          //       //     navController.navigateToExploreWithFilter(null),
          //       onPressed: () {
          //         FocusScope.of(context).unfocus();
          //         _showPopularFundsSheet(context);
          //       },
          //     ),
          //   ),
          // ),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   sliver: Obx(() {
          //     return SliverGrid.builder(
          //       itemCount: mutualController.searchFund.length.clamp(0, 4),
          //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         childAspectRatio: 1.55,
          //         crossAxisSpacing: 16,
          //         mainAxisSpacing: 16,
          //       ),
          //       itemBuilder: (context, index) {
          //         final fund = mutualController.searchFund[index];
          //         final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          //         final name = fund.baseSchemeName ?? 'Unknown Name';
          //         final threeyear = fund.returnsEntity?.threeYear ?? '';
          //         final schemeCode = fund.schemeCode.toString();
          //         return PopularFundCard(
          //           onTap: () => Get.toNamed(
          //             AppRoutes.funddetails,
          //             arguments: {
          //               'scheme': name,
          //               'imgUrl': img,
          //               'scheme_code': schemeCode,
          //             },
          //           ),
          //           isNetwork: true,
          //           imgPath: img,
          //           name: name,
          //           threeYear: threeyear,
          //         );
          //       },
          //     );
          //   }),
          // ),
          // SliverToBoxAdapter(
          //   child: Obx(() {
          //     // 🚀 Check if they have viewed 4 or more funds
          //     final hasEnoughHistory =
          //         mutualController.recentlyViewedFunds.length >= 4;

          //     return Padding(
          //       padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          //       child: USectionHeading(
          //         title: hasEnoughHistory ? 'Recently Viewed' : 'Popular Funds',
          //         // Only show the Action button for Popular Funds (optional)
          //         showActionButton: !hasEnoughHistory,
          //         onPressed: () {
          //           FocusScope.of(context).unfocus();
          //           _showPopularFundsSheet(context);
          //         },
          //       ),
          //     );
          //   }),
          // ),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   sliver: Obx(() {
          //     final hasEnoughHistory =
          //         mutualController.recentlyViewedFunds.length >= 4;

          //     // 🚀 Swap the data source based on history length
          //     final displayList = hasEnoughHistory
          //         ? mutualController.recentlyViewedFunds
          //         : mutualController.searchFund;

          //     if (displayList.isEmpty) {
          //       return const SliverToBoxAdapter(child: SizedBox.shrink());
          //     }

          //     return SliverGrid.builder(
          //       itemCount: displayList.length.clamp(0, 4),
          //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         childAspectRatio: 1.55,
          //         crossAxisSpacing: 16,
          //         mainAxisSpacing: 16,
          //       ),
          //       itemBuilder: (context, index) {
          //         final fund = displayList[index];
          //         final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          //         final name = fund.baseSchemeName ?? 'Unknown Name';
          //         final threeyear = fund.returnsEntity?.threeYear ?? '';
          //         final schemeCode = fund.schemeCode.toString();

          //         return PopularFundCard(
          //           onTap: () {
          //             // 🚀 Track this fund when tapped!
          //             // mutualController.addToRecentlyViewed(fund);
          //             mutualController.addToLocalRecentlyViewed(fund);

          //             Get.toNamed(
          //               AppRoutes.funddetails,
          //               arguments: {
          //                 'scheme': name,
          //                 'imgUrl': img,
          //                 'scheme_code': schemeCode,
          //               },
          //             );
          //           },
          //           isNetwork: true,
          //           imgPath: img,
          //           name: name,
          //           threeYear: threeyear,
          //         );
          //       },
          //     );
          //   }),
          // ),

          // Videos
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: USectionHeading(
                title: 'Video’s & Blogs',
                // showActionButton: true,
                buttonTitle: 'See all',
                onPressed: () => Get.toNamed(AppRoutes.videoList),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     // height: size.height * 0.25,
          //     height: 220,
          //     child: ListView(
          //       scrollDirection: Axis.horizontal,
          //       padding: const EdgeInsets.symmetric(horizontal: 16),
          //       children: const [
          //         InlineYouTubePlayer(
          //           thumbnailUrl:
          //               "https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg",
          //           videoId: "yo5aL4Plbso",
          //         ),
          //         // YoutubeThumbnail(videoId: 'yo5aL4Plbso'),
          //         SizedBox(width: 16),
          //         InlineYouTubePlayer(
          //           thumbnailUrl:
          //               "https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg",
          //           videoId: "t7lUSiddFd4",
          //         ),

          //         // YoutubeThumbnail(videoId: 't7lUSiddFd4'),
          //         SizedBox(width: 16),
          //       ],
          //     ),
          //   ),
          // ),
          // const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24, right: 12),
                physics: const BouncingScrollPhysics(),
                children: const [
                  ClickableYoutubeThumbnail(
                    videoUrl:
                        "https://youtu.be/2B8b2E9JPzk?si=69cT1kC-Er_TNNCB",
                  ),
                  SizedBox(width: 8),
                  ClickableYoutubeThumbnail(
                    videoUrl:
                        "https://youtu.be/xuVUGgB3kGE?si=0Kje6W2zqSxEtUuu",
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _showPopularFundsSheet(BuildContext context) {
    final mutualController = Get.find<MutualFundController>();
    final FocusNode searchFocus = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore Funds",
                            style: AppTextStyles.h2(color: Ucolors.dark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Search and discover mutual funds.",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: FontFamily.medium,

                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        final fundController = Get.find<FundhouseController>();
                        final int filterCount =
                            fundController.activeFilterCount;

                        return Badge(
                          isLabelVisible: filterCount > 0,
                          backgroundColor: Ucolors.primary,
                          label: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: FontFamily.medium,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: const Alignment(0.7, -0.7),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                            ),
                            child: CompactIcon(
                              icon: Icons.tune,
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  AppRoutes.filterpage,
                                );
                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  mutualController.applyFilters(result);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: Obx(() {
                            final bool isSearching =
                                mutualController.hasSearchFocus.value;

                            return Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onTap: () =>
                                        mutualController.setSearchFocus(true),
                                    onTapOutside: (event) {
                                      searchFocus.unfocus();
                                      mutualController.setSearchFocus(false);
                                    },
                                    focusNode: searchFocus,
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    leading: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Search mutual funds...',
                                    hintStyle: WidgetStateProperty.all(
                                      TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 15,
                                        fontFamily: FontFamily.medium,
                                      ),
                                    ),
                                    onChanged: (value) => mutualController
                                        .onSearchQueryChanged(value),
                                    elevation: WidgetStateProperty.all(0),
                                    side: WidgetStateProperty.all(
                                      BorderSide(color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                                if (!isSearching) ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () =>
                                        mutualController.cycleGlobalSort(),
                                    borderRadius: BorderRadius.circular(14),
                                    child: FilterChip(
                                      label: mutualController
                                          .currentSortLabel
                                          .value,
                                      icon: Icons.sort,
                                      isSelected:
                                          mutualController
                                              .currentSortLabel
                                              .value !=
                                          "1Y,3Y,5Y",
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade200, height: 20),

                Expanded(
                  child: Obx(() {
                    if (mutualController.isLoading.value) {
                      return const Align(
                        alignment: Alignment.topCenter,

                        child: CircularProgressIndicator(
                          color: Ucolors.primary,
                        ),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // Check if we scrolled near the bottom (within 200 pixels)
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          // Prevent spamming the API if it's already loading or has no more data
                          if (!mutualController.isMoreLoading.value &&
                              mutualController.canLoadMore) {
                            mutualController
                                .loadNextPage(); // Triggers your pagination API!
                          }
                        }
                        return false; // Return false so the sheet can still drag up/down normally
                      },

                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount:
                            mutualController.searchFund.length +
                            (mutualController.isMoreLoading.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == mutualController.searchFund.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Ucolors.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final fund = mutualController.searchFund[index];
                          // return ModernStaggeredItem(
                          //   index: index,
                          //   child: MutualFundCard(entity: fund),
                          // );

                          return MutualFundCard(entity: fund);
                        },
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
      // ).whenComplete(() {
      //   mutualController.setSearchFocus(false);

      //   mutualController.handleRefresh();
      // });
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        mutualController.setSearchFocus(false);

        Get.find<FundhouseController>().clearAllFilters();

        mutualController.silentReset();
      });
    });
  }
}

class YoutubeThumbnail extends StatelessWidget {
  const YoutubeThumbnail({
    super.key,
    required this.videoId,
    this.width = 300, // Default width
    this.height = 190,
    this.borderRadius = 16,
    this.onTap,
  });

  final String videoId;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // On mobile, use percentage width. On desktop, use fixed width.
    final displayWidth = isDesktop
        ? width
        : MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: displayWidth,
        height: height, // Use height parameter
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.error, color: Colors.white54),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xfff44336),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularFundCard extends StatefulWidget {
  const PopularFundCard({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;

  @override
  State<PopularFundCard> createState() => _PopularFundCardState();
}

class _PopularFundCardState extends State<PopularFundCard> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// RESPONSIVE
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;
    final bool isWeb = width >= 1100;

    final double logoSize = isMobile
        ? 38
        : isTablet
        ? 42
        : 48;

    final double titleSize = isMobile
        ? 12
        : isTablet
        ? 13
        : 14;

    final double cardPadding = isMobile ? 12 : 16;

    final double borderRadius = isMobile ? 16 : 20;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        scale: isPressed
            ? 0.98
            : isHovered
            ? 1.01
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),

            splashColor: Ucolors.primary.withValues(alpha: 0.08),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,

            onTapDown: (_) => _setPressed(true),

            onTapCancel: () => _setPressed(false),

            onTap: () async {
              _setPressed(true);

              await Future.delayed(const Duration(milliseconds: 90));

              _setPressed(false);

              widget.onTap?.call();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),

                /// BORDER
                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.18)
                      : Colors.grey.shade200,
                ),

                /// SHADOW
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? Ucolors.primary.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LOGO
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: logoSize,
                          width: logoSize,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? Ucolors.primary.withValues(alpha: 0.06)
                                : Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: widget.isNetwork
                              ? CustomCachedImage(
                                  imageUrl: widget.imgPath,
                                  size: logoSize,
                                )
                              : Image.asset(
                                  widget.imgPath,
                                  fit: BoxFit.contain,
                                ),
                        ),

                        SizedBox(width: isMobile ? 10 : 14),

                        /// TITLE
                        Expanded(
                          child: Text(
                            widget.name,
                            maxLines: isMobile ? 3 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: titleSize,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: isHovered
                                  ? Ucolors.primary
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 10 : 14),

                  /// BOTTOM
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// LABEL
                        Text(
                          '3Y Return',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.medium,
                          ),
                        ),

                        /// VALUE
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Ucolors.success.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Ucolors.success,
                                size: 14,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Text(
                              '${widget.threeYear ?? '--'}%',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 15,
                                fontWeight: FontWeight.bold,
                                color: Ucolors.success,
                                fontFamily: FontFamily.medium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopularFundCardMob extends StatelessWidget {
  const PopularFundCardMob({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(color: borderColor),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withValues(alpha:0.04),
        //       blurRadius: 10,
        //       offset: const Offset(0, 3),
        //     ),
        //   ],
        // ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.grey.shade50,
                        child: isNetwork
                            ? CustomCachedImage(imageUrl: imgPath, size: 40)
                            : Image.asset(imgPath, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: UTextStyles.medium.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3Y',
                    style: UTextStyles.bodySmallW500.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_drop_up_rounded,
                        color: Ucolors.success,
                        size: 20,
                      ),
                      Text(
                        '${threeYear}%',
                        style: UTextStyles.bodySmallW500.copyWith(
                          color: Ucolors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalBaseSIPCard extends StatelessWidget {
  const GoalBaseSIPCard({
    super.key,
    required this.title,
    required this.iconData,
    this.onTap,
  });
  final String title;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Ucolors.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(iconData, size: 20, color: Ucolors.blue),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFEEF5FF),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Icon(iconData, size: 20, color: Ucolors.blue),
              // ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: UTextStyles.small.copyWith(
                    color: Ucolors.dark,
                    fontSize: 11,
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolsItem extends StatelessWidget {
  const ToolsItem({
    super.key,
    required this.title,
    required this.imgUrl,
    this.onTap,
  });
  final String title;
  final String imgUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isDesktop ? 35 : 45,
            width: isDesktop ? 35 : 45,
            child: Image.asset(imgUrl),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              title,
              style: UTextStyles.medium.copyWith(
                color: Ucolors.secondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionItemMob extends StatefulWidget {
  final String iconImg;
  final String title;
  final VoidCallback? onTap;

  const CollectionItemMob({
    super.key, // Use super parameters for cleaner code
    required this.iconImg,
    required this.title,
    this.onTap,
  });

  @override
  State<CollectionItemMob> createState() => _CollectionItemMobState();
}

class _CollectionItemMobState extends State<CollectionItemMob> {
  double scale = 1.0;
  bool isPressed = false;

  // Helper to handle the animation state
  void _updateState(bool pressed) {
    setState(() {
      isPressed = pressed;
      scale = pressed ? 0.92 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isPressed
              ? RadialGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                )
              : null,
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.blue.withValues(alpha: 0.2),
            highlightColor: Colors
                .transparent, // Hide default highlight to see your custom animation
            // Trigger animation on press
            onTapDown: (_) => _updateState(true),
            onTapCancel: () => _updateState(false),

            onTap: () async {
              // 1. Brief delay to let the user see the "pressed" state
              _updateState(true);
              await Future.delayed(const Duration(milliseconds: 100));

              // 2. Reset state
              _updateState(false);

              // 3. Execute navigation
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(widget.iconImg, height: 48, width: 48),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.1,
                      fontFamily: FontFamily.medium,
                      // fontWeight: FontWeight.w500,
                      color: Color(0xff2A7BBF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WebActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const WebActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  State<WebActionCard> createState() => _WebActionCardState();
}

class _WebActionCardState extends State<WebActionCard> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// RESPONSIVE
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;

    final double cardHeight = isMobile
        ? 150
        : isTablet
        ? 165
        : 190;

    final double iconBoxSize = isMobile
        ? 48
        : isTablet
        ? 54
        : 60;

    final double iconSize = isMobile
        ? 22
        : isTablet
        ? 26
        : 30;

    final double titleFontSize = isMobile
        ? 14
        : isTablet
        ? 15
        : 16;

    final double subtitleFontSize = isMobile
        ? 10
        : isTablet
        ? 11
        : 12;

    final double padding = isMobile ? 14 : 18;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        scale: isPressed
            ? 0.97
            : isHovered
            ? 1.02
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: widget.color.withValues(alpha: 0.08),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,

            onTapDown: (_) => _setPressed(true),

            onTapCancel: () => _setPressed(false),

            onTap: () async {
              _setPressed(true);

              await Future.delayed(const Duration(milliseconds: 90));

              _setPressed(false);

              widget.onTap?.call();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: cardHeight,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                /// BACKGROUND
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Colors.white, widget.color.withValues(alpha: 0.06)]
                      : [
                          widget.color.withValues(alpha: 0.08),
                          widget.color.withValues(alpha: 0.03),
                        ],
                ),

                /// BORDER
                border: Border.all(
                  color: isHovered
                      ? widget.color.withValues(alpha: 0.18)
                      : widget.color.withValues(alpha: 0.10),
                ),

                /// SHADOW
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? widget.color.withValues(alpha: 0.14)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ICON BOX
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: iconBoxSize,
                        width: iconBoxSize,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.color,
                              widget.color.withValues(alpha: 0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withValues(
                                alpha: isHovered ? 0.28 : 0.16,
                              ),
                              blurRadius: isHovered ? 18 : 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),

                      AnimatedRotation(
                        turns: isHovered ? 0.08 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: iconSize - 6,
                          color: isHovered
                              ? widget.color
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// TITLE
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.medium,
                      height: 1.3,
                      color: isHovered ? widget.color : const Color(0xff1E293B),
                    ),
                  ),

                  SizedBox(height: isMobile ? 6 : 8),

                  /// SUBTITLE
                  Text(
                    widget.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      height: 1.5,
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CollectionItem extends StatefulWidget {
  final String iconImg;
  final String title;
  final VoidCallback? onTap;

  const CollectionItem({
    super.key,
    required this.iconImg,
    required this.title,
    this.onTap,
  });

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  double scale = 1.0;
  bool isPressed = false;
  bool isHovered = false;

  void _updatePressed(bool value) {
    setState(() {
      isPressed = value;
      scale = value ? 0.96 : 1.0;
    });
  }

  void _updateHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// We use the available width provided by the parent
        final double maxWidth = constraints.maxWidth;

        final bool isSmall = maxWidth < 160;
        final bool isLarge = maxWidth > 300;

        /// Scaling logic based on local constraints
        final double iconSize = isSmall ? 32 : (isLarge ? 60 : 48);
        final double fontSize = isSmall ? 10 : (isLarge ? 18 : 13);
        final double containerPadding = isSmall ? 8 : 14;
        final double borderRadius = isSmall ? 12 : 18;
        final double iconBoxSize = isSmall ? 54 : (isLarge ? 74 : 64);

        return MouseRegion(
          onEnter: (_) => _updateHover(true),
          onExit: (_) => _updateHover(false),
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Colors.white, Ucolors.primary.withValues(alpha: 0.04)]
                      : [Colors.grey.shade50, Colors.grey.shade200],
                ),
                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.18)
                      : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? Ucolors.primary.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  splashColor: Ucolors.primary.withValues(alpha: 0.10),
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTapDown: (_) => _updatePressed(true),
                  onTapCancel: () => _updatePressed(false),
                  onTap: () async {
                    _updatePressed(true);
                    await Future.delayed(const Duration(milliseconds: 90));
                    _updatePressed(false);
                    widget.onTap?.call();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(containerPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Hug content
                      children: [
                        /// ICON CONTAINER
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: iconBoxSize,
                          width: iconBoxSize,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? Ucolors.primary.withValues(alpha: 0.08)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Image.asset(
                            widget.iconImg,
                            height: iconSize,
                            width: iconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: isSmall ? 6 : 12),

                        /// TITLE
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize,
                            height: 1.2,
                            fontFamily: FontFamily.medium,
                            fontWeight: FontWeight.w600,
                            color: isHovered
                                ? Ucolors.primary
                                : const Color(0xff2A2A2A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  const FilterChip({required this.label, this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Ucolors.textFormEnabled : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureSection extends StatelessWidget {
  const FeatureSection({
    super.key,
    required this.featureName,
    required this.iconPath,
  });
  final String featureName;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Ucolors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          featureName,
          style: UTextStyles.medium.copyWith(
            color: Ucolors.light,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
