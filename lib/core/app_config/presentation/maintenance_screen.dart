import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constant/colors.dart';
import '../../utils/constant/text_style.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../services/session_manager.dart';
import '../service/app_config_service.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  bool _isChecking = false;

  Future<void> _handleRetry() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final config = await AppConfigService.instance.checkConfig();

    if (!mounted) return;
    setState(() => _isChecking = false);

    if (config != null && !config.isMaintenanceActive) {
      // Maintenance ended! Route back into app
      final isLoggedIn = SessionManager.instance.isAuthenticated();
      Get.offAllNamed(isLoggedIn ? AppRoutes.navMenuBar : AppRoutes.splash);
    } else {
      Get.snackbar(
        'Maintenance in Progress',
        'Our servers are still undergoing maintenance. Please try again shortly.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade900,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final configService = AppConfigService.instance;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Obx(() {
                  final config = configService.currentConfig.value;
                  final title = config?.maintenance.title.isNotEmpty == true
                      ? config!.maintenance.title
                      : 'MFSIP is Under Maintenance';
                  final message = config?.maintenance.message.isNotEmpty == true
                      ? config!.maintenance.message
                      : 'We are currently improving our services. Please try again shortly.';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Illustration / Icon Badge
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Ucolors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.setting_2,
                            size: 48,
                            color: Ucolors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: FontFamily.bold,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Message
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Retry Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isChecking ? null : _handleRetry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isChecking
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.refresh, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Check Again',
                                      style: TextStyle(
                                        fontFamily: FontFamily.medium,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
