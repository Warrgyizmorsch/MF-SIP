import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/core/utils/calculator/buildreport/buildreport.dart';
import 'package:my_sip/core/utils/calculator/model/lumpsum.dart/lumpsummodel.dart';
import 'package:my_sip/core/utils/calculator/model/model.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/table/table_header.dart';
import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/return.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/InvestValue.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/sipslidertile.dart';
import 'package:my_sip/features/home/presentation/widgets/product_tool/widget/piechart_with_value.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive Framework

import '../../../../../core/utils/helper/helpers.dart';
import '../../../../fund_details/presentation/pages/fund_deatails.dart';

class SipCalculatorPage extends StatefulWidget {
  const SipCalculatorPage({super.key});

  @override
  State<SipCalculatorPage> createState() => _SipCalculatorPageState();
}

class _SipCalculatorPageState extends State<SipCalculatorPage> with SingleTickerProviderStateMixin{
  final ScrollController horizontalCtrl = ScrollController();
  late TabController _tabController;
  SipResult get sipResult => calculateSip(
    monthlyInvestment: monthlyInvestment,
    annualRate: returnRate,
    years: years,
  );
  SipResult get lumpsumResult => calculateLumpsum(
    investment: totalInvestment,
    annualRate: returnRatelumpsum,
    years: yearslumpsum,
  );

  // SIP State
  double monthlyInvestment = 5000;
  double returnRate = 12;
  double years = 5;

