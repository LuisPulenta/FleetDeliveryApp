import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParadaMapScreen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;
  final ParadaEnvio paradaenvio;
  final Set<Marker> markers;
  final CustomInfoWindowController customInfoWindowController;

  const ParadaMapScreen(
      {Key? key,
      required this.user,
      required this.positionUser,
      required this.paradaenvio,
      required this.markers,
      required this.customInfoWindowController})
      : super(key: key);

  @override
  _ParadaMapScreenState createState() => _ParadaMapScreenState();
}

class _ParadaMapScreenState extends State<ParadaMapScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  bool ubicOk = false;
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
    _initialPosition = (widget.markers.length == 1)
        ? CameraPosition(
            target: LatLng(widget.paradaenvio.latitud!.toDouble(),
                widget.paradaenvio.longitud!.toDouble()),
            zoom: 16.0)
        : CameraPosition(
            target: LatLng(widget.paradaenvio.latitud!.toDouble(),
                widget.paradaenvio.longitud!.toDouble()),
            zoom: 12.0);
    ubicOk = true;
    _markers = widget.markers;
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
        title: (widget.markers.length == 1)
            ? Text(('Parada: ${widget.paradaenvio.secuencia.toString()}'))
            : Text(('Ruta: ${widget.paradaenvio.idRuta.toString()}')),
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
                          child: const Icon(Icons.layers),
                          elevation: 5,
                          backgroundColor: const Color(0xfff4ab04),
                          onPressed: () {
                            _changeMapType();
                          }),
                    ]),
                  ),
                  // Center(
                  //   child: Icon(
                  //     Icons.location_on,
                  //     color: Colors.red,
                  //     size: 50,
                  //   ),
                  // ),
                  CustomInfoWindow(
                    controller: widget.customInfoWindowController,
                    height: 140,
                    width: 300,
                    offset: 100,
                  ),
                ])
              : Container(),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
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
}
