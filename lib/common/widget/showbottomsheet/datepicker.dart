import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

Future<void> showDOBPickerBottomSheet({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  DateTime selectedDate = DateTime(2000, 1, 1);

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 750),
    ),
    builder: (_) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Drag Handle
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Select Date Of Birth',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (date) {
                  selectedDate = date;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: UElevatedBUtton(
                onPressed: () {
                  controller.text =
                      DateFormat('dd/MM/yyyy').format(selectedDate);
                  Navigator.pop(context);
                },
                child:  Center(
                  child: Text('Select Date', style: UTextStyles.buttonText),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
