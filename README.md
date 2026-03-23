# AuthSDK 🔐

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white)

A Flutter Authentication SDK for mobile apps that centralizes authentication
logic, token lifecycle, and session management.

---

## 🌟 Overview

`auth_sdk` is a drop-in authentication solution for Flutter applications. It
handles complex auth flows reliably and exposes a clean, stable public API.

**Core responsibilities:**

- 🛡️ Authentication lifecycle management (login, logout, session restore)
- 🔑 Token management (access / refresh tokens, auto-refresh, concurrency lock)
- 💾 Secure token storage (`flutter_secure_storage`)
- 📡 Auth state stream for reactive UI updates
- 🏢 Multi-tenant / multi-instance support

---

## 🏗️ Architecture

```
lib/
├── auth_sdk.dart          ← Single public entry point (barrel export)
└── src/
    ├── core/              ← Auth State Machine
    ├── errors/            ← Typed exceptions & error codes
    ├── models/            ← Immutable data models (AuthToken, …)
    ├── providers/         ← AuthProvider interface (pluggable backends)
    ├── token/             ← TokenManager + Concurrency Lock  [coming soon]
    ├── session/           ← SessionManager                   [coming soon]
    ├── registry/          ← Multi-instance registry          [coming soon]
    └── utils/             ← Shared utilities                 [coming soon]
```

For full technical specifications, see
[auth_sdk_technical_design.md](./auth_sdk_technical_design.md).

---

## 📖 Business Documentation (`lib_doc/`)

The `lib_doc/` folder contains **business-rule documentation** that mirrors
the `lib/` structure. Each `.dart` file has a corresponding `.md` file
describing its **purpose, business rules, data flows, and UI implications** —
without any code.

```
lib_doc/
├── auth_sdk.md
└── src/
    ├── core/auth_state.md
    ├── errors/auth_exception.md
    ├── models/auth_token.md
    └── providers/auth_provider.md
```

> `lib_doc/` is the **source of truth** for business requirements. Always read
> it before modifying or extending the SDK.

---

## 🚀 Getting Started

### 1. Initialization

```dart
import 'package:auth_sdk/auth_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthSDK.initialize(
    tenantId: 'my-tenant',
    provider: MyAuthProvider(),
  );

  runApp(MyApp());
}
```

### 2. Login

```dart
try {
  await AuthSDK.instance.login(email, password);
} on AuthException catch (e) {
  print('Login failed: ${e.message}');
}
```

### 3. Listening to Auth State

```dart
AuthSDK.instance.authStateStream.listen((state) {
  switch (state) {
    case AuthStateAuthenticated(:final userId):
      // Navigate to home
    case AuthStateUnauthenticated():
      // Navigate to login
    // … handle all states
  }
});
```

### 4. Logout

```dart
await AuthSDK.instance.logout();
```

---

## 🤖 AI Workflows (Antigravity IDE)

This project uses structured AI workflows defined in `.agents/workflows/`.

| Command | Description |
|---|---|
| `/create_feature <name>` | Create a new feature following the 7-step workflow (code → test → lint → sync docs) |
| `/run_checks` | Run format + analyze + tests + lib_doc sync check |
| `/update_doc` | Update `lib_doc/` documentation without creating new code |

---

## 🔒 Security Highlights

- Tokens stored in `flutter_secure_storage` (Keychain / EncryptedSharedPreferences)
- Refresh Concurrency Lock — only one refresh request in-flight at a time
- JWT expiration validated locally before API calls
- Full token cleanup on logout

---

## 🛠️ Roadmap

- [x] Phase 1 — SDK Foundation (AuthState, AuthToken, AuthProvider, AuthException)
- [ ] Phase 2 — Authentication Flow (AuthSDKCore, SessionManager)
- [ ] Phase 3 — Token Management (TokenManager, Concurrency Lock)
- [ ] Phase 4 — Multi-Instance Registry
- [ ] Phase 5 — Security Improvements (JWT validation, token rotation)
- [ ] Phase 6 — Stabilisation & production readiness

---

## 📝 License

MIT License — see the LICENSE file for details.
