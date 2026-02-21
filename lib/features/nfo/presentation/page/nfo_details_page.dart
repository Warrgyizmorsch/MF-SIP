// import 'package:flutter/material.dart';
// import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';

// class NfoDetailsPage extends StatelessWidget {
//   const NfoDetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: CustomAppBarNormal(title: 'NFO Details Page'));
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';

// class NfoDetailsPage extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String riskText;
//   final String navText;
//   final String closingText;
//   final String launchDate;
//   final String endDate;

//   const NfoDetailsPage({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.riskText,
//     required this.navText,
//     required this.closingText,
//     required this.launchDate,
//     required this.endDate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;

//     // Theme Colors based on your Tailwind config
//     final Color cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
//     final Color textColor = isDark ? Colors.white : const Color(0xFF111827);
//     final Color mutedColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
//     final Color borderColor = isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6);

//     return Container(
//       clipBehavior: Clip.antiAlias, // Ensures the blur doesn't bleed out
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
//                 color: isDark
//                     ? Colors.blue.shade400.withOpacity(0.1)
//                     : Colors.blue.shade500.withOpacity(0.1),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//           ),

//           // Main Card Content
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- Top Row: Icon and Title ---
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: isDark ? const Color(0xFF1F2937) : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: borderColor),
//                       ),
//                       child: const Icon(
//                         Icons.change_history_rounded,
//                         color: Colors.pink,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             title,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: textColor,
//                               height: 1.2,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             subtitle,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: mutedColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 24),

//                 // --- Tags Row ---
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     _buildTag(
//                       icon: Icons.warning_rounded,
//                       text: riskText,
//                       textColor: isDark ? Colors.orange.shade300 : Colors.orange.shade700,
//                       bgColor: isDark ? Colors.orange.shade900.withOpacity(0.2) : Colors.orange.shade50,
//                     ),
//                     _buildTag(
//                       icon: Icons.currency_rupee_rounded,
//                       text: navText,
//                       textColor: isDark ? Colors.blue.shade300 : const Color(0xFF1E40AF), // Primary blue
//                       bgColor: isDark ? Colors.blue.shade900.withOpacity(0.2) : Colors.blue.shade50,
//                     ),
//                     _buildTag(
//                       icon: Icons.timer_rounded,
//                       text: closingText,
//                       textColor: isDark ? Colors.red.shade300 : Colors.red.shade700,
//                       bgColor: isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50,
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // --- Dates Divider & Section ---
//                 Container(
//                   padding: const EdgeInsets.only(top: 16),
//                   decoration: BoxDecoration(
//                     border: Border(top: BorderSide(color: borderColor)),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Launch Date',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: mutedColor,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             launchDate,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: textColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'End Date',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: mutedColor,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             endDate,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: textColor,
//                             ),
//                           ),
//                         ],
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

//   // Helper widget to generate the info pills (tags)
//   Widget _buildTag({
//     required IconData icon,
//     required String text,
//     required Color textColor,
//     required Color bgColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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




import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  taxImplications: 'Returns are taxed at 15% if redeemed before 1 year. After 1 year, LTCG tax of 10% applies on returns of ₹1 Lac+ in a financial year.',
);


// Make sure to import your entity file here
// import 'package:my_sip/features/nfo/data/model/nfo_model.dart'; 

class NfoDetailsPage extends StatelessWidget {
  const NfoDetailsPage({super.key,});

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
                amount: '₹${nfo.minLumpsum ?? nfo.minSubscriptionAmount ?? "-"}',
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
            style: const TextStyle(
              fontSize: 11,
              color: textMuted,
            ),
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
            description: nfo.expenseRatio != null ? '${nfo.expenseRatio}%' : '-',
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icon: Icons.account_balance_rounded,
            iconColor: Colors.green.shade600,
            iconBg: Colors.green.shade50,
            title: 'Tax Implications',
            description: 'Returns are taxed at 15% if redeemed before 1 year. After 1 year, LTCG tax of 10% applies on returns of ₹1 Lac+ in a financial year.',
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
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
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

  const NfoDetailScreen({
    Key? key,
    required this.nfoData,
  }) : super(key: key);

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
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
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
            style: const TextStyle(
              fontSize: 11,
              color: textMuted,
            ),
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
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
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