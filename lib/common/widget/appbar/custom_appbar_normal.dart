import 'package:flutter/material.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class CustomAppBarNormal extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarNormal({
    super.key,
    required this.title,
    this.action,
    this.backgroundColor,
    this.backIcon = true,
    this.actionsPadding,
  });

  final String title;
  final List<Widget>? action;
  final Color? backgroundColor;
  final bool backIcon;
  // final
  final double? actionsPadding;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.grey.shade50,
      // automaticallyImplyLeading: true,
      actionsPadding: EdgeInsets.only(right: actionsPadding ?? 0),

      // leadingWidth: ,
      leading: backIcon
          ? Container(
              height: 20,
              width: 20,
              padding: EdgeInsets.only(left: 6),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xffEDEDED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(Icons.arrow_back_ios, size: 18)),
            )
          : SizedBox.shrink(),
      title: Text(
        title,
        style: UTextStyles.subtitle1.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      centerTitle: true,
      actions: action,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
