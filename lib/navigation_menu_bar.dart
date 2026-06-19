// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import 'package:my_sip/common/widget/animated/custom_footer.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/common/widget/webview/webview.dart';
import 'package:my_sip/config/routes/app_pages.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/dashboard/presentation/pages/dashboard.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/explore/presentation/widget/webfilterpage.dart';
import 'package:my_sip/features/goal/presentation/pages/goal.dart';
import 'package:my_sip/features/home/presentation/pages/home.dart';
import 'package:my_sip/features/kyc/data/datasource/kyc_remote_data_source.dart';
import 'package:my_sip/features/kyc/presentation/controllers/kyc_controller.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/personalization/presentation/widgets/document.dart';
import 'package:my_sip/features/personalization/presentation/widgets/personal_details.dart';
import 'package:my_sip/features/sip_process/presentation/controllers/sip_process_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:my_sip/config/routes/app_routes.dart';

import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/features/personalization/presentation/widgets/kyc_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';
import 'package:my_sip/features/personalization/presentation/widgets/nominee_list.dart';

class NavigationBarController extends GetxController {
  static NavigationBarController get instance => Get.find();
  final PersonalisationController personalisationController = Get.find();

  final RxInt selectedIndex = 0.obs;
  final RxBool isProfileExpanded = false.obs;
  final RxBool isHelpExpanded = false.obs;
  final RxBool isInvestExpanded = false.obs;
  Timer? _camsPollingTimer;

  @override
  void onInit() {
    super.onInit();
    _syncTabWithUrl();
    if (SessionManager.instance.isKycPending.value) {
      _startBackgroundCamsCheck();
    }
  }

  void _startBackgroundCamsCheck() {
    _checkCamsStatusSilently();
    _camsPollingTimer = Timer.periodic(const Duration(seconds: 30), (
      timer,
    ) async {
      await _checkCamsStatusSilently();
    });
  }

