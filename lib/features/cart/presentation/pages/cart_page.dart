import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Cart'),
    );
  }
}