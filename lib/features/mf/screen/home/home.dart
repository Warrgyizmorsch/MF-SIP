import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/features/mf/screen/explore/explore.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/goal/goal.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/sip_calculator.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/swp_calci.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/top_up_calculator.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color(0xffF5F5F7),
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
              // expandedHeight: 200,
              flexibleSpace: Container(
                // height: 260,
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
                        onPressed: () {},
                        iconColor: Ucolors.light,
                      ),
                      CompactIcon(
                        icon: Iconsax.shopping_cart,
                        onPressed: () {},
                        iconColor: Ucolors.light,
                      ),
                      CompactIcon(
                        icon: Iconsax.archive_tick,
                        onPressed: () {},
                        iconColor: Ucolors.light,
                      ),
                    ],
                    actionsPadding: EdgeInsets.only(right: 16),
                  ),
                ),
              ),
            ),

            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       // 1. Gradient header with quick action buttons
            //       Container(
            //         height: 180,
            //         // 180, // fixed reasonable height – adjust once, works everywhere
            //         decoration: const BoxDecoration(
            //           gradient: LinearGradient(
            //             begin: Alignment(-0.8, -1.0),
            //             end: Alignment(0.1, 1.0),
            //             stops: [0.0, 0.9784],
            //             colors: [Color(0xFF07315C), Color(0xFF0280C0)],
            //           ),
            //         ),
            //         child: SafeArea(
            //           bottom: false,
            //           child: Padding(
            //             padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            //             child: Column(
            //               children: [
            //                 // Greeting row (if needed – optional)
            //                 // Row(...)
            //                 // const Spacer(),

            //                 // Three feature buttons
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                   children: [
            //                     FeatureSection(
            //                       featureName: 'Start SIP',
            //                       iconPath: UImages.startsip,
            //                     ),
            //                     FeatureSection(
            //                       featureName: 'Freedom SIP',
            //                       iconPath: UImages.freedomsip,
            //                     ),
            //                     FeatureSection(
            //                       featureName: 'Lumpsum',
            //                       iconPath: UImages.glyph,
            //                     ),
            //                   ],
            //                 ),

            //                 const SizedBox(height: 20),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),

            //       // 2. KYC progress card – negative offset for natural overlap
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 24),
            //         child: Transform.translate(
            //           offset: const Offset(
            //             0,
            //             -40,
            //           ), // ← controls overlap amount (tune 40–60)
            //           child: Material(
            //             elevation: 4, // subtle shadow
            //             borderRadius: BorderRadius.circular(12),
            //             color: Ucolors.light,
            //             child: Padding(
            //               padding: const EdgeInsets.all(16),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   // Title + arrow
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       const Text(
            //                         'Complete Your KYC',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                           color: Ucolors.dark,
            //                         ),
            //                       ),
            //                       IconButton(
            //                         icon: const Icon(
            //                           Icons.arrow_forward_ios_rounded,
            //                           size: 18,
            //                           color: Ucolors.primary,
            //                         ),
            //                         onPressed: () {
            //                           // Navigate to KYC flow
            //                         },
            //                       ),
            //                     ],
            //                   ),

            //                   const SizedBox(height: 16),

            //                   // Stepper
            //                   SingleChildScrollView(
            //                     scrollDirection: Axis.horizontal,
            //                     child: EasyStepper(
            //                       activeStep: 2, // Step 3 active
            //                       stepRadius: 10,
            //                       // lineLength: 40,
            //                       // lineThickness: 2,
            //                       finishedStepBackgroundColor: Colors.lightBlue,
            //                       activeStepIconColor: Colors.lightBlue,
            //                       finishedStepIconColor: Colors.white,
            //                       // defaultStepIconColor: Colors.grey,
            //                       activeStepBorderColor: Colors.lightBlue,
            //                       steps: const [
            //                         EasyStep(
            //                           icon: Icon(
            //                             Icons.check_circle,
            //                             color: Colors.white,
            //                           ),
            //                         ),
            //                         EasyStep(
            //                           icon: Icon(
            //                             Icons.check_circle,
            //                             color: Colors.white,
            //                           ),
            //                         ),
            //                         EasyStep(
            //                           icon: Icon(
            //                             Icons.circle,
            //                             color: Colors.lightBlue,
            //                             size: 12,
            //                           ),
            //                         ),
            //                         EasyStep(
            //                           icon: Icon(
            //                             Icons.circle_outlined,
            //                             color: Colors.grey,
            //                           ),
            //                         ),
            //                         EasyStep(
            //                           icon: Icon(
            //                             Icons.circle_outlined,
            //                             color: Colors.grey,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),

            //       // const SizedBox(height: 24), // space before next section
            //     ],
            //   ),
            // ),

            //Header Section --KYC and ,start sip , freedom sip , lumpsum
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.3,
                    // child: Container(color),
                  ),
                  Container(
                    height: size.height * 0.21,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FeatureSection(
                          featureName: 'Start SIP',
                          iconPath: UImages.startsip,
                        ),
                        FeatureSection(
                          featureName: 'Freedom SIP',
                          iconPath: UImages.freedomsip,
                        ),
                        FeatureSection(
                          featureName: 'Lumpsum',
                          iconPath: UImages.glyph,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 0,
                    // top: 0,
                    child: Container(
                      height: size.height * 0.13,
                      // height: 108,
                      // width: size.width / 2,
                      // width: 400,
                      decoration: BoxDecoration(
                        color: Ucolors.light,

                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                            // spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          top: 10,
                          bottom: 10,
                          right: 15,
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
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
                                    Text(
                                      'Verify your Identity to start Investing',
                                      softWrap: true,

                                      maxLines: 1,

                                      overflow: TextOverflow.ellipsis,
                                      style: UTextStyles.caption.copyWith(
                                        // fontSize: 10,
                                      ),
                                      // textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 12),
                                // SizedBox(width: 10),
                              ],
                            ),
                            // Row(
                            //   // mainAxisSize: MainAxisSize.min,
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     SectionHeading(
                            //       sectionTitle: 'Complete Your KYC',
                            //       fontWeight: FontWeight.w500,
                            //       textcolor: Ucolors.dark,
                            //     ),
                            //     SizedBox(width: 5),
                            //     CompactIcon(
                            //       iconSize: 15,
                            //       icon: Icons.arrow_forward_ios,

                            //       onPressed: () {},
                            //     ),
                            //   ],
                            // ),

                            // SizedBox(height: 5),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: EasyStepper(
                            //     activeStepBorderColor: Colors.lightBlue,
                            //     finishedStepBackgroundColor: Colors.lightBlue,
                            //     activeStepIconColor: Colors.lightBlue,

                            //     // color
                            //     stepRadius: 4,
                            //     activeStep: 2,

                            //     // highlights Step 3
                            //     stepShape: StepShape.circle,
                            //     lineStyle: LineStyle(
                            //       lineSpace: 0,
                            //       lineLength: 30,
                            //       activeLineColor: Colors.lightBlue,
                            //       defaultLineColor: Colors.lightBlue,
                            //       lineThickness: 1,
                            //     ),
                            //     steps: [
                            //       EasyStep(
                            //         title: 'Step 1',

                            //         icon: Icon(Icons.check),
                            //       ),
                            //       EasyStep(
                            //         title: 'Step 2',
                            //         icon: Icon(Icons.check),
                            //       ),
                            //       EasyStep(
                            //         title: 'Step 3',
                            //         icon: Icon(Icons.circle),
                            //       ),
                            //       EasyStep(
                            //         title: 'Step 4',
                            //         icon: Icon(Icons.circle_outlined),
                            //       ),

                            //       EasyStep(

                            //         title: 'Step 5',
                            //         icon: Icon(Icons.circle_outlined),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: size.height * 0.025,
                      width: size.width / 2.3,
                      decoration: BoxDecoration(
                        color: Ucolors.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const SectionHeading(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns — most popular choice
                  childAspectRatio:
                      2.8, // tune this: 1.3–1.55 usually looks best
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
                  // GoalBaseSIPCard(
                  //   title: 'Education Goal',
                  //   iconData: Icons.school_rounded,
                  // ),
                  GestureDetector(
                    onTap: () => Get.to(() => GoalScreen()),
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
                          // Icon container
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

                          // Title
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

                          // Trailing arrow
                          // const Icon(
                          //   Icons.arrow_forward_ios_rounded,
                          //   size: 16,
                          //   color: Colors.grey,
                          // ),
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
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: USectionHeading(
                  title: 'Products & Tool',
                  buttonTitle: 'See all',
                  showActionButton: true,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.2, // tune: 2.8–3.5
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  ToolsItem(
                    title: "SIP Calculator",
                    imgUrl: UImages.sipcalci,
                    onTap: () => Get.to(() => SipCalculatorPage()),
                  ),
                  // ToolsItem(title: "STP Calculator", imgUrl: UImages.stpcalci),
                  ToolsItem(
                    title: "SWP Calculator",
                    imgUrl: UImages.swpcali,
                    onTap: () => Get.to(() => SwpCalciScreen()),
                  ),
                  ToolsItem(
                    title: "SIP Top Up Calculator",
                    imgUrl: UImages.siptopcalci,
                    onTap: () => Get.to(() => TopUpCalculatorPage()),
                  ),
                  ToolsItem(title: "Compare Fund", imgUrl: UImages.comparefund),
                ]),
              ),
            ),

            ///-------------Popular Funds Part ---------------///
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: const USectionHeading(
                  title: 'Popular Funds',
                  showActionButton: true,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.55,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  // mainAxisExtent: 120,
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
                height: size.height * 0.25,
                // width: size.height * 0.9,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    YoutubeThumbnail(videoId: 'yo5aL4Plbso'),
                    const SizedBox(width: 16),

                    YoutubeThumbnail(videoId: 't7lUSiddFd4'),
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
                  width: 64,
                  height: 64,
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
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

                        // fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              // Spacer(),
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
                // color: Ucolors.hometxtblue,
                // color: Colors.grey[600],
                // color: Colors.black.withOpacity(0.7),
                color: Colors.grey[600],

                // fontSize: 14,
                // fontWeight: FontWeight.w500,
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
            // width: 100,
            child: Text(
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              title,
              style: UTextStyles.small.copyWith(
                // color: Ucolors.hometxtblue,
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
          // padding: EdgeInsets.all(15),
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
