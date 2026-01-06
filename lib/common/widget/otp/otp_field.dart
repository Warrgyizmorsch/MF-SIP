import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:pinput/pinput.dart';

class SimpleOtpField extends StatelessWidget {
  final int length;
  final Function(String)? onCompleted;

  const SimpleOtpField({super.key, this.length = 6, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Ucolors.light,
        border: Border.all(color: Ucolors.borderColor),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Ucolors.light,
        border: Border.all(color: Ucolors.primary, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    return Pinput(
      length: length,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: defaultPinTheme,
      onCompleted: onCompleted,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autofocus: false,
    );
  }
}
