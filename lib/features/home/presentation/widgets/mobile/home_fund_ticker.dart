import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';

import 'home_design.dart';

class HomeFundTicker extends StatelessWidget {
  const HomeFundTicker({
    super.key,
    required this.funds,
    required this.isLoading,
    required this.onFundTap,
    required this.onRetry,
    this.errorMessage = '',
  });

  final List<MutualFundListEntity> funds;
  final bool isLoading;
  final String errorMessage;
  final ValueChanged<MutualFundListEntity> onFundTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = (constraints.maxWidth / HomeMetrics.referenceWidth)
          .clamp(0.7, 1.2)
          .toDouble();
      final height = math.max(
        (HomeMetrics.tickerHeight * scale).clamp(50.0, 70.0).toDouble(),
        HomeTextLayout.measure(
              context,
              'Ag',
              style: UTextStyles.homeText(
                size: (12 * scale).clamp(10.0, 14.0).toDouble(),
                height: 20 / 12,
              ),
            ).height +
            HomeTextLayout.measure(
              context,
              'Ag',
              style: UTextStyles.homeText(
                size: (13 * scale).clamp(11.0, 15.0).toDouble(),
                height: 20 / 13,
              ),
            ).height +
            14 * scale,
      );
      final cardWidth = (HomeMetrics.tickerCardWidth * scale)
          .clamp(138.0, 185.0)
          .toDouble();

      if (funds.isEmpty && !isLoading) {
        return SizedBox(
          height: height,
          child: Center(
            child: errorMessage.isEmpty
                ? Text(
                    'No funds available',
                    style: UTextStyles.homeText(
                      size: 12,
                      color: Ucolors.homeTextSecondary,
                    ),
                  )
                : TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Unable to load funds. Retry'),
                    style: TextButton.styleFrom(
                      foregroundColor: Ucolors.homeInk,
                      textStyle: UTextStyles.homeText(size: 12),
                    ),
                  ),
          ),
        );
      }

      final showLoading = funds.isEmpty;
      // Space for the reference shadow sits outside the measured card height.
      return SizedBox(
        height: height + 8,
        child: ListView.separated(
          key: const PageStorageKey('home-fund-ticker'),
          padding: const EdgeInsets.only(bottom: 8),
          scrollDirection: Axis.horizontal,
          itemCount: showLoading ? 3 : funds.length,
          separatorBuilder: (_, _) =>
              SizedBox(width: HomeMetrics.tickerGap * scale),
          itemBuilder: (context, index) {
            if (showLoading) {
              return UShimmerEffect(
                width: cardWidth,
                height: height,
                radius: 8 * scale,
              );
            }
            final fund = funds[index];
            return _TickerCard(
              key: ValueKey('ticker-${fund.schemeCode ?? fund.fundId}'),
              fund: fund,
              scale: scale,
              width: cardWidth,
              onTap: () => onFundTap(fund),
            );
          },
        ),
      );
    },
  );
}

class _TickerCard extends StatelessWidget {
  const _TickerCard({
    super.key,
    required this.fund,
    required this.scale,
    required this.width,
    required this.onTap,
  });

  final MutualFundListEntity fund;
  final double scale;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final parsedReturn = double.tryParse(
      fund.returnsEntity?.threeYear?.replaceAll('%', '').trim() ?? '',
    );
    final performance = parsedReturn?.isFinite == true ? parsedReturn : null;
    final positive = performance != null && performance > 0;
    final negative = performance != null && performance < 0;
    final color = negative
        ? Ucolors.red
        : positive
        ? Ucolors.homePositive
        : Ucolors.homeTextSecondary;
    final nav = fund.nav;
    final navLabel = nav != null && nav.isFinite ? nav.toStringAsFixed(2) : '—';
    final returnLabel = performance == null
        ? '—'
        : '${positive ? '+' : ''}${performance.toStringAsFixed(2)}%';
    final name = fund.baseSchemeName ?? 'Mutual fund';

    return Semantics(
      button: true,
      label: '$name. NAV $navLabel. Three year return $returnLabel.',
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Ucolors.white,
            borderRadius: BorderRadius.circular(8 * scale),
            boxShadow: UShadows.homeCard,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8 * scale),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14 * scale,
                  vertical: 7 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: UTextStyles.homeText(
                        size: (12 * scale).clamp(10.0, 14.0).toDouble(),
                        height: 20 / 12,
                        letterSpacing: -0.15,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              navLabel,
                              style: UTextStyles.homeText(
                                size: (13 * scale).clamp(11.0, 15.0).toDouble(),
                                height: 20 / 13,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8 * scale),
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (positive)
                                  SvgPicture.asset(
                                    UImages.homeTrendUp,
                                    width: 16 * scale,
                                    height: 16 * scale,
                                  )
                                else if (negative)
                                  Icon(
                                    Icons.trending_down_rounded,
                                    size: 16 * scale,
                                    color: color,
                                  ),
                                if (positive || negative)
                                  SizedBox(width: 4 * scale),
                                Text(
                                  returnLabel,
                                  style: UTextStyles.homeText(
                                    family: FontFamily.regular,
                                    size: (12 * scale)
                                        .clamp(10.0, 14.0)
                                        .toDouble(),
                                    weight: FontWeight.w400,
                                    color: color,
                                    height: 20 / 12,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
