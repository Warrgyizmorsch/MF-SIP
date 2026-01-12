import 'package:flutter/material.dart';
import 'dart:math';

// --- MOCK DATA MODELS ---

class Fund {
  final String id;
  final String name;
  final String shortName;
  final Color color;
  final double nav;
  final double rating;
  final String category;

  // 1. Performance (Mock data for chart points 0.0 to 1.0)
  final List<double> performancePoints;

  // 2. Overview
  final String aum;
  final String expenseRatio;
  final String exitLoad;
  final String age;

  // 3. Trailing Returns (%)
  final double return1Y;
  final double return3Y;
  final double return5Y;
  final double returnAll;

  // 4. SIP Returns (Mock absolute amounts for 10k/month)
  final String sipReturn1Y;
  final String sipReturn3Y;
  final String sipReturn5Y;

  // 5. Risk Measures
  final double stdDev;
  final double beta;
  final double sharpeRatio;
  final double alpha;

  // 6. Managers
  final String manager;
  final String education;

  // 7. Market Cap Allocation (%)
  final double largeCap;
  final double midCap;
  final double smallCap;

  // 8. Top Sectors (%)
  final Map<String, double> sectors;

  const Fund({
    required this.id,
    required this.name,
    required this.shortName,
    required this.color,
    required this.nav,
    required this.rating,
    required this.category,
    required this.performancePoints,
    required this.aum,
    required this.expenseRatio,
    required this.exitLoad,
    required this.age,
    required this.return1Y,
    required this.return3Y,
    required this.return5Y,
    required this.returnAll,
    required this.sipReturn1Y,
    required this.sipReturn3Y,
    required this.sipReturn5Y,
    required this.stdDev,
    required this.beta,
    required this.sharpeRatio,
    required this.alpha,
    required this.manager,
    required this.education,
    required this.largeCap,
    required this.midCap,
    required this.smallCap,
    required this.sectors,
  });
}

// --- DUMMY DATA ---

final List<Fund> mockFunds = [
  Fund(
    id: '1',
    name: 'Aditya Birla Sun Life Frontline Equity',
    shortName: 'ABSL Frontline',
    color: Colors.orange,
    nav: 456.23,
    rating: 4.5,
    category: 'Equity - Large Cap',
    performancePoints: [0.1, 0.3, 0.25, 0.4, 0.55, 0.5, 0.7, 0.85],
    aum: '₹22,450 Cr',
    expenseRatio: '1.05%',
    exitLoad: '1% < 1 Yr',
    age: '21 Years',
    return1Y: 15.4,
    return3Y: 22.1,
    return5Y: 18.5,
    returnAll: 14.2,
    sipReturn1Y: '₹1.32 L',
    sipReturn3Y: '₹4.85 L',
    sipReturn5Y: '₹9.20 L',
    stdDev: 14.2,
    beta: 0.92,
    sharpeRatio: 0.85,
    alpha: 1.2,
    manager: 'Mahesh Patil',
    education: 'B.E (Elect), MMS (Finance)',
    largeCap: 85.0,
    midCap: 12.0,
    smallCap: 3.0,
    sectors: {
      'Financials': 32.5,
      'Technology': 14.2,
      'Energy': 11.0,
      'Auto': 8.5,
    },
  ),
  Fund(
    id: '2',
    name: 'HDFC Mid-Cap Opportunities Fund',
    shortName: 'HDFC Mid-Cap',
    color: Colors.blue,
    nav: 124.50,
    rating: 5.0,
    category: 'Equity - Mid Cap',
    performancePoints: [0.1, 0.2, 0.4, 0.35, 0.6, 0.75, 0.9, 0.95],
    aum: '₹45,100 Cr',
    expenseRatio: '0.98%',
    exitLoad: '1% < 1 Yr',
    age: '16 Years',
    return1Y: 28.5,
    return3Y: 35.2,
    return5Y: 24.1,
    returnAll: 21.0,
    sipReturn1Y: '₹1.56 L',
    sipReturn3Y: '₹6.20 L',
    sipReturn5Y: '₹12.4 L',
    stdDev: 18.5,
    beta: 1.15,
    sharpeRatio: 1.10,
    alpha: 3.5,
    manager: 'Chirag Setalvad',
    education: 'B.Sc, MBA (UNC)',
    largeCap: 15.0,
    midCap: 75.0,
    smallCap: 10.0,
    sectors: {
      'Financials': 22.0,
      'Ind. Mfg': 18.5,
      'Cons. Disc': 15.0,
      'Health': 12.0,
    },
  ),
  Fund(
    id: '3',
    name: 'SBI Small Cap Fund',
    shortName: 'SBI Small Cap',
    color: Colors.green,
    nav: 189.30,
    rating: 4.0,
    category: 'Equity - Small Cap',
    performancePoints: [0.1, 0.2, 0.3, 0.6, 0.5, 0.8, 0.75, 0.9],
    aum: '₹18,200 Cr',
    expenseRatio: '0.85%',
    exitLoad: '1% < 1 Yr',
    age: '14 Years',
    return1Y: 12.1,
    return3Y: 28.4,
    return5Y: 26.8,
    returnAll: 25.5,
    sipReturn1Y: '₹1.28 L',
    sipReturn3Y: '₹5.10 L',
    sipReturn5Y: '₹10.5 L',
    stdDev: 21.0,
    beta: 0.88,
    sharpeRatio: 0.95,
    alpha: 2.1,
    manager: 'R. Srinivasan',
    education: 'M.Com, MFM',
    largeCap: 5.0,
    midCap: 15.0,
    smallCap: 80.0,
    sectors: {
      'Cons. Goods': 25.0,
      'Services': 20.0,
      'Chemicals': 15.0,
      'Engin.': 10.0,
    },
  ),
];

