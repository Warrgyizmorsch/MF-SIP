import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.showActionButton = false,
    required this.sectionTitle,
    this.fontSize,
    this.textcolor,
    this.textButton,
    this.hideButton,
    this.fontWeight,
  });

  final bool showActionButton;
  final String sectionTitle;
  final double? fontSize;
  final Color? textcolor;
  final bool? textButton;
  final VoidCallback? hideButton;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        sectionTitle.isEmpty
            ? SizedBox.shrink()
            : Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                sectionTitle,
                style: TextStyle(
                  fontSize: fontSize ?? (Get.width * 0.045).clamp(16, 20),
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: textcolor ?? Ucolors.dark,
                ),
              ),
        // Spacer(),
        if (showActionButton)
          InkWell(onTap: hideButton, child: Icon(Iconsax.eye, size: 20)),
      ],
    );
  }
}
