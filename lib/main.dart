import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modern_login_ui/AdminPanelScreen.dart';
import 'package:flutter_modern_login_ui/features/error_page/presentation/error_page.dart';
import 'package:flutter_modern_login_ui/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBJBeVjkWdzSmXzhLMbcOFKYy_58Rdv4IE",
            authDomain: "prognoz-73d69.firebaseapp.com",
            databaseURL: "https://prognoz-73d69-default-rtdb.firebaseio.com",
            projectId: "prognoz-73d69",
            storageBucket: "prognoz-73d69.firebasestorage.app",
            messagingSenderId: "594892812245",
            appId: "1:594892812245:web:885f11f03ae99ac1c1975c",
            measurementId: "G-ETZL4597K6"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyAppController());
}

class MyAppController extends StatefulWidget {
  const MyAppController({super.key});

  @override
  State<MyAppController> createState() => _MyAppControllerState();
}

class _MyAppControllerState extends State<MyAppController> {
  Locale? _locale;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyApp(
      locale: _locale,
      setLocale: _setLocale,
    );
  }
}

class MyApp extends StatelessWidget {
  final Locale? locale;
  final Function(Locale) setLocale;

  const MyApp({super.key, this.locale, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/admin': (context) => AdminPanelScreen(setLocale: setLocale),
        '/login': (context) => LoginScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(),
        );
      },
    );
  }
}
