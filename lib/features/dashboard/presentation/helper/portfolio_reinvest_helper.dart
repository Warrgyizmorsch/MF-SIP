import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/mfu/presentation/pages/purchase_page.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class PortfolioReinvestHelper {
  PortfolioReinvestHelper._();

  static void navigateToPurchase(
    BuildContext context,
    MfuPortfolioItemEntity fund, {
    bool isLumpsum = false,
  }) {
    final purchaseArgs = SipPurchaseArgs(
      schemeCode: fund.schemeCode,
      fundName: fund.fundName,
      amcName: fund.amcName.isNotEmpty ? fund.amcName : null,
      amcCode: fund.amcCode.isNotEmpty ? fund.amcCode : null,
      imgUrl: fund.amcLogo.isNotEmpty ? fund.amcLogo : null,
      folio: fund.folioNo.isNotEmpty && fund.folioNo != 'NEW'
          ? fund.folioNo
          : null,
      riskLabel: fund.riskLabel.isNotEmpty ? fund.riskLabel : 'Very High Risk',
      category: fund.category.isNotEmpty ? fund.category : 'Equity • Flexi Cap',
      minSip: fund.minSip > 0 ? fund.minSip : 500,
      minLumpsum: fund.minLumpsum > 0 ? fund.minLumpsum : 1000,
      minTopup: fund.minTopup > 0 ? fund.minTopup : 500,
      divoption: fund.resolvedDivOption,
      allowedSipDates: fund.allowedSipDates.isNotEmpty
          ? fund.allowedSipDates
          : null,
      initialGoalId: fund.goalId,
      initialGoalName: fund.goalName,
      initialInvType: isLumpsum
          ? InvType.lumpsum
          : (fund.isLumpsum ? InvType.lumpsum : InvType.sip),
    );

    SIPPurchasePage.tempData = purchaseArgs;

    if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
      Get.find<NavigationBarController>().openNestedRoute(
        AppRoutes.investNowPage,
        arguments: purchaseArgs,
      );
    } else {
      Get.toNamed(AppRoutes.investNowPage, arguments: purchaseArgs);
    }
  }
}
