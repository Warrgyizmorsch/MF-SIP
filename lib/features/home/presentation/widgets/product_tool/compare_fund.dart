// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/images/custom_cached_image.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';

// import '../../../../fund_details/presentation/pages/fund_deatails.dart';

// class CompareFundsPage extends GetView<FundDetailsController> {
//   CompareFundsPage({super.key});

//   final List<Map<String, dynamic>> returns = [
//     {
//       "title": "1Y",
//       "values": ['-', "-"],
//     },
//     {
//       "title": "3Y",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "5Y",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Since Inception",
//       "values": ["-", "-"],
//     },
//   ];

//   final List<Map<String, dynamic>> prosAndCons = [
//     {
//       "title": "Pros",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Cons",
//       "values": ["-", "-"],
//     },
//   ];

//   final List<Map<String, dynamic>> fundManagers = [
//     {
//       "title": "Name",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Education",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Experience",
//       "values": ["-", "-"],
//     },
//   ];

//   final List<Map<String, dynamic>> aboutFund = [
//     {
//       "title": "Description",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Launch Date",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Custodian",
//       "values": ["-", "-"],
//     },
//     {
//       "title": "Registrar & Transfer Agent",
//       "values": ["-", "-"],
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final arg = Get.arguments as Map<String, dynamic>?;
//     final name = arg?['name'];
//     final name2 = arg?['name2'];
//     log(arg.toString() + ' No argu');
//     return Scaffold(
//       // backgroundColor: Colors.grey,
//       backgroundColor: Colors.white.withOpacity(0.985),
//       appBar: AppBar(
//         leading: const BackButton(),
//         title: const Text("Compare Funds"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Gap(12),
//             // _addFundSection(context),
//             Row(
//               children: [
//                 Expanded(
//                   child: Comparecard(
//                     isAdd: name ?? true,
//                     title:
//                         name ??
//                         'Nippon India Large Cap Fund- Growth Plan- Growth Option',
//                     url: controller.imgUrl,
//                   ),
//                 ),

//                 Gap(2),

//                 // Expanded(child: headercard1('Add A fund', ' ', false)),
//                 Expanded(
//                   child: Comparecard(title: name2 ?? '', url: ''),
//                 ),
//               ],
//             ),
//             Gap(12),
//             _compareTitle(),
//             const SizedBox(height: 12),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),

//             CompareExpansion(title: "FUND DETAILS", child: FundDetailsTable()),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
//             CompareExpansion(
//               title: "RETURNS",
//               // child: _placeholder("Returns data"
//               // ),
//               // child: FundDetailsTable(),
//               child: CompareTable(data: returns),
//             ),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),

//             CompareExpansion(
//               title: "PROS & CONS",
//               // child: _placeholder("Pros & Cons"),
//               child: CompareTable(data: prosAndCons),
//             ),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),

//             CompareExpansion(
//               title: "TOP 5 HOLDINGS",
//               child: _placeholder("Holdings"),
//               // child: CompareTable(data: data),
//             ),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),

//             CompareExpansion(
//               title: "FUND MANAGERS",
//               // child: _placeholder("Managers"),
//               child: CompareTable(data: fundManagers),
//             ),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),

//             CompareExpansion(
//               title: "ABOUT FUND",
//               // child: _placeholder("About fund"),
//               child: CompareTable(data: aboutFund),
//             ),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),

//             CompareExpansion(
//               title: "POPULAR COMPARISONS",
//               child: _placeholder("Popular comparisons"),
//             ),
//             DashedLine(dashSpace: 0, color: Colors.grey.shade300),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget headercard1(String title, String url, bool isAdd) {
//   //   return comparecard();
//   // }

//   // ---------------- ADD FUND SECTION ----------------
//   Widget _addFundSection(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: List.generate(
//           2,
//           (index) => Expanded(
//             child: GestureDetector(
//               onTap: () => _openSearchBottomSheet(context),
//               child: Container(
//                 height: 100,
//                 margin: EdgeInsets.only(right: index == 0 ? 8 : 0),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(
//                       Icons.add_circle_outline,
//                       color: Colors.blue,
//                       size: 30,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       "Add a fund",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- TITLE ----------------
//   Widget _compareTitle() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text(
//             "Compare Funds",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           // SizedBox(height: 6),
//           Text(
//             "Detailed comparison on parameters like NAV | Returns | Risk | Rating | Analysis",
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------- SEARCH BOTTOM SHEET ----------------
//   void _openSearchBottomSheet(BuildContext context) {
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
//                 color: Ucolors.primary,
//                 width: double.infinity,
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

