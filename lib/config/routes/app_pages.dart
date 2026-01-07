import 'package:get/get.dart';
import 'package:my_sip/features/authentication/presentation/bindings/auth_binding.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
import 'package:my_sip/features/mf/screen/home/compare_fund.dart';
import 'package:my_sip/features/mf/screen/home/home.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.comparefund,
      page: () => const FundComparisonScreen(),
    ),
  ];
}
