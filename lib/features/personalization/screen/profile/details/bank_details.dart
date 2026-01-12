import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/features/personalization/screen/profile/details/add_another_bank.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Bank Details'),
      body: Padding(
        padding: UPadding.screenPadding.copyWith(
          bottom: kBottomNavigationBarHeight,
        ),
        child: Column(
          children: [
            // SizedBox(height: kToolbarHeight - kTextTabBarHeight / 2),
            Gap(10),

            //Bank card
            BankCard(
              ifsccode: 'SBIN0031163',
              bankName: 'SBI',
              cardNumber: '00000036150491589',
              bankLogo: UImages.sbi,
              // color: Ucolors.icicibankGradient,
              color: Ucolors.backgroundGradient,
            ),
            SizedBox(height: 15),
            BankCard(
              ifsccode: 'ICIC0000004',
              bankName: 'ICICI',
              cardNumber: '000405007899',
              bankLogo: UImages.icici,
              color: Ucolors.icicibankGradient,
              // color: Ucolors.backgroundGradient,
            ),

            //Acoount Details
            // Card(
            //   elevation: 4,
            //   color: Ucolors.light,
            //   child: Padding(
            //     padding: const EdgeInsets.all(15.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         bankinfo('Account', '4501560103'),
            //         bankinfo('IFSC Code', 'ICIC0000045'),
            //         // bankinfo('Branch Name', 'MADHUBAN, UDAIPUR'),
            //         // bankinfo('Account Type', 'Saving Account'),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 15),

            //Button
            UElevatedBUtton(
              outlined: true,
              child: Center(
                child: Text(
                  'Set Up Auto Pay',
                  style: TextStyle(color: Ucolors.blue),
                ),
              ),
            ),
            SizedBox(height: 15),

            //Button
            UElevatedBUtton(
              onPressed: () => Get.to(() => AddAnotherBankPage()),
              outlined: true,
              child: Center(
                child: Text(
                  'Add Another Account',
                  style: TextStyle(color: Ucolors.blue),
                ),
              ),
            ),
            // Spacer(),

            //Button
            // UElevatedBUtton(
            //   // outlined: true,
            //   child: Center(
            //     child: Text('Continue', style: UTextStyles.buttonText),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget bankinfo(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: UTextStyles.subtitle2.copyWith(
            color: Ucolors.dark,
            fontWeight: FontWeight.w600,
            height: 2,
          ),
        ),
        Text(value, style: UTextStyles.caption),
      ],
    );
  }
}

class BankCard extends StatelessWidget {
  const BankCard({
    super.key,
    required this.bankName,
    required this.cardNumber,
    required this.bankLogo,
    required this.color,
    required this.ifsccode,
  });

  final String bankName;
  final String cardNumber;
  final String bankLogo;
  final Gradient color;
  final String ifsccode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.23,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // Top Right Delete Icon
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  log('delete');
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(8),
                  // child: IconButton( Icon(Iconsax.trash, color: Colors.deepOrange, size: 20),
                  child: Icon(
                    Iconsax.trash,
                    color: Colors.deepOrange,
                    size: 18,
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bank Name
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 18,
                      backgroundImage: AssetImage(bankLogo),
                      // child: Image.asset(UImages.sbi)
                    ),
                    Gap(6),
                    Text(
                      bankName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Primary Row
                Row(
                  children: const [
                    Gap(8),
                    Icon(Icons.verified, color: Colors.lightGreen, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Primary",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Account Number
                Row(
                  children: [
                    Text(
                      cardNumber,
                      style: UTextStyles.subtitle2.copyWith(
                        color: Ucolors.light,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    // Image.asset(bankLogo),
                    Text(
                      ifsccode,
                      style: UTextStyles.subtitle2.copyWith(
                        color: Ucolors.light,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
