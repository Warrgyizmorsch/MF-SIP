import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../controllers/home_controller.dart';


class NotificationPage extends GetView<HomeController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
    ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      appBar: isDesktop
          ? null
          : CustomAppBarNormal(
        actionsPadding: 15,
        title: 'Notification',
        action: [
          GestureDetector(
            onTap: controller.markAllRead,
            child: Text(
              'Mark all read',
              style:
              UTextStyles.medium.copyWith(color: Ucolors.blue),
            ),
          ),
        ],
      ),

      body: Obx(() {
        final list = controller.notifications;

        return Column(
          children: [
            // 🔵 Header
            Container(
              height: 40,
              width: double.infinity,
              color: const Color(0xffCBE5FD),
              child: Center(
                child: Text(
                  '${list.where((e) => !e.isRead).length} new notifications',
                  style: UTextStyles.medium.copyWith(
                    color: const Color(0xff07315C),
                  ),
                ),
              ),
            ),

            // 🔔 List
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text("No notifications"))
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final n = list[index];

                  return NotificationMessage(
                    isRead: n.isRead,
                    title: n.title,
                    body: n.body,
                    time: n.time,
                    onTap: () {
                      controller.markSingleRead(n.id);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
class NotificationMessage extends StatelessWidget {
  final bool isRead;
  final String title;
  final String body;
  final DateTime time;
  final VoidCallback? onTap;

  const NotificationMessage({
    super.key,
    required this.isRead,
    required this.title,
    required this.body,
    required this.time,
    this.onTap,
  });

  String formatTime(DateTime time) {
    final now = DateTime.now();

    if (now.difference(time).inDays == 0) {
      return "Today ${time.hour}:${time.minute.toString().padLeft(2, '0')}";
    } else if (now.difference(time).inDays == 1) {
      return "Yesterday";
    } else {
      return "${time.day}/${time.month}/${time.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,

      tileColor:
      isRead ? const Color(0xffE8F4FF) : Colors.grey.shade100,

      leading: CircleAvatar(
        backgroundColor:
        isRead ? const Color(0xffCBE5FD) : Colors.grey.shade300,
        child: Icon(
          Iconsax.card_edit,
          color: isRead ? Ucolors.blue : Colors.grey.shade400,
        ),
      ),

      title: Text(
        title,
        style: UTextStyles.medium.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: UTextStyles.small,
          ),
          const Gap(3),
          Text(
            formatTime(time),
            style: UTextStyles.small.copyWith(color: Colors.grey),
          ),
        ],
      ),

      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
    );
  }
}
