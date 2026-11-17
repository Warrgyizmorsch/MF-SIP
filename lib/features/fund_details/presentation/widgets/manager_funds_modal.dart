import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';
import 'package:my_sip/features/explore/presentation/pages/explore.dart';
import 'package:my_sip/features/fund_details/domain/usecases/get_funds_by_manager_usecase.dart';
import 'package:my_sip/features/fund_details/presentation/controllers/fund_details_controller.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';
import 'package:my_sip/navigation_menu_bar.dart';

class ManagerFundsModal extends StatefulWidget {
  final int managerId;
  final String managerName;
  final bool isWeb;

  const ManagerFundsModal({
    super.key,
    required this.managerId,
    required this.managerName,
    this.isWeb = false,
  });

  static void show(
    BuildContext context, {
    required int managerId,
    required String managerName,
  }) {
    final bool isDesktopWeb = kIsWeb || MediaQuery.of(context).size.width > 768;

    if (isDesktopWeb) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640, maxHeight: 820),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.white,
                child: ManagerFundsModal(
                  managerId: managerId,
                  managerName: managerName,
                  isWeb: true,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.85,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Material(
              color: Colors.white,
              child: ManagerFundsModal(
                managerId: managerId,
                managerName: managerName,
                isWeb: false,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  State<ManagerFundsModal> createState() => _ManagerFundsModalState();
}

class _ManagerFundsModalState extends State<ManagerFundsModal> {
  bool _isLoading = true;
  String? _errorMessage;
  List<MutualFundListEntity> _funds = [];

  @override
  void initState() {
    super.initState();
    _fetchFunds();
  }

  Future<void> _fetchFunds() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (!Get.isRegistered<GetFundsByManagerUseCase>()) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Manager service is not available.';
        });
        return;
      }

      final useCase = Get.find<GetFundsByManagerUseCase>();
      final result = await useCase(widget.managerId);

      result.fold(
        (success) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _funds = success.data?.data ?? [];
            });
          }
        },
        (error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage =
                  error.message ?? 'Failed to load funds for this manager.';
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An unexpected error occurred: $e';
        });
      }
    }
  }

  void _onFundSelected(MutualFundListEntity fund) {
    Navigator.of(context).pop();

    final navData = {
      'scheme': fund.baseSchemeName,
      'imgUrl': '${Appurl.baseUrl}${fund.amc?.amcLogoUrl ?? ''}',
      'scheme_code': fund.schemeCode?.toString() ?? '',
      'isin': fund.isin ?? fund.baseSchemeName ?? '',
      'email': fund.amc?.email,
      'address': fund.amc?.address,
      'contact': fund.amc?.contact,
      'is_purchase_allowed': fund.isPurchaseAllowed,
      'is_sip_allowed': fund.isSipAllowed,
      'is_lumpsum_allowed': fund.isLumpsumAllowed,
      'allowed_sip_dates': fund.allowedSipDates,
      'rta_amc_code': fund.rtaAmcCode,
      'amc_name': fund.amc?.amcName,
      'fund_manager_id': fund.fundManagerId,
      'fund_managers': fund.fundManagers,
    };

    if (kIsWeb && Get.isRegistered<NavigationBarController>()) {
      final navController = Get.find<NavigationBarController>();
      if (Get.isRegistered<FundDetailsController>()) {
        Get.delete<FundDetailsController>();
      }
      navController.openNestedRoute(
        AppRoutes.funddetails,
        queryParameters: {
          'scheme': fund.baseSchemeName ?? '',
          'scheme_code': fund.schemeCode?.toString() ?? '',
          'isin': fund.isin ?? '',
        },
        arguments: navData,
      );
    } else {
      if (Get.isRegistered<FundDetailsController>()) {
        Get.delete<FundDetailsController>();
      }
      FundDetailsScreen.navData = navData;
      Get.toNamed(
        AppRoutes.funddetails,
        arguments: navData,
        preventDuplicates: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8F0)),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isWeb) ...[
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Ucolors.skyblue1,
                child: Icon(Icons.person, color: Ucolors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.managerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: UTextStyles.large.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Ucolors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Fund Manager',
                      style: UTextStyles.small.copyWith(
                        color: Ucolors.darkgrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                color: Colors.grey.shade600,
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 2.5, color: Ucolors.primary),
            const SizedBox(height: 16),
            Text(
              'Loading funds managed by ${widget.managerName}...',
              style: UTextStyles.medium.copyWith(color: Ucolors.darkgrey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: UTextStyles.medium.copyWith(color: Colors.grey.shade800),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchFunds,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Ucolors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_funds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder_open_rounded,
                size: 52,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                'No funds currently found for ${widget.managerName}.',
                textAlign: TextAlign.center,
                style: UTextStyles.medium.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: _funds.length,
      itemBuilder: (context, index) {
        final fund = _funds[index];
        return MutualFundCard(
          entity: fund,
          onTapOverride: () => _onFundSelected(fund),
        );
      },
    );
  }
}
