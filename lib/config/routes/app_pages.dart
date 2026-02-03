import 'package:get/get.dart';
import 'package:my_sip/core/bindings/bindings.dart';
import 'package:my_sip/features/authentication/presentation/bindings/auth_binding.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/otp_verification.dart';
import 'package:my_sip/features/authentication/presentation/pages/signup/register_account.dart';
import 'package:my_sip/features/explore/presentation/bindings/fundhousebinding.dart';
import 'package:my_sip/features/explore/presentation/pages/filterpage.dart';
import 'package:my_sip/features/freedom_sip/presentation/pages/freedom_sip_screen.dart';
import 'package:my_sip/features/freedom_sip/presentation/pages/sip_tenure_screen.dart';
import 'package:my_sip/features/fund_details/presentation/bindings/fund_detail_binding.dart';
import 'package:my_sip/features/goal/presentation/pages/goaldetails.dart';
import 'package:my_sip/features/goal/presentation/pages/goalsuccess.dart';
import 'package:my_sip/features/goal/presentation/pages/goalviewcard.dart';
import 'package:my_sip/features/goal/presentation/pages/ihavegoal.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:my_sip/features/personalization/presentation/bindings/BankBinding.dart';
import 'package:my_sip/features/personalization/presentation/pages/add_another_bank.dart';
import 'package:my_sip/features/sip_process/presentation/pages/payment_screen.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import '../../features/freedom_sip/presentation/pages/accumulationAndDistributionScreen.dart';
import '../../features/freedom_sip/presentation/pages/growth_scheme_screen.dart';
import '../../features/fund_details/presentation/pages/fund_deatails.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/pages/notification_page.dart';
import '../../features/home/presentation/pages/watchlist_page.dart';
import '../../features/home/presentation/widgets/product_tool/compare_fund.dart';
import '../../features/personalization/presentation/widgets/personal_details.dart';
import '../../features/sip_process/presentation/bindings/sip_process_binding.dart';
import '../../features/sip_process/presentation/pages/investing_approach_screen.dart';
import '../../features/sip_process/presentation/pages/monthly_sip_screen.dart';
import '../../features/sip_process/presentation/pages/select_funds_screen.dart';
import 'app_routes.dart';

class AppPages {
  static pages() => [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.home, page: () =>  HomeScreen(),),
    GetPage(
      binding: UBinding(),
      name: AppRoutes.navMenuBar,
      page: () => const NavigationMenuBar(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.registerAccountScreen,
      page: () => const RegisterAccountScreen(),
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
      name: AppRoutes.funddetails,
      page: () => const FundDetailsScreen(),
      binding:  FundDetailBinding()
    ),
    GetPage(name: AppRoutes.watchlist, page: () => WatchlistPage()),
    GetPage(name: AppRoutes.cart, page: () => CartPage()),
    GetPage(name: AppRoutes.notification, page: () => NotificationPage()),
    GetPage(
      name: AppRoutes.accumulationanddistributionscreen,
      page: () => const Accumulationanddistributionscreen(),
    ),
    GetPage(
      name: AppRoutes.startSipScreen,
      page: () => const MonthlySipScreen(),
      binding: SipProcessBinding()
    ),

    GetPage(
      name: AppRoutes.investingApproachScreen,
      page: () => const InvestingApproachScreen(),
    ),
    GetPage(
      name: AppRoutes.selectFundsScreen,
      page: () => const SelectFundsScreen(),
      binding: SipProcessBinding(),
    ),

    GetPage(
      name: AppRoutes.personaldetails,
      page: () => PersonalDetailsScreen(),
    ),
    GetPage(name: AppRoutes.ihavegoal, page: () => IhavegoalPage()),
    GetPage(
      name: AppRoutes.successfullcreategoal,
      page: () => GoalsuccessPage(),
    ),
    GetPage(name: AppRoutes.goalviewcard, page: () => GoalviewcardPage()),
    GetPage(name: AppRoutes.goaldetails, page: () => GoaldetailsPage()),

    GetPage(
      name: AppRoutes.addanotherbank,
      page: () => AddAnotherBankPage(),
      binding: Bankbinding(),
    ),

    GetPage(
      name: AppRoutes.filterpage,
      page: () => Filterpage(),
      binding: Fundhousebinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => OtpVerificationScreen(),
      binding: AuthBinding(),
    ),

    GetPage(name: AppRoutes.paymentScreen, page: () => PaymentScreen()),
  ];
}
