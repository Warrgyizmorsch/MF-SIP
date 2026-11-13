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
    this.onViewAll,
    required this.onRetry,
    this.title = 'Recently Viewed',
    this.errorMessage = '',
  });

  final String title;
  final List<MutualFundListEntity> funds;
  final double scale;
  final bool isLoading;
  final String errorMessage;
  final ValueChanged<MutualFundListEntity> onFundTap;
  final VoidCallback? onViewAll;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (funds.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    final cardHeight = (HomeMetrics.popularCardHeight * scale)
        .clamp(130.0, 168.0)
        .toDouble();
    final cardWidth = (180.0 * scale).clamp(160.0, 220.0).toDouble();

    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30 * scale),
            child: HomeSectionHeader(title: title, scale: scale),
          ),
          SizedBox(height: 6 * scale),
          SizedBox(
            height: cardHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 30 * scale),
              clipBehavior: Clip.none,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 12 * scale),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: UShimmerEffect(
                  width: cardWidth,
                  height: cardHeight,
                  radius: USizes.homeCardRadius * scale,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30 * scale),
          child: HomeSectionHeader(title: title, scale: scale),
        ),
        SizedBox(height: 6 * scale),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 30 * scale),
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: funds.length,
            separatorBuilder: (context, index) => SizedBox(width: 12 * scale),
            itemBuilder: (context, index) {
              final fund = funds[index];
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: _PopularFundCard(
                  fund: fund,
                  scale: scale,
                  onTap: () => onFundTap(fund),
                ),
              );
            },
          ),
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
