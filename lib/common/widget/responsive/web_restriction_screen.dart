import 'package:flutter/material.dart';

class WebRestrictionScreen extends StatelessWidget {
  final double currentWidth;

  const WebRestrictionScreen({super.key, required this.currentWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF334155)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3D000000),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon badge
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.desktop_windows_rounded,
                      size: 56,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Desktop View Required',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'This web application is optimized for desktop and laptop displays. Please open this link on a desktop browser for the best experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info Chip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.screen_search_desktop_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Current Width: ${currentWidth.toInt()}px (Requires ≥ 1024px)',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF94A3B8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
