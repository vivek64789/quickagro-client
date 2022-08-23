// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:quickagro/providers/auth_provider.dart';
// import 'package:quickagro/providers/fingerprint_provider.dart';
// import 'package:quickagro/providers/theme_provider.dart';
// import 'package:quickagro/screens/login.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';

// import '../providers/auth_provider_test.mocks.dart';
// import 'login_test.mocks.dart';

// @GenerateMocks([
//   Login,
//   ThemeProvider,
//   FingerprintProvider
// ], 
// // customMocks: [
// //   MockSpec<Login>(
// //      as: #MockLogin,
// //     returnNullOnMissingStub: true,
// //   ),
// // ]
// )
// void main() {
//   var mockLogin = Login();
//   var mockThemeProvider = ThemeProvider();
//   var mockFingerprintProvider = FingerprintProvider();
//   var mockAuthProvider = AuthProvider();
//   setUpAll(() {
//     mockLogin = MockLogin();
//     mockThemeProvider = MockThemeProvider();
//     mockFingerprintProvider = MockFingerprintProvider();
//     mockAuthProvider = MockAuthProvider();
//   });

//   testWidgets('login ...', (tester) async {
//     // when(mockLogin.);
//     when(mockFingerprintProvider.getFingerprintSharedPreferences())
//         .thenAnswer((realInvocation) => true);
//     when(mockFingerprintProvider.isFingerprintEnabled)
//         .thenAnswer((realInvocation) => true);
//     when(mockThemeProvider.textColor)
//         .thenAnswer((realInvocation) => Colors.white);
//     tester.pumpWidget(MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => mockAuthProvider),
//         ChangeNotifierProvider(create: (_) => mockThemeProvider),
//         ChangeNotifierProvider(create: (_) => mockFingerprintProvider),
//       ],
//       child: GetMaterialApp(
//         key: Key('main'),

//         home: Directionality(key: Key("directionality"), textDirection: TextDirection.ltr ,child: mockLogin),
//       ),
//     ));
//   });
// }
