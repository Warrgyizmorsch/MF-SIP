import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';

class PeriodSelector extends GetView<FundDetailsController> {
  const PeriodSelector({super.key});

  

  @override
  Widget build(BuildContext context) {
    final periods = ['1W', '1M', '3M', '6M', '1Y', '2Y', '3Y', '5Y', '10Y'];
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(periods.length, (index) {
            final period= periods[index];

            return Obx(() {
              
              final isSelected= controller.selectedPeriod.value ==period ;
              return GestureDetector(
                onTap: () {
                  // setState(() => selectedIndex = index);
                  controller.getShcemeNavHistory(
                    scchemeCode: controller.schemeCode,
                    period: period,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,

                  ),
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Ucolors.primary : Colors.grey,
                    ),
                  ),
                ),
              );
            }
            );
          }),
        ),
      ),
    );
  }
}