  Future<void> _checkCamsStatusSilently() async {
    final onboardingId =
        SessionManager.instance.getOnboardingData?.onboardingId ??
        SessionManager.instance.onboardingRespone.value?.onboardingId;

    // Grab the user ID to send to the backend
    final userId = SessionManager.instance.getUserData?.id;

    // Safety check: Ensure we have both IDs before making calls
    if (onboardingId == null || onboardingId.isEmpty || userId == null) {
      _camsPollingTimer?.cancel();
      return;
    }

    try {
      final currentToken = SessionManager.instance.tokenDataModel.value?.id;
      if (currentToken == null || currentToken.isEmpty) {
        debugPrint("[CAMS Check] Token missing. Fetching now...");
        if (Get.isRegistered<KycController>()) {
          final bool gotToken = await Get.find<KycController>().getTokenData();

          // If it STILL fails here, we abort the silent check and try again later.
          if (!gotToken) {
            debugPrint("[CAMS Check] Failed to get token. Aborting check.");
            return;
          }
        }
      }
      final kycDataSource = Get.find<KycRemoteDataSource>();
      final String status = await kycDataSource.checkCamsStatus(onboardingId);
      final statusLower = status.toLowerCase();

      //  SUCCESS
      if (statusLower == "success" || statusLower == "approved") {
        _camsPollingTimer?.cancel();

        await SessionManager.instance.handleKycApproved();

        // 2. Update UI instantly!
        if (Get.isRegistered<PersonalisationController>()) {
          final controller = Get.find<PersonalisationController>();
          controller.isKycPending.value = false;
          controller.isKycVerified.value = true;
        }

        // 🚀 3. SYNC WITH BACKEND
        final updateData = {'id': userId, 'kyc_status': 'Approved'};
        // Fire and forget (or await if you want to be totally safe)
        await Get.find<PersonalisationController>()
            .useCases
            .updateProfileUsecases
            .call(updateData);

        Get.snackbar(
          "KYC Approved! 🎉",
          "Your account is fully verified. You can now start investing.",
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
        );
      }
      // ❌ REJECTED
      else if (statusLower == "rejected" ||
          statusLower == "failed" ||
          statusLower == "fail") {
        _camsPollingTimer?.cancel();

        // 1. Update Device Storage
        await SessionManager.instance.setKycPending(false);
        await SessionManager.instance.setKycVerified(false);

        // 2. Update UI instantly!
        if (Get.isRegistered<PersonalisationController>()) {
          final controller = Get.find<PersonalisationController>();
          controller.isKycPending.value = false;
          controller.isKycVerified.value = false;
        }

        // 🚀 3. SYNC WITH BACKEND
        final updateData = {
          'id': userId,
          'kyc_status': 'Rejected', // Or 'Failed', depending on your DB
        };
        await Get.find<PersonalisationController>()
            .useCases
            .updateProfileUsecases
            .call(updateData);

        Get.snackbar(
          "KYC Update",
          "There was an issue with your verification. Please try again.",
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      debugPrint("Silent CAMS Check Exception: $e");
    }
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

  final RxInt profileDashboardTabIndex = 0.obs;

  int profileTabFromNavIndex(int index) {
    switch (index) {
      // case 40:
      //   return 0; // Overview
      case 41:
        return 0; // KYC Details
      case 42:
        return 1; // Personal Details
      case 43:
        return 2; // Bank Account
      case 44:
        return 3; // Nominee Details
      case 45:
        return 4; // Documents
      default:
        return 0;
    }
  }

  void openProfileDashboardTab(int tabIndex, {bool isDesktop = true}) {
    profileDashboardTabIndex.value = tabIndex;
    selectedIndex.value = 40;
    isProfileExpanded.value = false;

    if (isDesktop) {
      Get.toNamed(AppRoutes.profilePage, id: 1);
    }
  }

  void changePage(int index, {bool isDesktop = true}) {
    // if (index == 4) {
    //   if (isDesktop) {
    //     isProfileExpanded.value = !isProfileExpanded.value;
    //   } else {
    //     selectedIndex.value = 40;
    //   }
    //   return;
    // }
    if (index == 11) {
      if (isDesktop) {
        isInvestExpanded.value = !isInvestExpanded.value;
        isProfileExpanded.value = false;
        isHelpExpanded.value = false;
      }
      return;
    }
    if (index == 4) {
      if (isDesktop) {
        openProfileDashboardTab(0, isDesktop: true);
      } else {
        selectedIndex.value = 40;
      }
      return;
    }
    if (isDesktop && index >= 40 && index <= 45) {
      openProfileDashboardTab(profileTabFromNavIndex(index), isDesktop: true);
      return;
    }

    if (selectedIndex.value == index) return;

    if (index < 4) {
      isProfileExpanded.value = false;
      isInvestExpanded.value = false;
    }

    selectedIndex.value = index;

    // if (Get.isRegistered<MutualFundController>()) {
    //   Get.find<MutualFundController>().nextPopularGroup();
    // }
    if (index == 0) {
      if (Get.isRegistered<MutualFundController>()) {
        Get.find<MutualFundController>().nextPopularGroup();
      }
    }

    if (isDesktop) {
      String route = AppRoutes.home;
      String? webUrl;
      String? webTitle;
      switch (index) {
        case 0:
          route = AppRoutes.home;
          break;
        case 1:
          route = AppRoutes.explorePage;
          break;
        case 2:
          route = AppRoutes.dashBoardPage;
          break;
        case 3:
          route = AppRoutes.goalScreen;
          break;
        case 5:
          personalisationController.setStatementMode(isCapital: false);
          route = AppRoutes.downloadStatement;
          break;
        case 6:
          personalisationController.setStatementMode(isCapital: true);
          route = AppRoutes.downloadStatement;
          break;
        case 40:
          route = AppRoutes.profilePage;
          break;
        case 41:
          route = AppRoutes.kycDeatailScreen;
          break;
        case 42:
          route = AppRoutes.personaldetails;
          break;
        case 43:
          route = AppRoutes.bankDetails;
          break;
        case 44:
          route = AppRoutes.nomineeList;
          break;
        case 45:
          route = AppRoutes.documentsScreen;
          break;

        case 50:
          route = AppRoutes.webView;
          webTitle = 'Contact Support';
          webUrl = 'https://sip.londonstreetstore.com/contact-us?mobile=true';
          break;
        case 51:
          route = AppRoutes.webView;
          webTitle = 'Privacy Policy';
          webUrl =
              'https://sip.londonstreetstore.com/privacy-policy?mobile=true';
          break;
        case 52:
          route = AppRoutes.webView;
          webTitle = 'Terms & Conditions';
          webUrl =
              'https://sip.londonstreetstore.com/terms-and-conditions?mobile=true';
          break;
        case 53:
          route = AppRoutes.webView;
          webTitle = 'FAQs';
          webUrl = 'https://sip.londonstreetstore.com/faq?mobile=true';
          break;
        case 54:
          route = AppRoutes.webView;
          webTitle = 'About Us';
          webUrl = 'https://sip.londonstreetstore.com/about-us?mobile=true';
          break;
      }
      if (index >= 50 && index <= 54) {
        HtmlWebViewPage.navData = {
          'title': webTitle ?? '',
          'url': webUrl ?? '',
          'appBar': 'false',
        };
        Get.toNamed(route, id: 1);
      } else {
        Get.toNamed(route, id: 1);
      }

      // Get.toNamed(route, id: 1); // id: 1 keeps header/sidebar fixed!
    }
  }

  void navigateToExploreWithFilter(VoidCallback? filterLogic) {
    if (kIsWeb) {
      Get.toNamed(AppRoutes.explorePage, id: 1);
    } else {
      changePage(1, isDesktop: false);
    }

    Future.delayed(Duration(milliseconds: kIsWeb ? 100 : 10), () {
      isProfileExpanded.value = false;
      isHelpExpanded.value = false;

      selectedIndex.value = 1;
      if (Get.isRegistered<MutualFundController>()) {
        Get.find<MutualFundController>().nextPopularGroup();
      }

      // if (filterLogic != null) {
      //   filterLogic();
      // }
      if (filterLogic != null) {
        // 🚀 FIX: Give Web UI breathing room to navigate before filtering
        Future.delayed(const Duration(milliseconds: 150), () {
          filterLogic();
        });
      }
    });
  }

  bool get isProfileActive =>
      selectedIndex.value >= 40 && selectedIndex.value < 50;

  @override
  void onClose() {
    _camsPollingTimer?.cancel();
    super.onClose();
  }
}

class NavigationMenuBar extends StatelessWidget {
  const NavigationMenuBar({super.key});

  Future<bool> _showModernExitDialog(BuildContext context) async {
    return await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierLabel: "ExitDialog",
          barrierColor: Colors.black.withValues(alpha: 0.5),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, anim1, anim2) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                            color: Colors.red.withValues(alpha: 0.1),
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
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Closing the app will pause your current session. Are you sure you want to exit?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: FontFamily.medium,
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
                                    fontFamily: FontFamily.medium,
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

                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontFamily.medium,
                                  ),
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
    final fundhousecontroller = Get.find<FundhouseController>();

    return PopScope(
      canPop: kIsWeb && controller.selectedIndex.value == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (controller.selectedIndex.value != 0) {
          controller.changePage(0, isDesktop: isDesktop || isTablet);
          return;
        }

        if (!kIsWeb) {
          final shouldExit = await _showModernExitDialog(context);

          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },

      child: Scaffold(
        body: Row(
          children: [
            if (isDesktop || isTablet)
              _DesktopSideNav(
                isDesktop: isDesktop,
                isTablet: isTablet,
                fundhouseController: fundhousecontroller,
              ),

            Expanded(
              child: Column(
                children: [
                  if (isDesktop) const GlobalTopHeader(),

                  Expanded(
                    child: Column(
                      children: [
                        /// Main Content
                        Expanded(
                          child: (isDesktop || isTablet)
                              ? Navigator(
                                  key: Get.nestedKey(1),
                                  initialRoute: AppRoutes.home,
                                  onGenerateRoute: (settings) {
                                    if ((isDesktop || isTablet) &&
                                        settings.name ==
                                            AppRoutes.profilePage) {
                                      return GetPageRoute(
                                        settings: settings,
                                        page: () =>
                                            const WebProfileDashboardScreen(),
                                        transition: Transition.fadeIn,
                                      );
                                    }
                                    final List<GetPage> allPages =
                                        AppPages.pages();

                                    GetPage? page;

                                    try {
                                      page = allPages.firstWhere(
                                        (p) => p.name == settings.name,
                                      );
                                    } catch (e) {
                                      page = null;
                                    }

                                    if (page != null) {
                                      return GetPageRoute(
                                        settings: settings,
                                        page: page.page,
                                        binding: page.binding,
                                        bindings: page.bindings,
                                        transition: Transition.fadeIn,
                                      );
                                    }

                                    return GetPageRoute(
                                      page: () => const HomeScreen(),
                                    );
                                  },
                                )
                              : Obx(() {
                                  switch (controller.selectedIndex.value) {
                                    case 0:
                                      return const HomeScreen();

                                    case 1:
                                      return const ExploreScreen();

                                    case 2:
                                      return DashboardScreen();

                                    case 3:
                                      return GoalScreen();

                                    case 40:
                                      return const ProfileScreen();

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

                        /// Global Web Footer
                        if (isDesktop || isTablet) const WebFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        bottomNavigationBar: isDesktop ? null : const _MobileBottomNavBar(),
      ),
    );
  }
}

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Ucolors.light,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(
        "AMFI registered mutual fund distributor   ||   ARN : 104807 | Kriti Hinger",
        style: TextStyle(
          fontSize: 13,
          fontFamily: FontFamily.medium,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
        ),
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

      case 100:
        return 'My Cart';
      case 101:
        return 'My Watchlist';
      case 102:
        return 'Notifications';

      default:
        return 'MF SIP';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final navController = Get.find<NavigationBarController>();
    final mutualController = Get.find<MutualFundController>();
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      height: Get.height * 0.09,
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
                fontFamily: FontFamily.medium,
                fontWeight: FontWeight.bold,
                color: Ucolors.dark,
                letterSpacing: -0.5,
              ),
            );
          }),
          Obx(
            () => Row(
              children: [
                if (navController.selectedIndex.value == 1) ...[
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: SearchBar(
                      // focusNode: searchFocus,
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0xFFF0F2F5),
                      ),
                      leading: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey,
                      ),
                      hintText: 'Search funds...',

                      onChanged: (value) =>
                          mutualController.onSearchQueryChanged(value),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  Obx(() {
                    final activeCount =
                        Get.find<FundhouseController>().activeFilterCount;
                    final isActive = activeCount > 0;

                    return SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          WebFilterDrawer.show(context);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isActive
                              ? Ucolors.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                          side: BorderSide(
                            color: isActive
                                ? Ucolors.primary
                                : Colors.grey.shade300,
                            width: isActive ? 1.5 : 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.filter,
                              size: 18,
                              color: isActive ? Ucolors.primary : Ucolors.dark,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Filters',
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                color: isActive
                                    ? Ucolors.primary
                                    : Ucolors.dark,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),

                            if (isActive) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Ucolors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$activeCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: FontFamily.medium,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
                const SizedBox(width: 15),

                // 1. Notification Icon
                IconButton(
                  onPressed: () {
                    if (isDesktop) {
                      navController.selectedIndex.value = 102;
                      Get.toNamed(AppRoutes.notification, id: 1);
                    } else {
                      Get.toNamed(AppRoutes.notification);
                    }
                  },
                  icon: const Icon(Iconsax.notification),
                  color: Ucolors.darkgrey,
                ),

                Obx(() {
                  final controller = Get.find<CartController>();
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.shopping_cart),
                        color: Ucolors.darkgrey,
                        hoverColor: Ucolors.primary.withValues(alpha: 0.1),
                        onPressed: () {
                          controller.filterGoalId.value = null;
                          // Get.toNamed(AppRoutes.cart, id: 1);
                          if (isDesktop) {
                            navController.selectedIndex.value = 100;
                            Get.toNamed(AppRoutes.cart, id: 1);
                          } else {
                            Get.toNamed(AppRoutes.cart);
                          }
                        },
                      ),
                      if (controller.generalItemsCount > 0)
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
                              controller.generalItemsCount.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: FontFamily.medium,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),

                // 3. Watchlist Icon
                IconButton(
                  onPressed: () {
                    if (isDesktop) {
                      navController.selectedIndex.value = 101;
                      Get.toNamed(AppRoutes.watchlist, id: 1); // Nested Open
                    } else {
                      Get.toNamed(AppRoutes.watchlist);
                    }
                  },
                  icon: const Icon(Iconsax.archive_tick),
                  color: Ucolors.darkgrey,
                ),
              ],
            ),
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
  final FundhouseController fundhouseController;

  const _DesktopSideNav({
    required this.isDesktop,
    required this.isTablet,
    required this.fundhouseController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = NavigationBarController.instance;

    final screenWidth = MediaQuery.of(context).size.width;

    /// RESPONSIVE BREAKPOINTS
    final bool isCompactDesktop = screenWidth < 1200;

    final bool isMiniTablet = screenWidth < 800;

    /// WIDTH
    final double sideWidth = isDesktop
        ? (isCompactDesktop ? 220 : 280)
        : (isMiniTablet ? 78 : 90);

    /// LOGO
    final double logoSize = isDesktop ? (isCompactDesktop ? 48 : 60) : 40;

    /// TEXT
    final double navFontSize = isDesktop ? (isCompactDesktop ? 13 : 15) : 13;

    final double iconSize = isDesktop ? 22 : 20;

    final double horizontalPadding = isDesktop ? 14 : 10;

    final bool showText = isDesktop || screenWidth > 850;

    return Container(
      width: sideWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),

      child: SafeArea(
        child: Column(
          children: [
            /// LOGO
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showText ? 18 : 10,
                vertical: 14,
              ),
              child: Row(
                mainAxisAlignment: showText
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    UImages.mfsiplogo,
                    height: logoSize,
                    width: logoSize,
                  ),

                  if (showText) ...[
                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'MF SIP',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isCompactDesktop ? 18 : 20,
                          fontWeight: FontWeight.w700,
                          color: Ucolors.dark,
                          fontFamily: FontFamily.medium,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            /// USER CARD
            Container(
              margin: EdgeInsets.symmetric(horizontal: showText ? 12 : 8),
              padding: EdgeInsets.all(showText ? 12 : 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),

              child: Obx(() {
                final reactiveUser = SessionManager.instance.userObs.value;

                return Row(
                  mainAxisAlignment: showText
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: showText ? 48 : 40,
                      width: showText ? 48 : 40,
                      child: UCircularImage(image: reactiveUser?.img ?? ""),
                    ),

                    if (showText) ...[
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UHelperFunction.getGreetingMsg(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: FontFamily.medium,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              reactiveUser?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontFamily.medium,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),

            const SizedBox(height: 18),

            /// NAVIGATION
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: showText ? 12 : 8),
                child: Column(
                  children: [
                    if (showText) _buildSectionTitle("GENERALS"),

                    Obx(
                      () => _buildNavItem(
                        controller,
                        0,
                        Iconsax.home,
                        'Home',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),

                    Obx(
                      () => _buildNavItem(
                        controller,
                        1,
                        Icons.trending_up,
                        'Explore',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),

                    Obx(
                      () => _buildNavItem(
                        controller,
                        2,
                        Iconsax.chart_1,
                        'Dashboard',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),

                    Obx(
                      () => _buildNavItem(
                        controller,
                        3,
                        Iconsax.cup,
                        'Goal',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),
                    Obx(() {
                      final isExpanded = controller.isInvestExpanded.value;

                      return Column(
                        children: [
                          _DesktopNavItem(
                            icon: Iconsax.briefcase,
                            label: 'Invest',
                            isSelected: isExpanded,
                            isDesktop: showText,
                            fontSize: navFontSize,
                            iconSize: iconSize,
                            horizontalPadding: horizontalPadding,
                            trailing: showText
                                ? Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  )
                                : null,
                            onTap: () {
                              controller.changePage(11, isDesktop: showText);
                            },
                          ),

                          if (showText)
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 250),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Column(
                                children: [
                                  _buildInvestSubItem(
                                    controller,
                                    "Start SIP",
                                    () {
                                      Get.delete<SipProcessController>();
                                      SipProcessController.navIsLumpsum = false;

                                      Get.toNamed(
                                        AppRoutes.startSipScreen,
                                        id: 1,
                                        arguments: {'isLumpsum': false},
                                      );
                                    },
                                  ),
                                  _buildInvestSubItem(
                                    controller,
                                    "Start Lumpsum",
                                    () {
                                      Get.delete<SipProcessController>();
                                      SipProcessController.navIsLumpsum = true;

                                      Get.toNamed(
                                        AppRoutes.startSipScreen,
                                        id: 1,
                                        arguments: {'isLumpsum': true},
                                      );
                                    },
                                  ),
                                  _buildInvestSubItem(
                                    controller,
                                    "Invest in Index Fund",
                                    () =>
                                        controller.navigateToExploreWithFilter(
                                          () => fundhouseController
                                              .applyCustomSearch('index'),
                                        ),
                                  ),
                                  _buildInvestSubItem(
                                    controller,
                                    "Invest in International Fund",
                                    () =>
                                        controller.navigateToExploreWithFilter(
                                          () => fundhouseController
                                              .applyInternationalFilter(),
                                        ),
                                  ),
                                  _buildInvestSubItem(
                                    controller,
                                    "Start Tax Saving",
                                    () => controller
                                        .navigateToExploreWithFilter(null),
                                  ),
                                  _buildInvestSubItem(
                                    controller,
                                    "Gold Investment",
                                    () =>
                                        // controller
                                        //     .navigateToExploreWithFilter(null),
                                        controller.navigateToExploreWithFilter(
                                          () => fundhouseController
                                              .applyGoldFilter(),
                                        ),
                                  ),
                                  _buildInvestSubItem(
                                    controller,
                                    "New Fund Offer (NFO)",
                                    () => Get.toNamed(AppRoutes.nfolist, id: 1),
                                  ),
                                ],
                              ),
                              secondChild: const SizedBox.shrink(),
                            ),
                        ],
                      );
                    }),

                    // const SizedBox(height: 18),

                    // if (showText) _buildSectionTitle("SETTINGS"),

                    /// PROFILE
                    // Obx(() {
                    //   final isExpanded = controller.isProfileExpanded.value;

                    //   return Column(
                    //     children: [
                    //       _DesktopNavItem(
                    //         icon: Iconsax.user4,
                    //         label: 'Profile',
                    //         isSelected: false,
                    //         isDesktop: showText,
                    //         fontSize: navFontSize,
                    //         iconSize: iconSize,
                    //         horizontalPadding: horizontalPadding,
                    //         trailing: showText
                    //             ? Icon(
                    //                 isExpanded
                    //                     ? Icons.keyboard_arrow_up
                    //                     : Icons.keyboard_arrow_down,
                    //                 size: 18,
                    //                 color: Colors.grey.shade600,
                    //               )
                    //             : null,
                    //         onTap: () {
                    //           controller.changePage(4, isDesktop: showText);
                    //         },
                    //       ),

                    //       if (showText)
                    //         AnimatedCrossFade(
                    //           duration: const Duration(milliseconds: 250),
                    //           crossFadeState: isExpanded
                    //               ? CrossFadeState.showFirst
                    //               : CrossFadeState.showSecond,
                    //           firstChild: Column(
                    //             children: [
                    //               _buildSubItem(controller, 41, "KYC Details"),
                    //               _buildSubItem(
                    //                 controller,
                    //                 42,
                    //                 "Personal Details",
                    //               ),
                    //               _buildSubItem(controller, 43, "Bank Account"),
                    //               _buildSubItem(
                    //                 controller,
                    //                 44,
                    //                 "Nominee Details",
                    //               ),
                    //               _buildSubItem(controller, 45, "Documents"),
                    //             ],
                    //           ),
                    //           secondChild: const SizedBox.shrink(),
                    //         ),
                    //     ],
                    //   );
                    // }),
                    Obx(() {
                      return _DesktopNavItem(
                        icon: Iconsax.user4,
                        label: 'Profile',
                        isSelected: controller.isProfileActive,
                        isDesktop: showText,
                        fontSize: navFontSize,
                        iconSize: iconSize,
                        horizontalPadding: horizontalPadding,
                        onTap: () {
                          controller.changePage(4, isDesktop: showText);
                        },
                      );
                    }),
                    if (showText) _buildSectionTitle("TRANSACTIONS"),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        10,
                        Icons.currency_rupee_sharp,
                        'My Transactions',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        7,
                        Icons.sip_outlined,
                        'Manage SIP',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        8,
                        Icons.autorenew,
                        'Manage SWP',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        9,
                        Icons.info_outline,
                        'All Orders',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),

                    // const SizedBox(height: 18),
                    if (showText) _buildSectionTitle("REPORTS"),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        5,
                        Icons.info_outline,
                        'Account Statement',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),
                    Obx(
                      () => _buildNavItem(
                        controller,
                        6,
                        Icons.library_books_outlined,
                        'Capital Gain',
                        showText,
                        navFontSize,
                        iconSize,
                        horizontalPadding,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// FOOTER
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  if (showText)
                    Text(
                      "ARN : 104807",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.medium,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: 10),

                  if (showText) LogoutButton(web: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestSubItem(
    NavigationBarController controller,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        controller.isInvestExpanded.value = true;
        controller.isProfileExpanded.value = false;
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontFamily: FontFamily.medium,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 10, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontFamily: FontFamily.medium,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
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
    double fontSize,
    double iconSize,
    double horizontalPadding,
  ) {
    return _DesktopNavItem(
      icon: icon,
      label: label,
      isSelected: controller.selectedIndex.value == index,
      isDesktop: isDesktop,
      fontSize: fontSize,
      iconSize: iconSize,
      horizontalPadding: horizontalPadding,
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
      onTap: () => controller.changePage(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontFamily: FontFamily.medium,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Ucolors.blue : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDesktop;
  final VoidCallback onTap;
  final Widget? trailing;

  final double fontSize;
  final double iconSize;
  final double horizontalPadding;

  const _DesktopNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDesktop,
    required this.onTap,
    required this.fontSize,
    required this.iconSize,
    required this.horizontalPadding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(14),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),

            padding: EdgeInsets.symmetric(
              vertical: 11,
              horizontal: horizontalPadding,
            ),

            decoration: BoxDecoration(
              color: isSelected
                  ? Ucolors.blue.withValues(alpha: 0.04)
                  : Colors.transparent,

              borderRadius: BorderRadius.circular(14),

              // border: Border.all(
              //   color: isSelected
              //       ? Ucolors.blue.withValues(alpha: 0.18)
              //       : Colors.transparent,
              // ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: isSelected ? Ucolors.primary : Colors.grey.shade700,
                ),

                if (isDesktop) ...[
                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      label,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: FontFamily.medium,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? Ucolors.primary
                            : Colors.grey.shade800,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Footer
        CustomFooter(),

        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.symmetric(vertical: 8),
        //   alignment: Alignment.center,
        //   color: Ucolors.light,
        //   child: Column(
        //     children: [
        //       Text(
        //         "AMFI registered mutual fund distributor",
        //         style: TextStyle(
        //           fontSize: 12,
        //           color: Colors.grey.shade700,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //       Text(
        //         "ARN : 104807 || Kriti Hinger",
        //         style: TextStyle(
        //           fontSize: 12,
        //           color: Colors.grey.shade700,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SafeArea(
          top: false,
          bottom: true,
          child: Container(
            height: kBottomNavigationBarHeight + 4,
            padding: const EdgeInsets.only(top: 0, bottom: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _MobileNavItem(index: 0, icon: Iconsax.home, label: 'Home'),
                _MobileNavItem(
                  index: 1,
                  icon: Icons.trending_up,
                  label: 'Explore',
                ),
                _MobileNavItem(
                  index: 2,
                  icon: Iconsax.chart_1,
                  label: 'Dashboard',
                ),
                _MobileNavItem(index: 3, icon: Iconsax.cup, label: 'Goal'),
                _MobileNavItem(index: 4, icon: Iconsax.user4, label: 'Profile'),
              ],
            ),
          ),
        ),
      ],
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
              const SizedBox(height: 2),
              Icon(
                icon,
                size: 18,
                color: isSelected ? Ucolors.blue : Ucolors.darkgrey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: FontFamily.medium,
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

class WebProfileDashboardScreen extends StatelessWidget {
  const WebProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationBarController>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF5F7FA),
      padding: const EdgeInsets.all(28),
      child: Obx(() {
        // final selectedTab = navController.profileDashboardTabIndex.value;
        final rawTab = navController.profileDashboardTabIndex.value;
        final selectedTab = rawTab < 0
            ? 0
            : rawTab > 4
            ? 4
            : rawTab;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Profile Dashboard',
            //           style: TextStyle(
            //             fontFamily: FontFamily.medium,
            //             fontSize: 28,
            //             fontWeight: FontWeight.w800,
            //             color: Ucolors.dark,
            //           ),
            //         ),
            //         SizedBox(height: 6),
            //         Text(
            //           'Manage all your profile details from one place.',
            //           style: TextStyle(
            //             fontFamily: FontFamily.medium,
            //             fontSize: 14,
            //             color: Colors.grey,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),

            /// Tabs
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  // _ProfileTabButton(
                  //   title: 'Overview',
                  //   index: 0,
                  //   selectedIndex: selectedTab,
                  //   onTap: () =>
                  //       navController.profileDashboardTabIndex.value = 0,
                  // ),
                  _ProfileTabButton(
                    title: 'KYC Details',
                    index: 0,
                    selectedIndex: selectedTab,
                    onTap: () =>
                        navController.profileDashboardTabIndex.value = 0,
                  ),
                  _ProfileTabButton(
                    title: 'Personal Details',
                    index: 1,
                    selectedIndex: selectedTab,
                    onTap: () =>
                        navController.profileDashboardTabIndex.value = 1,
                  ),
                  _ProfileTabButton(
                    title: 'Bank Account',
                    index: 2,
                    selectedIndex: selectedTab,
                    onTap: () =>
                        navController.profileDashboardTabIndex.value = 2,
                  ),
                  _ProfileTabButton(
                    title: 'Nominee',
                    index: 3,
                    selectedIndex: selectedTab,
                    onTap: () =>
                        navController.profileDashboardTabIndex.value = 3,
                  ),
                  _ProfileTabButton(
                    title: 'Documents',
                    index: 4,
                    selectedIndex: selectedTab,
                    onTap: () =>
                        navController.profileDashboardTabIndex.value = 4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Important: bounded height
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: IndexedStack(
                    index: selectedTab,
                    children: const [
                      // ProfileScreen(),
                      KycDetailsScreen(),
                      _PersonalDetailsTabWrapper(),
                      BankDetailsScreen(),
                      NomineeListScreen(),
                      DocumentScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PersonalDetailsTabWrapper extends StatelessWidget {
  const _PersonalDetailsTabWrapper();

  @override
  Widget build(BuildContext context) {
    return PersonalDetailsScreen();
  }
}

class _ProfileTabButton extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _ProfileTabButton({
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Ucolors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class WebProfileDashboardScreen extends StatelessWidget {
//   const WebProfileDashboardScreen({super.key});

//   static const List<_ProfileTabData> _tabs = [
//     _ProfileTabData(
//       title: 'Overview',
//       subtitle: 'Profile summary',
//       icon: Iconsax.user,
//       navIndex: 40,
//     ),
//     _ProfileTabData(
//       title: 'KYC Details',
//       subtitle: 'Verification status',
//       icon: Iconsax.security_safe,
//       navIndex: 41,
//     ),
//     _ProfileTabData(
//       title: 'Personal Details',
//       subtitle: 'Identity and contact',
//       icon: Iconsax.personalcard,
//       navIndex: 42,
//     ),
//     _ProfileTabData(
//       title: 'Bank Account',
//       subtitle: 'Linked bank details',
//       icon: Iconsax.bank,
//       navIndex: 43,
//     ),
//     _ProfileTabData(
//       title: 'Nominee Details',
//       subtitle: 'Manage nominees',
//       icon: Iconsax.people,
//       navIndex: 44,
//     ),
//     _ProfileTabData(
//       title: 'Documents',
//       subtitle: 'Uploaded records',
//       icon: Iconsax.document_text,
//       navIndex: 45,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final navController = NavigationBarController.instance;
//     final user = SessionManager.instance.userObs.value;

//     return Container(
//       color: const Color(0xFFF5F7FB),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 1320),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _ProfileDashboardHero(userName: user?.name ?? 'Investor'),
//                 const SizedBox(height: 22),

//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(color: Colors.grey.shade200),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.04),
//                         blurRadius: 24,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
//                         child: Obx(
//                           () => _ProfileTabsBar(
//                             tabs: _tabs,
//                             selectedIndex:
//                                 navController.profileDashboardTabIndex.value,
//                             onTap: (index) =>
//                                 navController.openProfileDashboardTab(
//                                   index,
//                                   isDesktop: true,
//                                 ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       Divider(height: 1, color: Colors.grey.shade200),
//                       Obx(
//                         () => AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 220),
//                           switchInCurve: Curves.easeOutCubic,
//                           switchOutCurve: Curves.easeInCubic,
//                           child: _ProfileTabBody(
//                             key: ValueKey(
//                               navController.profileDashboardTabIndex.value,
//                             ),
//                             index: navController.profileDashboardTabIndex.value,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _ProfileDashboardHero extends StatelessWidget {
  const _ProfileDashboardHero({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: Ucolors.backgroundGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Ucolors.primary.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: const Icon(Iconsax.user_tick, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Dashboard',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage all profile, KYC, bank, nominee and document details from one place.',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.shield_tick, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTabsBar extends StatelessWidget {
  const _ProfileTabsBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<_ProfileTabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 980;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final selected = selectedIndex == index;

            return InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: compact ? 210 : 198,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected
                      ? Ucolors.primary.withValues(alpha: 0.08)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? Ucolors.primary.withValues(alpha: 0.35)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: selected ? Ucolors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: Ucolors.primary.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        tab.icon,
                        size: 18,
                        color: selected ? Colors.white : Ucolors.darkgrey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tab.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: selected ? Ucolors.primary : Ucolors.dark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tab.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ProfileTabBody extends StatelessWidget {
  const _ProfileTabBody({super.key, required this.index});

  final int index;

  Widget _child() {
    switch (index) {
      case 0:
        return const ProfileScreen();
      case 1:
        return const KycDetailsScreen();
      case 2:
        return PersonalDetailsScreen();
      case 3:
        return const BankDetailsScreen();
      case 4:
        return const NomineeListScreen();
      case 5:
        return const DocumentScreen();
      default:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 520),
      padding: const EdgeInsets.all(22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _child(),
      ),
    );
  }
}

class _ProfileTabData {
  final String title;
  final String subtitle;
  final IconData icon;
  final int navIndex;

  const _ProfileTabData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.navIndex,
  });
}
