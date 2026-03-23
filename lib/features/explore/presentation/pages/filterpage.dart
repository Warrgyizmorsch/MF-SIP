// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// // import 'package:my_sip/common/widget/button/elevated_button.dart';
// // import 'package:my_sip/core/utils/constant/colors.dart';
// // import 'package:my_sip/core/utils/constant/text_style.dart';
// // import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
// // import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

// // import '../../../fund_details/presentation/pages/fund_deatails.dart';

// // class Filterpage extends StatefulWidget {
// //   const Filterpage({super.key});

// //   @override
// //   State<Filterpage> createState() => _FilterpageState();
// // }

// // class _FilterpageState extends State<Filterpage> {
// //   final FundhouseController controller = Get.find();
// //   final MutualFundController mutualFundController = Get.find();

// //   int selectedMenuIndex = 0;

// //   final List<String> leftMenu = [
// //     // 'Sort by',
// //     'Categories',
// //     'Risk',
// //     'Ratings',
// //     'Fund House',
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBarNormal(
// //         title: 'Filters',
// //         actionsPadding: 15,
// //         action: [
// //           Text(
// //             'Clear all',
// //             style: UTextStyles.caption.copyWith(
// //               decoration: TextDecoration.underline,
// //             ),
// //           ),
// //         ],
// //         bottom: const PreferredSize(
// //           preferredSize: Size.fromHeight(1),
// //           child: Divider(height: 0),
// //         ),
// //       ),
// //       body: Row(
// //         children: [
// //           /// LEFT MENU
// //           Container(
// //             width: 130,
// //             decoration: const BoxDecoration(
// //               border: Border(right: BorderSide(color: Colors.black12)),
// //             ),
// //             child: ListView.separated(
// //               separatorBuilder: (context, index) =>
// //                   DashedLine(color: Ucolors.borderColor, dashSpace: 0),
// //               itemCount: leftMenu.length,
// //               itemBuilder: (context, index) {
// //                 final isSelected = selectedMenuIndex == index;

// //                 return InkWell(
// //                   onTap: () {
// //                     setState(() {
// //                       selectedMenuIndex = index;
// //                     });
// //                   },
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       vertical: 18,
// //                       horizontal: 12,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: isSelected
// //                           // ? const Color(0xFFE8F5F0)
// //                           ? Colors.transparent
// //                           : Colors.white,
// //                       border: Border(
// //                         left: BorderSide(
// //                           color: isSelected
// //                               ? Ucolors.primary
// //                               : Colors.transparent,
// //                           width: 4,
// //                         ),
// //                       ),
// //                     ),
// //                     child: Text(
// //                       leftMenu[index],
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: isSelected
// //                             ? Ucolors.primary
// //                             : const Color(0xff4C4B50),
// //                         fontWeight: isSelected
// //                             ? FontWeight.w600
// //                             : FontWeight.normal,
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),

// //           /// RIGHT PANEL
// //           Expanded(child: _buildRightPanel()),
// //         ],
// //       ),
// //       bottomNavigationBar: SafeArea(
// //         top: false,

// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Obx(
// //             () => UElevatedBUtton(
// //               // onPressed:  () => Get.back(
// //               //   result: controller.selectedAmcIds.toList(),
// //               //   // result: {
// //               //   //   'amc_id': controller.selectedAmcIds.toList(),
// //               //   //   'scheme_type': controller.selectedSchemeTyep.toList(),w
// //               //   // },
// //               // ),
// //               // onPressed: controller.selectedFundCount.value == 0
// //               //     ? null
// //               //     : () => Get.back(result: controller.buildParam()),
// //               onPressed: () => Get.back(result: controller.buildParam()),
// //               child: Center(
// //                 child: Text(
// //                   'View All ${controller.selectedFundCount}',
// //                   style: TextStyle(color: Ucolors.light),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildRightPanel() {
// //     switch (selectedMenuIndex) {
// //       // case 0:
// //       //   return SortByPanel();
// //       case 0:
// //         return CategoriesPanel();
// //       case 1:
// //         return RiskPanel();
// //       case 2:
// //         return RatingsPanel();
// //       case 3:
// //         return FundHousePanel();
// //       default:
// //         return const SizedBox();
// //     }
// //   }
// // }

// // class SortByPanel extends StatelessWidget {
// //   SortByPanel({super.key});
// //   final FundhouseController controller = Get.find();

// //   @override
// //   Widget build(BuildContext context) {
// //     final Map<String, String> options = {
// //       'Popularity': 'popularity',
// //       '1Y Returns': '1y',
// //       '3Y Returns': '3y',
// //       '5Y Returns': '5y',
// //       'Rating': 'rating',
// //     };

// //     return Obx(
// //       () => ListView(
// //         padding: EdgeInsets.only(left: 16),
// //         children: options.entries
// //             .map(
// //               (e) => RadioListTile<String>(
// //                 dense: true,
// //                 isThreeLine: false,
// //                 // visualDensity: VisualDensity(horizontal: 2),
// //                 shape: Border(
// //                   top: BorderSide(color: Ucolors.borderColor, width: 0.5),
// //                   bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
// //                 ),
// //                 value: e.value,
// //                 groupValue: controller.sortBy.value,
// //                 onChanged: (v) => controller.sortBy.value = v!,

