import 'package:get/get.dart';
import 'package:my_sip/features/authentication/presentation/bindings/auth_binding.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
import 'package:my_sip/features/freedom_sip/presentation/pages/freedom_sip_screen.dart';
import 'package:my_sip/features/freedom_sip/presentation/pages/sip_tenure_screen.dart';
import 'package:my_sip/features/mf/screen/home/home.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/compare_fund.dart';
import 'package:my_sip/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import '../../features/freedom_sip/presentation/pages/accumulationAndDistributionScreen.dart';
import '../../features/freedom_sip/presentation/pages/growth_scheme_screen.dart';
import 'app_routes.dart';

class AppPages {
  static pages() => [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(
      name: AppRoutes.navMenuBar,
      page: () => const NavigationMenuBar(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.freedomSipScreen,
      page: () => const FreedomSipScreen(),
    ),
    GetPage(name: AppRoutes.comparefund, page: () => CompareFundsPage()),
    GetPage(
      name: AppRoutes.sipTenureScreen,
      page: () => const SipTenureScreen(),
    ),
    GetPage(
      name: AppRoutes.growthSchemeScreen,
      page: () => const GrowthSchemeScreen(),
    ),
    GetPage(
      name: AppRoutes.accumulationanddistributionscreen,
      page: () => const Accumulationanddistributionscreen(),
    ),
  ];
}
