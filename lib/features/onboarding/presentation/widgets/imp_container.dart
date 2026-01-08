import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

class ImpContainer extends StatelessWidget {
  const ImpContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      height: h * 0.3,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 200),
      padding: EdgeInsets.symmetric(vertical: 20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color.fromRGBO(228, 240, 252, 0.5),
            Color.fromRGBO(190, 224, 255, 0.7),
          ],
        ),
      ),
      child: FittedBox(
        // fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: h * 0.055),
            Image.asset(UImages.imp),
            Text(
              textAlign: TextAlign.center,
              'Your Smart Personal Finance AI',
              style: TextStyle(
                color: Ucolors.dark,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              'Companion UI Kit',
              style: TextStyle(
                color: Ucolors.dark,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            SizedBox(height: h * 0.055),
          ],
        ),
      ),
    );
  }
}
