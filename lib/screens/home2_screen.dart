import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home2Screen extends StatefulWidget {
  final Usuario user;

  Home2Screen({required this.user});

  @override
  _Home2ScreenState createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
  @override

//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  Position _positionUser = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  Usuario _user = Usuario(
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

  String _conectadodesde = '';
  String _validohasta = '';
  String _ultimaactualizacion = '';

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _getprefs();
    _getPosition();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fleet App'),
        backgroundColor: Color(0xFF282886),
        centerTitle: true,
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 60),
        decoration: BoxDecoration(
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "assets/logo2.png",
                height: 200,
              ),
              Text(
                'Bienvenido/a ${widget.user.apellidonombre}',
                style: TextStyle(
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
        decoration: BoxDecoration(
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
              decoration: BoxDecoration(
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
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: AssetImage('assets/logo2.png'),
                    width: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Usuario: ",
                        style: (TextStyle(
                            color: Color(0xff0e4888),
                            fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        widget.user.apellidonombre!,
                        style: (TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.router,
                color: Color(0xff0e4888),
              ),
              title: Text('Asignaciones',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: Color(0xff0e4888),
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
            Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.equalizer,
                color: Color(0xff0e4888),
              ),
              title: Text('Estadísticas',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: Color(0xff8c8c94),
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SeguridadScreen()));
              },
            ),
            Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.contact_page,
                color: Color(0xff0e4888),
              ),
              title: Text('Contacto',
                  style: TextStyle(fontSize: 15, color: Color(0xff0e4888))),
              tileColor: Color(0xff8c8c94),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactoScreen()));
              },
            ),
            Divider(
              color: Color(0xff0e4888),
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Color(0xff0e4888),
              ),
              tileColor: Color(0xff8c8c94),
              title: Text('Cerrar Sesión',
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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//*****************************************************************************
//************************** METODO GETPREFS **********************************
//*****************************************************************************

  void _getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _conectadodesde = prefs.getString('conectadodesde').toString();
    _validohasta = prefs.getString('validohasta').toString();
    _ultimaactualizacion = prefs.getString('ultimaactualizacion').toString();
  }

  //*****************************************************************************
//************************** METODO GETPOSITION **********************************
//*****************************************************************************

  Future _getPosition() async {
    bool serviceEnabled;
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
                title: Text('Aviso'),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text('El permiso de localización está negado.'),
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
              title: Text('Aviso'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                    'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
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
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }
  }
}
