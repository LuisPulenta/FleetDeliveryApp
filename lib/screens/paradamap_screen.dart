import 'dart:async';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParadaMapScreen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;
  final ParadaEnvio paradaenvio;

  const ParadaMapScreen(
      {required this.user,
      required this.positionUser,
      required this.paradaenvio});

  @override
  _ParadaMapScreenState createState() => _ParadaMapScreenState();
}

class _ParadaMapScreenState extends State<ParadaMapScreen> {
  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  TextEditingController _direccionController = TextEditingController();
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

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialPosition = CameraPosition(
        target:
            LatLng(widget.positionUser.latitude, widget.positionUser.longitude),
        zoom: 16.0);
    ubicOk = true;
    _center =
        LatLng(widget.positionUser.latitude, widget.positionUser.longitude);
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
        title: Text(widget.paradaenvio.secuencia.toString()),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Container(
                  child: Stack(children: <Widget>[
                    GoogleMap(
                      myLocationEnabled: false,
                      initialCameraPosition: _initialPosition,
                      onCameraMove: _onCameraMove,
                      markers: _markers,
                      mapType: _defaultMapType,
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
                    Center(
                      child: Icon(
                        Icons.my_location,
                        color: Color(0xFFfc6c0c),
                        size: 50,
                      ),
                    ),
                  ]),
                )
              : Container(),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  void _marcar() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_center.latitude, _center.longitude);
    latitud = _center.latitude;
    longitud = _center.longitude;
    direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString();
    _direccionController.text = direccion;
    _markers.clear();
    _markers.add(Marker(
// This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_center.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: direccion,
        snippet: '',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    var a = placemarks[0];
    setState(() {});
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
