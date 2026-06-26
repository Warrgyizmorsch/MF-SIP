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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Ucolors.white,
      child: Obx(() {
        if (controller.isLoadingTransactions.value) {
          return const Center(
            child: CircularProgressIndicator(color: Ucolors.primary),
          );
        }
        if (controller.errorMessageTranscation.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessageTranscation.value));
        }

        final allTransactions = controller.transactionList.value?.transactions ?? [];
        final filteredTransactions = controller.filteredTransactions;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Main Title
              const Text(
                'My Transactions',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 24),

              // Main Active Transactions Card Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Bar with Title and Filter Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Active Transactions',
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          _FilterDropdownButton(controller: controller),
                        ],
                      ),
                    ),

                    // Table Headers (Matching the image layout exactly)
                    const _TransactionTableHeader(),

                    // Content Area (Handling empty/filtered empty/list views)
                    if (allTransactions.isEmpty)
                      const _EmptyState(
                        title: 'No Transaction found to show',
                      )
                    else if (filteredTransactions.isEmpty)
                      _EmptyState(
                        title: 'No matching transactions',
                        message: 'No ${controller.selectedTxnFilter.value.toLowerCase()} transactions found.',
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTransactions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                        itemBuilder: (context, index) {
                          return _TransactionTableRow(
                            transaction: filteredTransactions[index],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// Custom Filter Button Dropdown matching the UI
class _FilterDropdownButton extends StatelessWidget {
  final DashboardController controller;

  const _FilterDropdownButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        controller.setTxnFilter(value);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (BuildContext context) {
        return controller.txnFilters.map<PopupMenuEntry<String>>((String filter) {
          final bool isSelected = controller.selectedTxnFilter.value == filter;
          return PopupMenuItem<String>(
            value: filter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filter,
                  style: TextStyle(
                    fontFamily: FontFamily.medium,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Ucolors.primary : Colors.black87,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, size: 16, color: Ucolors.primary),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            const Text(
              'Filter',
              style: TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            // Blue Notification Count Bubble seen on image
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '1',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Updated Table Header mapping exactly to image
class _TransactionTableHeader extends StatelessWidget {
  const _TransactionTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: const Color(0xFFF9FAFB),
      child: Row(
        children: const [
          Expanded(flex: 4, child: _HeaderText('FUND')),
          Expanded(flex: 2, child: _HeaderText('INV. SINCE')),
          Expanded(flex: 2, child: _HeaderText('BALANCE UNITS')),
          Expanded(flex: 3, child: _HeaderText('MFU ORDER')),
          Expanded(flex: 2, child: _HeaderText('INV. COST')),
          Expanded(flex: 2, child: _HeaderText('STATUS')),
          Expanded(flex: 2, child: _HeaderText('ACTION', alignRight: true)),
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
      style: const TextStyle(
        fontFamily: FontFamily.medium,
        color: Color(0xFF6B7280),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

// Table rows corresponding to customized items
// Table rows corresponding to customized items
class _TransactionTableRow extends StatelessWidget {
  final dynamic transaction;

  const _TransactionTableRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // 1. FUND (flex: 4)
          Expanded(
            flex: 4,
            child: Text(
              // transaction.fundName ?? 'N/A',
              "transaction.fundName" ?? 'N/A',
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // 2. INV. SINCE (flex: 2)
          Expanded(
            flex: 2,
            child: Text(
              transaction.invSince ?? '-', // Map to Investment Date/Since
              style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600),
            ),
          ),
          // 3. BALANCE UNITS (flex: 2)
          Expanded(
            flex: 2, // Fixed: Changed from 3 to 2 to match header
            child: Text(
              transaction.balanceUnits?.toString() ?? '-',
              style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600),
            ),
          ),
          // 4. MFU ORDER (flex: 3)
          Expanded(
            flex: 3, // Fixed: Changed from 2 to 3 to match header
            child: Text(
              transaction.mfOrderId ?? '-',
              style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600),
            ),
          ),
          // 5. INV. COST (flex: 2)
          Expanded(
            flex: 2, // Fixed: Changed from 3 to 2 to match header
            child: Text(
              transaction.amount?.toString() ?? '-',
              style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600),
            ),
          ),
          // 6. STATUS (flex: 2)
          Expanded(
            flex: 2,
            child: Text(
              transaction.status ?? '-',
              style: const TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600),
            ),
          ),
          // 7. ACTION (flex: 2)
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'View',
                  style: TextStyle(fontFamily: FontFamily.medium, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Accurate illustration mapping image's no-transaction graphic layout
class _EmptyState extends StatelessWidget {
  final String title;
  final String? message;

  const _EmptyState({required this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(Iconsax.document_text5, size: 54, color: Colors.teal.shade300),
                Positioned(
                  right: 32,
                  bottom: 32,
                  child: Icon(Icons.search, size: 20, color: Colors.red.shade400),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontFamily: FontFamily.medium,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}