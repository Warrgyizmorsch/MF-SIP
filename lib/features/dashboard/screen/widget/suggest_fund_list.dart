import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

class SuggestFundList extends StatelessWidget {
  const SuggestFundList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      isThreeLine: false,

      minTileHeight: 0,
      leading: CircleAvatar(
        maxRadius: (Get.width * 0.06).clamp(15, 20),

        backgroundImage: AssetImage(UImages.motilal),
      ),
      title: Text(
        'Motilal Oswal Midcap Fund',
        maxLines: 1,
        // overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.start,
        // style: UTextStyles.subtitle2.copyWith(color: Ucolors.dark),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: UTextStyles.subtitle2.copyWith(
          color: Ucolors.dark,
          fontWeight: FontWeight.w400,
          // fontSize: 14,
          fontSize: (Get.width * 0.035).clamp(12, 14),
        ),
      ),
      subtitle: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              textAlign: TextAlign.start,
              'Commodities Gold - 5',
              maxLines: 1,
              style: UTextStyles.caption.copyWith(
                fontWeight: FontWeight.w400,
                color: Color(0xff828282),
                // fontSize: (Get.width * 0.026).clamp(8, 10),
                fontSize: (Get.width * 0.03).clamp(8, 12),
              ),
            ),
            SizedBox(width: 2),
            Icon(Icons.star_rate_rounded, size: 10),
            SizedBox(width: 2),

            Icon(Icons.arrow_drop_up, color: Ucolors.success, size: 16),

            Text(
              '+31.06%',
              style: UTextStyles.caption.copyWith(
                color: Ucolors.success,
                fontSize: (Get.width * 0.026).clamp(8, 10),
              ),
            ),
            SizedBox(width: 2),

            Text(
              '3Y',
              style: UTextStyles.caption.copyWith(
                color: Ucolors.darkgrey,
                fontSize: (Get.width * 0.026).clamp(8, 10),
              ),
            ),
          ],
        ),
      ),
      trailing: InkWell(
        onTap: () {},
        child: Container(
          width: Get.width * 0.15,
          // height: 40,
          height: Get.height * 0.05,
          decoration: BoxDecoration(
            // color: Ucolors.success,
            gradient: Ucolors.backgroundGradient,

            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(Icons.shopping_cart, color: Ucolors.light),
          // Center(
          //   child: FittedBox(
          //     child: Text(
          //       'Add to cart',
          //       textAlign: TextAlign.center,
          //       overflow: TextOverflow.ellipsis,
          //       style: UTextStyles.buttonText.copyWith(fontSize: 8),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
