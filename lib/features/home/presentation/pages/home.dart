import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/video/custom_inline_youtube_player.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/top_up_calculator.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive Framework

import '../widgets/product_tool/sip_calculator.dart';
import '../widgets/product_tool/swp_calci.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cartController = Get.find<CartController>();
  final mutualcontroller = Get.find<MutualFundController>();
  final navigation = Get.find<NavigationBarController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authController = Get.find<AuthController>();

    // Check Breakpoints
    final bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final bool isTablet = ResponsiveBreakpoints.of(context).isTablet;

    // Define Grid Counts based on screen size
    final int collectionGridCount = isDesktop ? 6 : (isTablet ? 4 : 3);
    final int goalGridCount = isDesktop ? 4 : (isTablet ? 3 : 2);
    final int toolsGridCount = isDesktop ? 4 : (isTablet ? 3 : 2);
    final int popularGridCount = isDesktop ? 5 : (isTablet ? 3 : 2);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            //Appbar
            SliverAppBar(
              pinned: true,
              snap: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              expandedHeight: isDesktop ? 100 : kToolbarHeight, // Taller on desktop if needed
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
                  child: Center( // Center content on desktop for better look
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: CustomProfileAppbar(
                        onProfiletap: () => navigation.selectedIndex.value = 4,
                        backgroundColor: Colors.transparent,
                        greetingName: authController.user.value?.name ?? '',
                        role: UHelperFunction.getGreetingMsg(),
                        iconColor: Ucolors.light,
                        roleColor: Ucolors.borderColor,
                        greetingNameColor: Ucolors.light,
                        avatar: AssetImage(UImages.avatar),
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
                                  onPressed: () => Get.toNamed(AppRoutes.cart),
                                  iconColor: Ucolors.light,
                                ),
                                if (cartController.itemsCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: -5,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Ucolors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        cartController.itemsCount.toString(),
                                        style: UTextStyles.buttonText.copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          CompactIcon(
                            icon: Iconsax.archive_tick,
                            onPressed: () => Get.toNamed(AppRoutes.watchlist),
                            iconColor: Ucolors.light,
                          ),
                        ],
                        actionsPadding: EdgeInsets.only(right: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Header Section --KYC and ,start sip , freedom sip , lumpsum
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    // Increase height on desktop to accommodate larger icons
                    height: isDesktop ? size.height * 0.4 : size.height * 0.3,
                  ),
                  Container(
                    height: isDesktop ? size.height * 0.28 : size.height * 0.21,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-0.8, -1.0),
                        end: Alignment(0.1, 1.0),
                        stops: const [0.0, 0.9784],
                        colors: [
                          const Color(0xFF07315C),
                          const Color(0xFF0280C0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.startSipScreen);
                              },
                              child: FeatureSection(
                                featureName: 'Start SIP',
                                iconPath: UImages.startsip,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutes.startSipScreen);
                              },
                              child: FeatureSection(
                                featureName: 'Freedom SIP',
                                iconPath: UImages.freedomsip,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                              child: FeatureSection(
                                featureName: 'Lumpsum',
                                iconPath: UImages.glyph,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 0,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: isDesktop ? 600 : double.infinity
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.kycScreen);
                          },
                          child: Container(
                            height: isDesktop ? 140 : size.height * 0.13,
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
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Row( // Changed Column to Row for better stability
                                children: [
                                  Icon(Icons.person, size: isDesktop ? 30 : 24),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Onboarding task',
                                          style: UTextStyles.caption.copyWith(
                                              fontSize: isDesktop ? 14 : 12
                                          ),
                                        ),
                                        Text(
                                          'Complete KYC & Profile',
                                          style: UTextStyles.medium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Ucolors.dark,
                                              fontSize: isDesktop ? 18 : 14
                                          ),
                                        ),
                                        Text(
                                          'Verify your Identity to start Investing',
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: UTextStyles.caption.copyWith(
                                              fontSize: isDesktop ? 14 : 10
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: isDesktop ? 16 : 12),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ///-------------Collection Part ---------------///
            SliverToBoxAdapter(
              child: Padding(
                padding: isDesktop ? EdgeInsets.all(10) : const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const SectionHeading(
                  sectionTitle: 'Collection',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: collectionGridCount,
                  childAspectRatio: isDesktop ? 1.3 : 1.1, // Adjusted aspect ratio for desktop
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 12,
                ),
                delegate: SliverChildListDelegate([
                  CollectionItem(
                    title: 'Best SIP Funds',
                    iconImg: UImages.savingbank,
                    onTap: () => Get.to(() => ExploreScreen()),
                  ),
                  CollectionItem(
                    title: 'High Returns',
                    iconImg: UImages.highreturn,
                    onTap: () => Get.to(() => ExploreScreen()),
                  ),
                  CollectionItem(
                    onTap: () => Get.to(() => ExploreScreen()),
                    title: 'International Funds',
                    iconImg: UImages.interfund,
                  ),
                  CollectionItem(
                    onTap: () => Get.to(() => ExploreScreen()),
                    title: 'Index Funds',
                    iconImg: UImages.indexfund,
                  ),
                  CollectionItem(
                    onTap: () => Get.to(() => ExploreScreen()),
                    title: 'Commodities',
                    iconImg: UImages.moneygold,
                  ),
                  CollectionItem(
                    onTap: () => Get.to(() => ExploreScreen()),
                    title: 'Equity',
                    iconImg: UImages.equity,
                  ),
                ]),
              ),
            ),

            ///-------------Create Goal Base SIP Part ---------------///
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: const USectionHeading(
                  title: 'Create Goal Base SIP',
                  showActionButton: false,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: goalGridCount,
                  childAspectRatio: isDesktop ? 3.5 : 2.8,
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
                    onTap: () => Get.toNamed(
                      AppRoutes.ihavegoal,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Ucolors.borderColor,
                          width: 1,
                        ),
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
                            child: Icon(
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

            ///-------------Products & Tool Part ---------------///
            SliverToBoxAdapter(
              child: Padding(
                padding: isDesktop ? EdgeInsets.all(10) : const EdgeInsets.fromLTRB(16, 20, 16, 0),                child: USectionHeading(
                  title: 'Products & Tool',
                  buttonTitle: 'See all',
                  showActionButton: true,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: toolsGridCount,
                  childAspectRatio: isDesktop ? 3.5 : 3.2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  ToolsItem(
                    title: "SIP Calculator",
                    imgUrl: UImages.sipcalci,
                    onTap: () => Get.to(() => SipCalculatorPage()),
                  ),
                  ToolsItem(
                    title: "SWP Calculator",
                    imgUrl: UImages.swpcali,
                    onTap: () => Get.to(() => SwpCalciScreen()),
                  ),
                  ToolsItem(
                    title: "Step-Up Calculator",
                    imgUrl: UImages.siptopcalci,
                    onTap: () => Get.to(() => TopUpCalculatorPage()),
                  ),
                  ToolsItem(
                    title: "Compare Fund",
                    imgUrl: UImages.comparefund,
                    onTap: () => Get.toNamed(AppRoutes.comparefund),
                  ),
                ]),
              ),
            ),

            ///-------------Popular Funds Part ---------------///
            SliverToBoxAdapter(
              child: Padding(
                padding: isDesktop ? EdgeInsets.all(10) : const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const USectionHeading(
                  title: 'Popular Funds',
                  showActionButton: true,
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: Obx(
                      () {
                    // LOGIC CHANGE: Limit to 4 on Mobile, 8 on Desktop/Tablet
                    final int maxItems = (isDesktop || isTablet) ? 8 : 4;

                    return SliverGrid.builder(
                      itemCount: mutualcontroller.searchFund.length.clamp(0, maxItems),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // Use the popularGridCount you defined earlier (e.g. 5 for desktop, 2 for mobile)
                        crossAxisCount: popularGridCount,
                        // Adjust aspect ratio: Wide for Desktop (2.5), Tall for Mobile (1.55)
                        childAspectRatio: isDesktop ? 2.0 : 1.55,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final fund = mutualcontroller.searchFund[index];
                        final id = fund.amc?.id;
                        if (id == null) return const SizedBox();
                        final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}" ?? '';
                        final name = fund.baseSchemeName ?? 'Unknown Name';

                        return PopularFundCard(
                          onTap: () => Get.toNamed(
                            AppRoutes.funddetails,
                            arguments: {'scheme': name, 'imgUrl': img},
                          ),
                          isNetwork: true,
                          imgPath: img,
                          name: name,
                        );
                      },
                    );
                  }
              ),
            ),

            ///-------------Video’s & Blogs Part ---------------///
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const USectionHeading(
                  title: 'Video’s & Blogs',
                  showActionButton: true,
                  buttonTitle: 'See all',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: isDesktop ? 300 : size.height * 0.25,
                child: Center( // Center the list on desktop
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: isDesktop, // Shrink wrap on desktop to center
                    children: [
                      InlineYouTubePlayer(thumbnailUrl: 'https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg', videoId: "yo5aL4Plbso"),
                      // YoutubeThumbnail(videoId: 'yo5aL4Plbso'),
                      const SizedBox(width: 16),
                      InlineYouTubePlayer(thumbnailUrl: 'https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg', videoId: "t7lUSiddFd4"),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class YoutubeThumbnail extends StatelessWidget {
  const YoutubeThumbnail({
    super.key,
    required this.videoId,
    this.width = 340,
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
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    final size = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Fixed width on desktop, percentage on mobile
    final displayWidth = isDesktop ? 400.0 : size.width * 0.8;
    final displayHeight = isDesktop ? 225.0 : height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: displayWidth,
        height: displayHeight,
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
              // Thumbnail image
              Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.error, color: Colors.white54),
                ),
              ),
              // Semi-transparent overlay
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
                  width: isDesktop ? 80 : 64,
                  height: isDesktop ? 80 : 64,
                  decoration: BoxDecoration(
                    color: const Color(0xfff44336), // YouTube red
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: isDesktop ? 50 : 42,
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
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Removed Align: Allow the container to fill the Grid Cell dimensions
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
              // 1. TOP SECTION (Expanded)
              // This takes up all available vertical space above the stats row.
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to top
                  children: [
                    // Image (Fixed Size)
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

                    // Name (Flexible/Expanded Width)
                    // Prevents horizontal overflow
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: UTextStyles.medium.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.2, // Better line spacing
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. BOTTOM SECTION (Fixed Height)
              // Stays pinned to the bottom because of the Expanded widget above.
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
                        '+31.06%',
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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              // Icon container
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF5FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(iconData, size: 20, color: Ucolors.blue),
              ),
              const SizedBox(width: 12),
              // Title
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
              // Trailing arrow
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
    final bool isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scale image slightly on desktop
          SizedBox(
              height: isDesktop ? 55 : 45,
              width: isDesktop ? 55 : 45,
              child: Image.asset(imgUrl)
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              title,
              style: UTextStyles.small.copyWith(
                color: Colors.grey[600],
                fontSize: isDesktop ? 16 : 14, // Scale font
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
    final size = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dynamic Image Size
          SizedBox(
              height: isDesktop ? 60 : 45,
              width: isDesktop ? 60 : 45,
              child: Image.asset(iconImg, fit: BoxFit.contain)
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: isDesktop ? 140 : size.width * 0.27,
            child: Text(
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              title,
              style: UTextStyles.small.copyWith(
                color: Colors.grey[600],
                overflow: TextOverflow.ellipsis,
                fontSize: isDesktop ? 14 : 12, // Scale text
              ),
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
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: isDesktop ? 80 : 60, // Larger container on desktop
          width: isDesktop ? 80 : 60,
          decoration: BoxDecoration(
            color: Ucolors.primary,
            borderRadius: BorderRadius.circular(isDesktop ? 25 : 20),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              // Scale SVG
              width: isDesktop ? 35 : 24,
              height: isDesktop ? 35 : 24,
              alignment: AlignmentGeometry.center,
            ),
          ),
        ),
        SizedBox(height: isDesktop ? 10 : 5),
        Text(
          featureName,
          style: UTextStyles.medium.copyWith(
            color: Ucolors.light,
            fontWeight: FontWeight.w500,
            fontSize: isDesktop ? 16 : 14, // Scale font
          ),
        ),
      ],
    );
  }
}