import 'package:auth_sdk/src/core/auth_state.dart';
import 'package:auth_sdk/src/errors/auth_exception.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('AuthState sealed classes', () {
    test('AuthStateUninitialized is an AuthState', () {
      const AuthState state = AuthStateUninitialized();
      check(state).isA<AuthStateUninitialized>();
    });

    test('AuthStateAuthenticated carries userId', () {
      const state = AuthStateAuthenticated(userId: 'user-42');
      check(state.userId).equals('user-42');
    });

    test('AuthStateRefreshingToken carries userId', () {
      const state = AuthStateRefreshingToken(userId: 'user-42');
      check(state.userId).equals('user-42');
    });

    test('AuthStateError carries the exception', () {
      const exception = AuthException(
        code: AuthErrorCode.refreshFailed,
        message: 'Refresh failed',
      );
      const state = AuthStateError(exception: exception);

      check(state.exception.code).equals(AuthErrorCode.refreshFailed);
    });

    test('exhaustive switch compiles and covers all states', () {
      // Verifies that the sealed hierarchy is complete.
      String describe(AuthState state) => switch (state) {
        AuthStateUninitialized() => 'uninitialized',
        AuthStateInitialising() => 'initialising',
        AuthStateUnauthenticated() => 'unauthenticated',
        AuthStateAuthenticating() => 'authenticating',
        AuthStateAuthenticated() => 'authenticated',
        AuthStateRefreshingToken() => 'refreshingToken',
        AuthStateLoggingOut() => 'loggingOut',
        AuthStateError() => 'error',
      };

      check(describe(const AuthStateUninitialized())).equals('uninitialized');
      check(
        describe(const AuthStateAuthenticated(userId: 'u')),
      ).equals('authenticated');
    });
  });
}
