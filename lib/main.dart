import 'dart:convert';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

//-----Main-----

final navigatorKey = GlobalKey<NavigatorState>();
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //--------------------------------------------------------
  //--------------------- Variables ------------------------
  //--------------------------------------------------------

  late Usuario _user;
  late WebSesion _webSesion;
  bool _showLoginPage = true;
  bool _isLoading = true;

  //--------------------------------------------------------
  //--------------------- initState ------------------------
  //--------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getHome();
  }

  //--------------------------------------------------------
  //--------------------- Pantalla ------------------------
  //--------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
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
      navigatorKey: navigatorKey,
      home: _isLoading
          ? const WaitScreen()
          : _showLoginPage
              ? const LoginScreen()
              : _user.codigo == "PQ"
                  ? HomeScreen(
                      user: _user,
                      webSesion: _webSesion,
                    )
                  : Home2Screen(
                      user: _user,
                      webSesion: _webSesion,
                    ),
    );
  }

  //--------------------------------------------------------
  //--------------------- _getHome -------------------------
  //--------------------------------------------------------

  void _getHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isRemembered = prefs.getBool('isRemembered') ?? false;

    if (isRemembered) {
      String? usuario = prefs.getString('usuario');
      String? webs = prefs.getString('websesion');
      String date = prefs.getString('date').toString();
      String dateAlmacenada = date.substring(0, 10);
      String dateActual = DateTime.now().toString().substring(0, 10);
      bool usuariosConseguidos = prefs.getBool('usuariosconseguidos') ?? false;

      if (usuario != null) {
        var decodedJson = jsonDecode(usuario);
        _user = Usuario.fromJson(decodedJson);

        var decodedJson2 = jsonDecode(webs!);
        _webSesion = WebSesion.fromJson(decodedJson2);

        if (dateAlmacenada != dateActual || !usuariosConseguidos) {
          _showLoginPage = true;
        } else {
          _showLoginPage = false;
        }
      }
    }

    _isLoading = false;
    setState(() {});
  }
}
