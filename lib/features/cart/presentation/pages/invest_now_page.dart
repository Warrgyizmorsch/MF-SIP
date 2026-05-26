import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../common/widget/text_form/text_field_component.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../fund_details/presentation/pages/fund_deatails.dart';
import '../controllers/cart_controller.dart';

class InvestNowPage extends GetView<CartController> {
  final bool isDesktop = Get.width > 600;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invest Now', style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // bottomNavigationBar: _buildActionButtons(),
      body: Column(
        children: [
          Card(
            color: Ucolors.light,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // decoration: BoxDecoration(
            //   color: Ucolors.light,
            //   borderRadius: BorderRadius.circular(18),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => ClipOval(
                          child: CustomCachedImage(
                            imageUrl: '${controller.amcImage.value}',
                            radius: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.fundDetail.value!.schemeName ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  DashedLine(color: Color(0xffACACAC), dashSpace: 3.5),
                  SizedBox(height: 12),
                  InvestmentInputsRow(),
                ],
              ),
            ),
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: _buildActionButtons(),
          ),
          Gap(20),
        ],
      ),
    );
  }

  Widget _buildInvestmentCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("Estimated Returns", style: TextStyle(color: Colors.blueGrey)),
          SizedBox(height: 10),
          Obx(
            () => Text(
              "₹${controller.investmentAmount.value}",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(
            AppRoutes.paymentScreen,
            arguments: {'amount': controller.investmentAmount.value},
            id: isDesktop ? 1 : null,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "Confirm Investment",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}

class InvestmentInputsRow extends StatelessWidget {
  InvestmentInputsRow({super.key});

  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              /// 1. Investment Type Dropdown
              Expanded(
                flex: 3,
                child: _buildColumn(
                  'Inv. Type',
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    isDense: true,
                    value: controller.invType.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'sip',
                        child: Text('SIP', style: TextStyle(fontSize: 12)),
                      ),
                      DropdownMenuItem(
                        value: 'lumpsum',
                        child: Text('Lumpsum', style: TextStyle(fontSize: 12)),
                      ),
                      DropdownMenuItem(
                        value: 'stepup',
                        child: Text('Step Up', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        controller.invType.value = val;
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// 2. SIP Date Dropdown (Visible for SIP/StepUp)
              if (controller.invType.value != 'lumpsum')
                Expanded(
                  flex: 2,
                  child: _buildColumn(
                    'SIP Date',
                    DropdownButton<String>(
                      menuMaxHeight: 300,
                      dropdownColor: Colors.white,
                      isDense: true,
                      value: controller.selectedSipDay.value.toString(),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: List.generate(
                        28,
                        (i) => DropdownMenuItem(
                          value: '${i + 1}',
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          controller.selectedSipDay.value = int.parse(val);
                        }
                      },
                    ),
                  ),
                ),

              const SizedBox(width: 12),

              /// 3. Investment Amount
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inv Amount',
                      style: UTextStyles.small.copyWith(
                        color: const Color(0xff5B5B5B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Inside _buildStepUpSection() -> CustomTextField
                    Obx(
                      () => CustomTextField(
                        bgColor: Colors.white,
                        height: 55,
                        borderRadius: 11,
                        // Use a Key to force the field to update if the min amount changes
                        // (e.g., when switching between different schemes)
                        key: ValueKey('stepup_${controller.schemeCode.value}'),
                        controller: TextEditingController(
                          text: controller.stepUpAmount.value.toStringAsFixed(
                            0,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validationType: ValidationType.custom,
                        borderColor: Colors.grey.shade300,
                        focusedBorderColor: Ucolors.primary,
                        onChanged: (value) {
                          controller.stepUpAmount.value =
                              double.tryParse(value) ?? 0.0;
                        },
                        customValidator: (value) {
                          final amt = int.tryParse(value ?? '') ?? 0;
                          final minAllowed = controller.minSipAmount.value;

                          if (amt < minAllowed) {
                            return 'Min ₹$minAllowed'; // Dynamically shows the fund's min SIP
                          }
                          if (amt % 100 != 0) {
                            return 'Multiple of ₹100';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// 4. Step Up Section (Visible for StepUp)
          if (controller.invType.value == 'stepup') ...[
            const Gap(15),
            _buildStepUpSection(),
          ],
        ],
      );
    });
  }

  Widget _buildColumn(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: UTextStyles.small.copyWith(
            color: const Color(0xff5B5B5B),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        _box(child: child),
      ],
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildStepUpSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffEAF5FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildColumn(
              'Step up Frequency',
              DropdownButton<String>(
                value: controller.stepUpFrequency.value,
                isExpanded: true,
                isDense: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text('Monthly', style: TextStyle(fontSize: 12)),
                  ),
                  DropdownMenuItem(
                    value: '3',
                    child: Text('Quarterly', style: TextStyle(fontSize: 12)),
                  ),
                  DropdownMenuItem(
                    value: '6',
                    child: Text('6 Months', style: TextStyle(fontSize: 12)),
                  ),
                  DropdownMenuItem(
                    value: '12',
                    child: Text('Yearly', style: TextStyle(fontSize: 12)),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    controller.stepUpFrequency.value = val;
                  }
                },
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step Up Amount',
                  style: UTextStyles.small.copyWith(
                    color: const Color(0xff5B5B5B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => CustomTextField(
                    bgColor: Colors.white,
                    height: 55,
                    borderRadius: 11,
                    // Use a Key to force the field to update if the min amount changes
                    // (e.g., when switching between different schemes)
                    key: ValueKey('inv_${controller.schemeCode.value}'),
                    controller: TextEditingController(
                      text: controller.stepUpAmount.value.toStringAsFixed(0),
                    ),
                    keyboardType: TextInputType.number,
                    validationType: ValidationType.custom,
                    borderColor: Colors.grey.shade300,
                    focusedBorderColor: Ucolors.primary,
                    onChanged: (value) {
                      controller.stepUpAmount.value =
                          double.tryParse(value) ?? 0.0;
                    },
                    customValidator: (value) {
                      final amt = int.tryParse(value ?? '') ?? 0;
                      final minAllowed = controller.minSipAmount.value;

                      if (amt < minAllowed) {
                        return 'Min ₹$minAllowed'; // Dynamically shows the fund's min SIP
                      }
                      if (amt % 100 != 0) {
                        return 'Multiple of ₹100';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
