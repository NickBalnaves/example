import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gift_card_shopping/constants/secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../constants/routes.dart';

/// A [ChangeNotifier] containing user data
class UserNotifier with ChangeNotifier {
  UserNotifier({
    @required this.navigatorKey,
  });

  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  /// A check if user authentication is populated for routing
  Future<void> init() async {
    var authCred = <String, String>{};
    try {
      authCred = await _storage.readAll();
    } on PlatformException catch (e) {
      log(e.message);
      await _storage.deleteAll();
    }
    if (authCred[SecureStorage.username] == null ||
        authCred[SecureStorage.password] == null) {
      await signOut();
    } else {
      if (await _auth.authenticateWithBiometrics(
        localizedReason: 'Confirm your biometric to continue',
        stickyAuth: true,
      )) {
        await signIn();
      } else {
        await signOut();
      }
      notifyListeners();
    }
  }

  /// A navigator key used for navigating in a change notifier
  GlobalKey<NavigatorState> navigatorKey;

  /// User sign out method to remove all user data and route to sign in
  Future<void> signOut() async {
    await _storage.deleteAll();
    await navigatorKey.currentState.pushNamedAndRemoveUntil(
      Routes.login,
      (_) => false,
    );
    notifyListeners();
  }

  /// User sign in method to route to a logged in state
  Future<void> signIn() async {
    await navigatorKey.currentState.pushNamedAndRemoveUntil(
      Routes.home,
      (_) => false,
    );
    notifyListeners();
  }

  /// Write credential values securely
  Future<void> writeAuth({
    @required String username,
    @required String password,
  }) async {
    await _storage.write(
      key: SecureStorage.username,
      value: username,
    );
    await _storage.write(
      key: SecureStorage.password,
      value: password,
    );
    notifyListeners();
  }
}
