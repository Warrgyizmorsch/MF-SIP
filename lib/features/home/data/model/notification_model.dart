import 'dart:convert';

import '../../domain/entity/notification_entity.dart';

class AppNotificationModel {
  final _NotificationResultModel? result;

  const AppNotificationModel({this.result});

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final resultMap = json['result'] as Map<String, dynamic>?;

    return AppNotificationModel(
      result: resultMap != null
          ? _NotificationResultModel.fromJson(resultMap)
          : null,
    );
  }

  //  ADD THIS
  Map<String, dynamic> toJson() {
    return {
      "result": result?.toJson(),
    };
  }

  AppNotificationEntity toEntity() {
    return AppNotificationEntity(
      id: result?.id ?? "",
      title: result?.title ?? "",
      body: result?.body ?? "",
      time: result?.time ?? DateTime.now(),
      isRead: result?.isRead ?? false,
    );
  }

  // ADD THIS (Entity → Model)
  factory AppNotificationModel.fromEntity(AppNotificationEntity entity) {
    return AppNotificationModel(
      result: _NotificationResultModel(
        id: entity.id,
        title: entity.title,
        body: entity.body,
        time: entity.time,
        isRead: entity.isRead,
      ),
    );
  }

  // Encode list
  static String encode(List<AppNotificationModel> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }

  // Decode list
  static List<AppNotificationModel> decode(String data) {
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => AppNotificationModel.fromJson(e)).toList();
  }
}
class _NotificationResultModel {
  final String? id;
  final String? title;
  final String? body;
  final DateTime? time;
  final bool? isRead;

  const _NotificationResultModel({
    this.id,
    this.title,
    this.body,
    this.time,
    this.isRead,
  });

  factory _NotificationResultModel.fromJson(Map<String, dynamic> json) {
    return _NotificationResultModel(
      id: json['id']?.toString(),
      title: json['title'],
      body: json['body'],
      time: json['time'] != null
          ? DateTime.tryParse(json['time'])
          : null,
      isRead: json['isRead'] ?? false,
    );
  }

  // ADD THIS
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "time": time?.toIso8601String(),
      "isRead": isRead,
    };
  }
}
