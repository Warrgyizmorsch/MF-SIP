import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:my_sip/services/session_manager.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'config/routes/app_pages.dart';
import 'core/utils/constant/images.dart';

class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();

  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // URL syncing won't apply to nested widgets, but it's safe to leave this
    // if you handle deep links manually later.
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
      selectedIndex.value = 4;
    } else {
      selectedIndex.value = 0;
    }
  }

  void changePage(int index) {
    if (selectedIndex.value == index) return;
    // We NO LONGER use Get.offNamed.
    // Just change the value, and the Obx in the UI will instantly swap the widget.
    selectedIndex.value = index;
  }

  void navigateToExploreWithFilter(VoidCallback? filterLogic) {
    changePage(1);
    // Get.toNamed(AppRoutes.explorePage);
    if (filterLogic != null) {
      filterLogic();
    }
  }
}

// class NavigationBarController extends GetxController {
//   static NavigationBarController get instance => Get.find();

//   @override
//   void onInit() {
//     super.onInit();
//     _syncTabWithUrl();
//   }

//   final RxInt selectedIndex = 0.obs;

//   void _syncTabWithUrl() {
//     // Read the exact URL the user typed in the browser
//     String currentRoute = Get.currentRoute;

//     // Change the active tab based on the URL string.
//     // We use .contains() instead of == just in case there are query parameters (like ?fundId=123)
//     if (currentRoute.contains(AppRoutes.explorePage)) {
//       selectedIndex.value = 1;
//     } else if (currentRoute.contains(AppRoutes.dashBoardPage)) {
//       selectedIndex.value = 2;
//     } else if (currentRoute.contains(AppRoutes.goalScreen)) {
//       selectedIndex.value = 3;
//     } else if (currentRoute.contains(AppRoutes.profilePage)) {
//       selectedIndex.value = 4;
//     } else {
//       selectedIndex.value = 0; // Default to Home
//     }
//   }

//   void changePage(int index) {
//     if (selectedIndex.value == index) return;
//     selectedIndex.value = index;

//     // Use id: 1 to navigate inside the nested area
//     switch (index) {
//       case 0:
//         Get.off(AppRoutes.home, id: 1);
//         // Get.toNamed(AppRoutes.home, id: 1);
//         break;
//       case 1:
//         Get.off(AppRoutes.explorePage, id: 1);
//         break;
//       case 2:
//         Get.off(AppRoutes.dashBoardPage, id: 1);
//         break;
//       case 3:
//         Get.off(AppRoutes.goalScreen, id: 1);
//         break;
//       case 4:
//         Get.off(AppRoutes.profilePage, id: 1);
//         break; // or AppRoutes.profile
//     }
//   }

//   // Inside NavigationBarController
//   void navigateToExploreWithFilter(VoidCallback? filterLogic) {
//     // 1. Update the UI state for the Nav Bar
//     changePage(1);

//     // 2. Execute the specific filter logic
//     if (filterLogic != null) {
//       filterLogic();
//     }
//   }
// }

class NavigationMenuBar extends StatelessWidget {
  const NavigationMenuBar({super.key});

  Future<bool> _showModernExitDialog(BuildContext context) async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierLabel: "ExitDialog",
          barrierColor: Colors.black.withOpacity(
            0.5,
          ), // Semi-transparent overlay
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, anim1, anim2) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ), // Adjust blur intensity here
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.9,
                    ), // Slightly transparent white
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
                        // Warning Icon with soft glow
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

                        // Action Buttons
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
    // Ensure the controller is loaded
    // final controller = Get.put(NavigationBarController());
    final controller = Get.find<NavigationBarController>();

    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return PopScope(
      canPop: false, // Prevents the default back button behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // If user is NOT on the Home tab (index 0), navigate to Home first
        if (controller.selectedIndex.value != 0) {
          controller.changePage(0);
          return;
        }

        // If already on Home tab, show the exit warning
        final shouldExit = await _showModernExitDialog(context);
        if (shouldExit) {
          // This closes the app
          SystemNavigator.pop();
        }
      },

      child: Scaffold(
        body: Row(
          // key: const ValueKey('MainNavigationRow'),
          children: [
            // if (isDesktop)
            //   _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet),
            isDesktop
                ? _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet)
                : const SizedBox.shrink(),

            Expanded(
              // THE ULTIMATE FIX:
              // We use Obx to dynamically return the exact screen widget based on the index.
              // No GetX router, no nested keys, impossible to duplicate!
              child: Obx(() {
                switch (controller.selectedIndex.value) {
                  case 0:
                    return HomeScreen();
                  case 1:
                    return ExploreScreen();
                  case 2:
                    return DashboardScreen();
                  case 3:
                    return GoalScreen();
                  case 4:
                    return ProfileScreen();
                  default:
                    return HomeScreen();
                }
              }),
            ),

            // Expanded(
            //   child: Navigator(
            //     key: Get.nestedKey(
            //       1,
            //     ), // Ensure this matches controller.changePage logic
            //     initialRoute: AppRoutes.home,
            //     onGenerateRoute: (settings) {
            //       // Look up the route in your existing AppPages
            //       try {
            //         final getPage = AppPages.pages().firstWhere(
            //           (p) => p.name == settings.name,
            //         );

            //         return GetPageRoute(
            //           page: getPage.page,
            //           binding: getPage.binding,
            //           bindings: getPage.bindings,
            //           settings: settings,
            //           transition:
            //               Transition.fadeIn, // Optional: smoother tab switch
            //         );
            //       } catch (e) {
            //         // Fallback if route not found in AppPages
            //         return GetPageRoute(
            //           page: () => HomeScreen(),
            //           settings: settings,
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
        bottomNavigationBar: (isDesktop) ? null : const _MobileBottomNavBar(),
      ),
    );
  }
}

class _DesktopSideNav extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const _DesktopSideNav({required this.isDesktop, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.getUserData;
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
                    decoration: BoxDecoration(
                      gradient: Ucolors.backgroundGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: 12),
                    Text(
                      'My SIP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Ucolors.dark,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8),
                itemCount: _navItems.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected = controller.selectedIndex.value == index;
                    return _DesktopNavItem(
                      item: _navItems[index],
                      isSelected: isSelected,
                      isDesktop: isDesktop,
                      onTap: () => controller.changePage(index), // UPDATED
                    );
                  });
                },
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
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(UImages.avatar),
                        ),

                        // UCircularImage(image: user?.img ?? ''),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Guest User',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
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
}

class _DesktopNavItem extends StatelessWidget {
  final _NavItemData item;
  final bool isSelected;
  final bool isDesktop;
  final VoidCallback onTap;

  const _DesktopNavItem({
    required this.item,
    required this.isSelected,
    required this.isDesktop,
    required this.onTap,
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
                  item.icon,
                  size: 24,
                  color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          children: List.generate(
            _navItems.length,
            (index) => _MobileNavItem(index: index),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final int index;
  const _MobileNavItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = NavigationBarController.instance;

    return Obx(() {
      final bool isSelected = controller.selectedIndex.value == index;
      final item = _navItems[index];

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        // UPDATED: Use changePage to trigger Get.toNamed
        onTap: () => controller.changePage(index),
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
                item.icon,
                size: 24,
                color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
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

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData(this.icon, this.label);
}

const List<_NavItemData> _navItems = [
  _NavItemData(Iconsax.home, 'Home'),
  _NavItemData(Icons.trending_up, 'Explore'),
  _NavItemData(Iconsax.chart_1, 'Dashboard'),
  _NavItemData(Iconsax.cup, 'Goal'),
  _NavItemData(Iconsax.user4, 'Profile'),
];
