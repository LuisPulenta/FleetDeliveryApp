import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/helpers/dbparadasenvios_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'dart:ui' as ui;

class ParadaInfoScreen extends StatefulWidget {
  final Usuario user;
  final ParadaEnvio paradaenvio;
  final Position positionUser;
  final List<Motivo> motivos;
  final List<Parada> paradas;
  final List<Envio> envios;

  const ParadaInfoScreen(
      {Key? key,
      required this.user,
      required this.paradaenvio,
      required this.positionUser,
      required this.motivos,
      required this.paradas,
      required this.envios})
      : super(key: key);

  @override
  _ParadaInfoScreenState createState() => _ParadaInfoScreenState();
}

class _ParadaInfoScreenState extends State<ParadaInfoScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  bool _photoChanged = false;
  late XFile _image;

  int _optionEstado = 0;
  String _optionEstadoError = '';
  bool _optionEstadoShowError = false;
  List<Option> _listoptions = [];

  int _optionMotivo = 0;
  int _estado = 0;

  String _optionMotivoError = '';
  bool _optionMotivoShowError = false;

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();
  String _motivodesc = '';

  List<DropdownMenuItem<int>> _items = [];
  List<ParadaEnvio> _paradasEnvios = [];
  ParadaEnvio _paradaEnvioSelected = ParadaEnvio(
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

  LatLng _center = const LatLng(0, 0);
  final Set<Marker> _markers = {};

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getlistOptions();
    setState(() {});
  }

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.paradaenvio.estado == 3
            ? Text(
                'Parada: ${widget.paradaenvio.secuencia.toString()} PENDIENTE')
            : widget.paradaenvio.estado == 4
                ? Text(
                    'Parada: ${widget.paradaenvio.secuencia.toString()} ENTREGADO')
                : widget.paradaenvio.estado == 10
                    ? Text(
                        'Parada: ${widget.paradaenvio.secuencia.toString()} NO ENTREGADO')
                    : widget.paradaenvio.estado == 7
                        ? Text(
                            'Parada: ${widget.paradaenvio.secuencia.toString()} RECHAZADO')
                        : Text(
                            'Parada: ${widget.paradaenvio.secuencia.toString()} PENDIENTE'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _showCliente(),
            _showPaquete(),
            _showDelivery(),
            _showButton(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showCliente ---------------------
//--------------------------------------------------------

  Widget _showCliente() {
    return Column(children: [
      Card(
        margin: const EdgeInsets.all(10),
        color: const Color(0xffb3b3b4),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Cliente",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              color: const Color(0xff8b8cb6),
              width: double.infinity,
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paradaenvio.titular.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(('DOC: ${widget.paradaenvio.dni.toString()}'))
                      ],
                    ),
                  ),
                ],
              ),
              color: const Color(0xffdadada),
              width: double.infinity,
            ),
            const Divider(
              height: 3,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(Icons.home),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 240,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paradaenvio.leyenda.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                            ('Entre: ${widget.paradaenvio.entreCalles.toString()}')),
                        Text(
                          '${widget.paradaenvio.localidad.toString()} (${widget.paradaenvio.cp.toString().replaceAll(" ", "")})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.map,
                      color: Colors.blue,
                      size: 34,
                    ),
                    onPressed: () => _navegar(widget.paradaenvio),
                  ),
                ],
              ),
              color: const Color(0xffdadada),
              width: double.infinity,
            ),
            const Divider(
              height: 3,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(Icons.phone),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paradaenvio.telefonos.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.phone_forwarded,
                        color: Colors.green,
                        size: 34,
                      ),
                      onPressed: () {
                        String tel = widget.paradaenvio.telefonos != null
                            ? widget.paradaenvio.telefonos!.trim()
                            : "";
                        if (tel != "") {
                          launch(
                              'tel://${widget.paradaenvio.telefonos.toString()}');
                        }
                      }),
                ],
              ),
              color: const Color(0xffdadada),
              width: double.infinity,
              height: 60,
            ),
          ],
        ),
      ),
    ]);
  }

