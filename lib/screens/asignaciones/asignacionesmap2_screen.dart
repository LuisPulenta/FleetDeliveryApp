import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AsignacionesMap2Screen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;
  final Asignacion2 asignacion;
  final LatLng posicion;
  final List<Asignacion2> asignaciones2;
  final CustomInfoWindowController customInfoWindowController;
  final int valorMarcador;

  const AsignacionesMap2Screen(
      {Key? key,
      required this.user,
      required this.positionUser,
      required this.asignacion,
      required this.posicion,
      required this.asignaciones2,
      required this.customInfoWindowController,
      required this.valorMarcador})
      : super(key: key);

  @override
  AsignacionesMap2ScreenState createState() => AsignacionesMap2ScreenState();
}

class AsignacionesMap2ScreenState extends State<AsignacionesMap2Screen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  List<Asignacion2> asignacionesTemporal = [];
  bool bandera = false;
  List<Asign> _asigns = [];

  bool ubicOk = false;
  int _valorMarcador = 0;
  double latitud = 0;
  double longitud = 0;
  final bool _showLoader = false;
  Set<Marker> _markers = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  Position position = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0);
  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(31, 64), zoom: 10.0);

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _getMarkers();
    _valorMarcador = widget.valorMarcador;

    _initialPosition = CameraPosition(target: widget.posicion, zoom: 10.0);

    ubicOk = true;

    setState(() {});
  }

  @override
  void dispose() {
    widget.customInfoWindowController.dispose();
    super.dispose();
  }

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(('Mapa Asign. ${widget.asignacion.proyectomodulo}')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Stack(children: <Widget>[
                  GoogleMap(
                    onTap: (position) {
                      widget.customInfoWindowController.hideInfoWindow!();
                    },
                    myLocationEnabled: true,
                    initialCameraPosition: _initialPosition,
                    markers: _markers,
                    mapType: _defaultMapType,
                    onMapCreated: (GoogleMapController controller) async {
                      widget.customInfoWindowController.googleMapController =
                          controller;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80, right: 10),
                    alignment: Alignment.topRight,
                    child: Column(children: <Widget>[
                      FloatingActionButton(
                          elevation: 5,
                          backgroundColor: const Color(0xfff4ab04),
                          onPressed: () {
                            _changeMapType();
                          },
                          child: const Icon(Icons.layers)),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 10),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ui.Color.fromARGB(255, 108, 9, 126),
                                minimumSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                _renumerar();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.pin),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Renumerar',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              )),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffdf281e),
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              _borrar();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.cancel),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('Borrar todo',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 80,
                        ),
                      ],
                    ),
                  ),
                ])
              : Container(),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
          CustomInfoWindow(
            controller: widget.customInfoWindowController,
            height: 140,
            width: 300,
            offset: 100,
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _changeMapType -------------------
//--------------------------------------------------------

  void _changeMapType() {
    _defaultMapType = _defaultMapType == MapType.normal
        ? MapType.satellite
        : _defaultMapType == MapType.satellite
            ? MapType.hybrid
            : MapType.normal;
    setState(() {});
  }

//--------------------------------------------------------
//--------------------- _getMarkers ----------------------
//--------------------------------------------------------

  _getMarkers() async {
    _markers.clear();

    Uint8List markerIcon = await getBytesFromCanvas(1, 20, 20, 3);

    double latmin = 180.0;
    double latmax = -180.0;
    double longmin = 180.0;
    double longmax = -180.0;
    double latcenter = 0.0;
    double longcenter = 0.0;

    for (Asignacion2 asign in widget.asignaciones2) {
      var lat = double.tryParse(asign.grxx.toString()) ?? 0;
      var long = double.tryParse(asign.gryy.toString()) ?? 0;

      if (lat.toString().length > 3 && long.toString().length > 3) {
        if (lat < latmin) {
          latmin = lat;
        }
        if (lat > latmax) {
          latmax = lat;
        }
        if (long < longmin) {
          longmin = long;
        }
        if (long > longmax) {
          longmax = long;
        }

        _markers.add(Marker(
            markerId: MarkerId(asign.cliente.toString()),
            position: LatLng(lat, long),
            onTap: () {
              if (asign.marcado == 0) {
                _valorMarcador++;
                asign.marcado = _valorMarcador;
              } else {
                asign.marcado = 0;
              }
              _getAsigns(asign);
              _getMarkers();
            },
            icon: asign.marcado == 0
                ? asign.proyectomodulo == 'Otro' && asign.fechaCita != null
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue)
                    : (asign.codigoCierre == 0)
                        ? BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed)
                        : BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet)));
      }
    }

    for (Asignacion2 asign in widget.asignaciones2) {
      var lat = double.tryParse(asign.grxx.toString()) ?? 0;
      var long = double.tryParse(asign.gryy.toString()) ?? 0;

      if (!isNullOrEmpty(asign.grxx) &&
          !isNullOrEmpty(asign.gryy) &&
          asign.marcado! > 0) {
        markerIcon = await getBytesFromCanvas(
            asign.marcado!.toInt(), 100, 100, asign.marcado!.toInt());
        _markers.add(
          Marker(
            markerId: MarkerId(asign.marcado!.toString()),
            position: LatLng(lat, long),
            onTap: () {},
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      }
    }

    latcenter = (latmin + latmax) / 2;
    longcenter = (longmin + longmax) / 2;
    setState(() {});
  }

//--------------------------------------------------------
//--------------------- getBytesFromCanvas ---------------
//--------------------------------------------------------

  Future<Uint8List> getBytesFromCanvas(
      int customNum, int width, int height, int estado) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

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
//--------------------- isNullOrEmpty --------------------
//--------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);

//--------------------------------------------------------
//--------------------- _getAsigns -----------------------
//--------------------------------------------------------

  Future<void> _getAsigns(Asignacion2 asignacion) async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    bandera = false;

    Map<String, dynamic> request1 = {
      'reclamoTecnicoID': asignacion.reclamoTecnicoID,
      'userID': asignacion.userID,
      'cliente': asignacion.cliente,
      'domicilio': asignacion.domicilio,
    };

    Response response = Response(isSuccess: false);
    do {
      response = await ApiHelper.getAutonumericos(request1);
      if (response.isSuccess) {
        bandera = true;
        _asigns = response.result;
      }
    } while (bandera == false);

    setState(() {});

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _asigns = response.result;
    });

    for (Asign asign in _asigns) {
      asign.marcado = asignacion.marcado;
      _guardar(asign);
    }
  }

