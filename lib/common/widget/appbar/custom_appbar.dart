import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/presentation/controllers/auth/auth_controller.dart';
import 'package:my_sip/services/session_manager.dart';

class CustomProfileAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  CustomProfileAppbar({
    super.key,
    required this.greetingName,
    this.action,
    required this.role,
    this.avatar,
    this.onProfiletap,
    this.backgroundColor,
    this.roleColor,
    this.greetingNameColor,
    this.iconColor,
    this.actionsPadding,
    this.actionIconcolor,
  });

  final String greetingName;
  final List<Widget>? action;
  final String role;
  final ImageProvider? avatar;
  final VoidCallback? onProfiletap;
  final Color? backgroundColor;
  final Color? roleColor;
  final Color? greetingNameColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? actionsPadding;
  final Color? actionIconcolor;
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = SessionManager.instance.getUserData;
    return AppBar(
      actionsPadding: actionsPadding,

      automaticallyImplyLeading: false,
      backgroundColor: kIsWeb ? Colors.transparent :backgroundColor,

      // elevation: 10,
      actions: action,

      //Profile Details
      title: kIsWeb ? SizedBox.shrink() : Row(
        children: [
          InkWell(
            onTap: onProfiletap,

            //avatar
            child: CircleAvatar(
              // backgroundColor: Colors.pink,
              backgroundImage: avatar ?? AssetImage(UImages.imp),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Greeting
              Text(
                UHelperFunction.getGreetingMsg(),

                textAlign: TextAlign.start,
                style: UTextStyles.subtitle1.copyWith(
                  color: roleColor ?? Ucolors.dark,
                  fontSize: 10,
                ),
              ),
              Row(
                children: [
                  //Name
                  Text(
                    // greetingName,
                    user?.name ?? '',
                    style: UTextStyles.heading1.copyWith(
                      fontSize: 14,
                      color: greetingNameColor,
                    ),
                  ),
                  const SizedBox(width: 5),

                  Icon(Icons.keyboard_arrow_down_sharp, color: iconColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
