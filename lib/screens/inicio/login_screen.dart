import 'dart:convert';
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
  //--------------------------------------------------------
  //--------------------- Variables ------------------------
  //--------------------------------------------------------

  List<Usuario> _usuariosApi = [];
  List<Usuario> _usuarios = [];
  bool _usuariosConseguidos = false;

  bool _rememberme = true;

  Modulo _modulo = Modulo(
      idModulo: 0,
      nombre: '',
      nroVersion: '',
      link: '',
      fechaRelease: '',
      actualizOblig: 0);

  String _imeiNo = "";

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
      centroDistribucion: 0,
      dni: '');

  List<WebSesion> _webSesionsdb = [];

  // String _email = '';
  // String _password = '';

  //String _email = 'jona';
  //String _password = '123456';

  String _email = 'TEST';
  String _password = '123456';

  String _emailError = '';
  bool _emailShowError = false;

  String _passwordError = '';
  bool _passwordShowError = false;

  bool _hayInternet = false;
  bool _passwordShow = false;
  bool _showLoader = false;

  String _ultimaactualizacion = '';

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getprefs();
  }

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd3a735),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              decoration: const BoxDecoration(
                // ignore: unnecessary_const
                gradient: const LinearGradient(
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
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/logo2.png",
                    height: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.version,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Transform.translate(
            offset: const Offset(0, -60),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.grey,

                  //  const Color(
                  //   (0xffb3b3b4),
                  // ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _showEmail(),
                        _showPassword(),
                        const SizedBox(
                          height: 10,
                        ),
                        _showRememberme(),
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
                ? const LoaderComponent(text: 'Cargando USUARIOS.')
                : Container(),
          )
        ],
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _showEmail -------------------------
//----------------------------------------------------------

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Usuario...',
            labelText: 'Usuario',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _showPassword ----------------------
//----------------------------------------------------------

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Contraseña...',
            labelText: 'Contraseña',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _passwordShow
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
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

//----------------------------------------------------------
//--------------------- _showButtons -----------------------
//----------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.login),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Iniciar Sesión'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF282886),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _login(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.language),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Web Fleet'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF637893),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _launchURL(),
                ),
              ),
            ],
          ),
          _modulo.nroVersion != '' && _modulo.nroVersion != Constants.version
              ? const SizedBox(
                  height: 20,
                )
              : Container(),
          _modulo.nroVersion != '' && _modulo.nroVersion != Constants.version
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('   Nueva versión disponible   ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _launchURL2(),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _showRememberme --------------------
//----------------------------------------------------------

  _showRememberme() {
    return CheckboxListTile(
      activeColor: const Color(0xFF282886),
      title: const Text('Recordarme:'),
      value: _rememberme,
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

//----------------------------------------------------------
//--------------------- _login -----------------------------
//----------------------------------------------------------

  void _login() async {
    if (_modulo.nroVersion != '' && _modulo.nroVersion != Constants.version) {
      await showAlertDialog(
          context: context,
          title: 'Atención!',
          message:
              "Debe instalar la nueva versión disponible en Google Play para poder continuar.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

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

    String body = jsonEncode(_usuarioLogueado);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('conectadodesde', DateTime.now().toString());
    await prefs.setString('validohasta',
        DateTime.now().add(const Duration(hours: 12)).toString());
    await prefs.setBool('sincronizar', true);

    // Agregar registro a bd local websesion

    Random r = Random();
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

    String wsesion = jsonEncode(webSesion);

    if (_rememberme) {
      _storeUser(body, wsesion);
    }

    // Si hay internet
    //    - Subir al servidor todos los registros de la bd local websesion
    //    - borrar la bd local websesion

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _webSesionsdb = await DBWebSesions.webSesions();

      for (var _webSesion in _webSesionsdb) {
        await _postWebSesion(_webSesion);
      }
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

//----------------------------------------------------------
//--------------------- validateFields ---------------------
//----------------------------------------------------------

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

//----------------------------------------------------------
//--------------------- _getUsuarios -----------------------
//----------------------------------------------------------

  Future<void> _getUsuarios() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      Response response2 = await ApiHelper.getModulo("4");
      _modulo = response2.result;
    }

    if ((_ultimaactualizacion == "null") ||
        (DateTime.parse(_ultimaactualizacion)
            .isBefore(DateTime.now().add(const Duration(days: -1))))) {
      setState(() {
        _showLoader = true;
      });

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
            DateTime.now().add(const Duration(days: 0)).toString());
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
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);

        return;
      }
    }

    _getTablaUsuarios();
    return;
  }

  //-------------------------------------------------------------------------

  void _getTablaUsuarios() async {
    if (_hayInternet) {
      if (_usuariosApi.isNotEmpty) {
        DBUsuarios.delete();
        for (var element in _usuariosApi) {
          await DBUsuarios.insertUsuario(element);
        }
      }
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      SystemNavigator.pop();
      return;
    }

    setState(() {
      _showLoader = false;
    });
  }

//----------------------------------------------------------
//--------------------- _getprefs --------------------------
//----------------------------------------------------------

  void _getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ultimaactualizacion = prefs.getString('ultimaactualizacion').toString();
    _getUsuarios();
  }

  void _launchURL() async {
    if (!await launch('http://www.deliveryfleet.com.ar:99/LoginForm')) {
      throw 'No se puede conectar a la Web de Fleet';
    }
  }

  void _launchURL2() async {
    if (!await launch(
        'https://play.google.com/store/apps/details?id=com.luisnu.fleetdeliveryapp')) {
      throw 'No se puede conectar a la tienda';
    }
  }

//----------------------------------------------------------
//--------------------- initPlatformState ------------------
//----------------------------------------------------------

  Future<void> initPlatformState() async {
    late String imeiNo = '';

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
              title: const Text('Aviso'),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('''
                        Debe habilitar los permisos:
                        - Almacenamiento
                        - Cámara
                        - Teléfono
                        - Ubicación
                        '''),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      openAppSettings();
      //exit(0);
    }

    try {
      imeiNo = await DeviceInformation.deviceIMEINumber;
    } on PlatformException catch (e) {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imeiNo = imeiNo;
    });
  }

//----------------------------------------------------------
//--------------------- _postWebSesion ---------------------
//----------------------------------------------------------

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

    await ApiHelper.post('/api/WebSesions/', requestWebSesion);
  }

//----------------------------------------------------------
//--------------------- _storeUser -------------------------
//----------------------------------------------------------

  void _storeUser(String body, String wsesion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('usuario', body);
    await prefs.setString('websesion', wsesion);
    await prefs.setString('date', DateTime.now().toString());
    await prefs.setBool('usuariosconseguidos', _usuariosConseguidos);
  }
}
