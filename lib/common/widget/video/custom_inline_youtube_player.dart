import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'
    hide YoutubePlayerController, YoutubePlayer;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart'; // UPDATED PACKAGE

class InlineYouTubePlayer extends StatefulWidget {
  final String thumbnailUrl;
  final String videoId;

  const InlineYouTubePlayer({
    super.key,
    required this.thumbnailUrl,
    required this.videoId,
  });

  @override
  State<InlineYouTubePlayer> createState() => _InlineYouTubePlayerState();
}

class _InlineYouTubePlayerState extends State<InlineYouTubePlayer> {
  bool _isPlaying = false;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller from youtube_player_iframe
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true, // Auto-play once the user clicks the thumbnail
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true, // Enables native fullscreen
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlaying) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
        ),
      );
    }

    return InkWell(
      onTap: () {
        setState(() {
          _isPlaying = true;
        });
        // Ensure playback starts
        _controller.playVideo();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CustomCachedImage(
                size: 400,

                imageUrl: widget.thumbnailUrl,

                // Remove fixed size to let AspectRatio handle it
                // size: double.infinity,
              ),
            ),
          ),

          // Play Button Overlay
          SvgPicture.asset('assets/logo/ic_play_youtube.svg', height: 50),
        ],
      ),
    );
  }
}
