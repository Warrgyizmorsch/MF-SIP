import 'package:flutter/material.dart';

class ThickDivider extends StatelessWidget {
  const ThickDivider({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ]),),
        Container(
          height: 10,
          decoration: BoxDecoration(color: Colors.grey.withAlpha(50)),
        ),
      ],
    );

  }
}