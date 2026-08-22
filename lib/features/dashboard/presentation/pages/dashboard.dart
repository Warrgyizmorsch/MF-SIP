import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/domain/entity/transactionlist_entity.dart';
import 'package:my_sip/features/mfu/presentation/pages/redeem_page.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/comparison_chart.dart';

enum PortfolioMenuAction {
  topUp,
  modify,
  pause,
  cancel,
  redemption,
  switchgoal,
}

/// --- PopMenuItem
PopupMenuItem<PortfolioMenuAction> buildMenuItem({
  required IconData icon,
  required String text,
  required PortfolioMenuAction value,
}) {
  return PopupMenuItem<PortfolioMenuAction>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

///------Bottom Dashed Painter----------//
class BottomDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height - 10);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height + 10,
      size.width * 0.5,
      size.height - 5,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 20,
      size.width,
      size.height - 10,
    );

    /// Dash logic
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

///-----------Bottom Clliper ----------///
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 20,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 40,
      size.width,
      size.height - 20,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// --- 1. MAIN SCREEN WRAPPER ---
class DashboardScreen extends GetView<DashboardController> {
  DashboardScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Initialize controller

    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Ucolors.light,
      body: isDesktop
          ? WebDashboardLayout(cartController: cartController)
          : _MobileDashboardLayout(
              cartController: cartController,
              dashboardController: controller,
            ),
    );
  }
}

// =========================================================================
// 💻 WEB DASHBOARD LAYOUT (Matches image_0d5c7f.png Exactly)
// =========================================================================
// =========================================================================
// 💻 WEB DASHBOARD LAYOUT (Fully Responsive with Advanced Stepping)
// =========================================================================
class WebDashboardLayout extends StatelessWidget {
  final CartController cartController;
  const WebDashboardLayout({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(
        0xFFF8FAFC,
      ), // Ultra-light premium dashboard background
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double textScale = MediaQuery.textScalerOf(context).scale(1.0);

          // 1. Structural Breakpoints
          final bool useVerticalSplit = width < (980 * textScale);
          final int statCrossAxisCount;
          final double statAspectRatio;

          if (width >= (1100 * textScale)) {
            statCrossAxisCount = 4;
            statAspectRatio = 2.2;
          } else if (width >= (700 * textScale)) {
            statCrossAxisCount = 2;
            statAspectRatio = 2.5;
          } else {
            statCrossAxisCount = 2;
            statAspectRatio = 2.6;
          }

          // Shared Widget Content Blocks
          final Widget mainContentBlock = Column(
            children: [
              _buildPerformanceChartCard(),
              const Gap(24),
              _buildYourHoldingsTableCard(
                width,
              ), // Dynamic compression support inside table
              const Gap(24),
              _buildBottomSummaryRow(useVerticalSplit),
            ],
          );

          final Widget sidebarContentBlock = Column(
            children: [
              _buildQuickActionsCard(),
              const Gap(24),
              _buildUpcomingSIPsCard(),
              const Gap(24),
              _buildRecentActivityCard(),
            ],
          );

          return Column(
            children: [
              // 2. SCROLLABLE CONTENT BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- ROW 1: DYNAMIC SUMMARY GRID ---
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: statCrossAxisCount,
                          childAspectRatio: statAspectRatio,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        children: const [
                          ExactWebStatCard(
                            title: "Current Value",
                            value: "₹32,580",
                            trendText: "1.24% vs last month",
                            trendIcon: Icons.arrow_upward_rounded,
                            valueColor: Color(0xFF0F172A),
                            trendColor: Color(0xFF22C55E),
                            icon: Icons.wallet,
                            iconBgColor: Color(0xFFEFF6FF),
                            iconColor: Color(0xFF1D4ED8),
                            sparklineData: [20, 15, 25, 18, 30, 22, 35, 45],
                          ),
                          ExactWebStatCard(
                            title: "Total Investment",
                            value: "₹30,000",
                            trendText: "0.00% vs last month",
                            trendIcon: Icons.remove,
                            valueColor: Color(0xFF0F172A),
                            trendColor: Color(0xFF64748B),
                            icon: Icons.paid,
                            iconBgColor: Color(0xFFFFF7ED),
                            iconColor: Color(0xFFEA580C),
                            sparklineData: [15, 25, 12, 20, 15, 22, 18, 20],
                          ),
                          ExactWebStatCard(
                            title: "Profit / Loss",
                            value: "+₹2,580",
                            trendText: "1.24% vs last month",
                            trendIcon: Icons.arrow_upward_rounded,
                            valueColor: Color(0xFF22C55E),
                            trendColor: Color(0xFF22C55E),
                            icon: Icons.trending_up_rounded,
                            iconBgColor: Color(0xFFF0FDF4),
                            iconColor: Color(0xFF16A34A),
                            sparklineData: [10, 12, 22, 15, 20, 28, 35, 48],
                          ),
                          ExactWebStatCard(
                            title: "Portfolio XIRR",
                            value: "+15.06%",
                            trendText: "15.06% all time",
                            trendIcon: Icons.arrow_upward_rounded,
                            valueColor: Color(0xFF9333EA),
                            trendColor: Color(0xFF22C55E),
                            icon: Icons.percent_rounded,
                            iconBgColor: Color(0xFFFAF5FF),
                            iconColor: Color(0xFF9333EA),
                            sparklineData: [12, 20, 14, 18, 15, 25, 22, 30],
                          ),
                        ],
                      ),

                      const Gap(24),

                      // --- ROW 2: ADAPTIVE SPLIT VIEW (MAIN CHART + SIDEBAR) ---
                      if (useVerticalSplit) ...[
                        mainContentBlock,
                        const Gap(24),
                        sidebarContentBlock,
                      ] else ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LEFT SIDE OVERVIEW (65% width)
                            Expanded(flex: 65, child: mainContentBlock),
                            const Gap(24),
                            // RIGHT SIDEBAR PANELS (35% width)
                            Expanded(flex: 35, child: sidebarContentBlock),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomSummaryRow(bool useVerticalLayout) {
    if (useVerticalLayout) {
      return const Column(
        children: [TopPerformingFundCard(), Gap(24), GoalProgressCard()],
      );
    }
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: TopPerformingFundCard()),
        Gap(24),
        Expanded(child: GoalProgressCard()),
      ],
    );
  }

