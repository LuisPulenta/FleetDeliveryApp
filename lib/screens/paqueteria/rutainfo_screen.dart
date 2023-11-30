import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class RutaInfoScreen extends StatefulWidget {
  final Usuario user;
  final RutaCab ruta;
  final List<Parada> paradas;
  final List<Envio> envios;
  final List<ParadaEnvio> paradasenvios;
  final Position positionUser;
  final List<Motivo> motivos;

  const RutaInfoScreen(
      {Key? key,
      required this.user,
      required this.ruta,
      required this.paradas,
      required this.envios,
      required this.paradasenvios,
      required this.positionUser,
      required this.motivos})
      : super(key: key);

  @override
  _RutaInfoScreenState createState() => _RutaInfoScreenState();
}

class _RutaInfoScreenState extends State<RutaInfoScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  bool _showLoader = false;
  bool _puso1 = false;
  bool _renovoState = false;

  bool _isFiltered = false;
  String _search = '';

  bool _todas = true;
  bool _sincronizar = true;

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  LatLng _center = const LatLng(0, 0);
  final Set<Marker> _markers = {};
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
    avonCodAmount: '',
    avonCodMemo: '',
    enviarMailSegunEstado: '',
  );

  ParadaEnvio parenv = ParadaEnvio(
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
    avonCodAmount: '',
    avonCodMemo: '',
    enviarMailSegunEstado: '',
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
    longitud2: 0,
    avonCodAmount: '',
    avonCodMemo: '',
  );

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
    longitud2: 0,
    avonCodAmount: '',
    avonCodMemo: '',
  );

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

  List<ParadaEnvio> _paradasenvios = [];
  List<ParadaEnvio> _paradasenviosfiltered = [];
  List<ParadaEnvio> _paradasenviosdb = [];

  int _nroReg = 0;

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _llenarparadasenvios();

    setState(() {});
  }

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdadada),
      appBar: AppBar(
        backgroundColor: const Color(0xff282886),
        title: Text(widget.ruta.nombre!),
        centerTitle: false,
        actions: [
          Row(
            children: [
              const Text(
                "Todas:",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Switch(
                  value: _todas,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                  onChanged: (value) {
                    _todas = value;
                    _llenarparadasenvios();
                    setState(() {});
                  }),
            ],
          ),
        ],
      ),
      body: Center(
        child: _showLoader ? const LoaderComponent(text: '') : _getContent(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "1",
            onPressed: () => _navegartodos(),
            child: _isFiltered
                ? IconButton(
                    onPressed: _removeFilter,
                    icon: const Icon(Icons.filter_none))
                : IconButton(
                    onPressed: _showFilter, icon: const Icon(Icons.filter_alt)),
            backgroundColor: const Color(0xff282886),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            heroTag: "2",
            onPressed: () => _navegartodos(),
            child: const Icon(
              Icons.map,
              size: 30,
            ),
            backgroundColor: const Color(0xff282886),
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _getContent ----------------------
//--------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showParadasCount(),
        Expanded(
          child: widget.paradas.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//--------------------------------------------------------
//--------------------- _showParadasCount ----------------
//--------------------------------------------------------

  Widget _showParadasCount() {
    int pendientes = 0;

    for (var element in _paradasenvios) {
      if (element.estado == 3) {
        pendientes++;
      }
    }

    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Paradas: ",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff282886),
                fontWeight: FontWeight.bold,
              )),
          Text(_paradasenviosfiltered.length.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff282886),
                fontWeight: FontWeight.bold,
              )),
          Text((' (Pendientes: $pendientes)'),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff282886),
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _noContent -----------------------
//--------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Paradas registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _getListView ---------------------
//--------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _llenarparadasenvios,
      child: ListView(
        children: _paradasenviosfiltered.map((e) {
          return Card(
            color: Colors.white60,
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () async {
                paradaenvioSelected = e;
                await _goInfoParada(e);
              },
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
                                      Expanded(
                                        child: Text(e.secuencia.toString(),
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Color(0xffbc2b51),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        child: Text(e.proveedor.toString(),
                                            style: const TextStyle(
                                                color: Color(0xff282886),
                                                fontWeight: FontWeight.bold)),
                                      ),
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
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : (e.estado == 7)
                                                  ? const Text(
                                                      "RECHAZADO",
                                                      style: TextStyle(
                                                          color: Colors.purple,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : const Text(
                                                      "PENDIENTE",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                    ],
                                  ),
                                  // const SizedBox(
                                  //   height: 5,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     const Text("EMSEst: ",
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           color: Color(0xFF781f1e),
                                  //           fontWeight: FontWeight.bold,
                                  //         )),
                                  //     Expanded(
                                  //       child: Text(
                                  //           e.enviarMailSegunEstado.toString(),
                                  //           style: const TextStyle(
                                  //               fontSize: 12,
                                  //               fontWeight: FontWeight.bold)),
                                  //     ),
                                  //   ],
                                  // ),
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
                                        child: Text(e.titular.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Dirección: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.leyenda.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 135,
                                        child: ElevatedButton(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.map,
                                                  color: Color(0xff282886)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                'Navegar',
                                                style: TextStyle(
                                                    color: Color(0xff282886)),
                                              ),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFb3b3b4),
                                            minimumSize:
                                                const Size(double.infinity, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () => _navegar(e),
                                        ),
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
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _goInfoParada --------------------
//--------------------------------------------------------

  Future<void> _goInfoParada(ParadaEnvio e) async {
    if (e.titular == null || e.titular!.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message:
              "Esta parada no tiene el Nombre del Cliente. Pruebe a volver a sincronizar/traer Rutas nuevamente.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParadaInfoScreen(
                user: widget.user,
                paradaenvio: e,
                positionUser: widget.positionUser,
                motivos: widget.motivos,
                paradas: widget.paradas,
                envios: widget.envios)));
    if (result == 'yes' || result != 'yes') {
      await _llenarparadasenvios();
    }

    await _llenarparadasenvios();
    setState(() {});
  }

//--------------------------------------------------------
//--------------------- _navegar -------------------------
//--------------------------------------------------------

  _navegar(e) async {
    if (e.latitud == 0 ||
        e.longitud == 0 ||
        isNullOrEmpty(e.latitud) ||
        isNullOrEmpty(e.longitud)) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "Esta parada no tiene coordenadas cargadas.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _center = LatLng(e.latitud!.toDouble(), e.longitud!.toDouble());
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(e.secuencia.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: e.titular.toString(),
        snippet: e.domicilio.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      var uri = Uri.parse(
          "google.navigation:q=${e.latitud!.toDouble()},${e.longitud!.toDouble()}&mode=d");
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch ${uri.toString()}';
      }
    } else {
      await showAlertDialog(
          context: context,
          title: 'Aviso!',
          message: "Necesita estar conectado a Internet para acceder al mapa",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

//--------------------------------------------------------
//--------------------- _navegartodos --------------------
//--------------------------------------------------------

  _navegartodos() async {
    _markers.clear();

    Uint8List markerIcon = await getBytesFromCanvas(1, 20, 20, 3);

    for (ParadaEnvio element in _paradasenvios) {
      if (!isNullOrEmpty(element.latitud) && !isNullOrEmpty(element.longitud)) {
        _markers.add(
          Marker(
            markerId: MarkerId(element.secuencia.toString()),
            position: LatLng(
                element.latitud!.toDouble(), element.longitud!.toDouble()),
            // infoWindow: InfoWindow(
            //   title: element.titular.toString(),
            //   snippet: element.domicilio.toString(),
            // ),

            icon: (element.estado == 3)
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue)
                : (element.estado == 4)
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen)
                    : (element.estado == 10)
                        ? BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed)
                        : (element.estado == 7)
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueViolet)
                            : BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
          ),
        );
      }
    }

    for (ParadaEnvio element in _paradasenvios) {
      if (!isNullOrEmpty(element.latitud) && !isNullOrEmpty(element.longitud)) {
        markerIcon = await getBytesFromCanvas(
            element.secuencia!.toInt(), 100, 100, element.estado!.toInt());
        _markers.add(
          Marker(
            markerId: MarkerId(element.secuencia.toString()),
            position: LatLng(
                element.latitud!.toDouble(), element.longitud!.toDouble()),
            // infoWindow: InfoWindow(
            //   title: element.titular.toString(),
            //   snippet: element.domicilio.toString(),
            // ),
            onTap: () {
              // CameraPosition(
              //     target: LatLng(element.latitud!.toDouble(),
              //         element.longitud!.toDouble()),
              //     zoom: 16.0);
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: (element.estado == 3)
                              ? const Color(0xff3933f2)
                              : (element.estado == 4)
                                  ? const Color(0xff31eb2f)
                                  : (element.estado == 10)
                                      ? const Color(0xffe9353a)
                                      : (element.estado == 7)
                                          ? const Color(0xff8a36e4)
                                          : const Color(0xff3933f2),
                          child: Text(
                            element.secuencia.toString(),
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(
                                element.titular.toString(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )),
                              Expanded(
                                  child: Text(element.domicilio.toString(),
                                      style: const TextStyle(fontSize: 12))),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.map,
                                              color: Color(0xff282886)),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Navegar',
                                            style: TextStyle(
                                                color: Color(0xff282886)),
                                          ),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFb3b3b4),
                                        minimumSize:
                                            const Size(double.infinity, 30),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () => _navegar(element),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Abrir',
                                            style: TextStyle(
                                                color: Color(0xff282886)),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_forward_ios,
                                              color: Color(0xff282886)),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFb3b3b4),
                                        minimumSize:
                                            const Size(double.infinity, 30),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () => _goInfoParada(element),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  LatLng(element.latitud!.toDouble(),
                      element.longitud!.toDouble()));
            },
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      }
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      bool band = true;
      for (var pe in _paradasenvios) {
        if (band) {
          if (pe.latitud != null && pe.longitud != null) {
            parenv = pe;
            band = false;
          }
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParadaMapScreen(
            user: widget.user,
            positionUser: widget.positionUser,
            paradaenvio: parenv,
            markers: _markers,
            customInfoWindowController: _customInfoWindowController,
          ),
        ),
      );
    } else {
      await showAlertDialog(
          context: context,
          title: 'Aviso!',
          message: "Necesita estar conectado a Internet para acceder al mapa",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

//--------------------------------------------------------
//--------------------- _llenarparadasenvios -------------
//--------------------------------------------------------

  Future<void> _llenarparadasenvios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _sincronizar = prefs.getBool('sincronizar') ?? false;

    _paradasenvios = [];
    for (var paradasenvio in widget.paradasenvios) {
      if (_todas) {
        _paradasenvios.add(paradasenvio);
      } else {
        if (paradasenvio.estado == 0 || paradasenvio.estado == 3) {
          _paradasenvios.add(paradasenvio);
        }
      }
    }
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();

    for (var paradaenvio in _paradasenviosdb) {
      if (DateTime.parse(paradaenvio.fecha!)
              .isBefore(DateTime.now().add(const Duration(days: -7))) &&
          paradaenvio.enviado != 0) {
        DBParadasEnvios.delete(paradaenvio);
      }
    }

    _paradasenviosdb = await DBParadasEnvios.paradasenvios();

    for (var paradasenvio in _paradasenvios) {
      for (var paradasenviodb in _paradasenviosdb) {
        if (paradasenvio.idParada == paradasenviodb.idParada) {
          paradasenvio.estado = paradasenviodb.estado;
          paradasenvio.motivo = paradasenviodb.motivo;
          paradasenvio.motivodesc = paradasenviodb.motivodesc;
          paradasenvio.notas = paradasenviodb.notas;
          paradasenvio.fecha = paradasenviodb.fecha;
          paradasenvio.imageArray = paradasenviodb.imageArray;
          paradasenvio.enviado = paradasenviodb.enviado;
          paradasenvio.enviado = paradasenviodb.enviado;
          paradasenvio.observaciones = paradasenviodb.observaciones;
        }
      }
    }

    if (_sincronizar) {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        _renovoState = false;

        do {
          setState(() {
            _showLoader = true;
          });
          _renovoState = true;
        } while (_renovoState == false);

        for (var paradaenvio in _paradasenviosdb) {
          if (paradaenvio.enviado == 0) {
            await _putParada(paradaenvio);
          }
        }

        do {
          setState(() {
            _showLoader = false;
          });
          _renovoState = true;
        } while (_renovoState == false);
      }
    }

    _paradasenvios.sort((a, b) {
      return a.secuencia!.toInt().compareTo(b.secuencia!.toInt());
    });

    _paradasenviosfiltered = _paradasenvios;
    setState(() {});
  }

//--------------------------------------------------------
//--------------------- _putParada -----------------------
//--------------------------------------------------------

  Future<void> _putParada(ParadaEnvio paradaenvio) async {
    for (var element in widget.paradas) {
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
            await _ponerEnviadoParada1(paradaenvio);
          }
        }
      }
    }
    await _putEnvio(paradaenvio);
  }

