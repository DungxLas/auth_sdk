/// Immutable value object holding the access/refresh token pair returned
/// by a successful authentication operation.
final class AuthToken {
  /// Creates an [AuthToken].
  ///
  /// [expiresAt] is the UTC time at which [accessToken] becomes invalid.
  /// Pass `null` if the provider does not expose an expiry time.
  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    this.expiresAt,
  });

  /// Short-lived token used to authorise API requests.
  final String accessToken;

  /// Long-lived token used to obtain a new [accessToken] without re-login.
  final String refreshToken;

  /// The identifier of the authenticated user this token belongs to.
  final String userId;

  /// UTC datetime at which [accessToken] expires, or `null` if unknown.
  final DateTime? expiresAt;

  /// Returns `true` when the access token is past its expiry time.
  ///
  /// Always returns `false` when [expiresAt] is `null` because we cannot
  /// determine expiry without that information.
  bool get isExpired {
    if (expiresAt == null) {
      return false;
    }
    return DateTime.now().toUtc().isAfter(expiresAt!);
  }

  @override
  String toString() =>
      'AuthToken(userId: $userId, expiresAt: $expiresAt, '
      'isExpired: $isExpired)';
}
