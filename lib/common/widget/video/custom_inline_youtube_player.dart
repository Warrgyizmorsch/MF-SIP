import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';

// 1. Alias the imports to avoid conflict
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as mobile;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as web;

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

  // 2. Define nullable controllers for both platforms
  mobile.YoutubePlayerController? _mobileController;
  web.YoutubePlayerController? _webController;

  @override
  void initState() {
    super.initState();
    // We initialize the specific controller only when the user clicks play
    // or we can pre-initialize if needed. Here we do it on "Play" for performance.
  }

  void _initializePlayer() {
    if (kIsWeb) {
      // --- WEB INITIALIZATION ---
      _webController = web.YoutubePlayerController.fromVideoId(
        videoId: widget.videoId,
        autoPlay: true,
        params: const web.YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
          strictRelatedVideos: true,
        ),
      );
    } else {
      // --- MOBILE INITIALIZATION ---
      _mobileController = mobile.YoutubePlayerController(
        initialVideoId: widget.videoId,
        flags: const mobile.YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: true,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    // 3. Dispose the correct controller
    if (kIsWeb) {
      _webController?.close();
    } else {
      _mobileController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlaying) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: kIsWeb
              ? _buildWebPlayer()
              : _buildMobilePlayer(),
        ),
      );
    }

    return InkWell(
      onTap: () {
        // Initialize logic before rebuilding
        _initializePlayer();
        setState(() {
          _isPlaying = true;
        });
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
                imageUrl: widget.thumbnailUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Play Button Overlay
          SvgPicture.asset(
            'assets/logo/ic_play_youtube.svg',
            height: 50,
          ),
        ],
      ),
    );
  }

  // --- WEB PLAYER WIDGET ---
  Widget _buildWebPlayer() {
    return web.YoutubePlayer(
      controller: _webController!,
      aspectRatio: 16 / 9,
    );
  }

  // --- MOBILE PLAYER WIDGET ---
  Widget _buildMobilePlayer() {
    return mobile.YoutubePlayer(
      controller: _mobileController!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.red,
      progressColors: const mobile.ProgressBarColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
      ),
      onReady: () {
        // Optional: Do something when player is ready
      },
    );
  }
}