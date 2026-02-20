import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:my_sip/services/session_manager.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'config/routes/app_pages.dart';
import 'core/utils/constant/images.dart';

class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();
  final RxInt selectedIndex = 0.obs;

  void changePage(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;

    // Use id: 1 to navigate inside the nested area
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.home, id: 1);
        break;
      case 1:
        Get.toNamed(AppRoutes.explorePage, id: 1);
        break;
      case 2:
        Get.toNamed(AppRoutes.dashBoardPage, id: 1);
        break;
      case 3:
        Get.toNamed(AppRoutes.goalScreen, id: 1);
        break;
      case 4:
        Get.toNamed(AppRoutes.profilePage, id: 1);
        break; // or AppRoutes.profile
    }
  }
}

class NavigationMenuBar extends StatelessWidget {
  const NavigationMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is loaded
    final controller = Get.put(NavigationBarController());

    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet),

          Expanded(
            child: Navigator(
              key: Get.nestedKey(
                1,
              ), // Ensure this matches controller.changePage logic
              initialRoute: AppRoutes.home,
              onGenerateRoute: (settings) {
                // Look up the route in your existing AppPages
                try {
                  final getPage = AppPages.pages().firstWhere(
                    (p) => p.name == settings.name,
                  );

                  return GetPageRoute(
                    page: getPage.page,
                    binding: getPage.binding,
                    bindings: getPage.bindings,
                    settings: settings,
                    transition:
                        Transition.fadeIn, // Optional: smoother tab switch
                  );
                } catch (e) {
                  // Fallback if route not found in AppPages
                  return GetPageRoute(
                    page: () => HomeScreen(),
                    settings: settings,
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: (isDesktop) ? null : const _MobileBottomNavBar(),
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
