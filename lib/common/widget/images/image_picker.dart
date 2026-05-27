// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:iconsax/iconsax.dart';

// class UImagePicker {
//   /// Custom Image Source Picker usable on any screen
//   static void showImageSourceOptions({
//     required BuildContext context,
//     required Function(ImageSource) onImageSelected,
//     String title = "Select Source Photo",
//   }) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(24),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildOption(
//                   icon: Iconsax.camera,
//                   label: "Camera",
//                   color: Colors.blue,
//                   onTap: () {
//                     Get.back();
//                     onImageSelected(ImageSource.camera);
//                   },
//                 ),
//                 const SizedBox(width: 32),
//                 _buildOption(
//                   icon: Iconsax.gallery,
//                   label: "Gallery",
//                   color: Colors.purple,
//                   onTap: () {
//                     Get.back();
//                     onImageSelected(ImageSource.gallery);
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildOption({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             height: 60,
//             width: 60,
//             decoration: BoxDecoration(
//               color: color.withValues(alpha:0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 8),
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/utils/constant/text_style.dart';

class UImagePicker {
  /// Custom Image Source Picker usable on any screen
  static void showImageSourceOptions({
    required BuildContext context,
    required Function(ImageSource) onImageSelected,
    String title = "Select Source Photo",
  }) {
    // 🚀 Check if Desktop/Web or Mobile
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    if (isDesktop) {
      // =========================================
      // 💻 WEB / DESKTOP: Show Centered Dialog
      // =========================================
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: FontFamily.medium,),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOption(
                      icon: Iconsax.camera,
                      label: "Camera",
                      color: Colors.blue,
                      onTap: () {
                        Get.back();
                        onImageSelected(ImageSource.camera);
                      },
                    ),
                    _buildOption(
                      icon: Iconsax.gallery,
                      label: "Gallery",
                      color: Colors.purple,
                      onTap: () {
                        Get.back();
                        onImageSelected(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // =========================================
      // 📱 MOBILE: Show Bottom Sheet
      // =========================================
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: FontFamily.medium,),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    icon: Iconsax.camera,
                    label: "Camera",
                    color: Colors.blue,
                    onTap: () {
                      Get.back();
                      onImageSelected(ImageSource.camera);
                    },
                  ),
                  const SizedBox(width: 32),
                  _buildOption(
                    icon: Iconsax.gallery,
                    label: "Gallery",
                    color: Colors.purple,
                    onTap: () {
                      Get.back();
                      onImageSelected(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }

  static Widget _buildOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: FontFamily.medium,)),
          ],
        ),
      ),
    );
  }
}