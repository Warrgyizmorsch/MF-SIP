import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import '../../domain/entities/ticket_category_entity.dart';
import '../../domain/entities/ticket_detail_entity.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/repositories/ticket_repo.dart';
import '../datasource/ticket_remote_ds.dart';

class TicketRepoImpl implements TicketRepo {
  final TicketRemoteDs remoteDs;

  TicketRepoImpl(this.remoteDs);

  @override
  Future<Either<Result<List<TicketCategoryEntity>>, ApiError>> getCategories() async {
    final result = await remoteDs.getCategories();
    return result.fold(
      (success) {
        final list = success.data?.map((m) => m.toEntity()).toList() ?? [];
        return Left(Result.success(list));
      },
      (error) => Right(error),
    );
  }

  @override
  Future<Either<Result<TicketListResultEntity>, ApiError>> getTickets({
    String status = 'ALL',
    int page = 1,
    int perPage = 15,
  }) async {
    final result = await remoteDs.getTickets(
      status: status,
      page: page,
      perPage: perPage,
    );
    return result.fold(
      (success) {
        if (success.data != null) {
          return Left(Result.success(success.data!.toEntity()));
        }
        return Right(ApiError(message: 'No ticket data returned'));
      },
      (error) => Right(error),
    );
  }

  @override
  Future<Either<Result<TicketEntity>, ApiError>> createTicket({
    required int categoryId,
    required String subject,
    required String description,
    String priority = 'MEDIUM',
    List<File>? attachments,
  }) async {
    final result = await remoteDs.createTicket(
      categoryId: categoryId,
      subject: subject,
      description: description,
      priority: priority,
      attachments: attachments,
    );
    return result.fold(
      (success) {
        if (success.data != null) {
          return Left(Result.success(success.data!.toEntity()));
        }
        return Right(ApiError(message: 'Failed to create ticket'));
      },
      (error) => Right(error),
    );
  }

  @override
  Future<Either<Result<TicketDetailEntity>, ApiError>> getTicketDetail(int ticketId) async {
    final result = await remoteDs.getTicketDetail(ticketId);
    return result.fold(
      (success) {
        if (success.data != null) {
          return Left(Result.success(success.data!.toEntity()));
        }
        return Right(ApiError(message: 'Ticket details not found'));
      },
      (error) => Right(error),
    );
  }

  @override
  Future<Either<Result<TicketMessageEntity>, ApiError>> replyTicket({
    required int ticketId,
    required String message,
    List<File>? attachments,
  }) async {
    final result = await remoteDs.replyTicket(
      ticketId: ticketId,
      message: message,
      attachments: attachments,
    );
    return result.fold(
      (success) {
        if (success.data != null) {
          return Left(Result.success(success.data!.toEntity()));
        }
        return Right(ApiError(message: 'Failed to send reply'));
      },
      (error) => Right(error),
    );
  }

  @override
  Future<Either<Result<bool>, ApiError>> closeTicket(int ticketId, {String? reason}) async {
    final result = await remoteDs.closeTicket(ticketId, reason: reason);
    return result.fold(
      (success) => Left(Result.success(success.data ?? true)),
      (error) => Right(error),
    );
  }

  @override
  Future<Either<Result<bool>, ApiError>> reopenTicket(int ticketId, {String? reason}) async {
    final result = await remoteDs.reopenTicket(ticketId, reason: reason);
    return result.fold(
      (success) => Left(Result.success(success.data ?? true)),
      (error) => Right(error),
    );
  }
}
