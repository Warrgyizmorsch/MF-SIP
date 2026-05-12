import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage> {
  final FundhouseController controller = Get.find();

  int selectedMenuIndex = 0;

  final List<String> leftMenu = ['Categories', 'Risk', 'Fund House', 'Returns'];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // Allow natural back navigation
      onPopInvoked: (bool didPop) {
        // 2. Grab the current selected checkboxes/filters
        final params = controller.buildParam();

        // 3. Send them to MutualFundController to update the main list
        if (Get.isRegistered<MutualFundController>()) {
          Get.find<MutualFundController>().syncFilterPageParams(params);
        }
      },

      child: Scaffold(
        appBar: CustomAppBarNormal(
          title: 'Filters',
          actionsPadding: 15,
          action: [
            Obx(
              () => InkWell(
                onTap: () => controller.clearAllFilters(),
                child: Text(
                  'Clear all',
                  style: UTextStyles.caption.copyWith(
                    color: controller.isFilterActive
                        ? Ucolors.primary
                        : Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
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
            /// LEFT MENU - Refactored to show active selection counts
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
                  return Obx(() {
                    final isSelected = selectedMenuIndex == index;

                    // Calculate count based on controller lists
                    int activeCount = 0;
                    if (index == 0) {
                      activeCount = controller.selectedSchemeTypes.length;
                    }
                    if (index == 1) {
                      activeCount = controller.selectedRisks.length;
                    }
                    // if (index == 2)
                    //   activeCount = controller.selectedRating.value != null
                    //       ? 1
                    //       : 0;
                    if (index == 2) {
                      activeCount = controller.selectedAmcIds.length;
                    }
                    if (index == 3)
                      activeCount = controller.isReturnRangeActive.value
                          ? 1
                          : 0;

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
                          color: isSelected ? Colors.transparent : Colors.white,
                          border: Border(
                            left: BorderSide(
                              color: isSelected
                                  ? Ucolors.primary
                                  : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
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
                            if (activeCount > 0)
                              CircleAvatar(
                                radius: 9,
                                backgroundColor: Ucolors.primary,
                                child: Text(
                                  '$activeCount',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  });
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
            child: UElevatedBUtton(
              onPressed: () => Get.back(result: controller.buildParam()),
              child: Center(
                child: Text(
                  // 'View All ${controller.selectedFundCount}',
                  'View All',
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
        return CategoriesPanel();
      case 1:
        return RiskPanel();
      // case 2:
      // return RatingsPanel();
      case 2:
        return FundHousePanel();
      case 3:
        return ReturnRangePanel();
      default:
        return const SizedBox();
    }
  }
}

class CategoriesPanel extends StatelessWidget {
  CategoriesPanel({super.key});

  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Index Fund Switch ---
        Container(
          padding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Index Funds only',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Obx(
                  () => Switch(
                    activeColor: Ucolors.primary,
                    value: controller.indexFundOnly.value,
                    onChanged: (value) => controller.toggleIndexFund(value),
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Dynamic Multi-Select Categories List ---
        Expanded(
          child: Obx(() {
            if (controller.categoryList.isEmpty ||
                controller.categoryList.first.categories.isEmpty) {
              return const Center(child: Text("No categories available"));
            }

            final List<String> rawList =
                controller.categoryList.first.categories;
            final Map<String, List<String>> groupedData = _groupCategories(
              rawList,
            );

            // return ListView(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   children: groupedData.entries.map((entry) {

            //     return _expandTile(entry.key, entry.value);
            //   }).toList(),
            // );
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: () {
                // 1. Convert map entries to a list
                final sortedEntries = groupedData.entries.toList();

                // 2. Sort the list alphabetically based on the Category Name (Key)
                sortedEntries.sort((a, b) => a.key.compareTo(b.key));

                // 3. Map the sorted list to your expansion tiles
                return sortedEntries.map((entry) {
                  // Optional: If you also want sub-categories sorted alphabetically:
                  final List<String> subCategories = entry.value..sort();

                  return _expandTile(entry.key, subCategories);
                }).toList();
              }(),
            );
          }),
        ),
      ],
    );
  }

  Map<String, List<String>> _groupCategories(List<String> rawList) {
    final Map<String, List<String>> groups = {};
    for (var item in rawList) {
      String groupKey = "Others";
      if (item.startsWith("Equity:"))
        groupKey = "Equity";
      else if (item.startsWith("Debt:"))
        groupKey = "Debt";
      else if (item.startsWith("Hybrid:"))
        groupKey = "Hybrid";
      else if (item.contains("Gold") || item.contains("Silver"))
        groupKey = "Commodities";
      else if (item.startsWith("Fund of Funds"))
        groupKey = "Fund of Funds";

      if (!groups.containsKey(groupKey)) groups[groupKey] = [];
      groups[groupKey]!.add(item);
    }
    return groups;
  }

  Widget _expandTile(String groupName, List<String> subItems) {
    return Obx(() {
      // Check if all sub-items in this group are selected
      bool allSelected = subItems.every(
        (item) => controller.selectedSchemeTypes.contains(item),
      );

      return Column(
        children: [
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(left: 10),
            visualDensity: VisualDensity.compact,
            shape: const Border(),
            title: Row(
              children: [
                Checkbox(
                  activeColor: Ucolors.primary,
                  visualDensity: VisualDensity.compact,
                  value: allSelected,
                  onChanged: (val) {
                    controller.toggleCategoryGroup(groupName, subItems);
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  groupName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            children: subItems.map((fullItemString) {
              String displayName = fullItemString.split(':').last.trim();
              if (displayName.contains('-')) {
                displayName = displayName
                    .substring(displayName.indexOf('-') + 1)
                    .trim();
              }
              final isSelected = controller.selectedSchemeTypes.contains(
                fullItemString,
              );
              return Column(
                children: [
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.only(left: 10, right: 12),
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Ucolors.primary,
                    title: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.blue : null,
                      ),
                    ),
                    // value: controller.selectedSchemeTypes.contains(fullItemString),
                    value: isSelected,
                    onChanged: (val) {
                      controller.toggleSubCategory(fullItemString);
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 48,
                    color: Colors.grey,
                  ),
                ],
              );
            }).toList(),
          ),
          DashedLine(color: Colors.grey.shade200, dashSpace: 0),
        ],
      );
    });
  }
}

class RiskPanel extends StatelessWidget {
  RiskPanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<String> risks = [
      'Low',
      'Low to Moderate',
      'Moderate',
      'Moderately High',
      'High',
      'Very High',
    ];

    return Obx(
      () => ListView(
        padding: const EdgeInsets.only(left: 16),
        children: risks.map((risk) {
          final key = risk.toLowerCase();
          final bool isSelected = controller.selectedRisks.contains(key);
          return CheckboxListTile(
            dense: true,
            activeColor: Ucolors.primary,
            // value: controller.selectedRisks.contains(key),
            value: isSelected,
            onChanged: (v) => controller.toggleRisk(risk),
            title: Text(
              risk,
              style: TextStyle(color: isSelected ? Ucolors.primary : null),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            shape: const Border(
              bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
            ),
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
        padding: const EdgeInsets.only(left: 16),
        children: ratings.entries
            .map(
              (e) => RadioListTile<int>(
                dense: true,
                value: e.value,
                groupValue: controller.selectedRating.value,
                onChanged: (value) => controller.toggleRating(value!),
                title: Text(e.key),
                activeColor: Ucolors.primary,
                shape: const Border(
                  bottom: BorderSide(color: Ucolors.borderColor),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// class FundHousePanel extends StatelessWidget {
//   FundHousePanel({super.key});
//   final FundhouseController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: controller.searchFundHouse,
//               decoration: InputDecoration(
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Ucolors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: 'Search fund house',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//           ),
//           Expanded(
//             child: controller.isLoading.value
//                 ? Center(child: CircularProgressIndicator(color: Ucolors.primary))
//                 : controller.filteredFundlist.isEmpty
//                     ? const Center(child: Text("No fund houses found"))
//                     : ListView.builder(
//                         itemCount: controller.filteredFundlist.length,
//                         itemBuilder: (context, index) {
//                           final e = controller.filteredFundlist[index];
//                           return CheckboxListTile(
//                             activeColor: Ucolors.primary,
//                             controlAffinity: ListTileControlAffinity.leading,
//                             value: controller.selectedAmcIds.contains(e.id),
//                             onChanged: (bool? value) {
//                               controller.toggleSelection(e.id);
//                             },
//                             title: Text(e.amcName.toString()),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class FundHousePanel extends StatelessWidget {
  FundHousePanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: controller.searchFundHouse,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Ucolors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Search fund house',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: Ucolors.primary),
              );
            }
            if (controller.filteredFundlist.isEmpty) {
              return const Center(child: Text("No fund houses found"));
            }

            return ListView.builder(
              // padding: EdgeInsets.only(left: 16),
              key: const PageStorageKey('fund_house_list'),
              itemCount: controller.filteredFundlist.length,
              itemBuilder: (context, index) {
                final e = controller.filteredFundlist[index];

                // CRITICAL: Wrap the individual item in Obx
                // This ensures this specific tile rebuilds when toggleSelection is called
                return Obx(() {
                  final bool isSelected = controller.isAmcSelected(e.id);

                  return CheckboxListTile(
                    shape: const Border(
                      bottom: BorderSide(
                        color: Ucolors.borderColor,
                        width: 0.5,
                      ),
                    ),

                    key: ValueKey(e.id),
                    activeColor: Ucolors.primary,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: isSelected,
                    onChanged: (bool? value) {
                      controller.toggleSelection(e.id);
                    },

                    title: Text(
                      e.amcName.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Ucolors.primary : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  );
                });
              },
            );
          }),
        ),
      ],
    );
  }
}

class ReturnRangePanel extends StatelessWidget {
  ReturnRangePanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Return Range (%)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Obx(() {
            return Column(
              children: [
                RangeSlider(
                  activeColor: Ucolors.primary,
                  inactiveColor: Colors.grey.shade300,
                  values: controller.returnRange.value,
                  min: 0, // Customize your minimum possible return
                  max: 100, // Customize your maximum possible return
                  divisions: 100, // Allows stepping by 1%
                  labels: RangeLabels(
                    '${controller.returnRange.value.start.round()}%',
                    '${controller.returnRange.value.end.round()}%',
                  ),
                  onChanged: (RangeValues values) {
                    controller.setReturnRange(values);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Min: ${controller.returnRange.value.start.round()}%',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Text(
                        'Max: ${controller.returnRange.value.end.round()}%',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
