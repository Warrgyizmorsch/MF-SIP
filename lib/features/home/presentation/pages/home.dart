import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/config/routes/app_pages.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/top_up_calculator.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../widgets/product_tool/sip_calculator.dart';
import '../widgets/product_tool/swp_calci.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);


    final horizontalPadding = isDesktop ? 60.0 : (isTablet ? 32.0 : 16.0);

    final collectionColumns = isDesktop ? 6 : (isTablet ? 4 : 3);
    final goalColumns = isDesktop ? 4 : (isTablet ? 3 : 2);
    final toolColumns = isDesktop ? 4 : (isTablet ? 3 : 2);
    final fundColumns = isDesktop ? 4 : (isTablet ? 3 : 2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [

            SliverAppBar(
              pinned: true,
              snap: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.8, -0.7),
                    end: Alignment(0.8, 0.7),
                    stops: [0.0, 0.5784],
                    colors: [Color(0xFF07315C), Color(0xff0280C0)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: CustomProfileAppbar(
                      onProfiletap: () => Get.to(() => ProfileScreen()),
                      backgroundColor: Colors.transparent,
                      greetingName: 'Nazzu',
                      role: 'Developer',
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
                        CompactIcon(
                          icon: Iconsax.shopping_cart,
                          onPressed: () => Get.toNamed(AppRoutes.cart),
                          iconColor: Ucolors.light,
                        ),
                        CompactIcon(
                          icon: Iconsax.archive_tick,
                          onPressed: () => Get.toNamed(AppRoutes.watchlist),
                          iconColor: Ucolors.light,
                        ),
                      ],
                      actionsPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:  0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: isDesktop ? size.height * 0.3 : size.height * 0.3,
                    ),
                    Container(
                      height: isDesktop ? size.height * 0.15 : size.height * 0.21,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.8, -1.0),
                          end: Alignment(0.1, 1.0),
                          stops: const [0.0, 0.9784],
                          colors: [Color(0xFF07315C), Color(0xFF0280C0)],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                            child: FeatureSection(
                              featureName: 'Start SIP',
                              iconPath: UImages.startsip,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.freedomSipScreen),
                            child: FeatureSection(
                              featureName: 'Freedom SIP',
                              iconPath: UImages.freedomsip,
                            ),
                          ),
                          FeatureSection(
                            featureName: 'Lumpsum',
                            iconPath: UImages.glyph,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: isDesktop ? 0 : 20,
                      right: isDesktop ? 0 : 20,
                      bottom: 0,
                      child: Container(
                        height: isDesktop ? 90 : size.height * 0.13,
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 800 : double.infinity,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: isDesktop ? size.width * 0.1 : 0,
                        ),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.person, size: isDesktop ? 28 : 24),
                              SizedBox(width: isDesktop ? 15 : 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Onboarding task',
                                      style: UTextStyles.caption,
                                    ),
                                    Text(
                                      'Complete KYC & Profile',
                                      style: UTextStyles.medium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Ucolors.dark,
                                      ),
                                    ),
                                    if (!isDesktop)
                                      Text(
                                        'Verify your Identity to start Investing',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: UTextStyles.caption,
                                      ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: isDesktop ? 14 : 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 0),
                child: const SectionHeading(
                  sectionTitle: 'Collection',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: collectionColumns,
                  childAspectRatio: 1.1,
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
                    title: 'International Funds',
                    iconImg: UImages.interfund,
                    onTap: () => Get.to(() => ExploreScreen()),
                  ),
                  CollectionItem(
                    title: 'Index Funds',
                    iconImg: UImages.indexfund,
                    onTap: () => Get.to(() => ExploreScreen()),
                  ),
                  CollectionItem(
                    title: 'Commodities',
                    iconImg: UImages.moneygold,
                    onTap: () => Get.to(() => ExploreScreen()),
                  ),
                  CollectionItem(
                    title: 'Equity',
                    iconImg: UImages.equity,
                    onTap: () => Get.to(() => ExploreScreen()),
                  ),
                ]),
              ),
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 12),
                child: const USectionHeading(
                  title: 'Create Goal Base SIP',
                  showActionButton: false,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: goalColumns,
                  childAspectRatio: isDesktop ? 3.5 : 2.8,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  GoalBaseSIPCard(
                    onTap: () => Get.to(() => GoalScreen()),
                    title: 'Car Goal',
                    iconData: Icons.directions_car_filled_rounded,
                  ),
                  GoalBaseSIPCard(
                    onTap: () => Get.to(() => GoalScreen()),
                    title: 'Bike Goal',
                    iconData: Icons.pedal_bike_rounded,
                  ),
                  GoalBaseSIPCard(
                    onTap: () => Get.to(() => GoalScreen()),
                    title: 'Marriage Goal',
                    iconData: Icons.favorite_border_outlined,
                  ),
                  GoalBaseSIPCard(
                    onTap: () => Get.to(() => GoalScreen()),
                    title: 'Vacation Goal',
                    iconData: Icons.flight_takeoff_rounded,
                  ),
                  GoalBaseSIPCard(
                    onTap: () => Get.to(() => GoalScreen()),
                    title: 'Home Goal',
                    iconData: Icons.home_rounded,
                  ),
                  _buildCustomGoalCard(),
                ]),
              ),
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: USectionHeading(
                  title: 'Products & Tool',
                  buttonTitle: 'See all',
                  showActionButton: true,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: toolColumns,
                  childAspectRatio: isDesktop ? 4.5 : 3.2,
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


            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 0),
                child: const USectionHeading(
                  title: 'Popular Funds',
                  showActionButton: true,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: fundColumns,
                  childAspectRatio: 1.55,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  PopularFundCard(
                    onTap: () => Get.to(() => FundDeatailsScreen()),
                    name: 'SBI Gold Fund',
                    imgPath: UImages.sbi,
                  ),
                  PopularFundCard(
                    onTap: () => Get.to(() => FundDeatailsScreen()),
                    name: 'Parag Parikh Flexi Cap Fund',
                    imgPath: UImages.sbi,
                  ),
                  PopularFundCard(
                    onTap: () => Get.to(() => FundDeatailsScreen()),
                    name: 'Motilal Ostwal Midcap Fund',
                    imgPath: UImages.motilal,
                  ),
                  PopularFundCard(
                    onTap: () => Get.to(() => FundDeatailsScreen()),
                    name: 'Bandhan Small Cap Fund',
                    imgPath: UImages.motilal,
                  ),
                ]),
              ),
            ),


            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 0),
                child: const USectionHeading(
                  title: "Video's & Blogs",
                  showActionButton: true,
                  buttonTitle: 'See all',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: isDesktop ? 280 : (isTablet ? 240 : size.height * 0.25),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  children: [
                    YoutubeThumbnail(
                      videoId: 'yo5aL4Plbso',
                      width: isDesktop ? 450 : (isTablet ? 380 : 340),
                    ),
                    const SizedBox(width: 16),
                    YoutubeThumbnail(
                      videoId: 't7lUSiddFd4',
                      width: isDesktop ? 450 : (isTablet ? 380 : 340),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomGoalCard() {
    return GestureDetector(
      onTap: () => Get.to(() => GoalScreen()),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add, size: 20, color: Ucolors.blue),
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
    final thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.8,
        height: height,
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
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Ucolors.borderColor),
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
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(backgroundImage: AssetImage(imgPath)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      softWrap: true,
                      maxLines: 2,
                      style: UTextStyles.small.copyWith(
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,


                      ),
                    ),
                  ),
                ],
              ),

              Expanded(child: SizedBox()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '3Y',
                    style: UTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.arrow_drop_up, color: Ucolors.success),
                      Text(
                        '+31.06%',
                        style: UTextStyles.caption.copyWith(
                          color: Ucolors.success,
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
    log('tap');
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 45, width: 45, child: Image.asset(imgUrl)),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              title,
              style: UTextStyles.small.copyWith(



                color: Colors.grey[600],



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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconImg),

          const SizedBox(height: 4),
          SizedBox(
            width: size.width * 0.27,

            child: Text(
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              title,
              style: UTextStyles.small.copyWith(

                color: Colors.grey[600],
                overflow: TextOverflow.ellipsis,
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
            child: SvgPicture.asset(
              iconPath,
              alignment: AlignmentGeometry.center,
            ),
          ),
        ),
        Text(
          featureName,
          style: UTextStyles.medium.copyWith(
            color: Ucolors.light,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