//--------------------------------------------------------
//--------------------- _showPaquete ---------------------
//--------------------------------------------------------

  _showPaquete() {
    return Card(
      margin: const EdgeInsets.all(10),
      color: const Color(0xffb3b3b4),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Paquete - ${widget.paradaenvio.proveedor.toString()}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            color: const Color(0xff8b8cb6),
            width: double.infinity,
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.receipt_long),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ('N° Remito: ${widget.paradaenvio.idEnvio.toString()} N° Orden Id: ${widget.paradaenvio.ordenid.toString()}'))
                    ],
                  ),
                ),
              ],
            ),
            color: const Color(0xffdadada),
            width: double.infinity,
          ),
          const Divider(
            height: 3,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.inventory_2),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ('Cant. de bultos: ${widget.paradaenvio.bultos.toString()}'))
                    ],
                  ),
                ),
              ],
            ),
            color: const Color(0xffdadada),
            width: double.infinity,
          ),
          const Divider(
            height: 3,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.format_list_bulleted),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ('Observaciones: ${widget.paradaenvio.observaciones.toString()}')),
                    ],
                  ),
                ),
              ],
            ),
            color: const Color(0xffdadada),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showDelivery ------------------------
//--------------------------------------------------------

  _showDelivery() {
    return Card(
      margin: const EdgeInsets.all(10),
      color: const Color(0xffb3b3b4),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Delivery",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            color: const Color(0xff8b8cb6),
            width: double.infinity,
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 145,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.fact_check),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(('Estado: ')),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: DropdownButtonFormField(
                            items: _items,
                            value: _optionEstado,
                            onChanged: (option) {
                              setState(() {
                                _optionMotivo = 0;
                                _optionEstado = option as int;
                                _estado = option;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Seleccione un Estado...',
                              labelText: '',
                              fillColor: Colors.white,
                              filled: true,
                              errorText: _optionEstadoShowError
                                  ? _optionEstadoError
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: const Color(0xffdadada),
            width: double.infinity,
          ),
          (_optionEstado == 10 || _optionEstado == 7 || _optionEstado == 4)
              ? const Divider(
                  height: 3,
                )
              : Container(),
          (_optionEstado == 10 || _optionEstado == 7 || _optionEstado == 4)
              ? Container(
                  padding: const EdgeInsets.all(10),
                  height: 145,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(Icons.fact_check),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(('Motivo: ')),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                  value: _optionMotivo,
                                  onChanged: (option) {
                                    setState(() {
                                      _optionMotivo = option as int;
                                      for (var motivo in widget.motivos) {
                                        if (motivo.id == _optionMotivo) {
                                          _motivodesc =
                                              motivo.motivo.toString();
                                        }
                                      }
                                    });
                                  },
                                  items: _getOptions2(),
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione un Motivo...',
                                    labelText: '',
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorText: _optionMotivoShowError
                                        ? _optionMotivoError
                                        : null,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  color: const Color(0xffdadada),
                  width: double.infinity,
                )
              : Container(),
          const Divider(
            height: 3,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.format_list_bulleted),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(('Notas: ')),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          maxLines: 3,
                          controller: _observacionesController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '',
                              labelText: 'Puede escribir Notas aquí...',
                              errorText: _observacionesShowError
                                  ? _observacionesError
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onChanged: (value) {
                            _observaciones = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: const Color(0xffdadada),
            width: double.infinity,
          ),
          const Divider(
            height: 3,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Icon(Icons.badge),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(('Documentación: ')),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              size: 12,
                            ),
                            const Text(('   Tomar foto')),
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.photo_camera,
                                color: Colors.blue,
                                size: 34,
                              ),
                              onPressed: () => _goAddPhoto(),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            !_photoChanged
                                ? const Image(
                                    image: AssetImage('assets/noimage.png'),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover)
                                : Image.file(
                                    File(_image.path),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.contain,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: const Color(0xffdadada),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showButton ----------------------
//--------------------------------------------------------

  Widget _showButton() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF120E43),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _save,
              ),
            ),
          ],
        ));
  }

