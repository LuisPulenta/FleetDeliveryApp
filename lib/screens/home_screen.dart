import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/dbenvios_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbparadas_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbrutas_helper.dart';
import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/parada.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/ruta.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/contacto_screen.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/helpers/constants.dart';
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

  List<Parada> _paradas = [];
  List<Parada> _paradasApiParcial = [];
  List<Parada> _paradasApi = [];

  List<Envio> _envios = [];
  List<Envio> _enviosApiParcial = [];
  List<Envio> _enviosApi = [];

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
      body: Stack(
        children: [
          Container(
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
          Center(
            child: _showLoader
                ? LoaderComponent(text: 'Por favor espere...')
                : Container(),
          ),
        ],
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
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fechaAlta!))}',
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
                                      child: Text(e.nombre!,
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
                                    Text("Ruta: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(e.id.toString()!,
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
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

  //*****************************************************************
  //*********************** RUTAS ***********************************
  //*****************************************************************

  Future<Null> _getRutas() async {
    setState(() {
      _showLoader = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.getRutas(_user.idUser);

      if (response.isSuccess) {
        _rutasApi = response.result;
        _rutasApi.sort((a, b) {
          return a.fechaAlta
              .toString()
              .toLowerCase()
              .compareTo(b.fechaAlta.toString().toLowerCase());
        });
        _hayInternet = true;
      }
    }
    _getTablaRutas();
    return;
  }

  void _getTablaRutas() async {
    void _insertRutas() async {
      if (_rutasApi.length > 0) {
        DBRutas.delete();
        _rutasApi.forEach((element) {
          DBRutas.insertRuta(element);
        });
      }
    }

    if (_hayInternet) {
      _insertRutas();
    }

    _rutas = await DBRutas.rutas();

    setState(() {
      _showLoader = false;
    });

    if (_rutas.length == 0) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "No hay Rutas para este Usuario.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    await _getParadas();
    //await _getEnvios();

    return;
  }

  //*****************************************************************
  //*********************** PARADAS *********************************
  //*****************************************************************

  Future<Null> _getParadas() async {
    setState(() {
      _showLoader = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _rutas.forEach((element) async {
        Response response = await ApiHelper.getParadas(element.id.toString());
        if (response.isSuccess) {
          _paradasApiParcial = response.result;
          _paradasApiParcial.forEach((parada) {
            _paradasApi.add(parada);
          });
        }
      });

      _hayInternet = true;
    }
    await _getTablaParadas();
    return;
  }

  _getTablaParadas() async {
    void _insertParadas() async {
      if (_paradasApi.length > 0) {
        DBParadas.delete();
        _paradasApi.forEach((element) {
          DBParadas.insertParada(element);
        });
      }
    }

    if (_hayInternet) {
      await _insertParadas;
    }

    _paradas = await DBParadas.paradas();

    setState(() {
      _showLoader = false;
    });

    if (_paradas.length == 0) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "No hay Paradas para esta Ruta.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    return;
  }

  //*****************************************************************
  //*********************** ENVIOS **********************************
  //*****************************************************************

  Future<Null> _getEnvios() async {
    setState(() {
      _showLoader = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // _rutas.forEach((element) async {
      //   Response response = await ApiHelper.getEnvios(element.id.toString());
      //   if (response.isSuccess) {
      //     _enviosApiParcial = response.result;
      //   }
      //   _enviosApiParcial.forEach((envio) {
      //     _enviosApi.add(envio);
      //   });
      // });

      Response response = await ApiHelper.getEnvios(_rutas[0].id.toString());
      if (response.isSuccess) {
        _enviosApiParcial = response.result;
        _enviosApiParcial.forEach((envio) {
          _enviosApi.add(envio);
        });
      }

      response = await ApiHelper.getEnvios(_rutas[1].id.toString());
      if (response.isSuccess) {
        _enviosApiParcial = response.result;
        _enviosApiParcial.forEach((envio) {
          _enviosApi.add(envio);
        });
      }

      _hayInternet = true;
    }
    _getTablaEnvios();
    return;
  }

  _getTablaEnvios() async {
    void _insertEnvios() async {
      if (_enviosApi.length > 0) {
        DBEnvios.delete();
        _enviosApi.forEach((element) {
          DBEnvios.insertEnvio(element);
        });
      }
    }

    if (_hayInternet) {
      _insertEnvios();
    }

    _envios = await DBEnvios.envios();

    setState(() {
      _showLoader = false;
    });

    if (_envios.length == 0) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "No hay Envíos para esta Ruta.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await showAlertDialog(
        context: context,
        title: 'Envíos',
        message: _envios.length.toString(),
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
    return;
  }
}
