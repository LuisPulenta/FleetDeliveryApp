// ignore_for_file: unnecessary_const

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
  final WebSesion webSesion;

  const HomeScreen({Key? key, required this.user, required this.webSesion})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  TabController? _tabController;

  int paraSincronizar = 0;
  bool _sincronizar = true;

  List<Ruta> _rutasApi = [];
  List<RutaCab> _rutas = [];

  List<Parada> _paradas = [];
  List<Envio> _envios = [];

  final List<ParadaEnvio> _paradasenvios = [];
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
    observaciones: '',
    enviadoparada: 0,
    enviadoenvio: 0,
    enviadoseguimiento: 0,
  );

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

  Parada paradaSaved = Parada(
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

  Envio envioSaved = Envio(
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

  Seguimiento seguimientoSaved = Seguimiento(
      id: 0,
      idenvio: 0,
      idetapa: 0,
      estado: 0,
      idusuario: 0,
      fecha: 0,
      hora: '',
      observaciones: '',
      motivo: '',
      notachofer: '');

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
      backgroundColor: const Color(0xffe9dac2),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(
                    (0xffdadada),
                  ),
                  const Color(
                    (0xffb3b3b4),
                  ),
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              physics: const AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Column(
                  children: <Widget>[
                    AppBar(
                      title: (const Text("Delivery")),
                      actions: [
                        Row(
                          children: [
                            const Text(
                              "Sincr:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Switch(
                                value: _sincronizar,
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.grey,
                                onChanged: (value) async {
                                  _sincronizar = value;
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('sincronizar', value);

                                  setState(() {});
                                }),
                          ],
                        ),
                      ],
                      centerTitle: true,
                      backgroundColor: const Color(0xff282886),
                    ),
                    Expanded(
                      child: _rutas.isEmpty ? _noContent() : _showRutas(),
                    ),
                  ],
                ),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------

                Column(
                  children: [
                    AppBar(
                      title: (const Text("Completas")),
                      centerTitle: true,
                      actions: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 50),
                          child: IconButton(
                            onPressed: _llenarparadasenvios,
                            icon: const Icon(
                              Icons.cloud_sync,
                              color: Colors.yellow,
                              size: 40,
                            ),
                          ),
                        )
                      ],
                      backgroundColor: const Color(0xff282886),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _showEnviosCount(),
                    Expanded(
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
                        title: (const Text("Usuario")),
                        centerTitle: true,
                        backgroundColor: const Color(0xff282886),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(children: [
                          Center(
                            child: Text(
                              _user.usrlogin.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              _user.apellidonombre!,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Conectado desde:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                _conectadodesde == ''
                                    ? ''
                                    : DateFormat('dd/MM/yyyy HH:mm').format(
                                        DateTime.parse(_conectadodesde)),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Válido hasta:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                _validohasta == ''
                                    ? ''
                                    : DateFormat('dd/MM/yyyy HH:mm')
                                        .format(DateTime.parse(_validohasta)),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Ultima actualización de Usuarios:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                _ultimaactualizacion == ''
                                    ? ''
                                    : DateFormat('dd/MM/yyyy HH:mm').format(
                                        DateTime.parse(_ultimaactualizacion)),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Text(
                                "Versión:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                Constants.version,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.delete),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('BORRAR PARADAS LOCALES'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              _password = '';
                              _result2 = "no";
                              await _borrarMedicionesLocales();
                              // if (_result2 == 'yes') {
                              //   await _borrarMedicionesLocales();
                              // }
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.storage),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('DATOS EN BD LOCALES'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff282886),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () => _storage(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.keyboard),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('CONTACTO KEYPRESS'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff282886),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () => _contacto(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.password),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('CAMBIAR CONTRASEÑA'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff282886),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () => _cambiarPassword(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.exit_to_app),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text('CERRAR SESION'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff282886),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () async {
                                await DBEnvios.deleteall();
                                await DBMotivos.deleteall();
                                await DBParadas.deleteall();
                                await DBParadasEnvios.deleteall();
                                await DBProveedores.deleteall();
                                await DBRutasCab.deleteall();
                                //await DBUsuarios.deleteall();
                                await DBWebSesions.deleteall();
                                _logOut();
                              }),
                          // ElevatedButton(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: const [
                          //       Icon(Icons.delete),
                          //       SizedBox(
                          //         width: 15,
                          //       ),
                          //       Text('BORRAR REGISTROS DE LA BASE'),
                          //     ],
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //     primary: Colors.red,
                          //     minimumSize: const Size(double.infinity, 50),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //   ),
                          //   onPressed: () async {
                          //     await DBEnvios.deleteall();
                          //     await DBMotivos.deleteall();
                          //     await DBParadas.deleteall();
                          //     await DBParadasEnvios.deleteall();
                          //     await DBProveedores.deleteall();
                          //     await DBRutasCab.deleteall();
                          //     await DBUsuarios.deleteall();
                          //     await DBWebSesions.deleteall();
                          //   },
                          // ),
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
        color: paraSincronizar > 0
            ? const Color.fromARGB(255, 219, 8, 5)
            : Colors.white,
        child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xff282886),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            labelColor: const Color(0xff282886),
            unselectedLabelColor:
                paraSincronizar > 0 ? Colors.white : Colors.grey,
            labelPadding: const EdgeInsets.all(10),
            tabs: <Widget>[
              Tab(
                child: Column(
                  children: const [
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
                  children: const [
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
                  children: const [
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
      margin: const EdgeInsets.all(20),
      child: const Center(
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
          color: const Color(0xFFffffff),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Fecha: ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Expanded(
                                    child: Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(e.fechaAlta!)),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text("Nombre: ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Expanded(
                                    child: Text(e.nombre!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text("Ruta N°: ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Expanded(
                                    child: Text(e.idRuta.toString(),
                                        style: const TextStyle(
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
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  e.pendientes == 0
                                      ? const Text(('COMPLETADA'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ))
                                      : const Text(' '),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text("Paradas: ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Expanded(
                                    child: Text(e.totalParadas.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text("Pendientes: ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Expanded(
                                    child: Text(e.pendientes.toString(),
                                        style: const TextStyle(
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
                Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff282886),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          rutaSelected = e;
                          _goInfoRuta(e);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CircleAvatar(
                      backgroundColor:
                          _sincronizar ? const Color(0xff282886) : Colors.grey,
                      child: IconButton(
                        icon: const Icon(
                          Icons.keyboard_double_arrow_right,
                          color: Colors.white,
                        ),
                        onPressed: _sincronizar
                            ? () {
                                rutaSelected = e;
                                _goInfoRuta2(e);
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
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
    return _paradasenviosdb.isEmpty ? _noContent2() : _getListView();
  }

//-------------------------------------------------------------------------
//-------------------------- METODO NOCONTENT2 ----------------------------
//-------------------------------------------------------------------------

  Widget _noContent2() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(
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
    paraSincronizar = 0;

    for (ParadaEnvio pe in _paradasenviosdb) {
      if (pe.enviado == 0) {
        paraSincronizar++;
      }
    }

    return ListView(
      padding: const EdgeInsets.only(top: 2),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: _paradasenviosdb.map((e) {
        return Card(
          color: e.enviado == 1 ? Colors.white : Colors.red[200],
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: InkWell(
            onTap: () {
              paradaenvioSelected = e;
            },
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          e.enviado == 1
                              ? const Icon(Icons.done_all, color: Colors.green)
                              : e.enviado == 0
                                  ? const Icon(Icons.done, color: Colors.grey)
                                  : const Icon(Icons.done, color: Colors.red),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Text("Ruta N°: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text("Parada N°: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text("Remito N°: ",
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
                                  style: const TextStyle(
                                    fontSize: 12,
                                  )),
                              Text(e.idParada.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  )),
                              Text(e.idEnvio.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
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
                                  DateFormat('dd/MM/yyyy')
                                      .format(DateTime.parse(e.fecha!)),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  )),
                              const Text("",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  )),
                              (e.estado == 4)
                                  ? const Text(
                                      "ENTREGADO",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : (e.estado == 10)
                                      ? const Text(
                                          "NO ENTREGADO",
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : (e.estado == 7)
                                          ? const Text(
                                              "RECHAZADO",
                                              style: const TextStyle(
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(
                                              "PENDIENTE",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
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
    );
  }

//-------------------------------------------------------------------------
//-------------------------- METODO CONTACTO ------------------------------
//-------------------------------------------------------------------------

  void _contacto() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ContactoScreen()));
  }

//-------------------------------------------------------------------------
//-------------------------- _storage -------------------------------------
//-------------------------------------------------------------------------

  void _storage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const StorageScreen()));
  }

//-------------------------------------------------------------------------
//-------------------------- METODO _cambiarPassword ----------------------
//-------------------------------------------------------------------------

  void _cambiarPassword() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
                  user: widget.user,
                )));

    if (result == 'yes') {
      _logOut();
    }
  }

//-------------------------------------------------------------------------
//-------------------------- METODO GOINFORUTA ----------------------------
//-------------------------------------------------------------------------

  void _goInfoRuta(RutaCab ruta) async {
    _paradasenviosselected = [];
    for (var element in _paradasenvios) {
      if (element.idRuta == ruta.idRuta) {
        _paradasenviosselected.add(element);
      }
    }

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
        _textComponent = "";
        _showLoader = true;
      });
      await _actualizaParadasEnvios();
      await _actualizaRutas();
      setState(() {
        _showLoader = false;
      });
    }
  }

//-------------------------------------------------------------------------
//-------------------------- METODO GOINFORUTA2 ---------------------------
//-------------------------------------------------------------------------

  void _goInfoRuta2(RutaCab ruta) async {
    _paradasenviosselected = [];
    for (var element in _paradasenvios) {
      if (element.idRuta == ruta.idRuta) {
        _paradasenviosselected.add(element);
      }
    }

    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RutaInfo2Screen(
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
        _textComponent = "Actualizando envíos en el Servidor";
        _showLoader = true;
      });

      // await _actualizaParadasEnvios();
      // await _actualizaRutas();
      // await _llenarparadasenvios();

      for (int i = 0; i < 2; i++) {
        await _actualizaParadasEnvios();
        await _actualizaRutas();
      }

      for (int i = 0; i < 4; i++) {
        await _llenarparadasenvios();
      }

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

//*****************************************************************************
//************************** METODO LOGOUT ************************************
//*****************************************************************************

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
//************************* PROVEEDORES ***************************************
//*****************************************************************************

  Future<void> _getProveedores() async {
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
      if (_proveedoresApi.isNotEmpty) {
        DBProveedores.delete();
        for (var element in _proveedoresApi) {
          DBProveedores.insertProveedor(element);
        }
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
  Future<void> _getRutas() async {
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

//------------------ _getTablaRutas ----------------------
  void _getTablaRutas() async {
    //..............  _insertRutas ................
    void _insertRutas() async {
      if (_rutasApi.isNotEmpty) {
        DBRutasCab.delete();
        DBParadas.delete();
        DBEnvios.delete();

        for (var ruta in _rutasApi) {
          RutaCab rutaCab = RutaCab(
              idRuta: ruta.idRuta,
              idUser: ruta.idUser,
              fechaAlta: ruta.fechaAlta,
              nombre: ruta.nombre,
              estado: ruta.estado,
              totalParadas: 0,
              pendientes: 0);
          DBRutasCab.insertRuta(rutaCab);

          if (ruta.paradas!.isNotEmpty) {
            for (var parada in ruta.paradas!) {
              if (parada.idEnvio != 0) {
                DBParadas.insertParada(parada);
              }
            }
          }

          if (ruta.envios!.isNotEmpty) {
            for (var envio in ruta.envios!) {
              DBEnvios.insertEnvio(envio);
            }
          }
        }
      }
    }

//...........................................
    if (_hayInternet) {
      _insertRutas();
    }

    _rutas = await DBRutasCab.rutas();
    _paradas = await DBParadas.paradas();
    _envios = await DBEnvios.envios();

    await _actualizaRutas();

    //_rutas = await DBRutasCab.rutas();

    for (var parada in _paradas) {
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
        observaciones: filteredEnvio.observaciones,
        enviadoparada: 0,
        enviadoenvio: 0,
        enviadoseguimiento: 0,
      );

      _paradasenvios.add(paradaEnvio);
    }

    if (_rutas.isEmpty) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              "No se encontraron Rutas activas para su Usuario. Comuníquese con el Administrador.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('usuariosconseguidos', false);
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

  Future<void> _getMotivos() async {
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
      if (_motivosApi.isNotEmpty) {
        DBMotivos.delete();
        for (var element in _motivosApi) {
          Motivo mot = Motivo(
              id: element.id,
              motivo: element.motivo,
              muestraParaEntregado: element.muestraParaEntregado);

          DBMotivos.insertMotivo(mot);
        }
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

  Future<void> _getParadasEnvios() async {
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
    return Future.delayed(const Duration(seconds: 1), () async {
      _paradasenviosdb = await DBParadasEnvios.paradasenvios();
      for (var paradaenvio in _paradasenviosdb) {
        if (DateTime.parse(paradaenvio.fecha!)
                .isBefore(DateTime.now().add(const Duration(days: -7))) &&
            paradaenvio.enviado != 0) {
          DBParadasEnvios.delete(paradaenvio);
        }
      }

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
                  children: const [
                    Text(
                      "Atención!!",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ],
                ),
                content: SizedBox(
                  height: 170,
                  child: Column(
                    children: [
                      Text(
                        "Para borrar las paradas grabadas en forma local de este teléfono para el Usuario  ${widget.user.apellidonombre} debe escribir su contraseña",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Text(""),
                      TextField(
                        obscureText: !_passwordShow,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Contraseña...',
                            labelText: 'Contraseña',
                            errorText:
                                _passwordShowError ? _passwordError : null,
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
                      children: const [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 15,
                        ),
                        Text('BORRAR'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      if (_password.toLowerCase() !=
                          widget.user.usrcontrasena.toLowerCase()) {
                        _passwordShowError = true;
                        _passwordError = 'Contraseña incorrecta';
                        setState(() {});
                      } else {
                        for (var element in _paradasenviosdb) {
                          DBParadasEnvios.delete(element);
                        }
                        _paradasenviosdb = [];
                        await showAlertDialog(
                            context: context,
                            title: 'Aviso',
                            message:
                                'Las paradas grabadas en forma local en este teléfono para el Usuario  ${widget.user.apellidonombre} han sido eliminadas',
                            actions: <AlertDialogAction>[
                              const AlertDialogAction(
                                  key: null, label: 'Aceptar'),
                            ]);
                        setState(() {});
                        _result2 = "yes";
                        Navigator.pop(context, 'yes');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel),
                        SizedBox(
                          width: 15,
                        ),
                        Text('CANCELAR'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF9a6a2e),
                      minimumSize: const Size(double.infinity, 50),
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

    for (var paradasenvio in _paradasenvios) {
      for (var paradasenviodb in _paradasenviosdb) {
        if (paradasenvio.idParada == paradasenviodb.idParada) {
          paradasenvio.estado = paradasenviodb.estado;
          paradasenvio.motivo = paradasenviodb.motivo;
          paradasenvio.motivodesc = paradasenviodb.motivodesc;
          paradasenvio.notas = paradasenviodb.notas;
          paradasenvio.fecha = paradasenviodb.fecha;
        }
      }
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _textComponent = "Actualizando envíos en el Servidor";
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }

    setState(() {});
  }

//*****************************************************************************
//******************** METODOS PARA GRABAR EN EL SERVIDOR *********************
//*****************************************************************************

  Future<void> _putParada(ParadaEnvio paradaenvio) async {
    for (var element in _paradas) {
      if (element.idParada == paradaenvio.idParada) {
        paradaSelected = element;
      }
    }

    String fec = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String hora = DateFormat('HH:mm').format(DateTime.now());

    if (paradaenvio.enviadoparada == 0) {
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
        Response response2 = await ApiHelper.getParadaByIDParada(
            paradaSelected.idParada.toString());
        if (response2.isSuccess) {
          //CHEQUEAR SI ESTADO GUARDADO ES IGUAL A ESTADO EN EL CELULAR
          paradaSaved = response2.result;
          if (paradaSaved.estado == paradaenvio.estado) {
            _ponerEnviadoParada1(paradaenvio);
          }
        }
      }
    }
    await _putEnvio(paradaenvio);
  }

  //-------------------------------------------------------------------------

  Future<void> _putEnvio(ParadaEnvio paradaenvio) async {
    for (var element in _envios) {
      if (element.idEnvio == paradaenvio.idEnvio) {
        envioSelected = element;
      }
    }

    double lat = 0.0;
    double long = 0.0;

    if (paradaenvio.estado == 4 ||
        paradaenvio.estado == 7 ||
        paradaenvio.estado == 10) {
      await _getPosition();
      lat = _positionUser.latitude.toString().isNotEmpty
          ? _positionUser.latitude
          : 0;
      long = _positionUser.longitude.toString().isNotEmpty
          ? _positionUser.longitude
          : 0;
    }

    if (paradaenvio.enviadoenvio == 0) {
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
        'imageArray': paradaenvio.imageArray,
        'latitud2': lat,
        'longitud2': long,
      };

      Response response = await ApiHelper.put(
          '/api/Envios/', envioSelected.idEnvio.toString(), requestEnvio);

      if (response.isSuccess) {
        Response response2 =
            await ApiHelper.getEnvioByIdEnvio(envioSelected.idEnvio.toString());
        if (response2.isSuccess) {
          //CHEQUEAR SI ESTADO GUARDADO ES IGUAL A ESTADO EN EL CELULAR
          envioSaved = response2.result;
          if (envioSaved.estado == paradaenvio.estado) {
            _ponerEnviadoEnvio1(paradaenvio);
          }
        }
      }
    }
    await _postSeguimiento(paradaenvio);
  }

  //-------------------------------------------------------------------------

  Future<void> _postSeguimiento(ParadaEnvio paradaenvio) async {
    int fec = DateTime.now().difference(DateTime(2022, 01, 01)).inDays + 80723;

    Response response2 = await ApiHelper.getNroRegistroMax();
    if (response2.isSuccess) {
      _nroReg = int.parse(response2.result.toString()) + 1;
    }

    if (paradaenvio.enviadoseguimiento == 0) {
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
        Response response2 = await ApiHelper.getUltimoSeguimientoByIdEnvio(
            paradaenvio.idEnvio.toString());
        if (response2.isSuccess) {
          //CHEQUEAR SI FECHA GUARDADA ES IGUAL A FECHA EN EL CELULAR
          seguimientoSaved = response2.result;
          if (seguimientoSaved.fecha == fec) {
            _ponerEnviadoSeguimiento1(paradaenvio);
          }
        }
      }
    }

    if (paradaenvio.enviadoparada == 1 &&
        paradaenvio.enviadoenvio == 1 &&
        paradaenvio.enviadoseguimiento == 1) {
      await _ponerEnviado1(paradaenvio);
      setState(() {});
    }
  }

  //-------------------------------------------------------------------------

  Future<void> _ponerEnviado1(ParadaEnvio paradaenvio) async {
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
      observaciones: paradaenvio.observaciones,
      enviadoparada: paradaenvio.enviadoparada,
      enviadoenvio: paradaenvio.enviadoenvio,
      enviadoseguimiento: paradaenvio.enviadoseguimiento,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
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

  //-------------------------------------------------------------------------

  Future<void> _ponerEnviadoParada1(ParadaEnvio paradaenvio) async {
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
      enviado: paradaenvio.enviado,
      fecha: paradaenvio.fecha,
      imageArray: paradaenvio.imageArray,
      observaciones: paradaenvio.observaciones,
      enviadoparada: 1,
      enviadoenvio: paradaenvio.enviadoenvio,
      enviadoseguimiento: paradaenvio.enviadoseguimiento,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    paradaenvio.enviadoparada = 1;
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (var element in _paradasenviosdb) {
      if (element.idParada == paradaenvionueva.idParada &&
          element.enviadoparada == 1) {}
    }
  }

  //-------------------------------------------------------------------------

  Future<void> _ponerEnviadoEnvio1(ParadaEnvio paradaenvio) async {
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
      enviado: paradaenvio.enviado,
      fecha: paradaenvio.fecha,
      imageArray: paradaenvio.imageArray,
      observaciones: paradaenvio.observaciones,
      enviadoparada: paradaenvio.enviadoparada,
      enviadoenvio: 1,
      enviadoseguimiento: paradaenvio.enviadoseguimiento,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    paradaenvio.enviadoenvio = 1;
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (var element in _paradasenviosdb) {
      if (element.idParada == paradaenvionueva.idParada &&
          element.enviadoenvio == 1) {}
    }
  }

//-------------------------------------------------------------------------
  Future<void> _ponerEnviadoSeguimiento1(ParadaEnvio paradaenvio) async {
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
      enviado: paradaenvio.enviado,
      fecha: paradaenvio.fecha,
      imageArray: paradaenvio.imageArray,
      observaciones: paradaenvio.observaciones,
      enviadoparada: paradaenvio.enviadoparada,
      enviadoenvio: paradaenvio.enviadoenvio,
      enviadoseguimiento: 1,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    paradaenvio.enviadoseguimiento = 1;
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (var element in _paradasenviosdb) {
      if (element.idParada == paradaenvionueva.idParada &&
          element.enviadoseguimiento == 1) {}
    }
  }

//-----------------------------------------------------------------------
//-------------------------- _showEnviosCount ---------------------------
//-----------------------------------------------------------------------
  Widget _showEnviosCount() {
    int sincronizados = 0;
    int nosincronizados = 0;
    for (var paradaenvio in _paradasenviosdb) {
      if (paradaenvio.enviado == 1) {
        sincronizados = sincronizados + 1;
      }
    }
    nosincronizados = _paradasenviosdb.length - sincronizados;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Sincronizados:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  sincronizados.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 125,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'No sincronizados:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  nosincronizados.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ],
              ),
            ),
          )),
    );
  }
}
