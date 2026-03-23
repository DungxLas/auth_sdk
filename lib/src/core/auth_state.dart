import 'package:auth_sdk/src/errors/auth_exception.dart';

/// Represents every possible state in the authentication lifecycle.
///
/// The state machine transitions follow this path:
/// ```
/// uninitialized → initialising → unauthenticated
///                                     ↓
///                              authenticating → authenticated
///                                                    ↓
///                                            refreshingToken → authenticated
///                                                    ↓ (on failure)
///                                            unauthenticated
///                              authenticated → loggingOut → unauthenticated
/// ```
///
/// Use an exhaustive `switch` expression to handle every state safely.
sealed class AuthState {
  const AuthState();
}

/// The SDK has not yet been initialised. No auth operations are allowed.
final class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

/// The SDK is performing its initialisation routine (e.g. loading stored
/// tokens, validating existing sessions).
final class AuthStateInitialising extends AuthState {
  const AuthStateInitialising();
}

/// No user is authenticated. The SDK is ready to accept a login attempt.
final class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

/// A login attempt is in progress.
final class AuthStateAuthenticating extends AuthState {
  const AuthStateAuthenticating();
}

/// A user is fully authenticated. [userId] identifies the current session.
final class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated({required this.userId});

  /// The ID of the currently authenticated user.
  final String userId;
}

/// A silent token refresh is in progress (the user is still considered
/// authenticated during this time).
final class AuthStateRefreshingToken extends AuthState {
  const AuthStateRefreshingToken({required this.userId});

  /// The ID of the user whose token is being refreshed.
  final String userId;
}

/// A logout operation is in progress.
final class AuthStateLoggingOut extends AuthState {
  const AuthStateLoggingOut();
}

/// An unrecoverable authentication error has occurred.
final class AuthStateError extends AuthState {
  const AuthStateError({required this.exception});

  /// The exception that caused this error state.
  final AuthException exception;
}
