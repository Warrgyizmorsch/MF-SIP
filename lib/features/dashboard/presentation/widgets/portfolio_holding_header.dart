import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../domain/entity/portfolio_entity.dart';

class PortfolioDetailsHeader extends StatelessWidget {
  const PortfolioDetailsHeader({
    super.key,
    required this.fund,
    required this.onBack,
  });

  final MfuPortfolioItemEntity fund;
  final VoidCallback onBack;

  static const gradient = Ucolors.portfolioHeaderGradient;

  @override
  Widget build(BuildContext context) {
    final metadata = _HoldingMetadata(fund);
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      // decoration: const BoxDecoration(gradient: gradient),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Material(
              color: Ucolors.white.withValues(alpha: 0.12),
              shape: CircleBorder(
                side: BorderSide(color: Ucolors.white.withValues(alpha: 0.2)),
              ),
              child: IconButton(
                tooltip: 'Back to portfolio',
                onPressed: onBack,
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 40,
                ),
                padding: const EdgeInsets.all(10),
                icon: SvgPicture.asset(
                  'assets/portfolio/figma/back.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),
            ClipOval(
              child: ColoredBox(
                color: Ucolors.white,
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: metadata.logo.isEmpty
                      ? Center(
                          child: Text(
                            metadata.initials,
                            style: _text(
                              10,
                              weight: FontWeight.w800,
                              color: Ucolors.portfolioAccent,
                            ),
                          ),
                        )
                      : CustomCachedImage(
                          imageUrl: metadata.logo,
                          width: 34,
                          height: 34,
                          radius: 17,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                metadata.name,
                softWrap: true,
                style: UTextStyles.portfolioHeaderTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioHoldingCard extends StatelessWidget {
  const PortfolioHoldingCard({super.key, required this.fund});

  final MfuPortfolioItemEntity fund;

  @override
  Widget build(BuildContext context) {
    final gainColor = fund.gainLoss < 0
        ? Ucolors.portfolioNegative
        : Ucolors.homePositive;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Ucolors.white,
        border: Border.all(color: Ucolors.portfolioCardBorder),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 33,
                    child: _metric(
                      'Invested',
                      _money(fund.investedAmount, decimals: 0),
                      fund.firstInvestedDate.trim().isNotEmpty &&
                              fund.firstInvestedDate.trim() != '—'
                          ? 'Since ${_date(fund.firstInvestedDate)}'
                          : 'Total cost',
                      prominent: true,
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Ucolors.portfolioDivider,
                  ),
                  Expanded(
                    flex: 34,
                    child: _metric(
                      'Current value',
                      _money(fund.currentValue, decimals: 0),
                      fund.navDate.trim().isNotEmpty &&
                              fund.navDate.trim() != '—'
                          ? 'As of ${_date(fund.navDate)}'
                          : 'Market value',
                      prominent: true,
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Ucolors.portfolioDivider,
                  ),
                  Expanded(
                    flex: 33,
                    child: _metric(
                      'Total gain',
                      _signedMoney(fund.gainLoss, decimals: 0),
                      fund.annualizedReturn != null
                          ? '${_percentage(fund.annualizedReturn!)} ${fund.annualizedReturnLabel}'
                          : '${_percentage(fund.gainLossPercent)} return',
                      color: gainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            decoration: _band,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${fund.totalUnits.isFinite ? fund.totalUnits.toStringAsFixed(3) : '—'} units',
                      style: _text(
                        12,
                        color: Ucolors.portfolioInk,
                        height: 1.5,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: _text(12, color: Ucolors.portfolioDivider),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'NAV ${_money(fund.currentNav, decimals: 4)}',
                      style: _text(
                        12,
                        color: Ucolors.portfolioTextMuted,
                        height: 1.5,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                _statusBadge(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: _band,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final folio = _metadata(
                  'Folio number',
                  fund.folioNo,
                  singleLineValue: true,
                );
                final goal = _metadata('Goal', fund.goalName ?? '');
                final folioWidth =
                    _textWidth(
                      context,
                      'Folio number',
                      _text(10, color: Ucolors.portfolioTextMuted, height: 1.5),
                    ) +
                    6 +
                    _textWidth(
                      context,
                      fund.folioNo.trim().isEmpty ? '—' : fund.folioNo,
                      _text(10, weight: FontWeight.w700, height: 1.5),
                    );
                if (folioWidth > (constraints.maxWidth - 24) / 2) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [folio, const SizedBox(height: 10), goal],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: folio),
                    const SizedBox(width: 24),
                    Expanded(child: goal),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    final String label;
    final Color color;
    if (fund.isFullyRedeemed) {
      label = 'Redeemed';
      color = Ucolors.portfolioTextMuted;
    } else if (fund.isRedemptionPending) {
      label = 'Redemption pending';
      color = Ucolors.portfolioPendingText;
    } else if (fund.isAllotmentPending) {
      label = 'Allotment pending';
      color = Ucolors.portfolioPendingText;
    } else if (fund.hasPendingSipCancellation) {
      label = 'Cancellation pending';
      color = Ucolors.portfolioPendingText;
    } else if (fund.isSipCancelledFlag) {
      label = 'SIP cancelled';
      color = Ucolors.portfolioTextMuted;
    } else if (fund.isSipActive) {
      label = 'Active SIP';
      color = Ucolors.homePositive;
    } else {
      label = fund.isLumpsum ? 'Lump sum' : 'Holding';
      color = Ucolors.portfolioAccent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: _text(10, weight: FontWeight.w700, color: color, height: 1.5),
      ),
    );
  }

  Widget _metadata(String label, String value, {bool singleLineValue = false}) {
    final labelStyle = _text(
      10,
      color: Ucolors.portfolioTextMuted,
      height: 1.5,
    );
    final valueStyle = _text(
      10,
      weight: FontWeight.w700,
      color: Ucolors.portfolioValueBlue,
      height: 1.5,
    );
    final labelText = Text(label, style: labelStyle);
    if (singleLineValue) {
      final number = PortfolioFolioNumber(value: value, style: valueStyle);
      return LayoutBuilder(
        builder: (context, constraints) {
          final requiredWidth =
              _textWidth(context, label, labelStyle) +
              6 +
              _textWidth(context, number.displayValue, valueStyle);
          if (requiredWidth > constraints.maxWidth) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [labelText, const SizedBox(height: 4), number],
            );
          }
          return Row(
            children: [
              labelText,
              const SizedBox(width: 6),
              Expanded(child: number),
            ],
          );
        },
      );
    }
    return Row(
      children: [
        Expanded(child: labelText),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value.trim().isEmpty ? '—' : value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          ),
        ),
      ],
    );
  }

  Widget _metric(
    String label,
    String value,
    String caption, {
    bool prominent = false,
    Color? color,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: UTextStyles.portfolioMetricLabel,
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style:
                (prominent
                        ? UTextStyles.portfolioMetricValueProminent
                        : UTextStyles.portfolioMetricValue)
                    .copyWith(color: color ?? Ucolors.portfolioInk),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: UTextStyles.portfolioCaption.copyWith(
            color: color ?? Ucolors.homeTextSecondary,
          ),
        ),
      ],
    ),
  );
}

/// Keeps the complete folio readable without splitting or truncating digits.
class PortfolioFolioNumber extends StatelessWidget {
  const PortfolioFolioNumber({
    super.key,
    required this.value,
    required this.style,
  });

  final String value;
  final TextStyle style;

  String get displayValue => value.trim().isEmpty ? '—' : value;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        displayValue,
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.right,
        style: style,
      ),
    ),
  );
}

// Display the supplied scheme identity without changing the official name.
class _HoldingMetadata {
  const _HoldingMetadata(this.fund);
  final MfuPortfolioItemEntity fund;

  String get name =>
      fund.fundName.trim().isEmpty ? 'Fund holding' : fund.fundName.trim();
  String get description => fund.amcName.trim().isNotEmpty
      ? fund.amcName.trim()
      : (fund.isSip
            ? 'SIP holding'
            : (fund.isLumpsum ? 'Lump-sum holding' : 'Fund holding'));
  String get logo {
    final path = fund.amcLogo.trim();
    final uri = Uri.tryParse(path);
    if (path.isEmpty || uri == null) return '';
    return uri.hasScheme
        ? path
        : '${Appurl.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/${path.replaceFirst(RegExp(r'^/+'), '')}';
  }

  String get initials {
    final words = (fund.amcName.trim().isEmpty ? name : fund.amcName.trim())
        .split(RegExp(r'\s+'));
    return words
        .take(2)
        .map((word) => word.substring(0, 1))
        .join()
        .toUpperCase();
  }
}

const _band = BoxDecoration(
  color: Ucolors.portfolioMetadataSurface,
  border: Border(top: BorderSide(color: Ucolors.portfolioMetadataBorder)),
);

TextStyle _text(
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = Ucolors.portfolioInk,
  double? height,
}) => UTextStyles.portfolioText(
  size: size,
  weight: weight,
  color: color,
  height: height,
);

double _textWidth(BuildContext context, String value, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(
      text: value,
      style: DefaultTextStyle.of(context).style.merge(style),
    ),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

String _money(double value, {int decimals = 2}) => value.isFinite
    ? NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: decimals,
      ).format(value)
    : '—';
String _signedMoney(double value, {int decimals = 2}) => value.isFinite
    ? '${value < 0 ? '−' : '+'}${_money(value.abs(), decimals: decimals)}'
    : '—';
String _percentage(double value) => value.isFinite
    ? '${value < 0 ? '−' : '+'}${value.abs().toStringAsFixed(2)}%'
    : '—';
String _date(String value) {
  final date = DateTime.tryParse(value);
  return date == null
      ? (value.trim().isEmpty ? '—' : value)
      : DateFormat('dd MMM yyyy').format(date);
}
