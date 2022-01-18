import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/dbenvios_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbmotivos_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbparadas_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbproveedores_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbrutascab_helper.dart';
import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:fleetdeliveryapp/models/parada.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/proveedor.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/ruta.dart';
import 'package:fleetdeliveryapp/models/rutacab.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/contacto_screen.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/helpers/constants.dart';
import 'package:fleetdeliveryapp/screens/login_screen.dart';
import 'package:fleetdeliveryapp/screens/rutainfo_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  List<Ruta> _rutasApi = [];
  List<RutaCab> _rutas = [];
  List<Parada> _paradas = [];
  List<Envio> _envios = [];
  List<ParadaEnvio> _paradasenvios = [];
  List<ParadaEnvio> _paradasenviosselected = [];
  List<Proveedor> _proveedoresApi = [];
  List<Proveedor> _proveedores = [];
  List<Motivo> _motivosApi = [];
  List<Motivo> _motivos = [];

  bool _habilitaPosicion = false;
  Position _positionUser = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

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

  RutaCab rutaSelected =
      new RutaCab(idRuta: 0, idUser: 0, fechaAlta: '', nombre: '', estado: 0);

  String _proveedorselected = '';

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
    _getProveedores();
    //_getRutas();
    _getPosition();
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
                                      child: Text(e.idRuta.toString(),
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

  void _goInfoRuta(RutaCab ruta) async {
    _paradasenviosselected = [];
    _paradasenvios.forEach((element) {
      if (element.idRuta == ruta.idRuta) {
        _paradasenviosselected.add(element);
      }
      ;
    });

    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RutaInfoScreen(
                  user: widget.user,
                  ruta: ruta,
                  paradas: _paradas,
                  envios: _envios,
                  paradasenvios: _paradasenviosselected,
                  positionUser: _positionUser,
                  motivos: _motivos,
                )));
  }

