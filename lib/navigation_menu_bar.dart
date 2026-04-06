// // import 'dart:ui';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get.dart';
// // import 'package:iconsax/iconsax.dart';
// // import 'package:my_sip/common/widget/images/image_select.dart';
// // import 'package:my_sip/config/routes/app_routes.dart';
// // import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
// // import 'package:my_sip/features/explore/presentation/pages/explore.dart';
// // import 'package:my_sip/features/goal/presentation/pages/goal.dart';
// // import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
// // import 'package:responsive_framework/responsive_framework.dart';

// // import 'package:my_sip/services/session_manager.dart';
// // import 'package:my_sip/features/home/presentation/pages/home.dart';
// // import 'package:my_sip/core/utils/constant/colors.dart';
// // import 'config/routes/app_pages.dart';
// // import 'core/utils/constant/images.dart';

// // class NavigationBarController extends GetxController {
// //   static NavigationBarController get instance => Get.find();

// //   final RxInt selectedIndex = 0.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     // URL syncing won't apply to nested widgets, but it's safe to leave this
// //     // if you handle deep links manually later.
// //     _syncTabWithUrl();
// //   }

// //   void _syncTabWithUrl() {
// //     String currentRoute = Get.currentRoute;
// //     if (currentRoute.contains(AppRoutes.explorePage)) {
// //       selectedIndex.value = 1;
// //     } else if (currentRoute.contains(AppRoutes.dashBoardPage)) {
// //       selectedIndex.value = 2;
// //     } else if (currentRoute.contains(AppRoutes.goalScreen)) {
// //       selectedIndex.value = 3;
// //     } else if (currentRoute.contains(AppRoutes.profilePage)) {
// //       selectedIndex.value = 4;
// //     } else {
// //       selectedIndex.value = 0;
// //     }
// //   }

// //   void changePage(int index) {
// //     if (selectedIndex.value == index) return;
// //     // We NO LONGER use Get.offNamed.
// //     // Just change the value, and the Obx in the UI will instantly swap the widget.
// //     selectedIndex.value = index;
// //   }

// //   void navigateToExploreWithFilter(VoidCallback? filterLogic) {
// //     changePage(1);
// //     // Get.toNamed(AppRoutes.explorePage);
// //     if (filterLogic != null) {
// //       filterLogic();
// //     }
// //   }
// // }

// // // class NavigationBarController extends GetxController {
// // //   static NavigationBarController get instance => Get.find();

// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     _syncTabWithUrl();
// // //   }

// // //   final RxInt selectedIndex = 0.obs;

// // //   void _syncTabWithUrl() {
// // //     // Read the exact URL the user typed in the browser
// // //     String currentRoute = Get.currentRoute;

// // //     // Change the active tab based on the URL string.
// // //     // We use .contains() instead of == just in case there are query parameters (like ?fundId=123)
// // //     if (currentRoute.contains(AppRoutes.explorePage)) {
// // //       selectedIndex.value = 1;
// // //     } else if (currentRoute.contains(AppRoutes.dashBoardPage)) {
// // //       selectedIndex.value = 2;
// // //     } else if (currentRoute.contains(AppRoutes.goalScreen)) {
// // //       selectedIndex.value = 3;
// // //     } else if (currentRoute.contains(AppRoutes.profilePage)) {
// // //       selectedIndex.value = 4;
// // //     } else {
// // //       selectedIndex.value = 0; // Default to Home
// // //     }
// // //   }

// // //   void changePage(int index) {
// // //     if (selectedIndex.value == index) return;
// // //     selectedIndex.value = index;

// // //     // Use id: 1 to navigate inside the nested area
// // //     switch (index) {
// // //       case 0:
// // //         Get.off(AppRoutes.home, id: 1);
// // //         // Get.toNamed(AppRoutes.home, id: 1);
// // //         break;
// // //       case 1:
// // //         Get.off(AppRoutes.explorePage, id: 1);
// // //         break;
// // //       case 2:
// // //         Get.off(AppRoutes.dashBoardPage, id: 1);
// // //         break;
// // //       case 3:
// // //         Get.off(AppRoutes.goalScreen, id: 1);
// // //         break;
// // //       case 4:
// // //         Get.off(AppRoutes.profilePage, id: 1);
// // //         break; // or AppRoutes.profile
// // //     }
// // //   }

// // //   // Inside NavigationBarController
// // //   void navigateToExploreWithFilter(VoidCallback? filterLogic) {
// // //     // 1. Update the UI state for the Nav Bar
// // //     changePage(1);

// // //     // 2. Execute the specific filter logic
// // //     if (filterLogic != null) {
// // //       filterLogic();
// // //     }
// // //   }
// // // }

// // class NavigationMenuBar extends StatelessWidget {
// //   const NavigationMenuBar({super.key});

