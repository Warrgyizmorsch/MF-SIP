import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../domain/entity/portfolio_entity.dart';

class PortfolioTransactionsSection extends StatefulWidget {
  const PortfolioTransactionsSection({super.key, required this.fund});

  final MfuPortfolioItemEntity fund;

  @override
  State<PortfolioTransactionsSection> createState() =>
      _PortfolioTransactionsSectionState();
}

class _PortfolioTransactionsSectionState
    extends State<PortfolioTransactionsSection> {
  static const _collapsedCount = 3;
  bool _expanded = true;

  @override
  void didUpdateWidget(covariant PortfolioTransactionsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.fund;
    final current = widget.fund;
    if (previous.schemeCode != current.schemeCode ||
        previous.folioNo != current.folioNo ||
        previous.mfuOrderFundId != current.mfuOrderFundId ||
        previous.mfuOrderId != current.mfuOrderId) {
      _expanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.fund.transactions;
    final canCollapse = transactions.length > _collapsedCount;
    final visibleCount = _expanded || !canCollapse
        ? transactions.length
        : _collapsedCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVITY',
                      style: _text(
                        9,
                        weight: FontWeight.w700,
                        color: _dim,
                      ).copyWith(letterSpacing: 0.9),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Transaction Details',
                      style: _text(17, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EAF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${transactions.length} ${transactions.length == 1 ? 'entry' : 'entries'}',
                  style: _text(9, color: Ucolors.homeTextSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        if (transactions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'No transactions yet',
              textAlign: TextAlign.center,
              style: _text(12, color: _dim),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: visibleCount,
            separatorBuilder: (_, index) => const SizedBox(height: 9),
            itemBuilder: (_, index) => _TransactionCard(
              key: ValueKey('${transactions[index].id}:$index'),
              transaction: transactions[index],
            ),
          ),
        if (canCollapse)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Align(
              alignment: Alignment.center,
              child: Semantics(
                expanded: _expanded,
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEFEBF7),
                    foregroundColor: _purple,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _expanded
                        ? 'Show fewer transactions'
                        : 'Show more transactions',
                    style: _text(10, weight: FontWeight.w700, color: _purple),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({super.key, required this.transaction});

  final MfuFundTransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final data = _TransactionPresentation(transaction);
    return Semantics(
      container: true,
      label: transaction.direction.trim().isEmpty
          ? null
          : '${transaction.direction} transaction',
      child: Container(
        constraints: const BoxConstraints(minHeight: 104),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(18),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _column(data.date, 'Transaction date', data.nav, 'NAV'),
              ),
              Expanded(
                child: _column(
                  data.type,
                  'Transaction type',
                  data.units,
                  'Units',
                  divider: true,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: Color(0xFFD2D5DA))),
                  ),
                  child: Column(
                    children: [
                      Text(
                        data.amount,
                        textAlign: TextAlign.center,
                        style: _text(
                          11,
                          weight: FontWeight.w700,
                          color: transaction.isDebit ? _negative : _valueBlue,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text('Amount', style: _text(8, color: _dim)),
                      const SizedBox(height: 9),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: data.statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          data.status,
                          textAlign: TextAlign.center,
                          style: _text(
                            9,
                            weight: FontWeight.w700,
                            color: data.statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.statusCaption,
                        textAlign: TextAlign.center,
                        style: _text(8, color: Ucolors.homeTextSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _column(
    String primary,
    String label,
    String secondary,
    String secondaryLabel, {
    bool divider = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9),
    decoration: divider
        ? const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFFD2D5DA))),
          )
        : null,
    child: Column(
      children: [
        Text(
          primary,
          textAlign: TextAlign.center,
          style: _text(11, weight: FontWeight.w700, color: _valueBlue),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: _text(8, color: _dim),
        ),
        const SizedBox(height: 9),
        Text(
          secondary,
          textAlign: TextAlign.center,
          style: _text(12, weight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          secondaryLabel,
          textAlign: TextAlign.center,
          style: _text(8, color: Ucolors.homeTextSecondary),
        ),
      ],
    ),
  );
}

class _TransactionPresentation {
  _TransactionPresentation(this.transaction);
  final MfuFundTransactionEntity transaction;

  late final List<String> _statuses = [
    transaction.statusLabel,
    transaction.orderStatusLabel,
    transaction.status,
    transaction.orderStatus,
  ].map((value) => value.trim()).where((value) => value.isNotEmpty).toList();
  bool _failure(String value) =>
      value.toLowerCase().contains('fail') ||
      value.toLowerCase().contains('reject');
  late final bool _isFailure = _statuses.any(_failure);
  late final bool _isCancelled = _statuses.any(
    (value) => value.toLowerCase().contains('cancel'),
  );
  bool get _isSuccess => !_isFailure && !_isCancelled && transaction.isSuccess;

  String get date {
    final value = transaction.displayDate.trim().isNotEmpty
        ? transaction.displayDate.trim()
        : transaction.date.trim();
    final parsed = DateTime.tryParse(value);
    return value.isEmpty
        ? '—'
        : (parsed == null ? value : DateFormat('dd MMM yyyy').format(parsed));
  }

  String get type {
    final value = transaction.type.trim().isNotEmpty
        ? transaction.type.trim()
        : transaction.investmentType.trim();
    if (value.isNotEmpty) {
      return value.toLowerCase() == 'sip' ? 'SIP' : value;
    }
    if (transaction.isDebit) {
      return 'Redemption';
    }
    if (transaction.isCredit) {
      return 'Purchase / SIP';
    }
    return 'Transaction';
  }

  String get amount => transaction.displayAmount.trim().isNotEmpty
      ? transaction.displayAmount.trim()
      : _money(transaction.amount);
  String get nav => transaction.nav > 0 ? _money(transaction.nav) : '—';
  String get units => transaction.displayUnits.trim().isNotEmpty
      ? transaction.displayUnits.trim()
      : (transaction.units.isFinite
            ? transaction.units.toStringAsFixed(3)
            : '—');

  String get status {
    // Explicit failure/cancellation text takes precedence over a conflicting
    // success code. These are display labels; domain transaction state is unchanged.
    if (_isFailure) {
      return _statuses.firstWhere(_failure);
    }
    if (_isCancelled) {
      return _statuses.firstWhere(
        (value) => value.toLowerCase().contains('cancel'),
      );
    }
    if (transaction.statusLabel.trim().isNotEmpty) {
      return transaction.statusLabel.trim();
    }
    if (transaction.orderStatusLabel.trim().isNotEmpty) {
      return transaction.orderStatusLabel.trim();
    }
    if (_isSuccess) {
      return 'Settled';
    }
    return _statuses.isEmpty ? '—' : _statuses.first;
  }

  String get statusCaption {
    if (_isFailure) {
      return 'Unsuccessful';
    }
    if (_isCancelled) {
      return 'Cancelled';
    }
    final label = transaction.orderStatusLabel.trim();
    if (label.isNotEmpty && label.toLowerCase() != status.toLowerCase()) {
      return label;
    }
    return _isSuccess ? 'Successful' : 'Transaction status';
  }

  Color get statusColor {
    if (_isFailure) {
      return _negative;
    }
    if (_isCancelled || _statuses.isEmpty) {
      return _dim;
    }
    return _isSuccess ? Ucolors.homePositive : const Color(0xFFD97706);
  }
}

const _purple = Color(0xFF441D9E);
const _dim = Color(0xFF8A8AA0);
const _line = Color(0xFFE4E6EE);
const _valueBlue = Color(0xFF2552E6);
const _negative = Color(0xFFFF383C);

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

String _money(double value) => value.isFinite
    ? NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 2,
      ).format(value)
    : '—';
