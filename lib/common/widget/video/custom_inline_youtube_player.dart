import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/images/custom_cached_image.dart';
import 'package:my_sip/common/widget/video/full_video_player.dart';
import 'package:url_launcher/url_launcher.dart';

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
          child: kIsWeb ? _buildWebPlayer() : _buildMobilePlayer(),
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
          SvgPicture.asset('assets/logo/ic_play_youtube.svg', height: 50),
        ],
      ),
    );
  }

  // --- WEB PLAYER WIDGET ---
  Widget _buildWebPlayer() {
    return web.YoutubePlayer(controller: _webController!, aspectRatio: 16 / 9);
  }

  // --- MOBILE PLAYER WIDGET ---
  // Widget _buildMobilePlayer() {
  //   return mobile.YoutubePlayer(
  //     controller: _mobileController!,
  //     showVideoProgressIndicator: true,
  //     progressIndicatorColor: Colors.red,
  //     progressColors: const mobile.ProgressBarColors(
  //       playedColor: Colors.red,
  //       handleColor: Colors.redAccent,
  //     ),
  //     onReady: () {
  //       // Optional: Do something when player is ready
  //     },
  //   );
  // }
  // --- MOBILE PLAYER WIDGET ---
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
      // OVERRIDE BOTTOM ACTIONS TO HIJACK THE FULLSCREEN BUTTON
      bottomActions: [
        const SizedBox(width: 14.0),
        const mobile.CurrentPosition(),
        const SizedBox(width: 8.0),
        mobile.ProgressBar(
          isExpanded: true,
          colors: const mobile.ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
        ),
        const mobile.RemainingDuration(),
        // OUR CUSTOM FULLSCREEN BUTTON
        IconButton(
          icon: const Icon(Icons.fullscreen, color: Colors.white),
          onPressed: () {
            // 1. Pause the small inline video
            _mobileController!.pause();

            // 2. Push the full screen page over everything using GetX
            Get.to(
              () => FullScreenVideoPage(videoId: widget.videoId),
              fullscreenDialog:
                  true, // This ensures it covers any sidebars/bottom bars
              transition: Transition.fadeIn,
            )?.then((_) {
              // 3. Ensure portrait mode is restored when coming back
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            });
          },
        ),
      ],
    );
  }
}




class ClickableYoutubeThumbnail extends StatelessWidget {

  final String videoUrl;
  final double width;

  const ClickableYoutubeThumbnail({
    super.key,
    required this.videoUrl,
    this.width = 300, 
  });

  String? _extractVideoId(String url) {
    final RegExp regExp = RegExp(
      r'.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*',
      caseSensitive: false,
    );
    final Match? match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 1 && match.group(1)!.length == 11) 
        ? match.group(1) 
        : null;
  }

  Future<void> _launchYoutubeVideo() async {
    final Uri url = Uri.parse(videoUrl);
    
    // LaunchMode.externalApplication forces it to try opening the YouTube app first
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? videoId = _extractVideoId(videoUrl);
    if (videoId == null) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    }
    return GestureDetector(
      onTap: _launchYoutubeVideo,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
          image: DecorationImage(
            image: NetworkImage("https://img.youtube.com/vi/$videoId/hqdefault.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6), // Dark translucent background
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),
      ),
    );
  }
}