// --- MAIN SCREEN ---

class FundComparisonScreen extends StatefulWidget {
  const FundComparisonScreen({super.key});

  @override
  State<FundComparisonScreen> createState() => _FundComparisonScreenState();
}

class _FundComparisonScreenState extends State<FundComparisonScreen> {
  // Slots for the two funds being compared
  Fund? slot1 = mockFunds[0];
  Fund? slot2 = mockFunds[1];

  // Helper to open a modal sheet to select a fund
  void _openSelectionModal(int slotNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (ctx, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Select Fund for Slot $slotNumber",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: mockFunds.length,
                    itemBuilder: (ctx, index) {
                      final f = mockFunds[index];
                      // Don't show the fund already in the OTHER slot
                      if (slotNumber == 1 && slot2?.id == f.id)
                        return const SizedBox.shrink();
                      if (slotNumber == 2 && slot1?.id == f.id)
                        return const SizedBox.shrink();

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: f.color.withOpacity(0.2),
                          child: Text(
                            f.shortName[0],
                            style: TextStyle(color: f.color),
                          ),
                        ),
                        title: Text(f.name),
                        subtitle: Text(f.category),
                        trailing: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                        ),
                        onTap: () {
                          setState(() {
                            if (slotNumber == 1) {
                              slot1 = f;
                            } else {
                              slot2 = f;
                            }
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Compare Funds",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {}, // Handle back
        ),
      ),
      body: Column(
        children: [
          // --- STICKY HEADER ---
          // This row stays visible while scrolling details
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,

              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _buildHeaderCard(slot1, 1)),
                const SizedBox(width: 12),
                Expanded(child: _buildHeaderCard(slot2, 2)),
              ],
            ),
          ),

          // --- SCROLLABLE DETAILS ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  if (slot1 != null && slot2 != null) ...[
                    // 1. Performance Chart
                    _buildSectionTitle("Performance Chart", Icons.show_chart),
                    _buildChartSection(slot1!, slot2!),

                    // 2. Overview
                    _buildSectionTitle("Overview", Icons.info_outline),
                    _buildCompareRow("AUM", slot1!.aum, slot2!.aum),
                    _buildCompareRow(
                      "Expense Ratio",
                      slot1!.expenseRatio,
                      slot2!.expenseRatio,
                      highlightLower: true,
                    ),
                    _buildCompareRow(
                      "Exit Load",
                      slot1!.exitLoad,
                      slot2!.exitLoad,
                    ),
                    _buildCompareRow("Fund Age", slot1!.age, slot2!.age),