  Widget _buildPerformanceChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const FundComparisonChartWidget(),
    );
  }

  // Modified Holdings layout to switch to SingleChildScrollView scrolling on compressed slots
  Widget _buildYourHoldingsTableCard(double totalWidth) {
    final bool isCompactTable = totalWidth < 750;

    final tableWidget = Table(
      columnWidths: isCompactTable
          ? const {
              0: FixedColumnWidth(
                220,
              ), // Lock sizing to prevent clipping text strings
              1: FixedColumnWidth(90),
              2: FixedColumnWidth(100),
              3: FixedColumnWidth(100),
              4: FixedColumnWidth(100),
              5: FixedColumnWidth(90),
              6: FixedColumnWidth(110),
            }
          : const {
              0: FlexColumnWidth(3.8),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.4),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1.4),
              5: FlexColumnWidth(1.4),
              6: FlexColumnWidth(1.5),
            },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
            ),
          ),
          children: [
            _buildHeaderCell('Fund Name\nCategory'),
            _buildHeaderCell('Type'),
            _buildHeaderCell('Invested\nAmount'),
            _buildHeaderCell('Current\nValue'),
            _buildHeaderCell('Gain / Loss\n(₹)'),
            _buildHeaderCell('Gain / Loss\n(%)'),
            _buildHeaderCell('Monthly\nContribution'),
          ],
        ),
        _buildTableRowItem(
          logoWidget: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 18,
          ),
          logoBgColor: const Color(0xFF007AFF),
          name: "Nippon India Large Cap Fund",
          category: "Equity • Large Cap",
          type: "SIP",
          invested: "₹10,000",
          current: "₹5,43,000",
          gainAmt: "+₹43,000",
          gainPct: "+8.60%",
          monthlyContribution: "₹5,000",
          isProfit: true,
        ),
        _buildTableRowItem(
          logoWidget: const Center(
            child: Text(
              "i",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          logoBgColor: const Color(0xFFE11D48),
          name: "ICICI Prudential Technology Fund",
          category: "Equity • Sectoral / Tech",
          type: "Lumpsum",
          invested: "₹10,000",
          current: "₹4,82,000",
          gainAmt: "+₹82,000",
          gainPct: "+20.50%",
          monthlyContribution: "—\n(One-time)",
          isProfit: true,
          isMonthlyContributionSubtitled: true,
        ),
        _buildTableRowItem(
          logoWidget: const Icon(
            Icons.show_chart_rounded,
            color: Colors.white,
            size: 18,
          ),
          logoBgColor: const Color(0xFF0B3C5D),
          name: "SBI Bluechip Fund",
          category: "Equity • Large Cap",
          type: "SIP",
          invested: "₹15,000",
          current: "₹4,21,000",
          gainAmt: "+₹71,000",
          gainPct: "+20.29%",
          monthlyContribution: "₹2,000",
          isProfit: true,
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Holdings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                  fontFamily: FontFamily.regular,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          isCompactTable
              ? Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 12),
                    child: tableWidget,
                  ),
                )
              : tableWidget,
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w600,
          height: 1.3,
          fontFamily: FontFamily.regular,
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              fontFamily: FontFamily.regular,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: _buildActionGridItem(
                  "Top Up",
                  "Add money\nInstantly",
                  Icons.add,
                  const Color(0xFF3B82F6),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildActionGridItem(
                  "Withdraw",
                  "Redeem to\nbank",
                  Icons.remove,
                  const Color(0xFFF97316),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildActionGridItem(
                  "SIP",
                  "Manage\nmonthly SIP",
                  Iconsax.calendar,
                  const Color(0xFFA855F7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionGridItem(
    String label,
    String sub,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const Gap(12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: FontFamily.regular,
            ),
          ),
          const Gap(4),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              height: 1.2,
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSIPsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upcoming SIPs",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View All",
                  style: TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
                ),
              ),
            ],
          ),
          const Gap(12),
          _buildSipRowItem("10 Jun", "Kotak Bluechip Fund", "₹5,000"),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          _buildSipRowItem("15 Jun", "ICICI Prudential Tech", "₹3,000"),
        ],
      ),
    );
  }

  Widget _buildSipRowItem(String date, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            date,
            style: const TextStyle(
              color: Color(0xFF0284C7),
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: FontFamily.regular,
            ),
          ),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: FontFamily.regular,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: FontFamily.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                  fontFamily: FontFamily.regular,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          _buildActivityRowItem(
            icon: Iconsax.document_text5,
            title: "SIP Invested",
            subtitle: "Kotak Bluechip Fund",
            amount: "₹5,000",
            timeAgo: "Today",
          ),
          const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),
          _buildActivityRowItem(
            icon: Iconsax.calendar_tick,
            title: "SIP Invested",
            subtitle: "ICICI Prudential Tech",
            amount: "₹3,000",
            timeAgo: "2 days ago",
          ),
          const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),
          _buildActivityRowItem(
            icon: Iconsax.clock,
            title: "Redemption",
            subtitle: "SBI Small Cap Fund",
            amount: "₹2,000",
            timeAgo: "5 days ago",
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRowItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String timeAgo,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF475569)),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                  fontFamily: FontFamily.regular,
                ),
              ),
              const Gap(4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.regular,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: FontFamily.regular,
          ),
        ),
        const Gap(24),
        SizedBox(
          width: 75,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              timeAgo,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.regular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 🏷 TABLE ROW ITEM METHOD
// =========================================================================
TableRow _buildTableRowItem({
  required Widget logoWidget,
  required Color logoBgColor,
  required String name,
  required String category,
  required String type,
  required String invested,
  required String current,
  required String gainAmt,
  required String gainPct,
  required String monthlyContribution,
  required bool isProfit,
  bool isMonthlyContributionSubtitled = false,
}) {
  final trendColor = isProfit
      ? const Color(0xFF22C55E)
      : const Color(0xFFEF4444);

  // Dynamic Type Chip Color configuration matching image layout rules
  Color typeBgColor = const Color(0xFFEFF6FF); // Default SIP Blue
  Color typeTextColor = const Color(0xFF1D4ED8);
  if (type == "Lumpsum") {
    typeBgColor = const Color(0xFFF3E8FF); // Purple
    typeTextColor = const Color(0xFF7E22CE);
  } else if (type == "SIP + Lumpsum") {
    typeBgColor = const Color(0xFFECFDF5); // Mint Teal
    typeTextColor = const Color(0xFF047857);
  }

  return TableRow(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFF8FAFC), width: 1)),
    ),
    children: [
      // 1. Fund Icon + Name and Category Group
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: logoBgColor,
                borderRadius: BorderRadius.circular(
                  8,
                ), // Round-square configuration
              ),
              child: Center(child: logoWidget),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // 2. Type Badge
      UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            decoration: BoxDecoration(
              color: typeBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: typeTextColor,
                fontFamily: FontFamily.regular,
              ),
            ),
          ),
        ),
      ),

      // 3. Invested Amount
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          invested,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: FontFamily.regular,
          ),
        ),
      ),

      // 4. Current Value
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          current,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: FontFamily.regular,
          ),
        ),
      ),

      // 5. Gain / Loss Value (₹)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          gainAmt,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: trendColor,
            fontFamily: FontFamily.regular,
          ),
        ),
      ),

      // 6. Gain / Loss (%)
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          gainPct,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: trendColor,
            fontFamily: FontFamily.regular,
          ),
        ),
      ),

      // 7. Monthly Contribution
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          monthlyContribution,
          style: TextStyle(
            fontSize: isMonthlyContributionSubtitled ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
            height: 1.2,
            fontFamily: FontFamily.regular,
          ),
        ),
      ),
    ],
  );
}

