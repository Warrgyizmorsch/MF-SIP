import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({
    super.key,
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    this.heading5,
    this.width,
  });

  final String heading1;
  final String heading2;
  final String heading3;
  final String heading4;
  final String? heading5;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: width ?? 40,
            child: Text(
              heading1,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              heading2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              heading3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              heading4,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          if (heading5 != null)
            Expanded(
              child: Text(
                heading5!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TableHeader2 extends StatelessWidget {
  const TableHeader2({
    super.key,
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    this.heading5,
  });

  final String heading1;
  final String heading2;
  final String heading3;
  final String heading4;
  final String? heading5;

  @override
  Widget build(BuildContext context) {
    const double colYear = 50;
    const double colWithdrawn = 120;
    const double colProfit = 120;
    const double colRemaining = 140;
    const double colExtra = 120;

    return Container(
      color: Colors.white, // important for pinned effect
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: colYear, child: _headerText(heading1)),
          SizedBox(width: colWithdrawn, child: _headerText(heading2)),
          SizedBox(width: colProfit, child: _headerText(heading3)),
          SizedBox(width: colRemaining, child: _headerText(heading4)),
          if (heading5 != null)
            SizedBox(width: colExtra, child: _headerText(heading5!)),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}