//***************************************************************
//************************* RUTAS *******************************
//***************************************************************
  Future<Null> _getRutas() async {
    setState(() {
      _showLoader = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.getRutas(widget.user.idUser);

      if (response.isSuccess) {
        _rutasApi = response.result;
        _hayInternet = true;
      }
    }
    _getTablaRutas();
    return;
  }

  void _getTablaRutas() async {
    void _insertRutas() async {
      if (_rutasApi.length > 0) {
        DBRutasCab.delete();
        DBParadas.delete();
        DBEnvios.delete();

        _rutasApi.forEach((ruta) {
          RutaCab rutaCab = RutaCab(
              idRuta: ruta.idRuta,
              idUser: ruta.idUser,
              fechaAlta: ruta.fechaAlta,
              nombre: ruta.nombre,
              estado: ruta.estado);
          DBRutasCab.insertRuta(rutaCab);

          if (ruta.paradas!.length > 0) {
            ruta.paradas!.forEach((parada) {
              if (parada.idEnvio != 0) {
                DBParadas.insertParada(parada);
              }
            });
          }

          if (ruta.envios!.length > 0) {
            ruta.envios!.forEach((envio) {
              DBEnvios.insertEnvio(envio);
            });
          }
        });
      }
    }

    if (_hayInternet) {
      _insertRutas();
    }

    _rutas = await DBRutasCab.rutas();
    _paradas = await DBParadas.paradas();
    _envios = await DBEnvios.envios();

    _paradas.forEach((parada) {
      Envio filteredEnvio = new Envio(
          idEnvio: 0,
          idproveedor: 0,
          agencianr: 0,
          estado: 0,
          envia: "",
          ruta: "",
          ordenid: "",
          fecha: 0,
          hora: "",
          imei: "",
          transporte: "",
          contrato: "",
          titular: "",
          dni: "",
          domicilio: "",
          cp: "",
          latitud: 0,
          longitud: 0,
          autorizado: "",
          observaciones: "",
          idCabCertificacion: 0,
          idRemitoProveedor: 0,
          idSubconUsrWeb: 0,
          fechaAlta: "",
          fechaEnvio: "",
          fechaDistribucion: "",
          entreCalles: "",
          mail: "",
          telefonos: "",
          localidad: "",
          tag: 0,
          provincia: "",
          fechaEntregaCliente: "",
          scaneadoIn: "",
          scaneadoOut: "",
          ingresoDeposito: 0,
          salidaDistribucion: 0,
          idRuta: 0,
          nroSecuencia: 0,
          fechaHoraOptimoCamino: "",
          bultos: 0,
          peso: "",
          alto: "",
          ancho: "",
          largo: "",
          idComprobante: 0,
          enviarMailSegunEstado: "",
          fechaRuta: "",
          ordenIDparaOC: "",
          hashUnico: "",
          bultosPikeados: 0,
          centroDistribucion: "",
          fechaUltimaActualizacion: "",
          volumen: "",
          avonZoneNumber: 0,
          avonSectorNumber: 0,
          avonAccountNumber: "",
          avonCampaignNumber: 0,
          avonCampaignYear: 0,
          domicilioCorregido: "",
          domicilioCorregidoUsando: 0,
          urlFirma: "",
          urlDNI: "",
          ultimoIdMotivo: 0,
          ultimaNotaFletero: "",
          idComprobanteDevolucion: 0,
          turno: "",
          barrioEntrega: "",
          partidoEntrega: "",
          avonDayRoute: 0,
          avonTravelRoute: 0,
          avonSecuenceRoute: 0,
          avonInformarInclusion: 0);
      for (var envio in _envios) {
        if (envio.idEnvio == parada.idEnvio) {
          filteredEnvio = envio;
        }
      }

      for (var proveedor in _proveedores) {
        if (proveedor.id == filteredEnvio.idproveedor) {
          _proveedorselected = proveedor.nombre.toString();
        }
      }
      ;
      ParadaEnvio paradaEnvio = ParadaEnvio(
          idParada: parada.idParada,
          idRuta: parada.idRuta,
          idEnvio: parada.idEnvio,
          secuencia: parada.secuencia,
          leyenda: parada.leyenda,
          latitud: parada.latitud,
          longitud: parada.longitud,
          idproveedor: filteredEnvio.idproveedor,
          estado: filteredEnvio.estado,
          ordenid: filteredEnvio.ordenid,
          titular: filteredEnvio.titular,
          dni: filteredEnvio.dni,
          domicilio: filteredEnvio.domicilio,
          cp: filteredEnvio.cp,
          entreCalles: filteredEnvio.entreCalles,
          telefonos: filteredEnvio.telefonos,
          localidad: filteredEnvio.localidad,
          bultos: filteredEnvio.bultos,
          proveedor: _proveedorselected);

      _paradasenvios.add(paradaEnvio);
    });

    if (_rutas.length == 0) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              "La tabla Rutas local está vacía. Por favor arranque la App desde un lugar con acceso a Internet para poder conectarse al Servidor.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      SystemNavigator.pop();
      return;
    }

    _getMotivos();
  }

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

    _habilitaPosicion = true;
    _positionUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _positionUser.latitude, _positionUser.longitude);
  }

//***************************************************************
//************************* PROVEEDORES *************************
//***************************************************************
  Future<Null> _getProveedores() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.getProveedores();

      if (response.isSuccess) {
        _proveedoresApi = response.result;
        _hayInternet = true;
      }
    }
    _getTablaProveedores();
    //return;
  }

  void _getTablaProveedores() async {
    void _insertProveedores() async {
      if (_proveedoresApi.length > 0) {
        DBProveedores.delete();
        _proveedoresApi.forEach((element) {
          DBProveedores.insertProveedor(element);
        });
      }
    }

    if (_hayInternet) {
      _insertProveedores();
    }
    _proveedores = await DBProveedores.proveedores();

    // if (_baterias.length > 0) {
    //   setState(() {
    //     _colorBaterias = Colors.green;
    //   });
    // }

    _getRutas();
  }

//***************************************************************
//************************* MOTIVOS *****************************
//***************************************************************
  Future<Null> _getMotivos() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.getMotivos();

      if (response.isSuccess) {
        _motivosApi = response.result;
        _hayInternet = true;
      }
    }
    _getTablaMotivos();

    return;
  }

  void _getTablaMotivos() async {
    void _insertMotivos() async {
      if (_motivosApi.length > 0) {
        DBMotivos.delete();
        _motivosApi.forEach((element) {
          Motivo mot = Motivo(id: element.id, motivo: element.motivo);

          DBMotivos.insertMotivo(mot);
        });
      }
    }

    if (_hayInternet) {
      _insertMotivos();
    }
    _motivos = await DBMotivos.motivos();

    setState(() {
      _showLoader = false;
    });
  }
}
