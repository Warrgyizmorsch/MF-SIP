import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_section_header.dart';

class HomeVideos extends StatelessWidget {
  const HomeVideos({super.key, required this.scale});

  final double scale;

  // Retain the existing Home video destinations with the exported artwork.
  static const _videos = [
    (
      image: UImages.homeSipVideo,
      label: 'SIP investing video',
      url: 'https://youtu.be/2B8b2E9JPzk?si=69cT1kC-Er_TNNCB',
    ),
    (
      image: UImages.homeTopFundsVideo,
      label: 'Top SIP funds video',
      url: 'https://youtu.be/xuVUGgB3kGE?si=0Kje6W2zqSxEtUuu',
    ),
  ];

  Future<void> _play(BuildContext context, String url) async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } on Exception {
      // Keep launch failures recoverable without leaving the Home screen.
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the video. Please retry.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 30 * scale),
        child: HomeSectionHeader(
          title: 'Videos & Blogs',
          action: 'See all',
          onAction: () => Get.toNamed(AppRoutes.videoList),
          scale: scale,
        ),
      ),
      SizedBox(height: 4 * scale),
      SizedBox(
        height: 140 * scale,
        child: ListView.separated(
          key: const PageStorageKey('home-learning-videos'),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 30 * scale),
          itemCount: _videos.length,
          separatorBuilder: (_, _) => SizedBox(width: 10 * scale),
          itemBuilder: (context, index) {
            final video = _videos[index];
            return Semantics(
              button: true,
              label: 'Play ${video.label}',
              excludeSemantics: true,
              onTap: () => _play(context, video.url),
              child: SizedBox(
                width: 250 * scale,
                child: Material(
                  color: Ucolors.homeVideoBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8 * scale),
                    side: const BorderSide(
                      color: Ucolors.homeVideoBorder,
                      width: 0.5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Ink.image(
                    image: AssetImage(video.image),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () => _play(context, video.url),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const ColoredBox(color: Ucolors.homeVideoOverlay),
                          Center(
                            child: SvgPicture.asset(
                              UImages.homeYoutubePlay,
                              width: 32 * scale,
                              height: 23 * scale,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