//--------------------------------------------------------
//--------------------- _putEnvio ------------------------
//--------------------------------------------------------

  Future<void> _putEnvio(ParadaEnvio paradaenvio) async {
    for (var element in widget.envios) {
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
        'enviarMailSegunEstado': paradaenvio.enviarMailSegunEstado,
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
            await _ponerEnviadoEnvio1(paradaenvio);
          }
        }
      }
    }
    await _postSeguimiento(paradaenvio);
  }

//--------------------------------------------------------
//--------------------- _postSeguimiento -----------------
//--------------------------------------------------------

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
          seguimientoSaved = response2.result;
          if (seguimientoSaved.fecha == fec) {
            await _ponerEnviadoSeguimiento1(paradaenvio);
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

//--------------------------------------------------------
//--------------------- _ponerEnviado1 -------------------
//--------------------------------------------------------

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
        observaciones: paradaenvio.observaciones,
        enviadoparada: paradaenvio.enviadoparada,
        enviadoenvio: paradaenvio.enviadoenvio,
        enviadoseguimiento: paradaenvio.enviadoenvio,
        avonCodAmount: paradaenvio.avonCodAmount,
        avonCodMemo: paradaenvio.avonCodMemo,
        enviarMailSegunEstado: paradaenvio.enviarMailSegunEstado,
      );

      await DBParadasEnvios.update(paradaenvionueva);
      _paradasenviosdb = await DBParadasEnvios.paradasenvios();
      for (var element in _paradasenviosdb) {
        if (element.idParada == paradaenvionueva.idParada &&
            element.enviado == 1) {
          _puso1 = true;
        }
      }
    } while (_puso1 == false);
  }

