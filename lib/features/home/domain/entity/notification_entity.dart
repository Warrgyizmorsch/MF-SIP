import 'package:equatable/equatable.dart';

import '../../data/model/notification_model.dart';

class AppNotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;

  const AppNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    time,
    isRead,
  ];


}
extension NotificationEntityToModel on AppNotificationEntity {
  Map<String, dynamic> toJson() {
    return {
      "result": {
        "id": id,
        "title": title,
        "body": body,
        "time": time.toIso8601String(),
        "isRead": isRead,
      }
    };
  }
}