// =========================================================================
// ⚡ SIDEBAR WIDGETS
// =========================================================================
Widget _buildQuickActionsCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: FontFamily.regular,
          ),
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: _buildActionGridItem(
                "Top Up",
                "Add money\nInstantly",
                Icons.add,
                const Color(0xFF3B82F6),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildActionGridItem(
                "Withdraw",
                "Redeem to\nbank",
                Icons.remove,
                const Color(0xFFF97316),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _buildActionGridItem(
                "SIP",
                "Manage\nmonthly SIP",
                Iconsax.calendar,
                const Color(0xFFA855F7),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildActionGridItem(
  String label,
  String sub,
  IconData icon,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFF1F5F9)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const Gap(12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: FontFamily.regular,
          ),
        ),
        const Gap(4),
        Text(
          sub,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            height: 1.2,
            fontWeight: FontWeight.w400,
            fontFamily: FontFamily.regular,
          ),
        ),
      ],
    ),
  );
}

Widget _buildUpcomingSIPsCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming SIPs",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
                fontFamily: FontFamily.regular,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF3B82F6),
                  fontFamily: FontFamily.regular,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        _buildSipRowItem("10 Jun", "Kotak Bluechip Fund", "₹5,000"),
        const Divider(height: 20, color: Color(0xFFF1F5F9)),
        _buildSipRowItem("15 Jun", "ICICI Prudential Tech", "₹3,000"),
      ],
    ),
  );
}

Widget _buildSipRowItem(String date, String title, String value) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          date,
          style: const TextStyle(
            color: Color(0xFF0284C7),
            fontWeight: FontWeight.w600,
            fontSize: 12,
            fontFamily: FontFamily.regular,
          ),
        ),
      ),
      const Gap(12),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
            fontFamily: FontFamily.regular,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
          fontFamily: FontFamily.regular,
        ),
      ),
    ],
  );
}

// =========================================================================
// 🍩 1. PORTFOLIO ALLOCATION CARD (Matches image_17bb38.png Exactly)
// =========================================================================
Widget _buildPortfolioAllocationCard() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Portfolio Allocation",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: FontFamily.regular,
          ),
        ),
        const Gap(24),
        Row(
          children: [
            // --- CUSTOM MULTI-SEGMENT DONUT DESIGN ---
            SizedBox(
              height: 110,
              width: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(110, 110),
                    painter: MultiSegmentDonutPainter(
                      segments: [
                        DonutSegment(
                          value: 60,
                          color: const Color(0xFF007AFF),
                        ), // Equity Blue
                        DonutSegment(
                          value: 22,
                          color: const Color(0xFF34C759),
                        ), // Debt Green
                        DonutSegment(
                          value: 10,
                          color: const Color(0xFFFF9500),
                        ), // Hybrid Orange
                        DonutSegment(
                          value: 8,
                          color: const Color(0xFFFFCC00),
                        ), // Cache/Other Yellow
                      ],
                      strokeWidth: 16,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "₹32,580",
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Gap(2),
                      Text(
                        "Current Value",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontFamily.regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(32),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(3, (index) {
                    final data = [
                      {
                        "label": "Equity",
                        "pct": "60.0%",
                        "amount": "₹22,144",
                        "color": const Color(0xFF007AFF),
                      },
                      {
                        "label": "Debt",
                        "pct": "22.0%",
                        "amount": "₹7,163",
                        "color": const Color(0xFF34C759),
                      },
                      {
                        "label": "Hybrid",
                        "pct": "10.0%",
                        "amount": "₹3,268",
                        "color": const Color(0xFFFF9500),
                      },
                    ];

                    final item = data[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == data.length - 1 ? 0 : 14,
                      ),
                      child: _buildAllocationRowItem(
                        item["label"] as String,
                        item["pct"] as String,
                        item["amount"] as String,
                        item["color"] as Color,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const Gap(20),

        // --- VIEW FULL ALLOCATION REDIRECT BUTTON ---
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View Full Allocation",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(6),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 11,
                  color: Color(0xFF007AFF),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildAllocationRowItem(
  String label,
  String pct,
  String amount,
  Color color,
) {
  return Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const Gap(10),
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
          fontFamily: FontFamily.regular,
        ),
      ),
      const Spacer(),
      Text(
        pct,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF64748B),
          fontFamily: FontFamily.regular,
        ),
      ),
      const Gap(24),
      Text(
        amount,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
          fontFamily: FontFamily.regular,
        ),
      ),
    ],
  );
}

// =========================================================================
// 🕒 2. RECENT ACTIVITY CARD (Matches image_17bb38.png Exactly)
// =========================================================================
Widget _buildRecentActivityCard() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
                fontFamily: FontFamily.regular,
              ), // Matching deep purple-blue
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.regular,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),

        // --- ACTIVITY LIST ROWS ---
        _buildActivityRowItem(
          icon: Iconsax.document_text5, // Or Icons.receipt_long
          title: "SIP Invested",
          subtitle: "Kotak Bluechip Fund",
          amount: "₹5,000",
          timeAgo: "Today",
        ),
        const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),
        _buildActivityRowItem(
          icon: Iconsax.calendar_tick,
          title: "SIP Invested",
          subtitle: "ICICI Prudential Tech",
          amount: "₹3,000",
          timeAgo: "2 days ago",
        ),
        const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),
        _buildActivityRowItem(
          icon: Iconsax.clock,
          title: "Redemption",
          subtitle: "SBI Small Cap Fund",
          amount: "₹2,000",
          timeAgo: "5 days ago",
        ),
        const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),

        // --- ACTIVITY LIST ROWS ---
        _buildActivityRowItem(
          icon: Iconsax.document_text5, // Or Icons.receipt_long
          title: "Lumpsum Invested",
          subtitle: "Kotak Bluechip Fund",
          amount: "₹5,000",
          timeAgo: "Today",
        ),
        const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),
        _buildActivityRowItem(
          icon: Iconsax.calendar_tick,
          title: "Lumpsum Invested",
          subtitle: "ICICI Prudential Tech",
          amount: "₹3,000",
          timeAgo: "2 days ago",
        ),
        const Divider(height: 24, thickness: 0.8, color: Color(0xFFF1F5F9)),
        _buildActivityRowItem(
          icon: Iconsax.clock,
          title: "Redemption",
          subtitle: "SBI Small Cap Fund",
          amount: "₹2,000",
          timeAgo: "5 days ago",
        ),
      ],
    ),
  );
}