  // Lumpsum State
  double totalInvestment = 100000;
  double returnRatelumpsum = 12;
  double yearslumpsum = 5;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 🔹 Listen for tab switches
    _tabController.addListener(() {
      // indexIsChanging is true when the user taps, preventing double-firing
      if (_tabController.indexIsChanging) {
        _resetData();
      }
    });
  }

  void _resetData() {
    setState(() {
      // Reset SIP values
      monthlyInvestment = 5000;
      returnRate = 12;
      years = 5;

      // Reset Lumpsum values
      totalInvestment = 100000;
      returnRatelumpsum = 12;
      yearslumpsum = 5;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // SIP Report Data
    final returns = buildSipReport(
      monthlyInvestment: monthlyInvestment,
      annualRate: returnRate,
      years: years.toInt(),
    );

    return Scaffold(
      backgroundColor: isDesktop
          ? const Color(0xFFF5F7FA)
          : Colors.white.withOpacity(0.96),
      appBar: CustomAppBarNormal(title: 'SIP Calculator', backIcon: true),
      body: SingleChildScrollView(
        padding: isDesktop
            ? const EdgeInsets.symmetric(vertical: 30, horizontal: 24)
            :const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          children: [
            // --- 1. Tab Bar (Centered on Web) ---
            Center(
              child: Container(
                width: isDesktop ? 400 : double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: isDesktop
                      ? Border.all(color: Colors.grey.shade300)
                      : null,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey,
                  dividerColor: Colors.transparent,
                  labelColor: Ucolors.primary,
                  indicatorColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(vertical: 8),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Ucolors.primary.withOpacity(0.1),
                  ),
                  tabs: const [
                    Text(
                      'SIP',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lumpsum',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const Gap(24),

            // --- 2. Content Area ---
            SizedBox(
              height:
                  800, // Fixed height for TabBarView to prevent scroll issues
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Handle scrolling in parent
                children: [
                  // SIP TAB
                  _buildSipTab(isDesktop, returns),

                  // LUMPSUM TAB
                  _buildLumpsumTab(isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 🔹 SIP TAB LAYOUT
  // =========================================================
  Widget _buildSipTab(bool isDesktop, List<ReturnRow> returns) {
    // 1. Input Section
    Widget inputs = Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 0),
      decoration: isDesktop ? _webCardDecoration() : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            const Text(
              "Input Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          if (isDesktop) const Gap(20),
          SipSliderTile2(
            title: 'Monthly Investment',
            value: monthlyInvestment,
            min: 100,
            max: 100000,
            // prefix: '₹',
            suffix: '₹',
            onChanged: (value) => setState(() => monthlyInvestment = value),
          ),
          SipSliderTile2(
            title: 'Expected return rate (p.a)',
            value: returnRate,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (val) => setState(() => returnRate = val),
          ),
          SipSliderTile2(
            title: 'Total period',
            value: years,
            min: 1,
            max: 30,
            suffix: 'Years',
            onChanged: (val) => setState(() => years = val),
          ),
        ],
      ),
    );

    // 2. Result Section (Visual + Report)
    Widget results = Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Ucolors.light,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Ucolors.borderside),
        boxShadow: isDesktop
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
            : null,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Inner Tabs
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
                labelColor: Ucolors.primary,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                tabs: const [
                  Tab(text: 'Visual Rep.'),
                  Tab(text: 'Report'),
                ],
              ),
            ),
            const Gap(20),

            // Inner Tab Views
            SizedBox(
              height: 450,
              child: TabBarView(
                children: [
                  // A. Visual Chart
                  PieChartWithValue(
                    title1: 'Returns',
                    title2: 'Invest',
                    list: [
                      InvestValue(
                        title: 'Investment amount',
                        value: formatCurrency(sipResult.invested),
                        inrFomat: false,
                        color: Colors.grey.shade800,
                      ),
                      InvestValue(
                        title: 'Est Returns',
                        value: formatCurrency(sipResult.returns),
                        inrFomat: false,
                        color: Colors.grey.shade800,
                      ),
                      InvestValue(
                        title: 'Total Value',
                        inrFomat: false,
                        value: formatCurrency(sipResult.totalValue),
                        color: Ucolors.dark,
                      ),
                    ],
                    piechartvalue1: sipResult.returns,
                    piechartvalue2: sipResult.invested,
                    piechartcolor2: Ucolors.primary.withOpacity(0.2),
                    piechartcolor1: Ucolors.primary,
                  ),

                  // B. Report Table
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TableHeader(
                          heading1: 'Years',
                          heading2: 'Investment',
                          heading3: 'Profit',
                          heading4: 'Current Value',
                        ),
                        DashedLine(color: Ucolors.borderColor, dashSpace: 0),
                        ...returns.map(
                          (row) => ReturnsTableRow(
                            color3: Colors.green.shade600,
                            data: row as ReturnRow,
                            percentage: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );

    // 3. Responsive Layout Logic
    if (isDesktop) {
      return Center(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: inputs), // 40% Width
              const Gap(30),
              Expanded(flex: 6, child: results), // 60% Width
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [const Gap(18), inputs, const Gap(18), results, const Gap(200),],
        ),
      );
    }
  }

  // =========================================================
  // 🔹 LUMPSUM TAB LAYOUT
  // =========================================================
  Widget _buildLumpsumTab(bool isDesktop) {
    // 1. Inputs
    Widget inputs = Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 0),
      decoration: isDesktop ? _webCardDecoration() : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            const Text(
              "Input Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          if (isDesktop) const Gap(20),
          SipSliderTile2(
            title: 'Total Investment',
            value: totalInvestment,
            min: 100,
            max: 1000000,
            prefix: '',
            onChanged: (value) => setState(() => totalInvestment = value),
            suffix: '₹',
          ),
          SipSliderTile2(
            title: 'Expected return rate (p.a)',
            value: returnRatelumpsum,
            min: 1,
            max: 30,
            suffix: '%',
            onChanged: (val) => setState(() => returnRatelumpsum = val),
          ),
          SipSliderTile2(
            title: 'Total period',
            value: yearslumpsum,
            min: 1,
            max: 30,
            suffix: 'Years',
            onChanged: (val) => setState(() => yearslumpsum = val),
          ),
        ],
      ),
    );

    // 2. Results
    Widget results = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      decoration: BoxDecoration(
        color: Ucolors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Ucolors.borderside),
        boxShadow: isDesktop
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
            : null,
      ),
      child: PieChartWithValue(
        title1: 'Returns',
        title2: 'Invest',
        list: [
          InvestValue(
            title: 'Investment amount',
            inrFomat: false,
            value: formatCurrency(lumpsumResult.invested),
            color: Colors.grey.shade800,
          ),
          InvestValue(
            title: 'Est Returns',
            inrFomat: false,
            value: formatCurrency(lumpsumResult.returns),
            color: Colors.grey.shade800,
          ),
          InvestValue(
            inrFomat: false,
            title: 'Total Value',
            value: formatCurrency(lumpsumResult.totalValue),
            color: Ucolors.dark,
          ),
        ],
        piechartvalue1: lumpsumResult.returns,
        piechartvalue2: lumpsumResult.invested,
        piechartcolor2: Ucolors.primary.withOpacity(0.2),
        piechartcolor1: Ucolors.primary,
      ),
    );

    // 3. Responsive Layout Logic
    if (isDesktop) {
      return Center(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: inputs),
              const Gap(30),
              Expanded(flex: 6, child: results),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [const Gap(18), inputs, const Gap(24), results],
        ),
      );
    }
  }

  BoxDecoration _webCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    );
  }
}
