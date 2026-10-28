import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import '../entities/ticket_category_entity.dart';
import '../entities/ticket_detail_entity.dart';
import '../entities/ticket_entity.dart';

abstract class TicketRepo {
  Future<Either<Result<List<TicketCategoryEntity>>, ApiError>> getCategories();

  Future<Either<Result<TicketListResultEntity>, ApiError>> getTickets({
    String status = 'ALL',
    int page = 1,
    int perPage = 15,
  });

  Future<Either<Result<TicketEntity>, ApiError>> createTicket({
    required int categoryId,
    required String subject,
    required String description,
    String priority = 'MEDIUM',
    List<File>? attachments,
  });

  Future<Either<Result<TicketDetailEntity>, ApiError>> getTicketDetail(int ticketId);

  Future<Either<Result<TicketMessageEntity>, ApiError>> replyTicket({
    required int ticketId,
    required String message,
    List<File>? attachments,
  });

  Future<Either<Result<bool>, ApiError>> closeTicket(int ticketId, {String? reason});

  Future<Either<Result<bool>, ApiError>> reopenTicket(int ticketId, {String? reason});
}
