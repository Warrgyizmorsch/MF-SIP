import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

import '../../../core/utils/enums/enums.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final bool readOnly;
  final Widget? trailing;
  final VoidCallback? onTrailingTap;
  final Widget? leading;
  final VoidCallback? onLeadingTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  final Color borderColor;
  final Color focusedBorderColor;
  final Color labelColor;
  final Color hintColor;
  final Color textColor;
  final Color trailingColor;
  final Color leadingColor;
  final Color bgColor;

  final double labelSize;
  final double hintSize;
  final double textSize;

  final bool enabled;

  /// Completely disables the field when false
  final bool isEnabled;

  final ValidationType validationType;
  final String? validationMessage;
  final int? minLength;
  final int? maxLength;
  final String? Function(String?)? customValidator;

  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  final int minLines;
  final int maxLines;

  final double? height;
  final double? borderRadius;

  final VoidCallback? onHelperTap;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.trailing,
    this.onTrailingTap,
    this.leading,
    this.onLeadingTap,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.borderColor = Colors.grey,
    this.focusedBorderColor = Ucolors.primary,
    this.labelColor = Colors.black,
    this.hintColor = Colors.grey,
    this.textColor = Colors.black,
    this.trailingColor = Colors.black,
    this.leadingColor = Colors.black,
    this.bgColor = Colors.white,
    this.labelSize = 14,
    this.hintSize = 14,
    this.textSize = 16,
    this.enabled = true,
    this.isEnabled = true,
    this.validationType = ValidationType.none,
    this.validationMessage,
    this.minLength,
    this.maxLength,
    this.customValidator,
    this.onChanged,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 1,
    this.onSubmitted,
    this.height = 30,
    this.textInputAction,
    this.borderRadius = 14,
    this.helperText,
    this.readOnly = false,
    this.onHelperTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  // --- FIX START: Updated Validator Logic ---
  String? _validate(String? fieldValue) {
    // Priority: Use Controller text if available, otherwise use FormField value
    // This ensures that if the controller is updated externally (like DatePicker),
    // the validator sees the new value immediately.
    final value = widget.controller?.text ?? fieldValue;

    switch (widget.validationType) {
      case ValidationType.required:
        if (value == null || value.trim().isEmpty) {
          return widget.validationMessage ??
              "${widget.label ?? "This field"} is required";
        }
        break;
      case ValidationType.email:
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (value == null || !emailRegex.hasMatch(value.trim())) {
          return widget.validationMessage ?? "Enter a valid email address";
        }
        break;
      case ValidationType.phone:
        // final phoneRegex = RegExp(r'^[6-9]\d{9}$');
        final phoneRegex = RegExp(r'^\d{10}$');
        // if (value == null || !phoneRegex.hasMatch(value.trim())) {
        //   return widget.validationMessage ??
        //       "Enter a valid 10 digit phone number";
        // }
        if (value == null || !phoneRegex.hasMatch(value.trim())) {
          return widget.validationMessage ??
              "Enter a valid 10 digit phone number";
        }
        break;
      case ValidationType.minLength:
        if (widget.minLength != null &&
            (value == null || value.length < widget.minLength!)) {
          return widget.validationMessage ??
              "Must be at least ${widget.minLength} characters";
        }
        break;
      case ValidationType.maxLength:
        if (widget.maxLength != null &&
            (value != null && value.length > widget.maxLength!)) {
          return widget.validationMessage ??
              "Must not exceed ${widget.maxLength} characters";
        }
        break;
      case ValidationType.custom:
        if (widget.customValidator != null) {
          return widget.customValidator!(value);
        }
        break;
      case ValidationType.none:
      default:
        return null;
    }
    return null;
  }
  // --- FIX END ---

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: _validate,
      // Ensure initial value syncs with controller
      initialValue: widget.controller?.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> field) {
        // --- FIX START: Sync Controller with Field State ---
        // If the controller text differs from the field state (e.g. DatePicker update),
        // update the field state silently so validation passes.
        if (widget.controller != null &&
            widget.controller!.text != field.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (field.mounted) {
              field.didChange(widget.controller!.text);
            }
          });
        }
        // --- FIX END ---

        EdgeInsets contentPadding = widget.height != null
            ? EdgeInsets.symmetric(
                vertical: (widget.height! - widget.textSize) / 2 - 8,
                horizontal: 12,
              )
            : const EdgeInsets.symmetric(vertical: 12, horizontal: 12);

        if (widget.trailing != null || widget.obscureText) {
          contentPadding = contentPadding.copyWith(right: 0);
        }

        final String? displayedError = widget.errorText ?? field.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: widget.borderRadius != null
                    ? BorderRadius.circular(widget.borderRadius!)
                    : null,
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  AbsorbPointer(
                    absorbing: !widget.isEnabled,
                    child: TextFormField(
                      readOnly: widget.readOnly,
                      maxLength: widget.maxLength,
                      focusNode: widget.focusNode,
                      controller: widget.controller,
                      obscureText: _obscure,
                      keyboardType:
                          widget.keyboardType ??
                          (widget.maxLines > 1
                              ? TextInputType.multiline
                              : TextInputType.text),
                      inputFormatters: widget.inputFormatters,
                      enabled: widget.enabled && widget.isEnabled,
                      onFieldSubmitted: widget.isEnabled
                          ? widget.onSubmitted
                          : null,
                      textInputAction: widget.textInputAction,
                      style: AppTextStyles.bodyMedium(),
                      minLines: widget.minLines,
                      maxLines: widget.obscureText ? 1 : widget.maxLines,

                      // --- FIX: Sync changes back to FormField State ---
                      onChanged: widget.isEnabled
                          ? (value) {
                              field.didChange(value);
                              widget.onChanged?.call(value);
                            }
                          : null,

                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: contentPadding.copyWith(right: 10),
                        labelText: widget.label,
                        labelStyle: TextStyle(
                          color: widget.labelColor,
                          fontSize: widget.labelSize,
                        ),
                        helper: widget.helperText != null
                            ? InkWell(
                                onTap: widget.onHelperTap,
                                child: Text(
                                  widget.helperText!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: widget.onHelperTap != null
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade600,
                                    decoration: widget.onHelperTap != null
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              )
                            : null,

                        hintText: widget.hint,
                        hintStyle: TextStyle(
                          color: widget.isEnabled
                              ? widget.hintColor
                              : Colors.grey,
                          fontSize: widget.hintSize,
                        ),

                        // We hide the default error because we render a custom one below
                        errorText: null,
                        errorStyle: const TextStyle(height: 0, fontSize: 0),

                        prefixIcon: widget.leading != null
                            ? GestureDetector(
                                onTap: widget.isEnabled
                                    ? widget.onLeadingTap
                                    : null,
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: widget.leadingColor,
                                    size: 10,
                                  ),
                                  child: widget.leading!,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? 14,
                          ),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? 14,
                          ),
                          borderSide: BorderSide(color: widget.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? 14,
                          ),
                          borderSide: BorderSide(
                            color: widget.focusedBorderColor,
                            width: 2,
                          ),
                        ),
                        // Force the border to turn red if there is an error
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? 14,
                          ),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? 14,
                          ),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? 14,
                          ),
                          borderSide: BorderSide(color: widget.borderColor),
                        ),
                      ),
                    ),
                  ),

                  if (widget.trailing != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                        height: widget.height,
                        child: GestureDetector(
                          onTap: widget.onTrailingTap,
                          behavior: HitTestBehavior.opaque,
                          child: widget.trailing!,
                        ),
                      ),
                    ),

                  if (widget.obscureText)
                    Positioned(
                      right: widget.trailing != null ? 40 : 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: widget.hintColor,
                        ),
                        onPressed: widget.isEnabled
                            ? () => setState(() => _obscure = !_obscure)
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            if (displayedError != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  displayedError,
                  style: const TextStyle(color: Colors.red, fontSize: 10),
                ),
              ),
          ],
        );
      },
    );
  }
}
