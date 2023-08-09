import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  _AsignacionesMap2ScreenState createState() => _AsignacionesMap2ScreenState();
}

class _AsignacionesMap2ScreenState extends State<AsignacionesMap2Screen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool poderMarcar = false;
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
      speedAccuracy: 0);
  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(31, 64), zoom: 16.0);

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _getMarkers();
    _valorMarcador = widget.valorMarcador;

    _initialPosition = CameraPosition(target: widget.posicion, zoom: 3.0);

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
        actions: [
          Row(
            children: [
              const Text(
                "Marcar:",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Switch(
                  value: poderMarcar,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                  onChanged: (value) async {
                    poderMarcar = value;
                    var a = 1;
                    setState(() {});
                  }),
            ],
          ),
        ],
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
                          child: const Icon(Icons.layers),
                          elevation: 5,
                          backgroundColor: const Color(0xfff4ab04),
                          onPressed: () {
                            _changeMapType();
                          }),
                    ]),
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
                    BitmapDescriptor.hueGreen)));
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
}
