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
    // Trigger fetch when screen loads (mimics initState)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNominee();
    });

    return Scaffold(
      appBar: const CustomAppBarNormal(title: 'Nominee List'),
      body: Padding(
        padding: UPadding.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                // 1. Loading State (Global)
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
                        Icon(Icons.person_off_outlined,
                            size: 60, color: Colors.grey.shade400),
                        const Gap(10),
                        Text(
                          "No nominees added yet",
                          style: UTextStyles.subtitle2.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // 3. Data List State
                return ListView.separated(
                  itemCount: nominees.length,
                  separatorBuilder: (context, index) => const Gap(12),
                  itemBuilder: (context, index) {
                    final nominee = nominees[index];

                    // Check if THIS specific nominee is being deleted
                    return Obx(() {
                      final isDeleting =
                          controller.isDeleteLoading[nominee.id] ?? false;

                      return NomineeListCard(
                        name: nominee.name,
                        relation: nominee.relation,
                        percentage:
                        "${nominee.allocationPercent.toStringAsFixed(0)}%",
                        isDeleting: isDeleting,
                        onTap: () {},
                        onDelete: () {
                          _showDeleteConfirmDialog(context, nominee);
                        },
                      );
                    });
                  },
                );
              }),
            ),
            const Gap(20),

            // 4. Add Button (Hidden if allocation is full)
            Obx(() {
              // Hide button if no allocation remaining (100% used)
              if (controller.remainingAllocation <= 0) {
                return const SizedBox.shrink();
              }
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

class NomineeListCard extends StatelessWidget {
  const NomineeListCard({
    super.key,
    required this.name,
    required this.relation,
    required this.percentage,
    required this.onTap,
    required this.onDelete,
    this.isDeleting = false,
  });

  final String name;
  final String relation;
  final String percentage;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Ucolors.light,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
        title: Text(
          name,
          style: UTextStyles.medium.copyWith(
            color: Ucolors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Relation: ",
                    style: UTextStyles.caption.copyWith(color: Colors.grey)),
                TextSpan(
                  text: "$relation  ",
                  style: UTextStyles.caption.copyWith(
                      color: Ucolors.dark, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                    text: "|  Share: ",
                    style: UTextStyles.caption.copyWith(color: Colors.grey)),
                TextSpan(
                  text: percentage,
                  style: UTextStyles.caption.copyWith(
                      color: Ucolors.blue, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        trailing: isDeleting
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline,
            size: 22,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}