import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/features/fund_details/presentation/widgets/helper.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';

class NfoDetailModel {
  final String fundName;
  final String planType;
  final String riskLevel;
  final String navPrice;
  final String closingStatus;
  final String launchDate;
  final String endDate;
  final String sipMinimum;
  final String lumpsumMinimum;
  final String additionalInvestment;
  final String exitLoad;
  final String expenseRatio;
  final String taxImplications;

  NfoDetailModel({
    required this.fundName,
    required this.planType,
    required this.riskLevel,
    required this.navPrice,
    required this.closingStatus,
    required this.launchDate,
    required this.endDate,
    required this.sipMinimum,
    required this.lumpsumMinimum,
    required this.additionalInvestment,
    required this.exitLoad,
    required this.expenseRatio,
    required this.taxImplications,
  });
}

final myApiData = NfoDetailModel(
  fundName: 'Axis Fixed Maturity Plan Series 129',
  planType: '(108 Days) Regular Plan Growth',
  riskLevel: 'Average Risk',
  navPrice: 'NAV: ₹10',
  closingStatus: 'Closes in 1 Day',
  launchDate: '18 Feb 2026',
  endDate: '23 Feb 2026',
  sipMinimum: '₹5,000',
  lumpsumMinimum: '₹5,000',
  additionalInvestment: '₹5,000',
  exitLoad: 'Nil',
  expenseRatio: '-',
  taxImplications:
      'Returns are taxed at 15% if redeemed before 1 year. After 1 year, LTCG tax of 10% applies on returns of ₹1 Lac+ in a financial year.',
);

class NfoDetailsPage1 extends StatelessWidget {
  const NfoDetailsPage1({Key? key}) : super(key: key);

