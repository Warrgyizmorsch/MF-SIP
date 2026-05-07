import 'package:get/get.dart';
import '../../../../services/session_manager.dart';
import '../../data/model/notification_model.dart';
import '../../domain/entity/notification_entity.dart';

class HomeController extends GetxController {
  final notifications = <AppNotificationEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void addNotification(String title, String body) {
    final entity = AppNotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      time: DateTime.now(),
      isRead: false,
    );

    notifications.insert(0, entity);

    _saveToLocal();
  }

  //  Load Notifications
  Future<void> loadNotifications() async {
    final entityList = await SessionManager.loadNotifications();

    notifications.assignAll(entityList);
  }

  //  Mark All Read (IMMUTABLE FIX)
  void markAllRead() {
    final updatedList = notifications.map((e) {
      return AppNotificationEntity(
        id: e.id,
        title: e.title,
        body: e.body,
        time: e.time,
        isRead: true,
      );
    }).toList();

    notifications.assignAll(updatedList);

    _saveToLocal();
  }

  //  Save helper (Entity → Model)
  void _saveToLocal() {
    final modelList = notifications
        .map((e) => AppNotificationModel.fromEntity(e))
        .toList();

    SessionManager.saveNotifications(modelList);
  }
}