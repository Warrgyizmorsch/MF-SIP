import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import '../../domain/entities/ticket_detail_entity.dart';
import '../controllers/ticket_detail_controller.dart';
import '../widgets/ticket_chat_bubble.dart';
import '../widgets/ticket_priority_badge.dart';
import '../widgets/ticket_status_badge.dart';

class TicketDetailPage extends StatelessWidget {
  final int ticketId;

  const TicketDetailPage({
    super.key,
    required this.ticketId,
  });

  String _formatDateTime(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour)}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
    } catch (_) {
      return raw;
    }
  }

  void _showAttachmentOptions(BuildContext context, TicketDetailController controller) {
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
                'Attach to Reply',
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
                  controller.pickReplyCamera();
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
                  controller.pickReplyFiles();
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
    // Unique tag in case user opens multiple tickets
    final controller = Get.put(
      TicketDetailController(ticketId: ticketId),
      tag: 'ticket_$ticketId',
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF11141C) : const Color(0xFFF8FAFC),
      appBar: CustomAppBarNormal(
        title: 'Ticket #$ticketId',
        action: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchDetail(silent: false),
          ),
          Obx(() {
            final t = controller.ticket.value;
            if (t == null) return const SizedBox.shrink();

            final isClosed = t.isClosed;
            final isResolved = t.isResolved;

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (val) {
                if (val == 'close') {
                  controller.closeTicketDialog(context);
                } else if (val == 'reopen') {
                  controller.reopenTicketDialog(context);
                }
              },
              itemBuilder: (ctx) {
                if (isClosed || isResolved) {
                  return [
                    const PopupMenuItem(
                      value: 'reopen',
                      child: Row(
                        children: [
                          Icon(Icons.refresh_rounded, color: Color(0xFF0280C0), size: 18),
                          SizedBox(width: 8),
                          Text('Reopen Ticket'),
                        ],
                      ),
                    ),
                  ];
                } else {
                  return [
                    const PopupMenuItem(
                      value: 'close',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Close Ticket'),
                        ],
                      ),
                    ),
                  ];
                }
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade400),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchDetail(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        final ticket = controller.ticket.value;
        if (ticket == null) {
          return const Center(child: Text('No details found'));
        }

        return Column(
          children: [
            // Top ticket header card
            _buildHeaderCard(context, ticket),

            // Messages Stream
            Expanded(
              child: ticket.messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      controller: controller.chatScrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: ticket.messages.length,
                      itemBuilder: (ctx, index) {
                        final msg = ticket.messages[index];
                        return TicketChatBubble(message: msg);
                      },
                    ),
            ),

            // Bottom reply section
            _buildReplyBottomBar(context, controller, ticket),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderCard(BuildContext context, TicketDetailEntity ticket) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.ticketNumber,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0280C0),
                ),
              ),
              Row(
                children: [
                  TicketPriorityBadge(priority: ticket.priority, isCompact: true),
                  const SizedBox(width: 8),
                  TicketStatusBadge(status: ticket.status, isCompact: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ticket.subject,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (ticket.category != null) ...[
                Text(
                  ticket.category!.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ' • ',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
              Text(
                _formatDateTime(ticket.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyBottomBar(
    BuildContext context,
    TicketDetailController controller,
    TicketDetailEntity ticket,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isInactive = ticket.isClosed || ticket.isResolved;

    if (isInactive) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2230) : Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ticket.isClosed
                      ? 'This ticket is closed.'
                      : 'This ticket is marked as resolved.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0280C0),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
                label: const Text(
                  'Reopen',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () => controller.reopenTicketDialog(context),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2230) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected attachments preview strip
            Obx(() {
              if (controller.replyAttachments.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.replyAttachments.length,
                      (idx) {
                        final file = controller.replyAttachments[idx];
                        final name = file.path.split(Platform.pathSeparator).last;
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.attachment_rounded, size: 14),
                              const SizedBox(width: 4),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 100),
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => controller.removeReplyAttachment(idx),
                                child: const Icon(Icons.close_rounded, size: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),

            // Text input + send row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: Color(0xFF0280C0)),
                    tooltip: 'Attach file',
                    onPressed: () => _showAttachmentOptions(context, controller),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.replyController,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write a reply...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF161922) : Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white12 : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white12 : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Obx(() {
                    return IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF0280C0),
                        shape: const CircleBorder(),
                      ),
                      onPressed: controller.isSendingReply.value
                          ? null
                          : controller.sendReply,
                      icon: controller.isSendingReply.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
