// import 'package:flutter/material.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';

// class Filterpage extends StatelessWidget {
//   const Filterpage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> leftMenu = [
//       'Sort by',
//       'Categories',
//       'Risk',
//       'Ratings',
//       'Fund House',
//     ];

//     return Scaffold(
//       appBar: CustomAppBarNormal(
//         bottom: PreferredSize(
//           preferredSize: Size(double.infinity, 1),
//           child: Divider(height: 0),
//         ),

//         title: 'Filters',
//         actionsPadding: 15,
//         action: [
//           Text(
//             'Clear all',
//             style: UTextStyles.caption.copyWith(
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ],
//       ),
//       body: Row(
//         // mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 120,
//             decoration: const BoxDecoration(
//               border: Border(right: BorderSide(color: Colors.black12)),
//             ),
//             child: ListView.separated(
//               padding: EdgeInsets.zero,

//               separatorBuilder: (context, index) => Divider(
//                 height: 0,
//                 color: Ucolors.borderside.withOpacity(0.3),
//               ),

//               itemCount: leftMenu.length,
//               itemBuilder: (context, index) {
//                 // final selected = selectedMenuIndex == index;
//                 return InkWell(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 20,
//                       horizontal: 12,
//                     ),
//                     // color: selected ? Colors.grey.shade200 : Colors.white,
//                     child: Text(
//                       leftMenu[index],
//                       style: TextStyle(
//                         color: Color(0xff4C4B50),
//                         // fontWeight: selected
//                         // ? FontWeight.bold
//                         // : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           Expanded(child: FilterCategoryPanel()),
//         ],
//       ),
//     );
//   }
// }

// class _CategoryItem extends StatelessWidget {
//   final String title;

//   const _CategoryItem({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0),
//       child: Row(
//         children: [
//           Checkbox(value: false, onChanged: (_) {}),
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 16, color: Color(0xff4C4B50)),
//             ),
//           ),
//           const Icon(
//             Icons.keyboard_arrow_down,
//             color: Color(0xff4C4B50),
//             size: 14,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FilterCategoryPanel extends StatefulWidget {
//   const FilterCategoryPanel({super.key});

//   @override
//   State<FilterCategoryPanel> createState() => _FilterCategoryPanelState();
// }

