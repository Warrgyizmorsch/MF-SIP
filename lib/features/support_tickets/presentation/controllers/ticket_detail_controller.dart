import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import '../../data/datasource/ticket_remote_ds.dart';
import '../../data/repositories/ticket_repo_impl.dart';
import '../../domain/entities/ticket_detail_entity.dart';
import '../../domain/usecases/ticket_usecases.dart';
import 'tickets_controller.dart';

class TicketDetailController extends GetxController {
  final int ticketId;
  final GetTicketDetailUseCase getDetailUseCase;
  final ReplyTicketUseCase replyUseCase;
  final CloseTicketUseCase closeUseCase;
  final ReopenTicketUseCase reopenUseCase;

  TicketDetailController({
    required this.ticketId,
    GetTicketDetailUseCase? detailUseCase,
    ReplyTicketUseCase? replyTicketUseCase,
    CloseTicketUseCase? closeTicketUseCase,
    ReopenTicketUseCase? reopenTicketUseCase,
  })  : getDetailUseCase = detailUseCase ??
            GetTicketDetailUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            ),
        replyUseCase = replyTicketUseCase ??
            ReplyTicketUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            ),
        closeUseCase = closeTicketUseCase ??
            CloseTicketUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            ),
        reopenUseCase = reopenTicketUseCase ??
            ReopenTicketUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            );

  final isLoading = false.obs;
  final isSendingReply = false.obs;
  final isActionInProgress = false.obs;
  final errorMessage = ''.obs;

  final ticket = Rxn<TicketDetailEntity>();
  final replyController = TextEditingController();
  final replyAttachments = <File>[].obs;
  late final ScrollController chatScrollController;

  static const int maxAttachments = 3;
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

  @override
  void onInit() {
    super.onInit();
    chatScrollController = ScrollController();
    fetchDetail();
  }

  @override
  void onClose() {
    replyController.dispose();
    chatScrollController.dispose();
    super.onClose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> fetchDetail({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    errorMessage.value = '';

    final result = await getDetailUseCase(ticketId);

    result.fold(
      (success) {
        ticket.value = success.data;
        scrollToBottom();
      },
      (error) {
        errorMessage.value = error.message;
      },
    );

    if (!silent) isLoading.value = false;
  }

  Future<void> pickReplyFiles() async {
    if (replyAttachments.length >= maxAttachments) {
      Get.snackbar(
        'Limit Reached',
        'You can attach up to $maxAttachments files.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        for (final pf in result.files) {
          if (replyAttachments.length >= maxAttachments) break;
          if (pf.path == null) continue;

          final file = File(pf.path!);
          final size = await file.length();
          if (size > maxFileSizeBytes) {
            Get.snackbar(
              'File Too Large',
              '${pf.name} exceeds 10MB limit.',
              snackPosition: SnackPosition.BOTTOM,
            );
            continue;
          }

          if (!replyAttachments.any((f) => f.path == file.path)) {
            replyAttachments.add(file);
          }
        }
      }
    } catch (e) {
      createLog("[TicketDetailController] Error picking files: $e");
    }
  }

  Future<void> pickReplyCamera() async {
    if (replyAttachments.length >= maxAttachments) {
      Get.snackbar(
        'Limit Reached',
        'You can attach up to $maxAttachments files.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (photo != null) {
        final file = File(photo.path);
        final size = await file.length();
        if (size > maxFileSizeBytes) {
          Get.snackbar(
            'File Too Large',
            'Image exceeds 10MB limit.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        replyAttachments.add(file);
      }
    } catch (e) {
      createLog("[TicketDetailController] Camera error: $e");
    }
  }

  void removeReplyAttachment(int index) {
    if (index >= 0 && index < replyAttachments.length) {
      replyAttachments.removeAt(index);
    }
  }

  Future<void> sendReply() async {
    final text = replyController.text.trim();
    if (text.isEmpty && replyAttachments.isEmpty) {
      return;
    }

    isSendingReply.value = true;

    final result = await replyUseCase(
      ticketId: ticketId,
      message: text,
      attachments: replyAttachments.isNotEmpty ? replyAttachments.toList() : null,
    );

    isSendingReply.value = false;

    result.fold(
      (success) {
        replyController.clear();
        replyAttachments.clear();

        // Refresh detail to show the new message
        fetchDetail(silent: true);

        // Also refresh list in background
        if (Get.isRegistered<TicketsController>()) {
          Get.find<TicketsController>().fetchTickets(isRefresh: true);
        }
      },
      (error) {
        Get.snackbar(
          'Failed to Send',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> closeTicketDialog(BuildContext context) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to close this ticket? You can reopen it later if needed.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Optional closing reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Close Ticket', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      isActionInProgress.value = true;
      final result = await closeUseCase(ticketId, reason: reasonController.text.trim());
      isActionInProgress.value = false;

      result.fold(
        (success) {
          Get.snackbar(
            'Closed',
            'Ticket has been marked as closed.',
            snackPosition: SnackPosition.BOTTOM,
          );
          fetchDetail(silent: true);
          if (Get.isRegistered<TicketsController>()) {
            Get.find<TicketsController>().fetchTickets(isRefresh: true);
          }
        },
        (error) {
          Get.snackbar(
            'Error',
            error.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    }
  }

  Future<void> reopenTicketDialog(BuildContext context) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reopen Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Do you want to reopen this ticket for further assistance?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Optional reason for reopening...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0280C0)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reopen Ticket', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      isActionInProgress.value = true;
      final result = await reopenUseCase(ticketId, reason: reasonController.text.trim());
      isActionInProgress.value = false;

      result.fold(
        (success) {
          Get.snackbar(
            'Reopened',
            'Ticket has been reopened.',
            snackPosition: SnackPosition.BOTTOM,
          );
          fetchDetail(silent: true);
          if (Get.isRegistered<TicketsController>()) {
            Get.find<TicketsController>().fetchTickets(isRefresh: true);
          }
        },
        (error) {
          Get.snackbar(
            'Error',
            error.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    }
  }
}
