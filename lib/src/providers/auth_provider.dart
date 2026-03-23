import 'package:auth_sdk/src/models/auth_token.dart';

/// Contract that every authentication backend must satisfy.
///
/// Implement this interface to plug in a concrete backend — Firebase,
/// a custom REST API, a mock for testing, and so on — without touching
/// the SDK core.
///
/// Example:
/// ```dart
/// class FirebaseAuthProvider implements AuthProvider {
///   @override
///   Future<AuthToken> login(String email, String password) async {
///     final credential = await FirebaseAuth.instance
///         .signInWithEmailAndPassword(email: email, password: password);
///     // Map Firebase credential → AuthToken.
///     ...
///   }
///   ...
/// }
/// ```
abstract interface class AuthProvider {
  /// Attempts to sign in with [email] and [password].
  ///
  /// Returns an [AuthToken] on success.
  /// Throws [AuthException] on failure.
  Future<AuthToken> login(String email, String password);

  /// Signs the current user out and invalidates the session on the backend.
  ///
  /// Throws [AuthException] if the operation fails.
  Future<void> logout();

  /// Uses [refreshToken] to obtain a new [AuthToken].
  ///
  /// Throws [AuthException] with code [AuthErrorCode.refreshFailed] when the
  /// refresh token is invalid or expired.
  Future<AuthToken> refreshToken(String refreshToken);
}
