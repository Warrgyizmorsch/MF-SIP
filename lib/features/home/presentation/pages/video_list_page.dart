import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/video/custom_inline_youtube_player.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  final List<String> videoUrls = const [
    "https://youtu.be/xuVUGgB3kGE?si=0Kje6W2zqSxEtUuu",
    "https://youtu.be/2B8b2E9JPzk?si=69cT1kC-Er_TNNCB",
    "https://youtu.be/rAqzpRZa78E?si=RNS6j8GSynDrvDzm",
    "https://youtu.be/ZXLATRO3Ifw?si=BMzoLqFc-XDw8TFr",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Videos & Blogs",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: videoUrls.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: ClickableYoutubeThumbnail(
                  videoUrl: videoUrls[index],
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "Educational Finance Video ${index + 1}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Learn more about mutual funds and SIP strategies.",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          );
        },
      ),
    );
  }
}
