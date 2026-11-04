import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/network_api_service.dart';
import '../../utils/constant/appUrl.dart';
import '../../utils/helper/helpers.dart';
import '../model/app_config_model.dart';

class AppConfigService extends GetxService {
  static AppConfigService get instance {
    if (!Get.isRegistered<AppConfigService>()) {
      Get.put(AppConfigService(), permanent: true);
    }
    return Get.find<AppConfigService>();
  }

  static const String _cacheKey = 'mfsip_cached_app_config';

  final Rxn<AppConfigData> currentConfig = Rxn<AppConfigData>();
  final RxBool isLoading = false.obs;
  final RxString installedVersion = '1.0.0'.obs;

  bool isDismissedOptionalUpdateThisSession = false;

  @override
  void onInit() {
    super.onInit();
    _loadInstalledVersion();
    _loadCachedConfig();
  }

  Future<void> _loadInstalledVersion() async {
    if (kIsWeb) {
      installedVersion.value = '1.0.0';
      return;
    }
    try {
      final info = await PackageInfo.fromPlatform();
      if (info.version.isNotEmpty) {
        installedVersion.value = info.version;
      }
    } catch (e) {
      createLog('[AppConfigService] Error loading PackageInfo: $e');
    }
  }

  Future<void> _loadCachedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final decoded = jsonDecode(cachedJson);
        if (decoded is Map<String, dynamic>) {
          currentConfig.value = AppConfigData.fromJson(decoded);
        }
      }
    } catch (e) {
      createLog('[AppConfigService] Error loading cached config: $e');
    }
  }

  /// Evaluates and fetches runtime configuration from backend
  Future<AppConfigData?> checkConfig() async {
    isLoading.value = true;
    try {
      await _loadInstalledVersion();
      final network = NetworkServicesApi();
      final String url = '${Appurl.baseUrl}/api/v1/app/config';

      final response = await network.getApi(
        url,
        isPublic: true,
      );

      if (response != null && response is Map<String, dynamic>) {
        final configResponse = AppConfigResponseModel.fromJson(response);
        if (configResponse.success) {
          currentConfig.value = configResponse.data;

          // Cache in local storage for offline tolerance
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_cacheKey, jsonEncode(configResponse.data.toJson()));
          return configResponse.data;
        }
      }
    } catch (e) {
      createLog('[AppConfigService] Check config failed: $e');
    } finally {
      isLoading.value = false;
    }
    return currentConfig.value;
  }

  // --- Convenience Getters ---

  bool get isMaintenanceActive => currentConfig.value?.isMaintenanceActive ?? false;

  bool get isForceUpdateRequired {
    final config = currentConfig.value;
    if (config == null) return false;

    // 1. Check server-evaluated flag first
    if (config.clientEvaluation != null) {
      return config.clientEvaluation!.forceUpdate || !config.clientEvaluation!.isSupported;
    }

    // 2. Client fallback: compare current version with minimumVersion
    final minVer = config.currentMinimumVersion;
    if (minVer != null && minVer.isNotEmpty) {
      return isVersionOlder(installedVersion.value, minVer);
    }
    return false;
  }

  bool get isOptionalUpdateAvailable {
    if (isForceUpdateRequired) return false;
    if (isDismissedOptionalUpdateThisSession) return false;

    final config = currentConfig.value;
    if (config == null) return false;

    final latestVer = config.currentLatestVersion;
    if (latestVer != null && latestVer.isNotEmpty) {
      return isVersionOlder(installedVersion.value, latestVer);
    }
    return false;
  }

  String? get storeUrl => currentConfig.value?.currentStoreUrl;

  bool isFeatureEnabled(String key) => currentConfig.value?.isFeatureEnabled(key) ?? true;

  bool get isSipEnabled => currentConfig.value?.isSipEnabled ?? true;
  bool get isRedeemEnabled => currentConfig.value?.isRedeemEnabled ?? true;
  bool get isPaymentEnabled => currentConfig.value?.isPaymentEnabled ?? true;
  bool get isNewInvestmentEnabled => currentConfig.value?.isNewInvestmentEnabled ?? true;

  /// Compares semantic versions (e.g. 1.0.0 vs 1.2.0)
  static bool isVersionOlder(String current, String target) {
    try {
      final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final targetParts = target.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      for (var i = 0; i < 3; i++) {
        final c = i < currentParts.length ? currentParts[i] : 0;
        final t = i < targetParts.length ? targetParts[i] : 0;
        if (c < t) return true;
        if (c > t) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Opens Google Play Store or Apple App Store externally
  Future<bool> openStore() async {
    final url = storeUrl;
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      createLog('[AppConfigService] Launch store URL failed: $e');
      return false;
    }
  }
}
