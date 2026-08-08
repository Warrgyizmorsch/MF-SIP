// ignore_for_file: unnecessary_brace_in_string_interps, unused_element_parameter, unused_local_variable

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/popups.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/images/image_select.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/common/widget/text/view_all.dart';
import 'package:my_sip/common/widget/video/custom_inline_youtube_player.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

import 'package:my_sip/features/home/presentation/widgets/product_tool/top_up_calculator.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/features/sip_process/presentation/controllers/sip_process_controller.dart';
import 'package:my_sip/navigation_menu_bar.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/product_tool/sip_calculator.dart';
import '../widgets/product_tool/swp_calci.dart';

class WebHoverScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  const WebHoverScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 1.05,
  });

  @override
  State<WebHoverScale> createState() => _WebHoverScaleState();
}

class _WebHoverScaleState extends State<WebHoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Changes background/border color on hover (Good for List Tiles)
class WebHoverTile extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final VoidCallback? onTap;

  const WebHoverTile({super.key, required this.builder, this.onTap});

  @override
  State<WebHoverTile> createState() => _WebHoverTileState();
}

class _WebHoverTileState extends State<WebHoverTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(_isHovered),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cartController = Get.find<CartController>();
  final mutualcontroller = Get.find<MutualFundController>();
  final navigation = Get.find<NavigationBarController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final shortestSide = MediaQuery.of(context).size.shortestSide;

    final bool isMobileDevice = kIsWeb ? false : shortestSide < 600;

    final bool isDesktop1 =
        !isMobileDevice && ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isDesktop1 // change to isDesktop
          ? _WebDashboardLayout(
              authController: authController,
              cartController: cartController,
              mutualController: mutualcontroller,
              navController: navigation,
            )
          : _MobileLayout(
              authController: authController,
              cartController: cartController,
              mutualController: mutualcontroller,
              navController: navigation,
            ),
    );
  }
}

class _WebDashboardLayout extends StatelessWidget {
  final AuthController authController;
  final CartController cartController;
  final MutualFundController mutualController;
  final NavigationBarController navController;

  const _WebDashboardLayout({
    required this.authController,
    required this.cartController,
    required this.mutualController,
    required this.navController,
  });

