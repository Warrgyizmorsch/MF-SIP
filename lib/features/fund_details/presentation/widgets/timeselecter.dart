// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/utils/constant/text_style.dart';
import '../../data/models/return_model.dart';
import '../controllers/chartInvestment_controller.dart';

class PeriodSelector extends GetView<FundDetailsController> {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final periods = ['1M', '3M', '6M', '1Y', '2Y', '3Y', 'ALL'];
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      height: isDesktop ? 50 : 40,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 2 : 4),
      decoration: BoxDecoration(
        color: isDesktop ? Colors.white : const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(isDesktop ? 10 : 10),
        border: isDesktop ? Border.all(color: Colors.grey.shade200) : null,
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isDesktop
          ? Container(
              alignment: Alignment.center,
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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

class PeriodSelectorBarChart extends GetView<ChartInvestmentController> {
  final List<ReturnRow> yearlyData;

  const PeriodSelectorBarChart({super.key, required this.yearlyData});

  @override
  Widget build(BuildContext context) {
    final periods = yearlyData.map((e) => e.period).toList();

    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Container(
      height: isDesktop ? 60 : 42,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 4, vertical: 4),
      decoration: BoxDecoration(
        color: isDesktop ? Colors.white : const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(isDesktop ? 26 : 12),
        border: isDesktop ? Border.all(color: Colors.grey.shade200) : null,
        boxShadow: isDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),

      /// 🔥 FIX OVERFLOW
      child: isDesktop
          ? Row(
              children: List.generate(periods.length, (index) {
                final period = periods[index];

                return Expanded(
                  child: Obx(() {
                    final isSelected =
                        controller.selectedPeriod.value == period;

                    return _PeriodButton(
                      period: period,
                      isSelected: isSelected,
                      isDesktop: isDesktop,

                      ///  PERIOD CHANGE
                      ///  PeriodSelectorBarChart
                      onTap: () {
                        /// SELECT PERIOD
                        controller.selectedPeriod.value = period;

                        ///  FIND SELECTED YEAR DATA
                        final selectedData = yearlyData.firstWhere(
                          (e) => e.period == period,
                        );

                        controller.update();
                      },
                    );
                  }),
                );
              }),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(periods.length, (index) {
                  final period = periods[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Obx(() {
                      final isSelected =
                          controller.selectedPeriod.value == period;

                      return _PeriodButton(
                        period: period,
                        isSelected: isSelected,
                        isDesktop: isDesktop,

                        ///  PERIOD CHANGE
                        onTap: () {
                          /// SELECT PERIOD
                          controller.selectedPeriod.value = period;

                          ///  FIND SELECTED YEAR DATA
                          final selectedData = yearlyData.firstWhere(
                            (e) => e.period == period,
                          );

                          ///  CALL METHOD

                          controller.update();
                        },
                      );
                    }),
                  );
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
          horizontal: isDesktop ? 10 : 4,
          vertical: isDesktop ? 2 : 0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 10 : 8,
          vertical: isDesktop ? 8 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDesktop ? Ucolors.primary : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(isDesktop ? 18 : 8),
          boxShadow: isSelected && isDesktop
              ? [
                  BoxShadow(
                    color: Ucolors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : isSelected && !isDesktop
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            period,
            style: TextStyle(
              fontSize: isDesktop ? 14 : 10,
              fontFamily: FontFamily.medium,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? (isDesktop ? Colors.white : Ucolors.primary)
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