// //                 title: Text(e.key),
// //                 activeColor: Ucolors.primary,
// //               ),
// //             )
// //             .toList(),
// //       ),
// //     );
// //   }
// // }

// // class CategoriesPanel extends StatelessWidget {
// //   CategoriesPanel({super.key});

// //   final FundhouseController controller = Get.find();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         // --- Index Fund Switch (Unchanged) ---
// //         Container(
// //           padding: const EdgeInsets.all(16),
// //           child: Container(
// //             constraints: const BoxConstraints(maxWidth: 400),
// //             padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(color: Colors.grey.shade300),
// //             ),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 const Flexible(
// //                   fit: FlexFit.loose,
// //                   child: Text(
// //                     'Index Funds only',
// //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //                     maxLines: 1,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),

// //                 Transform.scale(
// //                   scale: 0.8,
// //                   alignment: Alignment.centerRight,
// //                   child: SwitchTheme(
// //                     data: SwitchThemeData(
// //                       trackColor: MaterialStateProperty.resolveWith((states) {
// //                         if (states.contains(MaterialState.selected)) {
// //                           return Ucolors.primary;
// //                         }
// //                         return const Color(0xFFE0E0E0);
// //                       }),
// //                       thumbColor: MaterialStateProperty.all(Colors.white),
// //                       trackOutlineColor: MaterialStateProperty.all(
// //                         Colors.transparent,
// //                       ),
// //                       trackOutlineWidth: MaterialStateProperty.all(0),
// //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                     ),
// //                     child: Obx(
// //                       () => Switch(
// //                         value: controller.indexFundOnly.value,
// //                         onChanged: (value) {
// //                           controller.toggleIndexFund(value);
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),

// //         // --- Dynamic Categories List ---
// //         Expanded(
// //           child: Obx(() {
// //             if (controller.categoryList.isEmpty ||
// //                 controller.categoryList.first.categories.isEmpty) {
// //               return const Center(child: Text("No categories available"));
// //             }

// //             final List<String> rawList =
// //                 controller.categoryList.first.categories;
// //             final Map<String, List<String>> groupedData = _groupCategories(
// //               rawList,
// //             );

// //             return ListView(
// //               padding: const EdgeInsets.symmetric(horizontal: 16),
// //               children: groupedData.entries.map((entry) {
// //                 return _expandTile(entry.key, entry.value);
// //               }).toList(),
// //             );
// //           }),
// //         ),
// //       ],
// //     );
// //   }

// //   // Helper to Group Data
// //   Map<String, List<String>> _groupCategories(List<String> rawList) {
// //     final Map<String, List<String>> groups = {};
// //     for (var item in rawList) {
// //       String groupKey = "Others";
// //       if (item.startsWith("Equity:"))
// //         groupKey = "Equity";
// //       else if (item.startsWith("Debt:"))
// //         groupKey = "Debt";
// //       else if (item.startsWith("Hybrid:"))
// //         groupKey = "Hybrid";
// //       else if (item.contains("Gold") || item.contains("Silver"))
// //         groupKey = "Commodities";
// //       else if (item.startsWith("Fund of Funds"))
// //         groupKey = "Fund of Funds";

// //       if (!groups.containsKey(groupKey)) groups[groupKey] = [];
// //       groups[groupKey]!.add(item);
// //     }
// //     return groups;
// //   }

// //   Widget _expandTile(String groupName, List<String> subItems) {
// //     return Obx(() {
// //       // 1. Check if the Parent Group is selected directly (e.g. "Equity")
// //       final bool isGroupSelected = controller.selectedSchemeTyep.contains(
// //         groupName,
// //       );

// //       return ExpansionTile(
// //         tilePadding: const EdgeInsets.symmetric(horizontal: 0),
// //         childrenPadding: const EdgeInsets.only(left: 12),
// //         visualDensity: VisualDensity.compact,
// //         shape: const Border(),
// //         trailing: const Icon(Icons.keyboard_arrow_down, size: 20),

// //         title: Row(
// //           children: [
// //             Checkbox(
// //               activeColor: Colors.blue, // Ucolors.primary
// //               visualDensity: VisualDensity.compact,
// //               // If group is selected, parent is checked.
// //               // Optional: You can also check parent if ALL children are selected manually.
// //               value: isGroupSelected,
// //               onChanged: (val) {
// //                 controller.toggleCategoryGroup(groupName, subItems, val);
// //               },
// //             ),
// //             const SizedBox(width: 8),
// //             Expanded(
// //               child: Text(
// //                 groupName,
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),

// //         children: subItems.map((fullItemString) {
// //           // Display Name Cleanup
// //           String displayName = fullItemString;
// //           if (displayName.contains(':'))
// //             displayName = displayName.split(':')[1].trim();

// //           if (displayName.contains('-')) {
// //             displayName = displayName
// //                 .substring(displayName.indexOf('-') + 1)
// //                 .trim();
// //           }

