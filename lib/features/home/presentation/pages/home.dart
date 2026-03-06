import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
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
import 'package:my_sip/features/home/presentation/widgets/product_tool/top_up_calculator.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/sip_process/presentation/controllers/sip_process_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive Framework

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

// ==========================================
// 💻 WEB DASHBOARD LAYOUT
// ==========================================
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
    return Column(
      children: [
        _buildWebHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: MaxWidthBox(
                maxWidth: 1200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- LEFT COLUMN ---
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeroBanner(),
                                const Gap(30),
                                const Text(
                                  "Quick Actions",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(16),
                                _buildQuickActionsCard(),
                                const Gap(30),
                                const Text(
                                  "Explore Categories",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(16),
                                _buildWebCollectionGrid(),
                                const Gap(30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Popular Funds",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text("View All"),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                _buildWebFundGrid(),
                                const Gap(30),
                              ],
                            ),
                          ),
                          const Gap(30),
                          // --- RIGHT COLUMN ---
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                _buildWebGoalSection(),
                                const Gap(24),
                                _buildWebToolsSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Learn & Grow",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Gap(16),

                      _buildWebVideoRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ... (Header and Banner widgets remain similar, add hover to icons if desired)
  Widget _buildWebHeader() {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.notification),
                hoverColor: Ucolors.primary.withOpacity(0.1),
              ),
              const Gap(10),
              Obx(
                () => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.shopping_cart),
                      onPressed: () {
                        Get.find<CartController>().filterGoalId.value = null;
                        Get.toNamed(
                          AppRoutes.cart,
                          // arguments: {'goal_id': null},
                        );
                      },
                      hoverColor: Ucolors.primary.withOpacity(0.1),
                    ),
                    if (cartController.itemsCount > 0)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Ucolors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartController.itemsCount.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(10),
              CompactIcon(
                icon: Iconsax.archive_tick,
                onPressed: () => Get.toNamed(AppRoutes.watchlist),
                iconColor: Ucolors.dark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return WebHoverScale(
      scale: 1.02, // Subtle scale for the big banner
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF07315C), Color(0xff0280C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Ucolors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white30),
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
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _WebQuickActionItem(
            "Start SIP",
            UImages.startsip,
            () => Get.toNamed(AppRoutes.startSipScreen),
          ),
          const Gap(40),
          // _WebQuickActionItem("Freedom SIP", UImages.freedomsip, () => Get.toNamed(AppRoutes.startSipScreen)),
          const Gap(40),
          _WebQuickActionItem(
            "Lumpsum",
            UImages.glyph,
            () => Get.toNamed(AppRoutes.startSipScreen),
          ),
        ],
      ),
    );
  }

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
          () => funds.applyCustomSearch('international'),
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
        't': 'NFO', 'i': UImages.equity,
        'onTap': () => Get.toNamed(AppRoutes.nfolist), // <--- NFO ROUTE FIXED
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) => WebHoverScale(
        scale: 1.1, // Higher scale for small icons
        // onTap: () => Get.to(() => ExploreScreen()),
        onTap: items[i]['onTap'] as VoidCallback,
        child: CollectionItem(
          title: items[i]['t']! as String,
          iconImg: items[i]['i']! as String,
        ),
      ),
    );
  }

  Widget _buildWebFundGrid() {
    return Obx(() {
      final funds = mutualController.searchFund;
      final int count = funds.length > 8 ? 8 : funds.length;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final fund = funds[index];
          final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          final name = fund.baseSchemeName ?? 'Unknown Name';
          final schemeCode = fund.schemeCode.toString();

          // Wrap Fund Card with Hover Scale
          return WebHoverScale(
            child: PopularFundCard(
              isNetwork: true,
              imgPath: img,
              name: name,
              onTap: () => Get.toNamed(
                AppRoutes.funddetails,
                arguments: {
                  'scheme': name,
                  'imgUrl': img,
                  'scheme_code': schemeCode,
                },
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildWebGoalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plan Your Goals",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Gap(16),
          _WebGoalTile("Car Goal", Icons.directions_car_filled_rounded, 'car'),
          const Gap(10),
          _WebGoalTile(
            "Marriage Goal",
            Icons.favorite_border_outlined,
            'marriage',
          ),
          const Gap(10),
          _WebGoalTile("Home Goal", Icons.home_rounded, 'home'),
          const Gap(10),
          _WebGoalTile(
            "Vacation Goal",
            Icons.flight_takeoff_rounded,
            'vacation',
          ),
        ],
      ),
    );
  }

  Widget _buildWebToolsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Financial Tools",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Gap(16),
          // Wrap Tools in HoverTile logic for background change
          _buildToolItem(
            "SIP Calculator",
            UImages.sipcalci,
            () => Get.to(() => const SipCalculatorPage()),
          ),
          const Gap(8),
          _buildToolItem(
            "SWP Calculator",
            UImages.swpcali,
            () => Get.to(() => const SwpCalciScreen()),
          ),
          const Gap(8),
          _buildToolItem(
            "Step-Up Calculator",
            UImages.siptopcalci,
            () => Get.to(() => const TopUpCalculatorPage()),
          ),
          const Gap(8),
          _buildToolItem(
            "Compare Fund",
            UImages.comparefund,
            () => Get.toNamed(AppRoutes.comparefund),
          ),
        ],
      ),
    );
  }

  // Custom builder for Tool Items with Hover
  Widget _buildToolItem(String title, String img, VoidCallback onTap) {
    return WebHoverTile(
      onTap: onTap,
      builder: (isHovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isHovered
              ? Ucolors.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(height: 30, width: 30, child: Image.asset(img)),
            const Gap(15),
            Text(
              title,
              style: TextStyle(
                color: isHovered ? Ucolors.primary : Colors.grey[700],
                fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebVideoRow() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          WebHoverScale(
            child: InlineYouTubePlayer(
              thumbnailUrl:
                  "https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg",
              videoId: "yo5aL4Plbso",
            ),
          ),
          SizedBox(width: 20),
          WebHoverScale(
            child: InlineYouTubePlayer(
              thumbnailUrl:
                  "https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg",
              videoId: "t7lUSiddFd4",
            ),
          ),
        ],
      ),
    );
  }
}

