import 'package:flutter/material.dart';

class SipSetupScreenStatic extends StatelessWidget {
  const SipSetupScreenStatic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214), // Dark themed background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text(
          'SIP Setup', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFundDetailsCard(),
            const SizedBox(height: 24),
            _buildAmountSelector(),
            const SizedBox(height: 24),
            _buildDateSelector(),
            const SizedBox(height: 24),
            _buildPaymentMethods(),
            const SizedBox(height: 24),
            _buildSummaryCard(),
            const SizedBox(height: 32),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  // 1. Fund Details Section
  Widget _buildFundDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Nova Growth Equity Fund',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text('4.8', style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Direct · Growth · Large Cap',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Moderate Risk', style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white10, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('1Y Return', '+18.4%', Colors.greenAccent),
              _buildMetric('NAV', '₹184.27', Colors.white),
              _buildMetric('AUM', '₹12.4k Cr', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // 2. Investment Amount Selector
  Widget _buildAmountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Monthly Investment Amount', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('₹', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('2,500', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickAddChip('+ ₹500'),
            _buildQuickAddChip('+ ₹1,000'),
            _buildQuickAddChip('+ ₹2,500'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAddChip(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Center(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }

  // 3. Auto-Debit Date Selector
  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Auto-Debit Date', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_today, color: Colors.blueAccent, size: 20),
                  SizedBox(width: 12),
                  Text(
                    '16 May',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  // 4. Payment Methods Selection
  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildMethodTab('UPI', isSelected: true),
            const SizedBox(width: 8),
            _buildMethodTab('Cards', isSelected: false),
            const SizedBox(width: 8),
            _buildMethodTab('Net Banking', isSelected: false),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodTab(String label, {required bool isSelected}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.15) : const Color(0xFF1A1A1E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blueAccent : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // 5. Payment Breakdown Summary
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Estimated Units', '13.57'),
          const SizedBox(height: 10),
          _buildSummaryRow('Investment Amount', '₹2,500.00'),
          const SizedBox(height: 10),
          _buildSummaryRow('Processing Fees', '₹6.25'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white10, height: 1),
          ),
          _buildSummaryRow('Total Payable', '₹2,506.25', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.grey, fontSize: isTotal ? 15 : 13, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: isTotal ? Colors.blueAccent : Colors.white, fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  // 6. Action Button
  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        onPressed: () {},
        child: const Text(
          'Confirm & Pay ₹2,506.25',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}