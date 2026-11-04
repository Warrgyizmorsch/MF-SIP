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

class HomeFundStrip extends StatelessWidget {
  const HomeFundStrip({
    super.key,
    required this.funds,
    required this.scale,
    required this.isLoading,
    required this.onFundTap,
    required this.onRetry,
    this.errorMessage = '',
  });

  final List<MutualFundListEntity> funds;
  final double scale;
  final bool isLoading;
  final String errorMessage;
  final ValueChanged<MutualFundListEntity> onFundTap;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cardWidth = 329 * scale;
    double lineHeight(double size, double ratio) => HomeTextLayout.measure(
      context,
      'Ag',
      style: UTextStyles.homeText(size: size, height: ratio),
    ).height;
    final valueHeight = lineHeight(
      (14 * scale).clamp(12.0, 16.0).toDouble(),
      20 / 14,
    );
    final contentHeight =
        26 * scale +
        math.max(34 * scale, valueHeight) +
        10 * scale +
        valueHeight +
        lineHeight((9 * scale).clamp(8.0, 10.0).toDouble(), 20 / 9) +
        scale +
        9 * scale +
        math.max(
          14 * scale,
          lineHeight((10 * scale).clamp(9.0, 12.0).toDouble(), 1.2) + 8 * scale,
        );
    final height = math.max(
      (HomeMetrics.fundCardHeight * scale).clamp(138.0, 180.0).toDouble(),
      contentHeight,
    );
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
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Unable to load funds. Retry'),
                ),
        ),
      );
    }
    return SizedBox(
      height: height + 8,
      child: ListView.separated(
        key: const PageStorageKey('home-featured-funds'),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(27.5 * scale, 0, 27.5 * scale, 8),
        itemCount: funds.isEmpty ? 3 : funds.length,
        separatorBuilder: (_, _) => SizedBox(width: 20 * scale),
        itemBuilder: (context, index) {
          if (funds.isEmpty) {
            return UShimmerEffect(
              width: cardWidth,
              height: height,
              radius: USizes.homeCardRadius * scale,
            );
          }
          final fund = funds[index];
          return SizedBox(
            width: cardWidth,
            child: _FundCard(
              key: ValueKey('home-featured-${fund.schemeCode ?? fund.fundId}'),
              fund: fund,
              scale: scale,
              onTap: () => onFundTap(fund),
            ),
          );
        },
      ),
    );
  }
}

class _FundCard extends StatelessWidget {
  const _FundCard({
    super.key,
    required this.fund,
    required this.scale,
    required this.onTap,
  });

