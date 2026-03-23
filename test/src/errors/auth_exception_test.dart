import 'package:auth_sdk/src/errors/auth_exception.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('AuthException', () {
    test('stores code and message', () {
      const exception = AuthException(
        code: AuthErrorCode.invalidCredentials,
        message: 'Wrong password',
      );

      check(exception.code).equals(AuthErrorCode.invalidCredentials);
      check(exception.message).equals('Wrong password');
      check(exception.originalError).isNull();
    });

    test('stores originalError when provided', () {
      final original = Exception('network timeout');
      final exception = AuthException(
        code: AuthErrorCode.networkError,
        message: 'Network failed',
        originalError: original,
      );

      check(exception.originalError).isNotNull();
    });

    test('toString includes code and message', () {
      const exception = AuthException(
        code: AuthErrorCode.tokenExpired,
        message: 'Token is expired',
      );

      check(exception.toString())
        ..contains(AuthErrorCode.tokenExpired)
        ..contains('Token is expired');
    });
  });

  group('AuthErrorCode', () {
    test('all expected constants are defined', () {
      check(AuthErrorCode.invalidCredentials).equals('INVALID_CREDENTIALS');
      check(AuthErrorCode.tokenExpired).equals('TOKEN_EXPIRED');
      check(AuthErrorCode.refreshFailed).equals('REFRESH_FAILED');
      check(AuthErrorCode.networkError).equals('NETWORK_ERROR');
      check(AuthErrorCode.sessionRevoked).equals('SESSION_REVOKED');
      check(AuthErrorCode.notInitialised).equals('NOT_INITIALISED');
    });
  });
}
