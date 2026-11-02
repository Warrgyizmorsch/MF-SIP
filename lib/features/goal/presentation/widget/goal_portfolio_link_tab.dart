import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widget/images/custom_cached_image.dart';
import '../../../../core/utils/constant/appUrl.dart';
import '../../../../core/utils/constant/colors.dart';
import '../../../dashboard/domain/entity/portfolio_entity.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../domain/entity/goal_entity.dart';
import '../../domain/entity/single_goal_detail_entity.dart';
import '../controller/goal_sip_controller.dart';
import 'goal_linked_funds_shimmer.dart';

class GoalPortfolioLinkTab extends StatefulWidget {
  const GoalPortfolioLinkTab({
    super.key,
    required this.goalId,
    this.goal,
    this.liveDetail,
  });

  final int goalId;
  final UserGoalEntity? goal;
  final SingleGoalDetailEntity? liveDetail;

  @override
  State<GoalPortfolioLinkTab> createState() => _GoalPortfolioLinkTabState();
}

class _GoalPortfolioLinkTabState extends State<GoalPortfolioLinkTab> {
  final _goals = Get.find<GoalSipController>();
  final _pendingOrders = <int>{};
  final _pendingSchemes = <String>{};
  final _linkedSchemes = <String>{};
  String? _linkError;

  DashboardController? get _dashboard => Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : null;

