import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

import '../../../../core/utils/constant/text_style.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────────
class _T {
  static const surface = Colors.white;
  static const surface2 = Color(0xFFF0F1F7);
  static const primary = Ucolors.secondary;
  static const primaryBg = Color(0xFFF0EFFF);
  static const primaryBdr = Ucolors.secondary;
  // static const primaryBdr = Color(0xFFB8B4FF);
  static const text1 = Color(0xFF14142B);
  static const text2 = Color(0xFF4E4B66);
  static const text3 = Color(0xFF9898A8);
  static const border = Color(0xFFE8E8F0);
  static const success = Color(0xFF00C896);
  static const successBg = Color(0xFFE6FAF5);
  static const warning = Color(0xFFFFAB4C);
  static const warningBg = Color(0xFFFFF4E6);
  static const danger = Color(0xFFFF6B6B);
  static const dangerBg = Color(0xFFFFEEEE);
}

// ─── Main Filter Page ─────────────────────────────────────────────────────────
class Filterpage extends StatefulWidget {
  const Filterpage({super.key});

  @override
  State<Filterpage> createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage>
    with SingleTickerProviderStateMixin {
  final FundhouseController controller = Get.find();

  late TabController _tabController;
  final List<String> _tabs = ['Categories', 'Risk', 'Fund House', 'Returns'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _countForTab(int i) {
    switch (i) {
      case 0:
        return controller.selectedSchemeTypes.length +
            (controller.indexFundOnly.value ? 1 : 0);
      case 1:
        return controller.selectedRisks.length;
      case 2:
        return controller.selectedAmcIds.length;
      case 3:
        return controller.isReturnRangeActive.value ? 1 : 0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        final params = controller.buildParam();
        if (Get.isRegistered<MutualFundController>()) {
          Get.find<MutualFundController>().syncFilterPageParams(params);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CategoriesPanel(),
                      RiskPanel(),
                      FundHousePanel(),
                      ReturnRangePanel(),
                    ],
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final total = controller.activeFilterCount;
      return Container(
        color: _T.surface,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(result: controller.buildParam()),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _T.surface2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _T.border),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 15,
                  color: _T.text2,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Title + badge
            Expanded(
              child: Row(
                children: [
                  const Text(
                    'Smart Filters',
                    style: TextStyle(fontFamily: FontFamily.medium,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _T.text1,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (total > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: _T.primary,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$total',
                        style: const TextStyle(fontFamily: FontFamily.medium,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Clear all
            GestureDetector(
              onTap: () => controller.clearAllFilters(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: total > 0 ? _T.primaryBg : _T.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: total > 0 ? _T.primaryBdr : _T.border,
                  ),
                ),
                child: Text(
                  'Clear all',
                  style: TextStyle(fontFamily: FontFamily.medium,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: total > 0 ? _T.primary : _T.text3,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabBar() {
    return Container(
      color: _T.surface,
      child: Column(
        children: [
          const Divider(height: 0, color: _T.border),
          SizedBox(
            height: 52,
            child:
                //  Obx(
                //   () =>
                ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isActive = _tabController.index == i;
                    final count = _countForTab(i);
                    return GestureDetector(
                      onTap: () => _tabController.animateTo(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isActive ? _T.primary : _T.surface2,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? _T.primary : _T.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _tabs[i],
                              style: TextStyle(fontFamily: FontFamily.medium,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isActive ? Colors.white : _T.text2,
                              ),
                            ),
                            if (count > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white.withValues(alpha:0.25)
                                      : _T.primary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$count',
                                  style: const TextStyle(fontFamily: FontFamily.medium,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                  // ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: _T.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 0, color: _T.border),
          const SizedBox(height: 12),
          Obx(() {
            final total = controller.activeFilterCount;
            return SizedBox(
              width: double.infinity,
              child: UElevatedBUtton(
                onPressed: () => Get.back(result: controller.buildParam()),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'View All',
                      style: TextStyle(fontFamily: FontFamily.medium,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (total > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha:0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'active',
                          // '$total active',
                          style: TextStyle(fontFamily: FontFamily.medium,
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              //  ElevatedButton(
              //   onPressed: () => Get.back(result: controller.buildParam()),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: _T.primary,
              //     foregroundColor: Colors.white,
              //     elevation: 0,
              //     shadowColor: Colors.transparent,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(14),
              //     ),
              //   ),
              //   child:
              //    Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Icon(Icons.tune_rounded, size: 18),
              //       const SizedBox(width: 8),
              //       const Text(
              //         'View All',
              //         style: TextStyle(fontFamily: FontFamily.medium,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w600,
              //           letterSpacing: -0.2,
              //         ),
              //       ),
              //       if (total > 0) ...[
              //         const SizedBox(width: 8),
              //         Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 8,
              //             vertical: 3,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.white.withValues(alpha:0.2),
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           child: Text(
              //             '$total active',
              //             style: const TextStyle(fontFamily: FontFamily.medium,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ],
              //   ),
              // ),
            );
          }),
          // const SizedBox(height: 6),
        ],
      ),
    );
  }
}

// ─── Categories Panel ─────────────────────────────────────────────────────────
class CategoriesPanel extends StatelessWidget {
  CategoriesPanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Index Fund toggle card
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _T.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _T.primaryBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.show_chart_rounded,
                    size: 17,
                    color: _T.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Index Funds Only',
                        style: TextStyle(fontFamily: FontFamily.medium,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _T.text1,
                        ),
                      ),
                      Text(
                        'Passively managed, tracks an index',
                        style: TextStyle(fontFamily: FontFamily.medium,fontSize: 11, color: _T.text3),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Switch.adaptive(
                    // inactiveThumbColor: Colors.white,
                    value: controller.indexFundOnly.value,
                    onChanged: (v) => controller.toggleIndexFund(v),
                    activeColor: _T.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Category list
        Expanded(
          child: Obx(() {
            if (controller.categoryList.isEmpty ||
                controller.categoryList.first.categories.isEmpty) {
              return const Center(
                child: Text(
                  'No categories available',
                  style: TextStyle(fontFamily: FontFamily.medium,color: _T.text3),
                ),
              );
            }

            final rawList = controller.categoryList.first.categories;
            final grouped = _groupCategories(rawList);
            final sortedEntries = grouped.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: sortedEntries.map((entry) {
                final subs = entry.value..sort();
                return _ExpandGroup(
                  controller: controller,
                  groupName: entry.key,
                  subItems: subs,
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }

  Map<String, List<String>> _groupCategories(List<String> rawList) {
    final Map<String, List<String>> groups = {};
    for (var item in rawList) {
      String key = 'Others';
      if (item.startsWith('Equity:'))
        key = 'Equity';
      else if (item.startsWith('Debt:'))
        key = 'Debt';
      else if (item.startsWith('Hybrid:'))
        key = 'Hybrid';
      else if (item.contains('Gold') || item.contains('Silver'))
        key = 'Commodities';
      else if (item.startsWith('Fund of Funds'))
        key = 'Fund of Funds';
      groups.putIfAbsent(key, () => []).add(item);
    }
    return groups;
  }
}

// Stateful expand group — purely visual, all logic stays in controller
class _ExpandGroup extends StatefulWidget {
  final FundhouseController controller;
  final String groupName;
  final List<String> subItems;
  const _ExpandGroup({
    required this.controller,
    required this.groupName,
    required this.subItems,
  });

  @override
  State<_ExpandGroup> createState() => _ExpandGroupState();
}

class _ExpandGroupState extends State<_ExpandGroup>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _anim;
  late final Animation<double> _expand, _rotate;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _expand = CurvedAnimation(parent: _anim, curve: Curves.easeInOutCubic);
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(_expand);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _anim.forward() : _anim.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Obx(() {
        final allSelected = widget.subItems.every(
          (item) => widget.controller.selectedSchemeTypes.contains(item),
        );

        return Container(
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.border),
          ),
          child: Column(
            children: [
              // Header
              InkWell(
                onTap: _toggle,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
                  child: Row(
                    children: [
                      // Group checkbox — calls existing controller method
                      GestureDetector(
                        onTap: () => widget.controller.toggleCategoryGroup(
                          widget.groupName,
                          widget.subItems,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: allSelected
                                ? _T.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: allSelected ? _T.primary : _T.text3,
                              width: 1.5,
                            ),
                          ),
                          child: allSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 13,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.groupName,
                          style: const TextStyle(fontFamily: FontFamily.medium,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _T.text1,
                          ),
                        ),
                      ),
                      RotationTransition(
                        turns: _rotate,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _T.text3,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable children
              SizeTransition(
                sizeFactor: _expand,
                child: Column(
                  children: [
                    const Divider(height: 0, color: _T.border),
                    ...widget.subItems.map((fullItem) {
                      String display = fullItem.split(':').last.trim();
                      if (display.contains('-')) {
                        display = display
                            .substring(display.indexOf('-') + 1)
                            .trim();
                      }
                      final isLast = fullItem == widget.subItems.last;
                      final isSelected = widget.controller.selectedSchemeTypes
                          .contains(fullItem);

                      return Column(
                        children: [
                          InkWell(
                            onTap: () =>
                                widget.controller.toggleSubCategory(fullItem),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                44,
                                11,
                                14,
                                11,
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _T.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isSelected
                                            ? _T.primary
                                            : _T.text3,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 11,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      display,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: FontFamily.medium,
                                        fontSize: 13,
                                        color: isSelected ? _T.text1 : _T.text2,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!isLast)
                            const Divider(
                              height: 0,
                              indent: 44,
                              color: _T.border,
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Risk Panel ───────────────────────────────────────────────────────────────
class RiskPanel extends StatelessWidget {
  RiskPanel({super.key});
  final FundhouseController controller = Get.find();

  static const _risks = [
    ('low', 'Low', _T.success, _T.successBg),
    ('low to moderate', 'Low to Moderate', _T.success, _T.successBg),
    ('moderate', 'Moderate', _T.warning, _T.warningBg),
    ('moderately high', 'Moderately High', _T.warning, _T.warningBg),
    ('high', 'High', _T.danger, _T.dangerBg),
    ('very high', 'Very High', _T.danger, _T.dangerBg),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionLabel('Select risk levels'),
        const SizedBox(height: 10),

        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _risks.map((r) {
              final isSelected = controller.selectedRisks.contains(r.$1);
              return GestureDetector(
                onTap: () => controller.toggleRisk(r.$2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? r.$4 : _T.surface2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? r.$3 : _T.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? r.$3 : _T.text3,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        r.$2,
                        style: TextStyle(fontFamily: FontFamily.medium,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? r.$3 : _T.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),
        _SectionLabel('Risk spectrum'),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const Row(
                  children: [
                    _SpectrumBar(color: Color(0xFF00C896), flex: 1),
                    _SpectrumBar(color: Color(0xFF7ED957), flex: 1),
                    _SpectrumBar(color: Color(0xFFFFAB4C), flex: 1),
                    _SpectrumBar(color: Color(0xFFFF7A47), flex: 1),
                    _SpectrumBar(color: Color(0xFFFF6B6B), flex: 1),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Low', style: TextStyle(fontFamily: FontFamily.medium,fontSize: 11, color: _T.text3)),
                  Text(
                    'Very High',
                    style: TextStyle(fontFamily: FontFamily.medium,fontSize: 11, color: _T.text3),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Select multiple risk levels. Funds are categorized per SEBI guidelines.',
                style: TextStyle(fontFamily: FontFamily.medium,fontSize: 12, color: _T.text2, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpectrumBar extends StatelessWidget {
  final Color color;
  final int flex;
  const _SpectrumBar({required this.color, required this.flex});

  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Container(height: 8, color: color),
  );
}

// ─── Fund House Panel ─────────────────────────────────────────────────────────
class FundHousePanel extends StatelessWidget {
  FundHousePanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search field — calls controller.searchFundHouse exactly as before
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: TextField(
            onChanged: controller.searchFundHouse,
            style: const TextStyle(fontFamily: FontFamily.medium,fontSize: 14, color: _T.text1),
            decoration: InputDecoration(
              hintText: 'Search fund house...',
              hintStyle: const TextStyle(fontFamily: FontFamily.medium,fontSize: 14, color: _T.text3),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: _T.text3,
                size: 20,
              ),
              filled: true,
              fillColor: _T.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _T.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _T.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _T.primary, width: 1.5),
              ),
            ),
          ),
        ),

        // List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: _T.primary),
              );
            }
            if (controller.filteredFundlist.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 40, color: _T.text3),
                    SizedBox(height: 8),
                    Text(
                      'No fund houses found',
                      style: TextStyle(fontFamily: FontFamily.medium,fontSize: 14, color: _T.text3),
                    ),
                  ],
                ),
              );
            }

            return Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: _T.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _T.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ListView.separated(
                  key: const PageStorageKey('fund_house_list'),
                  itemCount: controller.filteredFundlist.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 0, color: _T.border),
                  itemBuilder: (_, index) {
                    final e = controller.filteredFundlist[index];
                    return Obx(() {
                      final bool isSelected = controller.isAmcSelected(e.id);
                      return InkWell(
                        onTap: () => controller.toggleSelection(e.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          color: isSelected ? _T.primaryBg : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              // Avatar initials
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _T.surface2,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),

                                  child: CustomCachedImage(
                                    imageUrl: e.amcLogoURl,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  e.amcName.toString(),
                                  style: TextStyle(fontFamily: FontFamily.medium,
                                    fontSize: 13,
                                    color: isSelected ? _T.text1 : _T.text2,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              // Checkbox
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _T.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected ? _T.primary : _T.text3,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 13,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─── Return Range Panel ───────────────────────────────────────────────────────
class ReturnRangePanel extends StatelessWidget {
  ReturnRangePanel({super.key});
  final FundhouseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Time horizon chips
        _SectionLabel('Time Horizon'),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            children: [1, 3, 5, 10].map((year) {
              final isSelected =
                  controller.selectedReturnFilterYear.value == year;
              return GestureDetector(
                onTap: () => controller.setFilterReturnYear(year),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _T.primary : _T.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? _T.primary : _T.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    '${year}Y',
                    style: TextStyle(fontFamily: FontFamily.medium,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : _T.text2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),
        _SectionLabel('Returns Range (%)'),
        const SizedBox(height: 10),

        // Slider card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.border),
          ),
          child: Column(
            children: [
              // Header row
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Expected Returns',
                      style: TextStyle(fontFamily: FontFamily.medium,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _T.text1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _T.primaryBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _T.primaryBdr),
                      ),
                      child: Text(
                        '${controller.returnRange.value.start.round()}% – ${controller.returnRange.value.end.round()}%',
                        style: const TextStyle(fontFamily: FontFamily.medium,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _T.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Range Slider — calls controller.updateRangeFromSlider exactly
              Obx(
                () => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _T.primary,
                    inactiveTrackColor: _T.surface2,
                    thumbColor: Colors.white,
                    overlayColor: _T.primary.withValues(alpha:0.12),
                    trackHeight: 4,
                    // thumbShape: _CustomThumb(),
                  ),
                  child: RangeSlider(
                    values: controller.returnRange.value,
                    min: 0,
                    max: 300,
                    divisions: 300,
                    labels: RangeLabels(
                      '${controller.returnRange.value.start.round()}%',
                      '${controller.returnRange.value.end.round()}%',
                    ),
                    onChanged: (values) =>
                        controller.updateRangeFromSlider(values),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Text inputs — use controller's TextEditingControllers exactly
              Row(
                children: [
                  Expanded(
                    child: _MiniInput(
                      label: 'Min %',
                      controller: controller.minReturnController,
                      onChanged: (_) =>
                          controller.updateSliderWithoutTextReset(),
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                        controller.formatAndApplyText();
                      },
                      onSubmitted: (_) => controller.formatAndApplyText(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'to',
                      style: TextStyle(fontFamily: FontFamily.medium,fontSize: 13, color: _T.text3),
                    ),
                  ),
                  Expanded(
                    child: _MiniInput(
                      label: 'Max %',
                      controller: controller.maxReturnController,
                      onChanged: (_) =>
                          controller.updateSliderWithoutTextReset(),
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                        controller.formatAndApplyText();
                      },
                      onSubmitted: (_) => controller.formatAndApplyText(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Tip: Enter values or drag the slider',
                  style: TextStyle(fontFamily: FontFamily.medium,fontSize: 10, color: _T.text3),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Reset card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: _T.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _T.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reset to defaults',
                style: TextStyle(fontFamily: FontFamily.medium,fontSize: 13, color: _T.text2),
              ),
              GestureDetector(
                onTap: () {
                  controller.returnRange.value = const RangeValues(0, 100);
                  controller.isReturnRangeActive.value = false;
                  controller.minReturnController.text = '0';
                  controller.maxReturnController.text = '300';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _T.primaryBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _T.primaryBdr),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontFamily: FontFamily.medium,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _T.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _T.surface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Returns shown are CAGR (Compounded Annual Growth Rate) for the selected time horizon.',
            style: TextStyle(fontFamily: FontFamily.medium,fontSize: 12, color: _T.text2, height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Shared Small Widgets ─────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: const TextStyle(fontFamily: FontFamily.medium,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: _T.text3,
      letterSpacing: 0.8,
    ),
  );
}

class _MiniInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;

  const _MiniInput({
    required this.label,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    style: const TextStyle(fontFamily: FontFamily.medium,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: _T.text1,
    ),
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    onTapOutside: onTapOutside,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: FontFamily.medium,fontSize: 12, color: _T.text3),
      filled: true,
      fillColor: _T.surface2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _T.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _T.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _T.primary, width: 1.5),
      ),
    ),
  );
}

class _CustomThumb extends RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    context.canvas
      ..drawCircle(
        center,
        10,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      )
      ..drawCircle(
        center,
        10,
        Paint()
          ..color = _T.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
// import 'package:my_sip/common/widget/button/elevated_button.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/features/explore/presentation/controller/fundhouse_controller.dart';
// import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

// import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

// class Filterpage extends StatefulWidget {
//   const Filterpage({super.key});

//   @override
//   State<Filterpage> createState() => _FilterpageState();
// }

// class _FilterpageState extends State<Filterpage> {
//   final FundhouseController controller = Get.find();

//   int selectedMenuIndex = 0;

//   final List<String> leftMenu = ['Categories', 'Risk', 'Fund House', 'Returns'];

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true, // Allow natural back navigation
//       onPopInvoked: (bool didPop) {
//         // 2. Grab the current selected checkboxes/filters
//         final params = controller.buildParam();

//         // 3. Send them to MutualFundController to update the main list
//         if (Get.isRegistered<MutualFundController>()) {
//           Get.find<MutualFundController>().syncFilterPageParams(params);
//         }
//       },

//       child: Scaffold(
//         appBar: CustomAppBarNormal(
//           title: 'Filters',
//           actionsPadding: 15,
//           action: [
//             Obx(
//               () => InkWell(
//                 onTap: () => controller.clearAllFilters(),
//                 child: Text(
//                   'Clear all',
//                   style: UTextStyles.caption.copyWith(
//                     color: controller.isFilterActive
//                         ? Ucolors.primary
//                         : Colors.grey,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//           bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 0),
//           ),
//         ),
//         body: Row(
//           children: [
//             /// LEFT MENU - Refactored to show active selection counts
//             Container(
//               width: 130,
//               decoration: const BoxDecoration(
//                 border: Border(right: BorderSide(color: Colors.black12)),
//               ),
//               child: ListView.separated(
//                 separatorBuilder: (context, index) =>
//                     DashedLine(color: Ucolors.borderColor, dashSpace: 0),
//                 itemCount: leftMenu.length,
//                 itemBuilder: (context, index) {
//                   return Obx(() {
//                     final isSelected = selectedMenuIndex == index;

//                     // Calculate count based on controller lists
//                     int activeCount = 0;
//                     if (index == 0) {
//                       activeCount = controller.selectedSchemeTypes.length;
//                     }
//                     if (index == 1) {
//                       activeCount = controller.selectedRisks.length;
//                     }
//                     // if (index == 2)
//                     //   activeCount = controller.selectedRating.value != null
//                     //       ? 1
//                     //       : 0;
//                     if (index == 2) {
//                       activeCount = controller.selectedAmcIds.length;
//                     }
//                     if (index == 3)
//                       activeCount = controller.isReturnRangeActive.value
//                           ? 1
//                           : 0;

//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectedMenuIndex = index;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 18,
//                           horizontal: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.transparent : Colors.white,
//                           border: Border(
//                             left: BorderSide(
//                               color: isSelected
//                                   ? Ucolors.primary
//                                   : Colors.transparent,
//                               width: 4,
//                             ),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 leftMenu[index],
//                                 style: TextStyle(fontFamily: FontFamily.medium,
//                                   fontSize: 14,
//                                   color: isSelected
//                                       ? Ucolors.primary
//                                       : const Color(0xff4C4B50),
//                                   fontWeight: isSelected
//                                       ? FontWeight.w600
//                                       : FontWeight.normal,
//                                 ),
//                               ),
//                             ),
//                             if (activeCount > 0)
//                               CircleAvatar(
//                                 radius: 9,
//                                 backgroundColor: Ucolors.primary,
//                                 child: Text(
//                                   '$activeCount',
//                                   style: const TextStyle(fontFamily: FontFamily.medium,
//                                     fontSize: 10,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   });
//                 },
//               ),
//             ),

//             /// RIGHT PANEL
//             Expanded(child: _buildRightPanel()),
//           ],
//         ),
//         bottomNavigationBar: SafeArea(
//           top: false,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: UElevatedBUtton(
//               onPressed: () => Get.back(result: controller.buildParam()),
//               child: Center(
//                 child: Text(
//                   // 'View All ${controller.selectedFundCount}',
//                   'View All',
//                   style: TextStyle(fontFamily: FontFamily.medium,color: Ucolors.light),
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
//       // case 2:
//       // return RatingsPanel();
//       case 2:
//         return FundHousePanel();
//       case 3:
//         return ReturnRangePanel();
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
//               children: [
//                 const Text(
//                   'Index Funds only',
//                   style: TextStyle(fontFamily: FontFamily.medium,fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//                 Obx(
//                   () => Switch(
//                     activeColor: Ucolors.primary,
//                     value: controller.indexFundOnly.value,
//                     onChanged: (value) => controller.toggleIndexFund(value),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // --- Dynamic Multi-Select Categories List ---
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
//               children: () {
//                 // 1. Convert map entries to a list
//                 final sortedEntries = groupedData.entries.toList();

//                 // 2. Sort the list alphabetically based on the Category Name (Key)
//                 sortedEntries.sort((a, b) => a.key.compareTo(b.key));

//                 // 3. Map the sorted list to your expansion tiles
//                 return sortedEntries.map((entry) {
//                   // Optional: If you also want sub-categories sorted alphabetically:
//                   final List<String> subCategories = entry.value..sort();

//                   return _expandTile(entry.key, subCategories);
//                 }).toList();
//               }(),
//             );
//           }),
//         ),
//       ],
//     );
//   }

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
//       // Check if all sub-items in this group are selected
//       bool allSelected = subItems.every(
//         (item) => controller.selectedSchemeTypes.contains(item),
//       );

//       return Column(
//         children: [
//           ExpansionTile(
//             tilePadding: EdgeInsets.zero,
//             childrenPadding: const EdgeInsets.only(left: 10),
//             visualDensity: VisualDensity.compact,
//             shape: const Border(),
//             title: Row(
//               children: [
//                 Checkbox(
//                   activeColor: Ucolors.primary,
//                   visualDensity: VisualDensity.compact,
//                   value: allSelected,
//                   onChanged: (val) {
//                     controller.toggleCategoryGroup(groupName, subItems);
//                   },
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   groupName,
//                   style: const TextStyle(fontFamily: FontFamily.medium,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//             children: subItems.map((fullItemString) {
//               String displayName = fullItemString.split(':').last.trim();
//               if (displayName.contains('-')) {
//                 displayName = displayName
//                     .substring(displayName.indexOf('-') + 1)
//                     .trim();
//               }
//               final isSelected = controller.selectedSchemeTypes.contains(
//                 fullItemString,
//               );
//               return Column(
//                 children: [
//                   CheckboxListTile(
//                     contentPadding: const EdgeInsets.only(left: 10, right: 12),
//                     dense: true,
//                     controlAffinity: ListTileControlAffinity.leading,
//                     activeColor: Ucolors.primary,
//                     title: Text(
//                       displayName,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(fontFamily: FontFamily.medium,
//                         fontSize: 12,
//                         color: isSelected ? Colors.blue : null,
//                       ),
//                     ),
//                     // value: controller.selectedSchemeTypes.contains(fullItemString),
//                     value: isSelected,
//                     onChanged: (val) {
//                       controller.toggleSubCategory(fullItemString);
//                     },
//                   ),
//                   const Divider(
//                     height: 1,
//                     thickness: 0.5,
//                     indent: 48,
//                     color: Colors.grey,
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//           DashedLine(color: Colors.grey.shade200, dashSpace: 0),
//         ],
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
//       'Low to Moderate',
//       'Moderate',
//       'Moderately High',
//       'High',
//       'Very High',
//     ];

//     return Obx(
//       () => ListView(
//         padding: const EdgeInsets.only(left: 16),
//         children: risks.map((risk) {
//           final key = risk.toLowerCase();
//           final bool isSelected = controller.selectedRisks.contains(key);
//           return CheckboxListTile(
//             dense: true,
//             activeColor: Ucolors.primary,
//             // value: controller.selectedRisks.contains(key),
//             value: isSelected,
//             onChanged: (v) => controller.toggleRisk(risk),
//             title: Text(
//               risk,
//               style: TextStyle(fontFamily: FontFamily.medium,color: isSelected ? Ucolors.primary : null),
//             ),
//             controlAffinity: ListTileControlAffinity.leading,
//             shape: const Border(
//               bottom: BorderSide(color: Ucolors.borderColor, width: 0.5),
//             ),
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
//                 value: e.value,
//                 groupValue: controller.selectedRating.value,
//                 onChanged: (value) => controller.toggleRating(value!),
//                 title: Text(e.key),
//                 activeColor: Ucolors.primary,
//                 shape: const Border(
//                   bottom: BorderSide(color: Ucolors.borderColor),
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }



// class FundHousePanel extends StatelessWidget {
//   FundHousePanel({super.key});
//   final FundhouseController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: TextField(
//             onChanged: controller.searchFundHouse,
//             decoration: InputDecoration(
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Ucolors.primary),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               hintText: 'Search fund house',
//               prefixIcon: const Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Obx(() {
//             if (controller.isLoading.value) {
//               return Center(
//                 child: CircularProgressIndicator(color: Ucolors.primary),
//               );
//             }
//             if (controller.filteredFundlist.isEmpty) {
//               return const Center(child: Text("No fund houses found"));
//             }

//             return ListView.builder(
//               // padding: EdgeInsets.only(left: 16),
//               key: const PageStorageKey('fund_house_list'),
//               itemCount: controller.filteredFundlist.length,
//               itemBuilder: (context, index) {
//                 final e = controller.filteredFundlist[index];

//                 // CRITICAL: Wrap the individual item in Obx
//                 // This ensures this specific tile rebuilds when toggleSelection is called
//                 return Obx(() {
//                   final bool isSelected = controller.isAmcSelected(e.id);

//                   return CheckboxListTile(
//                     shape: const Border(
//                       bottom: BorderSide(
//                         color: Ucolors.borderColor,
//                         width: 0.5,
//                       ),
//                     ),

//                     key: ValueKey(e.id),
//                     activeColor: Ucolors.primary,
//                     controlAffinity: ListTileControlAffinity.leading,
//                     value: isSelected,
//                     onChanged: (bool? value) {
//                       controller.toggleSelection(e.id);
//                     },

//                     title: Text(
//                       e.amcName.toString(),
//                       style: TextStyle(fontFamily: FontFamily.medium,
//                         fontSize: 12,
//                         color: isSelected ? Ucolors.primary : Colors.black,
//                         fontWeight: isSelected
//                             ? FontWeight.w600
//                             : FontWeight.normal,
//                       ),
//                     ),
//                   );
//                 });
//               },
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

// class ReturnRangePanel extends StatelessWidget {
//   ReturnRangePanel({super.key});
//   final FundhouseController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --- Year Selection ---
//           const Text(
//             "Time Horizon",
//             style: TextStyle(fontFamily: FontFamily.medium,fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Obx(
//             () => Wrap(
//               spacing: 8,
//               children: [1, 3, 5, 10].map((year) {
//                 final isSelected =
//                     controller.selectedReturnFilterYear.value == year;
//                 return ChoiceChip(
//                   label: Text("${year}Y"),
//                   selected: isSelected,
//                   onSelected: (_) => controller.setFilterReturnYear(year),
//                   selectedColor: Ucolors.primary.withValues(alpha:0.2),
//                   labelStyle: TextStyle(fontFamily: FontFamily.medium,
//                     color: isSelected ? Ucolors.primary : Colors.black,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),

//           const SizedBox(height: 25),
//           const Text(
//             "Returns Range (%)",
//             style: TextStyle(fontFamily: FontFamily.medium,fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),

//           // --- Manual Text Input ---
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: controller.minReturnController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Min',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                   // onSubmitted: (_) => controller.updateRangeFromText(),
//                   // onChanged: (_) => controller.updateRangeFromText(),
//                   onChanged: (_) => controller.updateSliderWithoutTextReset(),
//                   onTapOutside: (_) {
//                     FocusScope.of(context).unfocus();
//                     controller.formatAndApplyText();
//                   },
//                   onSubmitted: (_) => controller.formatAndApplyText(),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: Text("to"),
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: controller.maxReturnController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Max',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//                   ),

//                   // onSubmitted: (_) => controller.updateRangeFromText(),
//                   // onChanged: (_) => controller.updateRangeFromText(),
//                   onChanged: (_) => controller.updateSliderWithoutTextReset(),
//                   onTapOutside: (_) {
//                     FocusScope.of(context).unfocus();
//                     controller.formatAndApplyText();
//                   },
//                   onSubmitted: (_) => controller.formatAndApplyText(),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 30),

//           // --- Range Slider ---
//           Obx(
//             () => RangeSlider(
//               values: controller.returnRange.value,
//               min: 0,
//               max: 100,
//               divisions: 100,
//               activeColor: Ucolors.primary,
//               labels: RangeLabels(
//                 "${controller.returnRange.value.start.round()}%",
//                 "${controller.returnRange.value.end.round()}%",
//               ),
//               onChanged: (values) => controller.updateRangeFromSlider(values),
//             ),
//           ),

//           const SizedBox(height: 10),
//           const Center(
//             child: Text(
//               "Tip: Enter values or drag the slider",
//               style: TextStyle(fontFamily: FontFamily.medium,fontSize: 10, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
