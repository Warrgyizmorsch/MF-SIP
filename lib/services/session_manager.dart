import 'dart:async';
import 'dart:convert'; // Required for jsonEncode/jsonDecode

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:my_sip/features/authentication/data/models/auth_model.dart';
import 'package:my_sip/features/personalization/data/model/risk_result_model.dart';
import 'package:my_sip/features/personalization/domain/entity/risk_result_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends GetxService {
  SessionManager._internal();

  static final SessionManager _instance = SessionManager._internal();
  static SessionManager get instance => _instance;

  final FlutterSecureStorage? _secureStorage =
  kIsWeb ? null : const FlutterSecureStorage();
  SharedPreferences? _prefs;

  String? userId;
  String? jwtAccessToken;
  String? jwtRefreshToken;

  // --- REPLACED: _riskScore is now backed by an Rx Variable ---
  final Rxn<RiskResultModel> riskScoreObs = Rxn<RiskResultModel>();

  // Store as UserEntity object in memory
  UserModel? _userData;

  final StreamController<String?> _controller =
  StreamController<String?>.broadcast();
  Stream<String?> get accessTokenStream => _controller.stream;

  Future<void> initialize() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
      jwtAccessToken = _prefs?.getString('jwtAccessToken');
      jwtRefreshToken = _prefs?.getString('jwtRefreshToken');
      userId = _prefs?.getString('userId');

      final riskScoreString = _prefs?.getString('riskScore');

      if (riskScoreString != null) {
        try {
          final loadedScore =
          RiskResultModel.fromJson(jsonDecode(riskScoreString));
          // Update Observable
          riskScoreObs.value = loadedScore;
        } catch (e) {
          debugPrint("Error parsing risk score on web: $e");
        }
      }

      // 1. Read string
      final userJsonString = _prefs?.getString('userData');
      // 2. Convert String -> JSON -> UserEntity
      if (userJsonString != null) {
        try {
          _userData = UserModel.fromJson(jsonDecode(userJsonString));
        } catch (e) {
          debugPrint("Error parsing user data on web: $e");
        }
      }
    } else {
      await getSession();
    }
  }

  Future<bool> saveRiskScore(RiskResultModel? riskScore) async {
    // Update the Observable immediately to trigger UI updates
    riskScoreObs.value = riskScore;

    // Convert UserEntity -> JSON -> String
    String? riskDataString;
    if (riskScore != null) {
      riskDataString = jsonEncode(riskScore.toJson());
    }

    if (kIsWeb) {
      await _ensurePrefsInitialized();
      if (riskDataString != null) {
        await _prefs!.setString('riskScore', riskDataString);
        return true;
      } else {
        await _prefs!.remove('riskScore');
        return false;
      }
    } else {
      // Mobile (Secure Storage)
      if (riskDataString != null) {
        await _secureStorage!.write(key: "riskScore", value: riskDataString);
        return true;
      } else {
        await _secureStorage!.delete(key: "riskScore");
        return false;
      }
    }
  }

  Future<void> setSession({
    required String? jwtAccessToken,
    String? jwtRefreshToken,
    String? userId,
    UserModel? userData,
  }) async {
    this.jwtAccessToken = jwtAccessToken;
    this.jwtRefreshToken = jwtRefreshToken;
    this.userId = userId;
    this._userData = userData;

    // Convert UserEntity -> JSON -> String
    String? userDataString;
    if (userData != null) {
      userDataString = jsonEncode(userData.toJson());
    }

    if (kIsWeb) {
      await _ensurePrefsInitialized();

      if (jwtAccessToken != null) {
        await _prefs!.setString('jwtAccessToken', jwtAccessToken);
      } else {
        await _prefs!.remove('jwtAccessToken');
      }

      if (jwtRefreshToken != null) {
        await _prefs!.setString('jwtRefreshToken', jwtRefreshToken);
      } else {
        await _prefs!.remove('jwtRefreshToken');
      }

      if (userId != null) {
        await _prefs!.setString('userId', userId);
      } else {
        await _prefs!.remove('userId');
      }

      if (userDataString != null) {
        await _prefs!.setString('userData', userDataString);
      } else {
        await _prefs!.remove('userData');
      }
    } else {
      debugPrint("Storing in flutter secure storage for mobile");

      if (jwtAccessToken != null) {
        await _secureStorage!.write(
          key: "jwtAccessToken",
          value: jwtAccessToken,
        );
      } else {
        await _secureStorage!.delete(key: "jwtAccessToken");
      }

      if (jwtRefreshToken != null) {
        await _secureStorage!.write(
          key: "jwtRefreshToken",
          value: jwtRefreshToken,
        );
      } else {
        await _secureStorage!.delete(key: "jwtRefreshToken");
      }

      if (userId != null) {
        await _secureStorage!.write(key: "userId", value: userId);
      } else {
        await _secureStorage!.delete(key: "userId");
      }

      if (userDataString != null) {
        await _secureStorage!.write(key: "userData", value: userDataString);
      } else {
        await _secureStorage!.delete(key: "userData");
      }
    }

    _controller.add(jwtAccessToken);
  }

  Future<void> getSession() async {
    String? userDataString;
    String? riskScoreString;

    if (kIsWeb) {
      await _ensurePrefsInitialized();
      jwtAccessToken = _prefs?.getString('jwtAccessToken');
      jwtRefreshToken = _prefs?.getString('jwtRefreshToken');
      userId = _prefs?.getString('userId');
      userDataString = _prefs?.getString('userData');
      riskScoreString = _prefs?.getString('riskScore');
    } else {
      jwtAccessToken = await _secureStorage?.read(key: 'jwtAccessToken');
      jwtRefreshToken = await _secureStorage?.read(key: 'jwtRefreshToken');
      userId = await _secureStorage?.read(key: 'userId');
      userDataString = await _secureStorage?.read(key: 'userData');
      riskScoreString = await _secureStorage?.read(key: 'riskScore');
    }

    // Convert String -> UserEntity
    if (userDataString != null) {
      try {
        _userData = UserModel.fromJson(jsonDecode(userDataString));
      } catch (e) {
        debugPrint("Error parsing user data: $e");
      }
    }

    // Convert String -> RiskResultModel
    if (riskScoreString != null) {
      try {
        final loadedScore =
        RiskResultModel.fromJson(jsonDecode(riskScoreString));
        riskScoreObs.value = loadedScore;
      } catch (e) {
        debugPrint("Error parsing risk score: $e");
      }
    }
  }

  Future<void> clearSession() async {
    jwtAccessToken = null;
    jwtRefreshToken = null;
    userId = null;
    _userData = null;

    // Clear Observable
    riskScoreObs.value = null;

    if (kIsWeb) {
      await _ensurePrefsInitialized();
      await Future.wait([
        _prefs!.remove('jwtAccessToken'),
        _prefs!.remove('jwtRefreshToken'),
        _prefs!.remove('userId'),
        _prefs!.remove('userData'), // Added missing removal
        _prefs!.remove('riskScore'),
      ]);
    } else {
      await Future.wait([
        _secureStorage!.delete(key: 'jwtAccessToken'),
        _secureStorage!.delete(key: 'jwtRefreshToken'),
        _secureStorage!.delete(key: 'userId'),
        _secureStorage!.delete(key: 'userData'),
        _secureStorage!.delete(key: 'riskScore'),
      ]);
    }

    _controller.add(null);
  }

  Future<void> updateAccessToken(String? token) async {
    await setSession(
      jwtAccessToken: token,
      jwtRefreshToken: jwtRefreshToken,
      userId: userId,
      userData: _userData,
    );
  }

  Future<void> updateRefreshToken(String? token) async {
    jwtRefreshToken = token;

    if (kIsWeb) {
      await _ensurePrefsInitialized();
      if (token != null) {
        await _prefs!.setString('jwtRefreshToken', token);
      } else {
        await _prefs!.remove('jwtRefreshToken');
      }
    } else {
      if (token != null) {
        await _secureStorage!.write(key: "jwtRefreshToken", value: token);
      } else {
        await _secureStorage!.delete(key: "jwtRefreshToken");
      }
    }
  }

  Future<void> _ensurePrefsInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  String? get getUserId => userId;
  String? get getAccessToken => jwtAccessToken;
  String? get getRefreshToken => jwtRefreshToken;

  UserModel? get getUserData => _userData;

  // Getter now returns the value of the Observable
  RiskResultModel? get getRiskScore => riskScoreObs.value;

  bool isAuthenticated() {
    return jwtAccessToken != null && jwtAccessToken!.isNotEmpty;
  }

  // No need to manually dispose streams in a singleton service usually,
  // but if you do:
  void disposeStream() {
    _controller.close();
  }
}
