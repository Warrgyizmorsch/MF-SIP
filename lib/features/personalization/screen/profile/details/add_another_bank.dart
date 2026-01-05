import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class AddAnotherBankPage extends StatelessWidget {
  const AddAnotherBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Bank Details'),
      body: Padding(
        padding: UPadding.screenPadding.copyWith(
          bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(20),
            // Image.asset(UImages.imp,,),
            Text(
              'Enter Your Bank Details ',
              style: UTextStyles.medium.copyWith(
                color: Ucolors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(20),

            UTextFormField(
              prefixIcon: Iconsax.bank,
              hintText: 'Enter Bank Name',
            ),
            Gap(15),
            UTextFormField(prefixIcon: Icons.code, hintText: 'IFSC Code'),
            Gap(15),
            UTextFormField(prefixIcon: Iconsax.global, hintText: 'Branch Name'),
            Gap(15),
            UTextFormField(
              prefixIcon: Icons.onetwothree,
              hintText: 'Account Number',
            ),
            Spacer(),
            UElevatedBUtton(
              child: Center(child: Text('Save', style: UTextStyles.buttonText)),
            ),
          ],
        ),
      ),
    );
  }
}
