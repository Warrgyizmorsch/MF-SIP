import 'package:flutter/material.dart';

import '../../../../common/widget/shimmer/shimmer.dart';

class GoalLinkedFundsShimmer extends StatelessWidget {
  const GoalLinkedFundsShimmer({super.key, this.isDesktop = false});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading linked mutual funds',
      child: ExcludeSemantics(
        child: IgnorePointer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (isDesktop) {
                final columns = constraints.maxWidth > 900 ? 3 : 2;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: columns == 3 ? 3.6 : 3.0,
                  children: List.generate(
                    columns,
                    (_) => const _FundPlaceholder(),
                  ),
                );
              }
              return Column(
                children: List.generate(
                  3,
                  (_) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: _FundPlaceholder(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FundPlaceholder extends StatelessWidget {
  const _FundPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        children: [
          CustomShimmer.circular(width: 36, height: 36),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer.rectangular(height: 12),
                SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: 0.65,
                  child: CustomShimmer.rectangular(height: 9),
                ),
                SizedBox(height: 6),
                FractionallySizedBox(
                  widthFactor: 0.45,
                  child: CustomShimmer.rectangular(height: 9),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          CustomShimmer.rectangular(width: 40, height: 12),
        ],
      ),
    );
  }
}
