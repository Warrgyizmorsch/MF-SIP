import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as mobile;
import 'package:get/get.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoId;
  const FullScreenVideoPage({super.key, required this.videoId});

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late mobile.YoutubePlayerController _controller;
  bool _isExiting = false; // Prevent multiple taps

  @override
  void initState() {
    super.initState();
    // Force the app into landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = mobile.YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const mobile.YoutubePlayerFlags(
        autoPlay: true,
        hideControls: false,
      ),
    );
  }

  // --- THE MAGIC FIX ---
  // We use this function for both the custom button AND the Android back button
  Future<void> _safeExitFullscreen() async {
    if (_isExiting) return;
    setState(() => _isExiting = true);

    // 1. Tell the system to rotate back to Portrait
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 2. WAIT for the physical rotation to finish (300ms is usually perfect)
    // This prevents HomeScreen from seeing a "Landscape" width and breaking.
    await Future.delayed(const Duration(milliseconds: 300));

    // 3. NOW it is safe to close the page
    Get.back();
  }

  @override
  void dispose() {
    // Failsafe: Ensure portrait mode is restored if the widget is destroyed
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope intercepts the physical Android back button
    return WillPopScope(
      onWillPop: () async {
        await _safeExitFullscreen();
        return false; // We return false because our function handles the pop
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: mobile.YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
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
              // Ensure our custom exit button also uses the safe exit method
              IconButton(
                icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                onPressed: _safeExitFullscreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
