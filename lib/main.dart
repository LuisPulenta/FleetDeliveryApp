import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
  late Usuario _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fleet Delivery App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF781f1e),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF242424), foregroundColor: Colors.white),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[300]),
      ),
      home: LoginScreen(),
    );
  }
}
