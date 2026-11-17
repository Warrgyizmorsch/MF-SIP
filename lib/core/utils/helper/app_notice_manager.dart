import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/common/widget/animated/illustrated_notice_dialog.dart';

enum NoticeFrequency { everyOpen, oncePerSession, oncePerDay, onceEver }

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
    String? illustrationAsset,
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

    // 4. Present the shared illustrated dialog. Frequency guards stay above.
    void dismiss() {
      Get.back();
      onSecondaryTap?.call();
    }

    Get.dialog(
      IllustratedNoticeDialog(
        title: title,
        message: message,
        illustrationAsset: illustrationAsset,
        icon: icon,
        iconColor: iconColor ?? Ucolors.primary,
        primaryButtonText: primaryButtonText,
        onPrimaryTap: () {
          Get.back();
          onPrimaryTap();
        },
        secondaryButtonText: secondaryButtonText,
        onSecondaryTap: dismiss,
        onClose: barrierDismissible ? dismiss : null,
      ),
      barrierDismissible: barrierDismissible,
    );

    return true;
  }
}
