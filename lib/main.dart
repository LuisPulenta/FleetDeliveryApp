import 'package:flutter/material.dart';
import 'package:fleetdeliveryapp/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('es')],
      debugShowCheckedModeBanner: false,
      title: 'Fleet Delivery App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF781f1e),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF242424), foregroundColor: Colors.white),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
      ),
      home: const LoginScreen(),
    );
  }
}
