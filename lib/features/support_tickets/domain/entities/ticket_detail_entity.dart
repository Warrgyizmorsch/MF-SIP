import 'package:equatable/equatable.dart';
import 'ticket_category_entity.dart';

class TicketAttachmentEntity extends Equatable {
  final int id;
  final String name;
  final String url;
  final String type;

  const TicketAttachmentEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  bool get isImage =>
      type.toLowerCase().startsWith('image') ||
      name.toLowerCase().endsWith('.jpg') ||
      name.toLowerCase().endsWith('.jpeg') ||
      name.toLowerCase().endsWith('.png') ||
      name.toLowerCase().endsWith('.webp');

  @override
  List<Object?> get props => [id, name, url, type];
}

class TicketMessageEntity extends Equatable {
  final int id;
  final String senderType;
  final String senderName;
  final String message;
  final String? readAt;
  final String createdAt;
  final List<TicketAttachmentEntity> attachments;

  const TicketMessageEntity({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.message,
    this.readAt,
    required this.createdAt,
    required this.attachments,
  });

  bool get isUser => senderType.toUpperCase() == 'USER';

  @override
  List<Object?> get props => [
        id,
        senderType,
        senderName,
        message,
        readAt,
        createdAt,
        attachments,
      ];
}

class TicketDetailEntity extends Equatable {
  final int id;
  final String ticketNumber;
  final String subject;
  final String priority;
  final String status;
  final TicketCategoryEntity? category;
  final String? relatedType;
  final String? relatedId;
  final String createdAt;
  final String updatedAt;
  final String? resolvedAt;
  final String? closedAt;
  final List<TicketMessageEntity> messages;

  const TicketDetailEntity({
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

  bool get isClosed => status.toUpperCase() == 'CLOSED';
  bool get isResolved => status.toUpperCase() == 'RESOLVED';
  bool get canClose => !isClosed;
  bool get canReopen => isClosed || isResolved;

  @override
  List<Object?> get props => [
        id,
        ticketNumber,
        subject,
        priority,
        status,
        category,
        relatedType,
        relatedId,
        createdAt,
        updatedAt,
        resolvedAt,
        closedAt,
        messages,
      ];
}
