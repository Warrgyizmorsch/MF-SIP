import 'package:flutter/material.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';

class ReturnsTableRow extends StatelessWidget {
  final ReturnRow data;

  const ReturnsTableRow({
    super.key,
    required this.data,
    this.percentage = true,
    this.fontSize,
  });

  Color _valueColor(double value) {
    if (value < 0) return Colors.red;
    // return Colors.green;
    return Colors.black;
  }

  final bool percentage;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              // PERIOD
              SizedBox(
                width: 40,
                child: Text(
                  data.period,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    // color: Colors.blue,
                    color: Colors.black,
                  ),
                ),
              ),

              // SCHEME
              Expanded(
                child: Text(
                  percentage
                      ? '${data.scheme.toStringAsFixed(2)}%'
                      : data.scheme.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: _valueColor(data.scheme),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // CATEGORY
              Expanded(
                child: Text(
                  percentage
                      ? '${data.category.toStringAsFixed(2)}%'
                      : data.category.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,

                    color: _valueColor(data.category),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // BENCHMARK
              Expanded(
                child: Text(
                  percentage
                      ? '${data.benchmark.toStringAsFixed(2)}%'
                      : data.benchmark.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,

                    color: _valueColor(data.benchmark),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (data.extra != null)
                Expanded(
                  child: Text(
                    percentage
                        ? '${data.extra!.toStringAsFixed(2)}%'
                        : data.extra.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,

                      color: _valueColor(data.benchmark),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Divider(color: Colors.grey.shade200, height: 1),
        DashedLine(color: Colors.grey.shade200),
      ],
    );
  }
}
