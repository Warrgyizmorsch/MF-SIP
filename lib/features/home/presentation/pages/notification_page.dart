import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isRead = false;
    return Scaffold(
      appBar: CustomAppBarNormal(
        actionsPadding: 15,
        title: 'Notification',
        action: [
          Text(
            'Mark all read',
            style: UTextStyles.medium.copyWith(color: Ucolors.blue),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Upper Section
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xffCBE5FD)),
              child: Center(
                child: Text(
                  '4 new notifications',
                  style: UTextStyles.medium.copyWith(color: Color(0xff07315C)),
                ),
              ),
            ),

            ...List.generate(3, (index) => NotificationMessage(isRead: true)),
            ...List.generate(5, (index) => NotificationMessage(isRead: false)),
          ],
        ),
      ),
    );
  }
}

class NotificationMessage extends StatelessWidget {
  const NotificationMessage({super.key, required this.isRead});

  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isRead ? Color(0xffE8F4FF) : Colors.grey.shade100,
      leading: CircleAvatar(
        backgroundColor: isRead ? Color(0xffCBE5FD) : Colors.grey.shade300,
        child: Icon(
          Iconsax.card_edit,
          color: isRead ? Ucolors.blue : Colors.grey.shade200,
        ),
      ),
      title: Text(
        'Lorem Ipsum is simply dummy text',
        style: UTextStyles.medium.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: UTextStyles.small,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            // softWrap: true,
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s,',
          ),
          Gap(3),
          Text('Today 09:31 AM'),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_sharp,
        color: Ucolors.darkgrey,
        size: 15,
      ),
    );
  }
}
