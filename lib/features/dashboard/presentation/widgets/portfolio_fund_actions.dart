import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../domain/entity/portfolio_entity.dart';

/// Shared by the mobile footer and desktop actions card.
class PortfolioFundActions extends StatefulWidget {
  const PortfolioFundActions({
    super.key,
    required this.fund,
    required this.onCancelSip,
    required this.onRedeem,
    this.isRefreshing = false,
  });

  final MfuPortfolioItemEntity fund;
  final Future<void> Function() onCancelSip;
  final Future<void> Function() onRedeem;
  final bool isRefreshing;

  @override
  State<PortfolioFundActions> createState() => _PortfolioFundActionsState();
}

class _PortfolioFundActionsState extends State<PortfolioFundActions> {
  bool _busy = false;
  bool _cancelling = false;

  Future<void> _run({required bool cancel}) async {
    if (_busy || widget.isRefreshing) return;
    setState(() {
      _busy = true;
      _cancelling = cancel;
    });
    try {
      await (cancel ? widget.onCancelSip() : widget.onRedeem());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAct = !_busy && !widget.isRefreshing;
    final cancel = _button(
      label: widget.fund.hasPendingSipCancellation
          ? 'Cancellation pending'
          : 'Cancel SIP',
      cancel: true,
      onPressed: canAct && !widget.fund.hasPendingSipCancellation
          ? () => _run(cancel: true)
          : null,
    );
    final redeem = _button(
      label: widget.fund.isPartiallyRedeemed ? 'Redeem Remaining' : 'Redeem',
      cancel: false,
      onPressed: canAct ? () => _run(cancel: false) : null,
    );

    if (!widget.fund.isSipActive) return redeem;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Longer labels and accessibility text use a vertical layout.
        final stack =
            constraints.maxWidth < 340 ||
            MediaQuery.textScalerOf(context).scale(16) > 20 ||
            widget.fund.hasPendingSipCancellation ||
            widget.fund.isPartiallyRedeemed;
        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [cancel, const SizedBox(height: 12), redeem],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cancel),
              const SizedBox(width: 18),
              Expanded(child: redeem),
            ],
          ),
        );
      },
    );
  }

  Widget _button({
    required String label,
    required bool cancel,
    required VoidCallback? onPressed,
  }) {
    const red = Color(0xFFFF383C);
    final busy = _busy && _cancelling == cancel;
    final foreground = cancel ? red : Colors.white;
    final enabled = onPressed != null || busy;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cancel ? const Color(0x0FFF383C) : null,
          gradient: cancel
              ? null
              : const LinearGradient(
                  // CSS 163.16-degree gradient at the reference 185 x 56 size.
                  begin: Alignment(-0.168, -1.83),
                  end: Alignment(0.168, 1.83),
                  colors: [Ucolors.homeHeaderEnd, Color(0xFF5B3FE0)],
                ),
          borderRadius: BorderRadius.circular(999),
          border: cancel ? Border.all(color: const Color(0x33FF383C)) : null,
          boxShadow: cancel
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x617C5CFF),
                    blurRadius: 15,
                    offset: Offset(0, 12),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(999),
            child: Semantics(
              button: true,
              enabled: onPressed != null,
              label: busy ? '$label, please wait' : label,
              excludeSemantics: true,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (busy) ...[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: foreground,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ] else if (cancel) ...[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/portfolio/figma/cancel.svg',
                              width: 11.6,
                              height: 11.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: UTextStyles.homeText(
                            family: FontFamily.plusJakartaSans,
                            size: 16,
                            weight: FontWeight.w700,
                            color: foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
