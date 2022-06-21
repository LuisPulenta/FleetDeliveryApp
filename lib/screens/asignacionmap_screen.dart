import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AsignacionMapScreen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;
  final Asignacion2 asignacion;
  final Set<Marker> markers;
  final CustomInfoWindowController customInfoWindowController;

  const AsignacionMapScreen(
      {Key? key,
      required this.user,
      required this.positionUser,
      required this.asignacion,
      required this.markers,
      required this.customInfoWindowController})
      : super(key: key);

  @override
  _AsignacionMapScreenState createState() => _AsignacionMapScreenState();
}

class _AsignacionMapScreenState extends State<AsignacionMapScreen> {
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
  //static const LatLng _center = const LatLng(-31.4332373, -64.226344);

  @override
  void dispose() {
    widget.customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    double? grxx = double.tryParse(widget.asignacion.grxx!);
    double? gryy = double.tryParse(widget.asignacion.gryy!);

    _initialPosition =
        (widget.markers.length == 1 && grxx != null && gryy != null)
            ? CameraPosition(target: LatLng(grxx, gryy), zoom: 16.0)
            : (widget.markers.length > 1 && grxx != null && gryy != null)
                ? CameraPosition(target: LatLng(grxx, gryy), zoom: 12.0)
                : const CameraPosition(target: LatLng(0, 0), zoom: 12.0);
    ubicOk = true;

    _markers = widget.markers;
    // _markers.add(Marker(
    //   markerId: MarkerId(widget.paradaenvio.secuencia.toString()),
    //   position: _center,
    //   infoWindow: InfoWindow(
    //     title: widget.paradaenvio.titular.toString(),
    //     snippet: widget.paradaenvio.domicilio.toString(),
    //   ),
    //   icon: BitmapDescriptor.defaultMarker,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(('Mapa Asignaciones ${widget.asignacion.proyectomodulo}')),
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
                    myLocationEnabled: false,
                    initialCameraPosition: _initialPosition,
                    onCameraMove: _onCameraMove,
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

  void _onCameraMove(CameraPosition position) {}

  void _changeMapType() {
    _defaultMapType = _defaultMapType == MapType.normal
        ? MapType.satellite
        : _defaultMapType == MapType.satellite
            ? MapType.hybrid
            : MapType.normal;
    setState(() {});
  }
}
