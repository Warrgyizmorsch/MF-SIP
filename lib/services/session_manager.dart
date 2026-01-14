import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class SessionManager {
  SessionManager._internal();

  static final SessionManager _instance = SessionManager._internal();

  static SessionManager get instance => _instance;

  final storage = const FlutterSecureStorage();

  String? userId;
  String? jwtAccessToken;

  final StreamController<String?> _controller = StreamController<String?>.broadcast();

  Stream<String?> get accessTokenStream => _controller.stream;

  /// Sets the user session.
  ///
  /// This method now deletes the existing token before writing the new one
  /// to prevent a PlatformException on iOS when the key already exists.
  Future<void> setSession({
    required String? jwtAccessToken,
  }) async {
    this.jwtAccessToken = jwtAccessToken;

    // FIX: Delete the key before writing to avoid 'item already exists' error.
    await storage.delete(key: "jwtAccessToken");
    await storage.write(key: "jwtAccessToken", value: jwtAccessToken);

    _controller.add(jwtAccessToken);
  }

  /// Retrieves the session token from secure storage.
  Future<void> getSession() async {
    jwtAccessToken = await storage.read(key: 'jwtAccessToken');
    // Optionally, you can add the read value to the stream here if needed on app startup
    // _controller.add(jwtAccessToken);
  }

  /// Clears the session token from memory and secure storage.
  Future<void> clearSession() async {
    jwtAccessToken = null;
    await Future.wait([
      storage.delete(key: 'jwtAccessToken'),
    ]);
    _controller.add(null);
  }

  /// Updates the access token by reusing the setSession logic.
  ///
  /// This avoids code duplication and ensures the fix is applied here as well.
  Future<void> updateAccessToken(String? token) async {
    await setSession(jwtAccessToken: token);
  }

  String? get getUserId => userId;
  String? get getAccessToken => jwtAccessToken;

  /// Checks if the user is authenticated based on the presence of an access token.
  bool isAuthenticated() {
    return jwtAccessToken != null && jwtAccessToken!.isNotEmpty;
  }
}