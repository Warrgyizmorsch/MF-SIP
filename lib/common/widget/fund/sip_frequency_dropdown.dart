import 'package:flutter/material.dart';

import '../../../core/utils/constant/colors.dart';
import '../../../core/utils/constant/text_style.dart';

enum SipFrequency { daily, weekly, monthly }

extension SipFrequencyX on SipFrequency {
  String get label => switch (this) {
    SipFrequency.daily => 'Daily',
    SipFrequency.weekly => 'Weekly',
    SipFrequency.monthly => 'Monthly',
  };

  /// MFU frequency code for Systematic Transactions
  String get mfuCode => switch (this) {
    SipFrequency.daily => 'D',
    SipFrequency.weekly => 'W',
    SipFrequency.monthly => 'M',
  };

  static SipFrequency fromString(String? val) {
    if (val == null || val.trim().isEmpty) return SipFrequency.monthly;
    final lower = val.trim().toLowerCase();
    if (lower == 'daily' || lower == 'da' || lower == 'd') {
      return SipFrequency.daily;
    }
    if (lower == 'weekly' || lower == 'wk' || lower == 'w') {
      return SipFrequency.weekly;
    }
    return SipFrequency.monthly;
  }
}

/// Option 1: Dropdown pill for fund card frequency selection
class SipFrequencyDropdown extends StatelessWidget {
  final SipFrequency value;
  final ValueChanged<SipFrequency> onChanged;
  final bool enabled;
  final bool hasBorder;

  const SipFrequencyDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButtonHideUnderline(
      child: DropdownButton<SipFrequency>(
        isDense: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        value: value,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 18,
          color: enabled ? Colors.grey.shade700 : Colors.grey.shade400,
        ),
        items: SipFrequency.values.map((freq) {
          final bool isSelected = freq == value;
          return DropdownMenuItem<SipFrequency>(
            value: freq,
            child: Text(
              freq.label,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Ucolors.primary : const Color(0xFF1E293B),
              ),
            ),
          );
        }).toList(),
        onChanged: enabled
            ? (freq) {
                if (freq != null) onChanged(freq);
              }
            : null,
      ),
    );

    if (hasBorder) {
      return Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: enabled ? Colors.white : Colors.grey.shade100,
        ),
        child: dropdown,
      );
    }

    return dropdown;
  }
}