// //           // Check Visualization Logic:
// //           // Check this box IF:
// //           // 1. The specific item is in the list OR
// //           // 2. The Parent Group is in the list (Inherited selection)
// //           final bool isItemChecked =
// //               controller.selectedSchemeTyep.contains(fullItemString) ||
// //               isGroupSelected;

// //           return Column(
// //             children: [
// //               CheckboxListTile(
// //                 contentPadding: const EdgeInsets.only(left: 10, right: 12),
// //                 dense: true,
// //                 visualDensity: VisualDensity.compact,
// //                 controlAffinity: ListTileControlAffinity.leading,
// //                 activeColor: Colors.blue, // Ucolors.primary

// //                 title: Text(
// //                   displayName,
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis,
// //                   style: const TextStyle(fontSize: 13),
// //                 ),

// //                 value: isItemChecked,
// //                 onChanged: (val) {
// //                   controller.toggleSubCategory(
// //                     fullItemString,
// //                     groupName,
// //                     subItems,
// //                   );
// //                 },
// //               ),
// //               const Divider(
// //                 height: 1,
// //                 thickness: 0.5,
// //                 indent: 48,
// //                 color: Colors.grey,
// //               ),
// //             ],
// //           );
// //         }).toList(),
// //       );
// //     });
// //   }
// // }

// // /* class CategoriesPanel extends StatelessWidget {
// // //   CategoriesPanel({super.key});

// // //   final FundhouseController controller = Get.find();
// // //   final MutualFundController mutualFundController = Get.find();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         // ----------------------------------------
// // //         // 1. Index Funds Switch (Fixed at the top)
// // //         // ----------------------------------------
// // //         Container(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Container(
// // //             constraints: const BoxConstraints(maxWidth: 400),
// // //             padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(12),
// // //               border: Border.all(color: Colors.grey.shade300),
// // //             ),
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Flexible(
// // //                   fit: FlexFit.loose,
// // //                   child: Text(
// // //                     'Index Funds only',
// // //                     style: TextStyle(
// // //                       // UTextStyles.medium
// // //                       fontSize: 14,
// // //                       fontWeight: FontWeight.w500,
// // //                     ),
// // //                     maxLines: 1,
// // //                     overflow: TextOverflow.ellipsis,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 8),

// // //                 Transform.scale(
// // //                   scale: 0.8,
// // //                   alignment: Alignment.centerRight,
// // //                   child: SwitchTheme(
// // //                     data: SwitchThemeData(
// // //                       trackColor: MaterialStateProperty.resolveWith((states) {
// // //                         if (states.contains(MaterialState.selected)) {
// // //                           return Ucolors.primary;
// // //                         }
// // //                         return const Color(0xFFE0E0E0);
// // //                       }),
// // //                       thumbColor: MaterialStateProperty.all(Colors.white),
// // //                       trackOutlineColor: MaterialStateProperty.all(
// // //                         Colors.transparent,
// // //                       ),
// // //                       trackOutlineWidth: MaterialStateProperty.all(0),
// // //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // //                     ),
// // //                     child: Obx(
// // //                       () => Switch(
// // //                         value: controller.indexFundOnly.value,
// // //                         onChanged: (value) {
// // //                           controller.toggleIndexFund(value);
// // //                         },
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),

// // //         // ----------------------------------------
// // //         // 2. Dynamic Category Lists
// // //         // ----------------------------------------
// // //         Expanded(
// // //           child: Obx(() {
// // //             // 1. Check if data exists
// // //             if (controller.categoryList.isEmpty ||
// // //                 controller.categoryList.first.categories.isEmpty) {
// // //               return const Center(child: Text("No categories available"));
// // //             }

// // //             // 2. Get the raw list of strings from the Entity
// // //             final List<String> rawList =
// // //                 controller.categoryList.first.categories;

// // //             // 3. Group the data dynamically
// // //             final Map<String, List<String>> groupedData = _groupCategories(
// // //               rawList,
// // //             );

// // //             // 4. Build the UI
// // //             return ListView(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16),
// // //               children: groupedData.entries.map((entry) {
// // //                 return _expandTile(entry.key, entry.value, entry.key);
// // //               }).toList(),
// // //             );
// // //           }),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   // --- Helper Function to Group API Data ---
// // //   Map<String, List<String>> _groupCategories(List<String> rawList) {
// // //     final Map<String, List<String>> groups = {};

// // //     for (var item in rawList) {
// // //       String groupKey = "Others";

// // //       // Determine the group based on the string content
// // //       if (item.startsWith("Equity:")) {
// // //         groupKey = "Equity";
// // //       } else if (item.startsWith("Debt:")) {
// // //         groupKey = "Debt";
// // //       } else if (item.startsWith("Hybrid:")) {
// // //         groupKey = "Hybrid";
// // //       } else if (item.contains("Gold") || item.contains("Silver")) {
// // //         groupKey = "Commodities";
// // //       } else if (item.startsWith("Fund of Funds")) {
// // //         groupKey = "Fund of Funds";
// // //       }

