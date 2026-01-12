import 'package:flutter/material.dart';

import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/helper/helpers.dart';

class SipAmountSelector extends StatelessWidget {
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
    this.label = ""
  });

  // Helper to handle increment/decrement safely
  void _updateAmount(double newVal) {
    if (newVal < minAmount) return;
    onChanged(newVal);
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label.isNotEmpty)
          Text(
            label,

            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                priceFormatter.format(amount),
                style: AppTextStyles.bodyLarge(size: 28),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _updateAmount(amount + step),
                    child: const Align(
                      heightFactor: 0.4,
                      child: Icon(Icons.arrow_drop_up, size: 40, color: Colors.grey),
                    ),
                  ),
                  InkWell(
                    onTap: () => _updateAmount(amount - step),
                    child: const Align(
                      heightFactor: 0.4,
                      child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.grey),
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


class AmountChipList extends StatelessWidget {
  final List<double> amountList = const [1000, 2000, 5000, 10000];
  final ValueChanged<double> onSelected;

  const AmountChipList({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: amountList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final amt = amountList[index];
          return GestureDetector(
            onTap: () => onSelected(amt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                "+${priceFormatter.format(amt)}",
                style: AppTextStyles.bodySmall(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}