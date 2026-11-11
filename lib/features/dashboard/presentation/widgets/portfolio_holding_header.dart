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

  static const gradient = LinearGradient(
    begin: Alignment(-0.086, -1),
    end: Alignment(0.086, 1),
    colors: [Ucolors.homeHeaderEnd, Color(0xFF441D9E), Color(0xFF5B3FE0)],
    stops: [0.08, 0.54, 0.92],
  );

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
              color: Colors.white.withValues(alpha: 0.12),
              shape: CircleBorder(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
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
                color: Colors.white,
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
                              color: _purple,
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
                style: _text(
                  15,
                  weight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.5,
                ),
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
        ? const Color(0xFFFF383C)
        : Ucolors.homePositive;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
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
                    flex: 30,
                    child: _metric(
                      'Current NAV',
                      _money(fund.currentNav, decimals: 4),
                      _date(fund.navDate),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFD2D5DA),
                  ),
                  Expanded(
                    flex: 35,
                    child: _metric(
                      'Current value',
                      _money(fund.currentValue),
                      '${_money(fund.investedAmount)} invested',
                      prominent: true,
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFD2D5DA),
                  ),
                  Expanded(
                    flex: 30,
                    child: _metric(
                      'Total gain',
                      _signedMoney(fund.gainLoss),
                      '${_percentage(fund.gainLossPercent)} return',
                      color: gainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: _band,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _metadata('Folio number', fund.folioNo)),
                    const SizedBox(width: 24),
                    Expanded(child: _metadata('Goal', fund.goalName ?? '')),
                  ],
                ),
              ],
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
                Text(
                  '${fund.totalUnits.isFinite ? fund.totalUnits.toStringAsFixed(3) : '—'} total units',
                  style: _text(
                    12,
                    color: _ink,
                    height: 1.5,
                    weight: FontWeight.w700,
                  ),
                ),
                _statusBadge(),
              ],
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
      color = _dim;
    } else if (fund.isRedemptionPending) {
      label = 'Redemption pending';
      color = const Color(0xFFB45309);
    } else if (fund.isAllotmentPending) {
      label = 'Allotment pending';
      color = const Color(0xFFB45309);
    } else if (fund.hasPendingSipCancellation) {
      label = 'Cancellation pending';
      color = const Color(0xFFB45309);
    } else if (fund.isSipCancelledFlag) {
      label = 'SIP cancelled';
      color = _dim;
    } else if (fund.isSipActive) {
      label = 'Active SIP';
      color = Ucolors.homePositive;
    } else {
      label = fund.isLumpsum ? 'Lump sum' : 'Holding';
      color = _purple;
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

  Widget _metadata(String label, String value) => Row(
    children: [
      Expanded(
        child: Text(label, style: _text(10, color: _dim, height: 1.5)),
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          value.trim().isEmpty ? '—' : value,
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _text(
            10,
            weight: FontWeight.w700,
            color: _valueBlue,
            height: 1.5,
          ),
        ),
      ),
    ],
  );

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
          style: _text(9, color: _dim, height: 1.5),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: _text(
              prominent ? 17 : 14,
              weight: prominent ? FontWeight.w800 : FontWeight.w700,
              color: color ?? _ink,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: _text(
            8,
            color: color ?? Ucolors.homeTextSecondary,
            height: 1.35,
          ),
        ),
      ],
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

const _purple = Color(0xFF441D9E);
const _ink = Color(0xFF12121A);
const _dim = Color(0xFF8A8AA0);
const _line = Color(0xFFE4E6EE);
const _valueBlue = Color(0xFF2552E6);
const _band = BoxDecoration(
  color: Color(0xFFFAFAFD),
  border: Border(top: BorderSide(color: Color(0xFFEEF0F4))),
);

TextStyle _text(
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = _ink,
  double? height,
}) => UTextStyles.homeText(
  size: size,
  weight: weight,
  color: color,
  family: FontFamily.plusJakartaSans,
  height: height,
);

String _money(double value, {int decimals = 2}) => value.isFinite
    ? NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: decimals,
      ).format(value)
    : '—';
String _signedMoney(double value) =>
    value.isFinite ? '${value < 0 ? '−' : '+'}${_money(value.abs())}' : '—';
String _percentage(double value) => value.isFinite
    ? '${value < 0 ? '−' : '+'}${value.abs().toStringAsFixed(2)}%'
    : '—';
String _date(String value) {
  final date = DateTime.tryParse(value);
  return date == null
      ? (value.trim().isEmpty ? '—' : value)
      : DateFormat('dd MMM yyyy').format(date);
}
