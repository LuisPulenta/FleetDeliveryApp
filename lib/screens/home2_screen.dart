import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbwebsesions_helper.dart';
import 'package:flutter/material.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home2Screen extends StatefulWidget {
  final Usuario user;
  final WebSesion webSesion;

  const Home2Screen({Key? key, required this.user, required this.webSesion})
      : super(key: key);

  @override
  _Home2ScreenState createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  //*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _getprefs();
    _getPosition();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet App'),
        backgroundColor: const Color(0xFF282886),
        centerTitle: true,
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFFFFF),
              Color(0xffFFFFFF),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "assets/logo2.png",
                height: 200,
              ),
              Text(
                'Bienvenido/a ${widget.user.apellidonombre}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0e4888)),
              ),
            ],
          ),
        ));
  }

  Widget _getMenu() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffffffff),
              Color(0xff88a3be),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffffffff),
                    Color(0xffffffff),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    image: AssetImage('assets/logo2.png'),
                    width: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Usuario: ",
                        style: (TextStyle(
                            color: Color(0xff0e4888),
                            fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        widget.user.apellidonombre!,
                        style: (const TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.router,
                color: Color(0xff0e4888),
              ),
              title: const Text('Asignaciones',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: const Color(0xff0e4888),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AsignacionesScreen(
                              user: widget.user,
                              positionUser: _positionUser,
                            )));
              },
            ),
            const Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.map,
                color: Color(0xff0e4888),
              ),
              title: const Text('Asignaciones cercanas (mapa)',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: const Color(0xff0e4888),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AsignacionesTodasMapScreen(
                              user: widget.user,
                              positionUser: _positionUser,
                            )));
              },
            ),
            const Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.equalizer,
                color: Color(0xff0e4888),
              ),
              title: const Text('Estadísticas',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: const Color(0xff8c8c94),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Grafico01Screen(
                              user: widget.user,
                            )));
              },
            ),
            const Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_page,
                color: Color(0xff0e4888),
              ),
              title: const Text('Contacto',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: const Color(0xff8c8c94),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactoScreen()));
              },
            ),
            const Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color(0xff0e4888),
              ),
              tileColor: const Color(0xff8c8c94),
              title: const Text('Cerrar Sesión',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    //------------ Guarda en WebSesion la fecha y hora de salida ----------

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await ApiHelper.putWebSesion(widget.webSesion.nroConexion);
    } else {
      double hora = (DateTime.now().hour * 3600 +
              DateTime.now().minute * 60 +
              DateTime.now().second +
              DateTime.now().millisecond * 0.001) *
          100;
      WebSesion websesion = WebSesion(
          nroConexion: widget.webSesion.nroConexion,
          usuario: widget.webSesion.usuario,
          iP: widget.webSesion.iP,
          loginDate: widget.webSesion.loginDate,
          loginTime: widget.webSesion.loginTime,
          modulo: widget.webSesion.modulo,
          logoutDate: DateTime.now().toString(),
          logoutTime: hora.round(),
          conectAverage: widget.webSesion.conectAverage,
          id_ws: widget.webSesion.id_ws,
          version: widget.webSesion.version);

      await DBWebSesions.update(websesion);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

//*****************************************************************************
//************************** METODO GETPREFS **********************************
//*****************************************************************************

  void _getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  //*****************************************************************************
//************************** METODO GETPOSITION **********************************
//*****************************************************************************

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localización está negado.'),
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
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
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
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }
}