//--------------------------------------------------------
//--------------------- _navegar -------------------------
//--------------------------------------------------------

  _navegar(ParadaEnvio paradaenvio) async {
    Uint8List markerIcon = await getBytesFromCanvas(1, 20, 20, 3);

    if (paradaenvio.latitud == 0 ||
        paradaenvio.longitud == 0 ||
        isNullOrEmpty(paradaenvio.latitud) ||
        isNullOrEmpty(paradaenvio.longitud)) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "Esta parada no tiene coordenadas cargadas.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    _center = LatLng(
        paradaenvio.latitud!.toDouble(), paradaenvio.longitud!.toDouble());
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(paradaenvio.secuencia.toString()),
      position: _center,
      icon: (paradaenvio.estado == 3)
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
          : (paradaenvio.estado == 4)
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : (paradaenvio.estado == 10)
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed)
                  : (paradaenvio.estado == 7)
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet)
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
    ));

    markerIcon = await getBytesFromCanvas(
        paradaenvio.secuencia!.toInt(), 100, 100, paradaenvio.estado!.toInt());
    _markers.add(Marker(
      markerId: MarkerId(paradaenvio.secuencia.toString()),
      position: LatLng(
          paradaenvio.latitud!.toDouble(), paradaenvio.longitud!.toDouble()),
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
                    backgroundColor: (paradaenvio.estado == 3)
                        ? const Color(0xff3933f2)
                        : (paradaenvio.estado == 4)
                            ? const Color(0xff31eb2f)
                            : (paradaenvio.estado == 10)
                                ? const Color(0xffe9353a)
                                : (paradaenvio.estado == 7)
                                    ? const Color(0xff8a36e4)
                                    : const Color(0xff3933f2),
                    child: Text(
                      paradaenvio.secuencia.toString(),
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
                          paradaenvio.titular.toString(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            child: Text(paradaenvio.domicilio.toString(),
                                style: const TextStyle(fontSize: 12))),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.map, color: Color(0xff282886)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Navegar',
                                      style:
                                          TextStyle(color: Color(0xff282886)),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFb3b3b4),
                                  minimumSize: const Size(double.infinity, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () => _navegar2(paradaenvio),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LatLng(paradaenvio.latitud!.toDouble(),
                paradaenvio.longitud!.toDouble()));
      },
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParadaMapScreen(
                  user: widget.user,
                  positionUser: widget.positionUser,
                  paradaenvio: paradaenvio,
                  markers: _markers,
                  customInfoWindowController: _customInfoWindowController,
                )));
  }

//--------------------------------------------------------
//--------------------- _navegar2 ------------------------
//--------------------------------------------------------

  _navegar2(e) async {
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
//--------------------- _getOptions2 ---------------------
//--------------------------------------------------------

  List<DropdownMenuItem<int>> _getOptions2() {
    List<DropdownMenuItem<int>> list = [];

//Agrega Seleccione un Motivo
    list.add(const DropdownMenuItem(
      child: Text('Seleccione un Motivo...'),
      value: 0,
    ));

//Agrega motivos para No Entregados o Rechazados
    if (_optionEstado == 7 || _optionEstado == 10) {
      for (var element in widget.motivos) {
        if (element.activo == 1) {
          if (element.muestraParaEntregado == 0) {
            if (element.exclusivoCliente == widget.paradaenvio.idproveedor) {
              list.add(DropdownMenuItem(
                child: Text(element.motivo.toString()),
                value: element.id,
              ));
            }
          }
        }
      }
    }

//Agrega motivos para Entregados
    if (_optionEstado == 4) {
      for (var element in widget.motivos) {
        if (element.activo == 1) {
          if (element.muestraParaEntregado == 1) {
            if (element.exclusivoCliente == widget.paradaenvio.idproveedor) {
              list.add(DropdownMenuItem(
                child: Text(element.motivo.toString()),
                value: element.id,
              ));
            }
          }
        }
      }
    }

    return list;
  }
//--------------------------------------------------------
//--------------------- _takePicture ---------------------
//--------------------------------------------------------

  Future _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'Trasera'),
          const AlertDialogAction(key: 'yes', label: 'Delantera'),
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _image = response.result;
        });
      }
    }
  }

//--------------------------------------------------------
//--------------------- _goAddPhoto ----------------------
//--------------------------------------------------------

  void _goAddPhoto() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿De donde deseas obtener la imagen?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
          const AlertDialogAction(key: 'camera', label: 'Cámara'),
          const AlertDialogAction(key: 'gallery', label: 'Galería'),
        ]);

    if (response == 'cancel') {
      return;
    }

    if (response == 'camera') {
      await _takePicture();
    } else {
      await _selectPicture();
    }
  }

//--------------------------------------------------------
//--------------------- _selectPicture -------------------
//--------------------------------------------------------

  Future<void> _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _image2 = await _picker.pickImage(source: ImageSource.gallery);

    if (_image2 != null) {
      setState(() {
        _photoChanged = true;
        _image = _image2;
      });
    }
  }

//--------------------------------------------------------
//--------------------- _save ----------------------------
//--------------------------------------------------------

  _save() async {
    if (!validateFields()) {
      return;
    }
    await _saveRecord();
  }

//--------------------------------------------------------
//--------------------- validateFields -------------------
//--------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_estado == 0) {
      isValid = false;
      _optionEstadoShowError = true;
      _optionEstadoError = 'Debes seleccionar un Estado';
    } else {
      _optionEstadoShowError = false;
    }

    if (_estado == 7 || _estado == 10 || _estado == 4) {
      if (_optionMotivo == 0) {
        isValid = false;
        _optionMotivoShowError = true;
        _optionMotivoError = 'Debes seleccionar un Motivo';
      } else {
        _optionMotivoShowError = false;
      }
    }

    setState(() {});

    return isValid;
  }

