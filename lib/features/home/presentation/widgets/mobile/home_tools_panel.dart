import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import 'home_adaptive_grid.dart';
import 'home_design.dart';
import 'home_section_panel.dart';

class HomeToolsPanel extends StatelessWidget {
  const HomeToolsPanel({super.key, required this.scale});

  final double scale;

  static const _tools = [
    _HomeTool(
      'SIP Calculator',
      UImages.homeSipCalculator,
      AppRoutes.sipCalculator,
      Size(23, 34),
    ),
    _HomeTool(
      'SWP Calculator',
      UImages.homeSwpCalculator,
      AppRoutes.swpCalculator,
      Size(25.9875, 25.9333),
    ),
    _HomeTool(
      'Compare Fund',
      UImages.homeCompareFunds,
      AppRoutes.comparefund,
      Size(30, 28),
    ),
    _HomeTool(
      'SIP Top Up\nCalculator',
      UImages.homeTopUpCalculator,
      AppRoutes.stepUpCalculator,
      Size(29, 27),
    ),
  ];

  @override
  Widget build(BuildContext context) => HomeSectionPanel(
    title: 'Products & Tools',
    scale: scale,
    bottomPadding: 21,
    child: HomeAdaptiveGrid(
      maximumColumns: 2,
      minimumTileWidth:
          HomeTextLayout.widestWord(
            context,
            _tools.map((tool) => tool.title),
            style: UTextStyles.homeText(
              size: (11 * scale).clamp(9.0, 13.0).toDouble(),
              height: 15 / 11,
            ),
          ) +
          72 * scale +
          1.272,
      columnGap: 10 * scale,
      rowGap: 10 * scale,
      children: [
        for (final tool in _tools)
          _ToolTile(
            tool: tool,
            scale: scale,
            onTap: () => Get.toNamed(tool.route),
          ),
      ],
    ),
  );
}

class _HomeTool {
  const _HomeTool(this.title, this.asset, this.route, this.iconSize);

  final String title;
  final String asset;
  final String route;
  final Size iconSize;
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.tool,
    required this.scale,
    required this.onTap,
  });

  final _HomeTool tool;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Ucolors.homeTile,
    borderRadius: BorderRadius.circular(USizes.homeTileRadius * scale),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: (HomeMetrics.toolTileHeight * scale)
              .clamp(44.0, 60.0)
              .toDouble(),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Ucolors.homeTileBorder, width: 0.636),
          borderRadius: BorderRadius.circular(USizes.homeTileRadius * scale),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16 * scale,
          vertical: 7 * scale,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30 * scale,
              child: Center(
                child: SvgPicture.asset(
                  tool.asset,
                  width: tool.iconSize.width * scale,
                  height: tool.iconSize.height * scale,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10 * scale),
            Expanded(
              child: Text(
                tool.title,
                style: UTextStyles.homeText(
                  size: (11 * scale).clamp(9.0, 13.0).toDouble(),
                  color: Ucolors.homeInk,
                  height: 15 / 11,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