// //   Future<bool> _showModernExitDialog(BuildContext context) async {
// //     return await showGeneralDialog<bool>(
// //           context: context,
// //           barrierDismissible: true,
// //           barrierLabel: "ExitDialog",
// //           barrierColor: Colors.black.withOpacity(
// //             0.5,
// //           ), // Semi-transparent overlay
// //           transitionDuration: const Duration(milliseconds: 200),
// //           pageBuilder: (context, anim1, anim2) {
// //             return BackdropFilter(
// //               filter: ImageFilter.blur(
// //                 sigmaX: 5,
// //                 sigmaY: 5,
// //               ), // Adjust blur intensity here
// //               child: Center(
// //                 child: Container(
// //                   margin: const EdgeInsets.symmetric(horizontal: 24),
// //                   padding: const EdgeInsets.all(24),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(
// //                       0.9,
// //                     ), // Slightly transparent white
// //                     borderRadius: BorderRadius.circular(28),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.1),
// //                         blurRadius: 20,
// //                         spreadRadius: 5,
// //                       ),
// //                     ],
// //                   ),
// //                   child: Material(
// //                     color: Colors.transparent,
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       children: [
// //                         // Warning Icon with soft glow
// //                         Container(
// //                           padding: const EdgeInsets.all(20),
// //                           decoration: BoxDecoration(
// //                             color: Colors.red.withOpacity(0.1),
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: const Icon(
// //                             Iconsax.info_circle,
// //                             color: Colors.redAccent,
// //                             size: 40,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 24),

// //                         const Text(
// //                           'Wait! Are you leaving?',
// //                           style: TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.w800,
// //                             letterSpacing: -0.5,
// //                             color: Color(0xFF1A1A1A),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //                         Text(
// //                           'Closing the app will pause your current session. Are you sure you want to exit?',
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(
// //                             fontSize: 15,
// //                             color: Colors.grey.shade600,
// //                             height: 1.4,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 32),

// //                         // Action Buttons
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: TextButton(
// //                                 onPressed: () => Navigator.pop(context, false),
// //                                 style: TextButton.styleFrom(
// //                                   padding: const EdgeInsets.symmetric(
// //                                     vertical: 16,
// //                                   ),
// //                                   shape: RoundedRectangleBorder(
// //                                     side: BorderSide(
// //                                       color: Colors.grey.shade300,
// //                                     ),

// //                                     borderRadius: BorderRadius.circular(16),
// //                                   ),
// //                                 ),
// //                                 child: Text(
// //                                   'Stay here',
// //                                   style: TextStyle(
// //                                     color: Colors.grey.shade700,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(width: 12),
// //                             Expanded(
// //                               child: ElevatedButton(
// //                                 onPressed: () => Navigator.pop(context, true),
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: Colors.redAccent,
// //                                   foregroundColor: Colors.white,
// //                                   elevation: 0,
// //                                   padding: const EdgeInsets.symmetric(
// //                                     vertical: 16,
// //                                   ),
// //                                   shape: RoundedRectangleBorder(
// //                                     side: BorderSide(
// //                                       color: Colors.grey.shade300,
// //                                     ),
// //                                     borderRadius: BorderRadius.circular(16),
// //                                   ),
// //                                 ),
// //                                 child: const Text(
// //                                   'Exit App',
// //                                   style: TextStyle(fontWeight: FontWeight.bold),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         ) ??
// //         false;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Ensure the controller is loaded
// //     // final controller = Get.put(NavigationBarController());
// //     final controller = Get.find<NavigationBarController>();

// //     final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
// //     final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

// //     return PopScope(
// //       canPop: false, // Prevents the default back button behavior
// //       onPopInvokedWithResult: (didPop, result) async {
// //         if (didPop) return;

// //         // If user is NOT on the Home tab (index 0), navigate to Home first
// //         if (controller.selectedIndex.value != 0) {
// //           controller.changePage(0);
// //           return;
// //         }

// //         // If already on Home tab, show the exit warning
// //         final shouldExit = await _showModernExitDialog(context);
// //         if (shouldExit) {
// //           // This closes the app
// //           SystemNavigator.pop();
// //         }
// //       },

// //       child: Scaffold(
// //         body: Row(
// //           // key: const ValueKey('MainNavigationRow'),
// //           children: [
// //             // if (isDesktop)
// //             //   _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet),
// //             isDesktop
// //                 ? _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet)
// //                 : const SizedBox.shrink(),

// //             Expanded(
// //               // THE ULTIMATE FIX:
// //               // We use Obx to dynamically return the exact screen widget based on the index.
// //               // No GetX router, no nested keys, impossible to duplicate!
// //               child: Obx(() {
// //                 switch (controller.selectedIndex.value) {
// //                   case 0:
// //                     return HomeScreen();
// //                   case 1:
// //                     return ExploreScreen();
// //                   case 2:
// //                     return DashboardScreen();
// //                   case 3:
// //                     return GoalScreen();
// //                   case 4:
// //                     return ProfileScreen();
// //                   default:
// //                     return HomeScreen();
// //                 }
// //               }),
// //             ),

// //             // Expanded(
// //             //   child: Navigator(
// //             //     key: Get.nestedKey(
// //             //       1,
// //             //     ), // Ensure this matches controller.changePage logic
// //             //     initialRoute: AppRoutes.home,
// //             //     onGenerateRoute: (settings) {
// //             //       // Look up the route in your existing AppPages
// //             //       try {
// //             //         final getPage = AppPages.pages().firstWhere(
// //             //           (p) => p.name == settings.name,
// //             //         );

// //             //         return GetPageRoute(
// //             //           page: getPage.page,
// //             //           binding: getPage.binding,
// //             //           bindings: getPage.bindings,
// //             //           settings: settings,
// //             //           transition:
// //             //               Transition.fadeIn, // Optional: smoother tab switch
// //             //         );
// //             //       } catch (e) {
// //             //         // Fallback if route not found in AppPages
// //             //         return GetPageRoute(
// //             //           page: () => HomeScreen(),
// //             //           settings: settings,
// //             //         );
// //             //       }
// //             //     },
// //             //   ),
// //             // ),
// //           ],
// //         ),
// //         bottomNavigationBar: (isDesktop) ? null : const _MobileBottomNavBar(),
// //       ),
// //     );
// //   }
// // }

// // class _DesktopSideNav extends StatelessWidget {
// //   final bool isDesktop;
// //   final bool isTablet;

// //   const _DesktopSideNav({required this.isDesktop, required this.isTablet});

// //   @override
// //   Widget build(BuildContext context) {
// //     final user = SessionManager.instance.getUserData;
// //     final controller = NavigationBarController.instance;
// //     final width = isDesktop ? 280.0 : 80.0;

// //     return Container(
// //       width: width,
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         border: Border(
// //           right: BorderSide(color: Colors.grey.shade200, width: 1),
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(2, 0),
// //           ),
// //         ],
// //       ),
// //       child: SafeArea(
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: EdgeInsets.symmetric(
// //                 vertical: 24,
// //                 horizontal: isDesktop ? 24 : 16,
// //               ),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                     width: 40,
// //                     height: 40,
// //                     decoration: BoxDecoration(
// //                       gradient: Ucolors.backgroundGradient,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: const Icon(
// //                       Icons.trending_up,
// //                       color: Colors.white,
// //                       size: 24,
// //                     ),
// //                   ),
// //                   if (isDesktop) ...[
// //                     const SizedBox(width: 12),
// //                     Text(
// //                       'My SIP',
// //                       style: TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         color: Ucolors.dark,
// //                       ),
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             Expanded(
// //               child: ListView.builder(
// //                 padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8),
// //                 itemCount: _navItems.length,
// //                 itemBuilder: (context, index) {
// //                   return Obx(() {
// //                     final isSelected = controller.selectedIndex.value == index;
// //                     return _DesktopNavItem(
// //                       item: _navItems[index],
// //                       isSelected: isSelected,
// //                       isDesktop: isDesktop,
// //                       onTap: () => controller.changePage(index), // UPDATED
// //                     );
// //                   });
// //                 },
// //               ),
// //             ),

// //             if (isDesktop)
// //               Container(
// //                 padding: const EdgeInsets.all(24),
// //                 child: Column(
// //                   children: [
// //                     Divider(color: Colors.grey.shade200),
// //                     const SizedBox(height: 12),
// //                     Row(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 20,
// //                           backgroundImage: AssetImage(UImages.avatar),
// //                         ),

// //                         // UCircularImage(image: user?.img ?? ''),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 user?.name ?? 'Guest User',
// //                                 overflow: TextOverflow.ellipsis,
// //                                 style: const TextStyle(
// //                                   fontWeight: FontWeight.w600,
// //                                   fontSize: 14,
// //                                   color: Colors.black,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _DesktopNavItem extends StatelessWidget {
// //   final _NavItemData item;
// //   final bool isSelected;
// //   final bool isDesktop;
// //   final VoidCallback onTap;

// //   const _DesktopNavItem({
// //     required this.item,
// //     required this.isSelected,
// //     required this.isDesktop,
// //     required this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: onTap,
// //           borderRadius: BorderRadius.circular(12),
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 200),
// //             padding: EdgeInsets.symmetric(
// //               vertical: 14,
// //               horizontal: isDesktop ? 16 : 12,
// //             ),
// //             decoration: BoxDecoration(
// //               color: isSelected
// //                   ? Ucolors.blue.withOpacity(0.1)
// //                   : Colors.transparent,
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(
// //                 color: isSelected
// //                     ? Ucolors.blue.withOpacity(0.2)
// //                     : Colors.transparent,
// //                 width: 1,
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 Icon(
// //                   item.icon,
// //                   size: 24,
// //                   color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
// //                 ),
// //                 if (isDesktop) ...[
// //                   const SizedBox(width: 16),
// //                   Expanded(
// //                     child: Text(
// //                       item.label,
// //                       style: TextStyle(
// //                         fontSize: 15,
// //                         fontWeight: isSelected
// //                             ? FontWeight.w600
// //                             : FontWeight.w400,
// //                         color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _MobileBottomNavBar extends StatelessWidget {
// //   const _MobileBottomNavBar();

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       top: false,
// //       bottom: true,
// //       child: Container(
// //         height: kBottomNavigationBarHeight + 20,
// //         padding: const EdgeInsets.only(top: 6, bottom: 12),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, -2),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: List.generate(
// //             _navItems.length,
// //             (index) => _MobileNavItem(index: index),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _MobileNavItem extends StatelessWidget {
// //   final int index;
// //   const _MobileNavItem({required this.index});

// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = NavigationBarController.instance;

// //     return Obx(() {
// //       final bool isSelected = controller.selectedIndex.value == index;
// //       final item = _navItems[index];

// //       return GestureDetector(
// //         behavior: HitTestBehavior.opaque,
// //         // UPDATED: Use changePage to trigger Get.toNamed
// //         onTap: () => controller.changePage(index),
// //         child: SizedBox(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               AnimatedContainer(
// //                 duration: const Duration(milliseconds: 250),
// //                 height: 3,
// //                 width: isSelected ? 28 : 0,
// //                 decoration: BoxDecoration(
// //                   gradient: Ucolors.backgroundGradient,
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               const SizedBox(height: 6),
// //               Icon(
// //                 item.icon,
// //                 size: 24,
// //                 color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 item.label,
// //                 style: TextStyle(
// //                   fontSize: 12,
// //                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
// //                   color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     });
// //   }
// // }

// // class _NavItemData {
// //   final IconData icon;
// //   final String label;
// //   const _NavItemData(this.icon, this.label);
// // }

// // const List<_NavItemData> _navItems = [
// //   _NavItemData(Iconsax.home, 'Home'),
// //   _NavItemData(Icons.trending_up, 'Explore'),
// //   _NavItemData(Iconsax.chart_1, 'Dashboard'),
// //   _NavItemData(Iconsax.cup, 'Goal'),
// //   _NavItemData(Iconsax.user4, 'Profile'),
// // ];
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:flutter/services.dart';
// import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
// import 'package:my_sip/features/explore/presentation/pages/explore.dart';
// import 'package:my_sip/features/goal/presentation/pages/goal.dart';
// import 'package:my_sip/features/home/presentation/pages/home.dart';
// import 'package:my_sip/features/personalization/presentation/widgets/document.dart';
// import 'package:my_sip/features/personalization/presentation/widgets/personal_details.dart';
// import 'package:responsive_framework/responsive_framework.dart'; // Make sure this is imported

// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/images.dart';
// import 'package:my_sip/services/session_manager.dart';
// import 'package:my_sip/config/routes/app_routes.dart';

// // Screens imports (Replace with your actual paths)
// import 'package:my_sip/features/personalization/presentation/pages/profile.dart'; // Keep this as base Profile if needed
// import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
// import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
// import 'package:my_sip/features/personalization/presentation/widgets/nominee_list.dart';

// // =========================================
// // 1. UPDATED CONTROLLER
// // =========================================
// class NavigationBarController extends GetxController {
//   static NavigationBarController get instance => Get.find();

//   // Selected Index covers both main menus and sub-menus
//   // 0: Home, 1: Explore, 2: Dashboard, 3: Goal
//   // Profile Submenus -> 40: Base Profile, 41: KYC, 42: Personal Details, 43: Bank, 44: Nominee, 45: Documents, 46: Help, 47: About
//   final RxInt selectedIndex = 0.obs;

//   // Controls if the Profile menu is expanded in the SideNav
//   final RxBool isProfileExpanded = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _syncTabWithUrl();
//   }

//   void _syncTabWithUrl() {
//     String currentRoute = Get.currentRoute;
//     if (currentRoute.contains(AppRoutes.explorePage)) {
//       selectedIndex.value = 1;
//     } else if (currentRoute.contains(AppRoutes.dashBoardPage)) {
//       selectedIndex.value = 2;
//     } else if (currentRoute.contains(AppRoutes.goalScreen)) {
//       selectedIndex.value = 3;
//     } else if (currentRoute.contains(AppRoutes.profilePage)) {
//       selectedIndex.value = 40;
//       isProfileExpanded.value = true;
//     } else {
//       selectedIndex.value = 0;
//     }
//   }

//   void changePage(int index) {
//     if (selectedIndex.value == index) return;

//     // If clicking on main "Profile" (index 4), toggle expansion instead of just navigating
//     if (index == 4) {
//       isProfileExpanded.value = !isProfileExpanded.value;
//       if (isProfileExpanded.value && selectedIndex.value < 40) {
//         // Automatically select the first sub-item (Base Profile) when expanding
//         selectedIndex.value = 40;
//       }
//       return;
//     }

//     // Collapse profile if navigating to a completely different main tab (Home, Explore, etc.)
//     if (index < 4) {
//       isProfileExpanded.value = false;
//     }

//     selectedIndex.value = index;
//   }

//   void navigateToExploreWithFilter(VoidCallback? filterLogic) {
//     changePage(1);
//     if (filterLogic != null) {
//       filterLogic();
//     }
//   }

//   // Helper to check if currently on ANY profile sub-page
//   bool get isProfileActive =>
//       selectedIndex.value >= 40 && selectedIndex.value < 50;
// }

// // =========================================
// // 2. MAIN LAYOUT WIDGET
// // =========================================
// class NavigationMenuBar extends StatelessWidget {
//   const NavigationMenuBar({super.key});

//   Future<bool> _showModernExitDialog(BuildContext context) async {
//     return await showGeneralDialog<bool>(
//           context: context,
//           barrierDismissible: true,
//           barrierLabel: "ExitDialog",
//           barrierColor: Colors.black.withOpacity(0.5),
//           transitionDuration: const Duration(milliseconds: 200),
//           pageBuilder: (context, anim1, anim2) {
//             return BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//               child: Center(
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 24),
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(28),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.red.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Iconsax.info_circle,
//                             color: Colors.redAccent,
//                             size: 40,
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         const Text(
//                           'Wait! Are you leaving?',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w800,
//                             letterSpacing: -0.5,
//                             color: Color(0xFF1A1A1A),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           'Closing the app will pause your current session. Are you sure you want to exit?',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.grey.shade600,
//                             height: 1.4,
//                           ),
//                         ),
//                         const SizedBox(height: 32),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextButton(
//                                 onPressed: () => Navigator.pop(context, false),
//                                 style: TextButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Stay here',
//                                   style: TextStyle(
//                                     color: Colors.grey.shade700,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () => Navigator.pop(context, true),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.redAccent,
//                                   foregroundColor: Colors.white,
//                                   elevation: 0,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Exit App',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<NavigationBarController>();
//     final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
//     final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;
//         if (controller.selectedIndex.value != 0) {
//           controller.changePage(0);
//           return;
//         }
//         final shouldExit = await _showModernExitDialog(context);
//         if (shouldExit) {
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         body: Row(
//           children: [
//             isDesktop
//                 ? _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet)
//                 : const SizedBox.shrink(),
//             Expanded(
//               // 🚀 FIX: Enhanced switch case to handle sub-categories
//               child: Obx(() {
//                 switch (controller.selectedIndex.value) {
//                   case 0:
//                     return const HomeScreen();
//                   case 1:
//                     return const ExploreScreen();
//                   case 2:
//                     return DashboardScreen();
//                   case 3:
//                     return const GoalScreen();

//                   // Profile Sub-categories
//                   case 40:
//                     return const ProfileScreen(); // Base profile or overview
//                   case 41:
//                     return const KycDetailsScreen();
//                   case 42:
//                     return PersonalDetailsScreen(); // (Assuming no const in your file)
//                   case 43:
//                     return const BankDetailsScreen();
//                   case 44:
//                     return const NomineeListScreen();
//                   case 45:
//                     return const DocumentScreen();

//                   default:
//                     return const HomeScreen();
//                 }
//               }),
//             ),
//           ],
//         ),
//         bottomNavigationBar: (isDesktop) ? null : const _MobileBottomNavBar(),
//       ),
//     );
//   }
// }

// // =========================================
// // 3. DESKTOP NAV WITH ACCORDION
// // =========================================
// class _DesktopSideNav extends StatelessWidget {
//   final bool isDesktop;
//   final bool isTablet;

//   const _DesktopSideNav({required this.isDesktop, required this.isTablet});

//   @override
//   Widget build(BuildContext context) {
//     final user = SessionManager.instance.userObs.value;
//     final controller = NavigationBarController.instance;
//     final width = isDesktop ? 280.0 : 80.0;

//     return Container(
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           right: BorderSide(color: Colors.grey.shade200, width: 1),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(2, 0),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           children: [
//             // Logo Section
//             Container(
//               padding: EdgeInsets.symmetric(
//                 vertical: 24,
//                 horizontal: isDesktop ? 24 : 16,
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       gradient: Ucolors.backgroundGradient,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.trending_up,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   if (isDesktop) ...[
//                     const SizedBox(width: 12),
//                     const Text(
//                       'My SIP',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Ucolors.dark,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Navigation List
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8),
//                 child: Column(
//                   children: [
//                     // --- Main Items ---
//                     Obx(
//                       () => _buildNavItem(
//                         controller,
//                         0,
//                         Iconsax.home,
//                         'Home',
//                         isDesktop,
//                       ),
//                     ),
//                     Obx(
//                       () => _buildNavItem(
//                         controller,
//                         1,
//                         Icons.trending_up,
//                         'Explore',
//                         isDesktop,
//                       ),
//                     ),
//                     Obx(
//                       () => _buildNavItem(
//                         controller,
//                         2,
//                         Iconsax.chart_1,
//                         'Dashboard',
//                         isDesktop,
//                       ),
//                     ),
//                     Obx(
//                       () => _buildNavItem(
//                         controller,
//                         3,
//                         Iconsax.cup,
//                         'Goal',
//                         isDesktop,
//                       ),
//                     ),

//                     const SizedBox(height: 16),
//                     if (isDesktop)
//                       Padding(
//                         padding: const EdgeInsets.only(left: 16, bottom: 8),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "SETTINGS",
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey.shade500,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),

//                     // --- Profile Item (Expandable) ---
//                     Obx(() {
//                       final isProfileActive = controller.isProfileActive;
//                       final isExpanded = controller.isProfileExpanded.value;

//                       return Column(
//                         children: [
//                           _DesktopNavItem(
//                             icon: Iconsax.user4,
//                             label: 'Profile',
//                             isSelected: isProfileActive,
//                             isDesktop: isDesktop,
//                             // Show arrow if desktop
//                             trailing: isDesktop
//                                 ? Icon(
//                                     isExpanded
//                                         ? Icons.keyboard_arrow_up
//                                         : Icons.keyboard_arrow_down,
//                                     color: isProfileActive
//                                         ? Ucolors.blue
//                                         : Ucolors.darkgrey,
//                                     size: 18,
//                                   )
//                                 : null,
//                             onTap: () => controller.changePage(
//                               4,
//                             ), // 4 triggers the toggle in controller
//                           ),

//                           // Sub-categories (Animated expansion)
//                           if (isDesktop) // Only show sub-menu on desktop
//                             AnimatedCrossFade(
//                               duration: const Duration(milliseconds: 300),
//                               crossFadeState: isExpanded
//                                   ? CrossFadeState.showFirst
//                                   : CrossFadeState.showSecond,
//                               firstChild: Container(
//                                 margin: const EdgeInsets.only(
//                                   left: 36,
//                                   top: 4,
//                                   bottom: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     left: BorderSide(
//                                       color: Colors.grey.shade200,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     _buildSubItem(
//                                       controller,
//                                       40,
//                                       "Profile Overview",
//                                     ),
//                                     _buildSubItem(
//                                       controller,
//                                       41,
//                                       "KYC Details",
//                                     ),
//                                     _buildSubItem(
//                                       controller,
//                                       42,
//                                       "Personal Details",
//                                     ),
//                                     _buildSubItem(
//                                       controller,
//                                       43,
//                                       "Bank Account",
//                                     ),
//                                     _buildSubItem(
//                                       controller,
//                                       44,
//                                       "Nominee Details",
//                                     ),
//                                     _buildSubItem(controller, 45, "Documents"),
//                                     _buildSubItem(
//                                       controller,
//                                       46,
//                                       "Help & Support",
//                                     ),
//                                     _buildSubItem(controller, 47, "About Us"),
//                                   ],
//                                 ),
//                               ),
//                               secondChild: const SizedBox.shrink(),
//                             ),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),

//             // Profile Bottom Banner
//             if (isDesktop)
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   children: [
//                     Divider(color: Colors.grey.shade200),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 20,
//                           backgroundImage: AssetImage(UImages.avatar),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 user?.name ?? 'Guest User',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(
//     NavigationBarController controller,
//     int index,
//     IconData icon,
//     String label,
//     bool isDesktop,
//   ) {
//     return _DesktopNavItem(
//       icon: icon,
//       label: label,
//       isSelected: controller.selectedIndex.value == index,
//       isDesktop: isDesktop,
//       onTap: () => controller.changePage(index),
//     );
//   }

//   Widget _buildSubItem(
//     NavigationBarController controller,
//     int index,
//     String label,
//   ) {
//     final isSelected = controller.selectedIndex.value == index;
//     return InkWell(
//       onTap: () => controller.changePage(index),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//             color: isSelected ? Ucolors.blue : Colors.grey.shade600,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Custom Nav Item Widget
// class _DesktopNavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final bool isDesktop;
//   final VoidCallback onTap;
//   final Widget? trailing;

//   const _DesktopNavItem({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.isDesktop,
//     required this.onTap,
//     this.trailing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: EdgeInsets.symmetric(
//               vertical: 14,
//               horizontal: isDesktop ? 16 : 12,
//             ),
//             decoration: BoxDecoration(
//               color: isSelected
//                   ? Ucolors.blue.withOpacity(0.1)
//                   : Colors.transparent,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isSelected
//                     ? Ucolors.blue.withOpacity(0.2)
//                     : Colors.transparent,
//                 width: 1,
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   size: 24,
//                   color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
//                 ),
//                 if (isDesktop) ...[
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       label,
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: isSelected
//                             ? FontWeight.w600
//                             : FontWeight.w400,
//                         color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
//                       ),
//                     ),
//                   ),
//                   if (trailing != null) trailing!,
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =========================================
// // 4. MOBILE BOTTOM NAV
// // =========================================
// class _MobileBottomNavBar extends StatelessWidget {
//   const _MobileBottomNavBar();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: true,
//       child: Container(
//         height: kBottomNavigationBarHeight + 20,
//         padding: const EdgeInsets.only(top: 6, bottom: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: const [
//             _MobileNavItem(index: 0, icon: Iconsax.home, label: 'Home'),
//             _MobileNavItem(index: 1, icon: Icons.trending_up, label: 'Explore'),
//             _MobileNavItem(index: 2, icon: Iconsax.chart_1, label: 'Dashboard'),
//             _MobileNavItem(index: 3, icon: Iconsax.cup, label: 'Goal'),
//             _MobileNavItem(index: 4, icon: Iconsax.user4, label: 'Profile'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MobileNavItem extends StatelessWidget {
//   final int index;
//   final IconData icon;
//   final String label;

//   const _MobileNavItem({
//     required this.index,
//     required this.icon,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = NavigationBarController.instance;

//     return Obx(() {
//       // Logic: Mobile 'Profile' tab handles any index 40+ as 'active'
//       final bool isSelected = index == 4
//           ? controller.isProfileActive
//           : controller.selectedIndex.value == index;

//       return GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {
//           if (index == 4) {
//             controller.changePage(40); // Route mobile profile to Overview
//           } else {
//             controller.changePage(index);
//           }
//         },
//         child: SizedBox(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 height: 3,
//                 width: isSelected ? 28 : 0,
//                 decoration: BoxDecoration(
//                   gradient: Ucolors.backgroundGradient,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Icon(
//                 icon,
//                 size: 24,
//                 color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                   color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/personalization/presentation/widgets/document.dart';
import 'package:my_sip/features/personalization/presentation/widgets/help_support.dart';
import 'package:my_sip/features/personalization/presentation/widgets/personal_details.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:my_sip/config/routes/app_routes.dart';

// Screens imports (Replace with your actual paths)

import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/nominee_list.dart';

// =========================================
// 1. UPDATED CONTROLLER
// =========================================
class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();

  final RxInt selectedIndex = 0.obs;
  final RxBool isProfileExpanded = false.obs;
  final RxBool isHelpExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    _syncTabWithUrl();
  }

  void _syncTabWithUrl() {
    String currentRoute = Get.currentRoute;
    if (currentRoute.contains(AppRoutes.explorePage)) {
      selectedIndex.value = 1;
    } else if (currentRoute.contains(AppRoutes.dashBoardPage)) {
      selectedIndex.value = 2;
    } else if (currentRoute.contains(AppRoutes.goalScreen)) {
      selectedIndex.value = 3;
    } else if (currentRoute.contains(AppRoutes.profilePage)) {
      selectedIndex.value = 40;
      isProfileExpanded.value = true;
    } else {
      selectedIndex.value = 0;
    }
  }

  // 🚀 FIX: isDesktop parameter add kiya
  void changePage(int index, {bool isDesktop = true}) {
    // Agar "Profile" (Main Menu) par click kiya hai
    if (index == 4) {
      if (isDesktop) {
        // Web par sirf Accordion kholo/band karo. Screen change MAT karo.
        isProfileExpanded.value = !isProfileExpanded.value;
      } else {
        // Mobile par dropdown nahi hota, toh seedha Profile Overview (40) par bhej do
        selectedIndex.value = 40;
      }
      return; // Yahin se wapas laut jao, selectedIndex update mat hone do
    }

    if (selectedIndex.value == index) return;

    // Agar Home/Dashboard jaise kisi aur main tab par click kiya, toh Profile ka dropdown band kar do
    if (index < 4) {
      isProfileExpanded.value = false;
    }

    selectedIndex.value = index;
  }

  void navigateToExploreWithFilter(VoidCallback? filterLogic) {
    changePage(1);
    if (filterLogic != null) {
      filterLogic();
    }
  }

  bool get isProfileActive =>
      selectedIndex.value >= 40 && selectedIndex.value < 50;
}

// =========================================
// 2. MAIN LAYOUT WIDGET
// =========================================
class NavigationMenuBar extends StatelessWidget {
  const NavigationMenuBar({super.key});

  Future<bool> _showModernExitDialog(BuildContext context) async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierLabel: "ExitDialog",
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, anim1, anim2) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.info_circle,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Wait! Are you leaving?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Closing the app will pause your current session. Are you sure you want to exit?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Stay here',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Exit App',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationBarController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.selectedIndex.value != 0) {
          controller.changePage(0);
          return;
        }
        final shouldExit = await _showModernExitDialog(context);
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            // isDesktop
            //     ? _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet)
            //     : const SizedBox.shrink(),
            if (isDesktop || isTablet)
              _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet),
            Expanded(
              child: Column(
                children: [
                  if (isDesktop) const GlobalTopHeader(),
                  Expanded(
                    child: Obx(() {
                      switch (controller.selectedIndex.value) {
                        case 0:
                          return const HomeScreen();
                        case 1:
                          return const ExploreScreen();
                        case 2:
                          return DashboardScreen();
                        case 3:
                          return const GoalScreen();

                        // Profile Sub-categories
                        case 40:
                          return const ProfileScreen(); // Base profile or overview
                        case 41:
                          return const KycDetailsScreen();
                        case 42:
                          return PersonalDetailsScreen();
                        case 43:
                          return const BankDetailsScreen();
                        case 44:
                          return const NomineeListScreen();
                        case 45:
                          return const DocumentScreen();
                        // case 46:
                        //   return HelpSupportScreen();

                        // Help & Support

                        case 50:
                          return HtmlWebViewPage(
                            key: const ValueKey('contact'),
                            appBar: false,

                            title: 'Contact Support',
                            url:
                                'https://sip.londonstreetstore.com/contact-us?mobile=true',
                          );
                        case 51:
                          return HtmlWebViewPage(
                            appBar: false,
                            key: const ValueKey('privacy'),

                            title: 'Privacy Policy',
                            url:
                                'https://sip.londonstreetstore.com/privacy-policy?mobile=true',
                          );
                        case 52:
                          return HtmlWebViewPage(
                            appBar: false,
                            key: const ValueKey('terms'),

                            title: 'Terms & Conditions',
                            url:
                                'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true',
                          );
                        case 53:
                          return HtmlWebViewPage(
                            appBar: false,
                            key: const ValueKey('faq'),

                            title: 'FAQs',
                            url:
                                'https://sip.londonstreetstore.com/faq?mobile=true',
                          );
                        case 54:
                          return HtmlWebViewPage(
                            appBar: false,
                            key: const ValueKey('abouts'),

                            title: 'About Us',
                            url:
                                'https://sip.londonstreetstore.com/about-us?mobile=true',
                          );

                        default:
                          return const HomeScreen();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: (isDesktop) ? null : const _MobileBottomNavBar(),
      ),
    );
  }
}

class GlobalTopHeader extends StatelessWidget {
  const GlobalTopHeader({super.key});

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Home Overview';
      case 1:
        return 'Explore Funds';
      case 2:
        return 'My Dashboard';
      case 3:
        return 'My Goals';

      // Profile Section
      case 40:
        return 'Profile Overview';
      case 41:
        return 'KYC Details';
      case 42:
        return 'Personal Details';
      case 43:
        return 'Bank Account';
      case 44:
        return 'Nominee Details';
      case 45:
        return 'Documents';

      // Help & Support Section
      case 50:
        return 'Contact Support';
      case 51:
        return 'Privacy Policy';
      case 52:
        return 'Terms & Conditions';
      case 53:
        return 'FAQs';
      case 54:
        return 'About Us';

      default:
        return 'MF SIP';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final navController = Get.find<NavigationBarController>();
    final mutualController = Get.find<MutualFundController>();

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final title = _getPageTitle(navController.selectedIndex.value);
            return Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Ucolors.dark,
                letterSpacing: -0.5,
              ),
            );
          }),
          Row(
            children: [
              SizedBox(
                width: 300,
                height: 40,
                child: SearchBar(
                  // focusNode: searchFocus,
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFFF0F2F5),
                  ),
                  leading: const Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.grey,
                  ),
                  hintText: 'Search funds...',
                  // onChanged: (value) =>
                  //     mutualController.onSearchQueryChanged(value),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              // 🚀 Notification Icon
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notification),
                icon: const Icon(Iconsax.notification),
                color: Ucolors.darkgrey,
                hoverColor: Ucolors.primary.withOpacity(0.1),
              ),
              const SizedBox(width: 16),

              // 🚀 Cart Icon with Badge
              Obx(
                () => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.shopping_cart),
                      color: Ucolors.darkgrey,
                      hoverColor: Ucolors.primary.withOpacity(0.1),
                      onPressed: () {
                        cartController.filterGoalId.value = null;
                        Get.toNamed(AppRoutes.cart);
                      },
                    ),
                    if (cartController.generalItemsCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Ucolors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartController.generalItemsCount.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // 🚀 Watchlist/Bookmark Icon
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.watchlist),
                icon: const Icon(Iconsax.archive_tick),
                color: Ucolors.darkgrey,
                hoverColor: Ucolors.primary.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================
// 3. DESKTOP NAV WITH ACCORDION
// =========================================
class _DesktopSideNav extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const _DesktopSideNav({required this.isDesktop, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.userObs.value;
    final controller = NavigationBarController.instance;
    final width = isDesktop ? 280.0 : 80.0;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: isDesktop ? 24 : 16,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(UImages.imp, fit: BoxFit.contain),
                    ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: 12),
                    const Text(
                      'MF SIP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: Ucolors.dark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     vertical: 24,
            //     horizontal: isDesktop ? 24 : 16,
            //   ),
            //   child: Row(
            //     children: [
            //       Container(
            //         width: 40,
            //         height: 40,
            //         padding: EdgeInsets.all(3),
            //         decoration: BoxDecoration(
            //           // shape: BoxShape.circle,
            //           // gradient: Ucolors.backgroundGradient,
            //           // color: Ucolors.skyblue,
            //           // borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Image.asset(UImages.imp),
            //         // Icon(
            //         //   Icons.trending_up,
            //         //   color: Colors.white,
            //         //   size: 24,
            //         // ),
            //       ),
            //       if (isDesktop) ...[
            //         const SizedBox(width: 12),
            //         const Text(
            //           'MF SIP',
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w700,
            //             color: Ucolors.dark,
            //           ),
            //         ),
            //       ],
            //     ],
            //   ),
            // ),
            // if (isDesktop)
            //   Padding(
            //     padding: const EdgeInsets.only(left: 16, bottom: 8),
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: Text(
            //         "Generals",
            //         style: TextStyle(
            //           fontSize: 11,
            //           color: Colors.grey.shade500,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8),
                child: Column(
                  children: [
                    // --- Main Items ---
                    Obx(
                      () => _buildNavItem(
                        controller,
                        0,
                        Iconsax.home,
                        'Home',
                        isDesktop,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        1,
                        Icons.trending_up,
                        'Explore',
                        isDesktop,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        2,
                        Iconsax.chart_1,
                        'Dashboard',
                        isDesktop,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        3,
                        Iconsax.cup,
                        'Goal',
                        isDesktop,
                      ),
                    ),

                    const SizedBox(height: 16),
                    if (isDesktop)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "SETTINGS",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // --- Profile Item (Expandable) ---
                    Obx(() {
                      final isProfileActive = controller.isProfileActive;
                      final isExpanded = controller.isProfileExpanded.value;

                      return Column(
                        children: [
                          _DesktopNavItem(
                            icon: Iconsax.user4,
                            label: 'Profile',
                            // Highlight if either a sub-page is active OR the accordion is expanded
                            // isSelected: isProfileActive || isExpanded,
                            isSelected: false,
                            isDesktop: isDesktop,
                            trailing: isDesktop
                                ? Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: (isProfileActive || isExpanded)
                                        ? Ucolors.blue
                                        : Ucolors.darkgrey,
                                    size: 18,
                                  )
                                : null,
                            // 🚀 FIX: isDesktop parameter pass kiya
                            onTap: () =>
                                controller.changePage(4, isDesktop: isDesktop),
                          ),

                          if (isDesktop)
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Container(
                                margin: const EdgeInsets.only(
                                  left: 36,
                                  top: 4,
                                  bottom: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSubItem(
                                      controller,
                                      40,
                                      "Profile Overview",
                                    ),
                                    _buildSubItem(
                                      controller,
                                      41,
                                      "KYC Details",
                                    ),
                                    _buildSubItem(
                                      controller,
                                      42,
                                      "Personal Details",
                                    ),
                                    _buildSubItem(
                                      controller,
                                      43,
                                      "Bank Account",
                                    ),
                                    _buildSubItem(
                                      controller,
                                      44,
                                      "Nominee Details",
                                    ),
                                    _buildSubItem(controller, 45, "Documents"),
                                    // _buildSubItem(
                                    //   controller,
                                    //   46,
                                    //   "Help & Support",
                                    // ),
                                    // _buildSubItem(controller, 47, "About Us"),
                                  ],
                                ),
                              ),
                              secondChild: const SizedBox.shrink(),
                            ),
                        ],
                      );
                    }),

                    // =========================================
                    // 🔥 NAYA: HELP & SUPPORT ACCORDION
                    // =========================================
                    Obx(() {
                      // Maan lete hain Help ke sub-pages ka index 50 se 54 tak hai
                      final isHelpActive =
                          controller.selectedIndex.value >= 50 &&
                          controller.selectedIndex.value <= 54;
                      final isHelpExpanded = controller.isHelpExpanded.value;

                      return Column(
                        children: [
                          _DesktopNavItem(
                            icon: Iconsax.support, // Support icon
                            label: 'Help & Support',
                            isSelected: false,
                            isDesktop: isDesktop,
                            trailing: isDesktop
                                ? Icon(
                                    isHelpExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: (isHelpActive || isHelpExpanded)
                                        ? Ucolors.blue
                                        : Ucolors.darkgrey,
                                    size: 18,
                                  )
                                : null,
                            onTap: () {
                              // Click karne par bas Dropdown open/close hoga
                              controller.isHelpExpanded.value =
                                  !controller.isHelpExpanded.value;
                            },
                          ),

                          if (isDesktop)
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isHelpExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Container(
                                margin: const EdgeInsets.only(
                                  left: 36,
                                  top: 4,
                                  bottom: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Har item ko ek unique index diya hai (50 se 54)
                                    _buildSubItem(
                                      controller,
                                      50,
                                      "Contact Support",
                                    ),
                                    _buildSubItem(
                                      controller,
                                      51,
                                      "Privacy Policy",
                                    ),
                                    _buildSubItem(
                                      controller,
                                      52,
                                      "Terms & Conditions",
                                    ),
                                    _buildSubItem(controller, 53, "FAQs"),
                                    _buildSubItem(controller, 54, "About Us"),
                                  ],
                                ),
                              ),
                              secondChild: const SizedBox.shrink(),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            if (isDesktop)
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // CircleAvatar(
                        //   radius: 20,
                        //   backgroundImage: AssetImage(UImages.avatar),
                        // ),
                        UCircularImage(
                          radius: 20,
                          image:
                              user?.img ??
                              '', // Ya user?.img (Apne model ke hisab se)
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  log(user?.img ?? '');
                                },
                                child: Text(
                                  user?.name ?? 'Guest User',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 15),
                    // LogoutButton(web: true),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    NavigationBarController controller,
    int index,
    IconData icon,
    String label,
    bool isDesktop,
  ) {
    return _DesktopNavItem(
      icon: icon,
      label: label,
      isSelected: controller.selectedIndex.value == index,
      isDesktop: isDesktop,
      onTap: () => controller.changePage(index, isDesktop: isDesktop),
    );
  }

  Widget _buildSubItem(
    NavigationBarController controller,
    int index,
    String label,
  ) {
    final isSelected = controller.selectedIndex.value == index;
    return InkWell(
      onTap: () => controller.changePage(index), // isDesktop default true hai
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Ucolors.blue : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

// Custom Nav Item Widget
class _DesktopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDesktop;
  final VoidCallback onTap;
  final Widget? trailing;

  const _DesktopNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDesktop,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: isDesktop ? 16 : 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? Ucolors.blue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Ucolors.blue.withOpacity(0.2)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 4. MOBILE BOTTOM NAV
class _MobileBottomNavBar extends StatelessWidget {
  const _MobileBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: kBottomNavigationBarHeight + 20,
        padding: const EdgeInsets.only(top: 6, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _MobileNavItem(index: 0, icon: Iconsax.home, label: 'Home'),
            _MobileNavItem(index: 1, icon: Icons.trending_up, label: 'Explore'),
            _MobileNavItem(index: 2, icon: Iconsax.chart_1, label: 'Dashboard'),
            _MobileNavItem(index: 3, icon: Iconsax.cup, label: 'Goal'),
            _MobileNavItem(index: 4, icon: Iconsax.user4, label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;

  const _MobileNavItem({
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final controller = NavigationBarController.instance;

    return Obx(() {
      final bool isSelected = index == 4
          ? controller.isProfileActive
          : controller.selectedIndex.value == index;

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 🚀 FIX: Mobile ke click par isDesktop: false bhejna hai
          controller.changePage(index, isDesktop: false);
        },
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                width: isSelected ? 28 : 0,
                decoration: BoxDecoration(
                  gradient: Ucolors.backgroundGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),
              Icon(
                icon,
                size: 24,
                color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
