import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/common/widget/text/section_heading.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/mfu/presentation/pages/redeem_page.dart';
import 'package:my_sip/features/personalization/presentation/pages/profile.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/comparison_chart.dart';

enum PortfolioMenuAction { topUp, modify, pause, cancel, redemption }

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
class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(PortfolioTabController());

    // Detect Desktop
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Ucolors.light,
      body: isDesktop
          ? _WebDashboardLayout(cartController: cartController)
          : _MobileDashboardLayout(cartController: cartController),
    );
  }
}

// ==========================================
// 💻 WEB DASHBOARD LAYOUT (New)
// ==========================================
class _WebDashboardLayout extends StatelessWidget {
  final CartController cartController;
  const _WebDashboardLayout({required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Web Header
        // _buildWebHeader(),

        // 2. Scrollable Dashboard
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- TITLE ---
                    const Text(
                      "Portfolio Overview",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(24),

                    // --- TOP STAT CARDS (Full Width Row) ---
                    Row(
                      children: [
                        Expanded(
                          child: _WebStatCard(
                            title: "Current Value",
                            value: "₹32,580",
                            trend: "+15.06%",
                            icon: Iconsax.wallet_money,
                            color: Ucolors.primary,
                            isPrimary: true, // Highlights this card
                          ),
                        ),
                        const Gap(24),
                        Expanded(
                          child: _WebStatCard(
                            title: "Total Investment",
                            value: "₹30,000",
                            icon: Iconsax.money_send,
                            color: Colors.orange,
                          ),
                        ),
                        const Gap(24),
                        Expanded(
                          child: _WebStatCard(
                            title: "Profit / Loss",
                            value: "+ ₹2,580",
                            trend: "Healthy",
                            icon: Iconsax.chart_2,
                            color: Colors.green,
                            isProfit: true,
                          ),
                        ),
                      ],
                    ),

                    const Gap(30),

                    // --- MAIN CONTENT SPLIT ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT COLUMN (Chart + Portfolio List) - 65% width
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Chart Section
                              Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                // Reuse your existing chart widget
                                child: const FundComparisonChartWidget(),
                              ),
                              const Gap(30),

                              // Portfolio List Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Your Assets",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("View All"),
                                  ),
                                ],
                              ),
                              const Gap(10),

                              // Portfolio List (Reusing Mobile Card in Grid/List)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                separatorBuilder: (_, __) => const Gap(10),
                                itemBuilder: (ctx, index) => _WebPortfolioRow(),
                              ),
                            ],
                          ),
                        ),

                        const Gap(30),

                        // RIGHT COLUMN (Transactions + Actions) - 35% width
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              // Quick Actions
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Quick Actions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Gap(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _WebActionButton(
                                          label: "Top Up",
                                          icon: Iconsax.add_circle,
                                          color: Ucolors.primary,
                                        ),
                                        _WebActionButton(
                                          label: "Withdraw",
                                          icon: Iconsax.minus_cirlce,
                                          color: Colors.orange,
                                        ),
                                        _WebActionButton(
                                          label: "SIP",
                                          icon: Iconsax.timer_1,
                                          color: Colors.purple,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(24),

                              // Recent Transactions
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// HEADER
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Upcoming SIPs",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {},
                                          child: const Text(
                                            "View All",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 18),

                                    /// SIP LIST
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 3,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 18),
                                      itemBuilder: (context, index) {
                                        final data = [
                                          {
                                            "date": "10",
                                            "month": "Dec",
                                            "fund": "Kotak Bluechip Fund",
                                            "type": "Monthly",
                                            "amount": "₹5000",
                                          },
                                          {
                                            "date": "15",
                                            "month": "Dec",
                                            "fund": "ICICI Prudential Tech",
                                            "type": "Monthly",
                                            "amount": "₹3000",
                                          },
                                          {
                                            "date": "20",
                                            "month": "Dec",
                                            "fund": "SBI Small Cap Fund",
                                            "type": "Monthly",
                                            "amount": "₹2000",
                                          },
                                        ];

                                        final item = data[index];

                                        return Row(
                                          children: [
                                            /// DATE BOX
                                            Container(
                                              width: 42,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                  0.08,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    item["date"]!,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.blue,
                                                    ),
                                                  ),

                                                  Text(
                                                    item["month"]!,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.blue.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 14),

                                            /// FUND INFO
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item["fund"]!,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 4),

                                                  Text(
                                                    item["type"]!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// AMOUNT
                                            Text(
                                              item["amount"]!,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   padding: const EdgeInsets.all(20),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(20),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.black.withOpacity(0.05),
                              //         blurRadius: 10,
                              //       ),
                              //     ],
                              //   ),
                              //   child: Column(
                              //     crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //     children: [
                              //       const Text(
                              //         "Recent Transactions",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //       const Gap(15),
                              //       ListView.separated(
                              //         shrinkWrap: true,
                              //         physics:
                              //             const NeverScrollableScrollPhysics(),
                              //         itemCount: 5,
                              //         separatorBuilder: (_, __) =>
                              //             const Divider(height: 20),
                              //         itemBuilder: (ctx, index) =>
                              //             const TransactionCard(
                              //               isWebCompact: true,
                              //             ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWebHeader() {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "My SIP Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Ucolors.primary,
                ),
              ),
              const Spacer(),
              // Icons
              IconButton(
                onPressed: () {},
                icon: const Icon(Iconsax.notification),
              ),
              const Gap(10),
              Obx(
                () => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.shopping_cart),
                      onPressed: () => Get.toNamed(AppRoutes.cart),
                    ),
                    if (cartController.itemsCount > 0)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Ucolors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartController.itemsCount.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(10),
              const CircleAvatar(backgroundImage: AssetImage(UImages.avatar)),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background color
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Agar screen width 900 se kam hai toh column (stacked) dikhao, nahi toh row
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
            icon:
                Icons.track_changes, // App me Iconsax.target use kar sakte hain
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
                padding: const EdgeInsets.only(
                  right: 12,
                ), // Scrollbar se gap ke liye
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
          color: widget.color.withOpacity(0.04),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: widget.color.withOpacity(0.08)),

          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(isHovered ? 0.10 : 0.04),
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
                                fontWeight: FontWeight.w700,
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
        colors: [color.withOpacity(0.15), color.withOpacity(0.03)],
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
    final highlightPaint = Paint()..color = color.withOpacity(0.08);
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
            color: color.withOpacity(0.1),
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