  // Theme Colors
  static const Color primaryColor = Color(0xFF1E40AF);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFF3F4F6);

  List<String> _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == '--') {
      return ['--', ''];
    }
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(dateStr);
    } catch (e) {
      try {
        final parts = dateStr.split(RegExp(r'[-/]'));
        if (parts.length == 3) {
          parsedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }
    if (parsedDate != null) {
      return [
        DateFormat('dd MMM').format(parsedDate),
        DateFormat('yyyy').format(parsedDate),
      ];
    }
    return [dateStr, ''];
  }

  @override
  Widget build(BuildContext context) {
    final LaunchDataEntity nfoData =
        Get.arguments as LaunchDataEntity? ?? const LaunchDataEntity();

    // 🚀 Check for Web/Desktop
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : backgroundColor,

      // 🚀 THE FIX: Web par local AppBar hide karo
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: textDark),
              title: const Text(
                'NFO Detail',
                style: TextStyle(
                  color: textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: borderColor, height: 1),
              ),
            ),

      body: isDesktop
          ? _buildWebLayout(nfoData, context)
          : _buildMobileLayout(nfoData),

      // 🚀 Bottom Nav mobile ke liye, Web mein card ke andar hoga
      bottomNavigationBar: isDesktop
          ? null
          : _buildBottomBar(context, isWeb: false),
    );
  }

  // =========================================
  // 💻 WEB / DESKTOP LAYOUT (2-Column)
  // =========================================
  Widget _buildWebLayout(LaunchDataEntity nfoData, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100), // Max width for Web
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Web Header ---
                Text(
                  "NFO Details",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Review all information before investing in this New Fund Offering.",
                  style: TextStyle(color: textMuted, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // --- 2 Column Split ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _buildMainDetailsCard(nfoData),
                          const SizedBox(height: 24),
                          _buildAmcCard(nfoData),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Right Column
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          _buildMinimumInvestmentSection(nfoData),
                          const SizedBox(height: 24),
                          _buildFundDetailsSection(nfoData),
                          const SizedBox(height: 24),
                          _buildExitLoadAndTaxSection(nfoData),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                const Divider(color: borderColor),
                const SizedBox(height: 24),

                // --- Action Buttons (Web) ---
                _buildBottomBar(context, isWeb: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================
  // 📱 MOBILE LAYOUT
  // =========================================
  Widget _buildMobileLayout(LaunchDataEntity nfoData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainDetailsCard(nfoData),
          const SizedBox(height: 24),
          _buildMinimumInvestmentSection(nfoData),
          const SizedBox(height: 24),
          _buildFundDetailsSection(nfoData),
          const SizedBox(height: 24),
          _buildExitLoadAndTaxSection(nfoData),
          const SizedBox(height: 32),
          _buildAmcCard(nfoData),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // =========================================
  // 🧩 REUSABLE WIDGETS
  // =========================================

  Widget _buildAmcCard(LaunchDataEntity nfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AMC Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: CustomCachedImage(
                  imageUrl: '${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nfo.nfoAmcEntity?.amcName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'FUND HOUSE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF9FAFB))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONTACT DETAILS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        nfo.nfoAmcEntity?.address ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.mail_outline_rounded,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        nfo.nfoAmcEntity?.email ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.call_outlined,
                      size: 20,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      nfo.nfoAmcEntity?.contactNo ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainDetailsCard(LaunchDataEntity nfo) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -64,
            right: -64,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade500.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: CustomCachedImage(
                        imageUrl:
                            '${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nfo.schemeName ?? '--',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${nfo.schemeCategory ?? '--'} • ${nfo.assetClass ?? '--'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag(
                      icon: Icons.shield_rounded,
                      text: '${nfo.riskLevel ?? '--'}',
                      textColor: getRiskMeter(nfo.riskLevel).color,
                      bgColor: Colors.green.shade50,
                    ),
                    _buildTag(
                      icon: Icons.currency_rupee_rounded,
                      text: 'NAV: ₹${nfo.nav ?? nfo.nfoPrice ?? ""}',
                      textColor: primaryColor,
                      bgColor: Colors.blue.shade50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDateItem(
                          'OPEN',
                          nfo.nfoOpenDate ?? '--',
                          CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        child: _buildDateItem(
                          'CLOSE',
                          nfo.nfoCloseDate ?? '--',
                          CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        child: _buildDateItem(
                          'ALLOTMENT',
                          nfo.allotmentDate ?? '--',
                          CrossAxisAlignment.start,
                        ),
                      ),
                      Expanded(
                        child: _buildDateItem(
                          'LAUNCH',
                          nfo.launchDate ?? '--',
                          CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(
    String label,
    String? rawDateStr,
    CrossAxisAlignment alignment,
  ) {
    final parsedData = _parseDate(rawDateStr);
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: textMuted,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          parsedData[0],
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
        if (parsedData[1].isNotEmpty)
          Text(
            parsedData[1],
            style: const TextStyle(fontSize: 10, color: textMuted),
          ),
      ],
    );
  }

  Widget _buildMinimumInvestmentSection(LaunchDataEntity nfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Minimum Investment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInvestmentTypeCard(
                icon: Icons.repeat_rounded,
                type: 'SIP',
                amount: '₹${nfo.minSipAmount ?? "500"}',
                subtitle: 'Min. installment',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInvestmentTypeCard(
                icon: Icons.payments_outlined,
                type: 'LUMPSUM',
                amount:
                    '₹${nfo.minLumpsum ?? nfo.minSubscriptionAmount ?? "5,000"}',
                subtitle: '1st Investment',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvestmentTypeCard({
    required IconData icon,
    required String type,
    required String amount,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: textMuted),
              const SizedBox(width: 6),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildFundDetailsSection(LaunchDataEntity nfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fund Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildFundDetailRow('Fund Manager', nfo.fundManager ?? '--'),
          _buildFundDetailRow('Benchmark', nfo.benchmark ?? '--'),
          _buildFundDetailRow(
            'Expense Ratio',
            nfo.expenseRatio != null ? '${nfo.expenseRatio}%' : '--',
          ),
          _buildFundDetailRow(
            'Scheme Type',
            nfo.schemeType ?? '--',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFundDetailRow(
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: textMuted)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExitLoadAndTaxSection(LaunchDataEntity nfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exit Load & Tax Implications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.logout_rounded,
            iconColor: primaryColor,
            iconBg: Colors.blue.shade50,
            title: 'Exit Load',
            description: nfo.exitLoad ?? 'Nil',
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.account_balance_rounded,
            iconColor: Colors.green.shade600,
            iconBg: Colors.green.shade50,
            title: 'Tax Implications',
            description:
                'As a Debt scheme, gains are taxed at your applicable income tax slab rate, regardless of the holding period.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 5. Bottom Action Bar (Responsive) ---
  Widget _buildBottomBar(BuildContext context, {required bool isWeb}) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: isWeb ? 16 : 32,
      ),
      decoration: BoxDecoration(
        color: isWeb ? Colors.transparent : Colors.white,
        border: isWeb
            ? null
            : const Border(top: BorderSide(color: borderColor)),
        boxShadow: isWeb
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: isWeb
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceBetween,
        children: [
          if (isWeb) ...[
            SizedBox(
              width: 140,
              child: OutlinedButton(
                onPressed: () => Navigator.maybePop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: primaryColor, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          if (!isWeb) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(color: primaryColor, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: isWeb ? 180 : null,
            child: Expanded(
              flex: isWeb ? 0 : 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Invest Now',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// class NfoDetailsPage1 extends StatelessWidget {
//   const NfoDetailsPage1({Key? key}) : super(key: key);

//   // Theme Colors from Tailwind config
//   static const Color primaryColor = Color(0xFF1E40AF);
//   static const Color backgroundColor = Color(0xFFF9FAFB);
//   static const Color cardColor = Colors.white;
//   static const Color textDark = Color(0xFF1F2937);
//   static const Color textMuted = Color(0xFF6B7280);
//   static const Color borderColor = Color(0xFFF3F4F6);

//   List<String> _parseDate(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty || dateStr == '--') {
//       return ['--', ''];
//     }

//     DateTime? parsedDate;

//     // Attempt standard parsing (e.g., "2026-02-28")
//     try {
//       parsedDate = DateTime.parse(dateStr);
//     } catch (e) {
//       // Fallback for formats like DD-MM-YYYY or DD/MM/YYYY
//       try {
//         final parts = dateStr.split(RegExp(r'[-/]'));
//         if (parts.length == 3) {
//           parsedDate = DateTime(
//             int.parse(parts[2]),
//             int.parse(parts[1]),
//             int.parse(parts[0]),
//           );
//         }
//       } catch (_) {}
//     }

//     if (parsedDate != null) {
//       // Returns [ "28 Feb", "2026" ]
//       return [
//         DateFormat('dd MMM').format(parsedDate),
//         DateFormat('yyyy').format(parsedDate),
//       ];
//     }

//     // Ultimate fallback if parsing fails completely
//     return [dateStr, ''];
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve the entity passed via GetX navigation
//     // Fallback to a dummy entity for UI testing if arguments are null
//     final LaunchDataEntity nfoData =
//         Get.arguments as LaunchDataEntity? ?? const LaunchDataEntity();

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white.withOpacity(0.9),
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: textDark),
//         title: const Text(
//           'NFO Detail',
//           style: TextStyle(
//             color: textDark,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.share_outlined),
//         //     onPressed: () {},
//         //   ),
//         // ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(color: borderColor, height: 1),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildMainDetailsCard(nfoData),
//             const SizedBox(height: 24),
//             _buildMinimumInvestmentSection(nfoData),
//             const SizedBox(height: 24),
//             _buildFundDetailsSection(nfoData),
//             const SizedBox(height: 24),

//             _buildExitLoadAndTaxSection(nfoData),
//             const SizedBox(height: 32),
//             _buildAmcCard(nfoData),
//             const SizedBox(height: 24), //
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   // --- Asset Management Company Card ---
//   Widget _buildAmcCard(LaunchDataEntity nfo) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: const Color(0xFFF3F4F6)), // borderColor
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           const Text(
//             'AMC Details',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937), // textDark
//             ),
//           ),
//           const SizedBox(height: 24),

//           // AMC Logo and Name Row
//           Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,

//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF9FAFB),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFF3F4F6)),
//                 ),
//                 child: CustomCachedImage(
//                   imageUrl: '${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}',
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       nfo.nfoAmcEntity?.amcName ?? '',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937), // textDark
//                         height: 1.2,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       'FUND HOUSE',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF6B7280), // textMuted
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),

//           // Contact Details Section
//           Container(
//             padding: const EdgeInsets.only(top: 16),
//             decoration: const BoxDecoration(
//               border: Border(top: BorderSide(color: Color(0xFFF9FAFB))),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'CONTACT DETAILS',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF6B7280), // textMuted
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // Location Row
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.location_on_outlined,
//                       size: 20,
//                       color: Color(0xFF9CA3AF), // gray-400
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         nfo.nfoAmcEntity?.address ?? '',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF1F2937), // textDark
//                           height: 1.5,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Email Row
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.mail_outline_rounded,
//                       size: 20,
//                       color: Color(0xFF9CA3AF),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         nfo.nfoAmcEntity?.email ?? '',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1E40AF), // primaryColor
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Phone Row
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.call_outlined,
//                       size: 20,
//                       color: Color(0xFF9CA3AF),
//                     ),
//                     SizedBox(width: 12),
//                     Text(
//                       nfo.nfoAmcEntity?.contactNo ?? '',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1F2937), // textDark
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- 1. Main Details Card ---
//   Widget _buildMainDetailsCard(LaunchDataEntity nfo) {
//     return Container(
//       clipBehavior: Clip.antiAlias,
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Background Blur Effect (Top Right)
//           Positioned(
//             top: -64,
//             right: -64,
//             child: Container(
//               width: 192,
//               height: 192,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.blue.shade500.withOpacity(0.1),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Row
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: borderColor),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.02),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: CustomCachedImage(
//                         imageUrl:
//                             '${Appurl.baseUrl}${nfo.nfoAmcEntity?.amcLogo}',
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             nfo.schemeName ?? '--',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: textDark,
//                               height: 1.2,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${nfo.schemeCategory ?? '--'} • ${nfo.assetClass ?? '--'}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: textMuted,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Tags
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _buildTag(
//                       icon: Icons.shield_rounded,
//                       text: '${nfo.riskLevel ?? '--'}',
//                       textColor: getRiskMeter(nfo.riskLevel).color,
//                       bgColor: Colors.green.shade50,
//                       // bgColor: getRiskMeter(nfo.riskLevel).color,
//                     ),
//                     _buildTag(
//                       icon: Icons.currency_rupee_rounded,
//                       text: 'NAV: ₹${nfo.nav ?? nfo.nfoPrice ?? ""}',
//                       textColor: primaryColor,
//                       bgColor: Colors.blue.shade50,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // 4-Column Dates Grid
//                 Container(
//                   padding: const EdgeInsets.only(top: 16),
//                   decoration: const BoxDecoration(
//                     border: Border(top: BorderSide(color: borderColor)),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: _buildDateItem(
//                           'OPEN',
//                           nfo.nfoOpenDate ?? '--',
//                           CrossAxisAlignment.center,
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildDateItem(
//                           'CLOSE',
//                           nfo.nfoCloseDate ?? '--',
//                           CrossAxisAlignment.center,
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildDateItem(
//                           'ALLOTMENT',
//                           nfo.allotmentDate ?? '--',
//                           CrossAxisAlignment.center,
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildDateItem(
//                           'LAUNCH',
//                           nfo.launchDate ?? '--',
//                           CrossAxisAlignment.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateItem(
//     String label,
//     String? rawDateStr,
//     CrossAxisAlignment alignment,
//   ) {
//     final parsedData = _parseDate(rawDateStr);
//     final String dayMonth = parsedData[0]; // e.g., "28 Feb"
//     final String year = parsedData[1]; // e.g., "2026"

//     return Column(
//       crossAxisAlignment: alignment,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 10,
//             color: textMuted,
//             letterSpacing: 0.5,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           dayMonth,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: textDark,
//           ),
//           textAlign: alignment == CrossAxisAlignment.end
//               ? TextAlign.right
//               : TextAlign.left,
//         ),
//         if (year.isNotEmpty)
//           Text(
//             year,
//             style: const TextStyle(fontSize: 10, color: textMuted),
//             textAlign: alignment == CrossAxisAlignment.end
//                 ? TextAlign.right
//                 : TextAlign.left,
//           ),
//       ],
//     );
//   }

//   // Widget _buildDateItem(
//   //   String label,
//   //   String dateText,
//   //   CrossAxisAlignment alignment,
//   // ) {
//   //   return Column(
//   //     crossAxisAlignment: alignment,
//   //     children: [
//   //       Text(
//   //         label,
//   //         style: const TextStyle(
//   //           fontSize: 10,
//   //           color: textMuted,
//   //           letterSpacing: 0.5,
//   //           fontWeight: FontWeight.w600,
//   //         ),
//   //       ),
//   //       const SizedBox(height: 4),
//   //       Text(
//   //         dateText,
//   //         style: const TextStyle(
//   //           fontSize: 12,
//   //           fontWeight: FontWeight.w600,
//   //           color: textDark,
//   //         ),
//   //         textAlign: alignment == CrossAxisAlignment.end
//   //             ? TextAlign.right
//   //             : TextAlign.left,
//   //       ),
//   //     ],
//   //   );
//   // }

//   // --- 2. Minimum Investment Section ---
//   Widget _buildMinimumInvestmentSection(LaunchDataEntity nfo) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 4,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: primaryColor,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               'Minimum Investment',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: textDark,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildInvestmentTypeCard(
//                 icon: Icons.repeat_rounded,
//                 type: 'SIP',
//                 amount: '₹${nfo.minSipAmount ?? "500"}',
//                 subtitle: 'Min. installment',
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: _buildInvestmentTypeCard(
//                 icon: Icons.payments_outlined,
//                 type: 'LUMPSUM',
//                 amount:
//                     '₹${nfo.minLumpsum ?? nfo.minSubscriptionAmount ?? "5,000"}',
//                 subtitle: '1st Investment',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildInvestmentTypeCard({
//     required IconData icon,
//     required String type,
//     required String amount,
//     required String subtitle,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 18, color: textMuted),
//               const SizedBox(width: 6),
//               Text(
//                 type,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: textMuted,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             amount,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             subtitle,
//             style: const TextStyle(fontSize: 11, color: textMuted),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- 3. Fund Details Section ---
//   Widget _buildFundDetailsSection(LaunchDataEntity nfo) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Fund Details',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildFundDetailRow('Fund Manager', nfo.fundManager ?? '--'),
//           _buildFundDetailRow('Benchmark', nfo.benchmark ?? '--'),
//           _buildFundDetailRow(
//             'Expense Ratio',
//             nfo.expenseRatio != null ? '${nfo.expenseRatio}%' : '--',
//           ),
//           _buildFundDetailRow(
//             'Scheme Type',
//             nfo.schemeType ?? '--',
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFundDetailRow(
//     String label,
//     String value, {
//     bool isLast = false,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : const Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 14, color: textMuted)),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: textDark,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- 4. Exit Load & Tax Implications ---
//   Widget _buildExitLoadAndTaxSection(LaunchDataEntity nfo) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         // color: Color(0xFFF9FAFB),
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: borderColor),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Exit Load & Tax Implications',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: textDark,
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildInfoRow(
//             icon: Icons.logout_rounded,
//             iconColor: primaryColor,
//             iconBg: Colors.blue.shade50,
//             title: 'Exit Load',
//             description: nfo.exitLoad ?? 'Nil',
//           ),
//           const SizedBox(height: 20),
//           _buildInfoRow(
//             icon: Icons.account_balance_rounded,
//             iconColor: Colors.green.shade600,
//             iconBg: Colors.green.shade50,
//             title: 'Tax Implications',
//             description:
//                 'As a Debt scheme, gains are taxed at your applicable income tax slab rate, regardless of the holding period.',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow({
//     required IconData icon,
//     required Color iconColor,
//     required Color iconBg,
//     required String title,
//     required String description,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
//           child: Icon(icon, size: 18, color: iconColor),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: textDark,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: textMuted,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // --- 5. Bottom Action Bar ---
//   Widget _buildBottomBar() {
//     return Container(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: const Border(top: BorderSide(color: borderColor)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: primaryColor,
//                 side: const BorderSide(color: primaryColor, width: 1.5),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Buy SIP',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryColor,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 elevation: 4,
//                 shadowColor: primaryColor.withOpacity(0.4),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Buy Lumpsum',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTag({
//     required IconData icon,
//     required String text,
//     required Color textColor,
//     required Color bgColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: textColor),
//           const SizedBox(width: 4),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Make sure to import your entity file here
// import 'package:my_sip/features/nfo/data/model/nfo_model.dart';

class NfoDetailsPage extends StatelessWidget {
  const NfoDetailsPage({super.key});

  // Theme Colors
  static const Color primaryColor = Color(0xFF1E40AF);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    // Retrieve the entity passed from the list page
    final LaunchDataEntity nfoData = Get.arguments as LaunchDataEntity;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        title: const Text(
          'NFO Detail',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainDetailsCard(nfoData),
            const SizedBox(height: 24),
            _buildMinimumInvestmentSection(nfoData),
            const SizedBox(height: 24),
            _buildExitLoadAndTaxSection(nfoData),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- 1. Main Details Card ---
  Widget _buildMainDetailsCard(LaunchDataEntity nfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: const Icon(
                  Icons.change_history_rounded,
                  color: Colors.pinkAccent,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nfo.schemeName ?? 'Unknown Fund',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nfo.planType ?? nfo.schemeCategory ?? 'Regular Plan',
                      style: const TextStyle(
                        fontSize: 14,
                        color: textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(
                icon: Icons.warning_rounded,
                text: nfo.riskLevel ?? 'Average Risk',
                textColor: Colors.orange.shade700,
                bgColor: Colors.orange.shade50,
              ),
              _buildTag(
                icon: Icons.currency_rupee_rounded,
                text: 'NAV: ₹${nfo.nav ?? nfo.nfoPrice ?? "10"}',
                textColor: primaryColor,
                bgColor: Colors.blue.shade50,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Launch Date',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nfo.nfoOpenDate ?? '--',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'End Date',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nfo.nfoCloseDate ?? '--',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Minimum Investment Section ---
  Widget _buildMinimumInvestmentSection(LaunchDataEntity nfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Minimum Investment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInvestmentTypeCard(
                icon: Icons.repeat_rounded,
                type: 'SIP',
                amount: '₹${nfo.minSipAmount ?? "-"}',
                subtitle: 'Min. installment',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInvestmentTypeCard(
                icon: Icons.payments_outlined,
                type: 'LUMPSUM',
                amount:
                    '₹${nfo.minLumpsum ?? nfo.minSubscriptionAmount ?? "-"}',
                subtitle: '1st Investment',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Additional Investment',
                style: TextStyle(fontSize: 14, color: textMuted),
              ),
              Text(
                '₹${nfo.minimumTopup ?? "-"}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentTypeCard({
    required IconData icon,
    required String type,
    required String amount,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: textMuted),
              const SizedBox(width: 6),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }

  // --- 3. Exit Load & Tax Implications ---
  Widget _buildExitLoadAndTaxSection(LaunchDataEntity nfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exit Load & Tax Implications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.logout_rounded,
            iconColor: primaryColor,
            iconBg: Colors.blue.shade50,
            title: 'Exit Load',
            description: nfo.exitLoad ?? 'Nil',
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.percent_rounded,
            iconColor: Colors.purple.shade600,
            iconBg: Colors.purple.shade50,
            title: 'Expense Ratio',
            description: nfo.expenseRatio != null
                ? '${nfo.expenseRatio}%'
                : '-',
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.account_balance_rounded,
            iconColor: Colors.green.shade600,
            iconBg: Colors.green.shade50,
            title: 'Tax Implications',
            description:
                'Returns are taxed at 15% if redeemed before 1 year. After 1 year, LTCG tax of 10% applies on returns of ₹1 Lac+ in a financial year.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. Bottom Action Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy SIP',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy Lumpsum',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class NfoDetailScreen extends StatelessWidget {
  final NfoDetailModel nfoData;

  const NfoDetailScreen({Key? key, required this.nfoData}) : super(key: key);

  // Theme Colors
  static const Color primaryColor = Color(0xFF1E40AF);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    final LaunchDataEntity nfoData = Get.arguments as LaunchDataEntity;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        title: const Text(
          'NFO Detail',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainDetailsCard(),
            const SizedBox(height: 24),
            _buildMinimumInvestmentSection(),
            const SizedBox(height: 24),
            _buildExitLoadAndTaxSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- 1. Main Details Card ---
  Widget _buildMainDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.change_history_rounded,
                  color: Colors.pinkAccent,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nfoData.fundName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nfoData.planType,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(
                icon: Icons.warning_rounded,
                text: nfoData.riskLevel,
                textColor: Colors.orange.shade700,
                bgColor: Colors.orange.shade50,
              ),
              _buildTag(
                icon: Icons.currency_rupee_rounded,
                text: nfoData.navPrice,
                textColor: primaryColor,
                bgColor: Colors.blue.shade50,
              ),
              _buildTag(
                icon: Icons.timer_rounded,
                text: nfoData.closingStatus,
                textColor: Colors.red.shade700,
                bgColor: Colors.red.shade50,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Launch Date',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nfoData.launchDate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'End Date',
                      style: TextStyle(fontSize: 12, color: textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nfoData.endDate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Minimum Investment Section ---
  Widget _buildMinimumInvestmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Minimum Investment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInvestmentTypeCard(
                icon: Icons.repeat_rounded,
                type: 'SIP',
                amount: nfoData.sipMinimum,
                subtitle: 'Min. installment',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInvestmentTypeCard(
                icon: Icons.payments_outlined,
                type: 'LUMPSUM',
                amount: nfoData.lumpsumMinimum,
                subtitle: '1st Investment',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Additional Investment',
                style: TextStyle(fontSize: 14, color: textMuted),
              ),
              Text(
                nfoData.additionalInvestment,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentTypeCard({
    required IconData icon,
    required String type,
    required String amount,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: textMuted),
              const SizedBox(width: 6),
              Text(
                type,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }

  // --- 3. Exit Load & Tax Implications ---
  Widget _buildExitLoadAndTaxSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exit Load & Tax Implications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.logout_rounded,
            iconColor: primaryColor,
            iconBg: Colors.blue.shade50,
            title: 'Exit Load',
            description: nfoData.exitLoad,
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.percent_rounded,
            iconColor: Colors.purple.shade600,
            iconBg: Colors.purple.shade50,
            title: 'Expense Ratio',
            description: nfoData.expenseRatio,
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.account_balance_rounded,
            iconColor: Colors.green.shade600,
            iconBg: Colors.green.shade50,
            title: 'Tax Implications',
            description: nfoData.taxImplications,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 4. Bottom Action Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy SIP',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buy Lumpsum',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
