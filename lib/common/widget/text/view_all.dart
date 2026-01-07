import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
class USectionHeading extends StatelessWidget {
  const USectionHeading({
    super.key,
    required this.title,
    this.buttonTitle = 'View all',
    this.onPressed,
    this.showActionButton = true,
    this.fontSize,
    this.fontWeight,
    this.textcolor,
  });

  final String title, buttonTitle;
  final void Function()? onPressed;
  final bool showActionButton;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textcolor;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize ?? (Get.width * 0.045).clamp(16, 20),
            fontWeight: fontWeight ?? FontWeight.w500,
            color: textcolor ?? Ucolors.dark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonTitle,
              style: TextStyle(color: Color(0xff8A8990)),
            ),
          ),
      ],
    );
  }
}
