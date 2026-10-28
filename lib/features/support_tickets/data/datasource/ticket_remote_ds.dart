import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import 'package:my_sip/core/utils/api/api_error.dart';
import 'package:my_sip/core/utils/api/api_result.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import '../models/ticket_category_model.dart';
import '../models/ticket_detail_model.dart';
import '../models/ticket_model.dart';

class TicketRemoteDs {
  final NetworkServicesApi _servicesApi;

  TicketRemoteDs(this._servicesApi);

  /// 1. Get Categories
  Future<Either<Result<List<TicketCategoryModel>>, ApiError>> getCategories() async {
    try {
      final resp = await _servicesApi.getApi(
        "${Appurl.baseUrl}/api/v1/tickets/categories",
      );

      createLog("[TicketRemoteDs] getCategories response: $resp");

      if (resp != null && resp['success'] == true) {
        final list = (resp['data'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((c) => TicketCategoryModel.fromJson(c))
            .toList();
        return Left(Result.success(list));
      } else {
        return Right(ApiError(message: resp?['message']?.toString() ?? 'Failed to load categories'));
      }
    } catch (e) {
      createLog("[TicketRemoteDs] getCategories error: $e");
      return Right(ApiError(message: 'Error fetching ticket categories: $e'));
    }
  }

  /// 2. Get User's Tickets
  Future<Either<Result<TicketListResponseModel>, ApiError>> getTickets({
    String status = 'ALL',
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'status': status,
        'page': page,
        'per_page': perPage,
      };

      final resp = await _servicesApi.getApi(
        "${Appurl.baseUrl}/api/v1/tickets",
        queryParameters: queryParams,
      );

      createLog("[TicketRemoteDs] getTickets response: $resp");

      if (resp != null && resp['success'] == true) {
        final model = TicketListResponseModel.fromJson(resp);
        return Left(Result.success(model));
      } else {
        return Right(ApiError(message: resp?['message']?.toString() ?? 'Failed to load tickets'));
      }
    } catch (e) {
      createLog("[TicketRemoteDs] getTickets error: $e");
      return Right(ApiError(message: 'Error fetching tickets: $e'));
    }
  }

  /// 3. Raise a New Support Ticket
  Future<Either<Result<TicketModel>, ApiError>> createTicket({
    required String subject,
    required String description,
    int? categoryId,
    String priority = 'MEDIUM',
    String? relatedType,
    String? relatedId,
    List<File>? attachments,
  }) async {
    try {
      final formDataMap = <String, dynamic>{
        'subject': subject,
        'description': description,
        'priority': priority,
      };

      if (categoryId != null && categoryId > 0) {
        formDataMap['category_id'] = categoryId;
      }
      if (relatedType != null && relatedType.isNotEmpty) {
        formDataMap['related_type'] = relatedType;
      }
      if (relatedId != null && relatedId.isNotEmpty) {
        formDataMap['related_id'] = relatedId;
      }

      final formData = FormData.fromMap(formDataMap);

      if (attachments != null && attachments.isNotEmpty) {
        for (final file in attachments) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          formData.files.add(
            MapEntry(
              'attachments[]',
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
      }

      final response = await _servicesApi.dio.post(
        "${Appurl.baseUrl}/api/v1/tickets",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      createLog("[TicketRemoteDs] createTicket status: ${response.statusCode}, response: ${response.data}");

      final data = response.data;
      if (response.statusCode == 201 || (data != null && data['success'] == true)) {
        final model = TicketModel.fromJson(data['data'] as Map<String, dynamic>);
        return Left(Result.success(model));
      } else {
        return Right(ApiError(message: data?['message']?.toString() ?? 'Failed to create ticket'));
      }
    } on DioException catch (e) {
      createLog("[TicketRemoteDs] createTicket DioException: ${e.response?.data}");
      final msg = e.response?.data?['message'] ?? e.message ?? 'Network error occurred';
      return Right(ApiError(message: msg.toString()));
    } catch (e) {
      createLog("[TicketRemoteDs] createTicket error: $e");
      return Right(ApiError(message: 'Exception creating ticket: $e'));
    }
  }

  /// 4. Get Ticket Detail & Message Timeline
  Future<Either<Result<TicketDetailModel>, ApiError>> getTicketDetail(dynamic id) async {
    try {
      final resp = await _servicesApi.getApi(
        "${Appurl.baseUrl}/api/v1/tickets/$id",
      );

      createLog("[TicketRemoteDs] getTicketDetail response: $resp");

      if (resp != null && resp['success'] == true && resp['data'] != null) {
        final model = TicketDetailModel.fromJson(resp['data'] as Map<String, dynamic>);
        return Left(Result.success(model));
      } else {
        return Right(ApiError(message: resp?['message']?.toString() ?? 'Failed to load ticket details'));
      }
    } catch (e) {
      createLog("[TicketRemoteDs] getTicketDetail error: $e");
      return Right(ApiError(message: 'Error fetching ticket details: $e'));
    }
  }

  /// 5. Reply to Ticket
  Future<Either<Result<TicketMessageModel>, ApiError>> replyTicket({
    required dynamic ticketId,
    required String message,
    List<File>? attachments,
  }) async {
    try {
      final formData = FormData.fromMap({
        'message': message,
      });

      if (attachments != null && attachments.isNotEmpty) {
        for (final file in attachments) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          formData.files.add(
            MapEntry(
              'attachments[]',
              await MultipartFile.fromFile(file.path, filename: fileName),
            ),
          );
        }
      }

      final response = await _servicesApi.dio.post(
        "${Appurl.baseUrl}/api/v1/tickets/$ticketId/reply",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      createLog("[TicketRemoteDs] replyTicket response: ${response.data}");

      final data = response.data;
      if (response.statusCode == 200 || (data != null && data['success'] == true)) {
        final model = TicketMessageModel.fromJson(data['data'] as Map<String, dynamic>);
        return Left(Result.success(model));
      } else {
        return Right(ApiError(message: data?['message']?.toString() ?? 'Failed to send reply'));
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? e.message ?? 'Network error occurred';
      return Right(ApiError(message: msg.toString()));
    } catch (e) {
      return Right(ApiError(message: 'Exception sending reply: $e'));
    }
  }

  /// 6. Close Ticket
  Future<Either<Result<bool>, ApiError>> closeTicket(dynamic ticketId, {String? reason}) async {
    try {
      final resp = await _servicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/tickets/$ticketId/close",
        data: reason != null ? {'reason': reason} : <String, dynamic>{},
      );

      createLog("[TicketRemoteDs] closeTicket response: $resp");

      if (resp != null && resp['success'] == true) {
        return Left(Result.success(true));
      } else {
        return Right(ApiError(message: resp?['message']?.toString() ?? 'Failed to close ticket'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Exception closing ticket: $e'));
    }
  }

  /// 7. Reopen Ticket
  Future<Either<Result<bool>, ApiError>> reopenTicket(dynamic ticketId, {String? reason}) async {
    try {
      final resp = await _servicesApi.postApi(
        "${Appurl.baseUrl}/api/v1/tickets/$ticketId/reopen",
        data: reason != null ? {'reason': reason} : <String, dynamic>{},
      );

      createLog("[TicketRemoteDs] reopenTicket response: $resp");

      if (resp != null && resp['success'] == true) {
        return Left(Result.success(true));
      } else {
        return Right(ApiError(message: resp?['message']?.toString() ?? 'Failed to reopen ticket'));
      }
    } catch (e) {
      return Right(ApiError(message: 'Exception reopening ticket: $e'));
    }
  }
}
