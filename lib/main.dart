import 'package:flutter/material.dart';

void main() => runApp(const _App());

/// Minimal entry point kept intentionally empty — the auth logic
/// lives in the SDK layer, not in this demo shell.
class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AuthSDK Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    home: const Scaffold(
      body: Center(child: Text('AuthSDK Foundation Ready')),
    ),
  );
}
