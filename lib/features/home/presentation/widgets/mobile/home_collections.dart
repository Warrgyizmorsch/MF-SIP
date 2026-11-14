import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import 'home_adaptive_grid.dart';
import 'home_design.dart';
import 'home_section_panel.dart';

enum HomeCollection {
  bestSip,
  highReturns,
  international,
  betterThanFd,
  commodities,
  equity,
}

class HomeCollections extends StatelessWidget {
  const HomeCollections({
    super.key,
    required this.scale,
    required this.onSelected,
  });

  final double scale;
  final ValueChanged<HomeCollection> onSelected;

  static const _items = [
    (
      HomeCollection.bestSip,
      'Best SIP\nFunds',
      UImages.homeBestSip,
      Size(32, 32),
    ),
    (
      HomeCollection.highReturns,
      'High Returns',
      UImages.homeHighReturns,
      Size(32, 32),
    ),
    (
      HomeCollection.international,
      'International\nFunds',
      UImages.homeInternationalFunds,
      Size(32, 32),
    ),
    (
      HomeCollection.betterThanFd,
      'Better than\nFD',
      UImages.homeIndexFunds,
      Size(32, 35),
    ),
    (
      HomeCollection.commodities,
      'Commodities',
      UImages.homeCommodities,
      Size(32, 32),
    ),
    (HomeCollection.equity, 'Equity', UImages.homeEquity, Size(32, 32)),
  ];

  @override
  Widget build(BuildContext context) => HomeSectionPanel(
    title: 'Collection',
    scale: scale,
    child: HomeAdaptiveGrid(
      maximumColumns: 3,
      minimumTileWidth:
          HomeTextLayout.widestWord(
            context,
            _items.map((item) => item.$2),
            style: UTextStyles.homeText(
              size: (11 * scale).clamp(9.0, 13.0).toDouble(),
              height: 14 / 11,
            ),
          ) +
          8 * scale +
          1.272,
      columnGap: 25 * scale,
      rowGap: 20 * scale,
      children: [
        for (final item in _items)
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (HomeMetrics.collectionTileSize * scale)
                  .clamp(72.0, 108.0)
                  .toDouble(),
            ),
            child: Material(
              color: Ucolors.homeTile,
              borderRadius: BorderRadius.circular(
                USizes.homeTileRadius * scale,
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onSelected(item.$1),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    USizes.homeTileRadius * scale,
                  ),
                  side: const BorderSide(
                    color: Ucolors.homeTileBorder,
                    width: 0.636,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Ucolors.homeTileBorder,
                      width: 0.636,
                    ),
                    borderRadius: BorderRadius.circular(
                      USizes.homeTileRadius * scale,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 4 * scale,
                    vertical: 10 * scale - 0.636,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35 * scale,
                        child: Center(
                          child: SvgPicture.asset(
                            item.$3,
                            width: item.$4.width * scale,
                            height: item.$4.height * scale,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 7 * scale),
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 28 * scale),
                        child: Center(
                          heightFactor: 1,
                          child: Text(
                            item.$2,
                            textAlign: TextAlign.center,
                            style: UTextStyles.homeText(
                              size: (11 * scale).clamp(9.0, 13.0).toDouble(),
                              color: Ucolors.homeInk,
                              height: 14 / 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
