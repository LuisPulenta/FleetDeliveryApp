import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/models/asignacion.dart';
import 'package:fleetdeliveryapp/models/asignacion2.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AsignacionesMapScreen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;
  final Asignacion2 asignacion;
  final Set<Marker> markers;
  final CustomInfoWindowController customInfoWindowController;

  const AsignacionesMapScreen(
      {required this.user,
      required this.positionUser,
      required this.asignacion,
      required this.markers,
      required this.customInfoWindowController});

  @override
  _AsignacionesMapScreenState createState() => _AsignacionesMapScreenState();
}

class _AsignacionesMapScreenState extends State<AsignacionesMapScreen> {
  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  TextEditingController _direccionController = TextEditingController();
  bool ubicOk = false;
  double latitud = 0;
  double longitud = 0;
  bool _showLoader = false;
  Set<Marker> _markers = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  Position position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(31, 64), zoom: 16.0);
  //static const LatLng _center = const LatLng(-31.4332373, -64.226344);

  LatLng _center = LatLng(0, 0);

  @override
  void dispose() {
    widget.customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialPosition = (widget.markers.length == 1)
        ? CameraPosition(
            target: LatLng(double.parse(widget.asignacion.grxx!),
                double.parse(widget.asignacion.gryy!)),
            zoom: 16.0)
        : CameraPosition(
            target: LatLng(double.parse(widget.asignacion.grxx!),
                double.parse(widget.asignacion.gryy!)),
            zoom: 12.0);
    ubicOk = true;
    _center = LatLng(double.parse(widget.asignacion.grxx!),
        double.parse(widget.asignacion.gryy!));
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

  Future _getPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    latitud = position.latitude;
    longitud = position.longitude;
    direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString();
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
              ? Container(
                  child: Stack(children: <Widget>[
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
                      margin: EdgeInsets.only(top: 80, right: 10),
                      alignment: Alignment.topRight,
                      child: Column(children: <Widget>[
                        FloatingActionButton(
                            child: Icon(Icons.layers),
                            elevation: 5,
                            backgroundColor: Color(0xfff4ab04),
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
                  ]),
                )
              : Container(),
          _showLoader
              ? LoaderComponent(
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

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  void _changeMapType() {
    _defaultMapType = _defaultMapType == MapType.normal
        ? MapType.satellite
        : _defaultMapType == MapType.satellite
            ? MapType.hybrid
            : MapType.normal;
    setState(() {});
  }
}
