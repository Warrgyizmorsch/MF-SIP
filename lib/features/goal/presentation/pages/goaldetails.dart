// ignore_for_file: unnecessary_to_list_in_spreads, invalid_null_aware_operator, unnecessary_null_comparison, unused_local_variable

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../widget/goal_progress_indicator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/common/widget/animated/dialog_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:my_sip/features/dashboard/domain/entity/portfolio_entity.dart';
import 'package:my_sip/features/dashboard/presentation/widgets/portfolio_fund_details_modal.dart';
import 'package:my_sip/features/goal/presentation/controller/goal_sip_controller.dart';
import 'package:my_sip/features/goal/presentation/widget/GoalDetailsIndicator.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../common/widget/images/image_picker.dart';
import '../widget/add_fund_bottom_sheet.dart';
import '../widget/goal_linked_funds_shimmer.dart';

import '../../domain/entity/goal_entity.dart';
import '../../domain/entity/single_goal_detail_entity.dart';

extension GoalLinkedFundMapper on GoalLinkedFundEntity {
  MfuPortfolioItemEntity toPortfolioItem({String? goalName}) {
    final String formattedLogo = amcLogo.isNotEmpty
        ? (amcLogo.startsWith('http') ? amcLogo : "${Appurl.baseUrl}/$amcLogo")
        : (amcImageUrl.isNotEmpty
            ? (amcImageUrl.startsWith('http')
                ? amcImageUrl
                : "${Appurl.baseUrl}/$amcImageUrl")
            : '');

    final bool isSipBool = isSip ||
        investmentType.toLowerCase() == 'sip' ||
        type.toLowerCase() == 'sip';

    final String invType = investmentType.isNotEmpty
        ? investmentType
        : (type.isNotEmpty ? type : (isSipBool ? 'sip' : 'lumpsum'));

    final double invAmt = fundInvested > 0
        ? fundInvested
        : (investmentAmount > 0 ? investmentAmount : investedAmount);

    final double unitsVal = totalUnits > 0 ? totalUnits : units;
    final double navVal = currentNav > 0 ? currentNav : nav;
    final double oneDChange = oneDayReturn != 0 ? oneDayReturn : dayChange;
    final double oneDChangePct =
        oneDayChangePercent != 0 ? oneDayChangePercent : dayChangePercent;

    String resolvedExitLoad = exitLoad;
    if (resolvedExitLoad.isEmpty && Get.isRegistered<DashboardController>()) {
      final portfolioFunds =
          Get.find<DashboardController>().portfolioData.value?.portfolio;
      final match = portfolioFunds?.firstWhereOrNull(
        (p) =>
            p.schemeCode == schemeCode ||
            (folioNo.isNotEmpty && p.folioNo == folioNo),
      );
      if (match != null && match.exitLoad.isNotEmpty) {
        resolvedExitLoad = match.exitLoad;
      }
    }

    return MfuPortfolioItemEntity(
      schemeCode: schemeCode,
      fundName: fundName,
      amcName: '',
      amcLogo: formattedLogo,
      investmentType: invType,
      investedAmount: invAmt,
      totalUnits: unitsVal,
      currentNav: navVal,
      currentValue: currentValue,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
      oneDayChange: oneDChange,
      oneDayChangePercent: oneDChangePct,
      purchaseNav: purchaseNav,
      purchaseDate: investedDate,
      folioNo: folioNo,
      lastTransactionDate: investedDate,
      navDate: navDate,
      navChange: navChange,
      allotmentStatus: allotmentStatus,
      unitStatus: unitStatus,
      allotmentStatusLabel: allotmentStatusLabel,
      allotmentMessage: allotmentMessage,
      isUnitAllotted: isUnitAllotted,
      mfuOrderFundId: mfuOrderFundId != 0 ? mfuOrderFundId : id,
      mfuOrderId: mfuOrderId != 0 ? mfuOrderId : null,
      goalId: goalId != 0 ? goalId : null,
      goalName: goalName,
      hasPendingRedemption: hasPendingRedemption,
      redemptionStatus: redemptionStatus ?? '',
      redemptionMessage: redemptionMessage ?? '',
      redemptionDetails: redemptionDetails.isNotEmpty
          ? MfuRedemptionDetailsEntity(
              orderRefNo: redemptionDetails.first.orderRefNo,
              gorn: redemptionDetails.first.gorn,
              amount: redemptionDetails.first.amount,
              units: redemptionDetails.first.units,
              transactionVolumeType:
                  redemptionDetails.first.transactionVolumeType,
              requestedDate: redemptionDetails.first.requestedDate,
              status: redemptionDetails.first.status,
              statusCode: redemptionDetails.first.statusCode,
              estimatedPayoutDays: redemptionDetails.first.estimatedPayoutDays,
              message: redemptionDetails.first.message,
            )
          : null,
      redeemedAmount: redeemedAmount,
      redeemedUnits: redeemedUnits,
      isSipFlag: isSipBool,
      sipStatus: sipStatus ?? '',
      isSipCancelled: isSipCancelled,
      hasPendingSipCancellation: hasPendingSipCancellation,
      latestOrderStatus:
          latestOrderStatus.isNotEmpty ? latestOrderStatus : orderStatus,
      latestOrderStatusLabel: latestOrderStatusLabel,
      exitLoad: resolvedExitLoad,
    );
  }
}

extension LegacyGoalFundMapper on GoalFundEntity {
  MfuPortfolioItemEntity toPortfolioItem({String? goalName}) {
    final String logo = mutualFund?.amc?.amcLogo ?? '';
    final String formattedLogo = logo.isNotEmpty
        ? (logo.startsWith('http') ? logo : "${Appurl.baseUrl}/$logo")
        : '';

    final bool isSipBool = orderType.toLowerCase() == 'sip' || sipAmount > 0;
    final double invAmt = sipAmount > 0 ? sipAmount : lumpsumAmount;

    String resolvedExitLoad = '';
    if (Get.isRegistered<DashboardController>()) {
      final portfolioFunds =
          Get.find<DashboardController>().portfolioData.value?.portfolio;
      final match = portfolioFunds?.firstWhereOrNull(
        (p) => p.schemeCode == schemeCode,
      );
      if (match != null && match.exitLoad.isNotEmpty) {
        resolvedExitLoad = match.exitLoad;
      }
    }

    return MfuPortfolioItemEntity(
      schemeCode: schemeCode,
      fundName: mutualFund?.schemeName ?? 'Unknown Fund',
      amcName: mutualFund?.amc?.amcName ?? '',
      amcLogo: formattedLogo,
      investmentType:
          orderType.isNotEmpty ? orderType : (isSipBool ? 'sip' : 'lumpsum'),
      investedAmount: invAmt,
      totalUnits: 0.0,
      currentNav: 0.0,
      currentValue: invAmt,
      gainLoss: 0.0,
      gainLossPercent: 0.0,
      oneDayChange: 0.0,
      oneDayChangePercent: 0.0,
      purchaseNav: 0.0,
      purchaseDate: orderDate,
      folioNo: '',
      lastTransactionDate: orderDate,
      allotmentStatus: status,
      unitStatus: status,
      latestOrderStatus: mfuOrderStatus,
      mfuOrderFundId: id,
      goalId: goalId != 0 ? goalId : null,
      goalName: goalName,
      isSipFlag: isSipBool,
      exitLoad: resolvedExitLoad,
    );
  }
}

/// ----------------------------------------------------------------------
/// Main Entry Page Router
/// ----------------------------------------------------------------------
class GoalDetailsPage extends GetView<GoalSipController> {
  const GoalDetailsPage({super.key});

