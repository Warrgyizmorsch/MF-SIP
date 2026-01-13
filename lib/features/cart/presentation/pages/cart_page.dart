import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/features/personalization/screen/profile/details/bank_details.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Cart'),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) => CartItemCard(),
        itemCount: 5,
      ),

      bottomNavigationBar: SafeArea(top: false, child: CartBottomBar()),
    );
  }
}

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({super.key});

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
                    'Amount Payable ',
                    style: UTextStyles.small.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '₹ 5,000',
                    style: TextStyle(fontSize: 25, color: Ucolors.success),
                  ),
                ],
              ),
            ),
            Expanded(
              child: UElevatedBUtton(
                // height: 50,
                // width: 50,
                child: Center(
                  child: Text('Purchase', style: UTextStyles.buttonText),
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
  const CartItemCard({super.key});

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
        children: const [
          FundHeader(),
          SizedBox(height: 12),
          DashedLine(color: Color(0xffACACAC)),
          SizedBox(height: 12),
          InvestmentInputsRow(),
        ],
      ),
    );
  }
}

class FundHeader extends StatelessWidget {
  const FundHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: AssetImage(UImages.motilal),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Motilal Ostwal Small Cap Fund',
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
          containercolor: Colors.redAccent.withOpacity(0.1),
        ),
      ],
    );
  }
}

class InvestmentInputsRow extends StatefulWidget {
  const InvestmentInputsRow({super.key});

  @override
  State<InvestmentInputsRow> createState() => _InvestmentInputsRowState();
}

class _InvestmentInputsRowState extends State<InvestmentInputsRow> {
  String invType = 'SIP';
  String sipDate = '1';
  String amount = '500';
  String stepup = '6m';

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    style: UTextStyles.small.copyWith(color: Color(0xff5B5B5B)),
                  ),
                  const SizedBox(height: 6),
                  _box(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,

                      isDense: true,

                      value: invType,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'SIP', child: Text('SIP')),
                        DropdownMenuItem(
                          value: 'Lumpsum',
                          child: Text('Lumpsum'),
                        ),
                        DropdownMenuItem(
                          value: 'stepup',
                          child: Text('Step Up'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => invType = value!);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            invType != 'Lumpsum'
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
                            value: sipDate,
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
                              setState(() => sipDate = value!);
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
                    style: UTextStyles.small.copyWith(color: Color(0xff5B5B5B)),
                  ),
                  const SizedBox(height: 6),
                  _box(
                    child: TextField(
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        hintText: amount,

                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      onChanged: (value) {
                        amount = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(15),

        invType == 'stepup'
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
                              value: stepup,
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
                                setState(() {});
                                stepup = value.toString();
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
