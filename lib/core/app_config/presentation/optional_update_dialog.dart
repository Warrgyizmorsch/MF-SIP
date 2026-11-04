import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constant/colors.dart';
import '../../utils/constant/text_style.dart';
import '../service/app_config_service.dart';

class OptionalUpdateDialog extends StatelessWidget {
  final String latestVersion;
  final VoidCallback onDismiss;

  const OptionalUpdateDialog({
    super.key,
    required this.latestVersion,
    required this.onDismiss,
  });

  static Future<void> show(BuildContext context) async {
    final service = AppConfigService.instance;
    final latestVer = service.currentConfig.value?.currentLatestVersion ?? 'New';

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'OptionalUpdateDialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: OptionalUpdateDialog(
            latestVersion: latestVer,
            onDismiss: () {
              service.isDismissedOptionalUpdateThisSession = true;
              Navigator.of(ctx).pop();
            },
          ),
        );
      },
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Ucolors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Ucolors.primary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Update Available',
                style: TextStyle(
                  fontFamily: FontFamily.bold,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A newer version (v$latestVersion) of MFSIP is ready with improved performance and new features.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: FontFamily.regular,
                  fontSize: 13.5,
                  color: Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDismiss,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Later',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        AppConfigService.instance.openStore();
                        onDismiss();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Ucolors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontFamily: FontFamily.medium,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