//   Widget _placeholder(String text) {
//     return SizedBox(height: 120, child: Center(child: Text(text)));
//   }
// }

// class Comparecard extends StatelessWidget {
//   const Comparecard({
//     super.key,
//     required this.title,
//     required this.url,
//     this.isAdd = false,
//   });

//   final String title;
//   final String url;
//   final bool isAdd;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openSearchBottomSheet(context),
//       child: Card(
//         elevation: 5,
//         color: Colors.white,

//         child: SizedBox(
//           height: 130,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: !isAdd
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,

//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CircleAvatar(
//                             maxRadius: 18,
//                             // backgroundImage: AssetImage(url),
//                             child: CustomCachedImage(imageUrl: url),
//                           ),
//                           Icon(
//                             Icons.compare_arrows_outlined,
//                             color: Ucolors.red,
//                           ),
//                         ],
//                       ),
//                       // Gap(3),
//                       Text(
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 3,
//                         title,
//                         style: UTextStyles.medium.copyWith(
//                           color: Ucolors.dark,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   )
//                 : Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [Icon(Icons.add), Text('Add fund')],
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _openSearchBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.9,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 color: Ucolors.primary,
//                 width: double.infinity,
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
// }

// // ================= EXPANSION TILE =================
// class CompareExpansion extends StatelessWidget {
//   final String title;
//   final Widget child;

//   const CompareExpansion({super.key, required this.title, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       dense: true,
//       shape: Border.all(color: Colors.black),

//       title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//       // childrenPadding: const EdgeInsets.all(12),
//       children: [child],
//     );
//   }
// }

// // ================= FUND DETAILS TABLE =================
// class FundDetailsTable extends StatelessWidget {
//   FundDetailsTable({super.key});

//   final List<Map<String, String>> rows = [
//     {"title": "Risk", "left": "-", "right": "-"},
//     {"title": "Rating", "left": "-", "right": "-"},
//     {"title": "Min SIP Amount", "left": "-", "right": "-"},
//     {"title": "Expense Ratio", "left": "-", "right": "-"},
//     {"title": "Fund Started", "left": "-", "right": "-"},
//     {"title": "Exit Load", "left": "-", "right": "-"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: rows.map((row) {
//         return Column(
//           children: [
//             Container(
//               color: Colors.grey.shade100,
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               width: double.infinity,
//               child: Center(
//                 child: Text(
//                   row["title"]!,
//                   style: const TextStyle(fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ),
//             Row(
//               children: [_valueCell(row["left"]!), _valueCell(row["right"]!)],
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _valueCell(String value) {
//     return Expanded(
//       child: Container(
//         height: 45,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           border: Border(
//             right: BorderSide(color: Colors.grey.shade300),
//             bottom: BorderSide(color: Colors.grey.shade300),
//           ),
//         ),
//         child: Text(value),
//       ),
//     );
//   }
// }

// class CompareTable extends StatelessWidget {
//   /// Each item:
//   /// {
//   ///   "title": "1Y",
//   ///   "values": ["-", "-"]
//   /// }
//   final List<Map<String, dynamic>> data;

//   const CompareTable({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: data.map((row) {
//         final List<String> values = List<String>.from(row["values"]);

//         return Column(
//           children: [
//             // Header row
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               color: Colors.grey.shade100,
//               child: Center(
//                 child: Text(
//                   row["title"],
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),

