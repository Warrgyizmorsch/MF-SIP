import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';

enum NoticeFrequency {
  everyOpen,
  oncePerSession,
  oncePerDay,
  onceEver,
}

class AppNoticeManager {
  static final Set<String> _sessionHistory = {};
  static bool hasShownNoticeInCurrentSession = false;

  /// Resets the in-memory session flags and clears stored notice dates (e.g. upon user logout).
  static Future<void> resetSession() async {
    _sessionHistory.clear();
    hasShownNoticeInCurrentSession = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final keysToRemove = prefs
          .getKeys()
          .where((k) => k.startsWith('app_notice_'))
          .toList();
      for (final key in keysToRemove) {
        await prefs.remove(key);
      }
    } catch (_) {}
  }

  /// Evaluates frequency and conditions, and displays a Center Dialog Modal if eligible.
  /// Returns `true` if the dialog was presented, or `false` if skipped.
  static Future<bool> showNoticeIfEligible({
    required String noticeId,
    required NoticeFrequency frequency,
    required bool Function() condition,
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback onPrimaryTap,
    String secondaryButtonText = 'Remind Later',
    VoidCallback? onSecondaryTap,
    IconData icon = Icons.info_outline_rounded,
    Color? iconColor,
    bool barrierDismissible = true,
  }) async {
    // 1. Condition Guard
    if (!condition()) return false;

    // 2. Session Guard (Do not spam user on tab switches in the same session)
    if (hasShownNoticeInCurrentSession) return false;

    if (frequency == NoticeFrequency.oncePerSession &&
        _sessionHistory.contains(noticeId)) {
      return false;
    }

    // 3. Persistent Guard (SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    final String lastShownKey = 'app_notice_${noticeId}_last_shown';
    final String dismissedKey = 'app_notice_${noticeId}_dismissed';

    if (frequency == NoticeFrequency.onceEver &&
        (prefs.getBool(dismissedKey) ?? false)) {
      return false;
    }

    if (frequency == NoticeFrequency.oncePerDay) {
      final String today = DateTime.now().toIso8601String().substring(0, 10);
      final String? lastShownDate = prefs.getString(lastShownKey);
      if (lastShownDate == today) {
        return false; // Already presented today
      }
    }

    // Record that notice is shown
    hasShownNoticeInCurrentSession = true;
    _sessionHistory.add(noticeId);
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString(lastShownKey, today);
    if (frequency == NoticeFrequency.onceEver) {
      await prefs.setBool(dismissedKey, true);
    }

    // 4. Present Center Dialog Modal
    final Color effectiveColor = iconColor ?? Ucolors.primary;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Icon Header
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: effectiveColor, size: 28),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // Message Body
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.regular,
                  fontSize: 13.5,
                  height: 1.45,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        onSecondaryTap?.call();
                      },
                      child: Text(
                        secondaryButtonText,
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: effectiveColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        onPrimaryTap();
                      },
                      child: Text(
                        primaryButtonText,
                        style: const TextStyle(
                          fontFamily: FontFamily.medium,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );

    return true;
  }
}
