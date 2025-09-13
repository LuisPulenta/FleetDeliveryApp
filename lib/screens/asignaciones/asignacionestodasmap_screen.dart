import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AsignacionesTodasMapScreen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;

  const AsignacionesTodasMapScreen({
    super.key,
    required this.user,
    required this.positionUser,
  });

  @override
  AsignacionesTodasMapScreenState createState() =>
      AsignacionesTodasMapScreenState();
}

class AsignacionesTodasMapScreenState
    extends State<AsignacionesTodasMapScreen> {
  //--------------------------------------------------------------
  //------------------------- Variables --------------------------
  //--------------------------------------------------------------

  List<Asignacion2> _asignaciones = [];
  List<Asignacion2> _asignaciones2 = [];
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  bool ubicOk = false;
  double latitud = 0;
  double longitud = 0;
  bool _showLoader = false;
  final Set<Marker> _markers = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  Position position = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(31, 64),
    zoom: 16.0,
  );

  //--------------------------------------------------------------
  //------------------------- initState --------------------------
  //--------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getObras();

    LatLng initPos = LatLng(
      widget.positionUser.latitude,
      widget.positionUser.longitude,
    );

    _initialPosition = CameraPosition(target: initPos, zoom: 13.0);

    ubicOk = true;
  }

  //--------------------------------------------------------------
  //------------------------- dispose ----------------------------
  //--------------------------------------------------------------
  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  //--------------------------------------------------------------
  //------------------------- Pantalla ---------------------------
  //--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(('Asignaciones radio 20 km')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Stack(
                  children: <Widget>[
                    GoogleMap(
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      myLocationEnabled: true,
                      initialCameraPosition: _initialPosition,
                      markers: _markers,
                      mapType: _defaultMapType,
                      onMapCreated: (GoogleMapController controller) async {
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80, right: 10),
                      alignment: Alignment.topRight,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton(
                            elevation: 5,
                            backgroundColor: const Color(0xfff4ab04),
                            onPressed: () {
                              _changeMapType();
                            },
                            child: const Icon(Icons.layers),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 140,
            width: 300,
            offset: 100,
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //------------------------- _changeMapType ---------------------
  //--------------------------------------------------------------

  void _changeMapType() {
    _defaultMapType = _defaultMapType == MapType.normal
        ? MapType.satellite
        : _defaultMapType == MapType.satellite
        ? MapType.hybrid
        : MapType.normal;
    setState(() {});
  }

  //--------------------------------------------------------------
  //------------------------- _getObras --------------------------
  //--------------------------------------------------------------

  Future<void> _getObras() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
        'Error',
        "Verifica que estés conectado a Internet",
        'Aceptar',
      );
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getAsignacionesTodas(widget.user.idUser);

    if (!response.isSuccess) {
      showMyDialog('Error', response.message, 'Aceptar');
      return;
    }

    _asignaciones = response.result;

    _asignaciones2 = _asignaciones;
    setState(() {
      _showLoader = false;
    });

    _showMap();
  }

  //--------------------------------------------------------------
  //------------------------- _showMap ---------------------------
  //--------------------------------------------------------------

  void _showMap() {
    if (_asignaciones2.isEmpty) {
      return;
    }

    _markers.clear();

    double latmin = 180.0;
    double latmax = -180.0;
    double longmin = 180.0;
    double longmax = -180.0;

    for (Asignacion2 asign in _asignaciones2) {
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

        double distancia = 0;
        double dist = 0;

        distancia = _distanciaMarker(asign, widget.positionUser);
        dist = (distancia * 100).floorToDouble() / 100;

        if (distancia <= 20) {
          _markers.add(
            Marker(
              markerId: MarkerId(asign.reclamoTecnicoID.toString()),
              position: LatLng(lat, long),
              onTap: () {
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
                        const Icon(Icons.info),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  asign.proyectomodulo.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${asign.cliente.toString()} - ${asign.nombre.toString()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  asign.domicilio.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Distancia: $dist km",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFb3b3b4,
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          30,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _navegar(asign),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.map,
                                            color: Color(0xff282886),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Navegar',
                                            style: TextStyle(
                                              color: Color(0xff282886),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFb3b3b4,
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          30,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _goInfoAsignacion(asign),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Abrir',
                                            style: TextStyle(
                                              color: Color(0xff282886),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xff282886),
                                          ),
                                        ],
                                      ),
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
                  LatLng(lat, long),
                );
              },
              //Coloresa de los pines según la empresa
              icon: (asign.proyectomodulo == 'Cable')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    )
                  : (asign.proyectomodulo == 'DTV')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue,
                    )
                  : (asign.proyectomodulo == 'Otro')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueCyan,
                    )
                  : (asign.proyectomodulo == 'Prisma')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet,
                    )
                  : (asign.proyectomodulo == 'Tasa')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta,
                    )
                  : (asign.proyectomodulo == 'Teco')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    )
                  : (asign.proyectomodulo == 'SuperC')
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    )
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRose,
                    ),
            ),
          );
        }
      }
    }
    // latcenter = (latmin + latmax) / 2;
    // longcenter = (longmin + longmax) / 2;
  }

  //-------------------------------------------------------------------
  //-------------------------- _navegar -------------------------------
  //-------------------------------------------------------------------

  Future<void> _navegar(e) async {
    if (e.grxx == "" ||
        e.gryy == "" ||
        isNullOrEmpty(e.grxx) ||
        isNullOrEmpty(e.gryy)) {
      showMyDialog(
        'Aviso',
        "Este cliente no tiene coordenadas cargadas.",
        'Aceptar',
      );
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      var latt = double.tryParse(e.grxx.toString());
      var long = double.tryParse(e.gryy.toString());
      var uri = Uri.parse("google.navigation:q=$latt,$long&mode=d");
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch ${uri.toString()}';
      }
    } else {
      showMyDialog(
        'Aviso',
        "Necesita estar conectado a Internet para acceder al mapa",
        'Aceptar',
      );
    }
  }

  //------------------------------------------------------------------
  //-------------------------- isNullOrEmpty -------------------------
  //------------------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);

  //---------------------------------------------------
  //----------------- _distanciaMarker ----------------
  //---------------------------------------------------

  double _distanciaMarker(Asignacion2 asign, Position positionUser) {
    double latitud1 = double.parse(asign.grxx!);
    double longitud1 = double.parse(asign.gryy!);
    double latitud2 = positionUser.latitude;
    double longitud2 = positionUser.longitude;

    double R = 6372.8; // In kilometers
    double dLat = _toRadians(latitud2 - latitud1);
    double dLon = _toRadians(longitud2 - longitud1);
    latitud1 = _toRadians(latitud1);
    latitud2 = _toRadians(latitud2);

    double a =
        pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(latitud1) * cos(latitud2);
    double c = 2 * asin(sqrt(a));

    return R * c;
  }

  //---------------------------------------------
  //----------------- _toRadians ----------------
  //---------------------------------------------

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  //---------------------------------------------
  //----------------- _goInfoAsignacion ----------------
  //---------------------------------------------

  void _goInfoAsignacion(Asignacion2 asignacion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsignacionesScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          opcion: 2,
          asignacion: asignacion,
        ),
      ),
    );
  }
}