// // //       if (!groups.containsKey(groupKey)) {
// // //         groups[groupKey] = [];
// // //       }
// // //       groups[groupKey]!.add(item);
// // //     }

// // //     // Optional: Sort keys so Equity/Debt appear first
// // //     // You can implement custom sorting here if needed
// // //     return groups;
// // //   }

// // //   // --- Expansion Tile Widget ---
// // //   Widget _expandTile(String title, List<String> list, String schemeType) {
// // //     // Note: schemeType is passed as the Group Name (e.g. "Equity")
// // //     // If you need to select all "Equity" via the parent checkbox, handle that in logic.

// // //     return Obx(
// // //       () => ExpansionTile(
// // //         tilePadding: const EdgeInsets.symmetric(horizontal: 0),
// // //         childrenPadding: const EdgeInsets.only(left: 12),
// // //         visualDensity: VisualDensity.compact,
// // //         trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
// // //         shape: const Border(), // Removes top/bottom borders when expanded

// // //         title: Row(
// // //           children: [
// // //             Checkbox(
// // //               activeColor: Colors.blue, // Ucolors.primary
// // //               visualDensity: VisualDensity.compact,
// // //               // Logic: Checked if ANY item in this group is selected (or implement logic for ALL)
// // //               value: list.any(
// // //                 (item) => controller.selectedSchemeTyep.contains(item),
// // //               ),
// // //               onChanged: (bool? value) {
// // //                 // Logic: Toggle ALL items in this group
// // //                 if (value == true) {
// // //                   controller.selectedSchemeTyep.addAll(list);
// // //                 } else {
// // //                   controller.selectedSchemeTyep.removeAll(list);
// // //                 }
// // //                 // Don't forget to trigger the API call or update count
// // //                 controller.fetchCount();
// // //               },
// // //             ),
// // //             const SizedBox(width: 8),
// // //             Expanded(
// // //               child: Text(
// // //                 title,
// // //                 style: const TextStyle(
// // //                   fontWeight: FontWeight.w600,
// // //                   fontSize: 14,
// // //                 ),
// // //                 maxLines: 1,
// // //                 overflow: TextOverflow.ellipsis,
// // //               ),
// // //             ),
// // //           ],
// // //         ),

// // //         children: list.map((fullItemString) {
// // //           // Clean up the name for display (e.g., "Equity: Large Cap" -> "Large Cap")
// // //           String displayName = fullItemString;
// // //           if (displayName.contains(':')) {
// // //             displayName = displayName.split(':')[1].trim();
// // //           }

// // //           return Column(
// // //             children: [
// // //               CheckboxListTile(
// // //                 contentPadding: const EdgeInsets.only(left: 10, right: 12),
// // //                 dense: true,
// // //                 visualDensity: VisualDensity.compact,
// // //                 controlAffinity: ListTileControlAffinity.leading,
// // //                 activeColor: Colors.blue, // Ucolors.primary

// // //                 title: Text(
// // //                   displayName,
// // //                   maxLines: 1,
// // //                   overflow: TextOverflow.ellipsis,
// // //                   style: const TextStyle(fontSize: 13),
// // //                 ),

// // //                 // Check if this specific string is in the selected list
// // //                 value: controller.selectedSchemeTyep.contains(fullItemString),
// // //                 onChanged: (value) {
// // //                   controller.toggleSchemeType(fullItemString);
// // //                 },
// // //               ),
// // //               const Divider(
// // //                 height: 1,
// // //                 thickness: 0.5,
// // //                 indent: 48,
// // //                 color: Colors.grey, // Ucolors.borderColor
// // //               ),
// // //             ],
// // //           );
// // //         }).toList(),
// // //       ),
// // //     );
// // //   }
// // // } */

// // /* class CategoriesPanel extends StatelessWidget {
// // //   CategoriesPanel({super.key});

// // //   bool indexFundsOnly = false;
// // //   final FundhouseController controller = Get.find();
// // //   final MutualFundController mutualFundController = Get.find();

// // //   final List<String> equity = [
// // //     "Flexi Cap",
// // //     "International",
// // //     "Large Cap",
// // //     "Mid Cap",
// // //     "Multi Cap",
// // //   ];

// // //   final List<String> debt = ["Banking PSU", "Corporate", "Floater", "Liquid"];

// // //   final List<String> hybrid = [
// // //     "Arbitrage",
// // //     "Balanced Hybrid",
// // //     "Aggressive Hyb",
// // //     "Multi Asset",
// // //   ];

// // //   final List<String> commodities = ["Gold", "Silver"];