// ==========================================
// 📱 MOBILE DASHBOARD LAYOUT (Preserved)
// ==========================================
class _MobileDashboardLayout extends StatelessWidget {
  final CartController cartController;
  const _MobileDashboardLayout({required this.cartController});

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
            // onProfiletap: () => Get.to(() => ProfileScreen()),
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
              // Obx(
              //       () => Stack(
              //     children: [
              //       CompactIcon(
              //         icon: Iconsax.shopping_cart,
              //         onPressed: () => Get.toNamed(AppRoutes.cart),
              //         iconColor: Ucolors.dark,
              //       ),
              //       if (cartController.itemsCount > 0)
              //         Positioned(
              //           right: 0,
              //           top: -5,
              //           child: Container(
              //             padding: const EdgeInsets.all(5),
              //             decoration: const BoxDecoration(
              //               color: Ucolors.red,
              //               shape: BoxShape.circle,
              //             ),
              //             child: Text(
              //               cartController.itemsCount.toString(),
              //               style: UTextStyles.buttonText.copyWith(
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //     ],
              //   ),
              // ),
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
                  child: Container(
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
                            const Text(
                              '₹32,580',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CompactIcon(
                              icon: Icons.remove_red_eye,
                              onPressed: () {},
                              iconColor: Ucolors.light,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            SummaryItem(title: 'Invested', value: '₹30,000'),
                            SummaryItem(
                              title: 'Total Returns',
                              value: '₹2,580',
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
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
                final controller = Get.find<PortfolioTabController>();

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
          final controller = Get.find<PortfolioTabController>();

          if (controller.selectedIndex.value == 0) {
            /// 🟦 MY PORTFOLIO TAB
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
                ...List.generate(6, (index) => const PortfolioCard()),
              ]),
            );
          } else {
            /// 🟩 TRANSACTIONS TAB
            return SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: SectionHeading(
                    sectionTitle: 'Transactions',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    textcolor: const Color(0xff787878),
                  ),
                ),
                ...List.generate(6, (index) => const TransactionCard()),
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
                  color: Colors.black.withOpacity(0.08),
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

// ... Keep existing PortfolioCard, PopMenuItem, Painters unchanged ...
// (Retain all original classes below this point from your dashboard.dart file)
// Make sure to include PortfolioCard, StatItem1, SummaryItem, BottomDashedLinePainter, BottomWaveClipper
// exactly as they were in your uploaded file.
class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    this.subtitle = true,
    this.iconButton = true,
  });

  final bool subtitle;
  final bool iconButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Get.to(() => FundDetailsScreen()),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
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
                // / Fund Icon
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: ClipOval(
                    child: Image.asset(UImages.sbi, fit: BoxFit.cover),
                  ),
                ),

                // CircleAvatar(backgroundImage: AssetImage(UImages.sbi)),
                const SizedBox(width: 12),

                /// Title + Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      if (subtitle) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text(
                              '1D Change:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '-₹24.2',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 18,
                              color: Colors.red,
                            ),
                            Text(
                              '0.44%',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                /// Menu
                // const Icon(Icons.more_vert, color: Colors.grey),
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
                              log('top up');
                              break;

                            case PortfolioMenuAction.modify:
                              break;
                            case PortfolioMenuAction.pause:
                              break;
                            case PortfolioMenuAction.cancel:
                              break;
                            case PortfolioMenuAction.redemption:
                              Get.to(
                                () => RedeemPage(),
                                arguments: RedeemArgs(
                                  schemeCode: '012',
                                  schemeName:
                                      'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                                  folioNumber: '28975246',
                                  folioType: 'Individual',
                                  totalUnits: 0.049,
                                  totalValue: 104304,
                                  lockedUnits: 0.0,
                                  lockedValue: 0,
                                  freeUnits: 0.049,
                                  freeValue: 104304,
                                  investedAmt: 78500,
                                ),
                              );

                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          buildMenuItem(
                            icon: Iconsax.card_send,
                            text: 'Top Up',
                            value: PortfolioMenuAction.topUp,
                          ),
                          buildMenuItem(
                            icon: Iconsax.edit_2,
                            text: 'Modify',
                            value: PortfolioMenuAction.modify,
                          ),
                          buildMenuItem(
                            icon: Iconsax.pause,
                            text: 'Pause',
                            value: PortfolioMenuAction.pause,
                          ),
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
                        ],
                      )
                    : SizedBox(),
              ],
            ),

            const SizedBox(height: 4),

            /// 🔹 Bottom Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatItem1(title: 'Invested', amount: '₹5K', percentage: ''),
                StatItem1(
                  percentage: '',
                  title: 'Current Value',
                  amount: '₹5.43K',
                ),

                StatItem1(
                  percentage: '8.55 %',
                  title: 'Gain/Loss',

                  amount: '₹427.35',
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

/// 🔹 Summary Item Widget
class SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          //  style: const TextStyle(color: Colors.white70)
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Ucolors.skyblue,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
