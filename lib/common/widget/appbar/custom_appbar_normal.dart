import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/widget/compact_icon.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class CustomAppBarNormal extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarNormal({
    super.key,
    required this.title,
    this.action,
    this.backgroundColor,
    this.backIcon = true,
    this.actionsPadding,
    this.bottom,
    this.onpressed,
  });

  final String title;
  final List<Widget>? action;
  final Color? backgroundColor;
  final bool backIcon;
  final VoidCallback? onpressed;
  // final
  final double? actionsPadding;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      backgroundColor: backgroundColor ?? Colors.grey.shade50,
      actionsPadding: EdgeInsets.only(right: actionsPadding ?? 0),

      leading: backIcon
          ? InkWell(
              // onTap: () => Navigator.maybePop(context),
              onTap: onpressed ?? () => Navigator.maybePop(context),

              child: Container(
                height: 20,
                width: 20,
                padding: EdgeInsets.only(left: 6),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xffEDEDED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.arrow_back_ios),
                  //  CompactIcon(
                  //   iconSize: 18,
                  //   icon: Icons.arrow_back_ios,
                  //   // onPressed: () => Get.back(),
                  //   // onPressed: () => Navigator.maybePop(context),
                  //   onPressed: onpressed ?? () => Navigator.maybePop(context),
                  // ),
                ),
              ),
            )
          : SizedBox.shrink(),
      title: Text(
        title,
        style: UTextStyles.subtitle1.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      centerTitle: true,
      actions: action,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class WebCustomAppBarNormal extends StatelessWidget
    implements PreferredSizeWidget {
  const WebCustomAppBarNormal({
    super.key,
    required this.title,
    this.action,
    this.backgroundColor,
    this.backIcon = true,
    this.actionsPadding,
    this.bottom,
  });

  final String title;
  final List<Widget>? action;
  final Color? backgroundColor;
  final bool backIcon;
  final double? actionsPadding;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100, // AppBar Height
      bottom: bottom,
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.grey.shade50,

      actionsPadding: EdgeInsets.only(right: actionsPadding ?? 0),

      automaticallyImplyLeading: false,

      leading: backIcon
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.maybePop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CompactIcon(
                        iconSize: 18,
                        icon: Icons.arrow_back_ios,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,

      leadingWidth: 70,

      // LEFT TITLE
      titleSpacing: 20,
      centerTitle: false,

      title: Text(
        title,
        style: UTextStyles.subtitle1.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),

      actions: action,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
