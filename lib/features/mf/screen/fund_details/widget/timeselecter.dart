import 'package:flutter/material.dart';
import 'package:my_sip/utils/constant/colors.dart';

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({super.key});

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  int selectedIndex = 3;

  final periods = ['1M', '3M', '6M', '1Y', '2Y', '3Y', '5Y'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Ucolors.borderside,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(periods.length, (index) {
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              child: AnimatedContainer(
                
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  periods[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Ucolors.primary
                        : Colors.grey,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
