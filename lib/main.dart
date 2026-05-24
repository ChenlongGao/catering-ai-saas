import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/splash/splash_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const CateringAiSaasApp());
}

class CateringAiSaasApp extends StatelessWidget {
  const CateringAiSaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '餐饮AI管家',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
