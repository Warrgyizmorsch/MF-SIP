// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:my_sip/core/utils/constant/appUrl.dart';
// import 'package:my_sip/core/utils/constant/images.dart';

// class UCircularImage extends StatelessWidget {
//   const UCircularImage({
//     super.key,
//     required this.image,
//     this.radius = 60,
//     this.isNetwork = false,
//     this.fit = BoxFit.cover,
//     this.onTap,
//   });

//   final String image;
//   final double radius;
//   final bool isNetwork;
//   final BoxFit fit;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: radius,
//         backgroundColor: Colors.grey.shade200,
//         child: ClipOval(child: _buildImageLogic()),
//       ),
//     );
//   }

//   Widget _buildImageLogic() {
//     final double size = radius * 2;

//     // 1. Check if the file exists locally first (Priority for Image Picker)
//     if (image.isNotEmpty &&
//         !image.startsWith('http') &&
//         File(image).existsSync()) {
//       return Image.file(File(image), fit: fit, width: size, height: size);
//     }

//     // 2. Handle Network or Backend Storage Paths
//     if (image.startsWith('http') ||
//         image.startsWith('https') ||
//         image.startsWith('storage/')) {
//       final String fullUrl = image.startsWith('storage/')
//           ? "${Appurl.baseUrl}/$image"
//           : image;

//       return Image.network(
//         fullUrl,
//         fit: fit,
//         width: size,
//         height: size,
//         errorBuilder: (context, error, stackTrace) =>
//             Icon(Icons.person, size: radius),
//       );
//     }

//     // 3. Fallback to Asset Image
//     return Image.asset(
//       image.isEmpty ? UImages.avatar : image,
//       fit: fit,
//       width: size,
//       height: size,
//       errorBuilder: (context, error, stackTrace) =>
//           Icon(Icons.person, size: radius),
//     );
//   }
// }
import 'dart:io' as io; // 🚀 FIX 1: dart:io ko alias diya 'io' se
import 'package:flutter/foundation.dart'; // 🚀 FIX 2: kIsWeb use karne ke liye
import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/appUrl.dart';
import 'package:my_sip/core/utils/constant/images.dart';

class UCircularImage extends StatelessWidget {
  const UCircularImage({
    super.key,
    required this.image,
    this.radius = 60,
    this.isNetwork = false,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  final String image;
  final double radius;
  final bool isNetwork;
  final BoxFit fit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(child: _buildImageLogic()),
      ),
    );
  }

  Widget _buildImageLogic() {
    final double size = radius * 2;

    // 0. Safe Check: Agar image empty aayi toh direct fallback dikhao
    if (image.isEmpty) {
      return Image.asset(UImages.avatar, fit: fit, width: size, height: size);
    }

    // 1. Web Image Picker Check (blob: URL)
    if (kIsWeb && image.startsWith('blob:')) {
      return Image.network(
        image,
        fit: fit,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => _buildFallback(size),
      );
    }

    // 2. Check Local File (🚀 SIRF MOBILE PAR CHALEGA)
    if (!kIsWeb &&
        !image.startsWith('http') &&
        !image.startsWith('storage/') &&
        !image.startsWith('assets/')) {
      try {
        if (io.File(image).existsSync()) {
          return Image.file(
            io.File(image),
            fit: fit,
            width: size,
            height: size,
          );
        }
      } catch (e) {
        // Agar file dhoondhne mein error aaye toh ignore karo
      }
    }

    // 3. Handle Network or Backend Storage Paths
    if (image.startsWith('http') || image.startsWith('storage/')) {
      final String fullUrl = image.startsWith('storage/')
          ? "${Appurl.baseUrl}/$image"
          : image;

      return Image.network(
        fullUrl,
        fit: fit,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          // CORS error ya invalid URL par app crash nahi hogi, avatar dikhega!
          return _buildFallback(size);
        },
      );
    }

    // 4. Fallback to Asset Image (Agar path 'assets/...' jaisa hai)
    return Image.asset(
      image,
      fit: fit,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => _buildFallback(size),
    );
  }

  // Helper widget taaki baar-baar fallback code repeat na karna pade
  Widget _buildFallback(double size) {
    return Image.asset(
      UImages.avatar,
      fit: fit,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.person, size: radius, color: Colors.grey),
    );
  }
}