                    // 3. Trailing Returns
                    _buildSectionTitle(
                      "Trailing Returns (%)",
                      Icons.trending_up,
                    ),
                    _buildCompareRow(
                      "1 Year",
                      "${slot1!.return1Y}%",
                      "${slot2!.return1Y}%",
                      highlightHigher: true,
                    ),
                    _buildCompareRow(
                      "3 Year",
                      "${slot1!.return3Y}%",
                      "${slot2!.return3Y}%",
                      highlightHigher: true,
                    ),
                    _buildCompareRow(
                      "5 Year",
                      "${slot1!.return5Y}%",
                      "${slot2!.return5Y}%",
                      highlightHigher: true,
                    ),
                    _buildCompareRow(
                      "Since Inception",
                      "${slot1!.returnAll}%",
                      "${slot2!.returnAll}%",
                      highlightHigher: true,
                    ),

                    // 4. SIP Returns
                    _buildSectionTitle(
                      "SIP Returns (10k/mo)",
                      Icons.savings_outlined,
                    ),
                    _buildCompareRow(
                      "1 Year Value",
                      slot1!.sipReturn1Y,
                      slot2!.sipReturn1Y,
                    ),
                    _buildCompareRow(
                      "3 Year Value",
                      slot1!.sipReturn3Y,
                      slot2!.sipReturn3Y,
                    ),
                    _buildCompareRow(
                      "5 Year Value",
                      slot1!.sipReturn5Y,
                      slot2!.sipReturn5Y,
                    ),

                    // 5. Risk Measures
                    _buildSectionTitle("Risk Measures", Icons.shield_outlined),
                    _buildCompareRow(
                      "Standard Deviation",
                      slot1!.stdDev.toString(),
                      slot2!.stdDev.toString(),
                      highlightLower: true,
                    ),
                    _buildCompareRow(
                      "Beta",
                      slot1!.beta.toString(),
                      slot2!.beta.toString(),
                    ),
                    _buildCompareRow(
                      "Sharpe Ratio",
                      slot1!.sharpeRatio.toString(),
                      slot2!.sharpeRatio.toString(),
                      highlightHigher: true,
                    ),
                    _buildCompareRow(
                      "Alpha",
                      slot1!.alpha.toString(),
                      slot2!.alpha.toString(),
                      highlightHigher: true,
                    ),

                    // 6. Managers
                    _buildSectionTitle("Fund Managers", Icons.person_outline),
                    _buildMultiLineRow(
                      "Manager",
                      slot1!.manager,
                      slot2!.manager,
                    ),
                    _buildMultiLineRow(
                      "Education",
                      slot1!.education,
                      slot2!.education,
                    ),

                    // 7. Market Cap
                    _buildSectionTitle("Market Cap", Icons.pie_chart_outline),
                    _buildMarketCapRow(
                      "Large Cap",
                      slot1!.largeCap,
                      slot2!.largeCap,
                    ),
                    _buildMarketCapRow("Mid Cap", slot1!.midCap, slot2!.midCap),
                    _buildMarketCapRow(
                      "Small Cap",
                      slot1!.smallCap,
                      slot2!.smallCap,
                    ),

                    // 8. Sectors
                    _buildSectionTitle("Top Sectors (%)", Icons.business),
                    _buildSectorComparison(slot1!, slot2!),

