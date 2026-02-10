import 'dart:async';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/models/user_model.dart';

class AuthManagerImpl implements AuthManager {
  final TokenManager _tokenManager;
  final _authStatusController = StreamController<AuthStatus>.broadcast();

  AuthManagerImpl(this._tokenManager);

  @override
  Future<bool> isUserLoggedIn() async {
    return await _tokenManager.hasToken();
  }

  @override
  Future<void> login(
    String accessToken,
    String refreshToken, {
    bool isCompleteData = false,
    UserModel? user,
  }) async {
    await _tokenManager.saveToken(
      accessToken,
      refreshToken,
      isCompleteData: isCompleteData,
    );
    _authStatusController.add(AuthStatus.authenticated);
  }

  @override
  Future<void> newAccess(String accessToken) async {
    await _tokenManager.updateAccess(accessToken);
    _authStatusController.add(AuthStatus.authenticated);
  }

  @override
  Future<void> logout() async {
    await _tokenManager.deleteToken();
    _authStatusController.add(AuthStatus.unauthenticated);
  }

  @override
  Future<void> handleAuthError() async {
    await logout();
    _authStatusController.add(AuthStatus.expired);
  }

  @override
  Future<String?> getCurrentAccessToken() async {
    return await _tokenManager.getAccessToken();
  }

  @override
  Future<String?> getCurrentRefreshToken() async {
    return await _tokenManager.getResfreshToken();
  }

  @override
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  /// Libera recursos
  void dispose() {
    _authStatusController.close();
  }
}
