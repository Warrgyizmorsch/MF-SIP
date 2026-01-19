import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';

import '../../../fund_details/presentation/pages/fund_deatails.dart';

class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage> {
  final FundhouseController controller = Get.find();

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
      bottomNavigationBar: SafeArea(
        top: false,

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: const UElevatedBUtton(
            child: Center(
              child: Text('View All', style: TextStyle(color: Ucolors.light)),
            ),
          ),
        ),
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
        return FundHousePanel();
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
  FundHousePanel({super.key});

  final FundhouseController controller = Get.find<FundhouseController>();

  @override
  Widget build(BuildContext context) {
    log('${controller.fundlist.length} fundlist');

    return Obx(
      () => ListView(
        padding: const EdgeInsets.only(left: 16, top: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: TextField(
              onChanged: controller.searchFundHouse,
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

          if (controller.isLoading.value)
            Center(child: CircularProgressIndicator(color: Ucolors.primary))
          else if (controller.filteredFundlist.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  "No fund houses found",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            )
          else
            ...controller.filteredFundlist.map(
              (e) => CheckboxListTile(
                activeColor: Ucolors.primary,
                shape: Border(bottom: BorderSide(color: Ucolors.borderside)),
                contentPadding: EdgeInsets.zero,
                dense: true,
                isThreeLine: false,
                controlAffinity: ListTileControlAffinity.leading,
                value: controller.selectAmcname.contains(e.amcName),
                onChanged: (bool? echeck) =>
                    controller.toggleSelection(e.amcName),

                title: Text(e.amcName.toString()),
              ),
            ),
        ],
      ),
    );
  }
}
