import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

import '../../../fund_details/presentation/pages/fund_deatails.dart';

class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage> {
  final FundhouseController controller = Get.find();
  final MutualFundController mutualFundController = Get.find();

  int selectedMenuIndex = 0;

  final List<String> leftMenu = [
    // 'Sort by',
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
          child: Obx(
            () => UElevatedBUtton(
              // onPressed:  () => Get.back(
              //   result: controller.selectedAmcIds.toList(),
              //   // result: {
              //   //   'amc_id': controller.selectedAmcIds.toList(),
              //   //   'scheme_type': controller.selectedSchemeTyep.toList(),w
              //   // },
              // ),
              // onPressed: controller.selectedFundCount.value == 0
              //     ? null
              //     : () => Get.back(result: controller.buildParam()),
              onPressed: () => Get.back(result: controller.buildParam()),
              child: Center(
                child: Text(
                  'View All ${controller.selectedFundCount}',
                  style: TextStyle(color: Ucolors.light),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    switch (selectedMenuIndex) {
      case 0:
        return SortByPanel();
      case 1:
        return CategoriesPanel();
      case 2:
        return RiskPanel();
      case 3:
        return RatingsPanel();
      case 4:
        return FundHousePanel();
      default:
        return const SizedBox();
    }
  }
}

class SortByPanel extends StatelessWidget {
  SortByPanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> options = {
      'Popularity': 'popularity',
      '1Y Returns': '1y',
      '3Y Returns': '3y',
      '5Y Returns': '5y',
      'Rating': 'rating',
    };

    return Obx(
      () => ListView(
        padding: EdgeInsets.only(left: 16),
        children: options.entries
            .map(
              (e) => RadioListTile<String>(
                dense: true,
                isThreeLine: false,
                // visualDensity: VisualDensity(horizontal: 2),
                shape: Border(
                  top: BorderSide(color: Ucolors.borderColor, width: 0.5),
                  bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
                ),
                value: e.value,
                groupValue: controller.sortBy.value,
                onChanged: (v) => controller.sortBy.value = v!,

                title: Text(e.key),
                activeColor: Ucolors.primary,
              ),
            )
            .toList(),
      ),
    );
  }
}

class CategoriesPanel extends StatelessWidget {
  CategoriesPanel({super.key});

  bool indexFundsOnly = false;
  final FundhouseController controller = Get.find();

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
        Container(
          // Web: Prevents the button from becoming too wide
          // Mobile: Adapts to screen width naturally
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            8,
            8,
          ), // Adjusted padding for balance
          decoration: BoxDecoration(
            color: Colors.white, // Ensure background is visible
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize:
                MainAxisSize.min, // Important: Wraps content width on Web
            children: [
              // 1. Use Flexible/Expanded to handle text sizing safely
              Flexible(
                fit: FlexFit
                    .loose, // Allows text to be its natural size, shrinks if needed
                child: Text(
                  'Index Funds only',
                  style: UTextStyles.medium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis, // Safe clipping on small mobiles
                ),
              ),

              const SizedBox(width: 8),

              // 2. Scaled Switch (Keeps it compact)
              Transform.scale(
                scale: 0.8,
                alignment: Alignment.centerRight,
                child: SwitchTheme(
                  data: SwitchThemeData(
                    trackColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Ucolors.primary;
                      }
                      return const Color(0xFFE0E0E0);
                    }),
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    trackOutlineColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    trackOutlineWidth: MaterialStateProperty.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Obx(
                    () => Switch(
                      value: controller.indexFundOnly.value,
                      onChanged: (v) => controller.indexFundOnly.toggle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _expandTile('Equity', equity, 'equity'),

        // DashedLine(dashWidth: 0, height: 2, color: Ucolors.dark),
        _expandTile('Debt', debt, 'debt'),
        _expandTile('Hybrid', hybrid, 'hybrid'),
        _expandTile('Commodities', commodities, 'commodities'),
      ],
    );
  }

  // Widget _expandTile(String title) {
  Widget _expandTile(String title, List<String> list, String schemeType) {
    return Obx(
      () => ExpansionTile(
        // dense: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.only(left: 12),
        visualDensity: VisualDensity.compact,
        trailing: const Icon(Icons.keyboard_arrow_down, size: 20),

        title: Row(
          children: [
            Checkbox(
              activeColor: Ucolors.primary,
              // splashRadius: 6,
              value: controller.selectedSchemeTyep.contains(schemeType),
              onChanged: (value) {
                controller.toggleSchemeType(schemeType);
              },
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
      ),
    );
  }
}

class RiskPanel extends StatelessWidget {
  RiskPanel({super.key});
  final FundhouseController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final List<String> risks = [
      'Low',
      'Moderately Low',
      'Moderate',
      'Moderately High',
      'High',
      'Very High',
    ];

    return Obx(
      () => ListView(
        padding: EdgeInsets.only(left: 16),
        // padding: EdgeInsets.only(bottom: 10),
        children: risks.map((risk) {
          final key = risk.toLowerCase().replaceAll(' ', '_');

          return CheckboxListTile(
            dense: true,
            activeColor: Ucolors.primary,
            isThreeLine: false,
            shape: Border(
              top: BorderSide(color: Ucolors.borderColor, width: 0.5),
              bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
            ),
            value: controller.selectedRisk.contains(key),
            onChanged: (_) => controller.toggleRisk(risk),
            title: Text(risk),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}

class RatingsPanel extends StatelessWidget {
  RatingsPanel({super.key});

  final FundhouseController controller = Get.find();

  final Map<String, int> ratings = {
    '5 ★': 5,
    '4+ ★': 4,
    '3+ ★': 3,
    '2+ ★': 2,
    '1+ ★': 1,
  };

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        // padding: EdgeInsets.zero,
        padding: const EdgeInsets.only(left: 16),

        children: ratings.entries
            .map(
              (e) => RadioListTile<int>(
                dense: true,
                isThreeLine: false,
                shape: Border(
                  bottom: BorderSide(
                    color: Ucolors.borderColor,
                    // strokeAlign: BorderSide.strokeAlignCenter,
                    // style: BorderStyle.
                  ),
                ),
                value: e.value,
                groupValue: controller.selectedRating.value,
                onChanged: (value) => controller.toggleRating(value!),
                title: Text(e.key),
                activeColor: Ucolors.primary,
              ),
            )
            .toList(),
      ),
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
                value: controller.selectedAmcIds.contains(e.id),
                onChanged: (bool? echeck) {
                  controller.toggleSelection(e.id);

                  log(e.id.toString());
                },

                title: Text(e.amcName.toString()),
              ),
            ),
        ],
      ),
    );
  }
}
