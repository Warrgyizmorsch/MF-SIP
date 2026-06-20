import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/dashboard/presentation/controllers/dashboard_controller.dart';

class WebTransactionsScreen extends StatefulWidget {
  const WebTransactionsScreen({super.key});

  @override
  State<WebTransactionsScreen> createState() => _WebTransactionsScreenState();
}

class _WebTransactionsScreenState extends State<WebTransactionsScreen> {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedTxnFilter.value = 'All';
      controller.getTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final DashboardController controller = Get.find<DashboardController>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF5F7FA),
      child: Obx(() {
        if (controller.isLoadingTransactions.value) {
          return const Center(
            child: CircularProgressIndicator(color: Ucolors.primary),
          );
        }
        if (controller.errorMessageTranscation.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessageTranscation.value));
        }
        final allTransactions =
            controller.transactionList.value?.transactions ?? [];
        final filteredTransactions = controller.filteredTransactions;
        final totalAmount = allTransactions.fold<double>(
          0,
          (sum, txn) => sum + ((txn.amount as num?)?.toDouble() ?? 0),
        );
        final successCount = allTransactions
            .where((txn) => txn.isSuccess)
            .length;
        final failedCount = allTransactions.where((txn) => txn.isFailed).length;
        final pendingCount =
            allTransactions.length - successCount - failedCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _PageHeader(
                //   title: 'Transactions',
                //   subtitle:
                //       'View all SIP, lumpsum and mutual fund transaction activity in one place.',
                //   icon: Iconsax.receipt_2,
                // ),
                // const SizedBox(height: 24),
                // Row(
                //   children: [
                //     Expanded(
                //       child: _SummaryTile(
                //         title: 'Total Transactions',
                //         value: allTransactions.length.toString(),
                //         icon: Iconsax.document_text,
                //         color: Ucolors.primary,
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     Expanded(
                //       child: _SummaryTile(
                //         title: 'Success',
                //         value: successCount.toString(),
                //         icon: Iconsax.tick_circle,
                //         color: Ucolors.success,
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     Expanded(
                //       child: _SummaryTile(
                //         title: 'Pending',
                //         value: pendingCount.toString(),
                //         icon: Iconsax.clock,
                //         color: const Color(0xffF2994A),
                //       ),
                //     ),
                //     const SizedBox(width: 16),
                //     Expanded(
                //       child: _SummaryTile(
                //         title: 'Failed',
                //         value: failedCount.toString(),
                //         icon: Iconsax.close_circle,
                //         color: Ucolors.red,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                // _AmountBanner(amount: totalAmount),
                // const SizedBox(height: 24),
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
                            'All Transactions',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Ucolors.dark,
                            ),
                          ),
                          _FilterPills(controller: controller),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (controller.isLoadingTransactions.value)
                        const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Ucolors.primary,
                            ),
                          ),
                        )
                      else if (allTransactions.isEmpty)
                        const _EmptyState(
                          icon: Iconsax.receipt_text,
                          title: 'No transactions found',
                          message:
                              'Your mutual fund transactions will appear here once you start investing.',
                        )
                      else if (filteredTransactions.isEmpty)
                        _EmptyState(
                          icon: Iconsax.filter_remove,
                          title: 'No matching transactions',
                          message:
                              'No ${controller.selectedTxnFilter.value.toLowerCase()} transactions found.',
                        )
                      else ...[
                        const _TransactionTableHeader(),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredTransactions.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.grey.shade100),
                          itemBuilder: (context, index) {
                            return _TransactionTableRow(
                              transaction: filteredTransactions[index],
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
    return Row(
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
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Ucolors.dark,
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

class _AmountBanner extends StatelessWidget {
  final double amount;

  const _AmountBanner({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0B3C5D), Color(0xff072A40)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Iconsax.wallet_money,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total transaction value',
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
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

class _FilterPills extends StatelessWidget {
  final DashboardController controller;

  const _FilterPills({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.txnFilters.map<Widget>((filter) {
          final bool isSelected = controller.selectedTxnFilter.value == filter;
          return InkWell(
            onTap: () => controller.setTxnFilter(filter),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? Ucolors.primary : const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected ? Ucolors.primary : const Color(0xFFE3EAF3),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TransactionTableHeader extends StatelessWidget {
  const _TransactionTableHeader();

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
          Expanded(flex: 2, child: _HeaderText('Date')),
          Expanded(flex: 3, child: _HeaderText('Type')),
          Expanded(flex: 2, child: _HeaderText('Order ID')),
          Expanded(flex: 2, child: _HeaderText('Status')),
          Expanded(flex: 2, child: _HeaderText('Amount', alignRight: true)),
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

class _TransactionTableRow extends StatelessWidget {
  final dynamic transaction;

  const _TransactionTableRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = transaction.isSuccess
        ? Ucolors.success
        : transaction.isFailed
        ? Ucolors.red
        : const Color(0xffF2994A);
    final String status = transaction.isSuccess
        ? 'Success'
        : transaction.isFailed
        ? 'Failed'
        : 'Pending';
    final double amount = (transaction.amount as num?)?.toDouble() ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              transaction.txnDate.toString(),
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 13,
                color: Ucolors.dark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${transaction.investmentType.toString().toUpperCase()} - ${transaction.txtType.toString().toUpperCase()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.mfOrderId.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 14,
                color: statusColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
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
