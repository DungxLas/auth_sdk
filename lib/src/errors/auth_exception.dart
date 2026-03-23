/// Typed exception for all authentication-related errors in the SDK.
///
/// Use [AuthErrorCode] constants for the [code] field to ensure
/// consumers can handle errors programmatically without string matching.
///
/// Example:
/// ```dart
/// try {
///   await sdk.login(email, password);
/// } on AuthException catch (e) {
///   if (e.code == AuthErrorCode.invalidCredentials) {
///     // Show "Wrong email or password" message.
///   }
/// }
/// ```
class AuthException implements Exception {
  /// Creates an [AuthException] with a machine-readable [code] and a
  /// human-readable [message].
  const AuthException({
    required this.code,
    required this.message,
    this.originalError,
  });

  /// Machine-readable error code. Use constants from [AuthErrorCode].
  final String code;

  /// Human-readable description of the error.
  final String message;

  /// The underlying error that caused this exception, if any.
  final Object? originalError;

  @override
  String toString() => 'AuthException($code): $message';
}

/// Well-known error codes emitted by [AuthException].
///
/// Using constants prevents typos and enables exhaustive switch handling.
abstract final class AuthErrorCode {
  /// The supplied credentials (e.g. email/password) are wrong.
  static const String invalidCredentials = 'INVALID_CREDENTIALS';

  /// The access token has expired and a refresh is required.
  static const String tokenExpired = 'TOKEN_EXPIRED';

  /// The token refresh attempt failed (e.g. refresh token revoked).
  static const String refreshFailed = 'REFRESH_FAILED';

  /// A network error occurred while communicating with the backend.
  static const String networkError = 'NETWORK_ERROR';

  /// The session has been revoked server-side (e.g. forced logout).
  static const String sessionRevoked = 'SESSION_REVOKED';

  /// The SDK has not been initialised before use.
  static const String notInitialised = 'NOT_INITIALISED';
}