  final MutualFundListEntity fund;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final performance = HomeFundValues.percentage(
      fund.returnsEntity?.threeYear,
    );
    final positive = performance != null && performance > 0;
    final negative = performance != null && performance < 0;
    final performanceColor = negative
        ? Ucolors.red
        : positive
        ? Ucolors.homePositive
        : Ucolors.homeTextSecondary;
    final nfo = fund.isNfoOffer;
    final nav = fund.nav ?? (nfo ? fund.nfoDetails?.nfoPrice : null);
    final category = fund.schemecategory?.trim() ?? '';
    final risk = fund.riskLevel?.trim() ?? '';
    final tags = [
      if (nfo)
        fund.isNfoClosed
            ? 'NFO Closed'
            : fund.isNfoUpcoming
            ? 'Upcoming NFO'
            : 'NFO'
      else if (category.isNotEmpty)
        category,
      if (risk.isNotEmpty) risk,
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Ucolors.white,
        borderRadius: BorderRadius.circular(USizes.homeCardRadius * scale),
        boxShadow: UShadows.homeFeaturedFund,
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(USizes.homeCardRadius * scale),
          side: const BorderSide(color: Ucolors.homeCardBorder, width: 0.636),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16 * scale,
              12 * scale,
              16 * scale,
              14 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 34 * scale,
                      height: 34 * scale,
                      child: Center(
                        child: ClipOval(
                          child: CustomCachedImage(
                            imageUrl: HomeFundNavigation.logoUrl(
                              fund.amc?.amcLogoUrl,
                            ),
                            width: 31 * scale,
                            height: 31 * scale,
                            radius: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5 * scale),
                    Expanded(
                      child: Text(
                        fund.baseSchemeName ?? 'Mutual fund',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: UTextStyles.homeText(
                          size: (14 * scale).clamp(12.0, 16.0).toDouble(),
                          height: 20 / 14,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                    SizedBox(width: 6 * scale),
                    Semantics(
                      label:
                          'Three-year return ${HomeFundValues.returnLabel(fund.returnsEntity?.threeYear, signed: true)}',
                      child: SizedBox(
                        width: 76 * scale,
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
                                  color: performanceColor,
                                ),
                              if (positive || negative)
                                SizedBox(width: 4 * scale),
                              Text(
                                HomeFundValues.returnLabel(
                                  fund.returnsEntity?.threeYear,
                                  signed: true,
                                ),
                                style: UTextStyles.homeText(
                                  family: FontFamily.regular,
                                  size: (14 * scale)
                                      .clamp(11.0, 16.0)
                                      .toDouble(),
                                  color: performanceColor,
                                  height: 20 / 14,
                                  letterSpacing: -0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10 * scale),
                Row(
                  children: [
                    Expanded(
                      child: _Metric(
                        value: HomeFundValues.returnLabel(
                          fund.returnsEntity?.oneYear,
                        ),
                        label: '1Y CAGR',
                        scale: scale,
                      ),
                    ),
                    Expanded(
                      child: _Metric(
                        value: fund.isSipAllowed == false
                            ? 'Unavailable'
                            : HomeFundValues.amount(fund.minSipAmount),
                        label: 'Min. SIP',
                        scale: scale,
                        alignment: CrossAxisAlignment.center,
                      ),
                    ),
                    Expanded(
                      child: _Metric(
                        value: HomeFundValues.amount(nav, nav: true),
                        label: 'NAV',
                        scale: scale,
                        alignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                LayoutBuilder(
                  builder: (context, constraints) => SvgPicture.asset(
                    UImages.homeFundDivider,
                    width: constraints.maxWidth,
                    height: scale,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 9 * scale),
                Row(
                  children: [
                    for (var index = 0; index < tags.length; index++) ...[
                      if (index > 0) SizedBox(width: 10 * scale),
                      Flexible(
                        child: _FundTag(label: tags[index], scale: scale),
                      ),
                    ],
                    const Spacer(),
                    SvgPicture.asset(
                      UImages.homeFundChevron,
                      width: 6.5 * scale,
                      height: 13.5 * scale,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.value,
    required this.label,
    required this.scale,
    this.alignment = CrossAxisAlignment.start,
  });

  final String value;
  final String label;
  final double scale;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: alignment,
    mainAxisSize: MainAxisSize.min,
    children: [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          style: UTextStyles.homeText(
            size: (14 * scale).clamp(12.0, 16.0).toDouble(),
            weight: FontWeight.w600,
            height: 20 / 14,
          ),
        ),
      ),
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: UTextStyles.homeText(
          size: (9 * scale).clamp(8.0, 10.0).toDouble(),
          color: Ucolors.homeTextSecondary,
          height: 20 / 9,
          letterSpacing: 0.4,
        ),
      ),
    ],
  );
}

class _FundTag extends StatelessWidget {
  const _FundTag({required this.label, required this.scale});

  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
    decoration: BoxDecoration(
      color: Ucolors.homeTag,
      borderRadius: BorderRadius.circular(6 * scale),
    ),
    child: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: UTextStyles.homeText(
        size: (10 * scale).clamp(9.0, 12.0).toDouble(),
        color: Ucolors.homeTextSecondary,
        height: 1.2,
      ),
    ),
  );
}
