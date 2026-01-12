import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';

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
    // return Ucolors.primary;
    return Colors.black;
  }

  final bool percentage;
  final double? fontSize;
  final Color? color3;
  final Color? color4;
  final Color? color5;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              // PERIOD
              // SizedBox(
              //   width: 40,
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     child: Text(
              //       data.period,
              //       style: TextStyle(
              //         // fontSize: 16,
              //         fontWeight: FontWeight.w400,
              //         // color: Colors.blue,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: width ?? 40, // IMPORTANT: enough for "Step-up SIP"
                child: Text(
                  data.period,
                  textAlign: TextAlign.center,
                  // maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // fontSize: fontSize ?? 14,
                    fontWeight: FontWeight.w500,
                    // height: 1.3, // controls line spacing
                    color: Colors.black,
                  ),
                ),
              ),

              // SCHEME
              // Expanded(
              //   child: Text(
              //     percentage
              //         ? '${data.scheme.toStringAsFixed(2)}%'
              //         : '${data.scheme.toString()}',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: fontSize,
              //       color: _valueColor(data.scheme),
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
              Expanded(
                child: Text(
                  percentage
                      ? '${data.scheme.toStringAsFixed(2)}%'
                      : formatIndianNumber(data.scheme.toDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: _valueColor(data.scheme),
                    fontWeight: FontWeight.w400,
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
                    fontSize: fontSize,

                    // color: _valueColor(data.category),
                    color: color3 ?? _valueColor(data.category),
                    fontWeight: FontWeight.w400,
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
                    fontSize: fontSize,

                    // color: _valueColor(data.benchmark),
                    color: color4 ?? _valueColor(data.category),

                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (data.extra != null)
                Expanded(
                  child: Text(
                    percentage
                        ? '${data.extra!.toStringAsFixed(2)}%'
                        : formatIndianNumber(data.extra!.toDouble()),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,

                      // color: _valueColor(data.benchmark),
                      color: color5 ?? _valueColor(data.category),

                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Divider(color: Colors.grey.shade200, height: 1),
        DashedLine(color: Colors.grey.shade300, dashSpace: 0),
      ],
    );
  }
}

// String formatIndianNumber(double value) {
//   if (value >= 10000000) {
//     double cr = value / 10000000;
//     return cr % 1 == 0 ? '${cr.toInt()}Cr' : '${cr.toStringAsFixed(2)}Cr';
//   } else if (value >= 100000) {
//     double l = value / 100000;
//     return l % 1 == 0 ? '${l.toInt()}L' : '${l.toStringAsFixed(1)}L';
//   } else {
//     return value.toStringAsFixed(0);
//   }
// }

// String formatIndianNumber(double value) {
//   final indianFormatter = NumberFormat('#,##,###', 'en_IN');

//   if (value >= 10000000) {
//     double cr = value / 10000000;
//     return cr % 1 == 0 ? '${cr.toInt()}Cr' : '${cr.toStringAsFixed(2)}Cr';
//   } else if (value >= 100000) {
//     double l = value / 100000;
//     return l % 1 == 0 ? '${l.toInt()}L' : '${l.toStringAsFixed(1)}L';
//   } else {
//     return indianFormatter.format(value.round());
//   }
// }

// String formatIndianNumber(double value) {
//   final indianFormatter = NumberFormat('#,##,###', 'en_IN');
//   final isNegative = value < 0;
//   final absValue = value.abs();

//   String formatted;

//   if (absValue >= 10000000) {
//     double cr = absValue / 10000000;
//     formatted = cr % 1 == 0 ? '${cr.toInt()}Cr' : '${cr.toStringAsFixed(2)}Cr';
//   } else if (absValue >= 100000) {
//     double l = absValue / 100000;
//     formatted = l % 1 == 0 ? '${l.toInt()}L' : '${l.toStringAsFixed(1)}L';
//   } else {
//     formatted = indianFormatter.format(absValue.round());
//   }

//   return '${isNegative ? '-' : ''}₹$formatted';
// }

String formatIndianNumber(double value) {
  final indianFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  return indianFormatter.format(value);
}
