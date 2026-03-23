/// AuthSDK — Flutter Authentication SDK.
///
/// Provides a single, stable public surface for all authentication
/// operations. Internal implementation details live under `src/` and
/// are intentionally hidden from consumers.
///
/// Quick start:
/// ```dart
/// import 'package:auth_sdk/auth_sdk.dart';
///
/// // 1. Initialise once at app startup.
/// await AuthSDK.initialize(
///   tenantId: 'my-tenant',
///   provider: MyAuthProvider(),
/// );
///
/// // 2. Use the singleton instance anywhere.
/// await AuthSDK.instance.login(email, password);
///
/// // 3. React to state changes.
/// AuthSDK.instance.authStateStream.listen((state) { ... });
/// ```
library;

export 'src/core/auth_state.dart';
export 'src/errors/auth_exception.dart';
export 'src/models/auth_token.dart';
export 'src/providers/auth_provider.dart';