  static Map<String, dynamic>? tempData;

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map<String, dynamic>?) ?? tempData;
    tempData = null;

    final UserGoalEntity? initialGoal = args?['goal'] as UserGoalEntity?;
    final int currentGoalId =
        initialGoal?.id ??
        (args?['goalId'] as int?) ??
        int.tryParse(Get.parameters['id'] ?? '') ??
        0;

    if (args == null && currentGoalId == 0) {
      return const Scaffold(body: Center(child: Text("Error: No data found")));
    }

    if (currentGoalId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.currentGoalDetail.value?.id != currentGoalId) {
          controller.fetchSingleGoal(currentGoalId);
        }
      });
    }

    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Obx(() {
      final liveDetail = controller.currentGoalDetail.value;
      final bool isCurrentGoalMatch =
          liveDetail != null && liveDetail.id == currentGoalId;
      final matchedGoal = controller.goalResponse.value?.data?.firstWhereOrNull(
        (g) => g.id == currentGoalId,
      );

      final UserGoalEntity? goal = (isCurrentGoalMatch && liveDetail != null)
          ? UserGoalEntity(
              id: liveDetail.id,
              userId: initialGoal?.userId ?? 0,
              goalId: (initialGoal != null && initialGoal.goalId > 0)
                  ? initialGoal.goalId
                  : liveDetail.id,
              goalName: liveDetail.goalName.isNotEmpty
                  ? liveDetail.goalName
                  : (initialGoal?.goalName ?? ''),
              goalCover: liveDetail.goalCover.isNotEmpty
                  ? liveDetail.goalCover
                  : (initialGoal?.goalCover ?? ''),
              txnType: (initialGoal?.txnType.isNotEmpty ?? false)
                  ? initialGoal!.txnType
                  : 'sip',
              lumpsumAmount: (initialGoal?.lumpsumAmount ?? 0.0) > 0
                  ? initialGoal!.lumpsumAmount
                  : 0.0,
              targetAmount: liveDetail.targetAmount > 0
                  ? liveDetail.targetAmount
                  : (initialGoal?.targetAmount ?? 0.0),
              frequency: (initialGoal?.frequency.isNotEmpty ?? false)
                  ? initialGoal!.frequency
                  : 'Monthly',
              monthlyInvestment: liveDetail.monthlySavings > 0
                  ? liveDetail.monthlySavings
                  : (initialGoal?.monthlyInvestment ?? 0.0),
              expectedReturnRate:
                  (initialGoal != null && initialGoal.expectedReturnRate > 0)
                  ? initialGoal.expectedReturnRate
                  : 12.0,
              goalTenure: liveDetail.goalTenure > 0
                  ? liveDetail.goalTenure
                  : (initialGoal?.goalTenure ?? 0),
              investedAmount: liveDetail.savedAmount > 0
                  ? liveDetail.savedAmount
                  : (initialGoal?.investedAmount ?? 0.0),
              status: liveDetail.status.isNotEmpty
                  ? liveDetail.status
                  : (initialGoal?.status ?? 'pending'),
              mfuOrderStatus: initialGoal?.mfuOrderStatus ?? '',
              progressPercent: liveDetail.progressPercent,
              goalType: initialGoal?.goalType ?? matchedGoal?.goalType,
              goalFunds: initialGoal?.goalFunds ?? [],
            )
          : (initialGoal ?? matchedGoal);

      final String effectiveType = (isCurrentGoalMatch && liveDetail.goalName.isNotEmpty)
          ? liveDetail.goalName
          : (goal?.goalType?.typeName ?? goal?.goalName ?? '');
      final double liveProgress = isCurrentGoalMatch
          ? liveDetail.progressPercent
          : (goal?.progressPercent ?? 0.0);
      final String emoji = (args?['emoji'] != null && args!['emoji'] != '🎯')
          ? args['emoji']
          : controller.getGoalEmoji(
              effectiveType,
              progressPercent: liveProgress,
            );
      final double target = isCurrentGoalMatch && liveDetail.targetAmount > 0
          ? liveDetail.targetAmount
          : (args?['target'] ?? (goal?.targetAmount ?? 0.0));

      final double invested = isCurrentGoalMatch
          ? liveDetail.savedAmount
          : (args?['invested'] ??
                (goal != null && goal.investedAmount > 0
                    ? goal.investedAmount
                    : (target * ((goal?.progressPercent ?? 0) / 100))));

      final String logo =
          (isCurrentGoalMatch && liveDetail.goalCover.isNotEmpty)
          ? liveDetail.goalCover
          : ((goal != null && goal.goalCover.isNotEmpty)
                ? goal.goalCover
                : (goal?.goalType?.logo ?? ""));

      final String title = isCurrentGoalMatch && liveDetail.goalName.isNotEmpty
          ? liveDetail.goalName
          : (goal?.goalName ?? 'Goal Details');

      void onEdit() =>
          _showEditGoalDialog(context, currentGoalId, goal, isDesktop);
      void onDelete() => _showDeleteGoalDialog(context, currentGoalId);

      void onAddFunds() {
        if (currentGoalId != 0) {
          AddFundBottomSheet.show(
            context,
            goalId: currentGoalId,
            goal: goal,
            liveDetail: isCurrentGoalMatch ? liveDetail : null,
            isDesktop: isDesktop,
          ).then((_) {
            controller.fetchSingleGoal(currentGoalId);
            controller.getAllGoals();
          });
        } else {
          Get.snackbar("Error", "Goal ID is missing.");
        }
      }

      if (isDesktop) {
        return Scaffold(
          backgroundColor: Ucolors.white,
          body: GoalDetailsWebView(
            title: title,
            goal: goal,
            emoji: logo.isNotEmpty ? logo : emoji,
            target: target,
            invested: invested,
            logo: logo,
            onEdit: onEdit,
            onDelete: onDelete,
            onAddFunds: onAddFunds,
            controller: controller,
          ),
        );
      }

      return GoalDetailsMobileView(
        title: title,
        goal: goal,
        emoji: emoji,
        target: target,
        invested: invested,
        logo: logo,
        onEdit: onEdit,
        onDelete: onDelete,
        onAddFunds: onAddFunds,
      );
    });
  }

  void _showDeleteGoalDialog(BuildContext context, int currentGoalId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete Goal"),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this goal?",
            style: TextStyle(fontFamily: FontFamily.medium, fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await controller.deleteGoal(currentGoalId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showEditGoalDialog(
    BuildContext context,
    int currentGoalId,
    UserGoalEntity? goal,
    bool isDesktop,
  ) {
    final liveDetail = controller.currentGoalDetail.value;
    final int resolvedId = currentGoalId != 0
        ? currentGoalId
        : (liveDetail?.id ?? (goal?.id ?? 0));

    if (resolvedId == 0) {
      Get.snackbar("Error", "Goal ID is missing.");
      return;
    }

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _EditGoalSheetContent(
                    goalId: resolvedId,
                    goal: goal,
                    liveDetail: liveDetail,
                    controller: controller,
                    isDesktop: true,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: _EditGoalSheetContent(
                goalId: resolvedId,
                goal: goal,
                liveDetail: liveDetail,
                controller: controller,
                isDesktop: false,
              ),
            ),
          );
        },
      );
    }
  }
}

/// ----------------------------------------------------------------------
/// In-Context Edit Goal Modal Content (Approach 1)
/// ----------------------------------------------------------------------
class _EditGoalSheetContent extends StatefulWidget {
  final int goalId;
  final UserGoalEntity? goal;
  final SingleGoalDetailEntity? liveDetail;
  final GoalSipController controller;
  final bool isDesktop;

  const _EditGoalSheetContent({
    required this.goalId,
    required this.goal,
    required this.liveDetail,
    required this.controller,
    required this.isDesktop,
  });

  @override
  State<_EditGoalSheetContent> createState() => _EditGoalSheetContentState();
}

