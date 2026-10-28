import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import '../entities/ticket_category_entity.dart';
import '../entities/ticket_detail_entity.dart';
import '../entities/ticket_entity.dart';
import '../repositories/ticket_repo.dart';

class GetTicketCategoriesUseCase {
  final TicketRepo repo;
  GetTicketCategoriesUseCase(this.repo);

  Future<Either<Result<List<TicketCategoryEntity>>, ApiError>> call() {
    return repo.getCategories();
  }
}

class GetTicketsUseCase {
  final TicketRepo repo;
  GetTicketsUseCase(this.repo);

  Future<Either<Result<TicketListResultEntity>, ApiError>> call({
    String status = 'ALL',
    int page = 1,
    int perPage = 15,
  }) {
    return repo.getTickets(status: status, page: page, perPage: perPage);
  }
}

class CreateTicketUseCase {
  final TicketRepo repo;
  CreateTicketUseCase(this.repo);

  Future<Either<Result<TicketEntity>, ApiError>> call({
    required int categoryId,
    required String subject,
    required String description,
    String priority = 'MEDIUM',
    List<File>? attachments,
  }) {
    return repo.createTicket(
      categoryId: categoryId,
      subject: subject,
      description: description,
      priority: priority,
      attachments: attachments,
    );
  }
}

class GetTicketDetailUseCase {
  final TicketRepo repo;
  GetTicketDetailUseCase(this.repo);

  Future<Either<Result<TicketDetailEntity>, ApiError>> call(int ticketId) {
    return repo.getTicketDetail(ticketId);
  }
}

class ReplyTicketUseCase {
  final TicketRepo repo;
  ReplyTicketUseCase(this.repo);

  Future<Either<Result<TicketMessageEntity>, ApiError>> call({
    required int ticketId,
    required String message,
    List<File>? attachments,
  }) {
    return repo.replyTicket(
      ticketId: ticketId,
      message: message,
      attachments: attachments,
    );
  }
}

class CloseTicketUseCase {
  final TicketRepo repo;
  CloseTicketUseCase(this.repo);

  Future<Either<Result<bool>, ApiError>> call(int ticketId, {String? reason}) {
    return repo.closeTicket(ticketId, reason: reason);
  }
}

class ReopenTicketUseCase {
  final TicketRepo repo;
  ReopenTicketUseCase(this.repo);

  Future<Either<Result<bool>, ApiError>> call(int ticketId, {String? reason}) {
    return repo.reopenTicket(ticketId, reason: reason);
  }
}