//--------------------------------------------------------
//--------------------- _guardar -------------------------
//--------------------------------------------------------
  void _guardar(Asign asign) async {
    Map<String, dynamic> request = {
      //----------------- Campos que mantienen el valor -----------------
      'IDREGISTRO': asign.idregistro,
      'Marcado': asign.marcado,
    };
    Response response = await ApiHelper.put(
        '/api/AsignacionesMarca/', asign.idregistro.toString(), request);
    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
  }

//--------------------------------------------------------
//--------------------- _borrar --------------------------
//--------------------------------------------------------
  void _borrar() async {
    for (Asignacion2 asignacion in widget.asignaciones2) {
      if (asignacion.marcado! > 0) {
        asignacion.marcado = 0;
        _getAsigns(asignacion);
      }
    }
    _valorMarcador = 0;
    _getMarkers();
  }

//--------------------------------------------------------
//--------------------- _renumerar -----------------------
//--------------------------------------------------------
  void _renumerar() async {
    int numero = 1;

    asignacionesTemporal = [];
    asignacionesTemporal = widget.asignaciones2;

    asignacionesTemporal.sort((a, b) {
      return a.marcado!.compareTo(b.marcado!);
    });

    for (Asignacion2 asignacion in asignacionesTemporal) {
      if (asignacion.marcado! > 0) {
        asignacion.marcado = numero;
        numero++;
        _getAsigns(asignacion);
      }
    }
    _valorMarcador = numero - 1;
    _getMarkers();
  }
}
