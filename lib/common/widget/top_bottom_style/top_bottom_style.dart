import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/utils/constant/images.dart';

class TopBottomDecoration extends StatelessWidget {
  const TopBottomDecoration({
    super.key,
    required this.child,
    this.design = false,
  });

  final Widget child;

  final bool design;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-right decoration
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: Offset(20, -20),
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                UImages.topright,

                // width: Get.width * (271 / 430),
                // height: Get.height * (270 / 932),
              ),
            ),
          ),
        ),

        if (design) ...[
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(10, -10),
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  UImages.topRight1,
                  width: Get.width * (197 / 430),
                  height: Get.height * (192 / 932),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: const Offset(10, -10),
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  UImages.topRight2,
                  width: Get.width * (265 / 430),
                  height: Get.height * (140 / 932),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(-Get.width * 0.33, Get.height * 0.07),
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  UImages.topRight3,
                  width: Get.width * (33 / 430),
                  height: Get.height * (30 / 932),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: Offset(-Get.width * 0.15, Get.height * 0.14),
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  UImages.topRight4,
                  width: Get.width * (14 / 430),
                  height: Get.height * (14 / 932),
                ),
              ),
            ),
          ),
        ],

        // Bottom-left decoration – fixed
        Positioned(
          left: -10,
          bottom: -5,
          child: Opacity(opacity: 0.5, child: Image.asset(UImages.buttomleft)),
        ),

        child,
      ],
    );
  }
}
