import 'package:equatable/equatable.dart';
import 'ticket_category_entity.dart';

class TicketLatestMessageEntity extends Equatable {
  final String message;
  final String senderType;
  final String createdAt;

  const TicketLatestMessageEntity({
    required this.message,
    required this.senderType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [message, senderType, createdAt];
}

class TicketEntity extends Equatable {
  final int id;
  final String ticketNumber;
  final String subject;
  final String priority;
  final String status;
  final TicketCategoryEntity? category;
  final String? relatedType;
  final String? relatedId;
  final int unreadMessages;
  final TicketLatestMessageEntity? latestMessage;
  final String createdAt;
  final String updatedAt;

  const TicketEntity({
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
        unreadMessages,
        latestMessage,
        createdAt,
        updatedAt,
      ];
}

class TicketListSummaryEntity extends Equatable {
  final int total;
  final int openCount;
  final int resolvedCount;

  const TicketListSummaryEntity({
    required this.total,
    required this.openCount,
    required this.resolvedCount,
  });

  @override
  List<Object?> get props => [total, openCount, resolvedCount];
}

class TicketListResultEntity extends Equatable {
  final TicketListSummaryEntity summary;
  final List<TicketEntity> tickets;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const TicketListResultEntity({
    required this.summary,
    required this.tickets,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [summary, tickets, currentPage, totalPages, hasMore];
}
