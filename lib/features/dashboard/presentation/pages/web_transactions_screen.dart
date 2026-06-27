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

  // Defined Column Widths uniformly for consistency across Header and Rows
  final Map<int, TableColumnWidth> _columnWidths = const {
    0: FlexColumnWidth(6), // FUND
    1: FlexColumnWidth(2), // INV. SINCE
    2: FlexColumnWidth(2), // INV. TYPE
    3: FlexColumnWidth(4), // MFU ORDER
    4: FlexColumnWidth(3), // INV. COST
    5: FlexColumnWidth(2), // STATUS
    6: FlexColumnWidth(2), // ACTION
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Ucolors.white,
      body: Obx(() {
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

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Main Title (Static, no scrolling)
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

              // Main Active Transactions Card Container (Takes up remaining height)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Bar with Title and Filter Button (Static)
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

                      // Table Headers (Static and Fixed at the top)
                      _TransactionTableHeader(columnWidths: _columnWidths),

                      // CONTENT AREA: Only data scrolls inside this Expanded block
                      Expanded(
                        child: allTransactions.isEmpty
                            ? const _EmptyState(title: 'No Transaction found to show')
                            : filteredTransactions.isEmpty
                            ? _EmptyState(
                          title: 'No matching transactions',
                          message: 'No ${controller.selectedTxnFilter.value.toLowerCase()} transactions found.',
                        )
                            : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredTransactions.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          itemBuilder: (context, index) {
                            return _TransactionTableRow(
                              transaction: filteredTransactions[index],
                              columnWidths: _columnWidths,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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

// Fixed Layout Table Header using the Table widget
class _TransactionTableHeader extends StatelessWidget {
  final Map<int, TableColumnWidth> columnWidths;
  const _TransactionTableHeader({required this.columnWidths});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: const Color(0xFFF9FAFB),
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: const [
          TableRow(
            children: [
              _HeaderText('FUND'),
              _HeaderText('INV. SINCE'),
              _HeaderText('INV. TYPE'),
              _HeaderText('MFU ORDER'),
              _HeaderText('INV. COST'),
              _HeaderText('STATUS'),
              _HeaderText('ACTION', ),
            ],
          ),
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

// Table row using Table widget mapping columns exactly to headers
class _TransactionTableRow extends StatelessWidget {
  final dynamic transaction;
  final Map<int, TableColumnWidth> columnWidths;

  const _TransactionTableRow({
    required this.transaction,
    required this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              // 1. FUND
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  transaction.fundName ?? '',
                  style: const TextStyle(
                    fontFamily: FontFamily.medium,
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // 2. INV. SINCE
              Text(
                transaction.invSince ?? '',
                style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              // 3. INV. TYPE
              Text(
                transaction.investmentType?.toString() ?? '',
                style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              // 4. MFU ORDER
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  transaction.mfOrderId ?? '',
                  style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              // 5. INV. COST
              Text(
                transaction.amount?.toString() ?? '0',
                style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              // 6. STATUS
              Text(
                transaction.status ?? '',
                style: TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: (transaction.status?.toString().toLowerCase() == 'failed')
                      ? Colors.red
                      : Colors.black87,
                ),
              ),
              // 7. ACTION
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6366F1), // Clean designer look for link
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

class _EmptyState extends StatelessWidget {
  final String title;
  final String? message;
  const _EmptyState({required this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
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
    );
  }
}