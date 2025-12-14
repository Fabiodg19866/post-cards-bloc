import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      final canAuthenticateWithBiometrics = await canCheckBiometrics();
      final canAuthenticate = canAuthenticateWithBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        return false;
      }

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to view post details',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      print('Error authenticating: $e');
      return false;
    }
  }
}