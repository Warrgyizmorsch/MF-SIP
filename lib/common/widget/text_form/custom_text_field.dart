

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';


class TextFormFieldCustom extends StatelessWidget {
  final Widget method;
  final String title;
  final bool? isRequired;
  final Color? hintTextColor;
  final String? hintTextStyle;
  final double? hintTextSize;
  final double? borderWidth;
  final double? height;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool showTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const TextFormFieldCustom({
    super.key,
    required this.method,
    this.title = "",
    this.isRequired,
    this.hintTextStyle,
    this.hintTextSize,
    this.hintTextColor,
    this.borderColor,
    this.height,
    this.borderWidth,
    this.backgroundColor,
    this.padding,
    this.showTitle = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (showTitle && title.isNotEmpty)
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: hintTextSize ?? 14,
                    color: hintTextColor ?? Ucolors.primary,
                    fontFamily: hintTextStyle ?? UTextStyles.font,
                  ),
                ).paddingOnly(left: 5, bottom: 5),
                isRequired==true?
                Text(
                  "*",
                  style: TextStyle(
                    fontSize: hintTextSize ?? 14,
                    color:  Ucolors.red,
                    fontFamily: UTextStyles.font,
                  ),
                ).paddingOnly(left: 5, ):SizedBox.shrink(),
              ],
            ),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 1.0,
              ),
            ),
            child: method,
          ),
        ],
      ),
    );
  }
}
class UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = "";

    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 6) {
      formatted = "(${digits.substring(0, 3)}) ${digits.substring(3)}";
    } else if (digits.length <= 10) {
      formatted =
      "(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}";
    } else {
      formatted =
      "(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6, 10)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class TextFieldCustom extends StatelessWidget {
  Widget? suffixIcon;
  Widget? prefixIcon;
  Function()? onEditingComplete;
  Function()? onTap;
  int? maxLine;
  String? hintText;
  String? errorText;
  bool? obscureText;
  bool? readOnly;
  double? width;
  double? height;
  int? maxLines;
  int? maxLength;
  List<TextInputFormatter>? inputFormatters;
  String? fieldName;
  String? Function(String?)? validator;
  String? Function(String?)? onChanged;
  TextEditingController? controller;
  TextInputType? textInputType;
  TextInputAction? textInputAction;
  AutovalidateMode? autovalidateMode;
  Color? hintTextColor;
  String? hintTextStyle;
  double? hintTextSize;
  Color? borderColor;
  double? borderWidth;
  Color? backgroundColor;
  EdgeInsetsGeometry? contentPadding;
  bool? enabled;
  FocusNode? focusNode;
  Function(String)? onSubmitted;

  TextFieldCustom({
    super.key,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onEditingComplete,
    this.onChanged,
    this.maxLine,
    this.hintText,
    this.errorText,
    this.obscureText,
    this.readOnly,
    this.maxLines,
    this.width,
    this.height,
    this.inputFormatters,
    this.fieldName,
    this.validator,
    this.textInputType,
    this.textInputAction,
    this.controller,
    this.maxLength,
    this.autovalidateMode,
    this.hintTextColor,
    this.hintTextStyle,
    this.hintTextSize,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.contentPadding,
    this.enabled,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        autovalidateMode: autovalidateMode,
        onTap: onTap,
        controller: controller,
        obscureText: obscureText ?? false,
        validator: validator,
        maxLines: (obscureText ?? false) ? 1 : maxLines,
        cursorColor: Ucolors.primary,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        readOnly: readOnly ?? false,
        inputFormatters: inputFormatters ?? [],
        maxLength: maxLength,
        enabled: enabled ?? true,
        focusNode: focusNode,
        onFieldSubmitted: onSubmitted,
        style: TextStyle(
          fontSize: hintTextSize ?? 15,
          fontFamily: hintTextStyle ??UTextStyles.font,
          color: Ucolors.darkgrey,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          errorText: errorText,
          counterText: "",
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          errorStyle: TextStyle(
            fontSize: 12,
            fontFamily: UTextStyles.font,
            color: Ucolors.red
          ),
          hintStyle: TextStyle(
            color: hintTextColor ??Ucolors.darkgrey,
            fontSize: hintTextSize ?? 14,
            fontFamily: hintTextStyle ?? UTextStyles.font,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:  borderColor ?? Colors.transparent,
              width: borderWidth ?? 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Ucolors.red,
              width: borderWidth ?? 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:Ucolors.red,
              width: borderWidth ?? 1.0,
            ),
          ),
          filled: true,
          fillColor: backgroundColor ?? Colors.white,
        ),
      ),
    );
  }
}