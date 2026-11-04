import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/shimmer/shimmer.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/personalization/presentation/controllers/personalisation_controller.dart';
import 'package:my_sip/services/session_manager.dart';

import 'home_design.dart';

class HomeKycBanner extends StatelessWidget {
  const HomeKycBanner({
    super.key,
    required this.controller,
    required this.scale,
  });

  final PersonalisationController controller;
  final double scale;

  @override
  Widget build(BuildContext context) => Obx(() {
    final session = SessionManager.instance;
    final sessionKyc = (session.getUserData?.kycStatus ?? '')
        .trim()
        .toLowerCase();
    final profileKyc = (controller.userData.value?.kycStatus ?? '')
        .trim()
        .toLowerCase();
    final verified =
        controller.isKycVerified.value ||
        session.isKycVerified.value ||
        const ['approved', 'verified'].contains(sessionKyc) ||
        const ['approved', 'verified'].contains(profileKyc);
    if (verified) return const SizedBox.shrink();
    if (controller.isProfileLoading.value) {
      return Padding(
        padding: EdgeInsets.only(top: 30 * scale),
        child: UShimmerEffect(
          width: double.infinity,
          height: 126 * scale,
          radius: 20 * scale,
        ),
      );
    }
    const statuses = ['pending', 'in progress', 'submitted', 'under review'];
    final pending =
        controller.isKycPending.value ||
        session.isKycPending.value ||
        statuses.contains(sessionKyc) ||
        statuses.contains(profileKyc);
    final title = pending
        ? 'Your KYC verification is in progress'
        : 'Be investment ready by completing your KYC';
    final action = pending ? 'View Status' : 'Start KYC';

    return Padding(
      padding: EdgeInsets.only(top: 30 * scale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            label: '$title. $action.',
            child: Material(
              color: Ucolors.white,
              borderRadius: BorderRadius.circular(20 * scale),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  if (!pending) controller.isContinuousOnboarding.value = true;
                  Get.toNamed(
                    pending ? AppRoutes.kycDeatailScreen : AppRoutes.kycScreen,
                  );
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scale =
                        constraints.maxWidth / HomeMetrics.sectionWidth;
                    final titleStyle = UTextStyles.homeText(
                      size: 14 * scale,
                      weight: FontWeight.w700,
                      color: Ucolors.homeInk,
                      height: 1.489,
                      letterSpacing: 0.3,
                    );
                    final actionStyle = titleStyle.copyWith(height: 1.289);
                    final titleHeight = HomeTextLayout.measure(
                      context,
                      title,
                      style: titleStyle,
                      maxWidth: 188 * scale,
                    ).height;
                    final actionHeight = HomeTextLayout.measure(
                      context,
                      action,
                      style: actionStyle,
                      maxWidth: 168 * scale,
                    ).height;
                    final actionTop = math.max(
                      84 * scale,
                      16 * scale + titleHeight + 20 * scale,
                    );
                    final height = math.max(
                      117 * scale,
                      actionTop + actionHeight + 14.5 * scale,
                    );
                    return SizedBox(
                      height: height,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 195 * scale,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: Ucolors.homeKycGradient,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: (height - 117 * scale) / 2,
                            width: 195 * scale,
                            height: 117 * scale,
                            child: ClipRect(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: -21.06 * scale,
                                    top: -10 * scale,
                                    width: 217.13 * scale,
                                    height: 137 * scale,
                                    child: Image.asset(
                                      UImages.homeKycClock,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 175 * scale,
                            bottom: 0,
                            width: 200 * scale,
                            height: 98 * scale,
                            child: SvgPicture.asset(
                              UImages.homeKycCurve,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            left: 153 * scale,
                            top: 16 * scale,
                            width: 188 * scale,
                            child: Text(
                              title,
                              textAlign: TextAlign.right,
                              style: titleStyle,
                            ),
                          ),
                          Positioned(
                            left: 153 * scale,
                            right: 33 * scale,
                            top: actionTop,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    action,
                                    textAlign: TextAlign.right,
                                    style: actionStyle,
                                  ),
                                ),
                                SizedBox(width: 7 * scale),
                                SvgPicture.asset(
                                  UImages.homeKycArrow,
                                  width: 14 * scale,
                                  height: 14 * scale,
                                ),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20 * scale,
                                  ),
                                  border: Border.all(
                                    color: Ucolors.white.withValues(alpha: 0.8),
                                    width: 1.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 5 * scale),
          SizedBox(
            width: double.infinity,
            height: 4 * scale,
            child: SvgPicture.asset(UImages.homeKycUnderline, fit: BoxFit.fill),
          ),
        ],
      ),
    );
  });
}
