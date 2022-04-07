import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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

//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  TabController? _tabController;

  List<Ruta> _rutasApi = [];
  List<RutaCab> _rutas = [];

  List<Parada> _paradas = [];
  List<Envio> _envios = [];

  List<ParadaEnvio> _paradasenvios = [];
  List<ParadaEnvio> _paradasenviosselected = [];

  List<ParadaEnvio> _paradasenviosdb = [];

  List<Proveedor> _proveedoresApi = [];
  List<Proveedor> _proveedores = [];

  List<Motivo> _motivosApi = [];
  List<Motivo> _motivos = [];

  int _nroReg = 0;
  int pendientes = 0;
  int listas = 0;
  int totParadas = 0;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;
  bool _passwordShow = false;

  bool _paradaGrabada = false;
  bool _envioGrabado = false;
  bool _seguimientoGrabado = false;
  bool _puso1 = false;

  String _result2 = "no";

  bool _hayInternet = false;
  bool _showLoader = false;

  String _proveedorselected = '';

  String _conectadodesde = '';
  String _validohasta = '';
  String _ultimaactualizacion = '';

  String _textComponent = '';

  RutaCab rutaSelected = RutaCab(
      idRuta: 0,
      idUser: 0,
      fechaAlta: '',
      nombre: '',
      estado: 0,
      totalParadas: 0,
      pendientes: 0);

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

  ParadaEnvio paradaenvioSelected = ParadaEnvio(
      idParada: 0,
      idRuta: 0,
      idEnvio: 0,
      secuencia: 0,
      leyenda: '',
      latitud: 0,
      longitud: 0,
      idproveedor: 0,
      estado: 0,
      ordenid: '',
      titular: '',
      dni: '',
      domicilio: '',
      cp: '',
      entreCalles: '',
      telefonos: '',
      localidad: '',
      bultos: 0,
      proveedor: '',
      motivo: 0,
      motivodesc: '',
      notas: '',
      enviado: 0,
      fecha: '',
      imageArray: '',
      observaciones: '');

  Parada paradaSelected = Parada(
      idParada: 0,
      idRuta: 0,
      idEnvio: 0,
      tag: 0,
      secuencia: 0,
      leyenda: '',
      latitud: 0,
      longitud: 0,
      iconoPropio: '',
      iDmapa: '',
      distancia: 0,
      tiempo: 0,
      estado: 0,
      fecha: '',
      hora: '',
      idMotivo: 0,
      notaChofer: '',
      nuevoOrden: 0,
      idCabCertificacion: 0,
      idLiquidacionFletero: 0,
      turno: '');

  Envio envioSelected = Envio(
      idEnvio: 0,
      idproveedor: 0,
      agencianr: 0,
      estado: 0,
      envia: '',
      ruta: '',
      ordenid: '',
      fecha: 0,
      hora: '',
      imei: '',
      transporte: '',
      contrato: '',
      titular: '',
      dni: '',
      domicilio: '',
      cp: '',
      latitud: 0,
      longitud: 0,
      autorizado: '',
      observaciones: '',
      idCabCertificacion: 0,
      idRemitoProveedor: 0,
      idSubconUsrWeb: 0,
      fechaAlta: '',
      fechaEnvio: '',
      fechaDistribucion: '',
      entreCalles: '',
      mail: '',
      telefonos: '',
      localidad: '',
      tag: 0,
      provincia: '',
      fechaEntregaCliente: '',
      scaneadoIn: '',
      scaneadoOut: '',
      ingresoDeposito: 0,
      salidaDistribucion: 0,
      idRuta: 0,
      nroSecuencia: 0,
      fechaHoraOptimoCamino: '',
      bultos: 0,
      peso: '',
      alto: '',
      ancho: '',
      largo: '',
      idComprobante: 0,
      enviarMailSegunEstado: '',
      fechaRuta: '',
      ordenIDparaOC: '',
      hashUnico: '',
      bultosPikeados: 0,
      centroDistribucion: '',
      fechaUltimaActualizacion: '',
      volumen: '',
      avonZoneNumber: 0,
      avonSectorNumber: 0,
      avonAccountNumber: '',
      avonCampaignNumber: 0,
      avonCampaignYear: 0,
      domicilioCorregido: '',
      domicilioCorregidoUsando: 0,
      urlFirma: '',
      urlDNI: '',
      ultimoIdMotivo: 0,
      ultimaNotaFletero: '',
      idComprobanteDevolucion: 0,
      turno: '',
      barrioEntrega: '',
      partidoEntrega: '',
      avonDayRoute: 0,
      avonTravelRoute: 0,
      avonSecuenceRoute: 0,
      avonInformarInclusion: 0,
      urlDNIFullPath: '',
      latitud2: 0,
      longitud2: 0);

  Position _positionUser = Position(
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
    _user = widget.user;
    _tabController = TabController(length: 3, vsync: this);
    _getprefs();
    _getPosition();
    _getProveedores();

    for (ParadaEnvio element in _paradasenvios) {
      if (element.estado == 3) {
        pendientes++;
      }
    }
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

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
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
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
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Column(
                  children: [
                    AppBar(
                      title: (Text("Completas")),
                      centerTitle: true,
                      actions: <Widget>[
                        IconButton(
                          onPressed: _llenarparadasenvios,
                          icon: Icon(Icons.refresh),
                        )
                      ],
                      backgroundColor: Color(0xff282886),
                    ),
                    Center(
                      child: _getContent(),
                    ),
                  ],
                ),
//-------------------------------------------------------------------------
//-------------------------- 3° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                SingleChildScrollView(
                  child: Column(
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
                              _user.usrlogin.toUpperCase(),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                Icon(Icons.delete),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('BORRAR PARADAS LOCALES'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              _password = '';
                              _result2 = "no";
                              await _borrarMedicionesLocales();
                              if (_result2 == 'yes') {
                                await _borrarMedicionesLocales();
                              }
                              setState(() {});
                            },
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
                ),
              ],
            ),
          ),
          Center(
            child: _showLoader
                ? LoaderComponent(text: _textComponent)
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
            controller: _tabController,
            indicatorColor: Color(0xff282886),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
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

//-------------------------------------------------------------------------
//-------------------------- METODO NO CONTENT ----------------------------
//-------------------------------------------------------------------------

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

//-------------------------------------------------------------------------
//-------------------------- METODO SHOWRUTAS -----------------------------
//-------------------------------------------------------------------------

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
                                    e.pendientes == 0
                                        ? Text(('COMPLETADA'),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ))
                                        : Text(' '),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text("Paradas: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(e.totalParadas.toString(),
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
                                    Text("Pendientes: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(e.pendientes.toString(),
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

//-------------------------------------------------------------------------
//-------------------------- METODO GETCONTENT ----------------------------
//-------------------------------------------------------------------------

  Widget _getContent() {
    return _paradasenviosdb.length == 0 ? _noContent2() : _getListView();
  }

//-------------------------------------------------------------------------
//-------------------------- METODO NOCONTENT2 ----------------------------
//-------------------------------------------------------------------------

  Widget _noContent2() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'No hay paradas completadas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

//-------------------------------------------------------------------------
//-------------------------- METODO GETLISTVIEW ---------------------------
//-------------------------------------------------------------------------

  Widget _getListView() {
    return Container(
      height: 550,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: _paradasenviosdb.map((e) {
          return Card(
            color: Colors.white,
            shadowColor: Colors.white,
            elevation: 10,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: InkWell(
              onTap: () {
                paradaenvioSelected = e;
              },
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            e.enviado == 1
                                ? Icon(Icons.done_all, color: Colors.green)
                                : e.enviado == 0
                                    ? Icon(Icons.done, color: Colors.grey)
                                    : Icon(Icons.done, color: Colors.red),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Ruta: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("Parada: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("Envío: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(e.idRuta.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                Text(e.idParada.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                Text(e.idEnvio.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Fecha: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fecha!))}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                Text("",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF781f1e),
                                      fontWeight: FontWeight.bold,
                                    )),
                                (e.estado == 4)
                                    ? Text(
                                        "ENTREGADO",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : (e.estado == 10)
                                        ? Text(
                                            "NO ENTREGADO",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : (e.estado == 7)
                                            ? Text(
                                                "RECHAZADO",
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "PENDIENTE",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//-------------------------------------------------------------------------
//-------------------------- METODO CONTACTO ------------------------------
//-------------------------------------------------------------------------

  void _contacto() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContactoScreen()));
  }

//-------------------------------------------------------------------------
//-------------------------- METODO GOINFORUTA ----------------------------
//-------------------------------------------------------------------------

  void _goInfoRuta(RutaCab ruta) async {
    _paradasenviosselected = [];
    _paradasenvios.forEach((element) {
      if (element.idRuta == ruta.idRuta) {
        _paradasenviosselected.add(element);
      }
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
    if (result == 'yes' || result != 'yes') {
      setState(() {
        _showLoader = true;
      });
      await _actualizaParadasEnvios();
      await _actualizaRutas();
      setState(() {
        _showLoader = false;
      });
    }
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

//*****************************************************************************
//************************** METODO LOGOUT ************************************
//*****************************************************************************

  void _logOut() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//*****************************************************************************
//************************* PROVEEDORES ***************************************
//*****************************************************************************

  Future<Null> _getProveedores() async {
    setState(() {
      _textComponent = "Cargando Proveedores.";
      _showLoader = true;
    });

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

    setState(() {
      _showLoader = false;
    });

    _getRutas();
  }

//*****************************************************************************
//************************* RUTAS *********************************************
//*****************************************************************************
  Future<Null> _getRutas() async {
    setState(() {
      _textComponent = "Cargando Rutas.";
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
              estado: ruta.estado,
              totalParadas: 0,
              pendientes: 0);
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

    await _actualizaRutas();

    //_rutas = await DBRutasCab.rutas();

    _paradas.forEach((parada) {
      Envio filteredEnvio = Envio(
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
        avonInformarInclusion: 0,
        urlDNIFullPath: '',
        latitud2: 0,
        longitud2: 0,
      );

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
          proveedor: _proveedorselected,
          motivo: 0,
          motivodesc: '',
          notas: '',
          enviado: 0,
          fecha: '',
          imageArray: '',
          observaciones: filteredEnvio.observaciones);

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

    setState(() {
      _showLoader = false;
    });

    _getMotivos();
  }

//*****************************************************************************
//************************* MOTIVOS *******************************************
//*****************************************************************************

  Future<Null> _getMotivos() async {
    setState(() {
      _textComponent = "Cargando Motivos.";
      _showLoader = true;
    });

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

    _getParadasEnvios();
  }

  Future<Null> _getParadasEnvios() async {
    _getTablaMedicionesCab();
    return;
  }

  void _getTablaMedicionesCab() async {
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();

    setState(() {
      _showLoader = false;
    });
  }

//*****************************************************************************
//************************* METODO ACTUALIZAPARADASENVIOS *********************
//*****************************************************************************

  Future<void> _actualizaParadasEnvios() async {
    return Future.delayed(Duration(seconds: 1), () async {
      _paradasenviosdb = await DBParadasEnvios.paradasenvios();
      _paradasenviosdb.forEach((paradaenvio) {
        if (DateTime.parse(paradaenvio.fecha!)
                .isBefore(DateTime.now().add(Duration(days: -7))) &&
            paradaenvio.enviado != 0) {
          DBParadasEnvios.delete(paradaenvio);
        }
      });

      _paradasenviosdb = await DBParadasEnvios.paradasenvios();
      _paradasenviosdb.sort((a, b) {
        return a.secuencia!.toInt().compareTo(b.secuencia!.toInt());
      });
    });
  }

//*****************************************************************************
//************************* METODO BORRARMEDICIONESLOCALES ********************
//*****************************************************************************

  _borrarMedicionesLocales() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Atención!!",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Text(
                        "Para borrar las mediciones locales de su Usuario debe escribir su contraseña",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(""),
                      TextField(
                        obscureText: !_passwordShow,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Contraseña...',
                            labelText: 'Contraseña',
                            errorText:
                                _passwordShowError ? _passwordError : null,
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 15,
                        ),
                        Text('BORRAR'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      if (_password.toLowerCase() !=
                          widget.user.usrcontrasena.toLowerCase()) {
                        _passwordShowError = true;
                        _passwordError = 'Contraseña incorrecta';
                        setState(() {});
                      } else {
                        _paradasenviosdb.forEach((element) {
                          DBParadasEnvios.delete(element);
                        });
                        _paradasenviosdb = [];
                        setState(() {});
                        _result2 = "yes";
                        Navigator.pop(context, 'yes');
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel),
                        SizedBox(
                          width: 15,
                        ),
                        Text('CANCELAR'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF9a6a2e),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      _passwordShowError = false;
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
                shape: Border.all(
                    color: Colors.red, width: 5, style: BorderStyle.solid),
                backgroundColor: Colors.white,
              );
            },
          );
        });
  }

//*****************************************************************************
//************************* METODO LLENARPARADASENVIOS ************************
//*****************************************************************************

  Future<void> _llenarparadasenvios() async {
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    _paradasenviosdb.sort((a, b) {
      return a.secuencia!.toInt().compareTo(b.secuencia!.toInt());
    });

    _paradasenvios.forEach((paradasenvio) {
      _paradasenviosdb.forEach((paradasenviodb) {
        if (paradasenvio.idParada == paradasenviodb.idParada) {
          paradasenvio.estado = paradasenviodb.estado;
          paradasenvio.motivo = paradasenviodb.motivo;
          paradasenvio.motivodesc = paradasenviodb.motivodesc;
          paradasenvio.notas = paradasenviodb.notas;
          paradasenvio.fecha = paradasenviodb.fecha;
        }
      });
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _showLoader = true;
      });

      for (ParadaEnvio paradaenvio in _paradasenviosdb) {
        if (paradaenvio.enviado == 0) {
          await _putParada(paradaenvio);
        }
      }

      setState(() {
        _showLoader = false;
      });
    } else {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message:
              "No está conectado a Internet para subir los datos al Servidor",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }

    setState(() {});
  }

//*****************************************************************************
//******************** METODOS PARA GRABAR EN EL SERVIDOR *********************
//*****************************************************************************

  Future<void> _putParada(ParadaEnvio paradaenvio) async {
    _paradas.forEach((element) {
      if (element.idParada == paradaenvio.idParada) {
        paradaSelected = element;
      }
    });

    _paradaGrabada = false;

    do {
      String fec = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String hora = DateFormat('HH:mm').format(DateTime.now());

      Map<String, dynamic> requestParada = {
        'idParada': paradaSelected.idParada,
        'idRuta': paradaSelected.idRuta,
        'idEnvio': paradaSelected.idEnvio,
        'tag': paradaSelected.tag,
        'secuencia': paradaSelected.secuencia,
        'leyenda': paradaSelected.leyenda,
        'latitud': paradaSelected.latitud,
        'longitud': paradaSelected.longitud,
        'iconoPropio': paradaSelected.iconoPropio,
        'iDmapa': paradaSelected.iDmapa,
        'distancia': paradaSelected.distancia,
        'tiempo': paradaSelected.tiempo,
        'estado': paradaenvio.estado,
        'fecha': fec,
        'hora': hora,
        'idMotivo': paradaenvio.motivo,
        'notaChofer': paradaenvio.notas,
        'nuevoOrden': paradaSelected.nuevoOrden,
        'idCabCertificacion': paradaSelected.idCabCertificacion,
        'idLiquidacionFletero': paradaSelected.idLiquidacionFletero,
        'turno': paradaSelected.turno,
      };

      Response response = await ApiHelper.put(
          '/api/Paradas/', paradaSelected.idParada.toString(), requestParada);

      if (response.isSuccess) {
        _paradaGrabada = true;
      }
    } while (_paradaGrabada == false);

    await _putEnvio(paradaenvio);
  }

  //-------------------------------------------------------------------------

  Future<void> _putEnvio(ParadaEnvio paradaenvio) async {
    _envios.forEach((element) {
      if (element.idEnvio == paradaenvio.idEnvio) {
        envioSelected = element;
      }
    });

    _envioGrabado = false;

    do {
      Map<String, dynamic> requestEnvio = {
        'idEnvio': envioSelected.idEnvio,
        'idproveedor': envioSelected.idproveedor,
        'agencianr': envioSelected.agencianr,
        'estado': paradaenvio.estado,
        'envia': envioSelected.envia,
        'ruta': envioSelected.ruta,
        'ordenid': envioSelected.ordenid,
        'fecha': envioSelected.fecha,
        'hora': envioSelected.hora,
        'imei': envioSelected.imei,
        'transporte': envioSelected.transporte,
        'contrato': envioSelected.contrato,
        'titular': envioSelected.titular,
        'dni': envioSelected.dni,
        'domicilio': envioSelected.domicilio,
        'cp': envioSelected.cp,
        'latitud': envioSelected.latitud,
        'longitud': envioSelected.longitud,
        'autorizado': envioSelected.autorizado,
        'observaciones': envioSelected.observaciones,
        'idCabCertificacion': envioSelected.idCabCertificacion,
        'idRemitoProveedor': envioSelected.idRemitoProveedor,
        'idSubconUsrWeb': envioSelected.idSubconUsrWeb,
        'fechaAlta': envioSelected.fechaAlta,
        'fechaEnvio': envioSelected.fechaEnvio,
        'fechaDistribucion': envioSelected.fechaDistribucion,
        'entreCalles': envioSelected.entreCalles,
        'mail': envioSelected.mail,
        'telefonos': envioSelected.telefonos,
        'localidad': envioSelected.localidad,
        'tag': envioSelected.tag,
        'provincia': envioSelected.provincia,
        'fechaEntregaCliente': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'scaneadoIn': envioSelected.scaneadoIn,
        'scaneadoOut': envioSelected.scaneadoOut,
        'ingresoDeposito': envioSelected.ingresoDeposito,
        'salidaDistribucion': envioSelected.salidaDistribucion,
        'idRuta': envioSelected.idRuta,
        'nroSecuencia': envioSelected.nroSecuencia,
        'fechaHoraOptimoCamino': envioSelected.fechaHoraOptimoCamino,
        'bultos': envioSelected.bultos,
        'peso': envioSelected.peso,
        'alto': envioSelected.alto,
        'ancho': envioSelected.ancho,
        'largo': envioSelected.largo,
        'idComprobante': envioSelected.idComprobante,
        'enviarMailSegunEstado': envioSelected.enviarMailSegunEstado,
        'fechaRuta': envioSelected.fechaRuta,
        'ordenIDparaOC': envioSelected.ordenIDparaOC,
        'hashUnico': envioSelected.hashUnico,
        'bultosPikeados': envioSelected.bultosPikeados,
        'centroDistribucion': envioSelected.centroDistribucion,
        'fechaUltimaActualizacion':
            DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'volumen': envioSelected.volumen,
        'avonZoneNumber': envioSelected.avonZoneNumber,
        'avonSectorNumber': envioSelected.avonSectorNumber,
        'avonAccountNumber': envioSelected.avonAccountNumber,
        'avonCampaignNumber': envioSelected.avonCampaignNumber,
        'avonCampaignYear': envioSelected.avonCampaignYear,
        'domicilioCorregido': envioSelected.domicilioCorregido,
        'domicilioCorregidoUsando': envioSelected.domicilioCorregidoUsando,
        'urlFirma': envioSelected.urlFirma,
        'urlDNI': envioSelected.urlDNI,
        'ultimoIdMotivo': paradaenvio.motivo,
        'ultimaNotaFletero': paradaenvio.notas,
        'idComprobanteDevolucion': envioSelected.idComprobanteDevolucion,
        'turno': envioSelected.turno,
        'barrioEntrega': envioSelected.barrioEntrega,
        'partidoEntrega': envioSelected.partidoEntrega,
        'avonDayRoute': envioSelected.avonDayRoute,
        'avonTravelRoute': envioSelected.avonTravelRoute,
        'avonSecuenceRoute': envioSelected.avonSecuenceRoute,
        'avonInformarInclusion': envioSelected.avonInformarInclusion,
        'imageArray': paradaenvio.imageArray
      };

      Response response = await ApiHelper.put(
          '/api/Envios/', envioSelected.idEnvio.toString(), requestEnvio);
      if (response.isSuccess) {
        _envioGrabado = true;
      }
    } while (_envioGrabado == false);

    await _postSeguimiento(paradaenvio);
  }

  //-------------------------------------------------------------------------

  Future<void> _postSeguimiento(ParadaEnvio paradaenvio) async {
    int fec = DateTime.now().difference(DateTime(2022, 01, 01)).inDays + 80723;
    _seguimientoGrabado = false;

    do {
      Response response2 = await ApiHelper.getNroRegistroMax();
      if (response2.isSuccess) {
        _nroReg = int.parse(response2.result.toString()) + 1;
      }

      Map<String, dynamic> requestSeguimiento = {
        'id': _nroReg,
        'idenvio': paradaenvio.idEnvio,
        'idetapa': paradaenvio.estado,
        'estado': paradaenvio.estado,
        'idusuario': widget.user.idUser,
        'fecha': fec,
        'hora': DateFormat('HH:mm').format(DateTime.now()),
        'observaciones': 'Informada x Ws App',
        'motivo': paradaenvio.motivodesc,
        'notachofer': paradaenvio.notas,
      };

      Response response = await ApiHelper.post(
        '/api/Seguimientos',
        requestSeguimiento,
      );

      if (response.isSuccess) {
        _seguimientoGrabado = true;
      }
    } while (_seguimientoGrabado == false);

    await _ponerEnviado1(paradaenvio);
  }

  //-------------------------------------------------------------------------

  Future<void> _ponerEnviado1(ParadaEnvio paradaenvio) async {
    _puso1 = false;
    do {
      ParadaEnvio paradaenvionueva = ParadaEnvio(
          idParada: paradaenvio.idParada,
          idRuta: paradaenvio.idRuta,
          idEnvio: paradaenvio.idEnvio,
          secuencia: paradaenvio.secuencia,
          leyenda: paradaenvio.leyenda,
          latitud: paradaenvio.latitud,
          longitud: paradaenvio.longitud,
          idproveedor: paradaenvio.idproveedor,
          estado: paradaenvio.estado,
          ordenid: paradaenvio.ordenid,
          titular: paradaenvio.titular,
          dni: paradaenvio.dni,
          domicilio: paradaenvio.domicilio,
          cp: paradaenvio.cp,
          entreCalles: paradaenvio.entreCalles,
          telefonos: paradaenvio.telefonos,
          localidad: paradaenvio.localidad,
          bultos: paradaenvio.bultos,
          proveedor: paradaenvio.proveedor,
          motivo: paradaenvio.motivo,
          motivodesc: paradaenvio.motivodesc,
          notas: paradaenvio.notas,
          enviado: 1,
          fecha: paradaenvio.fecha,
          imageArray: paradaenvio.imageArray,
          observaciones: paradaenvio.observaciones);

      await DBParadasEnvios.update(paradaenvionueva);
      _paradasenviosdb = await DBParadasEnvios.paradasenvios();
      _paradasenviosdb.forEach((element) {
        if (element.idParada == paradaenvionueva.idParada &&
            element.enviado == 1) {
          _puso1 = true;
        }
      });
    } while (_puso1 == false);
  }

  _actualizaRutas() async {
    //---------------- LLENA CAMPO TOTAL PARADAS  ------------------
    for (RutaCab _ruta in _rutas) {
      totParadas = 0;
      for (Parada _parada in _paradas) {
        if (_ruta.idRuta == _parada.idRuta) {
          totParadas++;
        }
      }

      RutaCab rutaCabAux = RutaCab(
          idRuta: _ruta.idRuta,
          idUser: _ruta.idUser,
          fechaAlta: _ruta.fechaAlta,
          nombre: _ruta.nombre,
          estado: _ruta.estado,
          totalParadas: totParadas,
          pendientes: _ruta.pendientes);

      DBRutasCab.update(rutaCabAux);
    }
    _rutas = await DBRutasCab.rutas();

    //---------------- LLENA CAMPO TOTAL PENDIENTES  ------------------

    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (RutaCab _ruta in _rutas) {
      listas = 0;
      for (Parada _parada in _paradas) {
        if (_ruta.idRuta == _parada.idRuta) {
          if ((_parada.estado == 4) ||
              (_parada.estado == 7) ||
              (_parada.estado == 10)) {
            listas++;
          } else {
            for (ParadaEnvio _paradaenvio in _paradasenviosdb) {
              if ((_ruta.idRuta == _paradaenvio.idRuta) &&
                  (_parada.idParada == _paradaenvio.idParada) &&
                  ((_paradaenvio.estado == 4) ||
                      (_paradaenvio.estado == 7) ||
                      (_paradaenvio.estado == 10))) {
                listas++;
              }
            }
          }
        }
      }

      RutaCab rutaCabAux = RutaCab(
          idRuta: _ruta.idRuta,
          idUser: _ruta.idUser,
          fechaAlta: _ruta.fechaAlta,
          nombre: _ruta.nombre,
          estado: _ruta.estado,
          totalParadas: _ruta.totalParadas,
          pendientes: _ruta.totalParadas! - listas);

      DBRutasCab.update(rutaCabAux);
    }
    _rutas = await DBRutasCab.rutas();
  }
}
