import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_sip/core/utils/constant/colors.dart';

import '../../../core/utils/constant/text_style.dart';

// class AnimatedEmptyState extends StatefulWidget {
//   const AnimatedEmptyState({super.key});

//   @override
//   State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
// }

// class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _floatAnimation;
//   late Animation<double> _shadowAnimation;

//   @override
//   void initState() {
//     super.initState();
//     // 1. Setup the controller to loop back and forth continuously
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat(reverse: true);

//     // 2. The up and down floating movement
//     _floatAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(0, -0.15), // Move up on the Y axis
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOutSine, // Smooth, natural easing
//     ));

//     // 3. The shadow shrinking/fading as the icon goes higher
//     _shadowAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.5, 
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOutSine,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Always dispose controllers to prevent memory leaks
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 350,
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [tion(
//                 color: Ucolors.primary.withValues(alpha:0.08), // Soft background circle
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Iconsax.chart_fail, // Using your Iconsax package!
//                 size: 45,
//                 color: Ucolors.primary, 
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 16),
          
//           // --- THE ANIMATED SHADOW ---
//           ScaleTransition(
//             scale: _shadowAnimation,
//             child: FadeTransition(
//               opacity: _shadowAnimation,
//               child: Container(
//                 height: 8,
//                 width: 60,
//           // --- THE FLOATING ICON ---
//           SlideTransition(
//             position: _floatAnimation,
//             child: Container(
//               height: 100,
//               width: 100,
//               decoration: BoxDecora
//                 decoration: BoxDecoration(
//                   color: Colors.black.withValues(alpha:0.1),
//                   borderRadius: BorderRadius.circular(100), // Makes it an oval
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 32),

//           // --- THE TEXT ---
//           const Text(
//             "No Portfolio Data",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "The AMC hasn't disclosed the holdings for this fund, or it may not be applicable to this scheme.",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//               color: Colors.grey,
//               height: 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class AnimatedEmptyState extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;

  const AnimatedEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Iconsax.chart_fail, // Default icon if none provided
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _floatAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Setup the controller loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // 2. Float Up and Down
    _floatAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.15),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    // 3. Shadow Shrink/Fade
    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Height can be adjusted or removed if you want it to fill available space
      height: 350, 
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // --- ANIMATED ICON ---
          SlideTransition(
            position: _floatAnimation,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Ucolors.primary.withValues(alpha:0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon, // Using the passed icon
                size: 45,
                color: Ucolors.primary,
              ),
            ),
          ),
          
          const SizedBox(height: 16),

          // --- ANIMATED SHADOW ---
          ScaleTransition(
            scale: _shadowAnimation,
            child: FadeTransition(
              opacity: _shadowAnimation,
              child: Container(
                height: 8,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // --- TEXT CONTENT ---
          Text(
            widget.title, // Using the passed title
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: FontFamily.medium,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.message, // Using the passed message
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: FontFamily.medium,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}