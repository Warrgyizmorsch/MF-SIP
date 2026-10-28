import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import '../../domain/entities/ticket_category_entity.dart';
import '../controllers/create_ticket_controller.dart';
import '../widgets/ticket_priority_badge.dart';

class CreateTicketPage extends StatelessWidget {
  const CreateTicketPage({super.key});

  void _showAttachmentSourceSheet(BuildContext context, CreateTicketController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Attachment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F2FE),
                  child: Icon(Icons.camera_alt_rounded, color: Color(0xFF0280C0)),
                ),
                title: const Text('Take Photo with Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickFromCamera();
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F2FE),
                  child: Icon(Icons.file_present_rounded, color: Color(0xFF0280C0)),
                ),
                title: const Text('Choose Document or Image'),
                subtitle: const Text('PDF, JPG, PNG, DOC (max 10MB)'),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.pickFiles();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateTicketController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF11141C) : Colors.white,
      appBar: const CustomAppBarNormal(
        title: 'Raise Support Ticket',
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2230) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() {
            return SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0280C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submitTicket,
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Ticket',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selector
            const Text(
              'Select Issue Category *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingCategories.value) {
                return const LinearProgressIndicator();
              }

              if (controller.categories.isEmpty) {
                return const Text(
                  'No categories available',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                );
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TicketCategoryEntity>(
                    isExpanded: true,
                    value: controller.selectedCategory.value,
                    hint: const Text('Choose a category'),
                    items: controller.categories.map((cat) {
                      return DropdownMenuItem<TicketCategoryEntity>(
                        value: cat,
                        child: Text(
                          cat.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.setCategory(val);
                    },
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Priority Selector
            const Text(
              'Priority',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return Wrap(
                spacing: 8,
                children: controller.priorities.map((p) {
                  final isSelected = controller.selectedPriority.value == p;
                  final pColor = TicketPriorityBadge.getPriorityColor(p);

                  return ChoiceChip(
                    label: Text(
                      TicketPriorityBadge.getPriorityLabel(p),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : pColor,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: pColor,
                    backgroundColor: pColor.withValues(alpha: 0.08),
                    side: BorderSide(
                      color: isSelected ? pColor : pColor.withValues(alpha: 0.3),
                    ),
                    onSelected: (_) => controller.setPriority(p),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 20),

            // Subject Field
            const Text(
              'Subject *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.subjectController,
              decoration: InputDecoration(
                hintText: 'e.g., SIP amount deducted but units not allocated',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description Field
            const Text(
              'Description *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Please describe your problem or question in detail...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Attachments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attachments (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAttachmentSourceSheet(context, controller),
                  icon: const Icon(Icons.attach_file_rounded, size: 18),
                  label: const Text('Add File', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Supports up to 5 attachments (JPG, PNG, PDF, DOC). Max 10MB per file.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 10),

            // Picked attachments list
            Obx(() {
              if (controller.attachments.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: List.generate(controller.attachments.length, (index) {
                  final File file = controller.attachments[index];
                  final name = file.path.split(Platform.pathSeparator).last;
                  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
                  final isImg = ['jpg', 'jpeg', 'png', 'webp'].contains(ext);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isImg ? Icons.image_rounded : Icons.insert_drive_file_rounded,
                          size: 22,
                          color: const Color(0xFF0280C0),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                          onPressed: () => controller.removeAttachment(index),
                        ),
                      ],
                    ),
                  );
                }),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
