import 'package:get/get.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/core/bindings/bindings.dart';
import 'package:my_sip/features/authentication/presentation/bindings/auth_binding.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/login_page.dart';
import 'package:my_sip/features/authentication/presentation/pages/login/otp_verification.dart';
import 'package:my_sip/features/authentication/presentation/pages/signup/register_account.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/explore/presentation/bindings/fundhousebinding.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/explore/presentation/pages/filterpage.dart';
import 'package:my_sip/features/freedom_sip/presentation/pages/freedom_sip_screen.dart';
import 'package:my_sip/features/freedom_sip/presentation/pages/sip_tenure_screen.dart';
import 'package:my_sip/features/fund_details/presentation/bindings/fund_detail_binding.dart';
import 'package:my_sip/features/goal/presentation/bindings/goal_binding.dart';
import 'package:my_sip/features/goal/presentation/pages/coming_soon.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/goal/presentation/pages/goaldetails.dart';
import 'package:my_sip/features/goal/presentation/pages/goalsuccess.dart';
import 'package:my_sip/features/goal/presentation/pages/goalviewcard.dart';
import 'package:my_sip/features/goal/presentation/pages/ihavegoal.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/home/presentation/pages/video_list_page.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/sip_calculator.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/swp_calci.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/top_up_calculator.dart';
import 'package:my_sip/features/kyc/presentation/binding/kyc_bindings.dart';
import 'package:my_sip/features/kyc/presentation/pages/kyc_screen.dart';
import 'package:my_sip/features/nfo/presentation/bindings/nfo_list_binding.dart';
import 'package:my_sip/features/nfo/presentation/page/nfo_details_page.dart';
import 'package:my_sip/features/nfo/presentation/page/nfo_list_page.dart';
import 'package:my_sip/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:my_sip/features/personalization/presentation/bindings/personalisation_binding.dart';
import 'package:my_sip/features/personalization/presentation/pages/add_another_bank.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/features/personalization/presentation/pages/risk_profile.dart';
import 'package:my_sip/features/personalization/presentation/widgets/additional_info.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/document.dart';
import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/nominee_list.dart';
import 'package:my_sip/features/sip_process/presentation/pages/payment_screen.dart';
import 'package:my_sip/features/wishlist/presentation/bindings/wishlist_binding.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import '../../features/freedom_sip/presentation/pages/accumulationAndDistributionScreen.dart';
import '../../features/freedom_sip/presentation/pages/growth_scheme_screen.dart';
import '../../features/fund_details/presentation/pages/fund_deatails.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/presentation/binding/home_bindings.dart';
import '../../features/home/presentation/pages/notification_page.dart';
import '../../features/wishlist/presentation/pages/watchlist_page.dart';
import '../../features/home/presentation/widgets/product_tool/compare_fund.dart';
import '../../features/personalization/presentation/widgets/nominee_details.dart';
import '../../features/personalization/presentation/widgets/personal_details.dart';
import '../../features/sip_process/presentation/bindings/sip_process_binding.dart';
import '../../features/sip_process/presentation/pages/investing_approach_screen.dart';
import '../../features/sip_process/presentation/pages/monthly_sip_screen.dart';
import '../../features/sip_process/presentation/pages/select_funds_screen.dart';
import 'app_routes.dart';

class AppPages {
  static pages() => [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),

    GetPage(
      bindings: [
        UBinding(),
        PersonalisationBinding(),
        // Bankbinding(),
        Fundhousebinding(),
        WishlistBinding(),
        // SipProcessBinding(),
        GoalBinding(),
      ],
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
    GetPage(
      name: AppRoutes.comparefund,
      page: () => CompareFundsPage(),
      binding: FundDetailBinding(),
    ),
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
      page: () => FundDetailsScreen(),
      binding: FundDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.watchlist,
      page: () => WatchlistPage(),
      binding: WishlistBinding(),
    ),
    GetPage(name: AppRoutes.cart, page: () => CartPage()),
    GetPage(name: AppRoutes.notification, page: () => NotificationPage(), binding:HomeBindings() ),
    GetPage(
      name: AppRoutes.accumulationanddistributionscreen,
      page: () => const Accumulationanddistributionscreen(),
    ),
    GetPage(
      name: AppRoutes.startSipScreen,
      page: () => const MonthlySipScreen(),
      binding: SipProcessBinding(),
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
    GetPage(
      name: AppRoutes.ihavegoal,
      page: () => IhavegoalPage(),
      binding: GoalBinding(),
    ),
    GetPage(
      name: AppRoutes.goalScreen,
      page: () => GoalScreen(),
      binding: GoalBinding(),
    ),
    GetPage(
      name: AppRoutes.successfullcreategoal,
      page: () => GoalsuccessPage(),
    ),
    GetPage(name: AppRoutes.goalviewcard, page: () => GoalviewcardPage()),
    GetPage(name: AppRoutes.goaldetails, page: () => GoaldetailsPage()),

    GetPage(
      name: AppRoutes.addanotherbank,
      page: () => AddAnotherBankPage(),
      // binding: Bankbinding(),
    ),
    GetPage(
      name: AppRoutes.riskProfile,
      page: () => RiskProfile(),
      binding: PersonalisationBinding(),
    ),

    GetPage(
      name: AppRoutes.filterpage,
      page: () => Filterpage(),
      // binding: Fundhousebinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => OtpVerificationScreen(),
      binding: AuthBinding(),
    ),

    GetPage(name: AppRoutes.paymentScreen, page: () => PaymentScreen()),
    GetPage(name: AppRoutes.explorePage, page: () => ExploreScreen()),
    GetPage(name: AppRoutes.dashBoardPage, page: () => DashboardScreen()),
    GetPage(name: AppRoutes.profilePage, page: () => ProfileScreen()),
    GetPage(
      name: AppRoutes.kycScreen,
      page: () => KycScreen(),
      binding: KycBindings(),
    ),
    GetPage(name: AppRoutes.webView, page: () => HtmlWebViewPage()),
    GetPage(
      name: AppRoutes.nomineeList,
      page: () => NomineeListScreen(),
      binding: PersonalisationBinding(),
    ),
    GetPage(
      name: AppRoutes.nomineeDetail,
      page: () => NomineeDetailsScreen(),
      binding: PersonalisationBinding(),
    ),
    GetPage(
      name: AppRoutes.nfolist,
      page: () => NfoListPage(),
      binding: NfoListBinding(),
    ),
    GetPage(name: AppRoutes.nfodetailsPage, page: () => NfoDetailsPage1()),
    GetPage(name: AppRoutes.kycDeatailScreen, page: () => KycDetailsScreen()),
    GetPage(name: AppRoutes.documentsScreen, page: () => DocumentScreen()),

    GetPage(name: AppRoutes.sipCalculator, page: () => SipCalculatorPage()),
    GetPage(name: AppRoutes.swpCalculator, page: () => SwpCalciScreen()),
    GetPage(
      name: AppRoutes.stepUpCalculator,
      page: () => TopUpCalculatorPage(),
    ),
    GetPage(name: AppRoutes.comingSoon, page: () => ComingSoon()),
    GetPage(name: AppRoutes.bankDetails, page: () => BankDetailsScreen()),
    GetPage(name: AppRoutes.videoList, page: () => VideoListScreen()),

    GetPage(name: AppRoutes.additionalInfo, page: () => AdditionalInfoScreen()),
  ];
}
