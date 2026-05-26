
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';

class AuthServicesBio {
  final LocalAuthentication localAuth = LocalAuthentication();

  Future<bool> authencticateLocally() async {
    bool isAuthenticate = false;

    try {
      isAuthenticate = await localAuth.authenticate(
        biometricOnly: true,

        localizedReason: 'We need to authenticate to for using the app ',
      );
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noBiometricHardware) {
        // Add handling of no hardware here.
      } else if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        // ...
      } else {
        // ...
      }
    } catch (e) {
      isAuthenticate = false;
      debugPrint('Error $e');
    }

    return isAuthenticate;
  }
}