// // //   final List<String> elssFilters = [
// // //     "Tax Saving (80C)",
// // //     "3-Year Lock-in",
// // //     "Equity Exposure",
// // //     "Long-Term Wealth",
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ListView(
// // //       padding: const EdgeInsets.all(16),
// // //       children: [
// // //         Container(
// // //           // Web: Prevents the button from becoming too wide
// // //           // Mobile: Adapts to screen width naturally
// // //           constraints: const BoxConstraints(maxWidth: 400),
// // //           padding: const EdgeInsets.fromLTRB(
// // //             16,
// // //             8,
// // //             8,
// // //             8,
// // //           ), // Adjusted padding for balance
// // //           decoration: BoxDecoration(
// // //             color: Colors.white, // Ensure background is visible
// // //             borderRadius: BorderRadius.circular(12),
// // //             border: Border.all(color: Colors.grey.shade300),
// // //           ),
// // //           child: Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             mainAxisSize:
// // //                 MainAxisSize.min, // Important: Wraps content width on Web
// // //             children: [
// // //               // 1. Use Flexible/Expanded to handle text sizing safely
// // //               Flexible(
// // //                 fit: FlexFit
// // //                     .loose, // Allows text to be its natural size, shrinks if needed
// // //                 child: Text(
// // //                   'Index Funds only',
// // //                   style: UTextStyles.medium.copyWith(
// // //                     fontSize: 14,
// // //                     fontWeight: FontWeight.w500,
// // //                   ),
// // //                   maxLines: 1,
// // //                   overflow:
// // //                       TextOverflow.ellipsis, // Safe clipping on small mobiles
// // //                 ),
// // //               ),

// // //               const SizedBox(width: 8),

// // //               // 2. Scaled Switch (Keeps it compact)
// // //               Transform.scale(
// // //                 scale: 0.8,
// // //                 alignment: Alignment.centerRight,
// // //                 child: SwitchTheme(
// // //                   data: SwitchThemeData(
// // //                     trackColor: MaterialStateProperty.resolveWith((states) {
// // //                       if (states.contains(MaterialState.selected)) {
// // //                         return Ucolors.primary;
// // //                       }
// // //                       return const Color(0xFFE0E0E0);
// // //                     }),
// // //                     thumbColor: MaterialStateProperty.all(Colors.white),
// // //                     trackOutlineColor: MaterialStateProperty.all(
// // //                       Colors.transparent,
// // //                     ),
// // //                     trackOutlineWidth: MaterialStateProperty.all(0),
// // //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // //                   ),
// // //                   child: Obx(
// // //                     () => Switch(
// // //                       value: controller.indexFundOnly.value,
// // //                       // onChanged: (v) => controller.indexFundOnly.toggle(),
// // //                       onChanged: (value) {
// // //                         controller.toggleIndexFund(value);
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         const SizedBox(height: 16),
// // //         _expandTile('Equity', equity, 'equity'),

// // //         // DashedLine(dashWidth: 0, height: 2, color: Ucolors.dark),
// // //         _expandTile('Debt', debt, 'debt'),
// // //         _expandTile('Hybrid', hybrid, 'hybrid'),
// // //         _expandTile('Commodities', commodities, 'commodities'),
// // //       ],
// // //     );
// // //   }

// // //   // Widget _expandTile(String title) {
// // //   Widget _expandTile(String title, List<String> list, String schemeType) {
// // //     return Obx(
// // //       () => ExpansionTile(
// // //         // dense: true,
// // //         tilePadding: const EdgeInsets.symmetric(horizontal: 12),
// // //         childrenPadding: const EdgeInsets.only(left: 12),
// // //         visualDensity: VisualDensity.compact,
// // //         trailing: const Icon(Icons.keyboard_arrow_down, size: 20),

// // //         title: Row(
// // //           children: [
// // //             Checkbox(
// // //               activeColor: Ucolors.primary,
// // //               // splashRadius: 6,
// // //               value: controller.selectedSchemeTyep.contains(schemeType),
// // //               onChanged: (value) {
// // //                 controller.toggleSchemeType(schemeType);
// // //               },
// // //               visualDensity: VisualDensity.compact,
// // //             ),
// // //             Expanded(
// // //               child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
// // //             ),
// // //           ],
// // //         ),

// // //         children: List.generate(
// // //           // 5
// // //           list.length,
// // //           (index) => Column(
// // //             children: [
// // //               CheckboxListTile(
// // //                 contentPadding: const EdgeInsets.only(left: 10, right: 12),
// // //                 dense: true,
// // //                 visualDensity: VisualDensity.compact,
// // //                 controlAffinity: ListTileControlAffinity.leading,
// // //                 value: false,
// // //                 onChanged: (value) {},
// // //                 title: Text(
// // //                   list[index],
// // //                   maxLines: 1,
// // //                   overflow: TextOverflow.ellipsis,
// // //                 ),
// // //               ),
// // //               const Divider(
// // //                 height: 1,
// // //                 thickness: 1,
// // //                 indent: 36,
// // //                 color: Ucolors.borderColor,
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // } */

// // class RiskPanel extends StatelessWidget {
// //   RiskPanel({super.key});
// //   final FundhouseController controller = Get.find();
// //   @override
// //   Widget build(BuildContext context) {
// //     final List<String> risks = [
// //       'Low',
// //       "Low to Moderate",
// //       'Moderately Low',
// //       'Moderate',
// //       'Moderately High',
// //       'High',
// //       'Very High',
// //     ];

// //     return Obx(
// //       () => ListView(
// //         padding: EdgeInsets.only(left: 16),
// //         // padding: EdgeInsets.only(bottom: 10),
// //         children: risks.map((risk) {
// //           final key = risk.toLowerCase().replaceAll(' ', '_');

// //           return CheckboxListTile(
// //             dense: true,
// //             activeColor: Ucolors.primary,
// //             isThreeLine: false,
// //             shape: Border(
// //               top: BorderSide(color: Ucolors.borderColor, width: 0.5),
// //               bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
// //             ),
// //             value: controller.selectedRisk.contains(key),
// //             onChanged: (_) => controller.toggleRisk(risk),
// //             title: Text(risk),
// //             controlAffinity: ListTileControlAffinity.leading,
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// // }

// // class RatingsPanel extends StatelessWidget {
// //   RatingsPanel({super.key});

// //   final FundhouseController controller = Get.find();

// //   final Map<String, int> ratings = {
// //     '5 ★': 5,
// //     '4+ ★': 4,
// //     '3+ ★': 3,
// //     '2+ ★': 2,
// //     '1+ ★': 1,
// //   };

// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(
// //       () => ListView(
// //         // padding: EdgeInsets.zero,
// //         padding: const EdgeInsets.only(left: 16),

// //         children: ratings.entries
// //             .map(
// //               (e) => RadioListTile<int>(
// //                 dense: true,
// //                 isThreeLine: false,
// //                 shape: Border(
// //                   bottom: BorderSide(
// //                     color: Ucolors.borderColor,
// //                     // strokeAlign: BorderSide.strokeAlignCenter,
// //                     // style: BorderStyle.
// //                   ),
// //                 ),
// //                 value: e.value,
// //                 groupValue: controller.selectedRating.value,
// //                 onChanged: (value) => controller.toggleRating(value!),
// //                 title: Text(e.key),
// //                 activeColor: Ucolors.primary,
// //               ),
// //             )
// //             .toList(),
// //       ),
// //     );
// //   }
// // }

// // class FundHousePanel extends StatelessWidget {
// //   FundHousePanel({super.key});

// //   final FundhouseController controller = Get.find<FundhouseController>();

// //   @override
// //   Widget build(BuildContext context) {
// //     log('${controller.fundlist.length} fundlist');

// //     return Obx(
// //       () => ListView(
// //         padding: const EdgeInsets.only(left: 16, top: 16),
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 7.0),
// //             child: TextField(
// //               onChanged: controller.searchFundHouse,
// //               decoration: InputDecoration(
// //                 focusedBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(color: Ucolors.primary),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 // contentPadding: EdgeInsets.only(right: 10),
// //                 hintText: 'Search fund house',
// //                 prefixIcon: const Icon(Icons.search),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 12),

