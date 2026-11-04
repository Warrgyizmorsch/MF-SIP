import 'package:flutter/foundation.dart';

class AppConfigResponseModel {
  final bool success;
  final AppConfigData data;

  const AppConfigResponseModel({
    required this.success,
    required this.data,
  });

  factory AppConfigResponseModel.fromJson(Map<String, dynamic> json) {
    return AppConfigResponseModel(
      success: json['success'] == true,
      data: AppConfigData.fromJson(
        json['data'] is Map ? Map<String, dynamic>.from(json['data']) : {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.toJson(),
  };
}

class AppConfigData {
  final PlatformStoreConfig? ios;
  final PlatformStoreConfig? android;
  final WebConfig? web;
  final Map<String, bool> features;
  final int revision;
  final String? checkedAt;
  final MaintenanceConfig maintenance;
  final AnnouncementConfig announcement;
  final int refreshAfterSeconds;
  final ClientEvaluationConfig? clientEvaluation;

  const AppConfigData({
    this.ios,
    this.android,
    this.web,
    required this.features,
    required this.revision,
    this.checkedAt,
    required this.maintenance,
    required this.announcement,
    required this.refreshAfterSeconds,
    this.clientEvaluation,
  });

  factory AppConfigData.fromJson(Map<String, dynamic> json) {
    final rawFeatures = json['features'];
    final featuresMap = <String, bool>{};
    if (rawFeatures is Map) {
      rawFeatures.forEach((key, value) {
        featuresMap[key.toString()] = value == true;
      });
    }

    return AppConfigData(
      ios: json['ios'] is Map
          ? PlatformStoreConfig.fromJson(Map<String, dynamic>.from(json['ios']))
          : null,
      android: json['android'] is Map
          ? PlatformStoreConfig.fromJson(
              Map<String, dynamic>.from(json['android']),
            )
          : null,
      web: json['web'] is Map
          ? WebConfig.fromJson(Map<String, dynamic>.from(json['web']))
          : null,
      features: featuresMap,
      revision: json['revision'] is num ? (json['revision'] as num).toInt() : 1,
      checkedAt: json['checked_at']?.toString(),
      maintenance: json['maintenance'] is Map
          ? MaintenanceConfig.fromJson(
              Map<String, dynamic>.from(json['maintenance']),
            )
          : MaintenanceConfig.empty(),
      announcement: json['announcement'] is Map
          ? AnnouncementConfig.fromJson(
              Map<String, dynamic>.from(json['announcement']),
            )
          : AnnouncementConfig.empty(),
      refreshAfterSeconds: json['refresh_after_seconds'] is num
          ? (json['refresh_after_seconds'] as num).toInt()
          : 300,
      clientEvaluation: json['client_evaluation'] is Map
          ? ClientEvaluationConfig.fromJson(
              Map<String, dynamic>.from(json['client_evaluation']),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (ios != null) 'ios': ios!.toJson(),
    if (android != null) 'android': android!.toJson(),
    if (web != null) 'web': web!.toJson(),
    'features': features,
    'revision': revision,
    'checked_at': checkedAt,
    'maintenance': maintenance.toJson(),
    'announcement': announcement.toJson(),
    'refresh_after_seconds': refreshAfterSeconds,
    if (clientEvaluation != null)
      'client_evaluation': clientEvaluation!.toJson(),
  };

  /// Returns true if system-wide maintenance mode is actively enabled
  bool get isMaintenanceActive => maintenance.enabled;

  /// Returns true if app must be updated before user can proceed
  bool get isForceUpdateRequired {
    if (clientEvaluation != null) {
      return clientEvaluation!.forceUpdate || !clientEvaluation!.isSupported;
    }
    return false;
  }

  /// Store URL to direct the user based on runtime platform
  String? get currentStoreUrl {
    if (kIsWeb) return null;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios?.storeUrl;
    }
    return android?.storeUrl;
  }

  /// Latest version string from server for the current platform
  String? get currentLatestVersion {
    if (kIsWeb) return null;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios?.latestVersion;
    }
    return android?.latestVersion;
  }

  /// Minimum version string from server for the current platform
  String? get currentMinimumVersion {
    if (kIsWeb) return null;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios?.minimumVersion;
    }
    return android?.minimumVersion;
  }

  /// Checks whether a specific feature flag is permitted (defaults to true if key absent)
  bool isFeatureEnabled(String key) => features[key] ?? true;

  bool get isSipEnabled => isFeatureEnabled('sip_enabled');
  bool get isRedeemEnabled => isFeatureEnabled('redeem_enabled');
  bool get isPaymentEnabled => isFeatureEnabled('payment_enabled');
  bool get isNewInvestmentEnabled => isFeatureEnabled('new_investment_enabled');
  bool get isAnnouncementActive => announcement.enabled && announcement.message.trim().isNotEmpty;
}

class PlatformStoreConfig {
  final String storeUrl;
  final String latestVersion;
  final String minimumVersion;

  const PlatformStoreConfig({
    required this.storeUrl,
    required this.latestVersion,
    required this.minimumVersion,
  });

  factory PlatformStoreConfig.fromJson(Map<String, dynamic> json) {
    return PlatformStoreConfig(
      storeUrl: json['store_url']?.toString() ?? '',
      latestVersion: json['latest_version']?.toString() ?? '1.0.0',
      minimumVersion: json['minimum_version']?.toString() ?? '1.0.0',
    );
  }

  Map<String, dynamic> toJson() => {
    'store_url': storeUrl,
    'latest_version': latestVersion,
    'minimum_version': minimumVersion,
  };
}

class WebConfig {
  final String? buildId;
  final bool reloadRecommended;

  const WebConfig({
    this.buildId,
    required this.reloadRecommended,
  });

  factory WebConfig.fromJson(Map<String, dynamic> json) {
    return WebConfig(
      buildId: json['build_id']?.toString(),
      reloadRecommended: json['reload_recommended'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'build_id': buildId,
    'reload_recommended': reloadRecommended,
  };
}

class MaintenanceConfig {
  final bool enabled;
  final String title;
  final String message;
  final String? startsAt;
  final String? endsAt;
  final int retryAfterSeconds;

  const MaintenanceConfig({
    required this.enabled,
    required this.title,
    required this.message,
    this.startsAt,
    this.endsAt,
    required this.retryAfterSeconds,
  });

  factory MaintenanceConfig.empty() => const MaintenanceConfig(
    enabled: false,
    title: 'MFSIP is under maintenance',
    message: 'We are currently improving our services. Please try again shortly.',
    retryAfterSeconds: 180,
  );

  factory MaintenanceConfig.fromJson(Map<String, dynamic> json) {
    return MaintenanceConfig(
      enabled: json['enabled'] == true,
      title: json['title']?.toString() ?? 'MFSIP is under maintenance',
      message: json['message']?.toString() ??
          'We are currently improving our services. Please try again shortly.',
      startsAt: json['starts_at']?.toString(),
      endsAt: json['ends_at']?.toString(),
      retryAfterSeconds: json['retry_after_seconds'] is num
          ? (json['retry_after_seconds'] as num).toInt()
          : 180,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'title': title,
    'message': message,
    'starts_at': startsAt,
    'ends_at': endsAt,
    'retry_after_seconds': retryAfterSeconds,
  };
}

class AnnouncementConfig {
  final bool enabled;
  final dynamic id;
  final String title;
  final String message;
  final String? actionUrl;
  final String? actionText;

  const AnnouncementConfig({
    required this.enabled,
    this.id,
    required this.title,
    required this.message,
    this.actionUrl,
    this.actionText,
  });

  factory AnnouncementConfig.empty() => const AnnouncementConfig(
    enabled: false,
    id: null,
    title: '',
    message: '',
  );

  factory AnnouncementConfig.fromJson(Map<String, dynamic> json) {
    return AnnouncementConfig(
      enabled: json['enabled'] == true,
      id: json['id'],
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      actionUrl: json['action_url']?.toString(),
      actionText: json['action_text']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'id': id,
    'title': title,
    'message': message,
    if (actionUrl != null) 'action_url': actionUrl,
    if (actionText != null) 'action_text': actionText,
  };
}
class ClientEvaluationConfig {
  final String platform;
  final String installedVersion;
  final bool isSupported;
  final bool forceUpdate;

  const ClientEvaluationConfig({
    required this.platform,
    required this.installedVersion,
    required this.isSupported,
    required this.forceUpdate,
  });

  factory ClientEvaluationConfig.fromJson(Map<String, dynamic> json) {
    return ClientEvaluationConfig(
      platform: json['platform']?.toString() ?? '',
      installedVersion: json['installed_version']?.toString() ?? '',
      isSupported: json['is_supported'] == true,
      forceUpdate: json['force_update'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'platform': platform,
    'installed_version': installedVersion,
    'is_supported': isSupported,
    'force_update': forceUpdate,
  };
}
