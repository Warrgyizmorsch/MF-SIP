import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/features/fund_details/data/models/return_model.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../pages/fund_deatails.dart';

class ReturnsTableRow extends StatelessWidget {
  final ReturnRow data;

  const ReturnsTableRow({
    super.key,
    required this.data,
    this.percentage = true,
    this.fontSize,
    this.color3,
    this.color4,
    this.color5,
    this.width,
  });

  Color _valueColor(double value) {
    if (value < 0) return Colors.red;
    return const Color(0xFF22C55E);
  }

  final bool percentage;
  final double? fontSize;
  final Color? color3;
  final Color? color4;
  final Color? color5;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isDesktop ? 18 : 14,
            horizontal: isDesktop ? 12 : 0,
          ),
          child: Row(
            children: [
              // PERIOD
              SizedBox(
                width: width ?? (isDesktop ? 120 : 80),
                child: Text(
                  data.period,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 14 : 12,
                    fontWeight: isDesktop ? FontWeight.w500 : FontWeight.w400,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              // SCHEME
              Expanded(
                child: Text(
                  percentage
                      ? '${data.scheme.toStringAsFixed(2)}%'
                      : formatIndianNumber(data.scheme.toDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? (isDesktop ? 14 : 12),
                    color: _valueColor(data.scheme),
                    fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),

              // CATEGORY
              Expanded(
                child: Text(
                  percentage
                      ? '${data.category.toStringAsFixed(2)}%'
                      : formatIndianNumber(data.category.toDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? (isDesktop ? 14 : 12),
                    color: color3 ?? _valueColor(data.category),
                    fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),

              // BENCHMARK
              Expanded(
                child: Text(
                  percentage
                      ? '${data.benchmark.toStringAsFixed(2)}%'
                      : formatIndianNumber(data.benchmark.toDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? (isDesktop ? 14 : 12),
                    color: color4 ?? _valueColor(data.benchmark),
                    fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),

              // EXTRA (if exists)
              if (data.extra != null)
                Expanded(
                  child: Text(
                    percentage
                        ? '${data.extra!.toStringAsFixed(2)}%'
                        : formatIndianNumber(data.extra!.toDouble()),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize ?? (isDesktop ? 14 : 12),
                      color: color5 ?? _valueColor(data.category),
                      fontWeight: isDesktop ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Divider
        if (isDesktop)
          Divider(
            color: Colors.grey.shade100,
            height: 1,
            thickness: 1,
          )
        else
          DashedLine(color: Colors.grey.shade300, dashSpace: 0),
      ],
    );
  }
}

String formatIndianNumber(double value) {
  final indianFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  return indianFormatter.format(value);
}