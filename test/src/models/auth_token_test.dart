import 'package:auth_sdk/src/models/auth_token.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('AuthToken', () {
    test('isExpired returns false when expiresAt is null', () {
      const token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
      );

      check(token.isExpired).isFalse();
    });

    test('isExpired returns false for a future expiry', () {
      final token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );

      check(token.isExpired).isFalse();
    });

    test('isExpired returns true for a past expiry', () {
      final token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
        expiresAt: DateTime.now().toUtc().subtract(const Duration(seconds: 1)),
      );

      check(token.isExpired).isTrue();
    });

    test('toString contains userId', () {
      const token = AuthToken(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-42',
      );

      check(token.toString()).contains('user-42');
    });
  });
}
