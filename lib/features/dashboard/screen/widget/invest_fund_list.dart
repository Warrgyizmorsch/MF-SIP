import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class InvestFundList extends StatelessWidget {
  const InvestFundList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      isThreeLine: false,
      minTileHeight: 0,
      leading: CircleAvatar(
        maxRadius: (Get.width * 0.06).clamp(15, 20),
        backgroundImage: AssetImage(UImages.sbi),
        // maxRadius: 20,
      ),
      title: Text(
        'SBI Banking & Financial Services..',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: UTextStyles.subtitle2.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w400,
          // fontSize: 14,
          fontSize: (Get.width * 0.035).clamp(12, 14),
        ),
      ),
      subtitle: Text(
        textAlign: TextAlign.start,
        'Sector - Financial Services',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: UTextStyles.caption.copyWith(
          fontWeight: FontWeight.w400,
          color: Color(0xff828282),
          // fontSize: (Get.width * 0.026).clamp(8, 10),
          fontSize: (Get.width * 0.03).clamp(8, 12),
        ),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          Text(
            '₹38.84K',
            style: UTextStyles.subtitle2.copyWith(
              color: Ucolors.dark,
              fontWeight: FontWeight.w500,
              fontSize: (Get.width * 0.035).clamp(12, 14),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Icon(
                Icons.arrow_drop_up,
                color: Ucolors.success,
                size: (Get.width * 0.04).clamp(8, 10),
              ),
              Text(
                '+31.06%',
                style: UTextStyles.caption.copyWith(
                  color: Ucolors.success,
                  fontSize: (Get.width * 0.026).clamp(8, 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
