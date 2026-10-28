import '../../domain/entities/ticket_detail_entity.dart';
import 'ticket_category_model.dart';

class TicketAttachmentModel {
  final int id;
  final String name;
  final String url;
  final String type;

  TicketAttachmentModel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  factory TicketAttachmentModel.fromJson(Map<String, dynamic> json) {
    return TicketAttachmentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? 'file',
    );
  }

  TicketAttachmentEntity toEntity() {
    return TicketAttachmentEntity(
      id: id,
      name: name,
      url: url,
      type: type,
    );
  }
}

class TicketMessageModel {
  final int id;
  final String senderType;
  final String senderName;
  final String message;
  final String? readAt;
  final String createdAt;
  final List<TicketAttachmentModel> attachments;

  TicketMessageModel({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.message,
    this.readAt,
    required this.createdAt,
    required this.attachments,
  });

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'] as List<dynamic>? ?? [];

    return TicketMessageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      senderType: json['sender_type']?.toString() ?? 'USER',
      senderName: json['sender_name']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      attachments: rawAttachments
          .whereType<Map<String, dynamic>>()
          .map((a) => TicketAttachmentModel.fromJson(a))
          .toList(),
    );
  }

  TicketMessageEntity toEntity() {
    return TicketMessageEntity(
      id: id,
      senderType: senderType,
      senderName: senderName,
      message: message,
      readAt: readAt,
      createdAt: createdAt,
      attachments: attachments.map((a) => a.toEntity()).toList(),
    );
  }
}

class TicketDetailModel {
  final int id;
  final String ticketNumber;
  final String subject;
  final String priority;
  final String status;
  final TicketCategoryModel? category;
  final String? relatedType;
  final String? relatedId;
  final String createdAt;
  final String updatedAt;
  final String? resolvedAt;
  final String? closedAt;
  final List<TicketMessageModel> messages;

  TicketDetailModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.priority,
    required this.status,
    this.category,
    this.relatedType,
    this.relatedId,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.closedAt,
    required this.messages,
  });

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'] as List<dynamic>? ?? [];

    return TicketDetailModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketNumber: json['ticket_number']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'MEDIUM',
      status: json['status']?.toString() ?? 'OPEN',
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? TicketCategoryModel.fromJson(json['category'])
          : null,
      relatedType: json['related_type']?.toString(),
      relatedId: json['related_id']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      resolvedAt: json['resolved_at']?.toString(),
      closedAt: json['closed_at']?.toString(),
      messages: rawMessages
          .whereType<Map<String, dynamic>>()
          .map((m) => TicketMessageModel.fromJson(m))
          .toList(),
    );
  }

  TicketDetailEntity toEntity() {
    return TicketDetailEntity(
      id: id,
      ticketNumber: ticketNumber,
      subject: subject,
      priority: priority,
      status: status,
      category: category?.toEntity(),
      relatedType: relatedType,
      relatedId: relatedId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      resolvedAt: resolvedAt,
      closedAt: closedAt,
      messages: messages.map((m) => m.toEntity()).toList(),
    );
  }
}
