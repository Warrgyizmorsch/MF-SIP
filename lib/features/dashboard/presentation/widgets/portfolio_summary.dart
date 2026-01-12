import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class PortfolioSummary extends StatelessWidget {
  const PortfolioSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(
              '₹77.68K',
              style: UTextStyles.heading1.copyWith(
                // color: Ucolors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24,

                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Color(0xFF0280C0), Color(0xFF013C5A)],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 0)),
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: [
                Icon(
                  Icons.arrow_drop_up_outlined,
                  color: Ucolors.success,

                  // size: 11,
                ),
                Text(
                  '+15.06%',
                  style: UTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: Ucolors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: Get.height * 0.008),
        // SizedBox(height: 10),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: summaryItem('Total Invested', '₹62.00K')),
            Expanded(
              child: summaryItem(
                'Our Suggested Funds',
                '₹82.23K',
                isGreen: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: summaryItem('Current Value', '₹77.68K')),
            Expanded(child: summaryItem('Growth', '23.01%', isGreen: true)),
          ],
        ),
      ],
    );
  }

  Widget summaryItem(String title, String value, {bool isGreen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          maxLines: 1,
          title,
          style: UTextStyles.subtitle2.copyWith(fontWeight: FontWeight.w500),
        ),
        Text(
          maxLines: 1,
          value,
          style: UTextStyles.subtitle2.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isGreen ? Ucolors.success : Color(0xff025864),
          ),
        ),
      ],
    );
  }
}
