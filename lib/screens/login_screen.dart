import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/models/ruta.dart';
import 'package:fleetdeliveryapp/screens/components/loader_component.dart';
import 'package:fleetdeliveryapp/screens/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/screens/helpers/constants.dart';
import 'package:fleetdeliveryapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<Usuario> _usuariosApi = [];
  List<Usuario> _usuarios = [];

  Usuario _usuarioLogueado = Usuario(
      idUser: 0,
      codigo: '',
      apellidonombre: '',
      usrlogin: '',
      usrcontrasena: '',
      habilitadoWeb: 0,
      vehiculo: '',
      dominio: '',
      celular: '',
      orden: 0,
      centroDistribucion: 0);

  String _email = '*MARCHIONNE';
  String _emailError = '';
  bool _emailShowError = false;
  bool _hayInternet = false;

  String _password = 'FRANCO';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;

  bool _passwordShow = false;

  bool _showLoader = false;

  Color colorUsuarios = Color(0xff9e9e9e);

  @override
  void initState() {
    super.initState();
    _getUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd3a735),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(
                      (0xfff6faf8),
                    ),
                    Color(
                      (0xfff6faf8),
                    ),
                  ],
                ),
              ),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/logo2.png",
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Constants.version,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Container(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Usuarios:",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Icon(
                      Icons.radio_button_checked,
                      size: 12,
                      color: colorUsuarios,
                    ),
                  ],
                ),
              ],
            ),
          )),
          Transform.translate(
            offset: Offset(0, -60),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  color: Color(
                    (0xffb3b3b4),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _showEmail(),
                        _showPassword(),
                        SizedBox(
                          height: 10,
                        ),
                        //_showRememberme(),
                        _showButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: _showLoader
                ? LoaderComponent(text: 'Por favor espere...')
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/logo.png'),
      width: 300,
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Usuario...',
            labelText: 'Usuario',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Contraseña...',
            labelText: 'Contraseña',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _passwordShow
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordShow = !_passwordShow;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  // _showRememberme() {
  //   return CheckboxListTile(
  //     title: Text('Recordarme:'),
  //     value: _rememberme,
  //     onChanged: (value) {
  //       setState(() {
  //         _rememberme = value!;
  //       });
  //     },
  //   );
  // }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Iniciar Sesión'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF282886),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _login(),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    setState(() {
      _passwordShow = false;
    });

    setState(() {
      _showLoader = true;
    });

    if (!validateFields()) {
      setState(() {
        _showLoader = false;
      });
      return;
    }

    List<Usuario> filteredUsuario = [];
    for (var usuario in _usuarios) {
      if (usuario.usrlogin.toString().toLowerCase() == (_email.toLowerCase()) &&
          usuario.usrcontrasena.toString().toLowerCase() ==
              (_password.toLowerCase())) {
        filteredUsuario.add(usuario);
      }
    }

    if (filteredUsuario.length == 0) {
      setState(() {
        _showLoader = true;
      });
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Usuario o contraseña incorrectos';
      });
      return;
    }

    _usuarioLogueado = filteredUsuario[0];

    // if (_rememberme) {
    //   _storeUser(_usuarioLogueado);
    // }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('conectadodesde', DateTime.now().toString());
    await prefs.setString(
        'validohasta', DateTime.now().add(new Duration(hours: 12)).toString());
    await prefs.setString('ultimaactualizacion', DateTime.now().toString());

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  user: _usuarioLogueado,
                )));
  }

  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Usuario';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValid;
  }

  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
    await prefs.setString('date', DateTime.now().toString());
  }

//Future<Null>
  _getUsuarios() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.getUsuarios();

      if (response.isSuccess) {
        _usuariosApi = response.result;
        // _usuariosApi.sort((a, b) {
        //   return a.apellidonombre
        //       .toString()
        //       .toLowerCase()
        //       .compareTo(b.apellidonombre.toString().toLowerCase());
        // });
        _hayInternet = true;
      }
    }
    _getTablaUsuarios();
    return;
  }

  void _getTablaUsuarios() async {
    final Future<Database> database = openDatabase(
      p.join(await getDatabasesPath(), 'usuarios.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE usuarios(idUser INTEGER PRIMARY KEY, codigo TEXT, apellidonombre TEXT, usrlogin TEXT, usrcontrasena TEXT,  habilitadoWeb INTEGER, vehiculo TEXT, dominio TEXT, celular TEXT, orden INTEGER, centroDistribucion INTEGER)",
        );
      },
      version: 1,
    );

    Future<void> insertUsuario(Usuario usuario) async {
      final Database db = await database;
      await db.insert(
        'usuarios',
        usuario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    void _insertUsuarios() async {
      if (_usuariosApi.length > 0) {
        _usuariosApi.forEach((element) {
          insertUsuario(element);
        });
      }
    }

    Future<List<Usuario>> _getUsuariosSQLite() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('usuarios');
      return List.generate(
        maps.length,
        (i) {
          return Usuario(
            idUser: maps[i]['idUser'],
            codigo: maps[i]['codigo'],
            apellidonombre: maps[i]['apellidonombre'],
            usrlogin: maps[i]['usrlogin'],
            usrcontrasena: maps[i]['usrcontrasena'],
            habilitadoWeb: maps[i]['habilitadoWeb'],
            vehiculo: maps[i]['vehiculo'],
            dominio: maps[i]['dominio'],
            celular: maps[i]['celular'],
            orden: maps[i]['orden'],
            centroDistribucion: maps[i]['centroDistribucion'],
          );
        },
      );
    }

    if (_hayInternet) {
      _insertUsuarios();
    }

    _usuarios = await _getUsuariosSQLite();

    if (_usuarios.length > 0) {
      setState(() {
        colorUsuarios = Colors.green;
      });
    }

    setState(() {
      _showLoader = false;
    });
  }
}
