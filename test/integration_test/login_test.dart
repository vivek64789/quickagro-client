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

    final emailField = find.byKey(Key("email"));
    final passwordField = find.byKey(Key("password"));
    final loginButton = find.byKey(Key("login"));

    await tester.enterText(emailField, "anandkushwaha2074@gmail.com");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.enterText(passwordField, "Test@12345");
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1), () {});
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // In home page

    final firstCategoryCard = find.byKey(Key("categoryCard1"));

    await Future.delayed(const Duration(seconds: 2), () {});
    await tester.tap(firstCategoryCard);
    expect(firstCategoryCard, findsOneWidget);
    await tester.pumpAndSettle();
  });
}
