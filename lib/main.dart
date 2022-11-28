import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ms_supplier_app/auth/supplier_login.dart';
import 'package:ms_supplier_app/auth/supplier_signup.dart';
import 'package:ms_supplier_app/firebase_options.dart';
import 'package:ms_supplier_app/main_screens/onboarding_screen.dart';
import 'package:ms_supplier_app/main_screens/supplier_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: WelcomeScreen(),
      initialRoute: '/onboarding_screen',
      routes: {
        '/onboarding_screen': (context) => const OnboardingScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
      },
    );
  }
}
