import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/controller/mutual_fund_controller.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

/// Shared by Home's ticker and fund cards so NFO routing and permissions agree.
abstract final class HomeFundNavigation {
  static String logoUrl(String? value) {
    final path = value?.trim() ?? '';
    if (path.isEmpty) return '';
    return Uri.parse('${Appurl.baseUrl}/').resolve(path).toString();
  }

  static void open(
    MutualFundListEntity fund, {
    required MutualFundController controller,
  }) {
    if (fund.isNfoOffer) {
      Get.toNamed(
        AppRoutes.nfodetailsPage,
        arguments: fund.toLaunchDataEntity(),
      );
      return;
    }
    final code = fund.schemeCode?.trim() ?? '';
    if (code.isEmpty) return;
    controller.addToLocalRecentlyViewed(fund);
    if (Get.isRegistered<FundDetailsController>()) {
      Get.delete<FundDetailsController>();
    }
    final data = <String, dynamic>{
      'scheme': fund.baseSchemeName,
      'scheme_code': code,
      'isin': fund.isin ?? '',
      'imgUrl': logoUrl(fund.amc?.amcLogoUrl),
      'email': fund.amc?.email,
      'address': fund.amc?.address,
      'contact': fund.amc?.contact,
      'rta_amc_code': fund.rtaAmcCode,
      'amc_name': fund.amc?.amcName,
      'is_purchase_allowed': fund.isPurchaseAllowed,
      'is_sip_allowed': fund.isSipAllowed,
      'is_lumpsum_allowed': fund.isLumpsumAllowed,
      'allowed_sip_dates': fund.allowedSipDates,
    };
    FundDetailsScreen.navData = data;
    Get.toNamed(AppRoutes.funddetails, arguments: data);
  }
}

abstract final class HomeFundValues {
  static final _amount = NumberFormat('#,##0.##', 'en_IN');
  static final _nav = NumberFormat('#,##0.00', 'en_IN');

  static double? percentage(String? raw) {
    final value = double.tryParse(raw?.replaceAll('%', '').trim() ?? '');
    return value != null && value.isFinite ? value : null;
  }

  static String returnLabel(String? raw, {bool signed = false}) {
    final value = percentage(raw);
    if (value == null) return '—';
    return '${signed && value > 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
  }

  static String amount(num? value, {bool nav = false}) {
    if (value == null || !value.isFinite) return '—';
    return '₹${(nav ? _nav : _amount).format(value)}';
  }
}
