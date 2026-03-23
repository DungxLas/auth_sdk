import 'package:auth_sdk/main.dart' as app;
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AuthSDK demo shell renders without error', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    check(find.text('AuthSDK Foundation Ready').evaluate()).isNotEmpty();
  });
}
