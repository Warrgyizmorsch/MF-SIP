import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text_form/text_field_component.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/enums/enums.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/features/cart/data/model/cartItem_model.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/personalization/presentation/widgets/bank_details.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // log('${Get.arguments}');
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['monthlyAmount'] != null) {
      controller.monthlyAmount.value = int.parse(
        args['monthlyAmount'].toString(),
      );
    }
    // final monthly = args?['monthlyAmount'];
    // final amount = args['totalAmount'] ?? '';
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Cart'),
      body: Obx(() {
        if (controller.itemsCount == 0) {
          return Center(child: Text('Add scheme to cart'));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) =>
              CartItemCard(item: controller.items[index], index: index),
          itemCount: controller.itemsCount,
        );
      }),
      persistentFooterDecoration: BoxDecoration(),
      persistentFooterButtons: [
        TermAndPolicy(term: 'By Proceeding I accept the '),
      ],

      bottomNavigationBar: SafeArea(
        top: false,
        child: Obx(
          () => CartBottomBar(
            goalAmount: controller.items.isEmpty
                ? null
                : '/${controller.monthlyAmount.value.toString()}',
            amount: controller.totolAmount.toString(),
            ontap: () {
              if (controller.monthlyAmount.value > controller.totolAmount) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'SIP amount is insufficient for this goal.\nPlease increase the amount or duration.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Back'),
                      ),
                    ],
                  ),
                );

                // Get.toNamed(AppRoutes.paymentScreen);
              } else if (controller.monthlyAmount.value ==
                  controller.totolAmount) {
                Get.toNamed(
                  AppRoutes.paymentScreen,
                  arguments: {'amount': controller.totolAmount},
                );
              } else if (controller.monthlyAmount.value <
                  controller.totolAmount) {
                log('Inscrease');
              }
            },
          ),
        ),
      ),
    );
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    this.title,
    this.buttonText,
    this.amountColor,
    required this.ontap,
    this.amount,
    this.goalAmount,
  });

  final String? title;
  final String? buttonText;
  final Color? amountColor;
  final VoidCallback ontap;
  final String? amount;
  final String? goalAmount;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: Color(0xffE8F4FF)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 0,
                children: [
                  Text(
                    title ?? 'Amount Payable ',
                    style: UTextStyles.small.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        amount ?? '₹ 5,000',
                        style: TextStyle(
                          fontSize: 25,
                          color: amountColor ?? Ucolors.success,
                        ),
                      ),
                      Text(
                        goalAmount ?? '/Monthly',
                        style: TextStyle(
                          fontSize: goalAmount != null ? 25 : 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: UElevatedBUtton(
                // height: 50,
                onPressed: ontap,
                // width: 50,
                child: Center(
                  child: Text(
                    buttonText ?? 'Purchase',
                    style: UTextStyles.buttonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key, required this.item, required this.index});

  final CartItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Ucolors.light,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FundHeader(item: item, index: index),
          SizedBox(height: 12),
          DashedLine(color: Color(0xffACACAC)),
          SizedBox(height: 12),
          InvestmentInputsRow(item: item),
        ],
      ),
    );
  }
}

class FundHeader extends StatelessWidget {
  FundHeader({super.key, required this.item, required this.index});
  final CartItem item;
  final int index;

  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: CachedNetworkImageProvider("${Appurl.baseUrl}${item.logoUrl}"),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.fundName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '● ',
                      style: TextStyle(color: Ucolors.red, fontSize: 10),
                    ),
                    TextSpan(
                      text: 'Very High Risk ',
                      style: UTextStyles.small.copyWith(
                        fontSize: 10,

                        color: Color(0xff5B5B5B),
                      ),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: 'SIP Returns (3Y):',
                      style: UTextStyles.small.copyWith(
                        fontSize: 10,
                        color: Color(0xff5B5B5B),
                      ),
                    ),
                    TextSpan(
                      text: '29.89%',
                      style: UTextStyles.small.copyWith(
                        color: Ucolors.success,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   // mainAxisSize: MainAxisSize.min,
              //   children: [
              //     const Icon(Icons.circle, size: 6, color: Colors.red),
              //     const SizedBox(width: 3),
              //     Text(
              //       'Very High Risk',
              //       style: UTextStyles.small.copyWith(fontSize: 10),
              //     ),
              //     // const SizedBox(width: 12),
              //     Gap(5),
              //     Text(
              //       'SIP Returns (3Y):',
              //       style: UTextStyles.small.copyWith(fontSize: 10),
              //     ),
              //     const SizedBox(width: 4),
              //     Text(
              //       '29.89%',
              //       style: UTextStyles.small.copyWith(
              //         color: Ucolors.success,
              //         fontSize: 10,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),

        Deleteiconwithcontainer(
          delete: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                // backgroundColor: Ucolors.primary,
                title: Text('Are you sure ? '),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'No',
                      style: TextStyle(fontSize: 14, color: Ucolors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.snackbar(
                        margin: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                        colorText: Ucolors.light,
                        'Remove from cart',
                        item.fundName.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Ucolors.red,
                      );

                      controller.removeItem(index);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          // delete: () => controller.removeItem(index),
          containercolor: Colors.redAccent.withOpacity(0.1),
        ),
      ],
    );
  }
}