  @override
  Widget build(BuildContext context) {
    final personalController = Get.find<PersonalisationController>();

    return Scaffold(
      backgroundColor: Ucolors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final bool compact = width < 1000;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              compact ? 22 : 28,
              24,
              compact ? 22 : 28,
              32,
            ),
            child: Center(
              child: compact
                  ? _buildColumn(context, personalController)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 66,
                          child: _buildMainColumn(context, personalController),
                        ),
                        const SizedBox(width: 24),
                        Expanded(flex: 34, child: _buildRightColumn(context)),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    PersonalisationController personalController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeHero(),
        const SizedBox(height: 24),
        _buildInvestNowPanel(context),
        const SizedBox(height: 24),
        _buildSmartActionRow(),
        const SizedBox(height: 24),
        _buildRecentlyViewedPanel(),
        const SizedBox(height: 24),
        _buildExploreCategories(),
        const SizedBox(height: 24),
        _buildGoalsPanel(),
        const SizedBox(height: 24),
        _buildFinancialToolsPanel(),
        const SizedBox(height: 24),
        _buildPopularFunds(),
        const SizedBox(height: 24),
        _buildLearnGrow(),
      ],
    );
  }

  Widget _buildMainColumn(
    BuildContext context,
    PersonalisationController personalController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeHero(),
        const SizedBox(height: 24),
        _buildSmartActionRow(),
        const SizedBox(height: 24),
        _buildExploreCategories(),
        const SizedBox(height: 24),
        _buildPopularFunds(),
        const SizedBox(height: 24),
        _buildLearnGrow(),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      children: [
        _buildInvestNowPanel(context),
        const SizedBox(height: 24),
        _buildRecentlyViewedPanel(),
        const SizedBox(height: 24),
        _buildGoalsPanel(),
        const SizedBox(height: 24),
        _buildFinancialToolsPanel(),
      ],
    );
  }

  // =========================================================
  // HERO
  // =========================================================
  Widget _buildWelcomeHero() {
    final name = authController.user.value?.name ?? 'Investor';
    final user = SessionManager.instance.userObs.value;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3F5FF), Color(0xFFF2F9FF), Color(0xFFFFFFFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip
          .antiAlias, // Background image corners ko clean round clip karne ke liye
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedWelcomeText(name: user?.name ?? "Investor"),
            const SizedBox(height: 6),
            const Text(
              'Stay consistent with your SIPs and reach your financial goals faster.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.regular,
              ),
            ),
            const SizedBox(height: 24),

            // Metrics horizontal mapping block row
            Row(
              children: [
                Expanded(
                  child: _heroMetric(
                    icon: Icons.account_balance_wallet_rounded,
                    iconBgColor: const Color(0xFF3B82F6),
                    title: 'Portfolio Value',
                    value: '₹2,75,430',
                    subtitle: '+12.45%',
                    trailing: 'All Time',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _heroMetric(
                    icon: Icons.calendar_today_rounded,
                    iconBgColor: const Color(0xFF0EA5E9),
                    title: 'SIP Due This Month',
                    value: '₹12,000',
                    subtitle: 'Due on 05 Jun 2025',
                    trailing: '',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _heroMetric(
                    icon: Icons.track_changes_rounded,
                    iconBgColor: const Color(0xFF6366F1),
                    title: 'Active Goals',
                    value: '4 Goals',
                    subtitle: 'On Track',
                    trailing: '',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _heroMetric(
                    icon: Icons.trending_up_rounded,
                    iconBgColor: const Color(0xFF22C55E),
                    title: 'Overall Returns',
                    value: '+₹35,430',
                    subtitle: '+14.75%',
                    trailing: '',
                    isReturns: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroMetric({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
    required String trailing,
    bool isReturns = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double textScaleFactor = MediaQuery.textScalerOf(
            context,
          ).scale(1.0);

          final bool useVerticalLayout =
              constraints.maxWidth < (170 * textScaleFactor);

          final Widget contentColumn = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.regular,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler
                    .noScaling, // Keeps labels clean or let it scale by removing this line
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.regular,
                  color: Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow
                    .ellipsis, // Safe guard for large font sizes or long values
              ),
              const SizedBox(height: 4),
              // Replaced Wrap with Row + Flexible to handle responsive row items under font changes cleanly
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                runSpacing: 2,
                children: [
                  if (isReturns)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1.0),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: Color(0xFF22C55E),
                        size: 12,
                      ),
                    ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,

                      color: subtitle.contains('+') || isReturns
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  if (trailing.isNotEmpty)
                    Text(
                      trailing,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.regular,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ],
          );

          // --- Icon Block ---
          // Width scaled slightly with text configuration to balance layout proportions
          final double iconBoxSize = 44 * (textScaleFactor > 1.2 ? 1.15 : 1.0);
          final Widget iconWidget = Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          );

          // --- Layout Strategy ---
          if (useVerticalLayout) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [iconWidget, const SizedBox(height: 12), contentColumn],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 12),
              Expanded(child: contentColumn),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSmartActionRow() {
    final navController = Get.find<NavigationBarController>();

    final items = [
      {
        'icon': Icons.track_changes_rounded,
        'title': 'Plan your goals',
        'sub': 'Set clear financial targets',
        'color': const Color(0xFF1677FF),
        'onTap': () {
          if (kIsWeb) {
            navController.openNestedRoute(
              AppRoutes.webMasterGoalsPage,
              navIndex: 3,
            );
          } else {
            Get.toNamed(AppRoutes.webMasterGoalsPage);
          }
        },
      },
      {
        'icon': Icons.person_add_alt_1_rounded,
        'title': 'Know your investment personality',
        'sub': 'Discover your risk profile',
        'color': const Color(0xFF8E46E8),
        'onTap': () {
          if (kIsWeb) {
            navController.openNestedRoute(AppRoutes.riskProfile);
          } else {
            Get.toNamed(AppRoutes.riskProfile);
          }
        },
      },
      {
        'icon': Icons.shopping_basket_outlined,
        'title': 'Explore your investment basket',
        'sub': 'Diversify across funds',
        'color': const Color(0xFF3AAE59),
        'onTap': () {
          if (kIsWeb) {
            navController.openNestedRoute(AppRoutes.explorePage, navIndex: 1);
          } else {
            Get.toNamed(AppRoutes.explorePage);
          }
        },
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final bool compact = width < 760;
        final bool laptopTight = width >= 760 && width < 1000;
        final bool desktopTop = width >= 1000 && width < 1500;
        final bool largerDesktopTop = width >= 1500;

        final int crossAxisCount = 3;

        final double aspectRatio = compact
            ? 1.9
            : laptopTight
            ? 2.2
            : desktopTop
            ? 2.4
            : largerDesktopTop
            ? 3
            : 2.8;

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: compact ? 12 : 18,
            mainAxisSpacing: compact ? 12 : 18,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return _smartActionCard(
              icon: item['icon'] as IconData,
              title: item['title'] as String,
              subtitle: item['sub'] as String,
              color: item['color'] as Color,
              onTap: item['onTap'] as VoidCallback,
            );
          },
        );
      },
    );
  }

  Widget _smartActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return WebHoverTile(
      onTap: onTap,
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hover ? color.withOpacity(0.3) : const Color(0xFFF1F5F9),
            ),
            boxShadow: [
              BoxShadow(
                color: hover
                    ? color.withOpacity(0.15)
                    : Colors.black.withOpacity(0.08),
                blurRadius: hover ? 24 : 18,
                offset: hover ? const Offset(0, 10) : const Offset(0, 7),
                spreadRadius: hover ? 2 : 1,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final double textScale = MediaQuery.textScalerOf(
                context,
              ).scale(1.0);
              final double titleFontSize;
              final double subtitleFontSize;
              if (width >= (450 * textScale)) {
                titleFontSize = 24;
                subtitleFontSize = 20;
              } else if (width >= (320 * textScale)) {
                titleFontSize = 20;
                subtitleFontSize = 13;
              } else if (width >= (260 * textScale)) {
                titleFontSize = 18;
                subtitleFontSize = 12;
              } else if (width >= (220 * textScale)) {
                titleFontSize = 16;
                subtitleFontSize = 11;
              } else if (width >= (180 * textScale)) {
                titleFontSize = 14;
                subtitleFontSize = 11;
              } else if (width >= (160 * textScale)) {
                titleFontSize = 12;
                subtitleFontSize = 10;
              } else {
                titleFontSize = 11;
                subtitleFontSize = 9;
              }

              final bool useVerticalLayout = width < (160 * textScale);
              final bool isWideContainer = width >= (320 * textScale);
              final bool isUltraCompact = width < (140 * textScale);

              final double iconSize = isWideContainer
                  ? 24
                  : (isUltraCompact ? 12 : 16);
              final double chevronSize = isWideContainer
                  ? 24
                  : (isUltraCompact ? 12 : 16);
              final double innerSpacing = isWideContainer
                  ? 12
                  : (isUltraCompact ? 6 : 8);

              final Widget iconModule = Container(
                padding: EdgeInsets.all(isWideContainer ? 10 : 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: iconSize),
              );

              final Widget textModule = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: useVerticalLayout
                        ? 3
                        : 2, // Safeguard overflow limits
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.regular,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: useVerticalLayout
                        ? 2
                        : 1, // Safeguard overflow limits
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      fontFamily: FontFamily.regular,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              );

              if (useVerticalLayout) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        iconModule,
                        Icon(
                          Icons.chevron_right_rounded,
                          color: color.withOpacity(0.7),
                          size: chevronSize,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: textModule,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  iconModule,
                  SizedBox(width: innerSpacing),
                  Expanded(child: textModule),
                  SizedBox(width: innerSpacing / 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: color.withOpacity(0.7),
                    size: chevronSize,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Widget _smartActionCard({
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   required Color color,
  // }) {
  //   return WebHoverTile(
  //     onTap: () {},
  //     builder: (hover) {
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 180),
  //         height: 112,
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(
  //             color: hover
  //                 ? color.withValues(alpha: 0.25)
  //                 : const Color(0xFFE7ECF4),
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: hover
  //                   ? color.withValues(alpha: 0.12)
  //                   : Colors.black.withValues(alpha: 0.025),
  //               blurRadius: hover ? 18 : 12,
  //               offset: Offset(0, hover ? 8 : 5),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 54,
  //               height: 54,
  //               decoration: BoxDecoration(
  //                 color: color.withValues(alpha: 0.10),
  //                 borderRadius: BorderRadius.circular(18),
  //               ),
  //               child: Icon(icon, color: color, size: 30),
  //             ),
  //             const SizedBox(width: 18),
  //             Expanded(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: const TextStyle(
  //                       fontFamily: FontFamily.medium,
  //                       fontSize: 14,
  //                       height: 1.25,
  //                       fontWeight: FontWeight.w900,
  //                       color: Color(0xFF111827),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 7),
  //                   Text(
  //                     subtitle,
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                     style: TextStyle(
  //                       fontFamily: FontFamily.medium,
  //                       fontSize: 12,
  //                       height: 1.3,
  //                       color: Colors.blueGrey.shade600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               width: 30,
  //               height: 30,
  //               decoration: BoxDecoration(
  //                 color: color.withValues(alpha: 0.12),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(
  //                 Icons.arrow_forward_rounded,
  //                 size: 17,
  //                 color: color,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // =========================================================
  // PANELS
  // =========================================================

  Widget _panel({
    required String title,
    Widget? trailing,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Ucolors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7ECF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _viewAllButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          'View All',
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF005DFF),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // EXPLORE CATEGORIES
  // =========================================================

  Widget _buildExploreCategories() {
    final funds = Get.find<FundhouseController>();

    final items = [
      {
        'title': 'Best SIP',
        'img': UImages.savingbank,
        'tap': () => navController.navigateToExploreWithFilter(
          () => funds.applyBestSipFilter(1),
          filter: 'best-sip',
        ),
      },
      {
        'title': 'High Return',
        'img': UImages.highreturn,
        'tap': () => navController.navigateToExploreWithFilter(
          () => funds.applyHighReturnFilter(),
          filter: 'high-return',
        ),
      },
      {
        'title': 'International',
        'img': UImages.interfund,
        'tap': () => navController.navigateToExploreWithFilter(
          () => funds.applyInternationalFilter(),
          filter: 'international-fund',
        ),
      },
      {
        'title': 'Index Funds',
        'img': UImages.indexfund,
        'tap': () => navController.navigateToExploreWithFilter(
          () => funds.applyCustomSearch('index'),
          filter: 'index-fund',
        ),
      },
      {
        'title': 'Commodities',
        'img': UImages.moneygold,
        'tap': () => navController.navigateToExploreWithFilter(
          () => funds.applyCommodityFilter(),
          filter: 'commodities',
        ),
      },
      {
        'title': 'NFO',
        'img': UImages.equity,
        'tap': () => navController.openNestedRoute(AppRoutes.nfolist),
        // 'tap': () => Get.toNamed(AppRoutes.nfolist, id: 1),
      },
    ];

    return _panel(
      title: 'Explore Categories',
      trailing: _viewAllButton(() {
        navController.changePage(1, isDesktop: true);
      }),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final bool compact = width < 500;
          final bool laptopTight = width >= 500 && width < 700;
          final int count = compact ? 3 : 6;
          return GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              crossAxisSpacing: laptopTight ? 8 : 18,
              mainAxisSpacing: laptopTight ? 8 : 18,
              mainAxisExtent: 92,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return _categoryTile(
                title: item['title'] as String,
                img: item['img'] as String,
                onTap: item['tap'] as VoidCallback,
              );
            },
          );
        },
      ),
    );
  }

  Widget _categoryTile({
    required String title,
    required String img,
    required VoidCallback onTap,
  }) {
    return WebHoverTile(
      onTap: onTap,
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFF2F7FF) : const Color(0xFFFBFCFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hover
                  ? Ucolors.primary.withValues(alpha: 0.22)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: hover
                    ? Color(0xFFF2F7FF).withOpacity(0.15)
                    : Colors.black.withOpacity(0.1),
                blurRadius: hover ? 24 : 16,
                offset: hover ? const Offset(0, 10) : const Offset(0, 4),
                spreadRadius: hover ? 1 : 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(img, width: 38, height: 38, fit: BoxFit.contain),
              const SizedBox(height: 7),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: FontFamily.regular,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: hover ? Ucolors.primary : const Color(0xFF111827),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // POPULAR FUNDS
  // =========================================================

  Widget _buildPopularFunds() {
    return Obx(() {
      final bool isLoading = mutualController.isLoading.value;
      final funds = mutualController.searchFund;

      return _panel(
        title: 'Popular Funds',
        trailing: _viewAllButton(() {
          navController.changePage(1, isDesktop: true);
        }),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(color: Ucolors.primary),
                ),
              )
            : funds.isEmpty
            ? _emptyMiniState(
                icon: Iconsax.folder_open,
                title: 'No funds found',
                subtitle: 'Explore funds will appear here.',
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  // final bool compact = constraints.maxWidth < 700;
                  // final int crossAxisCount = compact ? 1 : 3;
                  final double width = constraints.maxWidth;

                  final bool compact = width < 700;
                  final bool laptopTight = width < 960;
                  final bool mediumTight = width < 920;

                  final int crossAxisCount = compact
                      ? 2
                      : laptopTight
                      ? 3
                      : 4;
                  final double aspectRatio = width < 700
                      ? 2.1
                      : width < 850
                      ? 1.6
                      : width < 960
                      ? 1.9
                      : width < 1200
                      ? 1.6
                      : 2.2;
                  return GridView.builder(
                    itemCount: funds.length > 8 ? 8 : funds.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: aspectRatio,
                    ),

                    itemBuilder: (context, index) {
                      final fund = funds[index];
                      final rawLogo = fund.amc?.amcLogoUrl ?? '';
                      final img = rawLogo.startsWith('http')
                          ? rawLogo
                          : '${Appurl.baseUrl}$rawLogo';

                      return _popularFundTile(
                        logo: img,
                        name: fund.baseSchemeName ?? 'Unknown Fund',
                        subtitle: fund.schemecategory ?? "",
                        threeYear:
                            fund.returnsEntity?.threeYear?.toString() ?? '--',
                        // onTap: () {
                        //   final schemeName = fund.baseSchemeName?.trim() ?? '';
                        //   final schemeCode =
                        //       fund.schemeCode?.toString().trim() ?? '';

                        //   if (schemeName.isEmpty || schemeCode.isEmpty) {
                        //     debugPrint(
                        //       'Fund details missing: scheme=$schemeName code=$schemeCode',
                        //     );
                        //     return;
                        //   }

                        //   mutualController.addToLocalRecentlyViewed(fund);

                        //   navController.openNestedRoute(
                        //     AppRoutes.funddetails,
                        //     queryParameters: {
                        //       'scheme': schemeName,
                        //       'scheme_code': schemeCode,
                        //     },
                        //     arguments: {
                        //       'scheme': schemeName,
                        //       'imgUrl': img,
                        //       'scheme_code': schemeCode,
                        //     },
                        //     beforeOpen: () {
                        //       if (Get.isRegistered<FundDetailsController>()) {
                        //         Get.delete<FundDetailsController>();
                        //       }

                        //       FundDetailsScreen.navData = {
                        //         'scheme': schemeName,
                        //         'imgUrl': img,
                        //         'scheme_code': schemeCode,
                        //       };
                        //     },
                        //   );
                        // },
                        onTap: () {
                          final schemeName = fund.baseSchemeName?.trim() ?? '';
                          final schemeCode =
                              fund.schemeCode?.toString().trim() ?? '';

                          if (schemeName.isEmpty || schemeCode.isEmpty) {
                            debugPrint(
                              'Fund details missing: scheme=$schemeName code=$schemeCode',
                            );
                            return;
                          }

                          mutualController.addToLocalRecentlyViewed(fund);

                          if (kIsWeb &&
                              Get.isRegistered<NavigationBarController>()) {
                            final navController =
                                Get.find<NavigationBarController>();

                            navController.fundDetailsParentIndex =
                                0; // Home parent

                            navController.openNestedRoute(
                              AppRoutes.funddetails,
                              navIndex: 0,
                              queryParameters: {
                                'scheme': schemeName,
                                'scheme_code': schemeCode,
                              },
                              arguments: {
                                'scheme': schemeName,
                                'imgUrl': img,
                                'scheme_code': schemeCode,
                              },
                              beforeOpen: () {
                                if (Get.isRegistered<FundDetailsController>()) {
                                  Get.delete<FundDetailsController>();
                                }

                                FundDetailsScreen.navData = {
                                  'scheme': schemeName,
                                  'imgUrl': img,
                                  'scheme_code': schemeCode,
                                };
                              },
                            );
                          } else {
                            if (Get.isRegistered<FundDetailsController>()) {
                              Get.delete<FundDetailsController>();
                            }

                            FundDetailsScreen.navData = {
                              'scheme': schemeName,
                              'imgUrl': img,
                              'scheme_code': schemeCode,
                            };

                            Get.toNamed(AppRoutes.funddetails);
                          }
                        },

                        // onTap: () {
                        //   mutualController.addToLocalRecentlyViewed(fund);
                        //   // Get.delete<FundDetailsController>();
                        //   // FundDetailsScreen.navData = {
                        //   //   'scheme': fund.baseSchemeName ?? '',
                        //   //   'imgUrl': img,
                        //   //   'scheme_code': fund.schemeCode.toString(),
                        //   // };
                        //   // Get.toNamed(AppRoutes.funddetails, id: 1);
                        //   navController.openNestedRoute(
                        //     AppRoutes.funddetails,
                        //     queryParameters: {
                        //       'scheme_code': fund.schemeCode.toString(),
                        //       'scheme': fund.baseSchemeName ?? '',
                        //       'imgUrl': img,
                        //     },
                        //     beforeOpen: () {
                        //       Get.delete<FundDetailsController>();

                        //       FundDetailsScreen.navData = {
                        //         'scheme': fund.baseSchemeName ?? '',
                        //         'imgUrl': img,
                        //         'scheme_code': fund.schemeCode.toString(),
                        //       };
                        //     },
                        //   );
                        // },
                      );
                    },
                  );
                },
              ),
      );
    });
  }

  Widget _popularFundTile({
    required String logo,
    required String name,
    required String subtitle,
    required String threeYear,
    required VoidCallback onTap,
  }) {
    return WebHoverTile(
      onTap: onTap,
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(
            16,
          ), // Extra padding to match the image's breathing room
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              16,
            ), // Rounded edges matching image_138c0e.png
            border: Border.all(
              color: hover
                  ? Ucolors.primary.withValues(alpha: 0.25)
                  : const Color(0xFFF1F5F9), // Soft border
            ),
            boxShadow: [
              BoxShadow(
                color: hover
                    ? Ucolors.primary.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: hover ? 16 : 10,
                offset: Offset(0, hover ? 6 : 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- TOP SECTION: Logo + Title Column ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 42,
                      height: 42,
                      color: const Color(0xFFF8FAFC),
                      child: CustomCachedImage(imageUrl: logo, size: 42),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ), // Space between top and bottom sections

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Return Metrics Inline
                  Row(
                    children: [
                      const Text(
                        '3Y Return',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.arrow_upward_rounded,
                            color: Color(0xFF22C55E),
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$threeYear%',
                            style: const TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Invest Button
                  // Optimized Invest Button using Material OutlinedButton
                  OutlinedButton(
                    onPressed:
                        onTap, // Hooks the action up directly to the tile's tap behavior
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D4ED8), // Text color
                      backgroundColor: const Color(
                        0xFFEFF6FF,
                      ), // Soft blue fill background
                      side: const BorderSide(
                        color: const Color(0xFFDBEAFE),
                        width: 1,
                      ), // Blue accent outline
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      minimumSize: const Size(
                        0,
                        32,
                      ), // Forces height to 32 pixels exactly
                      fixedSize: const Size(
                        72,
                        32,
                      ), // Keep width standard across all cards
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // Tight wrapper matching custom container padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Perfectly matches image_138c0e.png
                      ),
                    ),
                    child: const Text(
                      'Invest',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // RIGHT SIDE
  // =========================================================
  Widget _buildInvestNowPanel(BuildContext context) {
    return _panel(
      title: 'Invest Now',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 200;

          if (compact) {
            return Column(
              children: [
                _investModeCard(
                  icon: UImages.startsip,
                  title: 'Start SIP',
                  subtitle: 'Invest regularly',
                  onTap: () {
                    SipProcessController.navIsLumpsum = false;
                    // Get.toNamed(
                    //   AppRoutes.startSipScreen,
                    //   id: 1,
                    //   arguments: {'isLumpsum': false},
                    // );
                    navController.openNestedRoute(
                      AppRoutes.startSipScreen,
                      queryParameters: {'type': 'sip'},
                      arguments: {'isLumpsum': false},
                      beforeOpen: () {
                        SipProcessController.navIsLumpsum = false;
                      },
                    );
                  },
                ),
                const SizedBox(height: 14),
                _investModeCard(
                  icon: UImages.glyph,
                  title: 'Invest Lumpsum',
                  subtitle: 'Invest once',
                  onTap: () {
                    SipProcessController.navIsLumpsum = true;
                    // Get.toNamed(
                    //   AppRoutes.startSipScreen,
                    //   id: 1,
                    //   arguments: {'isLumpsum': true},
                    // );
                    navController.openNestedRoute(
                      AppRoutes.startSipScreen,
                      queryParameters: {'type': 'lumpsum'},
                      arguments: {'isLumpsum': true},
                      beforeOpen: () {
                        SipProcessController.navIsLumpsum = true;
                      },
                    );
                  },
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _investModeCard(
                  icon: UImages.startsip,
                  title: 'Start SIP',
                  subtitle: 'Invest regularly',
                  onTap: () {
                    SipProcessController.navIsLumpsum = false;
                    // Get.toNamed(
                    //   AppRoutes.startSipScreen,
                    //   id: 1,
                    //   arguments: {'isLumpsum': false},
                    // );
                    navController.openNestedRoute(
                      AppRoutes.startSipScreen,
                      queryParameters: {'type': 'sip'},
                      arguments: {'isLumpsum': false},
                      beforeOpen: () {
                        SipProcessController.navIsLumpsum = false;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _investModeCard(
                  icon: UImages.glyph,
                  title: 'Invest Lumpsum',
                  subtitle: 'Invest once',
                  onTap: () {
                    SipProcessController.navIsLumpsum = true;
                    // Get.toNamed(
                    //   AppRoutes.startSipScreen,
                    //   id: 1,
                    //   arguments: {'isLumpsum': true},
                    // );
                    navController.openNestedRoute(
                      AppRoutes.startSipScreen,
                      queryParameters: {'type': 'lumpsum'},
                      arguments: {'isLumpsum': true},
                      beforeOpen: () {
                        SipProcessController.navIsLumpsum = true;
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _investModeCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return WebHoverTile(
      onTap: onTap,
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFF5FAFF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hover
                  ? Ucolors.primary.withValues(alpha: 0.22)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: hover
                ? [
                    BoxShadow(
                      color: Ucolors.primary.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 7),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Ucolors.primary,
                      Ucolors.primary.withValues(alpha: 0.78),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Ucolors.primary.withValues(alpha: 0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  icon,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 12,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF005DFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // Widget _investModeCard({
  //   required String icon,
  //   required String title,
  //   required String subtitle,
  //   required VoidCallback onTap,
  // }) {
  //   return WebHoverTile(
  //     onTap: onTap,
  //     builder: (hover) {
  //       return AnimatedContainer(
  //         duration: const Duration(milliseconds: 180),
  //         height: 170,
  //         padding: const EdgeInsets.all(18),
  //         decoration: BoxDecoration(
  //           color: hover ? const Color(0xFFF5FAFF) : Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(
  //             color: hover
  //                 ? Ucolors.primary.withValues(alpha: 0.22)
  //                 : const Color(0xFFE2E8F0),
  //           ),
  //           boxShadow: hover
  //               ? [
  //                   BoxShadow(
  //                     color: Ucolors.primary.withValues(alpha: 0.12),
  //                     blurRadius: 16,
  //                     offset: const Offset(0, 7),
  //                   ),
  //                 ]
  //               : null,
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: 54,
  //               height: 54,
  //               padding: const EdgeInsets.all(14),
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     Ucolors.primary,
  //                     Ucolors.primary.withValues(alpha: 0.78),
  //                   ],
  //                 ),
  //                 borderRadius: BorderRadius.circular(16),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Ucolors.primary.withValues(alpha: 0.20),
  //                     blurRadius: 14,
  //                     offset: const Offset(0, 7),
  //                   ),
  //                 ],
  //               ),
  //               child: SvgPicture.asset(
  //                 icon,
  //                 colorFilter: const ColorFilter.mode(
  //                   Colors.white,
  //                   BlendMode.srcIn,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 18),
  //             Text(
  //               title,
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(
  //                 fontFamily: FontFamily.medium,
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w900,
  //                 color: Color(0xFF111827),
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               subtitle,
  //               style: TextStyle(
  //                 fontFamily: FontFamily.medium,
  //                 fontSize: 12,
  //                 color: Colors.blueGrey.shade600,
  //               ),
  //             ),
  //             const SizedBox(height: 18),
  //             Container(
  //               width: 36,
  //               height: 36,
  //               decoration: const BoxDecoration(
  //                 color: Color(0xFF005DFF),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: const Icon(
  //                 Icons.arrow_forward_rounded,
  //                 size: 18,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildRecentlyViewedPanel() {
    return Obx(() {
      final recentList = mutualController.recentlyViewedFunds;

      return _panel(
        title: 'Recently Viewed',
        trailing: _viewAllButton(() {}),
        child: recentList.isEmpty
            ? SizedBox(
                height: 166,
                child: _emptyMiniState(
                  icon: Icons.visibility_outlined,
                  title: 'No recently viewed funds',
                  subtitle: 'Your viewed funds will appear here.',
                ),
              )
            : Column(
                children: recentList.take(3).map((fund) {
                  final rawLogo = fund.amc?.amcLogoUrl ?? '';
                  final img = rawLogo.startsWith('http')
                      ? rawLogo
                      : '${Appurl.baseUrl}$rawLogo';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _miniFundRow(
                      logo: img,
                      title: fund.baseSchemeName ?? 'Unknown Fund',
                      value:
                          '${fund.returnsEntity?.threeYear?.toString() ?? '--'}%',
                      onTap: () {
                        final schemeName = fund.baseSchemeName ?? '';
                        final schemeCode = fund.schemeCode?.toString() ?? '';

                        navController.openNestedRoute(
                          AppRoutes.funddetails,
                          queryParameters: {
                            'scheme_code': schemeCode,
                            'scheme': schemeName,
                          },
                          arguments: {
                            'scheme': schemeName,
                            'imgUrl': img,
                            'scheme_code': schemeCode,
                          },
                          beforeOpen: () {
                            if (Get.isRegistered<FundDetailsController>()) {
                              Get.delete<FundDetailsController>();
                            }

                            FundDetailsScreen.navData = {
                              'scheme': schemeName,
                              'imgUrl': img,
                              'scheme_code': schemeCode,
                            };
                          },
                        );
                      },

                      // onTap: () {
                      //   Get.delete<FundDetailsController>();
                      //   FundDetailsScreen.navData = {
                      //     'scheme': fund.baseSchemeName ?? '',
                      //     'imgUrl': img,
                      //     'scheme_code': fund.schemeCode.toString(),
                      //   };
                      //   Get.toNamed(AppRoutes.funddetails, id: 1);
                      // },
                    ),
                  );
                }).toList(),
              ),
      );
    });
  }

  Widget _miniFundRow({
    required String logo,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return WebHoverTile(
      onTap: onTap,
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFF5FAFF) : const Color(0xFFFBFCFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hover
                  ? Ucolors.primary.withValues(alpha: 0.20)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  width: 38,
                  height: 38,
                  color: Colors.white,
                  child: CustomCachedImage(imageUrl: logo, size: 38),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00A85A),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalsPanel() {
    final goals = [
      {
        'title': 'Car Goal',
        'icon': Icons.directions_car_filled_rounded,
        'type': 'car',
      },
      {
        'title': 'Marriage Goal',
        'icon': Icons.favorite_border_rounded,
        'type': 'marriage',
      },
      {'title': 'Home Goal', 'icon': Icons.home_rounded, 'type': 'home'},
      {
        'title': 'Vacation Goal',
        'icon': Icons.flight_takeoff_rounded,
        'type': 'vacation',
      },
    ];

    return _panel(
      title: 'Plan Your Goals',
      trailing: _viewAllButton(() {
        Get.toNamed(AppRoutes.webMasterGoalsPage, id: 1);
      }),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          final bool tightWidth = constraints.maxWidth < 390;
          final bool maxWidth = constraints.maxWidth < 700;
          return GridView.builder(
            itemCount: goals.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxWidth ? 2 : 4,
              childAspectRatio: tightWidth ? 1.9 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final goal = goals[index];

              return _goalTile(
                title: goal['title'] as String,
                icon: goal['icon'] as IconData,
                type: goal['type'] as String,
              );
            },
          );
        },
      ),
    );
  }

  // Widget _buildGoalsPanel() {
  //   final goals = [
  //     {
  //       'title': 'Car Goal',
  //       'icon': Icons.directions_car_filled_rounded,
  //       'type': 'car',
  //     },
  //     {
  //       'title': 'Marriage Goal',
  //       'icon': Icons.favorite_border_rounded,
  //       'type': 'marriage',
  //     },
  //     {'title': 'Home Goal', 'icon': Icons.home_rounded, 'type': 'home'},
  //     {
  //       'title': 'Vacation Goal',
  //       'icon': Icons.flight_takeoff_rounded,
  //       'type': 'vacation',
  //     },
  //   ];

  //   return _panel(
  //     title: 'Plan Your Goals',
  //     trailing: _viewAllButton(() {
  //       Get.toNamed(AppRoutes.masterGoalsPage, id: 1);
  //     }),
  //     child: GridView.builder(
  //       itemCount: goals.length,
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         // crossAxisCount: 2,
  //         // mainAxisExtent: 66,
  //         // crossAxisSpacing: 12,
  //         // mainAxisSpacing: 12,
  //         crossAxisCount: 2,
  //         childAspectRatio: 3.21,
  //         crossAxisSpacing: 10,
  //         mainAxisSpacing: 10,
  //       ),
  //       itemBuilder: (context, index) {
  //         final goal = goals[index];

  //         return _goalTile(
  //           title: goal['title'] as String,
  //           icon: goal['icon'] as IconData,
  //           type: goal['type'] as String,
  //         );
  //       },
  //     ),

  //   );
  // }

  Widget _goalTile({
    required String title,
    required IconData icon,
    required String type,
  }) {
    return WebHoverTile(
      onTap: () {
        navController.openNestedRoute(
          AppRoutes.webMasterGoalsPage,
          queryParameters: {'goalType': type, 'isHome': 'true'},
          arguments: {'goalType': type, 'isHome': true},
        );
      },
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFF5FAFF) : const Color(0xFFFBFCFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hover
                  ? Ucolors.primary.withValues(alpha: 0.20)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Ucolors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'On Track',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00A85A),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: hover ? Ucolors.primary : Colors.blueGrey.shade400,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinancialToolsPanel() {
    final tools = [
      {
        'title': 'SIP Calculator',
        'img': UImages.sipcalci,
        // 'tap': () => Get.toNamed(AppRoutes.sipCalculator, id: 1),
        'tap': () => navController.openNestedRoute(AppRoutes.sipCalculator),
      },
      {
        'title': 'SWP Calculator',
        'img': UImages.swpcali,
        'tap': () => navController.openNestedRoute(AppRoutes.swpCalculator),
        // 'tap': () => Get.toNamed(AppRoutes.swpCalculator, id: 1),
      },
      {
        'title': 'Step-Up Calculator',
        'img': UImages.siptopcalci,
        // 'tap': () => Get.toNamed(AppRoutes.stepUpCalculator, id: 1),
        'tap': () => navController.openNestedRoute(AppRoutes.stepUpCalculator),
      },
      {
        'title': 'Compare Fund',
        'img': UImages.comparefund,
        // 'tap': () => Get.toNamed(AppRoutes.comparefund, id: 1),
        'tap': () => navController.openNestedRoute(AppRoutes.comparefund),
      },
    ];

    return _panel(
      title: 'Financial Tools',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final bool maxWidth = width < 700;
          final bool tightWidth = width < 390;
          return GridView.builder(
            itemCount: tools.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxWidth ? 2 : 4,
              childAspectRatio: tightWidth ? 1.9 : 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final item = tools[index];

              return _toolTile(
                title: item['title'] as String,
                img: item['img'] as String,
                onTap: item['tap'] as VoidCallback,
              );
            },
          );
        },
      ),
    );
  }

  Widget _toolTile({
    required String title,
    required String img,
    required VoidCallback onTap,
  }) {
    return WebHoverTile(
      onTap: onTap,
      builder: (hover) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFF5FAFF) : const Color(0xFFFBFCFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hover
                  ? Ucolors.primary.withValues(alpha: 0.20)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Image.asset(img, width: 28, height: 28, fit: BoxFit.contain),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                    color: hover ? Ucolors.primary : const Color(0xFF111827),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: hover ? Ucolors.primary : Colors.blueGrey.shade400,
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // LEARN & GROW
  // =========================================================

  Widget _buildLearnGrow() {
    final videos = [
      {
        'title': 'Understanding\nMutual Funds',
        'time': '12:45 min',
        'thumbnail': 'https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg',
        'videoId': 'yo5aL4Plbso',
      },
      {
        'title': 'Figma to Flutter\nMasterclass',
        'time': '21:30 min',
        'thumbnail': 'https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg',
        'videoId': 't7lUSiddFd4',
      },
    ];

    return _panel(
      title: 'Learn & Grow',
      trailing: _viewAllButton(() => Get.toNamed(AppRoutes.videoList, id: 1)),
      child: Row(
        children: List.generate(videos.length, (index) {
          final video = videos[index];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == 0 ? 16 : 0),
              child: _videoMiniCard(
                title: video['title'] as String,
                time: video['time'] as String,
                thumbnail: video['thumbnail'] as String,
                videoId: video['videoId'] as String,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _videoMiniCard({
    required String title,
    required String time,
    required String thumbnail,
    required String videoId,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 118),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 45,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: InlineYouTubePlayer(
                  thumbnailUrl: thumbnail,
                  videoId: videoId,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 55,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.blueGrey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 11,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005DFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Watch Now',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyMiniState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 54, color: const Color(0xFFB8C7E2)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF475467),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 12,
              color: Colors.blueGrey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WebQuickActionItem extends StatefulWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;

  const _WebQuickActionItem(this.label, this.icon, this.onTap, {super.key});

  @override
  State<_WebQuickActionItem> createState() => _WebQuickActionItemState();
}

class _WebQuickActionItemState extends State<_WebQuickActionItem> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// RESPONSIVE
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;
    final bool isWeb = width >= 1100;

    final double cardWidth = isMobile
        ? 90
        : isTablet
        ? 110
        : 130;

    final double iconBoxSize = isMobile
        ? 56
        : isTablet
        ? 64
        : 74;

    final double iconSize = isMobile
        ? 24
        : isTablet
        ? 28
        : 32;

    final double fontSize = isMobile
        ? 12
        : isTablet
        ? 13
        : 15;

    final double padding = isMobile ? 12 : 16;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        scale: isPressed
            ? 0.96
            : isHovered
            ? 1.03
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),

            splashColor: Ucolors.primary.withValues(alpha: 0.08),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,

            onTapDown: (_) => _setPressed(true),

            onTapCancel: () => _setPressed(false),

            onTap: () async {
              _setPressed(true);

              await Future.delayed(const Duration(milliseconds: 90));

              _setPressed(false);

              widget.onTap();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              constraints: const BoxConstraints(minHeight: 180),
              width: cardWidth,
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),

                /// BACKGROUND
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Colors.white, Ucolors.primary.withValues(alpha: 0.04)]
                      : [Colors.white, Colors.white],
                ),

                /// BORDER
                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.15)
                      : Colors.grey.shade200,
                ),

                /// SHADOW
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? Ucolors.primary.withValues(alpha: 0.14)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ICON BOX
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: iconBoxSize,
                    width: iconBoxSize,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isHovered
                            ? [
                                Ucolors.primary,
                                Ucolors.primary.withValues(alpha: 0.85),
                              ]
                            : [
                                Ucolors.primary,
                                Ucolors.primary.withValues(alpha: 0.92),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Ucolors.primary.withValues(
                            alpha: isHovered ? 0.30 : 0.18,
                          ),
                          blurRadius: isHovered ? 18 : 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      widget.icon,
                      width: iconSize,
                      height: iconSize,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 10 : 14),

                  /// LABEL
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: isHovered ? Ucolors.primary : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WebGoalTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String type;
  const _WebGoalTile(this.title, this.icon, this.type);

  @override
  Widget build(BuildContext context) {
    // Use WebHoverTile for background highlight effect
    return WebHoverTile(
      // onTap: () =>
      //     Get.toNamed(AppRoutes.ihavegoal, arguments: {'goalType': type}),
      onTap: () => Get.toNamed(AppRoutes.comingSoon, id: 1),
      builder: (isHovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHovered
              ? Ucolors.blue.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border.all(
            color: isHovered ? Ucolors.blue : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Ucolors.blue, size: 20),
            const Gap(12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.medium,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: isHovered ? Ucolors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final AuthController authController;
  final CartController cartController;
  final MutualFundController mutualController;
  final NavigationBarController navController;

  _MobileLayout({
    required this.authController,
    required this.cartController,
    required this.mutualController,
    required this.navController,
  });

  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = SessionManager.instance.getUserData;

    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          //Appbar
          SliverAppBar(
            pinned: true,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            expandedHeight: kToolbarHeight,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.8, -0.7),
                  end: Alignment(0.8, 0.7),
                  stops: [0.0, 0.5784],
                  colors: [Color(0xFF07315C), Color(0xff0280C0)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: CustomProfileAppbar(
                    // onProfiletap: () => navController.selectedIndex.value = 4,
                    // onProfiletap: () => navController.changePage(4),
                    onProfiletap: () => Get.toNamed(AppRoutes.personaldetails),
                    backgroundColor: Colors.transparent,
                    greetingName: authController.user.value?.name ?? '',
                    role: UHelperFunction.getGreetingMsg(),
                    iconColor: Ucolors.light,
                    roleColor: Ucolors.borderColor,
                    greetingNameColor: Ucolors.light,
                    avatar: const AssetImage(UImages.mfsiplogo),
                    // img: UCircularImage(image: user?.img ?? ''),
                    img: UCircularImage(
                      image: personalisationController.imagePath.isEmpty
                          ? (user?.img ?? UImages.mfsiplogo)
                          : personalisationController.imagePath.value,
                    ),
                    action: [
                      CompactIcon(
                        icon: Iconsax.notification,
                        onPressed: () => Get.toNamed(AppRoutes.notification),
                        iconColor: Ucolors.light,
                      ),
                      const SizedBox(width: 2),
                      Obx(
                        () => Stack(
                          children: [
                            CompactIcon(
                              icon: Iconsax.shopping_cart,
                              onPressed: () {
                                Get.find<CartController>().filterGoalId.value =
                                    null;
                                Get.toNamed(AppRoutes.cart);
                                // cartController.fetchCart();
                              },
                              iconColor: Ucolors.light,
                            ),
                            if (cartController.generalItemsCount > 0)
                              Positioned(
                                right: 0,
                                top: -5,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Ucolors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    cartController.generalItemsCount.toString(),
                                    style: UTextStyles.buttonText.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 2),

                      CompactIcon(
                        icon: Iconsax.archive_tick,
                        onPressed: () => Get.toNamed(AppRoutes.watchlist),
                        iconColor: Ucolors.light,
                      ),
                    ],
                    actionsPadding: const EdgeInsets.only(right: 16),
                  ),
                ),
              ),
            ),
          ),

          //Header Section
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(height: size.height * 0.3),
                Container(
                  height: size.height * 0.21,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.8, -1.0),
                      end: Alignment(0.1, 1.0),
                      stops: [0.0, 0.9784],
                      colors: [Color(0xFF07315C), Color(0xFF0280C0)],
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.startSipScreen,
                              arguments: {'isLumpsum': false},
                            );
                          },
                          child: const FeatureSection(
                            featureName: 'SIP',
                            iconPath: UImages.startsip,
                          ),
                        ),
                        // GestureDetector(
                        //     onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                        //     child: const FeatureSection(featureName: 'Freedom SIP', iconPath: UImages.freedomsip)),
                        GestureDetector(
                          // onTap: () => Get.toNamed(AppRoutes.startSipScreen),
                          onTap: () {
                            // Get.find<SipProcessController>().setInvestmentMode(
                            //   true,
                            // );
                            // Get.toNamed(AppRoutes.startSipScreen);
                            Get.toNamed(
                              AppRoutes.startSipScreen,
                              arguments: {'isLumpsum': true},
                            );
                          },
                          child: const FeatureSection(
                            featureName: 'Lumpsum',
                            iconPath: UImages.glyph,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  final controller = Get.find<PersonalisationController>();
                  final size = MediaQuery.of(context).size;

                  final isPending = controller.isKycPending.value;
                  final isVerified = controller.isKycVerified.value;
                  final noRiskProfile = !controller.hasRiskProfile.value;
                  final noNominee = !controller.hasNominee.value;
                  final noBank = !controller.hasBank.value;
                  final noPersonalDetails =
                      !controller.hasPersonalDetails.value;

                  final canNumber = controller.userData.value?.canNumber ?? '';
                  final userCanStatus =
                      (controller.userData.value?.canStatus ?? '')
                          .trim()
                          .toLowerCase();

                  final noCan =
                      canNumber.isEmpty || userCanStatus != 'approved';

                  final noMandate = !controller.hasApprovedMandate;

                  final isAllComplete =
                      isVerified &&
                      !noPersonalDetails &&
                      !noRiskProfile &&
                      !noNominee &&
                      !noBank &&
                      !noCan &&
                      !noMandate;

                  // --- 1. DEFAULT STATE ---
                  Color bgColor = Ucolors.light;
                  Color iconColor = Colors.black;
                  Color titleColor = Ucolors.dark;
                  Color subTextColor = Colors.grey;

                  IconData leftIcon = Icons.person;
                  Widget? customLeftIcon;
                  IconData rightIcon = Icons.arrow_forward_ios;
                  String titleText = '';
                  String subText = '';
                  VoidCallback? onTapAction;

                  if (controller.isProfileLoading.value) {
                    return Positioned(
                      bottom: 0,
                      right: 20,
                      left: 20,
                      child: UShimmerEffect(
                        width: double.infinity,
                        height: size.height * 0.13,
                        text: "Fetching your profile...",
                      ),
                    );
                  }

                  // 0. If KYC is rejected/failed (has error from CAMS)
                  if (!isVerified &&
                      !isPending &&
                      controller.kycErrorMessage.isNotEmpty) {
                    bgColor = Colors.red.shade50;
                    iconColor = Colors.red.shade700;
                    titleColor = Colors.red.shade900;
                    subTextColor = Colors.red.shade800;
                    leftIcon = Icons.error_outline_rounded;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'KYC Verification Failed';
                    subText = controller.kycErrorMessage;
                    onTapAction = () => Get.toNamed(AppRoutes.kycScreen);
                  }
                  // 1. If KYC hasn't even been started or is not verified
                  else if (!isVerified && !isPending) {
                    bgColor = Ucolors.light;
                    iconColor = Colors.black;
                    titleColor = Ucolors.dark;
                    subTextColor = Colors.grey;
                    leftIcon = Icons.person;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Complete KYC & Profile';
                    subText = 'Verify your Identity to start Investing';
                    onTapAction = () => Get.toNamed(AppRoutes.kycScreen);
                  } else if (noPersonalDetails) {
                    bgColor = Ucolors.blue; // or any color you prefer
                    iconColor = Ucolors.light;
                    titleColor = Ucolors.light;
                    subTextColor = Ucolors.light.withValues(alpha: 0.8);
                    leftIcon = Icons.assignment_ind_rounded;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Complete Profile Details';
                    subText = 'Add your income and family details';
                    onTapAction = () => Get.toNamed(AppRoutes.additionalInfo);
                  }
                  // 2. If Risk Profile is missing (even if KYC is pending)
                  else if (noRiskProfile) {
                    bgColor = Ucolors.blue;
                    iconColor = Ucolors.light;
                    titleColor = Ucolors.light;
                    subTextColor = Ucolors.light.withValues(alpha: 0.8);
                    customLeftIcon = CircleAvatar(
                      backgroundColor: Colors.amber,
                      backgroundImage: AssetImage(UImages.crown),
                      radius: 14,
                    );
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Check Your Risk Profile Now!';
                    subText = 'Discover your investment style';
                    onTapAction = () => Get.toNamed(AppRoutes.riskProfile);
                  }
                  // 3. If Nominee is missing (even if KYC is pending)
                  // 4. If Bank is missing (even if KYC is pending)
                  else if (noBank) {
                    bgColor = Ucolors.primary;
                    iconColor = Ucolors.light;
                    titleColor = Ucolors.light;
                    subTextColor = Ucolors.light.withValues(alpha: 0.8);
                    leftIcon = Icons.account_balance;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Add Bank Account';
                    subText = 'Link your bank for fast transactions';
                    onTapAction = () => Get.toNamed(AppRoutes.addanotherbank);
                  } else if (noNominee) {
                    bgColor = Ucolors.light;
                    iconColor = Ucolors.blue;
                    titleColor = Ucolors.blue;
                    subTextColor = Colors.grey;
                    leftIcon = Icons.family_restroom;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Add a Nominee';
                    subText = 'Secure your investments for your family';
                    onTapAction = () => Get.toNamed(AppRoutes.nomineeDetail);
                  } else if (isPending && !isVerified) {
                    bgColor = Colors.orange.shade50;
                    iconColor = Colors.orange.shade700;
                    titleColor = Colors.orange.shade900;
                    subTextColor = Colors.orange.shade800;
                    leftIcon = Icons.hourglass_top;
                    customLeftIcon = null;
                    rightIcon = Icons.access_time;
                    titleText = 'KYC Under Verification';
                    subText = 'Takes 2-3 business days for approval ⏳';
                    onTapAction = () => ULoaders.info(
                      title: "KYC Verification In Progress",
                      message:
                          "Your KYC documents have been submitted to KRA/CAMS. Verification typically takes 2-3 business days. You can continue completing your bank details, nominee, and risk profile in the meantime.",
                    );
                  }
                  // 5. If everything else is done, but KYC is STILL pending!
                  else if (noCan) {
                    bgColor = Colors.purple.shade50;
                    iconColor = Colors.purple.shade700;
                    titleColor = Colors.purple.shade900;
                    subTextColor = Colors.purple.shade800;
                    leftIcon = Icons.auto_awesome_rounded;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Setting Up Investment Account';
                    subText = 'Final activation in progress. Almost ready! 🚀';

                    onTapAction = () {
                      Get.find<PersonalisationController>()
                          .checkAndTriggerCanRegistration(
                            isManualTrigger: true,
                          );
                      ULoaders.info(
                        title: "Account Activation In Progress 🎉",
                        message:
                            "Your profile and bank details are complete! We are carrying out the final investment account activation in the background. No action is needed from your end.",
                      );
                    };
                  } else if (noMandate) {
                    bgColor = Colors.indigo.shade50;
                    iconColor = Colors.indigo.shade700;
                    titleColor = Colors.indigo.shade900;
                    subTextColor = Colors.indigo.shade800;
                    leftIcon = Icons.account_balance_wallet_rounded;
                    customLeftIcon = null;
                    rightIcon = Icons.arrow_forward_ios;
                    titleText = 'Setup Bank Mandate (AutoPay)';
                    subText =
                        'Link your bank to enable automatic SIP deductions';
                    onTapAction = () {
                      // Navigate to your Mandate / PaymentScreen
                      // Get.to(() => PaymentScreen());
                      Get.toNamed(AppRoutes.bankDetails);
                    };
                  }
                  // 6. SUCCESS STATE (All Tasks Complete & KYC Verified!)
                  else if (isAllComplete) {
                    bgColor = const Color(0xFFE8F5E9); // Very light green
                    iconColor = const Color(0xFF2E7D32); // Deep premium green
                    titleColor = const Color(0xFF1B5E20);
                    subTextColor = const Color(0xFF388E3C);
                    customLeftIcon = Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        color: iconColor,
                        size: 20,
                      ),
                    );
                    rightIcon = Icons.arrow_forward_rounded;
                    titleText = 'Ready to Invest! 🎉';
                    subText = 'Your profile is 100% complete.';
                    onTapAction = () {
                      navController.changePage(1, isDesktop: false);
                    };
                  } else {
                    return const SizedBox.shrink(); // Fallback
                  }

                  // --- PROGRESS CALCULATION ---
                  final isRejected =
                      !isVerified &&
                      !isPending &&
                      controller.kycErrorMessage.isNotEmpty;
                  final showProgressCard = !isAllComplete && !isRejected;

                  const int totalSteps = 7;
                  int completedSteps = 0;
                  if (isVerified) completedSteps++;
                  if (!noPersonalDetails) completedSteps++;
                  if (!noRiskProfile) completedSteps++;
                  if (!noBank) completedSteps++;
                  if (!noNominee) completedSteps++;
                  if (!noCan) completedSteps++;
                  if (!noMandate) completedSteps++;

                  final double progressFraction =
                      completedSteps / totalSteps.toDouble();
                  final int percentage = (progressFraction * 100).toInt();

                  // --- UI RENDER ---
                  return Positioned(
                    left: 20,
                    right: 20,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: onTapAction,
                        child: Container(
                          height: size.height * 0.13,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: showProgressCard ? null : bgColor,
                            gradient: showProgressCard
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF2C3E50),
                                      Color(0xFF3498DB),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              showProgressCard
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 38,
                                          height: 38,
                                          child: CircularProgressIndicator(
                                            value: progressFraction,
                                            strokeWidth: 3.5,
                                            backgroundColor: Colors.white
                                                .withValues(alpha: 0.18),
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(Colors.white),
                                          ),
                                        ),
                                        Text(
                                          "$percentage%",
                                          style: UTextStyles.caption.copyWith(
                                            fontSize: 9,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  : (customLeftIcon ??
                                        Icon(
                                          leftIcon,
                                          size: 24,
                                          color: iconColor,
                                        )),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Onboarding Task',
                                          style: UTextStyles.medium.copyWith(
                                            fontSize: 11,
                                            color: showProgressCard
                                                ? Colors.white.withValues(
                                                    alpha: 0.8,
                                                  )
                                                : subTextColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (showProgressCard)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "$completedSteps/$totalSteps steps",
                                              style: UTextStyles.caption
                                                  .copyWith(
                                                    fontSize: 9,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      titleText,
                                      style: UTextStyles.medium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: showProgressCard
                                            ? Colors.white
                                            : titleColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      subText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: UTextStyles.caption.copyWith(
                                        fontSize: 10,
                                        color: showProgressCard
                                            ? Colors.white.withValues(
                                                alpha: 0.9,
                                              )
                                            : subTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                rightIcon,
                                size: 14,
                                color: showProgressCard
                                    ? Colors.white
                                    : iconColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Collection
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SectionHeading(
                sectionTitle: 'Collection',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                mainAxisSpacing: 0,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildListDelegate([
                CollectionItemMob(
                  title: 'Best SIP Funds',
                  iconImg: UImages.savingbank,

                  onTap: () async {
                    // // navController.changePage(1);
                    // Get.find<NavigationBarController>().changePage(1);
                    // Get.find<FundhouseController>().applyBestSipFilter(1);
                    await Future.delayed(const Duration(milliseconds: 100));
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyBestSipFilter(1);
                    });
                  },
                ),
                CollectionItemMob(
                  title: 'High Returns',
                  iconImg: UImages.highreturn,
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyHighReturnFilter();
                    await Future.delayed(const Duration(milliseconds: 100));

                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyHighReturnFilter();
                    });
                  },
                ),
                CollectionItemMob(
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCustomSearch(
                    //   'international',
                    // );
                    await Future.delayed(const Duration(milliseconds: 100));

                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      // funds.applyCustomSearch('international');
                      funds.applyInternationalFilter();
                    });
                  },
                  title: 'International Funds',
                  iconImg: UImages.interfund,
                ),
                CollectionItemMob(
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCustomSearch('index');
                    await Future.delayed(const Duration(milliseconds: 100));

                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCustomSearch('index');
                    });
                  },

                  title: 'Index Funds',
                  iconImg: UImages.indexfund,
                ),
                CollectionItemMob(
                  onTap: () async {
                    // navController.changePage(1);
                    // Get.find<FundhouseController>().applyCommodityFilter();
                    await Future.delayed(const Duration(milliseconds: 100));
                    final nav = Get.find<NavigationBarController>();
                    final funds = Get.find<FundhouseController>();
                    nav.navigateToExploreWithFilter(() {
                      funds.applyCommodityFilter();
                    });
                  },
                  title: 'Commodities',
                  iconImg: UImages.moneygold,
                ),
                CollectionItemMob(
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    Get.toNamed(AppRoutes.nfolist);
                  },
                  title: 'NFO',
                  iconImg: UImages.equity,
                ),
              ]),
            ),
          ),

          // Create Goal Base SIP
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 5, 16, 12),
              child: USectionHeading(
                title: 'Create Goal Base SIP',
                showActionButton: false,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'car', 'isHome': true},
                  ),
                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Car Goal',
                  iconData: Icons.directions_car_filled_rounded,
                ),
                GoalBaseSIPCard(
                  title: 'Education Goal',
                  iconData: Icons.menu_book,
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'education', 'isHome': true},
                  ),
                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'marriage', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Marriage Goal',
                  iconData: Icons.favorite_border_outlined,
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'vacation', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Vacation Goal',
                  iconData: Icons.flight_takeoff_rounded,
                ),
                GoalBaseSIPCard(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'home', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  title: 'Home Goal',
                  iconData: Icons.home_rounded,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.masterGoalsPage,
                    arguments: {'goalType': 'other', 'isHome': true},
                  ),

                  // onTap: () => Get.toNamed(AppRoutes.comingSoon),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Ucolors.borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 20, color: Ucolors.blue),
                        // Container(
                        //   padding: const EdgeInsets.all(8),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFEEF5FF),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: const Icon(
                        //     Icons.add,
                        //     size: 20,
                        //     color: Ucolors.blue,
                        //   ),
                        // ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Custom Goal',
                            style: UTextStyles.small.copyWith(
                              color: Ucolors.dark,
                              fontSize: 11,
                              fontFamily: FontFamily.medium,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // Products & Tool
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: USectionHeading(
                title: 'Products & Tool',
                // buttonTitle: 'See all',
                showActionButton: false,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 5)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                ToolsItem(
                  title: "SIP Calculator",
                  imgUrl: UImages.sipcalci,
                  onTap: () => Get.to(() => const SipCalculatorPage()),
                ),
                ToolsItem(
                  title: "SWP Calculator",
                  imgUrl: UImages.swpcali,
                  onTap: () => Get.to(() => const SwpCalciScreen()),
                ),
                ToolsItem(
                  title: "Step-Up Calculator",
                  imgUrl: UImages.siptopcalci,
                  onTap: () => Get.to(() => const TopUpCalculatorPage()),
                ),
                ToolsItem(
                  title: "Compare Fund",
                  imgUrl: UImages.comparefund,
                  onTap: () => Get.toNamed(AppRoutes.comparefund),
                ),
              ]),
            ),
          ),
          // 1. POPULAR FUNDS SECTION (Horizontal Scroll)
          // ==============================================================
          // 2. POPULAR FUNDS SECTION (Auto-Cycling Groups of 4)
          // ==============================================================
          SliverToBoxAdapter(
            child: Obx(() {
              final popularList = mutualController.searchFund;

              if (popularList.isEmpty) {
                return const SizedBox.shrink();
              }

              // 🚀 1. Calculate the slice of 4 funds based on the timer index
              final currentIndex = mutualController.currentPopularIndex.value;
              final startIndex = currentIndex * 4;

              // Prevent out-of-bounds errors if the list isn't exactly a multiple of 4
              final endIndex = (startIndex + 4 > popularList.length)
                  ? popularList.length
                  : startIndex + 4;

              // The 4 funds currently visible
              final displayedFunds = popularList.sublist(startIndex, endIndex);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: USectionHeading(
                      title: 'Popular Funds',
                      showActionButton: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _showPopularFundsSheet(context);
                      },
                    ),
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    key: ValueKey<int>(currentIndex),
                    child: SizedBox(
                      height: 110, // Keep this identical to your card height
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: displayedFunds.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final fund = displayedFunds[index];

                          final rawLogo = fund.amc?.amcLogoUrl ?? '';
                          final img = rawLogo.startsWith('http')
                              ? rawLogo
                              : "${Appurl.baseUrl}$rawLogo";

                          final name = fund.baseSchemeName ?? 'Unknown Name';
                          final threeyear = fund.returnsEntity?.threeYear ?? '';
                          final schemeCode = fund.schemeCode.toString();

                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.42,
                            child: PopularFundCardMob(
                              onTap: () {
                                mutualController.addToLocalRecentlyViewed(fund);
                                Get.toNamed(
                                  AppRoutes.funddetails,
                                  arguments: {
                                    'scheme': name,
                                    'imgUrl': img,
                                    'scheme_code': schemeCode,
                                  },
                                );
                              },
                              isNetwork: true,
                              imgPath: img,
                              name: name,
                              threeYear: threeyear,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),

          // SliverToBoxAdapter(
          //   child: Obx(() {
          //     final popularList = mutualController.searchFund;

          //     if (popularList.isEmpty) {
          //       return const SizedBox.shrink();
          //     }

          //     return Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          //           child: USectionHeading(
          //             title: 'Popular Funds',
          //             showActionButton: true,
          //             onPressed: () {
          //               FocusScope.of(context).unfocus();
          //               _showPopularFundsSheet(context);
          //             },
          //           ),
          //         ),
          //         SizedBox(
          //           height:
          //               120, // 🚀 Keep this identical to the Recently Viewed height
          //           child: ListView.separated(
          //             padding: const EdgeInsets.symmetric(horizontal: 16),
          //             scrollDirection: Axis.horizontal,
          //             // If you strictly want maximum 2 items in the whole list, use: popularList.length.clamp(0, 2)
          //             itemCount: popularList.length.clamp(0, 4),
          //             separatorBuilder: (context, index) =>
          //                 const SizedBox(width: 16),
          //             itemBuilder: (context, index) {
          //               final fund = popularList[index];

          //               final rawLogo = fund.amc?.amcLogoUrl ?? '';
          //               final img = rawLogo.startsWith('http')
          //                   ? rawLogo
          //                   : "${Appurl.baseUrl}$rawLogo";

          //               final name = fund.baseSchemeName ?? 'Unknown Name';
          //               final threeyear = fund.returnsEntity?.threeYear ?? '';
          //               final schemeCode = fund.schemeCode.toString();

          //               return SizedBox(
          //                 // 🚀 This makes exactly 2 cards fit on the screen at a time
          //                 width: MediaQuery.of(context).size.width * 0.42,
          //                 child: PopularFundCard(
          //                   onTap: () {
          //                     mutualController.addToLocalRecentlyViewed(fund);
          //                     Get.toNamed(
          //                       AppRoutes.funddetails,
          //                       arguments: {
          //                         'scheme': name,
          //                         'imgUrl': img,
          //                         'scheme_code': schemeCode,
          //                       },
          //                     );
          //                   },
          //                   isNetwork: true,
          //                   imgPath: img,
          //                   name: name,
          //                   threeYear: threeyear,
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //       ],
          //     );
          //   }),
          // ),

          // 2. RECENTLY VIEWED SECTION (Horizontal Scroll)
          SliverToBoxAdapter(
            child: Obx(() {
              final recentList = mutualController.recentlyViewedFunds;

              // Hide section entirely if there is no history
              if (recentList.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: USectionHeading(
                      title: 'Recently Viewed',
                      showActionButton: false,
                    ),
                  ),
                  SizedBox(
                    height:
                        110, // 🚀 Adjust this height based on your card's design
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      // If you strictly want maximum 2 items in the whole list, use: recentList.length.clamp(0, 2)
                      itemCount: recentList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final fund = recentList[index];

                        // Safe Image URL handler (fixes the double URL bug we discussed earlier)
                        final rawLogo = fund.amc?.amcLogoUrl ?? '';
                        final img = rawLogo.startsWith('http')
                            ? rawLogo
                            : "${Appurl.baseUrl}$rawLogo";

                        final name = fund.baseSchemeName ?? 'Unknown Name';
                        final threeyear = fund.returnsEntity?.threeYear ?? '';
                        final schemeCode = fund.schemeCode.toString();

                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: PopularFundCardMob(
                            onTap: () {
                              mutualController.addToLocalRecentlyViewed(fund);
                              Get.toNamed(
                                AppRoutes.funddetails,
                                arguments: {
                                  'scheme': name,
                                  'imgUrl': img,
                                  'scheme_code': schemeCode,
                                },
                              );
                            },
                            isNetwork: true,
                            imgPath: img,
                            name: name,
                            threeYear: threeyear,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),

          // Popular Funds
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          //     child: USectionHeading(
          //       title: 'Popular Funds',
          //       showActionButton: true,
          //       // onPressed: () => navController.selectedIndex.value = 1,
          //       // onPressed: () =>
          //       //     navController.navigateToExploreWithFilter(null),
          //       onPressed: () {
          //         FocusScope.of(context).unfocus();
          //         _showPopularFundsSheet(context);
          //       },
          //     ),
          //   ),
          // ),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   sliver: Obx(() {
          //     return SliverGrid.builder(
          //       itemCount: mutualController.searchFund.length.clamp(0, 4),
          //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         childAspectRatio: 1.55,
          //         crossAxisSpacing: 16,
          //         mainAxisSpacing: 16,
          //       ),
          //       itemBuilder: (context, index) {
          //         final fund = mutualController.searchFund[index];
          //         final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          //         final name = fund.baseSchemeName ?? 'Unknown Name';
          //         final threeyear = fund.returnsEntity?.threeYear ?? '';
          //         final schemeCode = fund.schemeCode.toString();
          //         return PopularFundCard(
          //           onTap: () => Get.toNamed(
          //             AppRoutes.funddetails,
          //             arguments: {
          //               'scheme': name,
          //               'imgUrl': img,
          //               'scheme_code': schemeCode,
          //             },
          //           ),
          //           isNetwork: true,
          //           imgPath: img,
          //           name: name,
          //           threeYear: threeyear,
          //         );
          //       },
          //     );
          //   }),
          // ),
          // SliverToBoxAdapter(
          //   child: Obx(() {
          //     // 🚀 Check if they have viewed 4 or more funds
          //     final hasEnoughHistory =
          //         mutualController.recentlyViewedFunds.length >= 4;

          //     return Padding(
          //       padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          //       child: USectionHeading(
          //         title: hasEnoughHistory ? 'Recently Viewed' : 'Popular Funds',
          //         // Only show the Action button for Popular Funds (optional)
          //         showActionButton: !hasEnoughHistory,
          //         onPressed: () {
          //           FocusScope.of(context).unfocus();
          //           _showPopularFundsSheet(context);
          //         },
          //       ),
          //     );
          //   }),
          // ),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   sliver: Obx(() {
          //     final hasEnoughHistory =
          //         mutualController.recentlyViewedFunds.length >= 4;

          //     // 🚀 Swap the data source based on history length
          //     final displayList = hasEnoughHistory
          //         ? mutualController.recentlyViewedFunds
          //         : mutualController.searchFund;

          //     if (displayList.isEmpty) {
          //       return const SliverToBoxAdapter(child: SizedBox.shrink());
          //     }

          //     return SliverGrid.builder(
          //       itemCount: displayList.length.clamp(0, 4),
          //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         childAspectRatio: 1.55,
          //         crossAxisSpacing: 16,
          //         mainAxisSpacing: 16,
          //       ),
          //       itemBuilder: (context, index) {
          //         final fund = displayList[index];
          //         final img = "${Appurl.baseUrl}${fund.amc?.amcLogoUrl}";
          //         final name = fund.baseSchemeName ?? 'Unknown Name';
          //         final threeyear = fund.returnsEntity?.threeYear ?? '';
          //         final schemeCode = fund.schemeCode.toString();

          //         return PopularFundCard(
          //           onTap: () {
          //             // 🚀 Track this fund when tapped!
          //             // mutualController.addToRecentlyViewed(fund);
          //             mutualController.addToLocalRecentlyViewed(fund);

          //             Get.toNamed(
          //               AppRoutes.funddetails,
          //               arguments: {
          //                 'scheme': name,
          //                 'imgUrl': img,
          //                 'scheme_code': schemeCode,
          //               },
          //             );
          //           },
          //           isNetwork: true,
          //           imgPath: img,
          //           name: name,
          //           threeYear: threeyear,
          //         );
          //       },
          //     );
          //   }),
          // ),

          // Videos
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: USectionHeading(
                title: 'Video’s & Blogs',
                // showActionButton: true,
                buttonTitle: 'See all',
                onPressed: () => Get.toNamed(AppRoutes.videoList),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     // height: size.height * 0.25,
          //     height: 220,
          //     child: ListView(
          //       scrollDirection: Axis.horizontal,
          //       padding: const EdgeInsets.symmetric(horizontal: 16),
          //       children: const [
          //         InlineYouTubePlayer(
          //           thumbnailUrl:
          //               "https://img.youtube.com/vi/yo5aL4Plbso/maxresdefault.jpg",
          //           videoId: "yo5aL4Plbso",
          //         ),
          //         // YoutubeThumbnail(videoId: 'yo5aL4Plbso'),
          //         SizedBox(width: 16),
          //         InlineYouTubePlayer(
          //           thumbnailUrl:
          //               "https://img.youtube.com/vi/t7lUSiddFd4/maxresdefault.jpg",
          //           videoId: "t7lUSiddFd4",
          //         ),

          //         // YoutubeThumbnail(videoId: 't7lUSiddFd4'),
          //         SizedBox(width: 16),
          //       ],
          //     ),
          //   ),
          // ),
          // const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24, right: 12),
                physics: const BouncingScrollPhysics(),
                children: const [
                  ClickableYoutubeThumbnail(
                    videoUrl:
                        "https://youtu.be/2B8b2E9JPzk?si=69cT1kC-Er_TNNCB",
                  ),
                  SizedBox(width: 8),
                  ClickableYoutubeThumbnail(
                    videoUrl:
                        "https://youtu.be/xuVUGgB3kGE?si=0Kje6W2zqSxEtUuu",
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _showPopularFundsSheet(BuildContext context) {
    final mutualController = Get.find<MutualFundController>();
    final FocusNode searchFocus = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore Funds",
                            style: AppTextStyles.h2(color: Ucolors.dark),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Search and discover mutual funds.",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: FontFamily.medium,

                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        final fundController = Get.find<FundhouseController>();
                        final int filterCount =
                            fundController.activeFilterCount;

                        return Badge(
                          isLabelVisible: filterCount > 0,
                          backgroundColor: Ucolors.primary,
                          label: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: FontFamily.medium,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: const Alignment(0.7, -0.7),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                            ),
                            child: CompactIcon(
                              icon: Icons.tune,
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  AppRoutes.filterpage,
                                );
                                if (result != null &&
                                    result is Map<String, dynamic>) {
                                  mutualController.applyFilters(result);
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: Obx(() {
                            final bool isSearching =
                                mutualController.hasSearchFocus.value;

                            return Row(
                              children: [
                                Expanded(
                                  child: SearchBar(
                                    onTap: () =>
                                        mutualController.setSearchFocus(true),
                                    onTapOutside: (event) {
                                      searchFocus.unfocus();
                                      mutualController.setSearchFocus(false);
                                    },
                                    focusNode: searchFocus,
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.grey.shade50,
                                    ),
                                    leading: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Search mutual funds...',
                                    hintStyle: WidgetStateProperty.all(
                                      TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 15,
                                        fontFamily: FontFamily.medium,
                                      ),
                                    ),
                                    onChanged: (value) => mutualController
                                        .onSearchQueryChanged(value),
                                    elevation: WidgetStateProperty.all(0),
                                    side: WidgetStateProperty.all(
                                      BorderSide(color: Colors.grey.shade200),
                                    ),
                                  ),
                                ),
                                if (!isSearching) ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () =>
                                        mutualController.cycleGlobalSort(),
                                    borderRadius: BorderRadius.circular(14),
                                    child: FilterChip(
                                      label: mutualController
                                          .currentSortLabel
                                          .value,
                                      icon: Icons.sort,
                                      isSelected:
                                          mutualController
                                              .currentSortLabel
                                              .value !=
                                          "1Y,3Y,5Y",
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade200, height: 20),

                Expanded(
                  child: Obx(() {
                    if (mutualController.isLoading.value) {
                      return const Align(
                        alignment: Alignment.topCenter,

                        child: CircularProgressIndicator(
                          color: Ucolors.primary,
                        ),
                      );
                    }

                    if (mutualController.searchFund.isEmpty) {
                      return Center(
                        child: Text(
                          "No mutual funds found",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // Check if we scrolled near the bottom (within 200 pixels)
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          // Prevent spamming the API if it's already loading or has no more data
                          if (!mutualController.isMoreLoading.value &&
                              mutualController.canLoadMore) {
                            mutualController
                                .loadNextPage(); // Triggers your pagination API!
                          }
                        }
                        return false; // Return false so the sheet can still drag up/down normally
                      },

                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount:
                            mutualController.searchFund.length +
                            (mutualController.isMoreLoading.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == mutualController.searchFund.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Ucolors.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final fund = mutualController.searchFund[index];
                          // return ModernStaggeredItem(
                          //   index: index,
                          //   child: MutualFundCard(entity: fund),
                          // );

                          return MutualFundCard(entity: fund);
                        },
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
      // ).whenComplete(() {
      //   mutualController.setSearchFocus(false);

      //   mutualController.handleRefresh();
      // });
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        mutualController.setSearchFocus(false);

        Get.find<FundhouseController>().clearAllFilters();

        mutualController.silentReset();
      });
    });
  }
}

class YoutubeThumbnail extends StatelessWidget {
  const YoutubeThumbnail({
    super.key,
    required this.videoId,
    this.width = 300, // Default width
    this.height = 190,
    this.borderRadius = 16,
    this.onTap,
  });

  final String videoId;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // On mobile, use percentage width. On desktop, use fixed width.
    final displayWidth = isDesktop
        ? width
        : MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: displayWidth,
        height: height, // Use height parameter
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.error, color: Colors.white54),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xfff44336),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularFundCard extends StatefulWidget {
  const PopularFundCard({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;

  @override
  State<PopularFundCard> createState() => _PopularFundCardState();
}

class _PopularFundCardState extends State<PopularFundCard> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// RESPONSIVE
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;
    final bool isWeb = width >= 1100;

    final double logoSize = isMobile
        ? 38
        : isTablet
        ? 42
        : 48;

    final double titleSize = isMobile
        ? 12
        : isTablet
        ? 13
        : 14;

    final double cardPadding = isMobile ? 12 : 16;

    final double borderRadius = isMobile ? 16 : 20;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        scale: isPressed
            ? 0.98
            : isHovered
            ? 1.01
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),

            splashColor: Ucolors.primary.withValues(alpha: 0.08),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,

            onTapDown: (_) => _setPressed(true),

            onTapCancel: () => _setPressed(false),

            onTap: () async {
              _setPressed(true);

              await Future.delayed(const Duration(milliseconds: 90));

              _setPressed(false);

              widget.onTap?.call();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),

                /// BORDER
                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.18)
                      : Colors.grey.shade200,
                ),

                /// SHADOW
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? Ucolors.primary.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LOGO
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: logoSize,
                          width: logoSize,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? Ucolors.primary.withValues(alpha: 0.06)
                                : Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: widget.isNetwork
                              ? CustomCachedImage(
                                  imageUrl: widget.imgPath,
                                  size: logoSize,
                                )
                              : Image.asset(
                                  widget.imgPath,
                                  fit: BoxFit.contain,
                                ),
                        ),

                        SizedBox(width: isMobile ? 10 : 14),

                        /// TITLE
                        Expanded(
                          child: Text(
                            widget.name,
                            maxLines: isMobile ? 3 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: titleSize,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: isHovered
                                  ? Ucolors.primary
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isMobile ? 10 : 14),

                  /// BOTTOM
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// LABEL
                        Text(
                          '3Y Return',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.medium,
                          ),
                        ),

                        /// VALUE
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Ucolors.success.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Ucolors.success,
                                size: 14,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Text(
                              '${widget.threeYear ?? '--'}%',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 15,
                                fontWeight: FontWeight.bold,
                                color: Ucolors.success,
                                fontFamily: FontFamily.medium,
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
          ),
        ),
      ),
    );
  }
}

class PopularFundCardMob extends StatelessWidget {
  const PopularFundCardMob({
    super.key,
    required this.imgPath,
    required this.name,
    this.onTap,
    this.isNetwork = false,
    this.borderColor = Ucolors.borderColor,
    this.threeYear,
  });

  final String imgPath;
  final String name;
  final VoidCallback? onTap;
  final bool isNetwork;
  final Color borderColor;
  final String? threeYear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(color: borderColor),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withValues(alpha:0.04),
        //       blurRadius: 10,
        //       offset: const Offset(0, 3),
        //     ),
        //   ],
        // ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.grey.shade50,
                        child: isNetwork
                            ? CustomCachedImage(imageUrl: imgPath, size: 40)
                            : Image.asset(imgPath, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: UTextStyles.medium.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '3Y',
                    style: UTextStyles.bodySmallW500.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_drop_up_rounded,
                        color: Ucolors.success,
                        size: 20,
                      ),
                      Text(
                        '${threeYear}%',
                        style: UTextStyles.bodySmallW500.copyWith(
                          color: Ucolors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalBaseSIPCard extends StatelessWidget {
  const GoalBaseSIPCard({
    super.key,
    required this.title,
    required this.iconData,
    this.onTap,
  });
  final String title;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Ucolors.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(iconData, size: 20, color: Ucolors.blue),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFEEF5FF),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Icon(iconData, size: 20, color: Ucolors.blue),
              // ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: UTextStyles.small.copyWith(
                    color: Ucolors.dark,
                    fontSize: 11,
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolsItem extends StatelessWidget {
  const ToolsItem({
    super.key,
    required this.title,
    required this.imgUrl,
    this.onTap,
  });
  final String title;
  final String imgUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: isDesktop ? 35 : 45,
            width: isDesktop ? 35 : 45,
            child: Image.asset(imgUrl),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              title,
              style: UTextStyles.medium.copyWith(
                color: Ucolors.secondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionItemMob extends StatefulWidget {
  final String iconImg;
  final String title;
  final VoidCallback? onTap;

  const CollectionItemMob({
    super.key, // Use super parameters for cleaner code
    required this.iconImg,
    required this.title,
    this.onTap,
  });

  @override
  State<CollectionItemMob> createState() => _CollectionItemMobState();
}

class _CollectionItemMobState extends State<CollectionItemMob> {
  double scale = 1.0;
  bool isPressed = false;

  // Helper to handle the animation state
  void _updateState(bool pressed) {
    setState(() {
      isPressed = pressed;
      scale = pressed ? 0.92 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isPressed
              ? RadialGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                )
              : null,
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.blue.withValues(alpha: 0.2),
            highlightColor: Colors
                .transparent, // Hide default highlight to see your custom animation
            // Trigger animation on press
            onTapDown: (_) => _updateState(true),
            onTapCancel: () => _updateState(false),

            onTap: () async {
              // 1. Brief delay to let the user see the "pressed" state
              _updateState(true);
              await Future.delayed(const Duration(milliseconds: 100));

              // 2. Reset state
              _updateState(false);

              // 3. Execute navigation
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(widget.iconImg, height: 48, width: 48),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.1,
                      fontFamily: FontFamily.medium,
                      // fontWeight: FontWeight.w500,
                      color: Color(0xff2A7BBF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WebActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const WebActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  State<WebActionCard> createState() => _WebActionCardState();
}

class _WebActionCardState extends State<WebActionCard> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  void _setPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// RESPONSIVE
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;

    final double cardHeight = isMobile
        ? 150
        : isTablet
        ? 165
        : 190;

    final double iconBoxSize = isMobile
        ? 48
        : isTablet
        ? 54
        : 60;

    final double iconSize = isMobile
        ? 22
        : isTablet
        ? 26
        : 30;

    final double titleFontSize = isMobile
        ? 14
        : isTablet
        ? 15
        : 16;

    final double subtitleFontSize = isMobile
        ? 10
        : isTablet
        ? 11
        : 12;

    final double padding = isMobile ? 14 : 18;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        scale: isPressed
            ? 0.97
            : isHovered
            ? 1.02
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: widget.color.withValues(alpha: 0.08),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,

            onTapDown: (_) => _setPressed(true),

            onTapCancel: () => _setPressed(false),

            onTap: () async {
              _setPressed(true);

              await Future.delayed(const Duration(milliseconds: 90));

              _setPressed(false);

              widget.onTap?.call();
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: cardHeight,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                /// BACKGROUND
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Colors.white, widget.color.withValues(alpha: 0.06)]
                      : [
                          widget.color.withValues(alpha: 0.08),
                          widget.color.withValues(alpha: 0.03),
                        ],
                ),

                /// BORDER
                border: Border.all(
                  color: isHovered
                      ? widget.color.withValues(alpha: 0.18)
                      : widget.color.withValues(alpha: 0.10),
                ),

                /// SHADOW
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? widget.color.withValues(alpha: 0.14)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ICON BOX
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: iconBoxSize,
                        width: iconBoxSize,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.color,
                              widget.color.withValues(alpha: 0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withValues(
                                alpha: isHovered ? 0.28 : 0.16,
                              ),
                              blurRadius: isHovered ? 18 : 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),

                      AnimatedRotation(
                        turns: isHovered ? 0.08 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: iconSize - 6,
                          color: isHovered
                              ? widget.color
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// TITLE
                  Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.medium,
                      height: 1.3,
                      color: isHovered ? widget.color : const Color(0xff1E293B),
                    ),
                  ),

                  SizedBox(height: isMobile ? 6 : 8),

                  /// SUBTITLE
                  Text(
                    widget.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      height: 1.5,
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CollectionItem extends StatefulWidget {
  final String iconImg;
  final String title;
  final VoidCallback? onTap;

  const CollectionItem({
    super.key,
    required this.iconImg,
    required this.title,
    this.onTap,
  });

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}

class _CollectionItemState extends State<CollectionItem> {
  double scale = 1.0;
  bool isPressed = false;
  bool isHovered = false;

  void _updatePressed(bool value) {
    setState(() {
      isPressed = value;
      scale = value ? 0.96 : 1.0;
    });
  }

  void _updateHover(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        /// We use the available width provided by the parent
        final double maxWidth = constraints.maxWidth;

        final bool isSmall = maxWidth < 160;
        final bool isLarge = maxWidth > 300;

        /// Scaling logic based on local constraints
        final double iconSize = isSmall ? 32 : (isLarge ? 60 : 48);
        final double fontSize = isSmall ? 10 : (isLarge ? 18 : 15);
        final double containerPadding = isSmall ? 8 : 14;
        final double borderRadius = isSmall ? 12 : 18;
        final double iconBoxSize = isSmall ? 54 : (isLarge ? 74 : 64);

        return MouseRegion(
          onEnter: (_) => _updateHover(true),
          onExit: (_) => _updateHover(false),
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHovered
                      ? [Colors.white, Ucolors.primary.withValues(alpha: 0.04)]
                      : [Colors.grey.shade50, Colors.grey.shade200],
                ),
                border: Border.all(
                  color: isHovered
                      ? Ucolors.primary.withValues(alpha: 0.18)
                      : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? Ucolors.primary.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: isHovered ? 18 : 8,
                    spreadRadius: isHovered ? 1 : 0,
                    offset: Offset(0, isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  splashColor: Ucolors.primary.withValues(alpha: 0.10),
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTapDown: (_) => _updatePressed(true),
                  onTapCancel: () => _updatePressed(false),
                  onTap: () async {
                    _updatePressed(true);
                    await Future.delayed(const Duration(milliseconds: 90));
                    _updatePressed(false);
                    widget.onTap?.call();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(containerPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Hug content
                      children: [
                        /// ICON CONTAINER
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: iconBoxSize,
                          width: iconBoxSize,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isHovered
                                ? Ucolors.primary.withValues(alpha: 0.08)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Image.asset(
                            widget.iconImg,
                            height: iconSize,
                            width: iconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: isSmall ? 6 : 12),

                        /// TITLE
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: fontSize,
                            height: 1.4,
                            fontWeight: FontWeight.normal,
                            fontFamily: FontFamily.bold,
                            color: isHovered
                                ? const Color(0xff2A7BBF)
                                : Ucolors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  const FilterChip({required this.label, this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Ucolors.textFormEnabled : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureSection extends StatelessWidget {
  const FeatureSection({
    super.key,
    required this.featureName,
    required this.iconPath,
  });
  final String featureName;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Ucolors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          featureName,
          style: UTextStyles.medium.copyWith(
            color: Ucolors.light,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class AnimatedWelcomeText extends StatefulWidget {
  final String name;

  const AnimatedWelcomeText({super.key, required this.name});

  @override
  State<AnimatedWelcomeText> createState() => _AnimatedWelcomeTextState();
}

class _AnimatedWelcomeTextState extends State<AnimatedWelcomeText> {
  bool _showSecondText = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 10-second precise loop
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _showSecondText = !_showSecondText;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 650),
        switchInCurve: const Cubic(0.05, 0.7, 0.1, 1.0),
        switchOutCurve: Curves.easeInCubic,

        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },

        transitionBuilder: (Widget child, Animation<double> animation) {
          final isEntering = child.key == ValueKey(_showSecondText);

          final slideOffset = Tween<Offset>(
            begin: isEntering ? const Offset(0.0, 0.8) : Offset.zero,
            end: isEntering ? Offset.zero : const Offset(0.0, -0.8),
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideOffset, child: child),
          );
        },

        child: !_showSecondText
            ? RichText(
                key: const ValueKey(false),
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                    fontFamily: FontFamily.medium,
                  ),
                  children: [
                    const TextSpan(text: 'Welcome to, '),
                    TextSpan(
                      text: '${widget.name}!',
                      style: const TextStyle(
                        color: Color(0xFF0066FF),
                        fontWeight: FontWeight.w700,
                        fontFamily: FontFamily.medium,
                      ),
                    ),
                  ],
                ),
              )
            : RichText(
                key: const ValueKey(true),
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                    fontFamily: FontFamily.medium,
                  ),
                  children: [
                    TextSpan(text: 'Hello! '),
                    TextSpan(
                      text: "It's a pleasure to have you here",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        fontWeight: FontWeight.w700,
                        fontFamily: FontFamily.medium,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
