import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../domain/entity/portfolio_entity.dart';

enum _DetailPanel { investment, schedule }

class PortfolioDetailsPanels extends StatefulWidget {
  const PortfolioDetailsPanels({
    super.key,
    required this.fund,
    required this.showSipSchedule,
    required this.onViewInvestmentDetails,
  });

  final MfuPortfolioItemEntity fund;
  final bool showSipSchedule;
  final VoidCallback onViewInvestmentDetails;

  @override
  State<PortfolioDetailsPanels> createState() => _PortfolioDetailsPanelsState();
}

class _PortfolioDetailsPanelsState extends State<PortfolioDetailsPanels> {
  _DetailPanel? _expanded;

  @override
  void didUpdateWidget(covariant PortfolioDetailsPanels oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.fund;
    final current = widget.fund;
    if (previous.schemeCode != current.schemeCode ||
        previous.folioNo != current.folioNo ||
        previous.mfuOrderFundId != current.mfuOrderFundId ||
        previous.mfuOrderId != current.mfuOrderId ||
        (_expanded == _DetailPanel.schedule && !widget.showSipSchedule)) {
      _expanded = null;
    }
  }

  void _toggle(_DetailPanel panel) {
    setState(() => _expanded = _expanded == panel ? null : panel);
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _button(
                  _DetailPanel.investment,
                  'Investment Details',
                  'investment',
                ),
              ),
              if (widget.showSipSchedule) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _button(
                    _DetailPanel.schedule,
                    'SIP Schedule',
                    'calendar',
                  ),
                ),
              ],
            ],
          ),
        ),
        AnimatedSize(
          alignment: Alignment.topCenter,
          duration: reducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _expanded == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _expanded == _DetailPanel.investment
                      ? _investment()
                      : _schedule(),
                ),
        ),
      ],
    );
  }

  Widget _button(_DetailPanel panel, String label, String icon) {
    final selected = _expanded == panel;
    return Semantics(
      label: label,
      button: true,
      excludeSemantics: true,
      expanded: selected,
      onTap: () => _toggle(panel),
      child: Material(
        color: selected ? const Color(0xFFEFEBF7) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? _purple : _line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: () => _toggle(panel),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 54),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/portfolio/figma/$icon${selected ? '_active' : ''}.svg',
                        width: 17,
                        height: 17,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      label,
                      style: _text(
                        11,
                        weight: FontWeight.w700,
                        color: selected ? _purple : Ucolors.homeHeaderEnd,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  SizedBox(
                    width: 16,
                    child: Text(
                      selected ? '−' : '+',
                      textAlign: TextAlign.right,
                      style: _text(17, weight: FontWeight.w700, color: _dim),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _investment() {
    final fund = widget.fund;
    return _panel([
      ('Invested amount', _money(fund.investedAmount)),
      (
        'Purchase NAV',
        fund.purchaseNav > 0 ? _money(fund.purchaseNav, decimals: 4) : '—',
      ),
      ('First invested', _date(fund.firstInvestedDate)),
    ], onViewDetails: widget.onViewInvestmentDetails);
  }

  Widget _schedule() {
    final fund = widget.fund;
    final frequency = fund.sipFrequency.trim();
    return _panel([
      (
        'Next SIP date',
        fund.isSipCancelledFlag ? '—' : _date(fund.nextSipDate),
      ),
      (
        'Frequency',
        frequency.isEmpty
            ? '—'
            : (frequency.toLowerCase().endsWith('sip')
                  ? frequency
                  : '$frequency SIP'),
      ),
      (
        'Installments',
        fund.totalInstallments >= 0
            ? '${fund.totalInstallments} completed'
            : '—',
      ),
    ]);
  }

  Widget _panel(List<(String, String)> cells, {VoidCallback? onViewDetails}) =>
      Container(
        constraints: const BoxConstraints(minHeight: 67),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cells.length; i++)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: i == 0
                            ? null
                            : const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Color(0xFFD2D5DA)),
                                ),
                              ),
                        child: Column(
                          children: [
                            Text(
                              cells[i].$1,
                              textAlign: TextAlign.center,
                              style: _text(8, color: _dim),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cells[i].$2,
                              textAlign: TextAlign.center,
                              style: _text(10, weight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (onViewDetails != null) ...[
              const SizedBox(height: 10),
              const Divider(height: 1, color: _line),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.chevron_right, size: 16),
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    'View all details',
                    style: _text(10, weight: FontWeight.w700, color: _purple),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: _purple,
                    padding: const EdgeInsets.only(top: 6),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}

const _purple = Color(0xFF441D9E);
const _dim = Color(0xFF8A8AA0);
const _line = Color(0xFFE4E6EE);

TextStyle _text(
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = const Color(0xFF12121A),
}) => UTextStyles.homeText(
  size: size,
  weight: weight,
  color: color,
  height: 1.5,
  family: FontFamily.plusJakartaSans,
);

String _money(double value, {int decimals = 2}) => value.isFinite
    ? NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: decimals,
      ).format(value)
    : '—';

String _date(String value) {
  final text = value.trim();
  final date = DateTime.tryParse(text);
  return text.isEmpty
      ? '—'
      : (date == null ? text : DateFormat('dd MMM yyyy').format(date));
}