//             // Value row
//             Row(
//               children: values
//                   .map((value) => Expanded(child: _valueCell(value)))
//                   .toList(),
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _valueCell(String value) {
//     return Container(
//       height: 48,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         border: Border(
//           right: BorderSide(color: Colors.grey.shade300),
//           bottom: BorderSide(color: Colors.grey.shade300),
//         ),
//       ),
//       child: Text(value, style: const TextStyle(fontSize: 14)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/domain/entity/fund_detail_entity.dart';
import 'package:my_sip/features/fund_details/domain/entity/portfolio_analysis_entity.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/comparefund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

// Import the new controller

class CompareFundsPage extends GetView<CompareFundController> {
  CompareFundsPage({super.key});

  // We need MutualFundController ONLY for the search list
  final MutualFundController mutualFundController =
      Get.find<MutualFundController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.985),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Compare Funds"),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          // Listen to Controller State
          final f1Basic = controller.fund1Basic.value;
          final f2Basic = controller.fund2Basic.value;
          final f1Detail = controller.fund1Detail.value;
          final f2Detail = controller.fund2Detail.value;
          final f1Port = controller.fund1Portfolio.value;
          final f2Port = controller.fund2Portfolio.value;

          return Column(
            children: [
              const Gap(12),

              // --- 1. HEADER SELECTION CARDS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: CompareCard(
                        fund: f1Basic,
                        isLoading: controller.isFund1Loading.value,
                        onTap: () => _openSearchSheet(context, 1),
                        onRemove: () => controller.removeFund(1),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: CompareCard(
                        fund: f2Basic,
                        isLoading: controller.isFund2Loading.value,
                        onTap: () => _openSearchSheet(context, 2),
                        onRemove: () => controller.removeFund(2),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(12),
              _compareTitle(),
              const SizedBox(height: 12),

              // --- 2. COMPARISON TABLES (Dynamic Data) ---
              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "FUND DETAILS",
                child: FundDetailsTable(d1: f1Detail, d2: f2Detail),
              ),

              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "RETURNS",
                child: CompareTable(data: _getReturnsData(f1Detail, f2Detail)),
              ),

              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "TOP 5 HOLDINGS",
                // Pass Portfolio Entities here
                child: HoldingsCompareTable(p1: f1Port, p2: f2Port),
              ),

              DashedLine(dashSpace: 0, color: Colors.grey.shade300),
              CompareExpansion(
                title: "FUND MANAGERS",
                child: CompareTable(data: _getManagerData(f1Detail, f2Detail)),
              ),

              const Gap(50),
            ],
          );
        }),
      ),
    );
  }

  // --- DATA MAPPING HELPERS ---

  List<Map<String, dynamic>> _getReturnsData(
    FundDetailEntity? d1,
    FundDetailEntity? d2,
  ) {
    // Helper to extract return safely
    String ret(FundDetailEntity? d, String type) {
      if (d == null || d.schemePerformanceList.isEmpty) return "-";
      final p =
          d.schemePerformanceList.first; // Assuming 1st item is the Scheme

      switch (type) {
        case '1Y':
          return "${p.oneYearReturn}%";
        case '3Y':
          return "${p.threeYearReturn}%";
        case '5Y':
          return "${p.fiveYearReturn}%";
        case 'Inception':
          return "${d.schemeInceptionReturn}%";
        default:
          return "-";
      }
    }

    return [
      {
        "title": "1Y",
        "values": [ret(d1, '1Y'), ret(d2, '1Y')],
      },
      {
        "title": "3Y",
        "values": [ret(d1, '3Y'), ret(d2, '3Y')],
      },
      {
        "title": "5Y",
        "values": [ret(d1, '5Y'), ret(d2, '5Y')],
      },
      {
        "title": "Inception",
        "values": [ret(d1, 'Inception'), ret(d2, 'Inception')],
      },
    ];
  }

  List<Map<String, dynamic>> _getManagerData(
    FundDetailEntity? d1,
    FundDetailEntity? d2,
  ) {
    return [
      {
        "title": "Manager",
        "values": [d1?.schemeManager ?? "-", d2?.schemeManager ?? "-"],
      },
    ];
  }

  // --- SEARCH BOTTOM SHEET ---
  void _openSearchSheet(BuildContext context, int slot) {
    // Clear previous search when opening
    mutualFundController.searchFundFn('');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.96,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // Header
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

                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: "Search fund",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (val) =>
                        mutualFundController.onSearchQueryChanged(val),
                  ),
                ),

                // Fund List
                Expanded(
                  child: Obx(() {
                    final list = mutualFundController.searchFund;
                    if (mutualFundController.isLoading.value) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (list.isEmpty)
                      return const Center(child: Text("No funds found"));

                    return ListView.separated(
                      controller: scrollController,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, index) {
                        final item = list[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.shade100,
                            // Placeholder icon since list entity doesn't have image
                            // child: const Icon(Icons.show_chart, size: 18),
                            child: CustomCachedImage(
                              imageUrl:
                                  '${Appurl.baseUrl}${item.amc?.amcLogoUrl}',
                            ),
                          ),
                          title: Text(
                            item.baseSchemeName ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            // 1. Update Controller
                            controller.setFund(slot, item);
                            // 2. Close Sheet
                            Get.back();
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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
          Text(
            "Detailed comparison on parameters...",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ================== WIDGETS ==================

class CompareCard extends StatelessWidget {
  final MutualFundListEntity? fund;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const CompareCard({
    super.key,
    required this.fund,
    required this.isLoading,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        color: Colors.white,
        child: SizedBox(
          height: 130,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (fund == null) {
      return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, color: Colors.blue, size: 30),
                SizedBox(height: 8),
                Text(
                  "Add a fund",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      child: SizedBox(
        height: 130,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: CustomCachedImage(
                      imageUrl: 
                          '${Appurl.baseUrl}${fund?.amc?.amcLogoUrl}' ?? '',
                    ),
                  ),
                  const Gap(8),
                  Text(
                    fund?.baseSchemeName ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: UTextStyles.medium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FundDetailsTable extends StatelessWidget {
  final FundDetailEntity? d1;
  final FundDetailEntity? d2;

  const FundDetailsTable({super.key, this.d1, this.d2});

  @override
  Widget build(BuildContext context) {
    // Helper to create row data
    Map<String, String> row(String title, String Function(FundDetailEntity) f) {
      return {
        "title": title,
        "left": d1 != null ? f(d1!) : "-",
        "right": d2 != null ? f(d2!) : "-",
      };
    }

    final rows = [
      row("Risk", (e) => e.riskometerValue),
      row("Rating", (e) => "${e.ratingValue} ★"),
      row("NAV", (e) => "₹${e.nav}"),
      row("Min SIP", (e) => "₹${e.sipMinimumAmount}"),
      row("Exp Ratio", (e) => "${e.expenseRatioPercentage}%"),
      row("Launch", (e) => e.schemeInceptionDate),
    ];

    return Column(children: rows.map((r) => _buildRow(r)).toList());
  }

  Widget _buildRow(Map<String, String> row) {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          child: Center(
            child: Text(
              row["title"]!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Row(children: [_cell(row["left"]!), _cell(row["right"]!)]),
      ],
    );
  }

  Widget _cell(String txt) => Expanded(
    child: Container(
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        txt,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );
}

// Simple Table for Returns/Managers
class CompareTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const CompareTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((row) {
        final List<String> values = List<String>.from(row["values"]);
        return Column(
          children: [
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
            Row(
              children: values
                  .map(
                    (val) => Expanded(
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey.shade300),
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(val, style: const TextStyle(fontSize: 13)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// Special Table for Holdings (Just showing top 3 names for brevity)
class HoldingsCompareTable extends StatelessWidget {
  final SchemeDetailsEntity? p1;
  final SchemeDetailsEntity? p2;

  const HoldingsCompareTable({super.key, this.p1, this.p2});

  @override
  Widget build(BuildContext context) {
    // Get top 3 holdings
    List<String> getTop(SchemeDetailsEntity? p) {
      if (p == null || p.schemePortfolioHoldingsNamesString.isEmpty)
        return ["-", "-", "-"];
      return p.schemePortfolioHoldingsNamesString.take(3).toList();
    }

    final list1 = getTop(p1);
    final list2 = getTop(p2);

    return Column(
      children: List.generate(3, (index) {
        return Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  list1.length > index ? list1[index] : "-",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  list2.length > index ? list2[index] : "-",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Standard Widgets
class DashedLine2 extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  const DashedLine2({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    // this.dashSpace = 3,
    this.color = Colors.black,
    required int dashSpace,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.constrainWidth() / (2 * dashWidth))
            .floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (_) => SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            ),
          ),
        );
      },
    );
  }
}

class CompareExpansion extends StatelessWidget {
  final String title;
  final Widget child;
  const CompareExpansion({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => ExpansionTile(
    dense: true,
    initiallyExpanded: true, // Keep open by default
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    children: [child],
  );
}
