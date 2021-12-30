import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/ruta.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/contacto_screen.dart';
import 'package:fleetdeliveryapp/screens/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/screens/helpers/constants.dart';
import 'package:fleetdeliveryapp/screens/login_screen.dart';
import 'package:fleetdeliveryapp/screens/rutainfo_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
  List<Ruta> _rutas = [];
  List<Ruta> _rutasApi = [];
  bool _hayInternet = false;
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

  Ruta rutaSelected =
      new Ruta(id: 0, idFletero: 0, fechaAlta: '', nombre: '', estado: 0);

  bool _showLoader = false;
  String _conectadodesde = '';
  String _validohasta = '';
  String _ultimaactualizacion = '';

  String Titulo = "Delivery";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.user;
    _tabController = TabController(length: 3, vsync: this);
    _getprefs();
    _getRutas();
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
                (0xffdadada),
              ),
              Color(
                (0xffb3b3b4),
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
                  title: (Text("Delivery")),
                  centerTitle: true,
                  backgroundColor: Color(0xff282886),
                ),
                Expanded(
                  child: _rutas.length == 0 ? _noContent() : _showRutas(),
                )
              ],
            ),
            Column(
              children: [
                AppBar(
                  title: (Text("Completas")),
                  centerTitle: true,
                  backgroundColor: Color(0xff282886),
                ),
                Center(
                  child: Text("Hoja 2"),
                ),
              ],
            ),
            Column(
              children: [
                AppBar(
                  title: (Text("Usuario")),
                  centerTitle: true,
                  backgroundColor: Color(0xff282886),
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
                        primary: Color(0xff282886),
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
                        primary: Color(0xff282886),
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
            indicatorColor: Color(0xff282886),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            // isScrollable: false,
            labelColor: Color(0xff282886),
            unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.all(10),
            tabs: <Widget>[
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.local_shipping),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Delivery",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Icon(Icons.done_all),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Completas",
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
    // var a = 123;
    // setState(() {});
  }

  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
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

  Widget _showRutas() {
    return ListView(
      children: _rutas.map((e) {
        return Card(
          color: Color(0xFFffffff),
          shadowColor: Colors.white,
          elevation: 10,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () {
              rutaSelected = e;
              _goInfoRuta(e);
            },
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Fecha: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fechaAlta))}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text("Nombre: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(e.nombre,
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _goInfoRuta(Ruta ruta) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RutaInfoScreen(
                  user: widget.user,
                  ruta: ruta,
                )));
  }

  Future<Null> _getRutas() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.getRutas(_user.idUser);

      if (response.isSuccess) {
        _rutasApi = response.result;
        // _rutasApi.sort((a, b) {
        //   return a.fechaAlta
        //       .toString()
        //       .toLowerCase()
        //       .compareTo(b.fechaAlta.toString().toLowerCase());
        // });
        _hayInternet = true;
      }
    }
    _getTablaRutas();
    return;
  }

  void _getTablaRutas() async {
    final Future<Database> database = openDatabase(
      p.join(await getDatabasesPath(), 'rutas.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE rutas(id INTEGER PRIMARY KEY, idFletero INTEGER, fechaAlta TEXT, nombre TEXT, estado INTEGER)",
        );
      },
      version: 1,
    );

    Future<void> insertRuta(Ruta ruta) async {
      final Database db = await database;
      await db.insert(
        'rutas',
        ruta.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    void _insertRutas() async {
      if (_rutasApi.length > 0) {
        _rutasApi.forEach((element) {
          insertRuta(element);
        });
      }
    }

    Future<List<Ruta>> _getRutasSQLite() async {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('rutas');
      return List.generate(
        maps.length,
        (i) {
          return Ruta(
            id: maps[i]['id'],
            idFletero: maps[i]['idFletero'],
            fechaAlta: maps[i]['fechaAlta'],
            nombre: maps[i]['nombre'],
            estado: maps[i]['estado'],
          );
        },
      );
    }

    if (_hayInternet) {
      _insertRutas();
    }

    _rutas = await _getRutasSQLite();

    setState(() {
      _showLoader = false;
    });
  }
}
