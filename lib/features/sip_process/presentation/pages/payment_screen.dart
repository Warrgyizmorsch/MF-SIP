import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/cart/presentation/pages/cart_page.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final CartController cartController = Get.find<CartController>();
  final PersonalisationController personalisationController =
      Get.find<PersonalisationController>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arg = Get.arguments as Map<String, dynamic>?;

    final String amount =
        arg?['amount']?.toString() ?? cartController.totalAmount.toString();

    debugPrint('Amount to pay: $amount');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBarNormal(title: 'Payment'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: UTextStyles.small.copyWith(color: Color(0xff333333)),
            ),
            Gap(25),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Ucolors.light,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardMethod(
                    title:
                        '${personalisationController.userData.value?.bankAccount?.bankName}',
                    icon: Icons.credit_card,
                    subtitle:
                        '${personalisationController.userData.value?.bankAccount?.accountNumberEncrypted}',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),

                      const SmallHeading(
                        smallheading: 'Enter UPI ID',
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: UTextFormField(
                              prefixIcon: null,
                              hintText: 'Name',
                            ),
                          ),
                          Gap(10),
                          Expanded(
                            child: UElevatedBUtton(
                              color: Ucolors.darkgrey,
                              width: 40,
                              height: 52,
                              child: Center(
                                child: Text(
                                  'Verify',
                                  style: UTextStyles.buttonText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                    ],
                  ),
                ],
              ),
            ),

            Gap(5),
            Card(
              color: Colors.white,
              child: CardMethod(title: 'Net Banking', icon: Icons.home),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        TermAndPolicy(term: 'By Proceeding, I accept the '),
      ],
      persistentFooterDecoration: BoxDecoration(color: Colors.transparent),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CartBottomBar(
          amount: amount.toString(),
          title: 'Amount Payable',
          ontap: () {},
        ),
      ),
    );
  }
}

class CardMethod extends StatelessWidget {
  const CardMethod({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,

      // isThreeLine: true,
      leading: Icon(icon, size: 30),
      title: Text(
        title,
        style: UTextStyles.medium.copyWith(
          fontWeight: FontWeight.w600,
          color: Ucolors.dark,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: UTextStyles.small)
          : null,
      // subtitle: ,
      trailing: CircleAvatar(
        backgroundColor: Ucolors.primary.withOpacity(0.1),
        maxRadius: 15,
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Ucolors.borderColor),
      ),
      child: SizedBox(height: 40, width: 40, child: Image.asset(icon)),
    );
  }
}
