import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class InvestValue extends StatelessWidget {
  const InvestValue({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  final String title;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: UTextStyles.caption),
          Text(
            '₹ $value',
            style: UTextStyles.medium.copyWith(
              fontWeight: FontWeight.w600,
              // color: Ucolors.dark,
              // color: Ucolors.primary,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
