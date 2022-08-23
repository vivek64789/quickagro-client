import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickagro/main.dart' as app;
import 'package:integration_test/integration_test.dart';

// importing application that is needed to test

void main() {
  // adding integration testing flutter binding
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Full App Test", (tester) async {
    // testing the app
    app.main();

    // waiting for app to settle
    await tester.pumpAndSettle();

    final gotoRegister = find.byKey(Key("gotoRegister"));
    final nameField = find.byKey(Key("name"));
    final emailField = find.byKey(Key("email"));
    final passwordField = find.byKey(Key("password"));
    final phoneCode = find.byKey(Key("phoneCode"));
    final phone = find.byKey(Key("phone"));
    final registerButton = find.byKey(Key("registerButton"));

    await tester.tap(gotoRegister);
    await tester.pumpAndSettle();
    await tester.enterText(nameField, "Integration Test");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.enterText(emailField, "inttest2@gmail.com");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.enterText(passwordField, "Test@12345");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.enterText(phoneCode, "977");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.enterText(phone, "9818821313");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
  });
}
