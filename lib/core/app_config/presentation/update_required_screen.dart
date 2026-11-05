import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constant/colors.dart';
import '../../utils/constant/text_style.dart';
import '../service/app_config_service.dart';

class UpdateRequiredScreen extends StatefulWidget {
  const UpdateRequiredScreen({super.key});

  @override
  State<UpdateRequiredScreen> createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends State<UpdateRequiredScreen> {
  bool _isOpening = false;

  Future<void> _handleUpdate() async {
    if (_isOpening) return;
    setState(() => _isOpening = true);
    final launched = await AppConfigService.instance.openStore();
    if (!mounted) return;
    setState(() => _isOpening = false);

    if (!launched) {
      Get.snackbar(
        'Store Link Error',
        'Unable to open app store. Please visit Google Play Store or App Store manually to update MFSIP.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade900,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Obx(() {
                  final config = configService.currentConfig.value;
                  final installed = configService.installedVersion.value;
                  final minVersion = config?.currentMinimumVersion ?? 'Latest';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circular Badge
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Ucolors.skyblue1,
                          shape: BoxShape.circle,
                          border: Border.all(color: Ucolors.skyblue, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.arrow_circle_up,
                            size: 48,
                            color: Ucolors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'Update Required',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontFamily.bold,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      const Text(
                        'A newer version of MFSIP is required to continue. Please update your app for the latest investment features, security upgrades, and fixes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontFamily.regular,
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Version Information Chips
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Installed',
                                  style: TextStyle(
                                    fontFamily: FontFamily.regular,
                                    fontSize: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'v$installed',
                                  style: const TextStyle(
                                    fontFamily: FontFamily.medium,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: const Color(0xFFCBD5E1),
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Minimum Required',
                                  style: TextStyle(
                                    fontFamily: FontFamily.regular,
                                    fontSize: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'v$minVersion',
                                  style: const TextStyle(
                                    fontFamily: FontFamily.medium,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Ucolors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Update Now Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isOpening ? null : _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Ucolors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isOpening
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
                                    Icon(Icons.system_update_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Update Now',
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