//--------------------------------------------------------
//--------------------- isNullOrEmpty --------------------
//--------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);

//--------------------------------------------------------
//--------------------- getBytesFromAsset ----------------
//--------------------------------------------------------

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData? data = await rootBundle.load(path.toString());
    ui.Codec? codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

//--------------------------------------------------------
//--------------------- getBytesFromCanvas ---------------
//--------------------------------------------------------

  Future<Uint8List> getBytesFromCanvas(
      int customNum, int width, int height, int estado) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    if (estado == 3) {}

    if (estado == 4) {}

    if (estado == 10) {}

    if (estado == 7) {}

    TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);

    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: const TextStyle(
          fontSize: 28.0, color: Colors.white, fontWeight: FontWeight.bold),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * .5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

//--------------------------------------------------------
//--------------------- _getPosition ---------------------
//--------------------------------------------------------

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

    _positionUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

//--------------------------------------------------------
//--------------------- _ponerEnviadoParada1 -------------
//--------------------------------------------------------

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
      avonCodAmount: paradaenvio.avonCodAmount,
      avonCodMemo: paradaenvio.avonCodMemo,
      enviarMailSegunEstado: paradaenvio.enviarMailSegunEstado,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    paradaenvio.enviadoparada = 1;
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (var element in _paradasenviosdb) {
      if (element.idParada == paradaenvionueva.idParada &&
          element.enviadoparada == 1) {}
    }
  }

