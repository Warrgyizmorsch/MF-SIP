import 'package:flutter/material.dart';
import 'package:my_sip/features/mf/screen/fund_details/fund_deatails.dart';
import 'package:my_sip/features/mf/screen/fund_details/widget/model/return_model.dart';

class ReturnsTableRow extends StatelessWidget {
  final ReturnRow data;

  const ReturnsTableRow({super.key, required this.data});

  Color _valueColor(double value) {
    if (value < 0) return Colors.red;
    return Colors.green;
  }

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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),

              // SCHEME
              Expanded(
                child: Text(
                  '${data.scheme.toStringAsFixed(2)}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _valueColor(data.scheme),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // CATEGORY
              Expanded(
                child: Text(
                  '${data.category.toStringAsFixed(2)}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _valueColor(data.category),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // BENCHMARK
              Expanded(
                child: Text(
                  '${data.benchmark.toStringAsFixed(2)}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
