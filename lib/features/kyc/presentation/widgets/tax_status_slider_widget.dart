import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../../core/utils/constant/text_style.dart';
import '../controllers/kyc_controller.dart';
class SelectionPickerWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final RxString selectedValue; // Pass the specific observable (e.g., controller.selectedGender)

  const SelectionPickerWidget({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Vertical spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(title, style: AppTextStyles.h3()),
          const SizedBox(height: 12),

          // Sliding List
          SizedBox(
            height: 50,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = options[index];

                return Obx(() {
                  final isSelected = selectedValue.value == item;

                  return GestureDetector(
                    onTap: () {
                      selectedValue.value = item; // Update the observable
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200), // Smooth animation
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Ucolors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Ucolors.blue : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item,
                        style: AppTextStyles.bodyMediumW500(
                          color: isSelected ? Colors.white : Ucolors.darkgrey,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
