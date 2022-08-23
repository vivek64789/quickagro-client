import 'package:flutter_test/flutter_test.dart';
import 'package:quickagro/providers/forgot_password_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/forgot_password.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ForgotPassword, ForgotPasswordProvider, ThemeProvider])
void main() {
  testWidgets('forgot password ...', (tester) async {
    tester.pumpWidget(ForgotPassword());
  });
}
