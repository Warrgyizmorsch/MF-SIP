import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PeriodSelector extends GetView<FundDetailsController> {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final periods = ['1M', '3M', '6M', '1Y', '2Y', '3Y', '10Y'];
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      height: isDesktop ? 48 : 40,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 8 : 4),
      decoration: BoxDecoration(
        color: isDesktop ? Colors.white : const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 10),
        border: isDesktop ? Border.all(color: Colors.grey.shade200) : null,
        boxShadow: isDesktop
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ]
            : null,
      ),
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(periods.length, (index) {
          final period = periods[index];
          return Obx(() {
            final isSelected = controller.selectedPeriod.value == period;
            return _PeriodButton(
              period: period,
              isSelected: isSelected,
              isDesktop: isDesktop,
              onTap: () {
                controller.getShcemeNavHistory(
                  scchemeCode: controller.schemeCode,
                  period: period,
                );
              },
            );
          });
        }),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(periods.length, (index) {
            final period = periods[index];
            return Obx(() {
              final isSelected =
                  controller.selectedPeriod.value == period;
              return _PeriodButton(
                period: period,
                isSelected: isSelected,
                isDesktop: isDesktop,
                onTap: () {
                  controller.getShcemeNavHistory(
                    scchemeCode: controller.schemeCode,
                    period: period,
                  );
                },
              );
            });
          }),
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String period;
  final bool isSelected;
  final bool isDesktop;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.period,
    required this.isSelected,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: isDesktop ? 4 : 4,
          vertical: isDesktop ? 6 : 0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 20 : 8,
          vertical: isDesktop ? 10 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDesktop ? Ucolors.primary : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(isDesktop ? 18 : 8),
          boxShadow: isSelected && isDesktop
              ? [
            BoxShadow(
              color: Ucolors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
              : isSelected && !isDesktop
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
          period,
          style: TextStyle(
            fontSize: isDesktop ? 14 : 10,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (isDesktop ? Colors.white : Ucolors.primary)
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}