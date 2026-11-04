import 'package:flutter/material.dart';

/// Keeps the reference columns when labels fit, then uses fewer columns as text
/// grows. Natural row heights avoid fixed-height clipping and rounding in Wrap.
class HomeAdaptiveGrid extends StatelessWidget {
  const HomeAdaptiveGrid({
    super.key,
    required this.children,
    required this.maximumColumns,
    required this.minimumTileWidth,
    required this.columnGap,
    required this.rowGap,
  });

  final List<Widget> children;
  final int maximumColumns;
  final double minimumTileWidth;
  final double columnGap;
  final double rowGap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns =
          ((constraints.maxWidth + columnGap) / (minimumTileWidth + columnGap))
              .floor()
              .clamp(1, maximumColumns)
              .toInt();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var start = 0; start < children.length; start += columns) ...[
            if (start > 0) SizedBox(height: rowGap),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) SizedBox(width: columnGap),
                    Expanded(
                      child: start + column < children.length
                          ? children[start + column]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    },
  );
}
