import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class CreataAccountIfNot extends StatelessWidget {
  const CreataAccountIfNot({
    super.key,
    required this.firstPart,
    required this.textButton,
    this.voidCallback,
  });

  final String firstPart;
  final String textButton;
  final VoidCallback? voidCallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: voidCallback,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Ucolors.dark),
          children: [
            TextSpan(text: firstPart, style: TextStyle(fontSize: 14)),
            TextSpan(
              text: textButton,
              style: const TextStyle(
                color: Ucolors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