// //           if (controller.isLoading.value)
// //             Center(child: CircularProgressIndicator(color: Ucolors.primary))
// //           else if (controller.filteredFundlist.isEmpty)
// //             const Padding(
// //               padding: EdgeInsets.all(32),
// //               child: Center(
// //                 child: Text(
// //                   "No fund houses found",
// //                   style: TextStyle(color: Colors.grey, fontSize: 15),
// //                 ),
// //               ),
// //             )
// //           else
// //             ...controller.filteredFundlist.map(
// //               (e) => CheckboxListTile(
// //                 activeColor: Ucolors.primary,
// //                 shape: Border(bottom: BorderSide(color: Ucolors.borderside)),
// //                 contentPadding: EdgeInsets.zero,
// //                 dense: true,
// //                 isThreeLine: false,
// //                 controlAffinity: ListTileControlAffinity.leading,
// //                 value: controller.selectedAmcIds.contains(e.id),
// //                 onChanged: (bool? echeck) {
// //                   controller.toggleSelection(e.id);

// //                   log(e.id.toString());
// //                 },

// //                 title: Text(e.amcName.toString()),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

// import '../../../fund_details/presentation/pages/fund_deatails.dart';

// class Filterpage extends StatefulWidget {
//   const Filterpage({super.key});

//   @override
//   State<Filterpage> createState() => _FilterpageState();
// }

// class _FilterpageState extends State<Filterpage> {
//   final FundhouseController controller = Get.find();
//   final MutualFundController mutualFundController = Get.find();

//   int selectedMenuIndex = 0;

//   final List<String> leftMenu = [
//     // 'Sort by',
//     'Categories',
//     'Risk',
//     'Ratings',
//     'Fund House',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarNormal(
//         title: 'Filters',
//         actionsPadding: 15,
//         action: [
//           Obx(
//             () => InkWell(
//               onTap: () => controller.clearAllFilters(),
//               child: Text(
//                 'Clear all',
//                 style: UTextStyles.caption.copyWith(
//                   color: controller.isFilterActive
//                       ? Ucolors.primary
//                       : Colors.grey,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ),
//         ],
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Divider(height: 0),
//         ),
//       ),
//       body: Row(
//         children: [
//           /// LEFT MENU
//           Container(
//             width: 130,
//             decoration: const BoxDecoration(
//               border: Border(right: BorderSide(color: Colors.black12)),
//             ),
//             child: ListView.separated(
//               separatorBuilder: (context, index) =>
//                   DashedLine(color: Ucolors.borderColor, dashSpace: 0),
//               itemCount: leftMenu.length,
//               itemBuilder: (context, index) {
//                 final isSelected = selectedMenuIndex == index;

