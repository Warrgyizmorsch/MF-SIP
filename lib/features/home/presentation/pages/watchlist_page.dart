import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';

import '../../../explore/presentation/pages/explore.dart';

class WatchlistPage extends StatelessWidget {
  WatchlistPage({super.key});

  final MutualFundController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Wishlist'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Ucolors.primary),
          );
        }
        if (controller.mutualfund.isEmpty) {
          return Center(child: Text("No mutual funds found"));
        }

        return ListView.builder(
          itemCount: controller.searchFund.length,
          itemBuilder: (context, index) => MutualFundCard(
            isDelete: true,
            containercolor: Color(0xffFEF0F0),
            entity: controller.searchFund[index],
          ),
        );
      }),
    );
  }
}
