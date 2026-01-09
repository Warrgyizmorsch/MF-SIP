// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:my_sip/common/style/padding.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/showbottomsheet/showbottomsheet.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';

// class CompareFundPage extends StatelessWidget {
//   CompareFundPage({super.key});

//   List<String> mflist = [
//     'SBI Bluechip Fund',
//     'HDFC Top 100 Fund',
//     'ICICI Prudential Bluechip Fund',
//     'Axis Bluechip Fund',
//     'Kotak Bluechip Fund',

//     'Mirae Asset Large Cap Fund',
//     'Nippon India Large Cap Fund',
//     'Canara Robeco Bluechip Equity Fund',

//     'Parag Parikh Flexi Cap Fund',
//     'HDFC Flexi Cap Fund',
//     'Kotak Flexi Cap Fund',
//     'PGIM India Flexi Cap Fund',

//     'Axis Midcap Fund',
//     'Kotak Emerging Equity Fund',
//     'HDFC Mid-Cap Opportunities Fund',
//     'Motilal Oswal Midcap Fund',

//     'SBI Small Cap Fund',
//     'Nippon India Small Cap Fund',
//     'Axis Small Cap Fund',
//     'Quant Small Cap Fund',

//     'UTI Nifty 50 Index Fund',
//     'HDFC Index Fund – Nifty 50',
//     'ICICI Prudential Nifty Next 50 Index Fund',

//     'SBI Equity Hybrid Fund',
//     'HDFC Hybrid Equity Fund',
//     'ICICI Prudential Equity & Debt Fund',

//     'Aditya Birla Sun Life Digital India Fund',
//     'Tata Digital India Fund',
//     'ICICI Prudential Technology Fund',

//     'SBI Contra Fund',
//     'Invesco India Contra Fund',
//   ];

//   final TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarNormal(title: 'Compare Funds'),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       showSelectionBottomSheet(
//                         context: context,
//                         title: 'Select the Fund',
//                         items: mflist,
//                         controller: controller,
//                       );
//                     },
//                     child: headercard(),
//                   ),
//                 ),
//                 Gap(1),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       openSearchBottomSheet(context);
//                       // showSelectionBottomSheet(
//                       //   context: context,
//                       //   title: 'Select the Fund',
//                       //   items: mflist,
//                       //   controller: controller,
//                       // );
//                     },
//                     child: headercard(),
//                   ),
//                 ),
//               ],
//             ),
//             Gap(12),
//             Padding(
//               padding: UPadding.screenPadding,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Compare Fund',
//                     style: UTextStyles.subtitle1.copyWith(
//                       color: Ucolors.dark,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Details comparison on parameters like NAV | Returns | Returns | Risk | Rating | Analysis',
//                     style: UTextStyles.medium.copyWith(color: Ucolors.dark),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void openSearchBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.6,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.green,
//                 child: const Center(
//                   child: Text(
//                     "SEARCH MUTUAL FUNDS",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search fund",
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget headercard() {
//     return Container(
//       height: 100,
//       // color: Colors.grey.shade300,
//       margin: EdgeInsets.symmetric(horizontal: 2),

//       decoration: BoxDecoration(
//         // color: Colors.grey.shade300,
//         color: Ucolors.skyblue.withOpacity(0.4),
//         borderRadius: BorderRadius.circular(10),

//         border: Border.all(color: Ucolors.dark.withOpacity(0.2), width: 1),
//       ),

//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.add_circle_outline, color: Ucolors.primary),
//           Text('Add a Fund'),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/theme/widget_theme/text_theme.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';

class CompareFundsPage extends StatelessWidget {
  CompareFundsPage({super.key});

  final List<Map<String, dynamic>> returns = [
    {
      "title": "1Y",
      "values": ["-", "-"],
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
                  child: GestureDetector(
                    onTap: () {
                      _openSearchBottomSheet(context);
                    },
                    child: headercard(),
                  ),
                ),
                Gap(2),
                Text(
                  'v/s',
                  style: UTextStyles.large.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(2),
                Expanded(child: headercard1()),
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

  Widget headercard() {
    return Container(
      height: 100,
      // color: Colors.grey.shade300,
      margin: EdgeInsets.symmetric(horizontal: 2),

      decoration: BoxDecoration(
        // color: Colors.grey.shade300,
        color: Ucolors.skyblue.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: Ucolors.dark.withOpacity(0.2), width: 1),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, color: Ucolors.primary),
          Text('Add a Fund'),
        ],
      ),
    );
  }

  Widget headercard1() {
    return Card(
      elevation: 5,
      color: Colors.white,

      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        // height: 80,
        // width: 80,
        // color: Colors.grey.shade300,
        // margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),

        decoration: BoxDecoration(
          // color: Colors.grey.shade300,
          // color: Ucolors.skyblue.withOpacity(0.4),
          color: Ucolors.light,
          borderRadius: BorderRadius.circular(20),

          // border: Border.all(color: Ucolors.dark.withOpacity(0.2), width: 0),
        ),

        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  maxRadius: 18,
                  backgroundImage: AssetImage(UImages.sbi),
                  // child: Image.asset(UImages.sbi),
                ),
                Icon(Icons.compare_arrows_outlined, color: Ucolors.red),
              ],
            ),
            Gap(3),
            Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              'Nippon India Large Cap Fund- Growth Plan- Growth Option',
              style: UTextStyles.medium.copyWith(
                color: Ucolors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Icon(Icons.add_circle_outline, color: Ucolors.primary),
            // Text('Add a Fund'),
          ],
        ),
      ),
    );
  }

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
