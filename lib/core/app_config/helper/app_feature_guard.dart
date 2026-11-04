import 'package:flutter/material.dart';
import '../../../../common/widget/animated/custom_toast.dart';
import '../service/app_config_service.dart';

class AppFeatureGuard {
  AppFeatureGuard._();

  /// Checks if SIP investments are permitted by server runtime controls
  static bool canInvestSip({bool showNotice = true}) {
    final enabled = AppConfigService.instance.isSipEnabled;
    if (!enabled && showNotice) {
      showCustomToast(
        title: 'SIP Investments Paused',
        message: 'SIP investments are temporarily unavailable due to scheduled maintenance.',
        backgroundColor: Colors.grey.shade900,
        icon: Icons.pause_circle_outline_rounded,
      );
    }
    return enabled;
  }

  /// Checks if Redemptions are permitted by server runtime controls
  static bool canRedeem({bool showNotice = true}) {
    final enabled = AppConfigService.instance.isRedeemEnabled;
    if (!enabled && showNotice) {
      showCustomToast(
        title: 'Redemption Paused',
        message: 'Redemption services are temporarily unavailable due to system maintenance.',
        backgroundColor: Colors.grey.shade900,
        icon: Icons.pause_circle_outline_rounded,
      );
    }
    return enabled;
  }

  /// Checks if Payment operations are permitted
  static bool canProcessPayment({bool showNotice = true}) {
    final enabled = AppConfigService.instance.isPaymentEnabled;
    if (!enabled && showNotice) {
      showCustomToast(
        title: 'Payment Gateway Unavailable',
        message: 'Online payment services are currently undergoing maintenance.',
        backgroundColor: Colors.grey.shade900,
        icon: Icons.block_rounded,
      );
    }
    return enabled;
  }

  /// Checks if New Investment creation is permitted
  static bool canInvestNew({bool showNotice = true}) {
    final enabled = AppConfigService.instance.isNewInvestmentEnabled;
    if (!enabled && showNotice) {
      showCustomToast(
        title: 'New Investments Paused',
        message: 'New fund investments are temporarily unavailable. Please try again shortly.',
        backgroundColor: Colors.grey.shade900,
        icon: Icons.info_outline_rounded,
      );
    }
    return enabled;
  }
}
