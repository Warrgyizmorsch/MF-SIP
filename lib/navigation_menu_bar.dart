import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

import 'core/utils/constant/images.dart';

class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();
  final RxInt selectedIndex = 0.obs;
  final mutualFundController = Get.find<MutualFundController>();
  final cartController = Get.find<CartController>();

  @override
  void onInit() {
    // mutualFundController.fetchMutualFund();
    mutualFundController.fetchData();
    cartController.fetchCart();
    super.onInit();
  }

  final List<Widget> screens = [
    HomeScreen(),
    ExploreScreen(),
    DashboardScreen(),
    GoalScreen(),
    ProfileScreen(),
  ];
}

class NavigationMenuBar extends StatelessWidget {
  const NavigationMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationBarController());
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _DesktopSideNav(isDesktop: isDesktop, isTablet: isTablet),

          Expanded(
            child: Obx(
              () => controller.screens[controller.selectedIndex.value],
            ),
          ),
        ],
      ),

      bottomNavigationBar: (isDesktop)
          ? null
          : const _MobileBottomNavBar(),
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
              child: isDesktop
                  ? Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: Ucolors.backgroundGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
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
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: Ucolors.backgroundGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 24,
                      ),
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
                      onTap: () => controller.selectedIndex.value = index,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'mhgjh',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black
                              ),
                            ),
                            // Text(
                            //   user?.status ?? '',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey.shade600,
                            //   ),
                            // ),
                          ],
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
        onTap: () => controller.selectedIndex.value = index,
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
