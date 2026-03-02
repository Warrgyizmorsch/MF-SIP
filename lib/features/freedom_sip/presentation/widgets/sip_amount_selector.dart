import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/sip_process/presentation/controllers/sip_process_controller.dart';

import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/helper/helpers.dart';

import 'package:flutter/services.dart';

class SipAmountSelector extends StatefulWidget {
  final String label;
  final double amount;
  final ValueChanged<double> onChanged;
  final double step;
  final double minAmount;

  const SipAmountSelector({
    super.key,
    required this.amount,
    required this.onChanged,
    this.step = 1000,
    this.minAmount = 500,
    this.label = "",
  });

  @override
  State<SipAmountSelector> createState() => _SipAmountSelectorState();
}

class _SipAmountSelectorState extends State<SipAmountSelector> {
  late TextEditingController _controller;
  late double _currentAmount;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.amount;
    // Initialize the text field with the starting amount
    _controller = TextEditingController(
      text: _currentAmount.toStringAsFixed(0),
    );
  }

  @override
  void didUpdateWidget(covariant SipAmountSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent controller updates the amount (e.g., switching SIP/Lumpsum),
    // sync the local text field.
    if (widget.amount != oldWidget.amount) {
      _currentAmount = widget.amount;
      if (double.tryParse(_controller.text) != _currentAmount) {
        _controller.text = _currentAmount.toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Handle the Up/Down Arrows
  void _updateAmount(double newVal) {
    if (newVal < widget.minAmount) return;

    setState(() {
      _currentAmount = newVal;
      _controller.text = _currentAmount.toStringAsFixed(0);
      // Keep cursor at the end of the text
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });

    widget.onChanged(_currentAmount);
  }

  // Handle Manual Typing
  void _onTextChanged(String value) {
    // If the user clears the field, temporarily treat it as 0 to allow typing
    if (value.isEmpty) {
      widget.onChanged(0);
      return;
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      setState(() {
        _currentAmount = parsedValue;
      });
      // Note: We don't enforce minAmount here immediately to allow the user
      // to delete "500" and type "1000" naturally without it snapping back.
      widget.onChanged(_currentAmount);
    }
  }

  // Optional: Handle when the user clicks "Done" on the keyboard
  void _onSubmitted(String value) {
    final parsedValue = double.tryParse(value) ?? widget.minAmount;
    if (parsedValue < widget.minAmount) {
      _updateAmount(widget.minAmount);
    } else {
      _updateAmount(parsedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ), // Adjusted vertical padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: Row(
            children: [
              // Rupee Symbol prefix
              Text("₹ ", style: AppTextStyles.bodyLarge(size: 28)),
              // Typeable Input Field
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: _onTextChanged,
                  onSubmitted: _onSubmitted,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTextStyles.bodyLarge(size: 28),
                ),
              ),
              // Stepper Arrows
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _updateAmount(_currentAmount + widget.step),
                    child: const Align(
                      heightFactor: 0.6, // Adjusted for better touch targets
                      child: Icon(
                        Icons.arrow_drop_up,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _updateAmount(_currentAmount - widget.step),
                    child: const Align(
                      heightFactor: 0.6, // Adjusted for better touch targets
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class SipAmountSelector extends StatelessWidget {
//   final String label;
//   final double amount;
//   final ValueChanged<double> onChanged;
//   final double step;
//   final double minAmount;

//   const SipAmountSelector({
//     super.key,
//     required this.amount,
//     required this.onChanged,
//     this.step = 1000,
//     this.minAmount = 500,
//     this.label = "",
//   });

//   // Helper to handle increment/decrement safely
//   void _updateAmount(double newVal) {
//     if (newVal < minAmount) return;
//     onChanged(newVal);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label.isNotEmpty)
//           Text(
//             label,

//             style: Theme.of(
//               context,
//             ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
//           ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15.0),
//             border: Border.all(color: Colors.grey.shade300, width: 1.0),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 priceFormatter.format(amount),
//                 style: AppTextStyles.bodyLarge(size: 28),
//               ),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     onTap: () => _updateAmount(amount + step),
//                     child: const Align(
//                       heightFactor: 0.4,
//                       child: Icon(
//                         Icons.arrow_drop_up,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => _updateAmount(amount - step),
//                     child: const Align(
//                       heightFactor: 0.4,
//                       child: Icon(
//                         Icons.arrow_drop_down,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class AmountChipList extends StatelessWidget {
  final List<double> customAmounts; // Added this
  final ValueChanged<double> onSelected;

  const AmountChipList({
    super.key,
    required this.onSelected,
    required this.customAmounts, // Added this
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: customAmounts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final amt = customAmounts[index];
          return GestureDetector(
            onTap: () => onSelected(amt),
            child: Container(
              // ... your existing decoration ...
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                // Show as total amount for Lumpsum, or +amount for SIP
                Get.find<SipProcessController>().isLumpsum.value
                    ? priceFormatter.format(amt)
                    : "+${priceFormatter.format(amt)}",
                style: AppTextStyles.bodySmall(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}


// class AmountChipList extends StatelessWidget {
//   final List<double> amountList = const [1000, 2000, 5000, 10000];
//   final ValueChanged<double> onSelected;

//   const AmountChipList({super.key, required this.onSelected});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 36,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: amountList.length,
//         separatorBuilder: (context, index) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           final amt = amountList[index];
//           return GestureDetector(
//             onTap: () => onSelected(amt),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF3F4F6),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: const Color(0xFFE5E7EB)),
//               ),
//               child: Text(
//                 "+${priceFormatter.format(amt)}",
//                 style: AppTextStyles.bodySmall(color: Colors.grey),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }