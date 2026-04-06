import 'dart:developer';

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
    // 🚀 Check if Desktop/Web or Mobile
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    // Trigger fetch when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNominee();
    });

    return Scaffold(
      backgroundColor: isDesktop ? const Color(0xFFF5F7FA) : Colors.white,
      appBar: isDesktop
          ? null
          : const CustomAppBarNormal(title: 'Nominee List'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ), // Max width for web
          child: Padding(
            padding: isDesktop
                ? const EdgeInsets.all(40)
                : UPadding.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 💻 WEB Header
                if (isDesktop) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your Nominees",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        if (controller.remainingAllocation <= 0)
                          return const SizedBox.shrink();
                        return ElevatedButton.icon(
                          onPressed: () => Get.toNamed(AppRoutes.nomineeDetail),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Add Nominee',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const Gap(24),
                ],

                Expanded(
                  child: Obx(() {
                    // 1. Loading State
                    if (controller.isNomineeLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final response = controller.nomineeList.value;
                    final nominees = response?.nominees;

                    // 2. Empty State
                    if (nominees == null || nominees.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off_outlined,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const Gap(16),
                            Text(
                              "No nominees added yet",
                              style: UTextStyles.subtitle2.copyWith(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            const Gap(24),
                            // Web par empty state mein button beech mein
                            if (isDesktop)
                              ElevatedButton(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.nomineeDetail),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Ucolors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  'Add Your First Nominee',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      );
                    }

                    // 3. Data List State (List for Mobile, Grid for Web)
                    if (isDesktop) {
                      // 💻 WEB: Grid Layout
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 cards per row
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio:
                                  0.95, // Adjust this to fit content height properly
                            ),
                        itemCount: nominees.length,
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
                    } else {
                      // 📱 MOBILE: Standard List Layout
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

                // 4. Mobile Add Button (Bottom)
                if (!isDesktop) ...[
                  const Gap(20),
                  Obx(() {
                    if (controller.remainingAllocation <= 0)
                      return const SizedBox.shrink();
                    return UElevatedBUtton(
                      outlined: true,
                      onPressed: () => Get.toNamed(AppRoutes.nomineeDetail),
                      child: const Center(
                        child: Text(
                          'Add Another Nominee',
                          style: TextStyle(color: Ucolors.blue),
                        ),
                      ),
                    );
                  }),
                  const Gap(20), // Bottom Safe Area
                ],
              ],
            ),
          ),
        ),
      ),
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
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              controller.deleteNominee(nominee); // Call API
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// =========================================
// WIDGET: NomineeDetailsCard
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // 🚀 FIX 1: Column ko utni hi jagah lene do jitni zarurat hai
        children: [
          // --- TOP CARD: Summary Section ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.blue.withOpacity(0.15)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              relation.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1D4ED8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '•',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Text(
                            '$percentage Allocation',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Deleting Logic
                isDeleting
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                      ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),

          // --- BOTTOM CARD: Details List ---
          // 🚀 FIX 2: Hata diya Expanded() aur ListView().
          // Ab yeh ek simple Column hai jo unbounded error nahi dega!
          Column(
            children: [
              _buildDetailItem(
                context,
                icon: Icons.cake_outlined,
                iconColor: Colors.orange,
                label: 'DATE OF BIRTH',
                value: dob,
              ),
              if (guardianName != null && guardianName!.isNotEmpty)
                _buildDetailItem(
                  context,
                  icon: Icons.person_outline,
                  iconColor: Colors.teal,
                  label: 'GUARDIAN NAME',
                  value: guardianName!,
                ),
              _buildDetailItem(
                context,
                icon: Icons.mail_outline,
                iconColor: Colors.indigo,
                label: 'EMAIL ADDRESS',
                value: email.isNotEmpty ? email : 'N/A',
              ),
              _buildDetailItem(
                context,
                icon: Icons.call_outlined,
                iconColor: Colors.green,
                label: 'PHONE NUMBER',
                value: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
              ),
              _buildDetailItem(
                context,
                icon: Icons.badge_outlined,
                iconColor: Colors.purple,
                label: documentType.toUpperCase(),
                value: documentNumber,
              ),
              _buildDetailItem(
                context,
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                label: 'ADDRESS',
                value: address,
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155).withOpacity(0.5)
                      : const Color(0xFFF8FAFC),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: isDark
//                               ? Colors.white
//                               : const Color(0xFF0F172A),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         // Changed Row to Wrap to prevent overflow on small screens
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? Colors.blue.withOpacity(0.15)
//                                   : const Color(0xFFEFF6FF),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               relation.toUpperCase(),
//                               style: const TextStyle(
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
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                           Text(
//                             '$percentage Allocation',
//                             style: const TextStyle(
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
//           Expanded(
//             // Wrap list in Expanded so it handles space within fixed aspect ratio Grid
//             child: ListView(
//               physics:
//                   const NeverScrollableScrollPhysics(), // Prevent inner scrolling
//               children: [
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.cake_outlined,
//                   iconColor: Colors.orange,
//                   label: 'DATE OF BIRTH',
//                   value: dob,
//                 ),
//                 if (guardianName != null && guardianName!.isNotEmpty)
//                   _buildDetailItem(
//                     context,
//                     icon: Icons.person_outline,
//                     iconColor: Colors.teal,
//                     label: 'GUARDIAN NAME',
//                     value: guardianName!,
//                   ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.mail_outline,
//                   iconColor: Colors.indigo,
//                   label: 'EMAIL ADDRESS',
//                   value: email.isNotEmpty ? email : 'N/A',
//                 ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.call_outlined,
//                   iconColor: Colors.green,
//                   label: 'PHONE NUMBER',
//                   value: phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
//                 ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.badge_outlined,
//                   iconColor: Colors.purple,
//                   label: documentType.toUpperCase(),
//                   value: documentNumber,
//                 ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.location_on_outlined,
//                   iconColor: Colors.red,
//                   label: 'ADDRESS',
//                   value: address,
//                   isLast: true,
//                 ),
//               ],
//             ),
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
//                       ? const Color(0xFF334155).withOpacity(0.5)
//                       : const Color(0xFFF8FAFC),
//                 ),
//               ),
//       ),
//       child: Row(
//         crossAxisAlignment:
//             CrossAxisAlignment.start, // Align to top for multi-line address
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.1),
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
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: isDark
//                         ? const Color(0xFFE2E8F0)
//                         : const Color(0xFF1E293B),
//                   ),
//                   maxLines: 2, // Limit address to 2 lines
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

// class NomineeListScreen extends GetView<PersonalisationController> {
//   const NomineeListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Trigger fetch when screen loads (mimics initState)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getNominee();
//     });

//     return Scaffold(
//       appBar: const CustomAppBarNormal(title: 'Nominee List'),
//       body: Padding(
//         padding: UPadding.screenPadding,
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Expanded(
//               child: Obx(() {
//                 // 1. Loading State (Global)
//                 if (controller.isNomineeLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final response = controller.nomineeList.value;
//                 final nominees = response?.nominees;

//                 // 2. Empty State
//                 if (nominees == null || nominees.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.person_off_outlined,
//                           size: 60,
//                           color: Colors.grey.shade400,
//                         ),
//                         const Gap(10),
//                         Text(
//                           "No nominees added yet",
//                           style: UTextStyles.subtitle2.copyWith(
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // 3. Data List State
//                 return ListView.separated(
//                   itemCount: nominees.length,
//                   separatorBuilder: (context, index) => const Gap(12),
//                   itemBuilder: (context, index) {
//                     final nominee = nominees[index];

//                     // Check if THIS specific nominee is being deleted
//                     return Obx(() {
//                       final isDeleting =
//                           controller.isDeleteLoading[nominee.id] ?? false;

//                       return NomineeDetailsCard(
//                         name: nominee.name,
//                         relation: nominee.relation,
//                         percentage:
//                             "${nominee.allocationPercent.toStringAsFixed(0)}%",

//                         onTap: () {},
//                         onDelete: () {
//                           // log('message');
//                           _showDeleteConfirmDialog(context, nominee);
//                         },
//                         isDeleting: isDeleting,
//                         phoneNumber: nominee.phoneNumber,
//                         email: nominee.email,
//                         address: nominee.address,
//                         documentNumber: nominee.documentNumber,
//                         documentType: nominee.documentType,
//                         guardianName: nominee.guardianName,
//                         dob: nominee.dob,
//                       );
//                       //  NomineeListCard(
//                       //   name: nominee.name,
//                       //   relation: nominee.relation,
//                       //   percentage:
//                       //       "${nominee.allocationPercent.toStringAsFixed(0)}%",
//                       //   isDeleting: isDeleting,
//                       //   onTap: () {},
//                       //   onDelete: () {
//                       //     _showDeleteConfirmDialog(context, nominee);
//                       //   },
//                       // );
//                     });
//                   },
//                 );
//               }),
//             ),
//             const Gap(20),

//             // 4. Add Button (Hidden if allocation is full)
//             Obx(() {
//               // Hide button if no allocation remaining (100% used)
//               if (controller.remainingAllocation <= 0) {
//                 return const SizedBox.shrink();
//               }
//               return UElevatedBUtton(
//                 outlined: true,
//                 onPressed: () => Get.toNamed(AppRoutes.nomineeDetail),
//                 child: const Center(
//                   child: Text(
//                     'Add Another Nominee',
//                     style: TextStyle(color: Ucolors.blue),
//                   ),
//                 ),
//               );
//             }),
//             const Gap(20), // Bottom Safe Area
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmDialog(BuildContext context, dynamic nominee) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Nominee"),
//         content: Text("Are you sure you want to remove ${nominee.name}?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               controller.deleteNominee(nominee); // Call API
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NomineeListCard extends StatelessWidget {
//   const NomineeListCard({
//     super.key,
//     required this.name,
//     required this.relation,
//     required this.percentage,
//     required this.onTap,
//     required this.onDelete,
//     this.isDeleting = false,
//   });

//   final String name;
//   final String relation;
//   final String percentage;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;
//   final bool isDeleting;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0.5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       color: Ucolors.light,
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         onTap: onTap,
//         title: Text(
//           name,
//           style: UTextStyles.medium.copyWith(
//             color: Ucolors.dark,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 4.0),
//           child: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: "Relation: ",
//                   style: UTextStyles.caption.copyWith(color: Colors.grey),
//                 ),
//                 TextSpan(
//                   text: "$relation  ",
//                   style: UTextStyles.caption.copyWith(
//                     color: Ucolors.dark,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 TextSpan(
//                   text: "|  Share: ",
//                   style: UTextStyles.caption.copyWith(color: Colors.grey),
//                 ),
//                 TextSpan(
//                   text: percentage,
//                   style: UTextStyles.caption.copyWith(
//                     color: Ucolors.blue,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         trailing: isDeleting
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : IconButton(
//                 onPressed: onDelete,
//                 icon: const Icon(
//                   Icons.delete_outline,
//                   size: 22,
//                   color: Colors.redAccent,
//                 ),
//               ),
//       ),
//     );
//   }
// }

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
//       // padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1E293B) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
//         ),
//       ),
//       child: Column(
//         children: [
//           // --- TOP CARD: Summary Section ---
//           Padding(
//             padding: const EdgeInsets.only(left: 16, top: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: isDark
//                               ? Colors.white
//                               : const Color(0xFF0F172A),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? Colors.blue.withOpacity(0.15)
//                                   : const Color(0xFFEFF6FF),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               relation.toUpperCase(),
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF1D4ED8),
//                               ),
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               '•',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                           Text(
//                             '$percentage Allocation',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF3B82F6),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Deleting Logic from previous card
//                 isDeleting
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.redAccent,
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
//           SizedBox(height: 10),
//           DashedLine(color: Color(0xFFF8FAFC), dashSpace: 0),

//           // --- BOTTOM CARD: Details List ---
//           _buildDetailItem(
//             context,
//             icon: Icons.cake_outlined,
//             iconColor: Colors.orange,
//             label: 'DATE OF BIRTH',
//             value: dob,
//           ),

//           if (guardianName != null && guardianName!.isNotEmpty)
//             _buildDetailItem(
//               context,
//               icon: Icons.person_outline,
//               iconColor: Colors.teal,
//               label: 'GUARDIAN NAME',
//               value: guardianName!,
//             ),

//           _buildDetailItem(
//             context,
//             icon: Icons.mail_outline,
//             iconColor: Colors.indigo,
//             label: 'EMAIL ADDRESS',
//             value: email,
//           ),

//           _buildDetailItem(
//             context,
//             icon: Icons.call_outlined,
//             iconColor: Colors.green,
//             label: 'PHONE NUMBER',
//             value: phoneNumber,
//           ),

//           _buildDetailItem(
//             context,
//             icon: Icons.badge_outlined,
//             iconColor: Colors.purple,
//             label: documentType.toUpperCase(),
//             value: documentNumber,
//           ),

//           _buildDetailItem(
//             context,
//             icon: Icons.location_on_outlined,
//             iconColor: Colors.red,
//             label: 'ADDRESS',
//             value: address,
//             isLast: true,
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

//     return InkWell(
//       onTap:
//           onTap, // Making individual rows clickable if needed, or keep for overall card
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           border: isLast
//               ? null
//               : Border(
//                   bottom: BorderSide(
//                     color: isDark
//                         ? const Color(0xFF334155).withOpacity(0.5)
//                         : const Color(0xFFF8FAFC),
//                   ),
//                 ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: iconColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: iconColor, size: 15),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                       color: isDark
//                           ? const Color(0xFF64748B)
//                           : const Color(0xFF94A3B8),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: isDark
//                           ? const Color(0xFFE2E8F0)
//                           : const Color(0xFF1E293B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // --- CARD 1: Profile Summary ---
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF1E293B) : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isDark
//                     ? const Color(0xFF334155)
//                     : const Color(0xFFF1F5F9),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         name,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: isDark
//                               ? Colors.white
//                               : const Color(0xFF0F172A),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
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
//                                   ? Colors.blue.withOpacity(0.15)
//                                   : const Color(0xFFEFF6FF),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               relation.toUpperCase(),
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xFF1D4ED8),
//                               ),
//                             ),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.0),
//                             child: Text(
//                               '•',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                           Text(
//                             '$percentage Allocation',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF3B82F6),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Show loader if deleting, else show edit/profile icon
//                 isDeleting
//                     ? const SizedBox(
//                         width: 32,
//                         height: 32,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? const Color(0xFF334155)
//                               : const Color(0xFFF1F5F9),
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           icon: const Icon(
//                             Icons.edit_outlined,
//                             color: Color(0xFF3B82F6),
//                           ),
//                           onPressed: onTap,
//                         ),
//                       ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // --- CARD 2: Detailed Info List ---
//           Container(
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF1E293B) : Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isDark
//                     ? const Color(0xFF334155)
//                     : const Color(0xFFF1F5F9),
//               ),
//             ),
//             child: Column(
//               children: [
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.cake_outlined,
//                   iconColor: Colors.orange,
//                   label: 'DATE OF BIRTH',
//                   value: dob,
//                 ),
//                 // Only show Guardian if name is provided
//                 if (guardianName != null && guardianName!.isNotEmpty)
//                   _buildDetailItem(
//                     context,
//                     icon: Icons.security_outlined,
//                     iconColor: Colors.teal,
//                     label: 'GUARDIAN NAME',
//                     value: guardianName!,
//                   ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.mail_outline,
//                   iconColor: Colors.indigo,
//                   label: 'EMAIL ADDRESS',
//                   value: email,
//                 ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.call_outlined,
//                   iconColor: Colors.green,
//                   label: 'PHONE NUMBER',
//                   value: phoneNumber,
//                 ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.badge_outlined,
//                   iconColor: Colors.purple,
//                   label: '$documentType CARD',
//                   value: documentNumber,
//                 ),
//                 _buildDetailItem(
//                   context,
//                   icon: Icons.location_on_outlined,
//                   iconColor: Colors.redAccent,
//                   label: 'PERMANENT ADDRESS',
//                   value: address,
//                   isLast: true,
//                 ),
//               ],
//             ),
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
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : Border(
//                 bottom: BorderSide(
//                   color: isDark
//                       ? const Color(0xFF334155).withOpacity(0.5)
//                       : const Color(0xFFF8FAFC),
//                 ),
//               ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: iconColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: iconColor, size: 20),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
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
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: isDark
//                         ? const Color(0xFFE2E8F0)
//                         : const Color(0xFF1E293B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
//     // Theme-aware colors
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       // margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1E293B) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Section: Name, Relation, Allocation
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: isDark
//                                 ? Colors.blue.withOpacity(0.2)
//                                 : const Color(0xFFEFF6FF),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             relation,
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w800,
//                               color: isDark
//                                   ? Colors.blue[300]
//                                   : const Color(0xFF1D4ED8),
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8.0),
//                           child: CircleAvatar(
//                             radius: 2,
//                             backgroundColor: Colors.grey,
//                           ),
//                         ),
//                         Text(
//                           '$percentage Allocation',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF059669), // emerald-600
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               isDeleting
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : IconButton(
//                       onPressed: onDelete,
//                       icon: const Icon(
//                         Icons.delete_outline,
//                         size: 22,
//                         color: Colors.redAccent,
//                       ),
//                     ),
//             ],
//           ),

//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 16.0),
//             child: Divider(height: 1, thickness: 0.5),
//           ),

//           // Details Section
//           _buildInfoRow(Icons.call, phoneNumber, isDark),
//           const SizedBox(height: 12),
//           _buildInfoRow(Icons.mail_outline, email, isDark),
//           const SizedBox(height: 12),
//           _buildInfoRow(Icons.calendar_month, dob, isDark),

//           const SizedBox(height: 12),
//           _buildAadhaarRow(documentType, documentNumber, isDark, null),
//           const SizedBox(height: 12),
//           if (guardianName != "") ...[
//             _buildAadhaarRow(
//               'Guardian name',
//               guardianName ?? '',
//               isDark,
//               Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
//             ),
//             const SizedBox(height: 12),
//           ],
//           _buildInfoRow(Icons.location_on_outlined, address, isDark),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text, bool isDark) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[500]),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: isDark ? Colors.grey[300] : const Color(0xFF475569),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAadhaarRow(
//     String docType,
//     String docNum,
//     bool isDark,
//     Icon? icon,
//   ) {
//     return Row(
//       children: [
//         (icon ?? Icon(Icons.badge_outlined, size: 16, color: Colors.grey[500])),
//         const SizedBox(width: 12),
//         Text(
//           '$docType: ',
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w800,
//             color: Colors.grey[500],
//           ),
//         ),
//         Text(
//           docNum,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//             color: isDark ? Colors.grey[300] : const Color(0xFF475569),
//           ),
//         ),
//       ],
//     );
//   }
// }