Widget _buildActivityRowItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required String amount,
  required String timeAgo,
}) {
  return Row(
    children: [
      // Icon Box Color Treatment
      Icon(icon, size: 24, color: const Color(0xFF475569)),
      const Gap(16),

      // Title Block
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
                fontFamily: FontFamily.regular,
              ),
            ),
            const Gap(4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.regular,
              ),
            ),
          ],
        ),
      ),

      // Amount Value Block
      Text(
        amount,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
          fontFamily: FontFamily.regular,
        ),
      ),
      const Gap(
        40,
      ), // Balanced side alignment padding matching the image row layout
      // Timing Stamp Block
      SizedBox(
        width: 75,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            timeAgo,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.regular,
            ),
          ),
        ),
      ),
    ],
  );
}

class TopPerformingFundCard extends StatelessWidget {
  const TopPerformingFundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Performing Fund",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF22C55E),
                  fontFamily: FontFamily.regular,
                ), // Green text
              ),
              Icon(
                Icons.trending_up_rounded,
                color: const Color(0xFF22C55E),
                size: 20,
              ),
            ],
          ),
          Gap(14),

          // Fund Details and Mini Graph Split Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Left: Logo & Returns Text
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Logo (Placeholder matching your asset configuration)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "i",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "ICICI Prudential Technology Fund",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                              fontFamily: FontFamily.regular,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            "Return (YTD)",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontFamily.regular,
                            ),
                          ),
                          const Gap(4),
                          const Text(
                            "+24.58%",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF22C55E),
                              fontFamily: FontFamily.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Smooth Sparkline Mini Wave Graph
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 50,
                  child: CustomPaint(
                    painter: SmoothSparkPainter(
                      data: [10, 12, 11, 15, 14, 22, 20, 26, 24, 32, 36],
                      lineColor: const Color(0xFF22C55E),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Footer Navigation Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: const Text(
                  "View Fund Details",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: Color(0xFF007AFF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 🎯 2. GOAL PROGRESS CARD
// =========================================================================
class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text
          const Text(
            "Goal Progress",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF007AFF),
              fontFamily: FontFamily.regular,
            ), // Blue text
          ),
          Gap(14),
          // Target Info Block Split Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.radar_2,
                  color: Color(0xFF007AFF),
                  size: 22,
                ),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Retirement Fund",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    "Target: ₹25,00,000",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                "62%",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                  fontFamily: FontFamily.regular,
                ),
              ),
            ],
          ),
          const Gap(16),

          // Progress Ratio Text Values
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "₹15,50,000 ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    fontFamily: FontFamily.regular,
                  ),
                ),
                TextSpan(
                  text: "of ₹25,00,000",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),

          // Linear Flat Progress Bar Segment
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.62,
              minHeight: 8,
              backgroundColor: Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
            ),
          ),
          const Spacer(),

          // Footer Navigation Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: const Text(
                  "View All Goals",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF007AFF),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: Color(0xFF007AFF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 🖌 CUSTOM SMOOTH LINE SPARKLINE PAINTER (WITH AREA FILL GRADIENT)
// =========================================================================
class SmoothSparkPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  SmoothSparkPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxX = (data.length - 1).toDouble();
    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double rangeY = maxY - minY == 0 ? 1.0 : maxY - minY;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final double x = (i / maxX) * size.width;
      final double y =
          size.height - ((data[i] - minY) / rangeY) * (size.height - 8) - 4;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == data.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    // Draw area fill color matching gradient style properties
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.12), lineColor.withOpacity(0.00)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw upper stroke line path
    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant SmoothSparkPainter oldDelegate) => true;
}

// =========================================================================
// 🖌 MATHEMATICAL RE-DRAW PAINTER FOR SEGMENTED PIE/DONUT CHART
// =========================================================================
class DonutSegment {
  final double value;
  final Color color;
  DonutSegment({required this.value, required this.color});
}

class MultiSegmentDonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;

  MultiSegmentDonutPainter({required this.segments, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = segments.map((s) => s.value).reduce((a, b) => a + b);
    if (total == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Clean layout edge styling

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // Dynamic continuous rotation path matching chart positioning starting at top-left/blue quadrant
    double startAngle = -1.2;

    for (var segment in segments) {
      final sweepAngle = (segment.value / total) * 2 * 3.141592653589793;
      paint.color = segment.color;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant MultiSegmentDonutPainter oldDelegate) => true;
}
// =========================================================================
// 💎 PIXEL-PERFECT STAT CARD WITH MINI SPARKLINE
// =========================================================================

class ExactWebStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color valueColor;
  final List<double> sparklineData;

  const ExactWebStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.trendText,
    required this.trendIcon,
    required this.trendColor,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.valueColor,
    required this.sparklineData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double textScale = MediaQuery.textScalerOf(context).scale(1.0);

        // 1. Calculate granular, un-overflowable font stepping tiers
        final double titleFontSize;
        final double valueFontSize;
        final double trendFontSize;
        final double iconSize;
        final double paddingValue;
        final double sparklineHeight;

        if (width >= (450 * textScale)) {
          titleFontSize = 14;
          valueFontSize = 30;
          trendFontSize = 13;
          iconSize = 24;
          paddingValue = 20;
          sparklineHeight = 36;
        } else if (width >= (320 * textScale)) {
          titleFontSize = 13;
          valueFontSize = 26;
          trendFontSize = 12;
          iconSize = 22;
          paddingValue = 16;
          sparklineHeight = 32;
        } else if (width >= (260 * textScale)) {
          titleFontSize = 12;
          valueFontSize = 22;
          trendFontSize = 11;
          iconSize = 18;
          paddingValue = 12;
          sparklineHeight = 28;
        } else if (width >= (220 * textScale)) {
          titleFontSize = 11;
          valueFontSize = 18;
          trendFontSize = 10;
          iconSize = 16;
          paddingValue = 10;
          sparklineHeight = 24;
        } else {
          // Ultra Compact view dimensions
          titleFontSize = 10;
          valueFontSize = 15;
          trendFontSize = 9;
          iconSize = 14;
          paddingValue = 8;
          sparklineHeight = 20;
        }

        // Structural toggles to switch stack strategies based on space
        final bool useVerticalLayout = width < (180 * textScale);

        // --- Core Modules ---
        final Widget iconModule = Container(
          padding: EdgeInsets.all(paddingValue < 12 ? 8 : 12),
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: iconSize),
        );

        final Widget textModule = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: titleFontSize,
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.regular,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: valueColor,
                letterSpacing: -0.5,
                fontFamily: FontFamily.regular,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(trendIcon, size: trendFontSize + 2, color: trendColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    trendText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: trendFontSize,
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

        return Container(
          // REMOVED rigid hardcoded height: 140 to allow dynamic stretching
          constraints: BoxConstraints(minHeight: 135 * textScale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. MAIN CARD CONTENT
              Padding(
                padding: EdgeInsets.only(
                  left: paddingValue,
                  top: paddingValue,
                  right: paddingValue,
                  bottom:
                      paddingValue +
                      sparklineHeight, // Ensures content never overlaps with the chart
                ),
                child: useVerticalLayout
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          iconModule,
                          const SizedBox(height: 12),
                          textModule,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          iconModule,
                          SizedBox(width: paddingValue),
                          Expanded(child: textModule),
                        ],
                      ),
              ),

              // 2. BOTTOM MINI SPARKLINE CHART
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: sparklineHeight,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: CustomPaint(
                      painter: MiniSparklinePainter(
                        data: sparklineData,
                        lineColor: iconColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =========================================================================
// 🖌 CUSTOM PAINTER FOR THE SPARKLINE WAVE EFFECT
// =========================================================================
class MiniSparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  MiniSparklinePainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    double minX = 0;
    double maxX = (data.length - 1).toDouble();

    double minY = data.reduce((a, b) => a < b ? a : b);
    double maxY = data.reduce((a, b) => a > b ? a : b);

    // Prevent divide by zero if data is flat
    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    for (int i = 0; i < data.length; i++) {
      // Scale coordinates to fit inside the bottom clip area cleanly
      double x = (i / maxX) * size.width;
      double y =
          size.height -
          ((data[i] - minY) / (maxY - minY)) * (size.height - 8) -
          4;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MiniSparklinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.data != data;
  }
}

// ==========================================
// 📈 PREMIUM TOP METRIC STAT CARD FOR WEB
// ==========================================
class _WebTopStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final Color trendColor;
  final IconData icon;
  final Color iconColor;
  final Color chartColor;
  final bool isProfit;

  const _WebTopStatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.trendColor,
    required this.icon,
    required this.iconColor,
    required this.chartColor,
    this.isProfit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const Gap(8),
          Text(
            change,
            style: TextStyle(
              fontSize: 11,
              color: trendColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background color
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  _buildGoalTrackerCard(),
                  const SizedBox(height: 20),
                  _buildCashFlowCard(),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildGoalTrackerCard()),
                  const SizedBox(width: 24),
                  Expanded(child: _buildCashFlowCard()),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. GOAL TRACKER CARD
  /// ----------------------------------------------------
  Widget _buildGoalTrackerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Goal Tracker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 24),
          _buildGoalItem(
            icon: Icons.track_changes,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFFE6F4EA),
            title: 'Dream Home',
            currentAmount: '₹1,500,000',
            targetAmount: '₹5,000,000',
            progress: 0.30,
            progressText: '30% Completed',
          ),
          const SizedBox(height: 24),
          _buildGoalItem(
            icon: Icons
                .trending_up, // App me Iconsax.trending_up use kar sakte hain
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFEFF6FF),
            title: 'Car',
            currentAmount: '₹450,000',
            targetAmount: '₹1,200,000',
            progress: 0.38,
            progressText: '38% Completed',
          ),
          const SizedBox(height: 32),

          // Dotted Add New Goal Button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(
                color: Color(0xFF0284C7),
                style: BorderStyle.solid,
              ), // For pure dotted, use dotted_border package
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF0284C7), size: 20),
                SizedBox(width: 8),
                Text(
                  'Add New Goal',
                  style: TextStyle(
                    color: Color(0xFF0284C7),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String currentAmount,
    required String targetAmount,
    required double progress,
    required String progressText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Text(
              '$currentAmount / $targetAmount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          progressText,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 2. CASH FLOW CARD
  /// ----------------------------------------------------
  Widget _buildCashFlowCard() {
    // Static Dummy Data for Transactions
    final List<Map<String, dynamic>> transactions = [
      {
        'date': '10 Nov 2024',
        'fund': 'Kotak Bluechip',
        'type': 'SIP',
        'amount': '₹5,000',
        'isLumpSum': false,
      },
      {
        'date': '05 Nov 2024',
        'fund': 'ICICI Tech',
        'type': 'SIP',
        'amount': '₹3,000',
        'isLumpSum': false,
      },
      {
        'date': '01 Nov 2024',
        'fund': 'HDFC Midcap',
        'type': 'Lumpsum',
        'amount': '₹10,000',
        'isLumpSum': true,
      },
      {
        'date': '25 Oct 2024',
        'fund': 'SBI Small Cap',
        'type': 'SIP',
        'amount': '₹2,000',
        'isLumpSum': false,
      },
      {
        'date': '10 Oct 2024',
        'fund': 'Kotak Bluechip',
        'type': 'SIP',
        'amount': '₹5,000',
        'isLumpSum': false,
      },
    ];

    return Container(
      height:
          440, // Fixed height taaki scrollbar properly visible ho aur design clean lage
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cash Flow',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                'Latest 10 Transactions',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table Headers
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'DATE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'FUND',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'AMOUNT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),

          // Scrollable List Area
          Expanded(
            child: Scrollbar(
              thumbVisibility:
                  true, // Always show scrollbar track like in the screenshot
              thickness: 6,
              radius: const Radius.circular(8),
              child: ListView.separated(
                itemCount: transactions.length,
                padding: const EdgeInsets.only(right: 12),
                separatorBuilder: (context, index) => const Divider(
                  height: 32,
                  thickness: 0.5,
                  color: Color(0xFFF1F5F9),
                ),
                itemBuilder: (context, index) {
                  final item = transactions[index];
                  return Row(
                    children: [
                      // Date Column
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['date'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Fund Column (Name + Type)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['fund'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['type'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Amount Column (Color matching based on type)
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            item['amount'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: item['isLumpSum']
                                  ? const Color(0xFF0284C7)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// --- 💎 WEB WIDGETS ---

class _WebStatCard extends StatefulWidget {
  final String title;
  final String value;
  final String? trend;
  final IconData icon;
  final Color color;
  final bool isPrimary;
  final bool isProfit;

  const _WebStatCard({
    required this.title,
    required this.value,
    this.trend,
    required this.icon,
    required this.color,
    this.isPrimary = false,
    this.isProfit = false,
  });

  @override
  State<_WebStatCard> createState() => _WebStatCardState();
}

class _WebStatCardState extends State<_WebStatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),

        decoration: BoxDecoration(
          /// LIGHT PREMIUM BACKGROUND
          color: widget.color.withValues(alpha: 0.04),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: widget.color.withValues(alpha: 0.08)),

          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: isHovered ? 0.10 : 0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Stack(
          children: [
            /// WAVE BACKGROUND
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: CustomPaint(
                  painter: _CardWavePainter(
                    color: widget.color,
                    isProfit: widget.isProfit,
                  ),
                ),
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// TOP ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Ucolors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(widget.icon, color: widget.color, size: 20),
                      ),

                      if (widget.trend != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isProfit
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: widget.isProfit
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const Gap(4),
                            Text(
                              widget.trend!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: widget.isProfit
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  /// BOTTOM CONTENT
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.value,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1F2937),
                        ),
                      ),

                      const Gap(6),

                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
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

class _CardWavePainter extends CustomPainter {
  final Color color;
  final bool isProfit;

  _CardWavePainter({required this.color, this.isProfit = true});

  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.03)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Main wave path
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.8);

    if (isProfit) {
      wavePath.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.7,
        size.width * 0.5,
        size.height * 0.6,
      );
      wavePath.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.5,
        size.width,
        size.height * 0.4,
      );
    } else {
      wavePath.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.9,
        size.width * 0.5,
        size.height * 0.95,
      );
      wavePath.quadraticBezierTo(
        size.width * 0.75,
        size.height,
        size.width,
        size.height * 0.9,
      );
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, gradientPaint);

    // Optional highlight wave for depth
    final highlightPaint = Paint()..color = color.withValues(alpha: 0.08);
    final highlightPath = Path();
    highlightPath.moveTo(0, size.height * 0.9);
    highlightPath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.7,
    );
    highlightPath.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.6,
      size.width,
      size.height * 0.5,
    );
    highlightPath.lineTo(size.width, size.height);
    highlightPath.close();

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _CardWavePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isProfit != isProfit;
  }
}

class _WebActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _WebActionButton({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const Gap(8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _WebPortfolioRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Image.asset(UImages.sbi, fit: BoxFit.contain),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nippon India Large Cap Fund",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Equity • Growth",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "₹5,430",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "+8.55%",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileDashboardLayout extends StatelessWidget {
  final CartController cartController;
  final DashboardController dashboardController;
  const _MobileDashboardLayout({
    required this.cartController,
    required this.dashboardController,
  });

  @override
  Widget build(BuildContext context) {
    // THIS IS YOUR ORIGINAL CODE MOVED HERE
    return CustomScrollView(
      slivers: [
        /// 1️⃣ App Bar
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: false,
          pinned: true,
          flexibleSpace: CustomProfileAppbar(
            onProfiletap: () => Get.toNamed(AppRoutes.personaldetails),
            backgroundColor: const Color(0xffE8F5FF),
            greetingName: 'Pratik',
            role: 'Developer',
            avatar: AssetImage(UImages.avatar),
            iconColor: Ucolors.blue,
            roleColor: Ucolors.blue,
            greetingNameColor: Ucolors.blue,

            action: [
              CompactIcon(
                icon: Iconsax.notification,
                onPressed: () => Get.toNamed(AppRoutes.notification),
                iconColor: Ucolors.dark,
              ),

              Obx(
                () => Stack(
                  children: [
                    CompactIcon(
                      icon: Iconsax.shopping_cart,
                      onPressed: () {
                        Get.find<CartController>().filterGoalId.value = null;
                        Get.toNamed(AppRoutes.cart);
                        // cartController.fetchCart();
                      },
                      iconColor: Ucolors.dark,
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
              CompactIcon(
                icon: Iconsax.archive_tick,
                onPressed: () => Get.toNamed(AppRoutes.watchlist),
                iconColor: Ucolors.dark,
              ),
            ],
            actionsPadding: const EdgeInsets.only(right: 16),
          ),
        ),

        /// 2️⃣ Portfolio Summary Card
        SliverToBoxAdapter(
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              width: double.infinity,
              color: const Color(0xffE8F5FF),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: ClipPath(
                  clipper: BottomWaveClipper(),
                  child: Obx(() {
                    final summary =
                        dashboardController.portfolioData.value?.summary;
                    final isVisible =
                        dashboardController.isBalanceVisible.value;

                    // 2. Extract values with safe fallbacks (default to 0.0)
                    final currentValue = summary?.totalCurrentValue ?? 0.0;
                    final invested = summary?.totalInvested ?? 0.0;
                    final totalReturns = summary?.totalGainLoss ?? 0.0;
                    final isProfit = summary?.isOverallProfit ?? true;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff0B3C5D), Color(0xff072A40)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Value',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: Ucolors.skyblue, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // '₹${currentValue.toStringAsFixed(2)}',
                                isVisible
                                    ? '₹${currentValue.toStringAsFixed(2)}'
                                    : '₹ ••••••',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              CompactIcon(
                                icon: isVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onPressed: () {
                                  dashboardController.isBalanceVisible.toggle();
                                },
                                iconColor: Ucolors.light,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SummaryItem(
                                title: 'Invested',
                                amount: invested, // Pass the raw double
                                isVisible:
                                    isVisible, // Pass the reactive visibility state
                              ),
                              SummaryItem(
                                title: 'Total Returns',
                                amount: totalReturns, // Pass the raw double
                                isProfit: isProfit,
                                isVisible: isVisible,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),

        /// Dashed Painter
        SliverToBoxAdapter(
          child: CustomPaint(
            painter: BottomDashedLinePainter(),
            size: const Size(double.infinity, 0.01),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        /// My portfolio & Transactions Tabbar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xffF4F6F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() {
                final controller = Get.find<DashboardController>();

                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: controller.selectedIndex.value == 0
                                ? Ucolors.light
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'My Portfolio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectedIndex.value == 0
                                  ? Ucolors.primary
                                  : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: controller.selectedIndex.value == 1
                                ? Ucolors.light
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Transactions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectedIndex.value == 1
                                  ? Ucolors.primary
                                  : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        Obx(() {
          final controller = Get.find<DashboardController>();
          final isVisible = controller.isBalanceVisible.value;

          if (controller.selectedIndex.value == 0) {
            /// 🟦 MY PORTFOLIO TAB

            // 1. Handle Loading State
            if (controller.isLoadingPortfolio.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                ),
              );
            }

            // 2. Extract portfolio list
            final funds = controller.portfolioData.value?.portfolio ?? [];

            // 3. Handle Empty State
            if (funds.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text("No funds in your portfolio yet.")),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SectionHeading(
                    sectionTitle: 'My Portfolio',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    textcolor: const Color(0xff787878),
                  ),
                ),
                // 4. Map the actual funds to PortfolioCard
                ...funds
                    .map((fund) => PortfolioCard(fund: fund, isVisible: true))
                    .toList(),
              ]),
            );
          } else {
            if (controller.isLoadingTransactions.value) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                ),
              );
            }
            final txns = controller.transactionList.value?.transactions ?? [];

            if (txns.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text("No transactions found.")),
                ),
              );
            }

            final filteredTxns = controller.filteredTransactions;

            /// 🟩 TRANSACTIONS TAB
            return SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SectionHeading(
                    sectionTitle: 'Transactions',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    textcolor: const Color(0xff787878),
                  ),
                ),
                SizedBox(
                  height: 36, // Height of the filter bar
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.txnFilters.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = controller.txnFilters[index];
                      final isSelected =
                          controller.selectedTxnFilter.value == filter;

                      return GestureDetector(
                        onTap: () => controller.setTxnFilter(filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            // Smooth color transitions
                            color: isSelected ? Ucolors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Ucolors.primary
                                  : Colors.grey.shade300,
                              width: 1,
                            ),
                            // Add a subtle glow/shadow to the active pill
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Ucolors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade700,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                // ...txns
                //     .map((txn) => TransactionCardDash(transaction: txn))
                //     .toList(),
                ...filteredTxns.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 48,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No ${controller.selectedTxnFilter.value.toLowerCase()} transactions found.",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    : filteredTxns
                          .map((txn) => TransactionCardDash(transaction: txn))
                          .toList(),
              ]),
            );
          }
        }),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ==========================================
// 🛠 MODIFIED HELPER CARDS (Adapts to Web)
// ==========================================

class TransactionCardDash extends StatelessWidget {
  final bool isWebCompact;
  final MfuTransactionEntity transaction;

  const TransactionCardDash({
    super.key,
    this.isWebCompact = false,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the color based on your entity's computed status getters
    Color amountColor;
    if (transaction.isSuccess) {
      amountColor =
          Ucolors.success; // Assuming you have a success color defined
    } else if (transaction.isFailed) {
      amountColor = Ucolors.red; // Assuming you have a red/error color defined
    } else {
      amountColor = const Color(0xffF2994A); // Orange for Pending/Processing
    }

    return Container(
      margin: isWebCompact
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: isWebCompact ? EdgeInsets.zero : const EdgeInsets.all(16),
      decoration: isWebCompact
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.txnDate,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 14),
              ),
              Text(
                '₹${transaction.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${transaction.investmentType.toUpperCase()} - ${transaction.txtType.toUpperCase()}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff9A9A9A),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'Order: ${transaction.mfOrderId}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff9A9A9A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final bool isWebCompact;
  const TransactionCard({super.key, this.isWebCompact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // On Web, remove margin for cleaner list
      margin: isWebCompact
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: isWebCompact ? EdgeInsets.zero : const EdgeInsets.all(16),
      decoration: isWebCompact
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'January 10, 2024',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 14),
              ),
              Text(
                '₹1000',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Ucolors.success),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Funding from salary',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff9A9A9A),
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'Savings from Local Bank 1',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff9A9A9A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PortfolioCard extends StatelessWidget {
  final MfuPortfolioItemEntity fund;
  final bool isVisible;
  final bool subtitle;
  final bool iconButton;

  const PortfolioCard({
    super.key,
    required this.fund,
    required this.isVisible,
    this.subtitle = true,
    this.iconButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine Profit/Loss colors
    final is1DProfit = fund.isOneDayProfit;
    final isOverallProfit = fund.isProfit;

    return GestureDetector(
      // onTap: () => Get.to(() => FundDetailsScreen(), arguments: fund),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            /// 🔹 Top Row (Icon + Title + Menu)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Fund Logo
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: ClipOval(
                    // Using network image if amcLogo is a URL
                    child: fund.amcLogo.isNotEmpty
                        ? Image.network(
                            // Add your base URL if needed: '${Appurl.baseUrl}${fund.amcLogo}'
                            fund.amcLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.account_balance,
                              size: 20,
                              color: Colors.grey,
                            ),
                          )
                        : Image.asset(UImages.sbi, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),

                /// Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund.fundName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (fund.hasPendingRedemption) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.hourglass_top_rounded,
                                size: 12,
                                color: Colors.orange.shade800,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  fund.redemptionMessage.isNotEmpty
                                      ? fund.redemptionMessage
                                      : 'Redemption In Progress',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade800,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (subtitle) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Text(
                              '1D Change:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isVisible
                                  ? '${is1DProfit ? "+" : ""}₹${fund.oneDayChange.abs().toStringAsFixed(2)}'
                                  : '₹ •••',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (isVisible) ...[
                              Icon(
                                is1DProfit
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 18,
                                color: is1DProfit ? Colors.green : Colors.red,
                              ),
                              Text(
                                '${fund.oneDayChangePercent.abs().toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: is1DProfit ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                /// Menu
                // if (iconButton)
                //   PopupMenuButton<PortfolioMenuAction>(
                //     color: Ucolors.light,
                //     icon: const Icon(Icons.more_vert, color: Colors.grey),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     offset: const Offset(0, 40),
                //     onSelected: (value) {
                //       // ... keep your existing switch statement ...
                //     },
                //     itemBuilder: (context) => [
                //       // ... keep your existing menu items ...
                //     ],
                //   ),
                iconButton
                    ? PopupMenuButton<PortfolioMenuAction>(
                        color: Ucolors.light,
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        // elevation: 6,
                        offset: const Offset(0, 40),
                        onSelected: (value) {
                          switch (value) {
                            case PortfolioMenuAction.topUp:
                              break;

                            case PortfolioMenuAction.modify:
                              break;
                            case PortfolioMenuAction.pause:
                              break;
                            case PortfolioMenuAction.cancel:
                              createLog('tap for cancel sip / lumpsum ');
                              break;
                            case PortfolioMenuAction.redemption:
                              createLog('tap for cancel redemption / lumpsum ');

                              if (!fund.isUnitAllotted ||
                                  fund.allotmentStatus ==
                                      'allotment_in_progress') {
                                CustomSnackbar.info(
                                  title: 'Allotment In Progress',
                                  message: fund.allotmentMessage.isNotEmpty
                                      ? fund.allotmentMessage
                                      : 'Unit allotment is currently in progress by the AMC (1-2 business days).',
                                );
                                break;
                              }

                              if (fund.hasPendingRedemption) {
                                _showPendingRedemptionDetailsModal(
                                  context,
                                  fund,
                                );
                                break;
                              }

                              Get.to(
                                () => RedeemPage(),
                                arguments: RedeemArgs(
                                  mfuOrderFundId: fund.mfuOrderFundId,
                                  amcLogo: fund.amcLogo,
                                  schemeCode: fund.schemeCode,
                                  schemeName: fund.fundName,
                                  folioNumber: fund.folioNo,
                                  folioType: 'Individual',
                                  totalUnits: fund.totalUnits,
                                  totalValue: fund.currentValue,
                                  lockedUnits: 0.0,
                                  lockedValue: 0,
                                  freeUnits: fund.totalUnits,
                                  freeValue: fund.currentValue,
                                  investedAmt: fund.investedAmount,
                                  hasPendingRedemption:
                                      fund.hasPendingRedemption,
                                  redemptionMessage: fund.redemptionMessage,
                                  orderRefNo:
                                      fund.redemptionDetails?.orderRefNo ?? '',
                                ),
                              );

                              break;

                            case PortfolioMenuAction.switchgoal:
                              createLog('Tap for move to goal');
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          // buildMenuItem(
                          //   icon: Iconsax.card_send,
                          //   text: 'Top Up',
                          //   value: PortfolioMenuAction.topUp,
                          // ),
                          // buildMenuItem(
                          //   icon: Iconsax.edit_2,
                          //   text: 'Modify',
                          //   value: PortfolioMenuAction.modify,
                          // ),
                          // buildMenuItem(
                          //   icon: Iconsax.pause,
                          //   text: 'Pause',
                          //   value: PortfolioMenuAction.pause,
                          // ),
                          buildMenuItem(
                            icon: Iconsax.trash,
                            text: 'Cancel',
                            value: PortfolioMenuAction.cancel,
                          ),
                          buildMenuItem(
                            icon: Iconsax.receipt,
                            text: 'Redemption',
                            value: PortfolioMenuAction.redemption,
                          ),
                          // buildMenuItem(
                          //   icon: Icons.arrow_outward,
                          //   text: 'Add to Goal',
                          //   value: PortfolioMenuAction.switchgoal,
                          // ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),

            const SizedBox(height: 5),

            /// 🔹 Bottom Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatItem1(
                  title: 'Invested',
                  amount: isVisible
                      ? '₹${fund.investedAmount.toStringAsFixed(2)}'
                      : '₹ ••••••',
                  percentage: '', // Leave blank for Invested
                ),
                StatItem1(
                  title: 'Current Value',
                  amount: isVisible
                      ? '₹${fund.currentValue.toStringAsFixed(2)}'
                      : '₹ ••••••',
                  percentage: '',
                ),
                StatItem1(
                  title: 'Gain/Loss',
                  amount: isVisible
                      ? '${isOverallProfit ? "+" : ""}₹${fund.gainLoss.abs().toStringAsFixed(2)}'
                      : '₹ ••••••',
                  amountColor: isVisible
                      ? (isOverallProfit ? Colors.green : Colors.red)
                      : Colors.black,
                  percentage: isVisible
                      ? '${fund.gainLossPercent.abs().toStringAsFixed(2)}%'
                      : '',
                  percentageColor: isOverallProfit ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem1 extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final Color percentageColor;
  final Color amountColor;

  const StatItem1({
    required this.title,
    required this.amount,
    required this.percentage,
    this.percentageColor = Colors.green,
    this.amountColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: amount,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: amountColor,
                ),
              ),
              const TextSpan(text: '  '),
              TextSpan(
                text: percentage,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: percentageColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final double amount; // Changed from String to double for animation
  final bool? isProfit;
  final bool
  isVisible; // Now handles visibility internally for smoother animations

  const SummaryItem({
    super.key,
    required this.title,
    required this.amount,
    this.isProfit,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSpecial = isProfit != null;
    final valueColor = isSpecial
        ? (isProfit! ? Colors.greenAccent : Colors.redAccent)
        : Colors.white;

    final icon = isSpecial
        ? (isProfit!
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Ucolors.skyblue,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        // 1. AnimatedContainer smoothly transitions the background pill
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: isSpecial
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : EdgeInsets.zero,
          // decoration: BoxDecoration(
          //   color: isSpecial && isVisible
          //       ? valueColor.withValues(alpha:0.15)
          //       : Colors.transparent,
          //   borderRadius: BorderRadius.circular(6),
          // ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 2. AnimatedSwitcher for smooth hide/show transitions
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: isVisible
                    ? Row(
                        key: const ValueKey('visible'),
                        children: [
                          if (icon != null) ...[
                            Icon(icon, color: valueColor, size: 14),
                            const SizedBox(width: 4),
                          ],
                          // 3. TweenAnimationBuilder creates the "Number Counter" effect
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: amount.abs()),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutQuart,
                            builder: (context, value, child) {
                              return Text(
                                '₹${value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: valueColor,
                                  fontSize: 14,
                                  fontWeight: isSpecial
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Text(
                        '₹ ••••••',
                        key: const ValueKey('hidden'),
                        style: TextStyle(
                          color: isSpecial
                              ? valueColor.withValues(alpha: 0.5)
                              : Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _showPendingRedemptionDetailsModal(BuildContext context, dynamic fund) {
  final details = fund.redemptionDetails;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.hourglass_top_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Redemption In Progress',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1117),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              fund.redemptionMessage.isNotEmpty
                  ? fund.redemptionMessage
                  : 'A redemption request is currently being processed by the AMC.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildModalRow('Fund', fund.fundName),
                  const Divider(height: 16),
                  _buildModalRow('Folio', fund.folioNo),
                  if (details != null) ...[
                    const Divider(height: 16),
                    _buildModalRow('Order Reference', details.orderRefNo),
                    if (details.gorn.isNotEmpty) ...[
                      const Divider(height: 16),
                      _buildModalRow('MFU GORN', details.gorn),
                    ],
                    if (details.amount > 0) ...[
                      const Divider(height: 16),
                      _buildModalRow('Amount', '₹${details.amount}'),
                    ],
                    if (details.status.isNotEmpty) ...[
                      const Divider(height: 16),
                      _buildModalRow('Status', details.status),
                    ],
                    if (details.estimatedPayoutDays.isNotEmpty) ...[
                      const Divider(height: 16),
                      _buildModalRow(
                        'Payout Window',
                        details.estimatedPayoutDays,
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Got it',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildModalRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D1117),
          ),
        ),
      ),
    ],
  );
}
