import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';

class NomineeListScreen extends GetView<PersonalisationController> {
  const NomineeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 Dynamic Web Layout Check
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNominee();
    });

    return Scaffold(
      backgroundColor: Colors.white, // Softer slate background for web
      appBar: isDesktop
          ? null
          : const CustomAppBarNormal(title: 'Nominee List'),
      body: Padding(
        padding: isDesktop
            ? const EdgeInsets.symmetric(horizontal: 0, vertical: 0)
            : UPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💻 WEB Header Section
            if (isDesktop) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Nominees",
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        "Manage and allocate shares for your account dynamic updates.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (controller.remainingAllocation <= 0)
                      return const SizedBox.shrink();
                    return ElevatedButton.icon(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.nomineeDetail, id: 1),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Add Nominee',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const Gap(18),
            ],

            // 2. Main Content (List / Grid Container)
            Expanded(
              child: Obx(() {
                if (controller.isNomineeLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final response = controller.nomineeList.value;
                final nominees = response?.nominees;

                if (nominees == null || nominees.isEmpty) {
                  return _buildEmptyState(isDesktop, context);
                }

                // if (isDesktop) {
                //   // 💻 WEB Layout: Clean Grid with Intrinsic heights via SingleChildScrollView & Wrap
                //   // Or dynamically calculated crossAxis structures
                //   return SingleChildScrollView(
                //     physics: const BouncingScrollPhysics(),
                //     child: Wrap(
                //       spacing: 24,
                //       runSpacing: 24,
                //       children: nominees.map((nominee) {
                //         return SizedBox(
                //           width: 536, // Fits flawlessly (2 cards per row) on 1200px max-width limits
                //           child: Obx(() {
                //             final isDeleting = controller.isDeleteLoading[nominee.id] ?? false;
                //             return NomineeDetailsCard(
                //               name: nominee.name,
                //               relation: nominee.relation,
                //               percentage: "${nominee.allocationPercent.toStringAsFixed(0)}%",
                //               onTap: () {},
                //               onDelete: () => _showDeleteConfirmDialog(context, nominee),
                //               isDeleting: isDeleting,
                //               phoneNumber: nominee.phoneNumber,
                //               email: nominee.email,
                //               address: nominee.address,
                //               documentNumber: nominee.documentNumber,
                //               documentType: nominee.documentType,
                //               guardianName: nominee.guardianName,
                //               dob: nominee.dob,
                //             );
                //           }),
                //         );
                //       }).toList(),
                //     ),
                //   );
                // }
                if (isDesktop) {
                  // 💻 WEB Layout: Responsive Wrap mapping to available width
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Dynamic width calculation to ensure cards don't stretch awkwardly
                        final double availableWidth = constraints.maxWidth;
                        final bool isUltraWide = availableWidth >= 1440;
                        final double cardWidth = isUltraWide
                            ? (availableWidth - 48) /
                                  3 // 3 cards per row on ultra-wide
                            : (availableWidth >= 900
                                  ? (availableWidth - 24) / 2
                                  : availableWidth); // 2 cards per row on standard desktop

                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: nominees.map((nominee) {
                            return SizedBox(
                              width: cardWidth > 600
                                  ? 536
                                  : cardWidth, // Cap max width for perfect reading length
                              child: Obx(() {
                                final isDeleting =
                                    controller.isDeleteLoading[nominee.id] ??
                                    false;
                                return NomineeDetailsCard(
                                  name: nominee.name,
                                  relation: nominee.relation,
                                  percentage:
                                      "${nominee.allocationPercent.toStringAsFixed(0)}%",
                                  onTap: () {},
                                  onDelete: () => _showDeleteConfirmDialog(
                                    context,
                                    nominee,
                                  ),
                                  isDeleting: isDeleting,
                                  phoneNumber: nominee.phoneNumber,
                                  email: nominee.email,
                                  address: nominee.address,
                                  documentNumber: nominee.documentNumber,
                                  documentType: nominee.documentType,
                                  guardianName: nominee.guardianName,
                                  dob: nominee.dob,
                                );
                              }),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  );
                } else {
                  // 📱 MOBILE Layout
                  return ListView.separated(
                    itemCount: nominees.length,
                    separatorBuilder: (context, index) => const Gap(16),
                    itemBuilder: (context, index) {
                      final nominee = nominees[index];
                      return Obx(() {
                        final isDeleting =
                            controller.isDeleteLoading[nominee.id] ?? false;
                        return NomineeDetailsCard(
                          name: nominee.name,
                          relation: nominee.relation,
                          percentage:
                              "${nominee.allocationPercent.toStringAsFixed(0)}%",
                          onTap: () {},
                          onDelete: () =>
                              _showDeleteConfirmDialog(context, nominee),
                          isDeleting: isDeleting,
                          phoneNumber: nominee.phoneNumber,
                          email: nominee.email,
                          address: nominee.address,
                          documentNumber: nominee.documentNumber,
                          documentType: nominee.documentType,
                          guardianName: nominee.guardianName,
                          dob: nominee.dob,
                        );
                      });
                    },
                  );
                }
              }),
            ),

            // 4. Mobile Bottom Sticky Navigation Button
            if (!isDesktop) ...[
              const Gap(12),
              Obx(() {
                if (controller.remainingAllocation <= 0)
                  return const SizedBox.shrink();
                return UElevatedBUtton(
                  outlined: true,
                  onPressed: () => Get.toNamed(AppRoutes.nomineeDetail),
                  child: const Center(
                    child: Text(
                      'Add Another Nominee',
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: Ucolors.blue,
                      ),
                    ),
                  ),
                );
              }),
              const Gap(12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.group_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "No Nominees Added Yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Please assign up to 100% allocation across your structural nominees.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (isDesktop)
                      ElevatedButton(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.nomineeDetail, id: 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Ucolors.blue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add Your First Nominee',
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, dynamic nominee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Nominee"),
        content: Text("Are you sure you want to remove ${nominee.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontFamily: FontFamily.medium,
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              controller.deleteNominee(nominee); // Call API
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                fontFamily: FontFamily.medium,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================
// WIDGET: NomineeDetailsCard
// =========================================
// =========================================
// 💳 MODERN RESPONSIVE NOMINEE CARD
// =========================================
class NomineeDetailsCard extends StatelessWidget {
  const NomineeDetailsCard({
    super.key,
    required this.name,
    required this.relation,
    required this.percentage,
    required this.onTap,
    required this.onDelete,
    required this.isDeleting,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.documentNumber,
    required this.documentType,
    this.guardianName,
    required this.dob,
  });

  final String name;
  final String relation;
  final String percentage;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String phoneNumber;
  final String email;
  final String address;
  final String documentNumber;
  final String documentType;
  final String? guardianName;
  final String dob;
  final bool isDeleting;

  // Helper to extract initials for the premium avatar
  String get _initials {
    if (name.isEmpty) return "N";
    List<String> parts = name.trim().split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint to switch card's internal layout from List to Grid
        final bool isWideCard = constraints.maxWidth > 450;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP CARD: Summary & Actions ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Premium User Avatar
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Ucolors.primary.withValues(alpha: 0.1),
                      child: Text(
                        _initials,
                        style: TextStyle(
                          color: Ucolors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: FontFamily.medium,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name & Badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _buildBadge(
                                relation.toUpperCase(),
                                isDark,
                                isPrimary: true,
                              ),
                              _buildBadge(
                                '$percentage Allocation',
                                isDark,
                                isSuccess: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Delete Action
                    isDeleting
                        ? const SizedBox(
                            width: 36,
                            height: 36,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.redAccent,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: onDelete,
                            tooltip: 'Delete Nominee',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withValues(
                                alpha: 0.05,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                thickness: 1,
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFF1F5F9),
              ),

              // --- BOTTOM CARD: Details Layout ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: isWideCard
                    ? _buildWebDetailsGrid(context, isDark)
                    : _buildMobileDetailsList(context, isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  // 💻 WEB/TABLET: Multi-column internal grid
  Widget _buildWebDetailsGrid(BuildContext context, bool isDark) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _buildGridItem(
          context,
          icon: Icons.cake_outlined,
          iconColor: Colors.orange,
          label: 'DATE OF BIRTH',
          value: dob,
          isDark: isDark,
        ),
        if (guardianName != null && guardianName!.isNotEmpty)
          _buildGridItem(
            context,
            icon: Icons.person_outline,
            iconColor: Colors.teal,
            label: 'GUARDIAN NAME',
            value: guardianName!,
            isDark: isDark,
          ),
        _buildGridItem(
          context,
          icon: Icons.mail_outline,
          iconColor: Colors.indigo,
          label: 'EMAIL ADDRESS',
          value: email.isNotEmpty ? email : 'N/A',
          isDark: isDark,
        ),
        _buildGridItem(
          context,
          icon: Icons.call_outlined,
          iconColor: Colors.green,
          label: 'PHONE NUMBER',
          value: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
          isDark: isDark,
        ),
        _buildGridItem(
          context,
          icon: Icons.badge_outlined,
          iconColor: Colors.purple,
          label: documentType.toUpperCase(),
          value: documentNumber,
          isDark: isDark,
        ),
        _buildGridItem(
          context,
          icon: Icons.location_on_outlined,
          iconColor: Colors.red,
          label: 'ADDRESS',
          value: address,
          isDark: isDark,
          isFullWidth: true,
        ),
      ],
    );
  }

  // 📱 MOBILE: Stacked list layout
  Widget _buildMobileDetailsList(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildListItem(
          context,
          icon: Icons.cake_outlined,
          iconColor: Colors.orange,
          label: 'DATE OF BIRTH',
          value: dob,
          isDark: isDark,
        ),
        if (guardianName != null && guardianName!.isNotEmpty)
          _buildListItem(
            context,
            icon: Icons.person_outline,
            iconColor: Colors.teal,
            label: 'GUARDIAN NAME',
            value: guardianName!,
            isDark: isDark,
          ),
        _buildListItem(
          context,
          icon: Icons.mail_outline,
          iconColor: Colors.indigo,
          label: 'EMAIL ADDRESS',
          value: email.isNotEmpty ? email : 'N/A',
          isDark: isDark,
        ),
        _buildListItem(
          context,
          icon: Icons.call_outlined,
          iconColor: Colors.green,
          label: 'PHONE NUMBER',
          value: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
          isDark: isDark,
        ),
        _buildListItem(
          context,
          icon: Icons.badge_outlined,
          iconColor: Colors.purple,
          label: documentType.toUpperCase(),
          value: documentNumber,
          isDark: isDark,
        ),
        _buildListItem(
          context,
          icon: Icons.location_on_outlined,
          iconColor: Colors.red,
          label: 'ADDRESS',
          value: address,
          isDark: isDark,
          isLast: true,
        ),
      ],
    );
  }

  // Helper: Grid Item for Web
  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth
          ? double.infinity
          : 210, // 210px ensures 2 columns inside a 536px card
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconBox(icon, iconColor),
          const SizedBox(width: 12),
          Expanded(child: _buildTextContent(label, value, isDark)),
        ],
      ),
    );
  }

  // Helper: List Item for Mobile
  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155).withValues(alpha: 0.5)
                      : const Color(0xFFF1F5F9),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconBox(icon, iconColor),
          const SizedBox(width: 16),
          Expanded(child: _buildTextContent(label, value, isDark)),
        ],
      ),
    );
  }

  // Component: Icon Box
  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  // Component: Text Content (Label & Value)
  Widget _buildTextContent(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Component: Pill Badge
  Widget _buildBadge(
    String text,
    bool isDark, {
    bool isPrimary = false,
    bool isSuccess = false,
  }) {
    Color textColor = isPrimary
        ? const Color(0xFF1D4ED8)
        : (isSuccess ? const Color(0xFF059669) : Colors.grey);
    Color bgColor = isPrimary
        ? (isDark
              ? Colors.blue.withValues(alpha: 0.15)
              : const Color(0xFFEFF6FF))
        : (isDark
              ? Colors.green.withValues(alpha: 0.15)
              : const Color(0xFFECFDF5));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: FontFamily.medium,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
// class NomineeDetailsCard extends StatelessWidget {
//   const NomineeDetailsCard({
//     super.key,
//     required this.name,
//     required this.relation,
//     required this.percentage,
//     required this.onTap,
//     required this.onDelete,
//     required this.isDeleting,
//     required this.phoneNumber,
//     required this.email,
//     required this.address,
//     required this.documentNumber,
//     required this.documentType,
//     this.guardianName,
//     required this.dob,
//   });

//   final String name;
//   final String relation;
//   final String percentage;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;
//   final String phoneNumber;
//   final String email;
//   final String address;
//   final String documentNumber;
//   final String documentType;
//   final String? guardianName;
//   final String dob;
//   final bool isDeleting;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1E293B) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // --- TOP CARD: Summary Section ---
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: TextStyle(
//                           fontFamily: FontFamily.medium,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: isDark
//                               ? Colors.white
//                               : const Color(0xFF0F172A),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? Colors.blue.withValues(alpha: 0.15)
//                                   : const Color(0xFFEFF6FF),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               relation.toUpperCase(),
//                               style: const TextStyle(
//                                 fontFamily: FontFamily.medium,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w800,
//                                 color: Color(0xFF1D4ED8),
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               '•',
//                               style: TextStyle(
//                                 fontFamily: FontFamily.medium,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '$percentage Allocation',
//                             style: const TextStyle(
//                               fontFamily: FontFamily.medium,
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF059669),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Deleting Logic
//                 isDeleting
//                     ? const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.redAccent,
//                           ),
//                         ),
//                       )
//                     : IconButton(
//                         onPressed: onDelete,
//                         icon: const Icon(
//                           Icons.delete_outline,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//               ],
//             ),
//           ),

//           Divider(
//             height: 1,
//             thickness: 1,
//             color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
//           ),

//           // --- BOTTOM CARD: Details List ---
//           Column(
//             children: [
//               _buildDetailItem(
//                 context,
//                 icon: Icons.cake_outlined,
//                 iconColor: Colors.orange,
//                 label: 'DATE OF BIRTH',
//                 value: dob,
//               ),
//               if (guardianName != null && guardianName!.isNotEmpty)
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.person_outline,
//                   iconColor: Colors.teal,
//                   label: 'GUARDIAN NAME',
//                   value: guardianName!,
//                 ),
//               _buildDetailItem(
//                 context,
//                 icon: Icons.mail_outline,
//                 iconColor: Colors.indigo,
//                 label: 'EMAIL ADDRESS',
//                 value: email.isNotEmpty ? email : 'N/A',
//               ),
//               _buildDetailItem(
//                 context,
//                 icon: Icons.call_outlined,
//                 iconColor: Colors.green,
//                 label: 'PHONE NUMBER',
//                 value: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
//               ),
//               _buildDetailItem(
//                 context,
//                 icon: Icons.badge_outlined,
//                 iconColor: Colors.purple,
//                 label: documentType.toUpperCase(),
//                 value: documentNumber,
//               ),
//               _buildDetailItem(
//                 context,
//                 icon: Icons.location_on_outlined,
//                 iconColor: Colors.red,
//                 label: 'ADDRESS',
//                 value: address,
//                 isLast: true,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem(
//     BuildContext context, {
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required String value,
//     bool isLast = false,
//   }) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : Border(
//                 bottom: BorderSide(
//                   color: isDark
//                       ? const Color(0xFF334155).withValues(alpha: 0.5)
//                       : const Color(0xFFF8FAFC),
//                 ),
//               ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: iconColor.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: iconColor, size: 16),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontFamily: FontFamily.medium,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                     color: isDark
//                         ? const Color(0xFF64748B)
//                         : const Color(0xFF94A3B8),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontFamily: FontFamily.medium,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: isDark
//                         ? const Color(0xFFE2E8F0)
//                         : const Color(0xFF1E293B),
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