  static String _scheme(String code) => code.trim().toUpperCase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _dashboard?.getPortfolio();
    });
  }

  Future<void> _link(MfuPortfolioItemEntity item) async {
    final orderId = item.goalLinkId;
    final scheme = item.normalizedSchemeCode;
    if (widget.goalId <= 0 ||
        orderId <= 0 ||
        scheme.isEmpty ||
        _pendingOrders.contains(orderId) ||
        _pendingSchemes.contains(scheme) ||
        !_goals.canLinkPortfolioFund(item)) {
      return;
    }
    final dashboard = _dashboard;
    final currentDetail = _goals.currentGoalDetail.value;
    final detail = currentDetail?.id == widget.goalId
        ? currentDetail
        : widget.liveDetail;
    final goalName = detail?.goalName ?? widget.goal?.goalName;
    var confirmed = false;
    setState(() {
      _pendingOrders.add(orderId);
      _pendingSchemes.add(scheme);
      _linkError = null;
    });
    try {
      final success = await _goals.linkFundToGoal(
        goalId: widget.goalId,
        holding: item,
        goalName: goalName,
        refreshGoals: false,
      );
      if (!success) {
        if (mounted) {
          setState(() {
            _linkError = 'Could not link this holding. Please try again.';
          });
        }
        return;
      }
      confirmed = true;

      // Reflect the confirmed link before refreshing. Failed refreshes must not
      // make a successfully linked holding available for another submission.
      dashboard?.markHoldingLinked(
        mfuOrderId: orderId,
        goalId: widget.goalId,
        goalName: goalName,
      );
      if (mounted) setState(() => _linkedSchemes.add(scheme));
      await Future.wait([
        if (dashboard != null && !dashboard.isClosed)
          dashboard.getPortfolio(forceRefresh: true),
        if (!_goals.isClosed) _goals.fetchSingleGoal(widget.goalId),
        if (!_goals.isClosed) _goals.getAllGoals(),
      ]);
    } catch (error) {
      debugPrint('[GoalPortfolioLinkTab] Link/refresh failed: $error');
      if (mounted) {
        setState(() {
          _linkError = confirmed
              ? 'Holding linked. Please refresh to update the latest details.'
              : 'Could not link this holding. Please try again.';
        });
      }
    } finally {
      if (confirmed && dashboard != null && !dashboard.isClosed) {
        dashboard.markHoldingLinked(
          mfuOrderId: orderId,
          goalId: widget.goalId,
          goalName: goalName,
        );
      }
      if (mounted) {
        setState(() {
          _pendingOrders.remove(orderId);
          _pendingSchemes.remove(scheme);
        });
      }
    }
  }

  Widget _retryMessage(String message, {String action = 'Retry'}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          TextButton(
            onPressed: () {
              setState(() => _linkError = null);
              _dashboard?.getPortfolio();
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = _dashboard;
    if (dashboard == null) {
      return Center(child: _retryMessage('Your portfolio is unavailable.'));
    }
    return Obx(() {
      final loading = dashboard.isLoadingPortfolio.value;
      final portfolio = dashboard.portfolioData.value;
      final error = dashboard.errorMessagePortfolio.value;
      if (portfolio == null) {
        if (loading) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: GoalLinkedFundsShimmer(),
          );
        }
        return Center(
          child: _retryMessage(
            error.isNotEmpty ? error : 'Unable to load your portfolio.',
          ),
        );
      }

      final allGoals = _goals.goalResponse.value?.data ?? [];
      final currentGoal =
          allGoals.firstWhereOrNull((goal) => goal.id == widget.goalId) ??
          widget.goal;
      final currentDetail = _goals.currentGoalDetail.value;
      final detail = currentDetail?.id == widget.goalId
          ? currentDetail
          : (widget.liveDetail?.id == widget.goalId ? widget.liveDetail : null);
      // Keep a fund scheme exclusive to one goal across holdings and folios.
      final linkedCodes = {
        ..._linkedSchemes,
        for (final goal in allGoals)
          for (final fund in goal.goalFunds) _scheme(fund.schemeCode),
        for (final fund in currentGoal?.goalFunds ?? <GoalFundEntity>[])
          _scheme(fund.schemeCode),
        for (final fund in detail?.linkedFunds ?? <GoalLinkedFundEntity>[])
          _scheme(fund.schemeCode),
      };
      final available = portfolio.portfolio.where((item) {
        return item.currentValue.isFinite &&
            item.currentValue > 0 &&
            item.totalUnits.isFinite &&
            item.totalUnits > 0 &&
            !item.isFullyRedeemed &&
            !item.isRedemptionPending &&
            !item.isAllotmentPending &&
            !item.hasGoalAssociation &&
            !portfolio.portfolio.any(
              (other) =>
                  other.normalizedSchemeCode == item.normalizedSchemeCode &&
                  other.hasGoalAssociation,
            ) &&
            !linkedCodes.contains(_scheme(item.schemeCode));
      }).toList();

      return Column(
        children: [
          if (loading) const LinearProgressIndicator(minHeight: 2),
          if (error.isNotEmpty) _retryMessage(error),
          if (_linkError != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_linkError!, textAlign: TextAlign.center),
            ),
          Expanded(
            child: available.isEmpty
                ? Center(
                    child: _retryMessage(
                      portfolio.portfolio.isEmpty
                          ? 'You have no portfolio holdings yet.'
                          : 'No available holdings to link. Holdings may already be linked, pending, or have no remaining balance.',
                      action: 'Refresh',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: available.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _holding(available[index]),
                  ),
          ),
        ],
      );
    });
  }

  Widget _holding(MfuPortfolioItemEntity item) {
    final orderId = item.goalLinkId;
    final valid =
        widget.goalId > 0 && orderId > 0 && _scheme(item.schemeCode).isNotEmpty;
    final logo = item.amcLogo.trim();
    final logoUrl = logo.startsWith('http') ? logo : '${Appurl.baseUrl}/$logo';
    return Container(
      key: ValueKey('portfolio-holding-$orderId-${item.folioNo}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          if (logo.isNotEmpty)
            CustomCachedImage(imageUrl: logoUrl, size: 36, radius: 8)
          else
            const Icon(Icons.account_balance, color: Ucolors.primary, size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fundName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.investmentType.toUpperCase()} • ₹${item.currentValue.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                if (!valid)
                  const Text(
                    'This holding cannot be linked yet.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Obx(() {
            final controllerBusy = _goals.linkingFundMap[orderId] ?? false;
            final schemeBusy = _goals.linkingSchemeCodes.contains(
              item.normalizedSchemeCode,
            );
            final busy =
                controllerBusy ||
                schemeBusy ||
                _pendingOrders.contains(orderId) ||
                _pendingSchemes.contains(_scheme(item.schemeCode));
            return ElevatedButton(
              onPressed: valid && !busy ? () => _link(item) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Ucolors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
              ),
              child: busy
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(valid ? 'Link' : 'Unavailable'),
            );
          }),
        ],
      ),
    );
  }
}
