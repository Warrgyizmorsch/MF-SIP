import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class Filterpage extends StatelessWidget {
  const Filterpage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> leftMenu = [
      'Sort by',
      'Categories',
      'Risk',
      'Ratings',
      'Fund House',
    ];

    return Scaffold(
      appBar: CustomAppBarNormal(
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1),
          child: Divider(height: 0),
        ),

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
      ),
      body: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black12)),
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,

              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: Ucolors.borderside.withOpacity(0.3),
              ),

              itemCount: leftMenu.length,
              itemBuilder: (context, index) {
                // final selected = selectedMenuIndex == index;
                return InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    // color: selected ? Colors.grey.shade200 : Colors.white,
                    child: Text(
                      leftMenu[index],
                      style: TextStyle(
                        color: Color(0xff4C4B50),
                        // fontWeight: selected
                        // ? FontWeight.bold
                        // : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(child: FilterCategoryPanel()),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;

  const _CategoryItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (_) {}),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Color(0xff4C4B50)),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xff4C4B50),
            size: 14,
          ),
        ],
      ),
    );
  }
}

class FilterCategoryPanel extends StatefulWidget {
  const FilterCategoryPanel({super.key});

  @override
  State<FilterCategoryPanel> createState() => _FilterCategoryPanelState();
}

class _FilterCategoryPanelState extends State<FilterCategoryPanel> {
  bool indexFundsOnly = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Index Funds Toggle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: const Text(
                    'Index Funds only',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Flexible(
                  // fit: FlexFit.loose,
                  // flex: 0,
                  child: SwitchTheme(
                    data: SwitchThemeData(
                      trackColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFFE0E0E0);
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
                      value: indexFundsOnly,
                      onChanged: (value) {
                        setState(() {
                          indexFundsOnly = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// Categories
          _CategoryItem(title: 'Equity'),
          Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),
          _CategoryItem(title: 'Debt'),
          Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),

          _CategoryItem(title: 'Hybrid'),
          Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),

          _CategoryItem(title: 'Commodities'),
          Divider(height: 10, color: Ucolors.borderside.withOpacity(0.3)),
        ],
      ),
    );
  }
}
