import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_information/device_information.dart';

import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:fleetdeliveryapp/models/models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  List<Usuario> _usuariosApi = [];
  List<Usuario> _usuarios = [];
  bool _usuariosConseguidos = false;

  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

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

  List<WebSesion> _webSesionsdb = [];

  //String _email = '*jhollman';
  String _email = 'TEST';
  //String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  //String _password = 'jona';
  String _password = '123456';
  //String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _hayInternet = false;
  bool _passwordShow = false;
  bool _showLoader = false;

  String _ultimaactualizacion = '';

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getprefs();

    //_getUsuarios();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

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
                ? LoaderComponent(text: 'Cargando USUARIOS.')
                : Container(),
          )
        ],
      ),
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

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.language),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Web Fleet'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF637893),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _launchURL(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOGIN *************************************
//*****************************************************************************

  void _login() async {
    setState(() {
      _passwordShow = false;
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

    if (filteredUsuario.isEmpty) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Usuario o contraseña incorrectos';
      });
      return;
    }

    _usuarioLogueado = filteredUsuario[0];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('conectadodesde', DateTime.now().toString());
    await prefs.setString(
        'validohasta', DateTime.now().add(Duration(hours: 12)).toString());

    // Agregar registro a bd local websesion

    Random r = new Random();
    int resultado = r.nextInt((99999999 - 10000000) + 1) + 10000000;
    double hora = (DateTime.now().hour * 3600 +
            DateTime.now().minute * 60 +
            DateTime.now().second +
            DateTime.now().millisecond * 0.001) *
        100;

    WebSesion webSesion = WebSesion(
        nroConexion: resultado,
        usuario: _usuarioLogueado.idUser.toString(),
        iP: _imeiNo,
        loginDate: DateTime.now().toString(),
        loginTime: hora.round(),
        modulo: 'App-${_usuarioLogueado.codigo}',
        logoutDate: "",
        logoutTime: 0,
        conectAverage: 0,
        id_ws: 0,
        version: Constants.version);

    DBWebSesions.insertWebSesion(webSesion);

    // Agregar nroConexion a SharedPreferences

    await prefs.setInt('nroConexion', resultado);

    // Si hay internet
    //    - Subir al servidor todos los registros de la bd local websesion
    //    - borrar la bd local websesion

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _webSesionsdb = await DBWebSesions.webSesions();

      _webSesionsdb.forEach((_webSesion) async {
        await _postWebSesion(_webSesion);
      });
      await DBWebSesions.delete();
    }

    if (_usuarioLogueado.codigo == "PQ") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    user: _usuarioLogueado,
                    webSesion: webSesion,
                  )));
    }

    if (_usuarioLogueado.codigo == "TR") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home2Screen(
                    user: _usuarioLogueado,
                    webSesion: webSesion,
                  )));
    }
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

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

//*****************************************************************************
//*********************** METODO GETUSUARIOS **********************************
//*****************************************************************************
  Future<Null> _getUsuarios() async {
    if ((_ultimaactualizacion == "null") ||
        (DateTime.parse(_ultimaactualizacion)
            .isBefore(DateTime.now().add(Duration(days: -5))))) {
      setState(() {
        _showLoader = true;
      });

      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        _usuariosConseguidos = false;

        do {
          Response response = await ApiHelper.getUsuarios();

          if (response.isSuccess) {
            _usuariosApi = response.result;
            _hayInternet = true;
            _usuariosConseguidos = true;
          }
        } while (_usuariosConseguidos == false);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('ultimaactualizacion',
            DateTime.now().add(Duration(days: 0)).toString());

        var a = 1;
      } else {
        setState(() {
          _showLoader = false;
        });

        await showAlertDialog(
            context: context,
            title: 'Error',
            message:
                "Debe actualizar la Tabla Usuarios. Por favor arranque la App desde un lugar con acceso a Internet para poder conectarse al Servidor.",
            actions: <AlertDialogAction>[
              AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        return;
      }
    }

    _getTablaUsuarios();
    return;
  }

  //-------------------------------------------------------------------------

  void _getTablaUsuarios() async {
    void _insertUsuarios() async {
      if (_usuariosApi.isNotEmpty) {
        DBUsuarios.delete();
        _usuariosApi.forEach((element) {
          DBUsuarios.insertUsuario(element);
        });
      }
    }

    if (_hayInternet) {
      _insertUsuarios();
    }

    _usuarios = await DBUsuarios.usuarios();

    if (_usuarios.isEmpty) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              "La tabla Usuarios local está vacía. Por favor arranque la App desde un lugar con acceso a Internet para poder conectarse al Servidor.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      SystemNavigator.pop();
      return;
    }

    setState(() {
      _showLoader = false;
    });
  }

  //-------------------------------------------------------------------------

//*****************************************************************************
//************************** METODO GETPREFS **********************************
//*****************************************************************************

  void _getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ultimaactualizacion = prefs.getString('ultimaactualizacion').toString();
    _getUsuarios();
  }

  void _launchURL() async {
    if (!await launch('http://www.fleetsa.com.ar:99/LoginForm'))
      throw 'No se puede conectar a la Web de Fleet';
  }

//*****************************************************************************
//************************** METODO INITPLATFORMSTATE *************************
//*****************************************************************************

  Future<void> initPlatformState() async {
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.

    var status = await Permission.phone.status;

    if (status.isDenied) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Aviso'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                    'La App necesita que habilite el Permiso de acceso al teléfono para registrar el IMEI del celular con que se loguea.'),
                SizedBox(
                  height: 10,
                ),
              ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok')),
              ],
            );
          });
      openAppSettings();
      //exit(0);
    }

    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;
    } on PlatformException catch (e) {
      platformVersion = '${e.message}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = "Running on :$platformVersion";
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
      _apiLevel = apiLevel;
      _deviceName = deviceName;
      _productName = productName;
      _cpuType = cpuType;
      _hardware = hardware;
    });
  }

//*****************************************************************************
//******************** METODO POSTWEBSESION ***********************************
//*****************************************************************************

  Future<void> _postWebSesion(WebSesion webSesion) async {
    Map<String, dynamic> requestWebSesion = {
      'nroConexion': webSesion.nroConexion,
      'usuario': webSesion.usuario,
      'iP': webSesion.iP,
      'loginDate': webSesion.loginDate,
      'loginTime': webSesion.loginTime,
      'modulo': webSesion.modulo,
      'logoutDate': webSesion.logoutDate,
      'logoutTime': webSesion.logoutTime,
      'conectAverage': webSesion.conectAverage,
      'id_ws': webSesion.id_ws,
      'version': webSesion.version,
    };

    Response response =
        await ApiHelper.post('/api/WebSesions/', requestWebSesion);
  }
}