//--------------------------------------------------------
//--------------------- _saveRecord ----------------------
//--------------------------------------------------------

  Future<void> _saveRecord() async {
    _paradasEnvios = await DBParadasEnvios.paradasenvios();
    for (ParadaEnvio paradaenvio in _paradasEnvios) {
      if (paradaenvio.idParada == widget.paradaenvio.idParada) {
        _paradaEnvioSelected = paradaenvio;
      }
    }

    await DBParadasEnvios.delete(_paradaEnvioSelected);
    await _guardaParadaEnBDLocal();
    Navigator.pop(context, 'yes');
  }

//--------------------------------------------------------
//--------------------- _guardaParadaEnBDLocal -----------
//--------------------------------------------------------

  Future<void> _guardaParadaEnBDLocal() async {
    for (var element in widget.paradas) {
      if (element.idParada == widget.paradaenvio.idParada) {
        paradaSelected = element;
      }
    }

    if (paradaSelected == null) {
      await showAlertDialog(
          context: context,
          title: 'Error 1',
          message: "No se ha podido grabar",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    String base64Image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    ParadaEnvio requestParadaEnvio = ParadaEnvio(
      idParada: widget.paradaenvio.idParada,
      idRuta: widget.paradaenvio.idRuta,
      idEnvio: widget.paradaenvio.idEnvio,
      secuencia: widget.paradaenvio.secuencia,
      leyenda: widget.paradaenvio.leyenda,
      latitud: widget.paradaenvio.latitud,
      longitud: widget.paradaenvio.longitud,
      idproveedor: widget.paradaenvio.idproveedor,
      estado: _estado,
      ordenid: widget.paradaenvio.ordenid,
      titular: widget.paradaenvio.titular,
      dni: widget.paradaenvio.dni,
      domicilio: widget.paradaenvio.domicilio,
      cp: widget.paradaenvio.cp,
      entreCalles: widget.paradaenvio.entreCalles,
      telefonos: widget.paradaenvio.telefonos,
      localidad: widget.paradaenvio.localidad,
      bultos: widget.paradaenvio.bultos,
      proveedor: widget.paradaenvio.proveedor,
      motivo: _optionMotivo,
      motivodesc: _motivodesc,
      notas: _observaciones,
      enviado: 0,
      fecha: DateTime.now().toString(),
      imageArray: base64Image,
      observaciones: widget.paradaenvio.observaciones,
      enviadoparada: 0,
      enviadoenvio: 0,
      enviadoseguimiento: 0,
    );

    var parEnvio = await DBParadasEnvios.insertParadaEnvio(requestParadaEnvio);

    if (parEnvio == null || parEnvio == 0) {
      await showAlertDialog(
          context: context,
          title: 'Error 2',
          message: "No se ha podido grabar",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _showSnackbar();
  }

//--------------------------------------------------------
//--------------------- _getlistOptions ------------------
//--------------------------------------------------------

  void _getlistOptions() {
    _items = [];
    _listoptions = [];

    Option opt1 = Option(id: 3, description: 'Pendiente');
    Option opt2 = Option(id: 4, description: 'Entregado');
    Option opt3 = Option(id: 10, description: 'No Entregado');
    Option opt4 = Option(id: 7, description: 'Rechazado');
    _listoptions.add(opt1);
    _listoptions.add(opt2);
    _listoptions.add(opt3);
    _listoptions.add(opt4);

    _loadFieldValues();
  }

//--------------------------------------------------------
//--------------------- _loadFieldValues -----------------
//--------------------------------------------------------

  void _loadFieldValues() {
    _estado = widget.paradaenvio.estado!;
    _optionMotivo = widget.paradaenvio.motivo!;
    _observaciones = widget.paradaenvio.notas.toString();
    _observacionesController.text = _observaciones;
    _optionEstado = widget.paradaenvio.estado!;

    _getComboEstados();
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
//--------------------- _getComboEstados -----------------
//--------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboEstados() {
    _items = [];

    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Seleccione un Estado...'),
      value: 0,
    ));

    for (var _listoption in _listoptions) {
      list.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.id,
      ));
    }

    _items = list;

    return list;
  }

//--------------------------------------------------------
//--------------------- _showSnackbar --------------------
//--------------------------------------------------------

  void _showSnackbar() {
    SnackBar snackbar = const SnackBar(
      content: Text("Estado de Parada grabada con éxito"),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

//--------------------------------------------------------
//--------------------- isNullOrEmpty --------------------
//--------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);
}
