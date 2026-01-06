import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class AddAnotherBankPage extends StatelessWidget {
  AddAnotherBankPage({super.key});
  final TextEditingController bank = TextEditingController();

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

            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                banknamelist(context);
              },

              child: AbsorbPointer(
                absorbing: true,
                child: UTextFormField(
                  sufixIcon: Icons.arrow_drop_down,
                  controller: bank,
                  prefixIcon: Iconsax.bank,
                  hintText: 'Enter Bank Name',
                ),
              ),
            ),
            Gap(15),
            // Gap(15),s
            UTextFormField(
              prefixIcon: Icons.onetwothree,
              hintText: 'Account Number',
            ),
            Gap(15),
            UTextFormField(prefixIcon: Icons.code, hintText: 'IFSC Code'),
            // Gap(15),
            // UTextFormField(prefixIcon: Iconsax.global, hintText: 'Branch Name'),
            // Gap(15),
            // UTextFormField(
            //   prefixIcon: Icons.onetwothree,
            //   hintText: 'Account Number',
            // ),
            Spacer(),
            UElevatedBUtton(
              child: Center(child: Text('Save', style: UTextStyles.buttonText)),
            ),
          ],
        ),
      ),
    );
  }

  void banknamelist(BuildContext context) async {
    final value = await showMenu<String>(
      context: context,
      // menuPadding: EdgeInsets.all(10),
      color: Ucolors.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14), // 👈 radius here
      ),

      position: const RelativeRect.fromLTRB(100, 300, 100, 100),

      items: [
        PopupMenuItem(value: 'SBI', child: Text('State Bank of India')),
        PopupMenuItem(value: 'PNB', child: Text('Punjab National Bank')),
        PopupMenuItem(value: 'HDFC', child: Text('HDFC Bank')),
        PopupMenuItem(value: 'ICICI', child: Text('ICICI Bank')),
        PopupMenuItem(value: 'AXIS', child: Text('Axis Bank')),
        PopupMenuItem(value: 'KOTAK', child: Text('Kotak Mahindra Bank')),
        PopupMenuItem(value: 'CANARA', child: Text('Canara Bank')),
        PopupMenuItem(value: 'BOB', child: Text('Bank of Baroda')),
        PopupMenuItem(value: 'UNION', child: Text('Union Bank of India')),
        PopupMenuItem(value: 'IDFC', child: Text('IDFC First Bank')),
        PopupMenuItem(value: 'INDUSIND', child: Text('IndusInd Bank')),
        PopupMenuItem(value: 'YES', child: Text('Yes Bank')),
        PopupMenuItem(value: 'FEDERAL', child: Text('Federal Bank')),
        PopupMenuItem(value: 'RBL', child: Text('RBL Bank')),
        PopupMenuItem(value: 'BANDHAN', child: Text('Bandhan Bank')),
      ],
    );
    if (value != null) {
      bank.text = value;
    }
  }
}