class _WebQuickActionItem extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;
  const _WebQuickActionItem(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    // Use WebHoverScale for the "Pop" effect
    return WebHoverScale(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Ucolors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Ucolors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SvgPicture.asset(icon, width: 28, height: 28),
          ),
          const Gap(10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
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
      onTap: () =>
          Get.toNamed(AppRoutes.ihavegoal, arguments: {'goalType': type}),
      builder: (isHovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHovered
              ? Ucolors.blue.withOpacity(0.05)
              : Colors.transparent,
          border: Border.all(
            color: isHovered ? Ucolors.blue : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Ucolors.blue, size: 20),
            const Gap(12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
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
    log(user?.img ?? 'image ------------------');

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
                    onProfiletap: () => navController.changePage(4),
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
                      //         hoverColor: Ucolors.primary.withOpacity(0.1),
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
                            Get.find<SipProcessController>().setInvestmentMode(
                              false,
                            );
                            Get.toNamed(AppRoutes.startSipScreen);
                          },
                          child: const FeatureSection(
                            featureName: 'Start SIP',
                            iconPath: UImages.startsip,
                          ),
                        ),
                        // GestureDetector(
                        //     onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                        //     child: const FeatureSection(featureName: 'Freedom SIP', iconPath: UImages.freedomsip)),
                        GestureDetector(
                          // onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                          onTap: () {
                            Get.find<SipProcessController>().setInvestmentMode(
                              true,
                            );
                            Get.toNamed(AppRoutes.startSipScreen);
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
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.kycScreen),
                      child: Container(
                        height: size.height * 0.13,
                        decoration: BoxDecoration(
                          color: Ucolors.light,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
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
                              const Icon(Icons.person, size: 24),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Onboarding task',
                                      style: UTextStyles.caption.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Complete KYC & Profile',
                                      style: UTextStyles.medium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Ucolors.dark,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Verify your Identity to start Investing',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: UTextStyles.caption.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Collection
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SectionHeading(
                sectionTitle: 'Collection',
                fontWeight: FontWeight.w500,
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
                CollectionItem(
                  title: 'Best SIP Funds',
                  iconImg: UImages.savingbank,

                  onTap: () {
                    // // navController.changePage(1);
                    // Get.find<NavigationBarController>().changePage(1);
                    // Get.find<FundhouseController>().applyBestSipFilter(1);
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyBestSipFilter(1);
                    });
                  },
                ),
                CollectionItem(
                  title: 'High Returns',
                  iconImg: UImages.highreturn,
                  onTap: () {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyHighReturnFilter();
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyHighReturnFilter();
                    });
                  },
                ),
                CollectionItem(
                  onTap: () {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCustomSearch(
                    //   'international',
                    // );
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCustomSearch('international');
                    });
                  },
                  title: 'International Funds',
                  iconImg: UImages.interfund,
                ),
                CollectionItem(
                  onTap: () {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCustomSearch('index');
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCustomSearch('index');
                    });
                  },

                  title: 'Index Funds',
                  iconImg: UImages.indexfund,
                ),
                CollectionItem(
                  onTap: () {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCommodityFilter();
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCommodityFilter();
                    });
                  },
                  title: 'Commodities',
                  iconImg: UImages.moneygold,
                ),
                CollectionItem(
                  onTap: () => Get.toNamed(AppRoutes.nfolist),
                  title: 'NFO',
                  iconImg: UImages.equity,
                ),
              ]),
            ),
          ),

          // Create Goal Base SIP
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
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
                    AppRoutes.ihavegoal,
                    arguments: {'goalType': 'car'},
                  ),
                  title: 'Car Goal',
                  iconData: Icons.directions_car_filled_rounded,
                ),
                GoalBaseSIPCard(
                  title: 'Bike Goal',
                  iconData: Icons.pedal_bike_rounded,
                  onTap: () => Get.toNamed(
                    AppRoutes.ihavegoal,
                    arguments: {'goalType': 'bike'},
                  ),
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.ihavegoal,
                    arguments: {'goalType': 'marriage'},
                  ),
                  title: 'Marriage Goal',
                  iconData: Icons.favorite_border_outlined,
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.ihavegoal,
                    arguments: {'goalType': 'vacation'},
                  ),
                  title: 'Vacation Goal',
                  iconData: Icons.flight_takeoff_rounded,
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.ihavegoal,
                    arguments: {'goalType': 'home'},
                  ),
                  title: 'Home Goal',
                  iconData: Icons.home_rounded,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.ihavegoal),
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
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF5FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Ucolors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Custom Goal',
                            style: UTextStyles.small.copyWith(
                              color: Ucolors.dark,
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

          // Popular Funds
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: USectionHeading(
                title: 'Popular Funds',
                showActionButton: true,
                // onPressed: () => navController.selectedIndex.value = 1,
                onPressed: () =>
                    navController.navigateToExploreWithFilter(null),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Obx(() {
              return SliverGrid.builder(
                itemCount: mutualController.searchFund.length.clamp(0, 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.55,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final fund = mutualController.searchFund[index];
                  final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
                  final name = fund.baseSchemeName ?? 'Unknown Name';
                  final threeyear = fund.returnsEntity?.threeYear ?? '';
                  final schemeCode = fund.schemeCode.toString();
                  return PopularFundCard(
                    onTap: () => Get.toNamed(
                      AppRoutes.funddetails,
                      arguments: {
                        'scheme': name,
                        'imgUrl': img,
                        'scheme_code': schemeCode,
                      },
                    ),
                    isNetwork: true,
                    imgPath: img,
                    name: name,
                    threeYear: threeyear,
                  );
                },
              );
            }),
          ),

          // Videos
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: USectionHeading(
                title: 'Video’s & Blogs',
                showActionButton: true,
                buttonTitle: 'See all',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              // height: size.height * 0.25,
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  InlineYouTubePlayer(
                    thumbnailUrl:
                        "https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg",
                    videoId: "yo5aL4Plbso",
                  ),
                  // YoutubeThumbnail(videoId: 'yo5aL4Plbso'),
                  SizedBox(width: 16),
                  InlineYouTubePlayer(
                    thumbnailUrl:
                        "https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg",
                    videoId: "t7lUSiddFd4",
                  ),

                  // YoutubeThumbnail(videoId: 't7lUSiddFd4'),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
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
              color: Colors.black.withOpacity(0.12),
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
                    colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
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
                        color: Colors.red.withOpacity(0.5),
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

class PopularFundCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        color: Colors.grey.shade50,
                        child: isNetwork
                            ? CustomCachedImage(imageUrl: imgPath, size: 40)
                            : Image.asset(imgPath, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: UTextStyles.medium.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.2,
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
                    style: UTextStyles.caption.copyWith(
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
                        style: UTextStyles.caption.copyWith(
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Ucolors.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF5FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(iconData, size: 20, color: Ucolors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: UTextStyles.small.copyWith(
                    color: Ucolors.dark,
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
              style: UTextStyles.small.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionItem extends StatelessWidget {
  const CollectionItem({
    super.key,
    required this.title,
    required this.iconImg,
    this.onTap,
  });
  final String title;
  final String iconImg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 45,
            width: 45,
            child: Image.asset(iconImg, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: UTextStyles.small.copyWith(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
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
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
