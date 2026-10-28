import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import '../../data/datasource/ticket_remote_ds.dart';
import '../../data/repositories/ticket_repo_impl.dart';
import '../../domain/entities/ticket_category_entity.dart';
import '../../domain/usecases/ticket_usecases.dart';
import 'tickets_controller.dart';

class CreateTicketController extends GetxController {
  final GetTicketCategoriesUseCase getCategoriesUseCase;
  final CreateTicketUseCase createTicketUseCase;

  CreateTicketController({
    GetTicketCategoriesUseCase? categoriesUseCase,
    CreateTicketUseCase? createUseCase,
  })  : getCategoriesUseCase = categoriesUseCase ??
            GetTicketCategoriesUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            ),
        createTicketUseCase = createUseCase ??
            CreateTicketUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            );

  final isLoadingCategories = false.obs;
  final isSubmitting = false.obs;

  final categories = <TicketCategoryEntity>[].obs;
  final selectedCategory = Rxn<TicketCategoryEntity>();

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final descriptionError = RxnString();

  final selectedPriority = 'MEDIUM'.obs;
  final priorities = const ['LOW', 'MEDIUM', 'HIGH', 'URGENT'];

  final attachments = <File>[].obs;
  static const int maxAttachments = 5;
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB limit per file

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    final result = await getCategoriesUseCase();
    result.fold(
      (success) {
        categories.assignAll(success.data ?? []);
        if (categories.isNotEmpty && selectedCategory.value == null) {
          selectedCategory.value = categories.first;
        }
      },
      (error) {
        createLog("[CreateTicketController] Error categories: ${error.message}");
      },
    );
    isLoadingCategories.value = false;
  }

  void setCategory(TicketCategoryEntity category) {
    selectedCategory.value = category;
  }

  void setPriority(String priority) {
    selectedPriority.value = priority;
  }

  Future<void> pickFiles() async {
    if (attachments.length >= maxAttachments) {
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
        for (final platformFile in result.files) {
          if (attachments.length >= maxAttachments) break;
          if (platformFile.path == null) continue;

          final file = File(platformFile.path!);
          final size = await file.length();
          if (size > maxFileSizeBytes) {
            Get.snackbar(
              'File Too Large',
              '${platformFile.name} exceeds the 5MB limit.',
              snackPosition: SnackPosition.BOTTOM,
            );
            continue;
          }

          if (!attachments.any((f) => f.path == file.path)) {
            attachments.add(file);
          }
        }
      }
    } catch (e) {
      createLog("[CreateTicketController] Error picking files: $e");
    }
  }

  Future<void> pickFromCamera() async {
    if (attachments.length >= maxAttachments) {
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
            'Image exceeds the 5MB limit.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        attachments.add(file);
      }
    } catch (e) {
      createLog("[CreateTicketController] Camera error: $e");
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      attachments.removeAt(index);
    }
  }

  Future<void> submitTicket() async {
    final subject = subjectController.text.trim();
    final description = descriptionController.text.trim();

    if (selectedCategory.value == null) {
      Get.snackbar('Missing Field', 'Please select a ticket category.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (subject.isEmpty) {
      Get.snackbar('Missing Field', 'Please provide a subject for your ticket.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (subject.length > 255) {
      Get.snackbar('Validation Error', 'Subject cannot exceed 255 characters.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (description.isEmpty) {
      descriptionError.value = 'Please provide a detailed description.';
      return;
    }

    if (description.length < 5) {
      descriptionError.value = 'Description must be at least 5 characters long.';
      return;
    }

    descriptionError.value = null;

    isSubmitting.value = true;

    final result = await createTicketUseCase(
      categoryId: selectedCategory.value!.id,
      subject: subject,
      description: description,
      priority: selectedPriority.value,
      attachments: attachments.isNotEmpty ? attachments.toList() : null,
    );

    isSubmitting.value = false;

    result.fold(
      (success) {
        Get.snackbar(
          'Success',
          'Ticket #${success.data?.ticketNumber ?? ''} created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );

        if (Get.isRegistered<TicketsController>()) {
          Get.find<TicketsController>().fetchTickets(isRefresh: true);
        }

        Get.back();
      },
      (error) {
        Get.snackbar(
          'Submission Failed',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      },
    );
  }
}