//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       selectedMenuIndex = index;
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 18,
//                       horizontal: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSelected ? Colors.transparent : Colors.white,
//                       border: Border(
//                         left: BorderSide(
//                           color: isSelected
//                               ? Ucolors.primary
//                               : Colors.transparent,
//                           width: 4,
//                         ),
//                       ),
//                     ),
//                     child: Text(
//                       leftMenu[index],
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isSelected
//                             ? Ucolors.primary
//                             : const Color(0xff4C4B50),
//                         fontWeight: isSelected
//                             ? FontWeight.w600
//                             : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           /// RIGHT PANEL
//           Expanded(child: _buildRightPanel()),
//         ],
//       ),
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Obx(
//             () => UElevatedBUtton(
//               onPressed: () => Get.back(result: controller.buildParam()),
//               child: Center(
//                 child: Text(
//                   'View All ${controller.selectedFundCount}',
//                   style: TextStyle(color: Ucolors.light),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRightPanel() {
//     switch (selectedMenuIndex) {
//       case 0:
//         return CategoriesPanel();
//       case 1:
//         return RiskPanel();
//       case 2:
//         return RatingsPanel();
//       case 3:
//         return FundHousePanel();
//       default:
//         return const SizedBox();
//     }
//   }
// }

// class CategoriesPanel extends StatelessWidget {
//   CategoriesPanel({super.key});

//   final FundhouseController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // --- Index Fund Switch ---
//         Container(
//           padding: const EdgeInsets.all(16),
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Flexible(
//                   fit: FlexFit.loose,
//                   child: Text(
//                     'Index Funds only',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Transform.scale(
//                   scale: 0.8,
//                   alignment: Alignment.centerRight,
//                   child: SwitchTheme(
//                     data: SwitchThemeData(
//                       trackColor: MaterialStateProperty.resolveWith((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return Ucolors.primary;
//                         }
//                         return const Color(0xFFE0E0E0);
//                       }),
//                       thumbColor: MaterialStateProperty.all(Colors.white),
//                       trackOutlineColor: MaterialStateProperty.all(
//                         Colors.transparent,
//                       ),
//                       trackOutlineWidth: MaterialStateProperty.all(0),
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     child: Obx(
//                       () => Switch(
//                         value: controller.indexFundOnly.value,
//                         onChanged: (value) {
//                           controller.toggleIndexFund(value);
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // --- Dynamic Categories List ---
//         Expanded(
//           child: Obx(() {
//             if (controller.categoryList.isEmpty ||
//                 controller.categoryList.first.categories.isEmpty) {
//               return const Center(child: Text("No categories available"));
//             }

//             final List<String> rawList =
//                 controller.categoryList.first.categories;
//             final Map<String, List<String>> groupedData = _groupCategories(
//               rawList,
//             );

//             return ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               children: groupedData.entries.map((entry) {
//                 return _expandTile(entry.key, entry.value);
//               }).toList(),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   // Helper to Group Data
//   Map<String, List<String>> _groupCategories(List<String> rawList) {
//     final Map<String, List<String>> groups = {};
//     for (var item in rawList) {
//       String groupKey = "Others";
//       if (item.startsWith("Equity:"))
//         groupKey = "Equity";
//       else if (item.startsWith("Debt:"))
//         groupKey = "Debt";
//       else if (item.startsWith("Hybrid:"))
//         groupKey = "Hybrid";
//       else if (item.contains("Gold") || item.contains("Silver"))
//         groupKey = "Commodities";
//       else if (item.startsWith("Fund of Funds"))
//         groupKey = "Fund of Funds";

//       if (!groups.containsKey(groupKey)) groups[groupKey] = [];
//       groups[groupKey]!.add(item);
//     }
//     return groups;
//   }

//   Widget _expandTile(String groupName, List<String> subItems) {
//     return Obx(() {
//       return ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 0),
//         childrenPadding: const EdgeInsets.only(left: 10),
//         visualDensity: VisualDensity.compact,
//         shape: const Border(),
//         trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
//         title: Row(
//           children: [
//             Radio<String>(
//               activeColor: Colors.blue, // Ucolors.primary
//               visualDensity: VisualDensity.compact,
//               value: groupName,
//               groupValue: controller.selectedSchemeType.value,
//               onChanged: (val) {
//                 controller.toggleCategoryGroup(val!);
//               },
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 groupName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         children: subItems.map((fullItemString) {
//           // Display Name Cleanup
//           String displayName = fullItemString;
//           if (displayName.contains(':')) {
//             displayName = displayName.split(':')[1].trim();
//           }

//           if (displayName.contains('-')) {
//             displayName = displayName
//                 .substring(displayName.indexOf('-') + 1)
//                 .trim();
//           }

//           return Column(
//             children: [
//               RadioListTile<String>(
//                 contentPadding: const EdgeInsets.only(left: 10, right: 12),
//                 dense: true,
//                 horizontalTitleGap: 10,
//                 visualDensity: VisualDensity.compact,
//                 controlAffinity: ListTileControlAffinity.leading,
//                 activeColor: Colors.blue, // Ucolors.primary
//                 title: Text(
//                   displayName,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 13),
//                 ),
//                 value: fullItemString,
//                 groupValue: controller.selectedSchemeType.value,
//                 onChanged: (val) {
//                   if (val != null) {
//                     controller.toggleSubCategory(val);
//                   }
//                 },
//               ),
//               const Divider(
//                 height: 1,
//                 thickness: 0.5,
//                 indent: 48,
//                 color: Colors.grey,
//               ),
//             ],
//           );
//         }).toList(),
//       );
//     });
//   }
// }

// class RiskPanel extends StatelessWidget {
//   RiskPanel({super.key});
//   final FundhouseController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     final List<String> risks = [
//       'Low',
//       "Low to Moderate",
//       // 'Moderately Low',
//       'Moderate',
//       'Moderatley Risk',
//       'Moderately High',
//       'High',
//       'High Risk',
//       'Very High',
//     ];

//     return Obx(
//       () => ListView(
//         padding: const EdgeInsets.only(left: 16),
//         children: risks.map((risk) {
//           // final key = risk.toLowerCase().replaceAll(' ', '_');
//           final key = risk.toLowerCase();

//           return RadioListTile<String>(
//             dense: true,
//             activeColor: Ucolors.primary,
//             isThreeLine: false,
//             shape: const Border(
//               top: BorderSide(color: Ucolors.borderColor, width: 0.5),
//               bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
//             ),
//             value: key,
//             groupValue: controller.selectedRisk.value,
//             onChanged: (v) => controller.toggleRisk(risk),
//             title: Text(risk),
//             controlAffinity: ListTileControlAffinity.leading,
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class RatingsPanel extends StatelessWidget {
//   RatingsPanel({super.key});

//   final FundhouseController controller = Get.find();

//   final Map<String, int> ratings = {
//     '5 ★': 5,
//     '4+ ★': 4,
//     '3+ ★': 3,
//     '2+ ★': 2,
//     '1+ ★': 1,
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => ListView(
//         padding: const EdgeInsets.only(left: 16),
//         children: ratings.entries
//             .map(
//               (e) => RadioListTile<int>(
//                 dense: true,
//                 isThreeLine: false,
//                 shape: const Border(
//                   bottom: BorderSide(color: Ucolors.borderColor),
//                 ),
//                 value: e.value,
//                 groupValue: controller.selectedRating.value,
//                 onChanged: (value) => controller.toggleRating(value!),
//                 title: Text(e.key),
//                 activeColor: Ucolors.primary,
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }

// class FundHousePanel extends StatelessWidget {
//   FundHousePanel({super.key});

//   final FundhouseController controller = Get.find<FundhouseController>();

//   @override
//   Widget build(BuildContext context) {
//     log('${controller.fundlist.length} fundlist');

//     return Obx(
//       () => ListView(
//         padding: const EdgeInsets.only(left: 16, top: 16),
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 7.0),
//             child: TextField(
//               onChanged: controller.searchFundHouse,
//               decoration: InputDecoration(
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Ucolors.primary),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 hintText: 'Search fund house',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           if (controller.isLoading.value)
//             Center(child: CircularProgressIndicator(color: Ucolors.primary))
//           else if (controller.filteredFundlist.isEmpty)
//             const Padding(
//               padding: EdgeInsets.all(32),
//               child: Center(
//                 child: Text(
//                   "No fund houses found",
//                   style: TextStyle(color: Colors.grey, fontSize: 15),
//                 ),
//               ),
//             )
//           else
//             ...controller.filteredFundlist.map(
//               (e) => RadioListTile<int>(
//                 activeColor: Ucolors.primary,
//                 shape: const Border(
//                   bottom: BorderSide(color: Ucolors.borderside),
//                 ),
//                 contentPadding: EdgeInsets.zero,
//                 dense: true,
//                 isThreeLine: false,
//                 controlAffinity: ListTileControlAffinity.leading,
//                 value: e.id ?? 0,
//                 groupValue: controller.selectedAmcId.value,
//                 onChanged: (int? value) {
//                   controller.toggleSelection(e.id);
//                   log(e.id.toString());
//                 },
//                 title: Text(e.amcName.toString()),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage> {
  final FundhouseController controller = Get.find();

  int selectedMenuIndex = 0;

  final List<String> leftMenu = ['Categories', 'Risk', 'Fund House'];

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
                    if (index == 0)
                      activeCount = controller.selectedSchemeTypes.length;
                    if (index == 1)
                      activeCount = controller.selectedRisks.length;
                    // if (index == 2)
                    //   activeCount = controller.selectedRating.value != null
                    //       ? 1
                    //       : 0;
                    if (index == 2)
                      activeCount = controller.selectedAmcIds.length;

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
            child: Obx(
              () => UElevatedBUtton(
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
