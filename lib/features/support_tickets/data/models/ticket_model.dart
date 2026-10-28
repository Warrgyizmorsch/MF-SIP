import '../../domain/entities/ticket_entity.dart';
import 'ticket_category_model.dart';

class TicketLatestMessageModel {
  final String message;
  final String senderType;
  final String createdAt;

  TicketLatestMessageModel({
    required this.message,
    required this.senderType,
    required this.createdAt,
  });

  factory TicketLatestMessageModel.fromJson(Map<String, dynamic> json) {
    return TicketLatestMessageModel(
      message: json['message']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  TicketLatestMessageEntity toEntity() {
    return TicketLatestMessageEntity(
      message: message,
      senderType: senderType,
      createdAt: createdAt,
    );
  }
}

class TicketModel {
  final int id;
  final String ticketNumber;
  final String subject;
  final String priority;
  final String status;
  final TicketCategoryModel? category;
  final String? relatedType;
  final String? relatedId;
  final int unreadMessages;
  final TicketLatestMessageModel? latestMessage;
  final String createdAt;
  final String updatedAt;

  TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.priority,
    required this.status,
    this.category,
    this.relatedType,
    this.relatedId,
    required this.unreadMessages,
    this.latestMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
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
      unreadMessages: json['unread_messages'] is int
          ? json['unread_messages']
          : int.tryParse(json['unread_messages']?.toString() ?? '0') ?? 0,
      latestMessage: json['latest_message'] != null && json['latest_message'] is Map<String, dynamic>
          ? TicketLatestMessageModel.fromJson(json['latest_message'])
          : null,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      ticketNumber: ticketNumber,
      subject: subject,
      priority: priority,
      status: status,
      category: category?.toEntity(),
      relatedType: relatedType,
      relatedId: relatedId,
      unreadMessages: unreadMessages,
      latestMessage: latestMessage?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class TicketListResponseModel {
  final bool success;
  final int total;
  final int openCount;
  final int resolvedCount;
  final List<TicketModel> data;
  final int currentPage;
  final int perPage;
  final int lastPage;
  final bool hasMore;

  TicketListResponseModel({
    required this.success,
    required this.total,
    required this.openCount,
    required this.resolvedCount,
    required this.data,
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
    required this.hasMore,
  });

  factory TicketListResponseModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? {};
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};
    final rawData = json['data'] as List<dynamic>? ?? [];

    return TicketListResponseModel(
      success: json['success'] == true,
      total: summary['total'] is int
          ? summary['total']
          : int.tryParse(summary['total']?.toString() ?? '0') ?? 0,
      openCount: summary['open_count'] is int
          ? summary['open_count']
          : int.tryParse(summary['open_count']?.toString() ?? '0') ?? 0,
      resolvedCount: summary['resolved_count'] is int
          ? summary['resolved_count']
          : int.tryParse(summary['resolved_count']?.toString() ?? '0') ?? 0,
      data: rawData
          .whereType<Map<String, dynamic>>()
          .map((item) => TicketModel.fromJson(item))
          .toList(),
      currentPage: pagination['current_page'] is int
          ? pagination['current_page']
          : int.tryParse(pagination['current_page']?.toString() ?? '1') ?? 1,
      perPage: pagination['per_page'] is int
          ? pagination['per_page']
          : int.tryParse(pagination['per_page']?.toString() ?? '15') ?? 15,
      lastPage: pagination['last_page'] is int
          ? pagination['last_page']
          : int.tryParse(pagination['last_page']?.toString() ?? '1') ?? 1,
      hasMore: pagination['has_more'] == true,
    );
  }

  TicketListResultEntity toEntity() {
    return TicketListResultEntity(
      summary: TicketListSummaryEntity(
        total: total,
        openCount: openCount,
        resolvedCount: resolvedCount,
      ),
      tickets: data.map((t) => t.toEntity()).toList(),
      currentPage: currentPage,
      totalPages: lastPage,
      hasMore: hasMore,
    );
  }
}
