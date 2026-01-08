import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/features/mf/screen/dashboard/dashboard.dart';
import 'package:my_sip/features/mf/screen/explore/explore.dart';
import 'package:my_sip/features/mf/screen/goal/goal.dart';
import 'package:my_sip/features/mf/screen/home/home.dart';
import 'package:my_sip/features/personalization/screen/profile/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

/// ================= CONTROLLER =================
class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    //Home Screen
    HomeScreen(),

    //Explore Screen
    ExploreScreen(),

    //Dashboard
    DashboardScreen(),

    //Goal Screen
    GoalScreen(),

    //Profile Screen
    ProfileScreen(),
  ];
}

/// ================= MAIN =================
class NavigationMenuBar extends StatelessWidget {
  const NavigationMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationBarController());

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: const _CustomBottomNavBar(),
    );
  }
}

/// ================= CUSTOM NAV BAR =================
class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: kBottomNavigationBarHeight + 20,
        padding: EdgeInsets.only(top: 6, bottom: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navItems.length,
            (index) => _NavItem(index: index),
          ),
        ),
      ),
    );
  }
}

/// ================= NAV ITEM  =================
class _NavItem extends StatelessWidget {
  final int index;
  const _NavItem({required this.index});

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
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
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
