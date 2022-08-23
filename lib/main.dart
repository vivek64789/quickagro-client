import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/providers/fingerprint_provider.dart';
import 'package:quickagro/providers/notification_provider.dart';
import 'package:quickagro/providers/proximity_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/chat_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/forgot_password_provider.dart';
import 'package:quickagro/providers/order_provider.dart';
import 'package:quickagro/providers/payment_provider.dart';
import 'package:quickagro/providers/search_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/splash_screen.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<NotificationProvider>(
              create: (_) => NotificationProvider()),
          ChangeNotifierProvider<FingerprintProvider>(
              create: (_) => FingerprintProvider()),
          ChangeNotifierProvider<ProximityProvider>(
              create: (_) => ProximityProvider()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ChangeNotifierProvider<UserProfileProvider>(
              create: (_) => UserProfileProvider()),
          ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
          ChangeNotifierProvider<PaymentProvider>(
              create: (_) => PaymentProvider()),
          ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
          ChangeNotifierProvider<SearchProvider>(
              create: (_) => SearchProvider()),
          ChangeNotifierProvider<ForgotPasswordProvider>(
              create: (_) => ForgotPasswordProvider()),
        ],
        child: Builder(
          builder: (context) => GetMaterialApp(
            key: Key('main'),
            debugShowCheckedModeBanner: false,
            color: primaryColor,
            theme: ThemeData(primarySwatch: Colors.green).copyWith(
              scaffoldBackgroundColor:
                  Provider.of<ThemeProvider>(context).scaffoldColor,
              textTheme: GoogleFonts.poppinsTextTheme(),
              primaryColor: primaryColor,
            ),
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}
