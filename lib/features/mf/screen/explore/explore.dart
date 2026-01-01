import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Ucolors.borderColor,
      body: CustomScrollView(
        slivers: [
          //////----------Appbar---------------///
          SliverAppBar(
            pinned: true,

            // leadingWidth: 20,
            // expandedHeight: 200,
            flexibleSpace: CustomAppBarNormal(
              title: 'All Mutual Funds',
              backgroundColor: Ucolors.light,
            ),
          ),

          ////----------TabBar-------------///
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Ucolors.borderColor),
                      // borderRadius: BorderRadius.circular(2),
                      shape: BoxShape.circle,
                    ),
                    child: CompactIcon(icon: Icons.tune, onPressed: () {}),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 30, // controls line height
                    width: 1, // controls thickness
                    color: Ucolors.borderside,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(
                            icon: Icons.filter_list_sharp,
                            label: 'Sort by',
                            isSelected: true,
                          ),
                          _FilterChip(label: 'Equity'),
                          _FilterChip(label: 'Debt'),
                          _FilterChip(label: 'Hybrid'),
                          _FilterChip(label: 'Commodities', isSelected: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1,601 funds', style: UTextStyles.small),
                  Text('‹› 3 Year Returns', style: UTextStyles.small),
                ],
              ),
            ),
          ),

          ///  MUTUAL FUND LIST
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return const MutualFundCard();
            }, childCount: 10),
          ),
        ],
      ),
    );
  }
}

class MutualFundCard extends StatelessWidget {
  const MutualFundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                // radius: 18,
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(UImages.sbi),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nippon India Large Cap Fund - Growth Plan',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff383838),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Risk:',
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: 'Very High',
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(color: Ucolors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),

          // const SizedBox(height: 8),

          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: 'Risk:',
          //         style: Theme.of(context).textTheme.labelSmall!.copyWith(),
          //       ),
          //       TextSpan(
          //         text: 'Very High',
          //         style: Theme.of(
          //           context,
          //         ).textTheme.labelMedium!.copyWith(color: Ucolors.red),
          //       ),
          //     ],
          //   ),
          // ),

          /// Risk
          // const Text(
          //   'Risk: Very High',
          //   style: TextStyle(fontSize: 13, color: Colors.red),
          // ),
          const SizedBox(height: 5),
          // const Divider(height: 0),
          Text(
            maxLines: 1,
            'Trailing Return -------------------------------------------------------------------------------------------------------',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Ucolors.borderside,
              fontSize: 10,
              height: 0,
            ),
          ),

          const SizedBox(height: 5),

          /// Returns Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ReturnItem(title: '1W', value: '-0.15%', isNegative: true),
              _ReturnItem(title: '1Y', value: '5.20%'),
              _ReturnItem(title: '3Y', value: '18.42%'),
              _ReturnItem(title: '5Y', value: '20.89%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReturnItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isNegative;

  const _ReturnItem({
    required this.title,
    required this.value,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.labelMedium!.copyWith()),
        const SizedBox(height: 4),
        Text(
          value,

          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: isNegative ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;

  const _FilterChip({required this.label, this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Ucolors.textFormEnabled : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall!.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
