import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';

import '../../../../fund_details/presentation/pages/fund_deatails.dart';

class CompareFundsPage extends GetView<FundDetailsController> {
  CompareFundsPage({super.key});

  final List<Map<String, dynamic>> returns = [
    {
      "title": "1Y",
      "values": ['-', "-"],
    },
    {
      "title": "3Y",
      "values": ["-", "-"],
    },
    {
      "title": "5Y",
      "values": ["-", "-"],
    },
    {
      "title": "Since Inception",
      "values": ["-", "-"],
    },
  ];

  final List<Map<String, dynamic>> prosAndCons = [
    {
      "title": "Pros",
      "values": ["-", "-"],
    },
    {
      "title": "Cons",
      "values": ["-", "-"],
    },
  ];

  final List<Map<String, dynamic>> fundManagers = [
    {
      "title": "Name",
      "values": ["-", "-"],
    },
    {
      "title": "Education",
      "values": ["-", "-"],
    },
    {
      "title": "Experience",
      "values": ["-", "-"],
    },
  ];

  final List<Map<String, dynamic>> aboutFund = [
    {
      "title": "Description",
      "values": ["-", "-"],
    },
    {
      "title": "Launch Date",
      "values": ["-", "-"],
    },
    {
      "title": "Custodian",
      "values": ["-", "-"],
    },
    {
      "title": "Registrar & Transfer Agent",
      "values": ["-", "-"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments as Map<String, dynamic>?;
    final name = arg?['name'];
    final name2 = arg?['name2'];
    log(arg.toString() + ' No argu');
    return Scaffold(
      // backgroundColor: Colors.grey,
      backgroundColor: Colors.white.withOpacity(0.985),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Compare Funds"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(12),
            // _addFundSection(context),
            Row(
              children: [
                Expanded(
                  child: Comparecard(
                    isAdd: name ?? true,
                    title:
                        name ??
                        'Nippon India Large Cap Fund- Growth Plan- Growth Option',
                    url: controller.imgUrl,
                  ),
                ),

                Gap(2),

                // Expanded(child: headercard1('Add A fund', ' ', false)),
                Expanded(
                  child: Comparecard(title: name2 ?? '', url: ''),
                ),
              ],
            ),
            Gap(12),
            _compareTitle(),
            const SizedBox(height: 12),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),

            CompareExpansion(title: "FUND DETAILS", child: FundDetailsTable()),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),
            CompareExpansion(
              title: "RETURNS",
              // child: _placeholder("Returns data"
              // ),
              // child: FundDetailsTable(),
              child: CompareTable(data: returns),
            ),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),

            CompareExpansion(
              title: "PROS & CONS",
              // child: _placeholder("Pros & Cons"),
              child: CompareTable(data: prosAndCons),
            ),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),

            CompareExpansion(
              title: "TOP 5 HOLDINGS",
              child: _placeholder("Holdings"),
              // child: CompareTable(data: data),
            ),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),

            CompareExpansion(
              title: "FUND MANAGERS",
              // child: _placeholder("Managers"),
              child: CompareTable(data: fundManagers),
            ),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),

            CompareExpansion(
              title: "ABOUT FUND",
              // child: _placeholder("About fund"),
              child: CompareTable(data: aboutFund),
            ),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),

            CompareExpansion(
              title: "POPULAR COMPARISONS",
              child: _placeholder("Popular comparisons"),
            ),
            DashedLine(dashSpace: 0, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  // Widget headercard1(String title, String url, bool isAdd) {
  //   return comparecard();
  // }

  // ---------------- ADD FUND SECTION ----------------
  Widget _addFundSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: List.generate(
          2,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => _openSearchBottomSheet(context),
              child: Container(
                height: 100,
                margin: EdgeInsets.only(right: index == 0 ? 8 : 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add a fund",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TITLE ----------------
  Widget _compareTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Compare Funds",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 6),
          Text(
            "Detailed comparison on parameters like NAV | Returns | Risk | Rating | Analysis",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ---------------- SEARCH BOTTOM SHEET ----------------
  void _openSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Ucolors.primary,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "SEARCH MUTUAL FUNDS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search fund",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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

  Widget _placeholder(String text) {
    return SizedBox(height: 120, child: Center(child: Text(text)));
  }
}

class Comparecard extends StatelessWidget {
  const Comparecard({
    super.key,
    required this.title,
    required this.url,
    this.isAdd = false,
  });

  final String title;
  final String url;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSearchBottomSheet(context),
      child: Card(
        elevation: 5,
        color: Colors.white,

        child: SizedBox(
          height: 130,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: !isAdd
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            maxRadius: 18,
                            // backgroundImage: AssetImage(url),
                            child: CustomCachedImage(imageUrl: url),
                          ),
                          Icon(
                            Icons.compare_arrows_outlined,
                            color: Ucolors.red,
                          ),
                        ],
                      ),
                      // Gap(3),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        title,
                        style: UTextStyles.medium.copyWith(
                          color: Ucolors.dark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.add), Text('Add fund')],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _openSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Ucolors.primary,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    "SEARCH MUTUAL FUNDS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search fund",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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

// ================= EXPANSION TILE =================
class CompareExpansion extends StatelessWidget {
  final String title;
  final Widget child;

  const CompareExpansion({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: true,
      shape: Border.all(color: Colors.black),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      // childrenPadding: const EdgeInsets.all(12),
      children: [child],
    );
  }
}

// ================= FUND DETAILS TABLE =================
class FundDetailsTable extends StatelessWidget {
  FundDetailsTable({super.key});

  final List<Map<String, String>> rows = [
    {"title": "Risk", "left": "-", "right": "-"},
    {"title": "Rating", "left": "-", "right": "-"},
    {"title": "Min SIP Amount", "left": "-", "right": "-"},
    {"title": "Expense Ratio", "left": "-", "right": "-"},
    {"title": "Fund Started", "left": "-", "right": "-"},
    {"title": "Exit Load", "left": "-", "right": "-"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.map((row) {
        return Column(
          children: [
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Center(
                child: Text(
                  row["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Row(
              children: [_valueCell(row["left"]!), _valueCell(row["right"]!)],
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _valueCell(String value) {
    return Expanded(
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(value),
      ),
    );
  }
}

class CompareTable extends StatelessWidget {
  /// Each item:
  /// {
  ///   "title": "1Y",
  ///   "values": ["-", "-"]
  /// }
  final List<Map<String, dynamic>> data;

  const CompareTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((row) {
        final List<String> values = List<String>.from(row["values"]);

        return Column(
          children: [
            // Header row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade100,
              child: Center(
                child: Text(
                  row["title"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // Value row
            Row(
              children: values
                  .map((value) => Expanded(child: _valueCell(value)))
                  .toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _valueCell(String value) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }
}
