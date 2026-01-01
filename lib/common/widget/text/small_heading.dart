import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/utils/constant/colors.dart';

class SmallHeading extends StatelessWidget {
  const SmallHeading({super.key, required this.smallheading, this.fontsize});

  final String smallheading;
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    return Text(
      // textAlign: TextAlign.justify,
      smallheading,
      style: TextStyle(
        color: Ucolors.darkgrey,
        fontSize: fontsize ?? (Get.width * 0.035).clamp(12, 14),
      ),
    );
  }
}