// class _FilterCategoryPanelState extends State<FilterCategoryPanel> {
//   bool indexFundsOnly = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Index Funds Toggle
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.black12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Flexible(
//                   child: const Text(
//                     'Index Funds only',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ),
//                 Flexible(
//                   // fit: FlexFit.loose,
//                   // flex: 0,
//                   child: SwitchTheme(
//                     data: SwitchThemeData(
//                       trackColor: MaterialStateProperty.resolveWith((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return Ucolors.primary;
//                         }
//                         return const Color(0xFFF0F0F0);
//                       }),
//                       thumbColor: MaterialStateProperty.all(Colors.white),
//                       trackOutlineColor: MaterialStateProperty.all(
//                         Colors.transparent,
//                       ),
//                       trackOutlineWidth: MaterialStateProperty.all(0),
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: Switch(
//                       value: indexFundsOnly,
//                       onChanged: (value) {
//                         setState(() {
//                           indexFundsOnly = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           /// Categories
//           _CategoryItem(title: 'Equity'),
//           Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),
//           _CategoryItem(title: 'Debt'),
//           Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),

//           _CategoryItem(title: 'Hybrid'),
//           Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),

//           _CategoryItem(title: 'Commodities'),
//           Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';

class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage> {
  int selectedMenuIndex = 0;

  final List<String> leftMenu = [
    'Sort by',
    'Categories',
    'Risk',
    'Ratings',
    'Fund House',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(
        title: 'Filters',
        actionsPadding: 15,
        action: [
          Text(
            'Clear all',
            style: UTextStyles.caption.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 0),
        ),
      ),
      body: Row(
        children: [
          /// LEFT MENU
          Container(
            width: 130,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black12)),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  DashedLine(color: Ucolors.borderColor, dashSpace: 0),
              itemCount: leftMenu.length,
              itemBuilder: (context, index) {
                final isSelected = selectedMenuIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedMenuIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          // ? const Color(0xFFE8F5F0)
                          ? Colors.transparent
                          : Colors.white,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? Ucolors.primary
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Text(
                      leftMenu[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? Ucolors.primary
                            : const Color(0xff4C4B50),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// RIGHT PANEL
          Expanded(child: _buildRightPanel()),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    switch (selectedMenuIndex) {
      case 0:
        return const SortByPanel();
      case 1:
        return const CategoriesPanel();
      case 2:
        return const RiskPanel();
      case 3:
        return const RatingsPanel();
      case 4:
        return const FundHousePanel();
      default:
        return const SizedBox();
    }
  }
}

class SortByPanel extends StatelessWidget {
  const SortByPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Popularity',
      '1Y Returns',
      '3Y Returns',
      '5Y Returns',
      'Rating',
    ];

    return ListView(
      padding: EdgeInsets.only(left: 16),
      children: items
          .map(
            (e) => RadioListTile(
              dense: true,
              isThreeLine: false,
              // visualDensity: VisualDensity(horizontal: 2),
              shape: Border(
                top: BorderSide(color: Ucolors.borderColor, width: 0.5),
                bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
              ),
              value: e,
              groupValue: 'Popularity',
              onChanged: (_) {},
              title: Text(e),
              activeColor: Ucolors.primary,
            ),
          )
          .toList(),
    );
  }
}

class CategoriesPanel extends StatefulWidget {
  const CategoriesPanel({super.key});

  @override
  State<CategoriesPanel> createState() => _CategoriesPanelState();
}

class _CategoriesPanelState extends State<CategoriesPanel> {
  bool indexFundsOnly = false;
  final List<String> equity = [
    "Flexi Cap",
    "International",
    "Large Cap",
    "Mid Cap",
    "Multi Cap",
  ];

  final List<String> debt = ["Banking PSU", "Corporate", "Floater", "Liquid"];

  final List<String> hybrid = [
    "Arbitrage",
    "Balanced Hybrid",
    "Aggressive Hyb",
    "Multi Asset",
  ];

  final List<String> commodities = ["Gold", "Silver"];

  final List<String> elssFilters = [
    "Tax Saving (80C)",
    "3-Year Lock-in",
    "Equity Exposure",
    "Long-Term Wealth",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        /// Index Funds Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Index Funds only'),
                SwitchTheme(
                  data: SwitchThemeData(
                    // splashRadius: 5,
                    trackColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Ucolors.primary;
                      }
                      return const Color(0xFFF0F0F0);
                    }),
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    trackOutlineColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    trackOutlineWidth: MaterialStateProperty.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Switch(
                    // splashRadius: 5,
                    value: indexFundsOnly,
                    onChanged: (v) {
                      setState(() {
                        indexFundsOnly = v;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _expandTile('Equity', equity),

        // DashedLine(dashWidth: 0, height: 2, color: Ucolors.dark),
        _expandTile('Debt', debt),
        _expandTile('Hybrid', hybrid),
        _expandTile('Commodities', commodities),
      ],
    );
  }

  // Widget _expandTile(String title) {
  //   return ExpansionTile(
  //     // shape: Border(bottom: BorderSide(color: Ucolors.borderColor)),
  //     visualDensity: VisualDensity(vertical: 0),
  //     leading: Checkbox(value: false, onChanged: (value) {}),
  //     dense: true,
  //     title: Text(title),
  //     trailing: const Icon(Icons.keyboard_arrow_down),
  //     children: List.generate(
  //       5,
  //       (index) => Column(
  //         children: [
  //           CheckboxListTile(
  //             contentPadding: const EdgeInsets.only(left: 48),
  //             dense: true,
  //             controlAffinity: ListTileControlAffinity.leading,
  //             value: false,
  //             onChanged: (value) {},
  //             title: const Text('Flexi Cap'),
  //           ),

  //           const Divider(
  //             color: Ucolors.borderColor,
  //             height: 1,
  //             thickness: 1,
  //             indent: 72,
  //             endIndent: 0,
  //           ),
  //         ],
  //       ),
  //     ),

  //     //  [
  //     //   // ListTile(title: Text('Sub Category 1')),
  //     //   // ListTile(title: Text('Sub Category 2')),
  //     //   // ...List.generate(
  //     //   //   5,
  //     //   //   (index) => CheckboxListTile(
  //     //   //     // shape: Border(bottom: BorderSide(color: Ucolors.borderColor,)),
  //     //   //     // shape: Border(bottom: BorderSide(color: Ucolors.borderside)),
  //     //   //     contentPadding: EdgeInsets.only(left: 50),
  //     //   //     dense: true,
  //     //   //     // isThreeLine: true,
  //     //   //     controlAffinity: ListTileControlAffinity.leading,

  //     //   //     // side: BorderSide(color: Colors.black),
  //     //   //     shape: Border(bottom: BorderSide(color: Ucolors.borderColor)),
  //     //   //     value: false,
  //     //   //     onChanged: (value) {},
  //     //   //     title: Text('Flexi Cap'),
  //     //   //   ),
  //     //   // ),
  //     // ],
  //   );
  // }
  Widget _expandTile(String title, List<String> list) {
    return ExpansionTile(
      // dense: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.only(left: 12),
      visualDensity: VisualDensity.compact,
      trailing: const Icon(Icons.keyboard_arrow_down, size: 20),

      title: Row(
        children: [
          Checkbox(
            // splashRadius: 6,
            value: false,
            onChanged: (value) {},
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),

      children: List.generate(
        // 5
        list.length,
        (index) => Column(
          children: [
            CheckboxListTile(
              contentPadding: const EdgeInsets.only(left: 10, right: 12),
              dense: true,
              visualDensity: VisualDensity.compact,
              controlAffinity: ListTileControlAffinity.leading,
              value: false,
              onChanged: (value) {},
              title: Text(
                list[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 36,
              color: Ucolors.borderColor,
            ),
          ],
        ),
      ),
    );
  }
}

class RiskPanel extends StatelessWidget {
  const RiskPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final risks = [
      'Low',
      'Moderately Low',
      'Moderate',
      'Moderately High',
      'High',
      'Very High',
    ];

    return ListView(
      padding: EdgeInsets.only(left: 16),
      // padding: EdgeInsets.only(bottom: 10),
      children: risks
          .map(
            (e) => CheckboxListTile(
              dense: true,
              activeColor: Ucolors.primary,
              isThreeLine: false,
              shape: Border(
                top: BorderSide(color: Ucolors.borderColor, width: 0.5),
                bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
              ),
              value: false,
              onChanged: (_) {},
              title: Text(e),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          )
          .toList(),
    );
  }
}

class RatingsPanel extends StatelessWidget {
  const RatingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ratings = ['5 ★', '4+ ★', '3+ ★', '2+ ★', '1+ ★'];

    return ListView(
      // padding: EdgeInsets.zero,
      padding: const EdgeInsets.only(left: 16),

      children: ratings
          .map(
            (e) => RadioListTile(
              dense: true,
              isThreeLine: false,
              shape: Border(
                bottom: BorderSide(
                  color: Ucolors.borderColor,
                  // strokeAlign: BorderSide.strokeAlignCenter,
                  // style: BorderStyle.
                ),
              ),
              value: e,
              groupValue: '5 ★',
              onChanged: (_) {},
              title: Text(e),
              activeColor: Ucolors.primary,
            ),
          )
          .toList(),
    );
  }
}

class FundHousePanel extends StatelessWidget {
  const FundHousePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final funds = [
      'Axis Mutual Fund',
      'HDFC Mutual Fund',
      'ICICI Prudential',
      'SBI Mutual Fund',
      'DSP Mutual Fund',
    ];

    return ListView(
      padding: const EdgeInsets.only(left: 16, top: 16),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 7.0),
          child: TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Ucolors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              // contentPadding: EdgeInsets.only(right: 10),
              hintText: 'Search fund house',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...funds.map(
          (e) => CheckboxListTile(
            shape: Border(bottom: BorderSide(color: Ucolors.borderside)),
            contentPadding: EdgeInsets.zero,
            dense: true,
            isThreeLine: false,
            controlAffinity: ListTileControlAffinity.leading,
            value: false,
            onChanged: (value) {},
            title: Text(e),
          ),
        ),

        // ...funds.map(
        //   (e) =>
        //       CheckboxListTile(value: false, onChanged: (_) {}, title: Text(e)),
        // ),
      ],
    );
  }
}
