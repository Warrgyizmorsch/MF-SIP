import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

class UTextFormField extends StatelessWidget {
  const UTextFormField({
    super.key,
    this.labelText,
    this.hintText,

    required this.prefixIcon,
    this.sufixIcon,
    this.keyboardType,
    this.controller,
    this.maxLines = 1,
    this.suffix,
    this.readOnly = false,
  });

  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? sufixIcon;
  final TextEditingController? controller;
  final Widget? suffix;
  final bool readOnly;

  final int maxLines;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.065,
      child: TextFormField(
        
        readOnly: readOnly,

        controller: controller,
        maxLines: maxLines,

        // enabled: false,
        keyboardType: keyboardType,

        decoration: InputDecoration(
          // visualDensity: VisualDensity(vertical: 1),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Ucolors.darkgrey,
            fontSize: (Get.width * 0.035).clamp(12, 14),
          ),
          floatingLabelStyle: TextStyle(color: Ucolors.textFormEnabled),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Ucolors.darkgrey.withOpacity(0.8),
            fontSize: (Get.width * 0.035).clamp(12, 14),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey)
              : null,
          suffixIcon: sufixIcon != null
              ? IconButton(
                  icon: Icon(sufixIcon, color: Ucolors.darkgrey),
                  onPressed: () {},
                )
              : null,
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            // vertical: 0,
            // horizontal: 16,
          ),
          suffix: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(
              color: Ucolors.textFormEnabled,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
  
}
