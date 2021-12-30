import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/contacto_screen.dart';
import 'package:fleetdeliveryapp/screens/helpers/constants.dart';
import 'package:fleetdeliveryapp/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Usuario user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  TabController? _tabController;
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

  bool _showLoader = false;
  String _conectadodesde = '';
  String _validohasta = '';
  String _ultimaactualizacion = '';

  String Titulo = "Nueva medición";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.user;
    _tabController = TabController(length: 3, vsync: this);
    _getprefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9dac2),
      // appBar: AppBar(
      //   //title: (Text("PSEnergy App")),
      //   title: (Text(Titulo)),
      //   centerTitle: true,
      //   backgroundColor: Color(0xff9a6a2e),
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(
                (0xffe9dac2),
              ),
              Color(
                (0xffd3a735),
              ),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          physics: AlwaysScrollableScrollPhysics(),
          dragStartBehavior: DragStartBehavior.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                AppBar(
                  title: (Text("Nueva medición")),
                  centerTitle: true,
                  backgroundColor: Color(0xff9a6a2e),
                ),
                Center(child: Text("Hoja 1"))
              ],
            ),
            Column(
              children: [
                AppBar(
                  title: (Text("Ultimas mediciones")),
                  centerTitle: true,
                  backgroundColor: Color(0xff9a6a2e),
                ),
                Center(
                  child: Text("Hoja 2"),
                ),
              ],
            ),
            Column(
              children: [
                AppBar(
                  title: (Text("Información")),
                  centerTitle: true,
                  backgroundColor: Color(0xff9a6a2e),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    Center(
                      child: Text(
                        _user.usrlogin!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        _user.apellidonombre!,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Conectado desde:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            _conectadodesde == ''
                                ? ''
                                : '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(_conectadodesde))}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Válido hasta:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            _validohasta == ''
                                ? ''
                                : '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(_validohasta))}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Ultima actualización de Usuarios:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            _ultimaactualizacion == ''
                                ? ''
                                : '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(_ultimaactualizacion))}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Versión:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            Constants.version,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard),
                          SizedBox(
                            width: 15,
                          ),
                          Text('CONTACTO KEYPRESS'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9a6a2e),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () => _contacto(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 15,
                          ),
                          Text('CERRAR SESION'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9a6a2e),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () => _logOut(),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
            controller: _tabController,
            // indicator: BoxDecoration(
            //     color: Colors.orange,
            //     border: Border.all(width: 5, color: Colors.yellow)),
            indicatorColor: Color(0xff9a6a2e),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            // isScrollable: false,
            labelColor: Color(0xff9a6a2e),
            unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.all(10),
            tabs: <Widget>[
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.add_circle),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Nueva",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Cargadas",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Usuario",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  void _logOut() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _contacto() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContactoScreen()));
  }

  void _getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _conectadodesde = prefs.getString('conectadodesde').toString();
    _validohasta = prefs.getString('validohasta').toString();
    _ultimaactualizacion = prefs.getString('ultimaactualizacion').toString();
    var a = 123;
    setState(() {});
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