class _EditGoalSheetContentState extends State<_EditGoalSheetContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetInput;
  late final TextEditingController _yearsInput;
  late double _targetAmount;
  late double _years;
  late double _rate;
  bool _isSaving = false;
  bool _isPickingCover = false;
  XFile? _selectedCover;
  Uint8List? _coverBytes;

  String _resolveCoverUrl(String path) {
    final value = path.trim();
    final uri = Uri.tryParse(value);
    if (value.isEmpty || uri == null) return '';
    if (uri.hasScheme) return value;
    return '${Appurl.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/${value.replaceFirst(RegExp(r'^/+'), '')}';
  }

  String get _existingCoverUrl {
    final live = widget.liveDetail;
    final cover = live?.id == widget.goalId ? live!.goalCover : '';
    return _resolveCoverUrl(
      cover.trim().isNotEmpty ? cover : (widget.goal?.goalCover ?? ''),
    );
  }

  Future<void> _pickCover(ImageSource source) async {
    if (!mounted || _isSaving || _isPickingCover) return;
    setState(() => _isPickingCover = true);
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image == null || !mounted) return;
      final bytes = await image.readAsBytes();
      if (bytes.isEmpty) throw const FormatException('Empty image');
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 160);
      try {
        final frame = await codec.getNextFrame();
        frame.image.dispose();
      } finally {
        codec.dispose();
      }
      if (!mounted) return;
      setState(() {
        _selectedCover = image;
        _coverBytes = bytes;
      });
    } catch (_) {
      if (mounted) {
        Get.snackbar(
          'Image unavailable',
          'Could not read this image. Please choose another image.',
        );
      }
    } finally {
      if (mounted) setState(() => _isPickingCover = false);
    }
  }

  Widget _coverEditor() {
    final url = _existingCoverUrl;
    final bytes = _coverBytes;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE4E6EE)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: bytes != null
                ? Image.memory(
                    bytes,
                    width: 80,
                    height: 80,
                    cacheWidth: 160,
                    fit: BoxFit.cover,
                  )
                : CustomCachedImage(
                    imageUrl: url,
                    width: 80,
                    height: 80,
                    radius: 12,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Goal image',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: _isSaving || _isPickingCover
                      ? null
                      : () => UImagePicker.showImageSourceOptions(
                          context: context,
                          onImageSelected: _pickCover,
                        ),
                  icon: _isPickingCover
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 20,
                        ),
                  label: Text(
                    _isPickingCover
                        ? 'Reading image…'
                        : (bytes != null || url.isNotEmpty
                              ? 'Change image'
                              : 'Add image'),
                  ),
                  style: TextButton.styleFrom(foregroundColor: Ucolors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshCoverCache() async {
    final detail = widget.controller.currentGoalDetail.value;
    final urls = {
      _existingCoverUrl,
      if (detail?.id == widget.goalId) _resolveCoverUrl(detail!.goalCover),
    }..remove('');
    try {
      for (final url in urls) {
        await CachedNetworkImage.evictFromCache(url);
      }
    } catch (_) {
      // A cache failure must not turn a confirmed goal update into a failure.
    }
    if (!widget.controller.isClosed) {
      widget.controller.currentGoalDetail.refresh();
      widget.controller.goalResponse.refresh();
    }
  }

  @override
  void initState() {
    super.initState();
    final live = widget.liveDetail;
    final initialName = (live?.goalName.isNotEmpty ?? false)
        ? live!.goalName
        : (widget.goal?.goalName ?? '');
    _nameController = TextEditingController(text: initialName);

    _targetAmount = (live != null && live.targetAmount > 0)
        ? live.targetAmount
        : (widget.goal?.targetAmount ?? 1000000.0);

    int rawTenure = (live != null && live.goalTenure > 0)
        ? live.goalTenure
        : (widget.goal?.goalTenure ?? 0);
    if (rawTenure > 30) {
      _years = (rawTenure / 12).clamp(1.0, 30.0);
    } else if (rawTenure > 0) {
      _years = rawTenure.toDouble().clamp(1.0, 30.0);
    } else {
      _years = 5.0;
    }

    _rate = (widget.goal != null && widget.goal!.expectedReturnRate > 0)
        ? widget.goal!.expectedReturnRate.clamp(1.0, 30.0)
        : 12.0;
    _targetInput = TextEditingController(
      text: _targetAmount.toInt().toString(),
    );
    _yearsInput = TextEditingController(text: _years.toInt().toString());
  }

  @override
  void dispose() {
    _targetInput.dispose();
    _yearsInput.dispose();
    _nameController.dispose();
    super.dispose();
  }

  double _calcMonthlySip() {
    final int totalMonths = (_years * 12).round();
    if (totalMonths <= 0 || _targetAmount <= 0) return 0.0;
    final annual = _rate / 100;
    final r = math.pow(1 + annual, 1 / 12) - 1;
    if (r == 0) return (_targetAmount / totalMonths);
    final factor = ((math.pow(1 + r, totalMonths) - 1) / r) * (1 + r);
    final exact = _targetAmount / factor;
    return ((exact / 10).round() * 10).toDouble();
  }

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  Future<void> _handleSave() async {
    if (_isSaving || _isPickingCover) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        "Required",
        "Please enter a goal name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSaving = true);
    final monthly = _calcMonthlySip();
    final success = await widget.controller.updateGoalDetails(
      goalId: widget.goalId,
      goalName: name,
      targetAmount: _targetAmount,
      expectedReturnRate: _rate,
      monthlyInvestment: monthly,
      goalTenure: (_years * 12).round(),
      goalCover: _selectedCover,
    );
    if (success && _selectedCover != null) {
      await _refreshCoverCache();
    }
    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _mobileEdit() {
    final monthly = _calcMonthlySip();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: _TrackingStyle.line),
    );
    InputDecoration decoration({String? prefix}) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      prefixText: prefix,
      prefixStyle: _TrackingStyle.text(
        16,
        color: _TrackingStyle.muted,
        weight: FontWeight.w800,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: _TrackingStyle.purple),
      ),
    );
    Widget field(String label, Widget input) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: _TrackingStyle.text(
            13,
            color: _TrackingStyle.muted,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 54, child: input),
      ],
    );
    Widget slider(
      double value,
      double min,
      double max,
      ValueChanged<double> onChanged,
    ) => SizedBox(
      height: 18,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          activeTrackColor: _TrackingStyle.purple,
          inactiveTrackColor: const Color(0xFFE9E5F3),
          thumbColor: _TrackingStyle.purple,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          overlayShape: SliderComponentShape.noOverlay,
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          padding: EdgeInsets.zero,
          onChanged: _isSaving ? null : onChanged,
        ),
      ),
    );
    Widget step(String label, VoidCallback onTap) => Material(
      color: const Color(0xFFF1F4F9),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: _isSaving ? null : onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Text(
              label,
              style: _TrackingStyle.text(18, weight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFA7A7A7),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.directions_car_outlined,
                    size: 18,
                    color: _TrackingStyle.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Goal',
                        style: _TrackingStyle.text(14, weight: FontWeight.w600),
                      ),
                      Text(
                        'Adjust targets and investments duration',
                        style: _TrackingStyle.text(
                          9,
                          color: _TrackingStyle.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFA7A7A7),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _coverEditor(),
            const SizedBox(height: 14),
            field(
              'Goal name',
              TextFormField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: decoration(),
                style: _TrackingStyle.text(16, weight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 14),
            field(
              'I Need',
              TextFormField(
                controller: _targetInput,
                enabled: !_isSaving,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: decoration(prefix: '₹ '),
                style: _TrackingStyle.text(16, weight: FontWeight.w800),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(
                      () => _targetAmount = parsed.clamp(10000, 10000000),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            slider(
              _targetAmount,
              10000,
              10000000,
              (value) => setState(() {
                _targetAmount = (value / 10000).round() * 10000.0;
                _targetInput.text = _targetAmount.toInt().toString();
              }),
            ),
            const SizedBox(height: 14),
            field(
              'Duration',
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _TrackingStyle.line),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: TextFormField(
                        controller: _yearsInput,
                        enabled: !_isSaving,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: _TrackingStyle.text(16, weight: FontWeight.w800),
                        onChanged: (value) {
                          final parsed = double.tryParse(value);
                          if (parsed != null) {
                            setState(() => _years = parsed.clamp(1, 30));
                          }
                        },
                      ),
                    ),
                    Text(
                      'Years',
                      style: _TrackingStyle.text(
                        16,
                        color: _TrackingStyle.muted,
                        weight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            slider(
              _years,
              1,
              30,
              (value) => setState(() {
                _years = value.roundToDouble();
                _yearsInput.text = _years.toInt().toString();
              }),
            ),
            const SizedBox(height: 14),
            Container(
              height: 57,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: _TrackingStyle.line),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Expected Return Rate p.a.',
                      style: _TrackingStyle.text(13, weight: FontWeight.w600),
                    ),
                  ),
                  step(
                    '−',
                    () => setState(() => _rate = (_rate - 0.5).clamp(5, 25)),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '${_rate.toStringAsFixed(_rate % 1 == 0 ? 0 : 1)}%',
                      textAlign: TextAlign.center,
                      style: _TrackingStyle.text(15, weight: FontWeight.w800),
                    ),
                  ),
                  step(
                    '+',
                    () => setState(() => _rate = (_rate + 0.5).clamp(5, 25)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBF4),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Monthly SIP',
                    style: _TrackingStyle.text(
                      13,
                      color: const Color(0xFF07894C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${NumberFormat.decimalPattern('en_IN').format(monthly.round())}',
                    style: _TrackingStyle.text(
                      26,
                      color: const Color(0xFF07894C),
                      weight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  height: 56,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF0F1F6),
                    ),
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: _TrackingStyle.text(16, weight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _TrackingStyle.gradient,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isSaving || _isPickingCover
                            ? null
                            : _handleSave,
                        borderRadius: BorderRadius.circular(999),
                        child: Center(
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Update goal',
                                  style: _TrackingStyle.text(
                                    16,
                                    color: Colors.white,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDesktop) return _mobileEdit();
    final monthlySip = _calcMonthlySip();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isDesktop)
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Ucolors.skyblue1,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: Ucolors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Edit Goal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.medium,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        "Adjust targets and investment duration",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: FontFamily.regular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _coverEditor(),
          const SizedBox(height: 18),
          const Text(
            "Goal Name",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "e.g. Dream Car, Marriage",
              prefixIcon: const Icon(
                Iconsax.flag,
                size: 18,
                color: Color(0xFF64748B),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Ucolors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Target Amount",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Ucolors.skyblue1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _fmt(_targetAmount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Ucolors.primary,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _targetAmount.clamp(10000.0, 10000000.0),
            min: 10000.0,
            max: 10000000.0,
            divisions: 200,
            activeColor: Ucolors.primary,
            inactiveColor: const Color(0xFFE2E8F0),
            onChanged: (val) {
              setState(() {
                _targetAmount = (val / 10000).round() * 10000.0;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Duration",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${_years.toInt()} Years (${(_years * 12).toInt()} Mos)",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _years.clamp(1.0, 30.0),
            min: 1.0,
            max: 30.0,
            divisions: 29,
            activeColor: Ucolors.primary,
            inactiveColor: const Color(0xFFE2E8F0),
            onChanged: (val) {
              setState(() {
                _years = val;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Expected Return Rate",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${_rate.toStringAsFixed(1)}% p.a.",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _rate.clamp(5.0, 25.0),
            min: 5.0,
            max: 25.0,
            divisions: 40,
            activeColor: Ucolors.primary,
            inactiveColor: const Color(0xFFE2E8F0),
            onChanged: (val) {
              setState(() {
                _rate = val;
              });
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCFCE7)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Estimated Monthly SIP",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ],
                ),
                Text(
                  _fmt(monthlySip),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving || _isPickingCover ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Ucolors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "Update Goal",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Web Custom Reusable App Bar Component
/// ----------------------------------------------------------------------
class WebCustomAppBarNormal extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String emoji;
  final VoidCallback onAddFunds;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WebCustomAppBarNormal({
    super.key,
    required this.title,
    required this.emoji,
    required this.onAddFunds,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const Gap(12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontFamily: FontFamily.regular,
                ),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "On Track",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF15803D),
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: onAddFunds,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Ucolors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Add Funds",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ),
              const Gap(12),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: TextStyle(fontFamily: FontFamily.regular),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(115);
}

/// ----------------------------------------------------------------------
/// Web View Layout Core Configuration
/// ----------------------------------------------------------------------
class GoalDetailsWebView extends StatelessWidget {
  final String title;
  final UserGoalEntity? goal;
  final String emoji;
  final double target;
  final double invested;
  final String logo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddFunds;
  final GoalSipController controller;

  const GoalDetailsWebView({
    super.key,
    required this.title,
    required this.goal,
    required this.emoji,
    required this.target,
    required this.invested,
    required this.logo,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFunds,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.white,
      appBar: WebCustomAppBarNormal(
        title: title,
        emoji: emoji,
        onAddFunds: onAddFunds,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Main Column Workspace Grid Pane
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GoalOverviewCard(
                            goal: goal,
                            target: target,
                            invested: invested,
                            emoji: emoji,
                            logo: logo,
                            controller: controller,
                          ),
                          const Gap(24),
                          LinkedFundsCard(goal: goal, onAddFunds: onAddFunds),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Right Summary Analytics Column Panel
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const RecentContributionsCard(),
                          const Gap(24),
                          NextMilestoneCard(invested: invested, target: target),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Redesigned Goal Overview UI Block Widget (Grid Approach to Prevent Overflow)
/// ----------------------------------------------------------------------
class GoalOverviewCard extends StatelessWidget {
  final UserGoalEntity? goal;
  final double target;
  final double invested;
  final String emoji;
  final String logo;
  final GoalSipController controller;

  const GoalOverviewCard({
    super.key,
    required this.goal,
    required this.target,
    required this.invested,
    required this.emoji,
    required this.logo,
    required this.controller,
  });

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final liveDetail = controller.currentGoalDetail.value;
      final int resolvedGoalId = (goal != null && goal!.id > 0)
          ? goal!.id
          : (liveDetail?.id ?? 0);
      final bool isMatch =
          liveDetail != null &&
          (resolvedGoalId == 0 || liveDetail.id == resolvedGoalId);

      final double liveSaved = isMatch ? liveDetail.savedAmount : invested;
      final double liveTarget = isMatch && liveDetail.targetAmount > 0
          ? liveDetail.targetAmount
          : target;
      final double liveRemaining = isMatch
          ? liveDetail.remainingAmount
          : (liveTarget - liveSaved).clamp(0.0, double.infinity);

      final double monthly = goal?.monthlyInvestment ?? 0.0;
      final double liveMonthly = isMatch ? liveDetail.monthlySavings : monthly;
      final double liveWeekly = isMatch
          ? liveDetail.weeklySavings
          : ((liveMonthly * 12) / 52);
      final double liveDaily = isMatch
          ? liveDetail.dailySavings
          : ((liveMonthly * 12) / 365);

      final currentYear = DateTime.now().year;
      final dynamic rawDeadlineYear = isMatch && liveDetail.estYear > 0
          ? liveDetail.estYear
          : (currentYear + (goal?.goalTenure ?? 0) / 12);
      final int deadlineYearInt = rawDeadlineYear is int
          ? rawDeadlineYear
          : (rawDeadlineYear as num).floor();

      final String deadlineText = isMatch && liveDetail.deadlineLabel.isNotEmpty
          ? liveDetail.deadlineLabel
                .replaceAll("Deadline ", "")
                .replaceAll("(", "")
                .replaceAll(")", "")
          : "Est. Year $deadlineYearInt";

      final double safeTarget = liveTarget > 0 ? liveTarget : 1;
      final double rawPercent = isMatch && liveDetail.progressPercent > 0
          ? liveDetail.progressPercent
          : (liveTarget > 0 ? (liveSaved / safeTarget * 100) : 0.0);
      final double percentage = (rawPercent / 100).clamp(0.0, 1.0);
      final String percentStr = rawPercent <= 0
          ? "0%"
          : (rawPercent < 1
                ? "${rawPercent.toStringAsFixed(2)}%"
                : (rawPercent < 10
                      ? "${rawPercent.toStringAsFixed(1)}%"
                      : "${rawPercent.toStringAsFixed(0)}%"));
      final String effectiveGoalType = goal?.goalType?.typeName ?? '';
      final String effectiveGoalName = (isMatch && liveDetail.goalName.isNotEmpty)
          ? liveDetail.goalName
          : (goal?.goalName ?? '');
      final Color rawColor = controller.getGoalColor(
        effectiveGoalType,
        goalName: effectiveGoalName,
      );
      final Color progressColor = (rawColor == Colors.grey)
          ? const Color(0xFF213C73)
          : rawColor;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Title
            const Text(
              "Goal Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: FontFamily.regular,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Main Dashboard Panel Split
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: CircularGoalIndicatorDetails(
                    percentage: true,
                    goalName: effectiveGoalName,
                    goalType: effectiveGoalType,
                    targetAmount: liveTarget,
                    investedAmount: liveSaved,
                    progressPercent: rawPercent,
                    emoji: emoji,
                    imageUrl: isMatch && liveDetail.goalCover.isNotEmpty
                        ? liveDetail.goalCover
                        : logo,
                  ),
                ),
                const SizedBox(width: 24),

                // --- RIGHT: Grid Layout Box Panel (Zero Overflow Matrix) ---
                Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.6,
                      children: [
                        _buildGridTile(
                          Iconsax.empty_wallet,
                          "Saved",
                          _fmt(liveSaved),
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.refresh_2,
                          "Remaining",
                          _fmt(liveRemaining),
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.radar,
                          "Target",
                          _fmt(liveTarget),
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.calendar_1,
                          "Deadline",
                          deadlineText,
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.coin,
                          "Daily Savings",
                          _fmt(liveDaily),
                          hasRightBorder: true,
                          hasBottomBorder: true,
                        ),
                        _buildGridTile(
                          Iconsax.wallet_3,
                          "Weekly Savings",
                          _fmt(liveWeekly),
                          hasBottomBorder: true,
                        ),
                        const SizedBox.shrink(),
                        _buildGridTile(
                          Iconsax.card_send,
                          "Monthly Savings",
                          _fmt(liveMonthly),
                          hasLeftBorder: true,
                          hasRightBorder: true,
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Bottom Status Analytics Banner Track
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.trend_up,
                      color: Color(0xFF0066FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                              fontFamily: FontFamily.regular,
                            ),
                            children: [
                              const TextSpan(
                                text: "You are ",
                                style: TextStyle(
                                  fontFamily: FontFamily.regular,
                                ),
                              ),
                              const TextSpan(
                                text: "on track ",
                                style: TextStyle(
                                  color: Color(0xFF0066FF),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontFamily.regular,
                                ),
                              ),
                              TextSpan(
                                text: "to reach your goal by $deadlineYearInt",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 8,
                            backgroundColor: Ucolors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progressColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    percentStr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                      color: progressColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGridTile(
    IconData icon,
    String label,
    String value, {
    bool hasLeftBorder = false,
    bool hasRightBorder = false,
    bool hasBottomBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: hasLeftBorder
              ? const BorderSide(color: Color(0xFFF1F5F9))
              : BorderSide.none,
          right: hasRightBorder
              ? const BorderSide(color: Color(0xFFF1F5F9))
              : BorderSide.none,
          bottom: hasBottomBorder
              ? const BorderSide(color: Color(0xFFF1F5F9))
              : BorderSide.none,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Ucolors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.regular,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.regular,
              color: Color(0xFF1E293B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Redesigned Linked Mutual Funds Grid Widget Blocks
/// ----------------------------------------------------------------------
class LinkedFundsCard extends StatelessWidget {
  final UserGoalEntity? goal;
  final VoidCallback? onAddFunds;
  final bool showHeader;
  const LinkedFundsCard({
    super.key,
    this.goal,
    this.onAddFunds,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final goalSipController = Get.find<GoalSipController>();
    final currentGoalId = goal?.id ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        if (showHeader)
          Obx(() {
            final liveDetail = goalSipController.currentGoalDetail.value;
            final bool hasLiveFunds =
                liveDetail != null &&
                liveDetail.id == currentGoalId &&
                liveDetail.linkedFunds.isNotEmpty;

            final freshGoal =
                goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                  (g) => g.id == currentGoalId,
                ) ??
                goal;

            final int count = hasLiveFunds
                ? liveDetail.linkedFunds.length
                : (freshGoal?.goalFunds.length ?? 0);
            final showCount =
                count > 0 || !goalSipController.isLoadingSingleGoal.value;

            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    const Text(
                      "Linked Mutual Funds",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.regular,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    if (showCount) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Ucolors.skyblue1,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Ucolors.skyblue),
                        ),
                        child: Text(
                          "$count",
                          style: const TextStyle(
                            color: Ucolors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (onAddFunds != null)
                  TextButton(
                    onPressed: onAddFunds,
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: _TrackingStyle.navy,
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            );
          }),
        if (showHeader) const SizedBox(height: 20),

        // Funds Grid View Block
        Obx(() {
          final liveDetail = goalSipController.currentGoalDetail.value;
          final bool hasLiveFunds =
              liveDetail != null &&
              liveDetail.id == currentGoalId &&
              liveDetail.linkedFunds.isNotEmpty;

          final freshGoal =
              goalSipController.goalResponse.value?.data?.firstWhereOrNull(
                (g) => g.id == currentGoalId,
              ) ??
              goal;

          final linkedFunds = freshGoal?.goalFunds ?? [];

          if (!hasLiveFunds && linkedFunds.isEmpty) {
            if (goalSipController.isLoadingSingleGoal.value) {
              return const GoalLinkedFundsShimmer(isDesktop: true);
            }
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Ucolors.skyblue1,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 32,
                      color: Ucolors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "No mutual funds linked yet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Link funds to start tracking your progress towards this goal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontFamily: FontFamily.regular,
                    ),
                  ),
                  if (onAddFunds != null) ...[
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: onAddFunds,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text("Link Your First Fund"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Ucolors.primary,
                        side: const BorderSide(color: Ucolors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          if (hasLiveFunds) {
            final liveFunds = liveDetail.linkedFunds;
            return LayoutBuilder(
              builder: (context, constraints) {
                final scale = MediaQuery.textScalerOf(context).scale(1);
                final int crossAxisCount =
                    (constraints.maxWidth / (360 * scale.clamp(1.0, 2.0)))
                        .floor()
                        .clamp(1, 3);
                final cardWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * 16) /
                    crossAxisCount;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(liveFunds.length, (index) {
                    final fund = liveFunds[index];
                    final String imgUrl = fund.amcLogo.isNotEmpty
                        ? (fund.amcLogo.startsWith('http')
                              ? fund.amcLogo
                              : "${Appurl.baseUrl}/${fund.amcLogo}")
                        : (fund.amcImageUrl.isNotEmpty
                              ? (fund.amcImageUrl.startsWith('http')
                                    ? fund.amcImageUrl
                                    : "${Appurl.baseUrl}/${fund.amcImageUrl}")
                              : '');

                    final int fundId = fund.id != 0
                        ? fund.id
                        : fund.mfuOrderFundId;
                    final double gain = fund.gainLoss;
                    final double gainPercent = fund.gainLossPercent;

                    return SizedBox(
                      width: cardWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              PortfolioFundDetailsModal.show(
                                context,
                                fund.toPortfolioItem(
                                  goalName:
                                      goal?.goalName ?? liveDetail.goalName,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                      ),
                                      color: Colors.white,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: imgUrl.isNotEmpty
                                        ? Image.network(
                                            imgUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(
                                                  Icons.account_balance,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                          )
                                        : const Icon(
                                            Icons.account_balance,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fund.fundName.isNotEmpty
                                              ? fund.fundName
                                              : 'Unknown Fund',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: FontFamily.regular,
                                            fontSize: 13,
                                            color: Color(0xFF0F172A),
                                            height: 1.25,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          runSpacing: 4,
                                          children: [
                                            const Text(
                                              "Invested: ",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF64748B),
                                                fontFamily: FontFamily.regular,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '₹${(fund.fundInvested > 0 ? fund.fundInvested : fund.investedAmount).toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1E293B),
                                                fontFamily: FontFamily.regular,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              child: Text(
                                                "•",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFFCBD5E1),
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              "Current: ",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF64748B),
                                                fontFamily: FontFamily.regular,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              fund.currentValue > 0
                                                  ? '₹${fund.currentValue.toStringAsFixed(0)}'
                                                  : (fund.currentNav > 0
                                                        ? 'NAV ₹${fund.currentNav.toStringAsFixed(2)}'
                                                        : '—'),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF0F172A),
                                                fontFamily: FontFamily.regular,
                                              ),
                                            ),
                                            if (gain != 0 ||
                                                gainPercent != 0) ...[
                                              const SizedBox(width: 4),
                                              Text(
                                                "(${gain >= 0 ? '+' : ''}${gainPercent.toStringAsFixed(1)}%)",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: gain >= 0
                                                      ? const Color(0xFF16A34A)
                                                      : const Color(0xFFDC2626),
                                                  fontFamily:
                                                      FontFamily.regular,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        if (fund.hasPendingRedemption) ...[
                                          const SizedBox(height: 3),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 1.5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFF7ED),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFFDBA74),
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Text(
                                              fund.redeemedUnits > 0
                                                  ? "Redemption Pending (${fund.redeemedUnits.toStringAsFixed(3)} Units)"
                                                  : (fund.redeemedAmount > 0
                                                        ? "Redemption Pending (₹${fund.redeemedAmount.toStringAsFixed(0)})"
                                                        : "Redemption Pending"),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFC2410C),
                                              ),
                                            ),
                                          ),
                                        ] else if (fund.isRedeemed ||
                                            fund.holdingStatus.toLowerCase() ==
                                                'redeemed') ...[
                                          const SizedBox(height: 3),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 1.5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: const Color(0xFFCBD5E1),
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Text(
                                              fund.redeemedUnits > 0
                                                  ? "Redeemed (${fund.redeemedUnits.toStringAsFixed(3)} Units)"
                                                  : (fund.redeemedAmount > 0
                                                        ? "Redeemed (₹${fund.redeemedAmount.toStringAsFixed(0)})"
                                                        : "Redeemed"),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    final bool isDel =
                                        goalSipController.isDeleting[fundId] ??
                                        false;
                                    if (fund.hasPendingRedemption) {
                                      return const SizedBox.shrink();
                                    }
                                    return isDel
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : IconButton(
                                            icon: const Icon(
                                              Iconsax.trash,
                                              size: 17,
                                              color: Color(0xFF94A3B8),
                                            ),
                                            hoverColor: const Color(0xFFFEE2E2),
                                            color: const Color(0xFFEF4444),
                                            tooltip: 'Remove Fund',
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              DialogHelper.showRemoveFundDialog(
                                                fundName:
                                                    fund.fundName.isNotEmpty
                                                    ? fund.fundName
                                                    : 'this fund',
                                                onConfirm: () {
                                                  goalSipController
                                                      .deleteGoalFund(
                                                        id: fundId,
                                                        isEdit: false,
                                                        schemeName:
                                                            fund.fundName,
                                                        goalId: goal?.id,
                                                      );
                                                },
                                              );
                                            },
                                          );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final int crossAxisCount =
                  (constraints.maxWidth / (360 * scale.clamp(1.0, 2.0)))
                      .floor()
                      .clamp(1, 3);
              final cardWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * 16) /
                  crossAxisCount;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(linkedFunds.length, (index) {
                  final fund = linkedFunds[index];
                  final String imgUrl =
                      "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
                  final String displayAmount =
                      freshGoal?.txnType.toLowerCase() == 'sip'
                      ? '₹${fund.sipAmount.toStringAsFixed(0)} / mo'
                      : '₹${fund.lumpsumAmount.toStringAsFixed(0)}';

                  return SizedBox(
                    width: cardWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            PortfolioFundDetailsModal.show(
                              context,
                              fund.toPortfolioItem(
                                goalName: goal?.goalName ?? freshGoal?.goalName,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    imgUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.account_balance,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        fund.mutualFund?.schemeName ??
                                            'Unknown Fund',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: FontFamily.regular,
                                          fontSize: 13,
                                          color: Color(0xFF0F172A),
                                          height: 1.25,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runSpacing: 4,
                                        children: [
                                          const Text(
                                            "Amount: ",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF64748B),
                                              fontFamily: FontFamily.regular,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            displayAmount,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF0F172A),
                                              fontFamily: FontFamily.regular,
                                            ),
                                          ),
                                          if (fund
                                                  .mutualFund
                                                  ?.mfPerformanceScheme
                                                  ?.oneMonth !=
                                              null) ...[
                                            const SizedBox(width: 6),
                                            Text(
                                              "${fund.mutualFund!.mfPerformanceScheme!.oneMonth}% (1M)",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF16A34A),
                                                fontFamily: FontFamily.regular,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(() {
                                  final bool isDel =
                                      goalSipController.isDeleting[fund.id] ??
                                      false;
                                  return isDel
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Iconsax.trash,
                                            size: 17,
                                            color: Color(0xFF94A3B8),
                                          ),
                                          hoverColor: const Color(0xFFFEE2E2),
                                          color: const Color(0xFFEF4444),
                                          tooltip: 'Remove Fund',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            final fundTitle =
                                                fund.mutualFund?.schemeName ??
                                                fund.mutualFund?.schemeCode
                                                    ?.toString() ??
                                                'this fund';
                                            DialogHelper.showRemoveFundDialog(
                                              fundName: fundTitle,
                                              onConfirm: () {
                                                goalSipController
                                                    .deleteGoalFund(
                                                      id: fund.id,
                                                      isEdit: false,
                                                      schemeName:
                                                          fund
                                                              .mutualFund
                                                              ?.schemeCode
                                                              ?.toString() ??
                                                          '',
                                                      goalId: goal?.id,
                                                    );
                                              },
                                            );
                                          },
                                        );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          );
        }),
      ],
    );
  }
}

/// ----------------------------------------------------------------------
/// Vertical Contributions Ledger Interface Stream Panel
/// ----------------------------------------------------------------------
class RecentContributionsCard extends StatelessWidget {
  const RecentContributionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Contributions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.regular,
                  color: Color(0xFF1E293B),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: Ucolors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontFamily.regular,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Iconsax.filter,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ledger List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6, // Matches the 6 items visible in the image
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // Creating dynamic date variations just to mimic the image mockup perfectly
              final dates = [
                "Jan 10, 2024",
                "Jan 03, 2024",
                "Dec 27, 2023",
                "Dec 20, 2023",
                "Dec 13, 2023",
                "Dec 06, 2023",
              ];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side: Circular Calendar Icon + Text Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(
                              0xFFF0F5FF,
                            ), // Soft blue background circle matching your UI
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Iconsax.calendar_2,
                            color: Ucolors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dates[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Funding from salary",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right Side: Amount, Payment Source + Success Badge
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "+ ₹1,000",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                                fontSize: 14,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Local Bank 1",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE8F5E9,
                            ), // Soft green background capsule match
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Success",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              fontFamily: FontFamily.regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Next Milestone Completion Target Container Card
/// ----------------------------------------------------------------------
class NextMilestoneCard extends StatelessWidget {
  final double invested;
  final double target;

  const NextMilestoneCard({
    super.key,
    required this.invested,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Milestone",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEDD5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.flag,
                      color: Color(0xFFEA580C),
                      size: 20,
                    ),
                  ),
                  const Gap(14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ 93,080 more to reach 60%",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: FontFamily.regular,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Gap(2),
                      Text(
                        "Keep it up! You're doing great.",
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: FontFamily.regular,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      value: 0.60,
                      strokeWidth: 4,
                      backgroundColor: Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFEA580C),
                      ),
                    ),
                  ),
                  Text(
                    "60%",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.regular,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Mobile View Layout (Tabbed Switching Container Remains Unchanged)
/// ----------------------------------------------------------------------
class GoalDetailsMobileView extends StatefulWidget {
  final String title;
  final UserGoalEntity? goal;
  final String emoji;
  final double target;
  final double invested;
  final String logo;
  final VoidCallback onEdit, onDelete, onAddFunds;
  const GoalDetailsMobileView({
    super.key,
    required this.title,
    required this.goal,
    required this.emoji,
    required this.target,
    required this.invested,
    required this.logo,
    required this.onEdit,
    required this.onDelete,
    required this.onAddFunds,
  });
  @override
  State<GoalDetailsMobileView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<GoalDetailsMobileView> {
  bool _funds = true;
  final _scroll = ScrollController();
  GoalSipController get c => Get.find<GoalSipController>();
  SingleGoalDetailEntity? get live {
    final detail = c.currentGoalDetail.value;
    return detail != null && detail.id == widget.goal?.id ? detail : null;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  String url(String value) => value.isEmpty
      ? ''
      : Uri.parse(value).hasScheme
      ? value
      : '${Appurl.baseUrl.replaceFirst(RegExp(r'/+$'), '')}/${value.replaceFirst(RegExp(r'^/+'), '')}';
  String money(num amount) =>
      '₹${NumberFormat.decimalPattern('en_IN').format(amount.round())}';
  String compact(num value) => value.abs() >= 100000
      ? '₹${(value / 100000).toStringAsFixed(2)}L'
      : money(value);

  @override
  Widget build(BuildContext context) => Obx(() {
    final detail = live;
    final funds = detail?.linkedFunds ?? <GoalLinkedFundEntity>[];
    final saved = detail?.savedAmount ?? widget.invested;
    final target = detail?.targetAmount ?? widget.target;
    final progress = calculateGoalProgress(
      targetAmount: target,
      investedAmount: saved,
      progressPercent: detail?.progressPercent ?? widget.goal?.progressPercent,
    );
    final monthly =
        detail?.monthlySavings ?? widget.goal?.monthlyInvestment ?? 0;
    final end = DateTime.tryParse(detail?.endDate ?? '');
    final years = end == null
        ? ((widget.goal?.goalTenure ?? 0) > 30
              ? (widget.goal?.goalTenure ?? 0) / 12
              : (widget.goal?.goalTenure ?? 0).toDouble())
        : math.max(0, end.difference(DateTime.now()).inDays / 365);
    final year = (detail?.estYear ?? 0) > 0 ? detail!.estYear : end?.year;
    final gain = funds.fold<double>(0, (sum, f) => sum + f.gainLoss);
    final projected = target;
    return Scaffold(
      backgroundColor: _TrackingStyle.background,
      appBar: AppBar(
        backgroundColor: _TrackingStyle.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        titleSpacing: 20,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circle(Icons.chevron_left, () => Navigator.of(context).pop()),
            Text(
              'Goal Detail',
              style: _TrackingStyle.text(16, weight: FontWeight.w600),
            ),
            Material(
              color: const Color(0xFFF0F1F6),
              shape: const CircleBorder(),
              child: PopupMenuButton<String>(
                tooltip: 'Goal actions',
                icon: const Icon(Icons.more_horiz, size: 22),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: _TrackingStyle.line),
                ),
                popUpAnimationStyle: const AnimationStyle(
                  duration: Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
                onSelected: (value) {
                  if (value == 'edit') widget.onEdit();
                  if (value == 'delete') widget.onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Edit',
                      style: _TrackingStyle.text(
                        12,
                        color: _TrackingStyle.navy,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: _TrackingStyle.text(12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: _TrackingStyle.purple,
        onRefresh: () async {
          if (widget.goal != null) await c.fetchSingleGoal(widget.goal!.id);
        },
        child: SingleChildScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: _TrackingStyle.text(
                  22,
                  weight: FontWeight.w600,
                ).copyWith(letterSpacing: -0.6),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: _TrackingStyle.box(26),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayoutBuilder(
                      builder: (context, bounds) {
                        final height = bounds.maxWidth * 224 / 390;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: SizedBox(
                            height: height,
                            child: widget.logo.isEmpty
                                ? ColoredBox(
                                    color: const Color(0xFFF0F1F6),
                                    child: Center(
                                      child: Icon(
                                        c.getGoalIcon(widget.title),
                                        size: 80,
                                        color: _TrackingStyle.purple,
                                      ),
                                    ),
                                  )
                                : CustomCachedImage(
                                    imageUrl: url(widget.logo),
                                    width: bounds.maxWidth,
                                    height: height,
                                    radius: 26,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _info(
                                      'Plan',
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFBC50),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Text(
                                            '${money(widget.goal?.txnType == 'lumpsum' ? (widget.goal?.lumpsumAmount ?? 0) : (monthly > 0 ? monthly : (widget.goal?.effectiveMonthlySip ?? 0)))}${widget.goal?.txnType == 'lumpsum' ? '' : '/mo'}',
                                            style: _TrackingStyle.text(
                                              12,
                                              weight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _info(
                                      'Due date',
                                      Text(
                                        end == null
                                            ? (detail
                                                          ?.deadlineLabel
                                                          .isNotEmpty ==
                                                      true
                                                  ? detail!.deadlineLabel
                                                  : year == null
                                                  ? '—'
                                                  : '$year')
                                            : '${DateFormat('MMM yyyy').format(end)} · ${years.ceil()} years left',
                                        style: _TrackingStyle.text(
                                          12,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox.expand(
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0, end: progress),
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        curve: Curves.easeOut,
                                        builder: (context, value, child) =>
                                            CircularProgressIndicator(
                                              value: value,
                                              strokeWidth: 6,
                                              color: const Color(0xFFF5A524),
                                              backgroundColor:
                                                  _TrackingStyle.line,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).round()}%',
                                      style: _TrackingStyle.text(
                                        13,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            money(saved),
                            style: _TrackingStyle.text(
                              26,
                              weight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _stat(
                                  'Gain so far',
                                  '${gain >= 0 ? '+' : ''}${money(gain)}',
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _stat(
                                  'Projected${year == null ? '' : ' $year'}',
                                  compact(projected),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _panel(funds),
            ],
          ),
        ),
      ),
    );
  });

  Widget _circle(IconData icon, VoidCallback tap) => Material(
    color: const Color(0xFFF0F1F6),
    shape: const CircleBorder(),
    child: IconButton(
      onPressed: tap,
      icon: Icon(icon, size: 22, color: _TrackingStyle.navy),
    ),
  );
  Widget _info(String title, Widget value) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 82,
        child: Text(
          title,
          style: _TrackingStyle.text(12, color: _TrackingStyle.muted),
        ),
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: value,
        ),
      ),
    ],
  );
  Widget _stat(String title, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: _TrackingStyle.background,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _TrackingStyle.text(11, color: Colors.black)),
        const SizedBox(height: 2),
        Text(
          value,
          style: _TrackingStyle.text(
            20,
            color: const Color(0xFF3023AC),
            weight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );

  int _fundCount(List<GoalLinkedFundEntity> funds) {
    if (funds.isNotEmpty) return funds.length;
    final fresh = c.goalResponse.value?.data.firstWhereOrNull((goal) => goal.id == widget.goal?.id);
    return (fresh ?? widget.goal)?.goalFunds.length ?? 0;
  }

  Widget _panel(List<GoalLinkedFundEntity> funds) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _TrackingStyle.box(26),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFECECF4),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              for (final tab in ['Funds', 'Activity'])
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _funds = tab == 'Funds'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: (_funds == (tab == 'Funds'))
                            ? _TrackingStyle.gradient
                            : null,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tab,
                        style: _TrackingStyle.text(
                          13,
                          color: (_funds == (tab == 'Funds'))
                              ? Colors.white
                              : _TrackingStyle.muted,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_funds) ...[
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8, runSpacing: 4,
            children: [
              Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Linked Mutual Funds', style: _TrackingStyle.text(14, weight: FontWeight.w600)),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFF3EFFF), borderRadius: BorderRadius.circular(999)),
                    child: Text('${_fundCount(funds)}', style: _TrackingStyle.text(12, color: _TrackingStyle.purple, weight: FontWeight.w700))),
                ]),
              TextButton(onPressed: widget.onAddFunds,
                child: Text('Add Fund', style: _TrackingStyle.text(13, color: _TrackingStyle.navy, weight: FontWeight.w600))),
            ],
          ),
          if (c.isLoadingSingleGoal.value && funds.isEmpty)
            const GoalLinkedFundsShimmer()
          else if (funds.isEmpty)
            LinkedFundsCard(goal: widget.goal, onAddFunds: widget.onAddFunds, showHeader: false)
          else
            ...funds.take(2).map(_fundRow),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: widget.onAddFunds,
              icon: const Icon(Icons.add, size: 16, color: _TrackingStyle.navy),
              label: Text('Add more', style: _TrackingStyle.text(13,
                color: _TrackingStyle.navy, weight: FontWeight.w600)),
            ),
          ),
          if (funds.isNotEmpty)
            TextButton(
              onPressed: () => _allFunds(),
              child: Text(
                'See all ${funds.length} Funds',
                style: _TrackingStyle.text(
                  13,
                  color: _TrackingStyle.navy,
                  weight: FontWeight.w600,
                ),
              ),
            ),
        ] else
          ..._activity(funds),
      ],
    ),
  );

  Widget _fundRow(GoalLinkedFundEntity fund) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: const Color(0xFFF0F1F7),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: _TrackingStyle.line),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: ClipOval(
          child: CustomCachedImage(
            imageUrl: url(
              fund.amcLogo.isNotEmpty ? fund.amcLogo : fund.amcImageUrl,
            ),
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          fund.fundName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _TrackingStyle.text(12, weight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Text(
            'Inv: ${money(fund.fundInvested)}   Cur: ${money(fund.currentValue)}   (${fund.gainLossPercent >= 0 ? '+' : ''}${fund.gainLossPercent.toStringAsFixed(1)}%)',
            style: _TrackingStyle.text(10, color: _TrackingStyle.muted),
          ),
        ),
        onTap: () => PortfolioFundDetailsModal.show(
          context,
          fund.toPortfolioItem(goalName: widget.title),
        ),
        trailing: fund.hasPendingRedemption
            ? null
            : Obx(
                () =>
                    (c.isDeleting[fund.id > 0 ? fund.id : fund.mfuOrderFundId] ??
                        false)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        onPressed: () => DialogHelper.showRemoveFundDialog(
                          fundName: fund.fundName,
                          onConfirm: () => c.deleteGoalFund(
                            id: fund.id > 0 ? fund.id : fund.mfuOrderFundId,
                            isEdit: false,
                            schemeName: fund.fundName,
                            goalId: widget.goal?.id,
                          ),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF6E3E7),
                        ),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Color(0xFFFF5368),
                        ),
                      ),
              ),
      ),
    ),
  );

  List<Widget> _activity(List<GoalLinkedFundEntity> funds) {
    final txns = funds.expand((f) => f.transactions).toList()
      ..sort(
        (a, b) => (DateTime.tryParse(b.date) ?? DateTime(1970)).compareTo(
          DateTime.tryParse(a.date) ?? DateTime(1970),
        ),
      );
    return [
      if (txns.isEmpty)
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No transactions yet',
            textAlign: TextAlign.center,
            style: _TrackingStyle.text(13, color: _TrackingStyle.muted),
          ),
        )
      else
        ...txns
            .take(2)
            .map(
              (txn) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F1F7),
                  border: Border.all(color: _TrackingStyle.line),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      ['success', 'settled', 'processed', 'completed'].any(
                            (status) =>
                                '${txn.status} ${txn.statusLabel} ${txn.orderStatusLabel}'
                                    .toLowerCase()
                                    .contains(status),
                          )
                          ? Icons.check_circle
                          : Icons.schedule,
                      color: _TrackingStyle.purple,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            txn.investmentType.isEmpty
                                ? txn.type
                                : txn.investmentType,
                            style: _TrackingStyle.text(
                              14,
                              weight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${txn.displayDate.isEmpty ? txn.date : txn.displayDate} · ${txn.statusLabel.isEmpty ? txn.status : txn.statusLabel}',
                            style: _TrackingStyle.text(
                              12,
                              color: _TrackingStyle.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      txn.display?.amount.isNotEmpty == true
                          ? txn.display!.amount
                          : money(txn.amount),
                      style: _TrackingStyle.text(14, weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
      TextButton(
        onPressed: () => Get.to(
          () => Scaffold(
            backgroundColor: _TrackingStyle.background,
            appBar: AppBar(title: const Text('Activity')),
            body: GoalRecordTab(goalId: widget.goal?.id ?? 0),
          ),
        ),
        child: Text(
          txns.isEmpty
              ? 'See all activity'
              : 'See all ${txns.length} instalments',
          style: _TrackingStyle.text(
            13,
            color: _TrackingStyle.navy,
            weight: FontWeight.w600,
          ),
        ),
      ),
    ];
  }

  void _allFunds() => Get.to(
    () => Scaffold(
      backgroundColor: _TrackingStyle.background,
      appBar: AppBar(title: const Text('Linked Funds')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: LinkedFundsCard(
          goal: widget.goal,
          onAddFunds: widget.onAddFunds,
        ),
      ),
    ),
  );
}

class _TrackingStyle {
  static const background = Color(0xFFF5F6FA),
      line = Color(0xFFE4E6EE),
      purple = Color(0xFF441D9E),
      navy = Color(0xFF0E176F),
      muted = Color(0xFF5E6175);
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy, Color(0xFF5B3FE0)],
  );
  static TextStyle text(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color color = const Color(0xFF12121A),
  }) => TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
  static BoxDecoration box(double radius) => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
  );
}

/// ----------------------------------------------------------------------
/// Goal Record / Transactions Tab (Mobile)
/// ----------------------------------------------------------------------
class GoalRecordTab extends StatefulWidget {
  final int goalId;
  const GoalRecordTab({super.key, required this.goalId});

  @override
  State<GoalRecordTab> createState() => _GoalRecordTabState();
}

class _GoalRecordTabState extends State<GoalRecordTab> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GoalSipController>();

    return Obx(() {
      final liveDetail = controller.currentGoalDetail.value;

      // Extract all transactions from all linked funds and include redemption details
      final List<GoalFundTransactionEntity> allTxns = [];
      if (liveDetail != null) {
        for (final fund in liveDetail.linkedFunds) {
          allTxns.addAll(fund.transactions);

          // Add redemption details if not already present in transactions
          for (final r in fund.redemptionDetails) {
            final bool alreadyExists = fund.transactions.any(
              (t) =>
                  (r.orderRefNo.isNotEmpty &&
                      (t.orderId == r.orderRefNo ||
                          t.mfOrderId == r.orderRefNo)) ||
                  (r.gorn.isNotEmpty && t.mfuGorn == r.gorn),
            );

            if (!alreadyExists) {
              final bool isUnits =
                  r.transactionVolumeType.toUpperCase() == 'U' ||
                      (r.amount <= 0 && r.units > 0);

              final String displayAmount = isUnits
                  ? "-${r.units.toStringAsFixed(3)} Units"
                  : (r.amount > 0 ? "-₹${r.amount.toStringAsFixed(2)}" : "");

              allTxns.add(
                GoalFundTransactionEntity(
                  id: 0,
                  txnId: 0,
                  orderId: r.orderRefNo,
                  mfOrderId: r.orderRefNo,
                  date: r.requestedDate,
                  txnDate: r.requestedDate,
                  displayDate: r.requestedDate,
                  type: 'redeem',
                  txtType: 'redeem',
                  investmentType: 'redeem',
                  schemeCode: fund.schemeCode,
                  amfiSchemeCode: fund.schemeCode,
                  mfuSchemeCode: '',
                  fundName: fund.fundName,
                  amcName: '',
                  amcLogo: fund.amcLogo,
                  amcImageUrl: fund.amcImageUrl,
                  folioNo: fund.folioNo,
                  folio: fund.folioNo,
                  amount: r.amount,
                  units: r.units,
                  nav: fund.currentNav,
                  status: r.status,
                  statusLabel: r.statusLabel.isNotEmpty
                      ? r.statusLabel
                      : (r.orderStatusLabel.isNotEmpty
                          ? r.orderStatusLabel
                          : r.status),
                  orderStatus: r.statusCode,
                  orderStatusLabel: r.orderStatusLabel.isNotEmpty
                      ? r.orderStatusLabel
                      : (r.statusLabel.isNotEmpty ? r.statusLabel : r.status),
                  mfuGorn: r.gorn,
                  mfuItrn: '',
                  direction: 'debit',
                  display: GoalFundTransactionDisplayEntity(
                    amount: displayAmount,
                    units: r.units > 0 ? r.units.toStringAsFixed(3) : '',
                  ),
                  goalId: fund.goalId != 0 ? fund.goalId : widget.goalId,
                ),
              );
            }
          }
        }
      }

      // Sort newest first
      allTxns.sort((a, b) {
        final dateA = DateTime.tryParse(a.date.isNotEmpty ? a.date : a.txnDate) ??
            DateTime(1970);
        final dateB = DateTime.tryParse(b.date.isNotEmpty ? b.date : b.txnDate) ??
            DateTime(1970);
        return dateB.compareTo(dateA);
      });

      // Filter by type
      final filteredTxns = allTxns.where((t) {
        if (_selectedFilter == 'All') return true;
        final type = (t.investmentType.isNotEmpty ? t.investmentType : t.type).toLowerCase();
        final isDebit = t.direction.toLowerCase() == 'debit' ||
            type == 'redeem' ||
            type == 'redemption' ||
            type == 'red' ||
            t.txtType.toLowerCase() == 'redeem';

        if (_selectedFilter == 'SIP') {
          return !isDebit && (type == 'sip' || type == 'systematic');
        }
        if (_selectedFilter == 'Lumpsum') {
          return !isDebit && (type == 'lumpsum' || type == 'normal');
        }
        if (_selectedFilter == 'Redeem') {
          return isDebit;
        }
        return true;
      }).toList();

      return RefreshIndicator(
        onRefresh: () async {
          if (widget.goalId != 0) {
            await controller.fetchSingleGoal(widget.goalId);
          }
        },
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Horizontal Filter Chips (only when there are transactions)
            if (allTxns.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: ['All', 'SIP', 'Lumpsum', 'Redeem'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Ucolors.primary,
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Ucolors.primary : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedFilter = filter);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

            if (allTxns.isNotEmpty) const SizedBox(height: 8),

            // Content Area
            Expanded(
              child: filteredTxns.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40,
                            horizontal: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Ucolors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Iconsax.receipt_2,
                                  size: 46,
                                  color: Ucolors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedFilter == 'All'
                                    ? "No transactions yet"
                                    : "No $_selectedFilter transactions",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                  fontFamily: FontFamily.medium,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Transactions for your linked funds will appear here once orders are processed.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontFamily: FontFamily.regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 24, top: 4),
                      itemCount: filteredTxns.length,
                      itemBuilder: (context, index) {
                        return _GoalTransactionCardItem(
                          transaction: filteredTxns[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class _GoalTransactionCardItem extends StatelessWidget {
  final GoalFundTransactionEntity transaction;

  const _GoalTransactionCardItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final txn = transaction;
    final bool isDebit = txn.direction.toLowerCase() == 'debit' ||
        txn.type.toLowerCase() == 'redeem' ||
        txn.investmentType.toLowerCase() == 'redeem';

    final Color amountColor =
        isDebit ? const Color(0xFFE53935) : const Color(0xFF2E7D32);

    final String unitStr = txn.display?.units.isNotEmpty == true
        ? txn.display!.units
        : (txn.units > 0 ? txn.units.toStringAsFixed(3) : '');

    final bool isRedeemInUnits = isDebit &&
        (txn.amount <= 0 || (unitStr.isNotEmpty && txn.amount <= 0));

    final String amountStr;
    if (txn.display?.amount.isNotEmpty == true) {
      amountStr = txn.display!.amount;
    } else if (isRedeemInUnits && unitStr.isNotEmpty) {
      amountStr = "-$unitStr Units";
    } else {
      amountStr = isDebit
          ? "-₹${txn.amount.toStringAsFixed(2)}"
          : "+₹${txn.amount.toStringAsFixed(2)}";
    }

    final String typeLabel = isDebit
        ? (isRedeemInUnits ? 'REDEEM (UNITS)' : 'REDEEM')
        : (txn.investmentType.isNotEmpty
            ? txn.investmentType.toUpperCase()
            : (txn.type.isNotEmpty ? txn.type.toUpperCase() : 'INVESTMENT'));

    final String statusLabel = txn.orderStatusLabel.isNotEmpty
        ? txn.orderStatusLabel
        : (txn.statusLabel.isNotEmpty ? txn.statusLabel : txn.status);

    Color statusBg;
    Color statusColor;
    final lowerStatus = statusLabel.toLowerCase();
    if (lowerStatus.contains('settled') ||
        lowerStatus.contains('processed') ||
        lowerStatus.contains('success')) {
      statusBg = const Color(0xFFE8F5E9);
      statusColor = const Color(0xFF2E7D32);
    } else if (lowerStatus.contains('accept') || lowerStatus.contains('order')) {
      statusBg = const Color(0xFFE3F2FD);
      statusColor = const Color(0xFF1565C0);
    } else if (lowerStatus.contains('pending') ||
        lowerStatus.contains('approval')) {
      statusBg = const Color(0xFFFFF8E1);
      statusColor = const Color(0xFFF57F17);
    } else if (lowerStatus.contains('cancel') || lowerStatus.contains('fail')) {
      statusBg = const Color(0xFFFFEBEE);
      statusColor = const Color(0xFFC62828);
    } else {
      statusBg = const Color(0xFFF5F5F5);
      statusColor = const Color(0xFF616161);
    }

    final String dateStr = txn.displayDate.isNotEmpty
        ? txn.displayDate
        : (txn.date.isNotEmpty ? txn.date : txn.txnDate);

    final String logoUrl = txn.amcLogo.isNotEmpty
        ? (txn.amcLogo.startsWith('http')
            ? txn.amcLogo
            : '${Appurl.baseUrl}/${txn.amcLogo}')
        : (txn.amcImageUrl.isNotEmpty
            ? (txn.amcImageUrl.startsWith('http')
                ? txn.amcImageUrl
                : '${Appurl.baseUrl}/${txn.amcImageUrl}')
            : '');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Logo + Fund name + Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipOval(
                  child: logoUrl.isNotEmpty
                      ? CustomCachedImage(imageUrl: logoUrl, size: 38)
                      : const Icon(
                          Iconsax.empty_wallet,
                          size: 20,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.fundName.isNotEmpty ? txn.fundName : 'Mutual Fund',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: FontFamily.medium,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                amountStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.medium,
                  color: amountColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 0.6, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),

          // Row 2: Status badge + Units / Order ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              if (unitStr.isNotEmpty) ...[
                Text(
                  isDebit
                      ? (isRedeemInUnits
                          ? "$unitStr units${txn.nav > 0 ? ' • NAV ₹${txn.nav.toStringAsFixed(2)}' : ''}"
                          : "-$unitStr units${txn.nav > 0 ? ' @ ₹${txn.nav.toStringAsFixed(2)}' : ''}")
                      : "$unitStr units${txn.nav > 0 ? ' @ ₹${txn.nav.toStringAsFixed(2)}' : ''}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isDebit ? FontWeight.w600 : FontWeight.w400,
                    color: isDebit
                        ? const Color(0xFFC62828)
                        : Colors.grey.shade600,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ] else if (txn.orderId.isNotEmpty) ...[
                Text(
                  "Order: ${txn.orderId}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontFamily: FontFamily.regular,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------
/// Core Reusable UI Sections & Custom Metric Tiles (Fallback for Mobile)
/// ----------------------------------------------------------------------
class GoalDetailSection extends StatelessWidget {
  final UserGoalEntity? goal;
  final double target;
  final double invested;
  final String emoji;
  final String logo;
  final VoidCallback? onAddFunds;

  const GoalDetailSection({
    super.key,
    required this.goal,
    required this.target,
    required this.invested,
    required this.emoji,
    required this.logo,
    this.onAddFunds,
  });

  String _fmt(double amount) {
    return '₹ ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final goalSipController = Get.find<GoalSipController>();

    return Obx(() {
      final liveDetail = goalSipController.currentGoalDetail.value;
      final int resolvedGoalId = (goal != null && goal!.id > 0)
          ? goal!.id
          : (liveDetail?.id ?? 0);
      final bool isMatch =
          liveDetail != null &&
          (resolvedGoalId == 0 || liveDetail.id == resolvedGoalId);

      final double liveSaved = isMatch ? liveDetail.savedAmount : invested;
      final double liveTarget = isMatch && liveDetail.targetAmount > 0
          ? liveDetail.targetAmount
          : target;
      final double liveRemaining = isMatch
          ? liveDetail.remainingAmount
          : (liveTarget - liveSaved).clamp(0.0, double.infinity);

      final double monthly = goal?.monthlyInvestment ?? 0.0;
      final double liveMonthly = isMatch ? liveDetail.monthlySavings : monthly;
      final double liveWeekly = isMatch
          ? liveDetail.weeklySavings
          : ((liveMonthly * 12) / 52);
      final double liveDaily = isMatch
          ? liveDetail.dailySavings
          : ((liveMonthly * 12) / 365);

      final currentYear = DateTime.now().year;
      final dynamic rawDeadlineYear = isMatch && liveDetail.estYear > 0
          ? liveDetail.estYear
          : (currentYear + (goal?.goalTenure ?? 0) / 12);
      final int deadlineYearInt = rawDeadlineYear is int
          ? rawDeadlineYear
          : (rawDeadlineYear as num).floor();

      final String deadlineTitle =
          isMatch && liveDetail.deadlineLabel.isNotEmpty
          ? liveDetail.deadlineLabel
          : 'Deadline (Est. Year $deadlineYearInt)';

      final String effectiveLogo = isMatch && liveDetail.goalCover.isNotEmpty
          ? liveDetail.goalCover
          : logo;

      final bool hasLiveFunds = isMatch && liveDetail.linkedFunds.isNotEmpty;
      final freshGoal =
          goalSipController.goalResponse.value?.data?.firstWhereOrNull(
            (g) => g.id == resolvedGoalId,
          ) ??
          goal;
      final linkedFunds = freshGoal?.goalFunds ?? [];
      final loadingFunds =
          !hasLiveFunds &&
          linkedFunds.isEmpty &&
          goalSipController.isLoadingSingleGoal.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          Center(
            child: CircularGoalIndicatorDetails(
              percentage: true,
              goalName: (isMatch && liveDetail.goalName.isNotEmpty)
                  ? liveDetail.goalName
                  : (goal?.goalName ?? ''),
              goalType: freshGoal?.goalType?.typeName.isNotEmpty == true
                  ? freshGoal!.goalType!.typeName
                  : (goal?.goalType?.typeName ?? ''),
              targetAmount: liveTarget,
              investedAmount: liveSaved,
              progressPercent: isMatch && liveDetail.progressPercent > 0
                  ? liveDetail.progressPercent
                  : (goal?.progressPercent ?? 0.0),
              emoji: emoji,
              imageUrl: effectiveLogo.isNotEmpty
                  ? (effectiveLogo.startsWith('http')
                        ? effectiveLogo
                        : "${Appurl.baseUrl}/$effectiveLogo")
                  : "",
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SmallHeading(smallheading: 'Saving'),
                const Gap(10),
                Row(
                  children: [
                    ValueTitleGoal(value: _fmt(liveSaved), title: 'Saved'),
                    ValueTitleGoal(
                      value: _fmt(liveRemaining),
                      title: 'Remaining',
                    ),
                    ValueTitleGoal(value: _fmt(liveTarget), title: 'Goal'),
                  ],
                ),
                const Gap(20),
                SmallHeading(smallheading: deadlineTitle),
                const Gap(12),
                Row(
                  children: [
                    ValueTitleGoal(
                      value: _fmt(liveDaily),
                      title: 'Daily Savings',
                    ),
                    ValueTitleGoal(
                      value: _fmt(liveWeekly),
                      title: 'Weekly Savings',
                    ),
                    ValueTitleGoal(
                      value: _fmt(liveMonthly),
                      title: 'Monthly Savings',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SmallHeading(smallheading: 'Linked Mutual Funds'),
                  if (!loadingFunds) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Ucolors.skyblue1,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${hasLiveFunds ? liveDetail.linkedFunds.length : linkedFunds.length}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Ucolors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (onAddFunds != null)
                TextButton.icon(
                  onPressed: onAddFunds,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 16,
                    color: Ucolors.primary,
                  ),
                  label: const Text(
                    "Add",
                    style: TextStyle(
                      color: Ucolors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (loadingFunds)
                const GoalLinkedFundsShimmer()
              else if (!hasLiveFunds && linkedFunds.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Ucolors.skyblue1,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 26,
                          color: Ucolors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No mutual funds linked yet',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Link a fund to start building towards this goal.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      if (onAddFunds != null) ...[
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: onAddFunds,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text("Link Fund"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (hasLiveFunds)
                ...liveDetail.linkedFunds.map((fund) {
                  final String imgUrl = fund.amcLogo.isNotEmpty
                      ? (fund.amcLogo.startsWith('http')
                            ? fund.amcLogo
                            : "${Appurl.baseUrl}/${fund.amcLogo}")
                      : (fund.amcImageUrl.isNotEmpty
                            ? (fund.amcImageUrl.startsWith('http')
                                  ? fund.amcImageUrl
                                  : "${Appurl.baseUrl}/${fund.amcImageUrl}")
                            : '');

                  final int fundId = fund.id != 0
                      ? fund.id
                      : fund.mfuOrderFundId;
                  final bool isAllotted = fund.isUnitAllotted;
                  final double gain = fund.gainLoss;
                  final double gainPercent = fund.gainLossPercent;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          PortfolioFundDetailsModal.show(
                            context,
                            fund.toPortfolioItem(
                              goalName:
                                  freshGoal?.goalName ?? liveDetail.goalName,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                backgroundImage: imgUrl.isNotEmpty
                                    ? NetworkImage(imgUrl)
                                    : null,
                                onBackgroundImageError: (_, __) {},
                                child: imgUrl.isEmpty
                                    ? const Icon(
                                        Icons.account_balance,
                                        size: 18,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fund.fundName.isNotEmpty
                                          ? fund.fundName
                                          : 'Unknown Fund',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: UTextStyles.medium.copyWith(
                                        color: const Color(0xFF0F172A),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text(
                                          "Inv: ",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "₹${(fund.fundInvested > 0 ? fund.fundInvested : fund.investedAmount).toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: Text(
                                            "•",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFFCBD5E1),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "Cur: ",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          fund.currentValue > 0
                                              ? "₹${fund.currentValue.toStringAsFixed(0)}"
                                              : (fund.currentNav > 0
                                                    ? "NAV ₹${fund.currentNav.toStringAsFixed(2)}"
                                                    : "—"),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        if (gain != 0 || gainPercent != 0) ...[
                                          const SizedBox(width: 4),
                                          Text(
                                            "(${gain >= 0 ? '+' : ''}${gainPercent.toStringAsFixed(1)}%)",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: gain >= 0
                                                  ? const Color(0xFF16A34A)
                                                  : const Color(0xFFDC2626),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (fund.hasPendingRedemption) ...[
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF7ED),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFFDBA74),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Text(
                                          fund.redeemedUnits > 0
                                              ? "Redemption Pending (${fund.redeemedUnits.toStringAsFixed(3)} Units)"
                                              : (fund.redeemedAmount > 0
                                                    ? "Redemption Pending (₹${fund.redeemedAmount.toStringAsFixed(0)})"
                                                    : "Redemption Pending"),
                                          style: const TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFC2410C),
                                          ),
                                        ),
                                      ),
                                    ] else if (fund.isRedeemed ||
                                        fund.holdingStatus.toLowerCase() ==
                                            'redeemed') ...[
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFCBD5E1),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Text(
                                          fund.redeemedUnits > 0
                                              ? "Redeemed (${fund.redeemedUnits.toStringAsFixed(3)} Units)"
                                              : (fund.redeemedAmount > 0
                                                    ? "Redeemed (₹${fund.redeemedAmount.toStringAsFixed(0)})"
                                                    : "Redeemed"),
                                          style: const TextStyle(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF475569),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Obx(() {
                                final bool deleting =
                                    goalSipController.isDeleting[fundId] ??
                                    false;
                                if (fund.hasPendingRedemption) {
                                  return const SizedBox.shrink();
                                }
                                return deleting
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                          Iconsax.trash,
                                          color: Color(0xFF94A3B8),
                                          size: 17,
                                        ),
                                        padding: const EdgeInsets.only(left: 6),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          DialogHelper.showRemoveFundDialog(
                                            fundName: fund.fundName.isNotEmpty
                                                ? fund.fundName
                                                : 'this fund',
                                            onConfirm: () {
                                              goalSipController.deleteGoalFund(
                                                id: fundId,
                                                isEdit: false,
                                                schemeName: fund.fundName,
                                                goalId: freshGoal?.id,
                                              );
                                            },
                                          );
                                        },
                                      );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
              else
                ...linkedFunds.map((fund) {
                  return Obx(() {
                    final bool deleting =
                        goalSipController.isDeleting[fund.id] ?? false;
                    final String imgUrl =
                        "${Appurl.baseUrl}${fund.mutualFund?.amc?.amcLogo ?? ''}";
                    final String displayAmount =
                        freshGoal?.txnType.toLowerCase() == 'sip'
                        ? _fmt(fund.sipAmount)
                        : _fmt(fund.lumpsumAmount);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          PortfolioFundDetailsModal.show(
                            context,
                            fund.toPortfolioItem(
                              goalName:
                                  freshGoal?.goalName ??
                                  liveDetail?.goalName ??
                                  '',
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        dense: true,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(imgUrl),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.broken_image, size: 18),
                        ),
                        title: Text(
                          fund.mutualFund?.schemeName ?? 'Unknown Fund',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: UTextStyles.medium.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        subtitle:
                            fund.mutualFund?.schemeCategory?.isNotEmpty == true
                            ? Text(
                                fund.mutualFund!.schemeCategory,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF64748B),
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              displayAmount,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            deleting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Iconsax.trash,
                                      color: Color(0xFF94A3B8),
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      final fundTitle = fund.mutualFund?.schemeName ??
                                          fund.mutualFund?.schemeCode?.toString() ??
                                          'this fund';
                                      DialogHelper.showRemoveFundDialog(
                                        fundName: fundTitle,
                                        onConfirm: () {
                                          goalSipController.deleteGoalFund(
                                            id: fund.id,
                                            isEdit: true,
                                            schemeName:
                                                fund.mutualFund?.schemeCode
                                                    ?.toString() ??
                                                '',
                                            goalId: freshGoal?.id,
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    );
                  });
                }).toList(),
            ],
          ),
          const Gap(22),
        ],
      );
    });
  }
}

class ValueTitleGoal extends StatelessWidget {
  const ValueTitleGoal({super.key, required this.value, required this.title});
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: UTextStyles.large.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: UTextStyles.small.copyWith(color: Ucolors.darkgrey),
          ),
        ],
      ),
    );
  }
}
