import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/shadows.dart';
import 'package:my_sip/core/utils/constant/sizes.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';

import 'home_design.dart';
import 'home_fund_navigation.dart';
import 'home_section_header.dart';

class HomePopularFunds extends StatelessWidget {
  const HomePopularFunds({
    super.key,
    required this.funds,
    required this.scale,
    required this.isLoading,
    required this.onFundTap,
    required this.onViewAll,
    required this.onRetry,
    this.errorMessage = '',
  });

  final List<MutualFundListEntity> funds;
  final double scale;
  final bool isLoading;
  final String errorMessage;
  final ValueChanged<MutualFundListEntity> onFundTap;
  final VoidCallback onViewAll;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final visible = funds.take(3).toList(growable: false);
    final height = (HomeMetrics.popularCardHeight * scale)
        .clamp(128.0, 168.0)
        .toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeader(
          title: 'Popular Funds',
          action: 'View all',
          onAction: onViewAll,
          scale: scale,
        ),
        SizedBox(height: scale),
        if (visible.isEmpty && !isLoading)
          SizedBox(
            height: height,
            child: Center(
              child: errorMessage.isNotEmpty
                  ? TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Unable to load funds. Retry'),
                    )
                  : Text(
                      'No funds available',
                      style: UTextStyles.homeText(
                        size: 12,
                        color: Ucolors.homeTextSecondary,
                      ),
                    ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 12 * scale) / 2;
              final titleStyle = UTextStyles.homeText(
                size: (14 * scale).clamp(12.0, 16.0).toDouble(),
                height: 20 / 14,
                letterSpacing: -0.15,
              );
              final valueStyle = UTextStyles.homeText(
                size: (13 * scale).clamp(12.0, 15.0).toDouble(),
                height: 20 / 13,
              );
              var titleHeight = 31 * scale;
              for (final fund in visible) {
                titleHeight = math.max(
                  titleHeight,
                  HomeTextLayout.measure(
                    context,
                    fund.baseSchemeName ?? 'Mutual fund',
                    style: titleStyle,
                    maxWidth: width - 67.72 * scale,
                    maxLines: 2,
                  ).height,
                );
              }
              final valueHeight = HomeTextLayout.measure(
                context,
                'Ag',
                style: valueStyle,
              ).height;
              final returnHeight = math.max(
                valueHeight,
                HomeTextLayout.measure(
                  context,
                  'Ag',
                  style: titleStyle.copyWith(
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w400,
                  ),
                ).height,
              );
              final moreHeight = HomeTextLayout.measure(
                context,
                'See more',
                style: valueStyle,
                maxWidth: width - 40.22 * scale,
                maxLines: 2,
              ).height;
              final cardHeight = math.max(
                height,
                math.max(
                  25 * scale +
                      titleHeight +
                      16 * scale +
                      valueHeight +
                      4 * scale +
                      returnHeight,
                  26.72 * scale + 78 * scale + 8 * scale + moreHeight,
                ),
              );
              final count = visible.isEmpty ? 3 : visible.length;
              return GridView(
                shrinkWrap: true,
                primary: false,
                clipBehavior: Clip.none,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12 * scale,
                  mainAxisSpacing: 12 * scale,
                  mainAxisExtent: cardHeight,
                ),
                children: [
                  for (var index = 0; index < count; index++)
                    SizedBox(
                      width: width,
                      height: cardHeight,
                      child: visible.isEmpty
                          ? UShimmerEffect(
                              width: width,
                              height: cardHeight,
                              radius: USizes.homeCardRadius * scale,
                            )
                          : _PopularFundCard(
                              fund: visible[index],
                              scale: scale,
                              onTap: () => onFundTap(visible[index]),
                            ),
                    ),
                  SizedBox(
                    width: width,
                    height: cardHeight,
                    child: _MoreFundsCard(scale: scale, onTap: onViewAll),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.scale,
    required this.onTap,
    required this.child,
  });

  final double scale;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(USizes.homeCardRadius * scale);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: UShadows.homeCard,
      ),
      child: Material(
        color: Ucolors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: Ucolors.homeCardBorder, width: 0.636),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}

class _PopularFundCard extends StatelessWidget {
  const _PopularFundCard({
    required this.fund,
    required this.scale,
    required this.onTap,
  });

  final MutualFundListEntity fund;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final value = HomeFundValues.percentage(fund.returnsEntity?.threeYear);
    final color = value == null || value == 0
        ? Ucolors.homeTextSecondary
        : value < 0
        ? Ucolors.red
        : Ucolors.homePositive;
    return _CardSurface(
      scale: scale,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          13.36 * scale,
          13.36 * scale,
          13.36 * scale,
          11.64 * scale,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CustomCachedImage(
                    imageUrl: HomeFundNavigation.logoUrl(fund.amc?.amcLogoUrl),
                    width: 31 * scale,
                    height: 31 * scale,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10 * scale),
                Expanded(
                  child: Text(
                    fund.baseSchemeName ?? 'Mutual fund',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: UTextStyles.homeText(
                      size: (14 * scale).clamp(12.0, 16.0).toDouble(),
                      height: 20 / 14,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 3 * scale),
              child: Text(
                HomeFundValues.amount(fund.nav, nav: true),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: UTextStyles.homeText(
                  size: (13 * scale).clamp(12.0, 15.0).toDouble(),
                  height: 20 / 13,
                ),
              ),
            ),
            SizedBox(height: 4 * scale),
            Semantics(
              label: 'Three-year return',
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (value != null && value != 0) ...[
                            Transform.flip(
                              flipY: value < 0,
                              child: SvgPicture.asset(
                                UImages.homeTrendUp,
                                width: 16 * scale,
                                height: 16 * scale,
                                colorFilter: ColorFilter.mode(
                                  color,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            SizedBox(width: 4 * scale),
                          ],
                          Text(
                            HomeFundValues.returnLabel(
                              fund.returnsEntity?.threeYear,
                              signed: true,
                            ),
                            style: UTextStyles.homeText(
                              family: FontFamily.regular,
                              weight: FontWeight.w400,
                              size: (14 * scale).clamp(12.0, 16.0).toDouble(),
                              height: 20 / 14,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Text(
                    '3Y',
                    style: UTextStyles.homeText(
                      size: (13 * scale).clamp(12.0, 15.0).toDouble(),
                      height: 20 / 13,
                      color: Ucolors.homeTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreFundsCard extends StatelessWidget {
  const _MoreFundsCard({required this.scale, required this.onTap});

  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'See more mutual funds',
    child: _CardSurface(
      scale: scale,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(13.36 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: SizedBox(
                width: 78 * scale,
                height: 78 * scale,
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.zero,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 6 * scale,
                  mainAxisSpacing: 6 * scale,
                  children: List.generate(
                    4,
                    (_) => Container(
                      width: 36 * scale,
                      height: 36 * scale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9 * scale),
                        border: Border.all(color: Ucolors.homeMoreFundBorder),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Flexible(
                  child: Text(
                    'See more',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: UTextStyles.homeText(
                      size: (13 * scale).clamp(12.0, 15.0).toDouble(),
                      height: 20 / 13,
                      color: Ucolors.homeTextSecondary,
                    ),
                  ),
                ),
                SizedBox(width: 9 * scale),
                SvgPicture.asset(
                  UImages.homeSectionChevron,
                  width: 4.5 * scale,
                  height: 8 * scale,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
