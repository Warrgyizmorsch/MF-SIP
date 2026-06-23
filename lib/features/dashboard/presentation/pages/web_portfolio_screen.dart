import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';

class WebPortfolioScreen extends StatelessWidget {
  const WebPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF5F7FA),
      child: Obx(() {
        final summary = controller.portfolioData.value?.summary;
        final funds = controller.portfolioData.value?.portfolio ?? [];
        final bool isVisible = controller.isBalanceVisible.value;

        final double currentValue =
            (summary?.totalCurrentValue as num?)?.toDouble() ?? 0.0;
        final double invested =
            (summary?.totalInvested as num?)?.toDouble() ?? 0.0;
        final double gainLoss =
            (summary?.totalGainLoss as num?)?.toDouble() ?? 0.0;
        final bool isProfit = summary?.isOverallProfit ?? true;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     // const _PageHeader(
                //     //   title: 'Manage Portfolio',
                //     //   subtitle:
                //     //       'Track every fund, current value, investment amount and returns from a single web page.',
                //     //   icon: Iconsax.wallet_3,
                //     // ),
                //     InkWell(
                //       onTap: () => controller.isBalanceVisible.toggle(),
                //       borderRadius: BorderRadius.circular(14),
                //       child: Container(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 16,
                //           vertical: 12,
                //         ),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(14),
                //           border: Border.all(color: const Color(0xFFE8EDF5)),
                //         ),
                //         child: Row(
                //           children: [
                //             Icon(
                //               isVisible
                //                   ? Icons.visibility_off_outlined
                //                   : Icons.visibility_outlined,
                //               size: 18,
                //               color: Ucolors.primary,
                //             ),
                //             const SizedBox(width: 8),
                //             Text(
                //               isVisible ? 'Hide Amounts' : 'Show Amounts',
                //               style: const TextStyle(
                //                 fontFamily: FontFamily.medium,
                //                 fontSize: 13,
                //                 fontWeight: FontWeight.w700,
                //                 color: Ucolors.primary,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff0B3C5D), Color(0xff072A40)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff0B3C5D).withValues(alpha: 0.18),
                        blurRadius: 26,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _HeroMetric(
                          title: 'Current Value',
                          value: currentValue,
                          isVisible: isVisible,
                          large: true,
                          showEyeIcon: true,
                          onEyeTap: () => controller.isBalanceVisible.toggle(),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: _HeroMetric(
                          title: 'Invested',
                          value: invested,
                          isVisible: isVisible,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: _HeroMetric(
                          title: 'Total Returns',
                          value: gainLoss,
                          isVisible: isVisible,
                          isProfit: isProfit,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: _HeroCountMetric(
                          title: 'Funds',
                          value: funds.length.toString(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE8EDF5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'All Funds',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Ucolors.dark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F5FF),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${funds.length} funds',
                              style: const TextStyle(
                                fontFamily: FontFamily.medium,
                                fontSize: 12,
                                color: Ucolors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (controller.isLoadingPortfolio.value)
                        const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Ucolors.primary,
                            ),
                          ),
                        )
                      else if (funds.isEmpty)
                        const _EmptyState(
                          icon: Iconsax.wallet_minus,
                          title: 'No funds in portfolio',
                          message:
                              'Your invested mutual funds will appear here after your first purchase.',
                        )
                      else ...[
                        const _PortfolioTableHeader(),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: funds.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade100),
                          itemBuilder: (context, index) {
                            return _PortfolioTableRow(
                              fund: funds[index],
                              isVisible: isVisible,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: Ucolors.backgroundGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Ucolors.primary.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Ucolors.dark,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 14,
                    height: 1.45,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String title;
  final double value;
  final bool isVisible;
  final bool? isProfit;
  final bool large;
  final bool showEyeIcon;
  final VoidCallback? onEyeTap;

  const _HeroMetric({
    required this.title,
    required this.value,
    required this.isVisible,
    this.isProfit,
    this.large = false,
    this.showEyeIcon = false,
    this.onEyeTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool special = isProfit != null;
    final Color valueColor = special
        ? (isProfit! ? Colors.greenAccent : Colors.redAccent)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (showEyeIcon)
                InkWell(
                  onTap: onEyeTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              isVisible
                  ? '${special && !isProfit! ? '-' : ''}₹${value.abs().toStringAsFixed(2)}'
                  : '₹ ••••••',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                color: isVisible ? valueColor : Colors.white70,
                fontSize: large ? 28 : 20,
                fontWeight: FontWeight.w900,
                letterSpacing: isVisible ? -0.4 : 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _HeroMetric extends StatelessWidget {
//   final String title;
//   final double value;
//   final bool isVisible;
//   final bool? isProfit;
//   final bool large;

//   const _HeroMetric({
//     required this.title,
//     required this.value,
//     required this.isVisible,
//     this.isProfit,
//     this.large = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool special = isProfit != null;
//     final Color valueColor = special
//         ? (isProfit! ? Colors.greenAccent : Colors.redAccent)
//         : Colors.white;

//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontFamily: FontFamily.medium,
//               color: Colors.white.withValues(alpha: 0.72),
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             isVisible
//                 ? '${special && !isProfit! ? '-' : ''}₹${value.abs().toStringAsFixed(2)}'
//                 : '₹ ••••••',
//             style: TextStyle(
//               fontFamily: FontFamily.medium,
//               color: isVisible ? valueColor : Colors.white70,
//               fontSize: large ? 28 : 20,
//               fontWeight: FontWeight.w900,
//               letterSpacing: isVisible ? -0.4 : 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _HeroCountMetric extends StatelessWidget {
  final String title;
  final String value;

  const _HeroCountMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioTableHeader extends StatelessWidget {
  const _PortfolioTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Expanded(flex: 4, child: _HeaderText('Fund')),
          Expanded(flex: 2, child: _HeaderText('1D Change')),
          Expanded(flex: 2, child: _HeaderText('Invested', alignRight: true)),
          Expanded(
            flex: 2,
            child: _HeaderText('Current Value', alignRight: true),
          ),
          Expanded(flex: 2, child: _HeaderText('Gain/Loss', alignRight: true)),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  final bool alignRight;

  const _HeaderText(this.text, {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        fontFamily: FontFamily.medium,
        color: Colors.grey.shade600,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _PortfolioTableRow extends StatelessWidget {
  final dynamic fund;
  final bool isVisible;

  const _PortfolioTableRow({required this.fund, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final bool isOneDayProfit = fund.isOneDayProfit;
    final bool isOverallProfit = fund.isProfit;
    final double investedAmount =
        (fund.investedAmount as num?)?.toDouble() ?? 0;
    final double currentValue = (fund.currentValue as num?)?.toDouble() ?? 0;
    final double gainLoss = (fund.gainLoss as num?)?.toDouble() ?? 0;
    final double gainLossPercent =
        (fund.gainLossPercent as num?)?.toDouble() ?? 0;
    final double oneDayChange = (fund.oneDayChange as num?)?.toDouble() ?? 0;
    final double oneDayChangePercent =
        (fund.oneDayChangePercent as num?)?.toDouble() ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: fund.amcLogo.toString().isNotEmpty
                      ? Image.network(
                          fund.amcLogo.toString(),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.account_balance,
                            size: 19,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.account_balance,
                          size: 19,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    fund.fundName.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: FontFamily.medium,
                      fontSize: 13,
                      color: Ucolors.dark,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _ChangeText(
              value: oneDayChange,
              percent: oneDayChangePercent,
              isProfit: isOneDayProfit,
              isVisible: isVisible,
            ),
          ),
          Expanded(
            flex: 2,
            child: _MoneyText(value: investedAmount, isVisible: isVisible),
          ),
          Expanded(
            flex: 2,
            child: _MoneyText(value: currentValue, isVisible: isVisible),
          ),
          Expanded(
            flex: 2,
            child: _ChangeText(
              value: gainLoss,
              percent: gainLossPercent,
              isProfit: isOverallProfit,
              isVisible: isVisible,
              alignRight: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoneyText extends StatelessWidget {
  final double value;
  final bool isVisible;

  const _MoneyText({required this.value, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Text(
      isVisible ? '₹${value.toStringAsFixed(2)}' : '₹ ••••••',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: FontFamily.medium,
        color: isVisible ? Ucolors.dark : Colors.grey.shade500,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: isVisible ? 0 : 1.2,
      ),
    );
  }
}

class _ChangeText extends StatelessWidget {
  final double value;
  final double percent;
  final bool isProfit;
  final bool isVisible;
  final bool alignRight;

  const _ChangeText({
    required this.value,
    required this.percent,
    required this.isProfit,
    required this.isVisible,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isProfit ? Ucolors.success : Ucolors.red;
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          isVisible
              ? '${isProfit ? '+' : '-'}₹${value.abs().toStringAsFixed(2)}'
              : '₹ •••',
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            color: isVisible ? color : Colors.grey.shade500,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: isVisible ? 0 : 1.2,
          ),
        ),
        if (isVisible) ...[
          const SizedBox(height: 3),
          Text(
            '${percent.abs().toStringAsFixed(2)}%',
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: Ucolors.primary, size: 30),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Ucolors.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                color: Colors.grey.shade600,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