                    const SizedBox(height: 20),
                    _buildCtaButton(),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: Text("Select two funds to begin comparison"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeaderCard(Fund? fund, int slotNum) {
    if (fund == null) {
      return GestureDetector(
        onTap: () => _openSelectionModal(slotNum),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.grey),
              SizedBox(height: 4),
              Text(
                "Add Fund",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          height: 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 4),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: fund.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${fund.rating} ★",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: fund.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fund.shortName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    fund.category,
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NAV",
                        style: TextStyle(color: Colors.grey[400], fontSize: 9),
                      ),
                      Text(
                        "₹${fund.nav}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "1Y",
                        style: TextStyle(color: Colors.grey[400], fontSize: 9),
                      ),
                      Text(
                        "+${fund.return1Y}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() {
              if (slotNum == 1)
                slot1 = null;
              else
                slot2 = null;
            }),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(Icons.close, size: 14, color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // A custom painter widget to simulate the Performance Chart
  Widget _buildChartSection(Fund f1, Fund f2) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: CustomPaint(
        painter: PerformanceChartPainter(
          points1: f1.performancePoints,
          points2: f2.performancePoints,
          color1: f1.color,
          color2: f2.color,
        ),
      ),
    );
  }

  Widget _buildCompareRow(
    String label,
    String val1,
    String val2, {
    bool highlightHigher = false,
    bool highlightLower = false,
  }) {
    // Simple logic to parse doubles for highlighting
    bool v1Wins = false;
    bool v2Wins = false;

    if (highlightHigher || highlightLower) {
      try {
        double d1 = double.parse(val1.replaceAll(RegExp(r'[^0-9.]'), ''));
        double d2 = double.parse(val2.replaceAll(RegExp(r'[^0-9.]'), ''));

        if (highlightHigher) {
          v1Wins = d1 > d2;
          v2Wins = d2 > d1;
        } else if (highlightLower) {
          v1Wins = d1 < d2;
          v2Wins = d2 < d1;
        }
      } catch (e) {
        // ignore parsing errors
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(flex: 2, child: Center(child: _buildValueBox(val1, v1Wins))),
          Expanded(flex: 2, child: Center(child: _buildValueBox(val2, v2Wins))),
        ],
      ),
    );
  }

  Widget _buildValueBox(String text, bool isWinner) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isWinner
          ? BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
          color: isWinner ? Colors.green[800] : Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildMultiLineRow(String label, String val1, String val2) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              val1,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              val2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketCapRow(String label, double val1, double val2) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${val1.toStringAsFixed(1)}% vs ${val2.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: val1 / 100,
                  backgroundColor: Colors.grey[200],
                  color: slot1?.color,
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LinearProgressIndicator(
                  value: val2 / 100,
                  backgroundColor: Colors.grey[200],
                  color: slot2?.color,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectorComparison(Fund f1, Fund f2) {
    // Get unique sectors from both to list them
    final allSectors = {...f1.sectors.keys, ...f2.sectors.keys}.toList();

    return Column(
      children: allSectors.map((sector) {
        final v1 = f1.sectors[sector] ?? 0.0;
        final v2 = f2.sectors[sector] ?? 0.0;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sector,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "${v1}%",
                          style: TextStyle(fontSize: 10, color: f1.color),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: v1 / 50,
                            color: f1.color,
                            backgroundColor: Colors.grey[100],
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: v2 / 50,
                            color: f2.color,
                            backgroundColor: Colors.grey[100],
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${v2}%",
                          style: TextStyle(fontSize: 10, color: f2.color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCtaButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        children: [
          const Text(
            "Need help deciding?",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          const Text(
            "Talk to our certified distributors.",
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Get Advice",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTERS ---

class PerformanceChartPainter extends CustomPainter {
  final List<double> points1;
  final List<double> points2;
  final Color color1;
  final Color color2;

  PerformanceChartPainter({
    required this.points1,
    required this.points2,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _drawPath(canvas, size, points1, paint..color = color1);
    _drawPath(canvas, size, points2, paint..color = color2);

    // Draw baseline
    final linePaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      linePaint,
    );
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), linePaint);
  }

  void _drawPath(Canvas canvas, Size size, List<double> points, Paint paint) {
    if (points.isEmpty) return;

    final path = Path();
    final stepX = size.width / (points.length - 1);

    path.moveTo(0, size.height - (points[0] * size.height));

    for (int i = 1; i < points.length; i++) {
      path.lineTo(i * stepX, size.height - (points[i] * size.height));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