class InvestmentInputsRow extends StatelessWidget {
  InvestmentInputsRow({super.key, required this.item});

  final CartItem item;
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              /// Investment Type
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inv. Type',
                      style: UTextStyles.small.copyWith(
                        color: Color(0xff5B5B5B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _box(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,

                        isDense: true,

                        value: item.invType.value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'SIP', child: Text('SIP')),
                          DropdownMenuItem(
                            value: 'lumpsum',
                            child: Text('Lumpsum'),
                          ),
                          DropdownMenuItem(
                            value: 'stepup',
                            child: Text('Step Up'),
                          ),
                        ],
                        onChanged: (value) {
                          // setState(() => invType = value!);
                          item.invType.value = value!;
                          // item.amount.value = value == 'lumpsum'
                          //     ? 25000
                          //     : value == 'SIP '
                          //     ? 12330
                          //     : 10000;
                          if (value == 'lumpsum') {
                            item.amount.value = 25000;
                          } else if (value == 'SIP') {
                            item.amount.value = 12330;
                          } else if (value == 'stepup') {
                            item.amount.value = 100000;
                            item.stepupFrequency.value = '6m'; // ✅ IMPORTANT
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // invType != 'lumpsum'
              //     ?
              item.invType.value != 'lumpsum'
                  ?
                    /// SIP Date
                    Expanded(
                      flex: 2,
                      // flex: ,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SIP Date',
                            style: UTextStyles.small.copyWith(
                              color: Color(0xff5B5B5B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _box(
                            child: DropdownButton<String>(
                              menuMaxHeight: 300,
                              dropdownColor: Colors.white,

                              isDense: true,
                              value: item.sipDate.value.toString(),
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: List.generate(
                                28,
                                (i) => DropdownMenuItem(
                                  value: '${i + 1}',
                                  child: Text('${i + 1}'),
                                ),
                              ),
                              onChanged: (value) {
                                // item.invType.value = value!;
                                item.sipDate.value = int.parse(value!);

                                // setState(() => sipDate = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),

              const SizedBox(width: 12),

              /// Amount
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inv Amount',
                      style: UTextStyles.small.copyWith(
                        color: Color(0xff5B5B5B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      onChanged: item.updateAmount,
                      keyboardType: TextInputType.number,
                      controller: item.amountController,
                      validationType: ValidationType.custom,
                      customValidator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount is required';
                        }

                        final amount = int.tryParse(value);
                        if (amount == null) {
                          return 'Enter a valid number';
                        }

                        if (amount <= 0) {
                          return 'Amount must be greater than 0';
                        }

                        if (amount < 500) {
                          return 'Minimum investment is ₹500';
                        }

                        return null; // ✅ valid
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      height: 44,
                      borderRadius: 10,
                    ),

                    // _box(
                    //   child:
                    //   TextField(
                    //     keyboardType: TextInputType.number,
                    //     controller: TextEditingController(
                    //       text: item.amount.value.toString(),
                    //     ),

                    //     decoration: InputDecoration(
                    //       // hintText: amount,
                    //       border: InputBorder.none,
                    //       isCollapsed: true,
                    //     ),
                    //     onChanged: (value) {
                    //       // amount = value;
                    //       item.amount.value = int.tryParse(value) ?? 0;
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(15),

          item.invType.value == 'stepup'
              ? Container(
                  // height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: Color(0xffEAF5FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step up Frequency',
                              style: TextStyle(fontSize: 10),
                            ),
                            const Gap(5),
                            _box(
                              child: DropdownButton<String>(
                                // style: TextStyle(color: Ucolors.dark),
                                isExpanded: true,
                                isDense: true,
                                underline: SizedBox(),
                                value: item.stepupFrequency.value,
                                items: [
                                  DropdownMenuItem(
                                    value: '6m',
                                    child: Text('6 month'),
                                  ),
                                  DropdownMenuItem(
                                    value: '1y',
                                    child: Text('1 Year'),
                                  ),
                                  DropdownMenuItem(
                                    value: '2y',
                                    child: Text('2 Year '),
                                  ),
                                  DropdownMenuItem(
                                    value: '5y',
                                    child: Text('5 Year'),
                                  ),
                                ],
                                onChanged: (value) {
                                  item.stepupFrequency.value = value!;

                                  // setState(() {});
                                  // stepup = value.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gap(20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step Up Amount',
                              style: TextStyle(fontSize: 10),
                            ),
                            Gap(5),
                            _box(
                              child: TextField(
                                onChanged: (value) {},
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(11),
      ),
      child: child,
    );
  }
}

class InputBox extends StatelessWidget {
  final String label;
  final String value;

  const InputBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