//--------------------------------------------------------
//--------------------- _ponerEnviadoEnvio1 --------------
//--------------------------------------------------------

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
      avonCodAmount: paradaenvio.avonCodAmount,
      avonCodMemo: paradaenvio.avonCodMemo,
      enviarMailSegunEstado: paradaenvio.enviarMailSegunEstado,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    paradaenvio.enviadoenvio = 1;
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (var element in _paradasenviosdb) {
      if (element.idParada == paradaenvionueva.idParada &&
          element.enviadoenvio == 1) {}
    }
  }

//--------------------------------------------------------
//--------------------- _ponerEnviadoSeguimiento1 --------
//--------------------------------------------------------

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
      avonCodAmount: paradaenvio.avonCodAmount,
      avonCodMemo: paradaenvio.avonCodMemo,
      enviarMailSegunEstado: paradaenvio.enviarMailSegunEstado,
    );

    await DBParadasEnvios.update(paradaenvionueva);
    paradaenvio.enviadoseguimiento = 1;
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();
    for (var element in _paradasenviosdb) {
      if (element.idParada == paradaenvionueva.idParada &&
          element.enviadoseguimiento == 1) {}
    }
  }

//--------------------------------------------------------
//--------------------- _removeFilter --------------------
//--------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _search = '';
      _isFiltered = false;
    });
    _paradasenviosfiltered = _paradasenvios;
    _filter();
  }

//--------------------------------------------------------
//--------------------- _showFilter ----------------------
//--------------------------------------------------------

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Filtrar Paradas'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text('Escriba texto a buscar en Nombre o Dirección'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Criterio de búsqueda...',
                    labelText: 'Buscar',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Filtrar')),
            ],
          );
        });
  }

//--------------------------------------------------------
//--------------------- _filter --------------------------
//--------------------------------------------------------

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<ParadaEnvio> filteredList = [];
    for (var paradasenvio in _paradasenvios) {
      if (paradasenvio.domicilio!
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          paradasenvio.titular!.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(paradasenvio);
      }
    }

    setState(() {
      _paradasenviosfiltered = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
}
