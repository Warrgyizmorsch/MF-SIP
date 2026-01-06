import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class CompactIcon extends StatelessWidget {
  const CompactIcon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor, this.iconSize,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      radius: 18,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(icon, size: iconSize?? 25, color: iconColor ?? Ucolors.dark),
      ),
    );
  }
}
