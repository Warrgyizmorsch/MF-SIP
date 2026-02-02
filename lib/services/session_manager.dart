import 'dart:async';
import 'dart:convert'; // Required for jsonEncode/jsonDecode

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_sip/features/authentication/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/authentication/domain/entitites/auth_entity.dart';

class SessionManager {
  SessionManager._internal();

  static final SessionManager _instance = SessionManager._internal();
  static SessionManager get instance => _instance;

  final FlutterSecureStorage? _secureStorage = kIsWeb ? null : const FlutterSecureStorage();
  SharedPreferences? _prefs;

  String? userId;
  String? jwtAccessToken;
  String? jwtRefreshToken;

  // Store as UserEntity object in memory
  UserModel? _userData;

  final StreamController<String?> _controller = StreamController<String?>.broadcast();
  Stream<String?> get accessTokenStream => _controller.stream;

  Future<void> initialize() async {
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
      jwtAccessToken = _prefs?.getString('jwtAccessToken');
      jwtRefreshToken = _prefs?.getString('jwtRefreshToken');
      userId = _prefs?.getString('userId');

      // 1. Read string
      final userJsonString = _prefs?.getString('userData');
      // 2. Convert String -> JSON -> UserEntity
      if (userJsonString != null) {
        try {
          // Assuming UserEntity has a fromJson factory or method
          _userData = UserModel.fromJson(jsonDecode(userJsonString));
        } catch (e) {
          createLog("Error parsing user data on web: $e");
        }
      }
    } else {
      await getSession();
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
      // Assuming UserEntity has a toJson method
      userDataString = userData != null ? jsonEncode(userData.toJson()) : null;    }

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
      createLog("Storing in flutter secure storage for mobile");

      if (jwtAccessToken != null) {
        await _secureStorage!.write(key: "jwtAccessToken", value: jwtAccessToken);
      } else {
        await _secureStorage!.delete(key: "jwtAccessToken");
      }

      if (jwtRefreshToken != null) {
        await _secureStorage!.write(key: "jwtRefreshToken", value: jwtRefreshToken);
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

    if (kIsWeb) {
      await _ensurePrefsInitialized();
      jwtAccessToken = _prefs?.getString('jwtAccessToken');
      jwtRefreshToken = _prefs?.getString('jwtRefreshToken');
      userId = _prefs?.getString('userId');
      userDataString = _prefs?.getString('userData');
    } else {
      jwtAccessToken = await _secureStorage?.read(key: 'jwtAccessToken');
      jwtRefreshToken = await _secureStorage?.read(key: 'jwtRefreshToken');
      userId = await _secureStorage?.read(key: 'userId');
      userDataString = await _secureStorage?.read(key: 'userData');
    }

    // Convert String -> UserEntity
    if (userDataString != null) {
      try {
        _userData = UserModel.fromJson(jsonDecode(userDataString));
      } catch (e) {
        createLog("Error parsing user data: $e");
      }
    }
  }

  Future<void> clearSession() async {
    jwtAccessToken = null;
    jwtRefreshToken = null;
    userId = null;
    _userData = null;

    if (kIsWeb) {
      await _ensurePrefsInitialized();
      await Future.wait([
        _prefs!.remove('jwtAccessToken'),
        _prefs!.remove('jwtRefreshToken'),
        _prefs!.remove('userId'),
        _prefs!.remove('userData'),
      ]);
    } else {
      await Future.wait([
        _secureStorage!.delete(key: 'jwtAccessToken'),
        _secureStorage!.delete(key: 'jwtRefreshToken'),
        _secureStorage!.delete(key: 'userId'),
        _secureStorage!.delete(key: 'userData'),
      ]);
    }

    _controller.add(null);
  }

  Future<void> updateAccessToken(String? token) async {
    // Pass the existing _userData object
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

  // Getter now returns the Object, not a String
  UserModel? get getUserData => _userData;

  bool isAuthenticated() {
    return jwtAccessToken != null && jwtAccessToken!.isNotEmpty;
  }

  void dispose() {
    _controller.close();
  }
}