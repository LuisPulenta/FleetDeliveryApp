import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/asign.dart';
import 'package:fleetdeliveryapp/models/asignacion.dart';
import 'package:fleetdeliveryapp/models/asignacion2.dart';
import 'package:fleetdeliveryapp/models/codigocierre.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/take_picture_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AsignacionInfoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;
  final List<CodigoCierre> codigoscierre;
  final Position positionUser;

  AsignacionInfoScreen(
      {required this.user,
      required this.asignacion,
      required this.codigoscierre,
      required this.positionUser});

  @override
  _AsignacionInfoScreenState createState() => _AsignacionInfoScreenState();
}

class _AsignacionInfoScreenState extends State<AsignacionInfoScreen>
    with SingleTickerProviderStateMixin {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  int _codigocierre = -1;
  String _codigocierreError = '';
  bool _codigocierreShowError = false;
  TextEditingController _codigocierreController = TextEditingController();

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();

  List<CodigoCierre> __codigoscierre = [];
  bool _photoChanged = false;
  bool _signChanged = false;
  late XFile _image;

  List<Asign> _asigns = [];

  bool _showLoader = false;

  bool bandera = false;

  bool ubicOk = false;

  TabController? _tabController;

  MapType _defaultMapType = MapType.normal;

  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(31, 64), zoom: 16.0);

  final Set<Marker> _markers = {};

  Asignacion2 _asignacion = Asignacion2(
      recupidjobcard: '',
      cliente: '',
      nombre: '',
      domicilio: '',
      cp: '',
      entrecallE1: '',
      entrecallE2: '',
      localidad: '',
      telefono: '',
      grxx: '',
      gryy: '',
      estadogaos: '',
      proyectomodulo: '',
      userID: 0,
      causantec: '',
      subcon: '',
      fechaAsignada: '',
      codigoCierre: 0,
      descripcion: '',
      cierraenapp: 0,
      nomostrarapp: 0,
      novedades: '',
      provincia: '',
      reclamoTecnicoID: 0,
      fechaCita: '',
      medioCita: '',
      nroSeriesExtras: '',
      evento1: '',
      fechaEvento1: '',
      evento2: '',
      fechaEvento2: '',
      evento3: '',
      fechaEvento3: '',
      evento4: '',
      fechaEvento4: '',
      observacion: '',
      telefAlternativo1: '',
      telefAlternativo2: '',
      telefAlternativo3: '',
      telefAlternativo4: '',
      cantAsign: 0,
      codigoequivalencia: '',
      deco1descripcion: '');

  LatLng _center = LatLng(0, 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asignacion = widget.asignacion;
    __codigoscierre = widget.codigoscierre;
    _tabController = TabController(length: 3, vsync: this);
    _initialPosition = (_asignacion.grxx != "" && _asignacion.gryy != "")
        ? CameraPosition(
            target: LatLng(double.parse(_asignacion.grxx!),
                double.parse(_asignacion.gryy!)),
            zoom: 16.0)
        : CameraPosition(target: LatLng(0, 0), zoom: 16.0);

    ubicOk = true;
    _center = (_asignacion.grxx != "" && _asignacion.gryy != "")
        ? LatLng(
            double.parse(_asignacion.grxx!), double.parse(_asignacion.gryy!))
        : LatLng(0, 0);

    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(_asignacion.reclamoTecnicoID.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: _asignacion.nombre.toString(),
        snippet: _asignacion.domicilio.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    _getAsigns();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9dac2),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(
                    (0xffdadada),
                  ),
                  Color(
                    (0xffb3b3b4),
                  ),
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              physics: AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Column(
                  children: <Widget>[
                    AppBar(
                      title: (Text("Asignación")),
                      centerTitle: true,
                      backgroundColor: Color(0xff282886),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: _showAsignacion(),
                              flex: 2,
                            ),
                            Expanded(child: _showAutonumericos(), flex: 1),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Column(
                  children: [
                    AppBar(
                      title: (Text("Teléfonos")),
                      centerTitle: true,
                      backgroundColor: Color(0xff282886),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            _showTelefonos(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
//-------------------------------------------------------------------------
//-------------------------- 3° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Column(
                  children: [
                    AppBar(
                      title: (Text("Mapa")),
                      centerTitle: true,
                      backgroundColor: Color(0xff282886),
                    ),
                    Expanded(
                      child: Container(
                        child: (_asignacion.grxx != "" &&
                                _asignacion.gryy != "")
                            ? Stack(
                                children: [
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
                                ],
                              )
                            : Center(
                                child: Text(
                                    "Este Cliente no tiene coordenadas cargadas")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
            controller: _tabController,
            indicatorColor: Color(0xff282886),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            labelColor: Color(0xff282886),
            unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            tabs: <Widget>[
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.local_shipping),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Asignación",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Teléfonos",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(Icons.map),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Mapa",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

//*****************************************************************************
//************************** METODO SHOWASIGNACION ****************************
//*****************************************************************************

  Widget _showAsignacion() {
    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        //color: Color(0xFFC7C7C8),
        shadowColor: Colors.white,
        elevation: 10,
        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Cliente: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text(
                                      '${_asignacion.cliente.toString()} - ${_asignacion.nombre.toString()}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                Text("Rec.Téc.: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text(
                                      _asignacion.reclamoTecnicoID.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Dirección: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Expanded(
                                            child: Text(
                                                _asignacion.domicilio
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Row(
                                        children: [
                                          Text("Localidad: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(_asignacion.localidad.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Row(
                                        children: [
                                          Text("Provincia: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(_asignacion.provincia.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.map,
                                    color: Color(0xff282886),
                                    size: 34,
                                  ),
                                  onPressed: () => _navegar(_asignacion),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            _showButtonsDNIFirma(),
                            Divider(
                              color: Colors.black,
                            ),
                            _showButtonsEstados(),
                            Divider(
                              color: Colors.black,
                            ),
                            _showButtonsGuardarCancelar(),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
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
  }

  Widget _showButtonsDNIFirma() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(children: <Widget>[
                Container(
                  child: !_photoChanged
                      ? Image(
                          image: AssetImage('assets/dni.png'),
                          width: 80,
                          height: 60,
                          fit: BoxFit.contain)
                      : Image.file(
                          File(_image.path),
                          width: 80,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                ),
                Positioned(
                    bottom: 0,
                    left: 90,
                    child: InkWell(
                      onTap: () => _takePicture(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: Color(0xFF282886),
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.photo_camera,
                            size: 40,
                            color: Color(0xFFf6faf8),
                          ),
                        ),
                      ),
                    )),
              ]),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: InkWell(
              child: Stack(children: <Widget>[
                Container(
                  child: !_signChanged
                      ? Image(
                          image: AssetImage('assets/firma.png'),
                          width: 80,
                          height: 60,
                          fit: BoxFit.contain)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.file(
                            File(_image.path),
                            width: 80,
                            height: 60,
                            fit: BoxFit.contain,
                          )),
                ),
                Positioned(
                    bottom: 0,
                    left: 90,
                    child: InkWell(
                      onTap: () => _takePicture(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: Color(0xFF282886),
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.drive_file_rename_outline,
                            size: 40,
                            color: Color(0xFFf6faf8),
                          ),
                        ),
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showButtonsEstados() {
    return Column(
      children: [
        Row(
          children: [
            Text("Est. Gaos: ",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0e4888),
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: Text(
                _asignacion.estadogaos.toString(),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Text("Cód. Cierre: ",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0e4888),
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: Text(_asignacion.descripcion.toString(),
                  style: TextStyle(
                    fontSize: 12,
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Si a todo'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF282886),
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {}),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(
                      width: 2,
                    ),
                    Text('No a todo'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffdf281e),
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 5,
            ),
            _asignacion.cantAsign! > 1
                ? Expanded(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_half),
                          SizedBox(
                            width: 2,
                          ),
                          Text('Parcial'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFc41c9c),
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget _showButtonsGuardarCancelar() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: DropdownButtonFormField(
            value: _codigocierre,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Elija Código de Cierre',
              labelText: 'Código de Cierre',
              errorText: _codigocierreShowError ? _codigocierreError : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: _getComboCodigosCierre(),
            onChanged: (value) {
              _codigocierre = value as int;
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          style: TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
          controller: _observacionesController,
          decoration: InputDecoration(
              hintText: 'Ingresa observaciones...',
              labelText: 'Observaciones',
              errorText: _observacionesShowError ? _observacionesError : null,
              suffixIcon: Icon(Icons.notes),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          onChanged: (value) {
            _observaciones = value;
          },
        ),
        SizedBox(
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Guardar', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF282886),
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {}),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(
                      width: 2,
                    ),
                    Text('Cancelar', style: TextStyle(fontSize: 12)),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffdf281e),
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_half),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      'Otro recup.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFc41c9c),
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _showAutonumericos() {
    return ListView(
      children: _asigns.map((e) {
        return Card(
            color: Color(0xFFbfd4e7),
            shadowColor: Color(0xFF0000FF),
            elevation: 10,
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {}, //=> _goHistory(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text("Autonumérico: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.autonumerico.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Cód. Cierre: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.codigoCierre.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("Cód. Equiv.: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.decO1.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("Deco1: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.decO1.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("Estado3: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.estadO3.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("CModem1: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.cmodeM1.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("IDSuscripcion: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.idSuscripcion.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("MarcaModeloId: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.marcaModeloId.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("Observacion: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.observacion.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ));
      }).toList(),
    );
  }

  List<DropdownMenuItem<int>> _getComboCodigosCierre() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Elija Código de Cierre.'),
      value: -1,
    ));

    __codigoscierre.forEach((codigocierre) {
      list.add(DropdownMenuItem(
        child: Text(codigocierre.descripcion.toString()),
        value: codigocierre.codigoCierre,
      ));
    });

    return list;
  }

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'Trasera'),
          AlertDialogAction(key: 'yes', label: 'Delantera'),
          AlertDialogAction(key: 'cancel', label: 'Cancelar'),
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

  Future<void> _getAsigns() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    bandera = false;

    Map<String, dynamic> request1 = {
      'reclamoTecnicoID': _asignacion.reclamoTecnicoID,
      'userID': _asignacion.userID,
    };

    Response response = Response(isSuccess: false);
    do {
      response = await ApiHelper.GetAutonumericos(request1);
      if (response.isSuccess) {
        bandera = true;
        _asigns = response.result;
      }
    } while (bandera == false);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _asigns = response.result;
    });

    var a = 1;
  }

  Widget _showTelefonos() {
    return Card(
      color: Colors.white,
      //color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Cliente: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    '${_asignacion.cliente.toString()} - ${_asignacion.nombre.toString()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Dirección: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.domicilio.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Localidad: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.localidad.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Provincia: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.provincia.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Text("Teléfono: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.telefono.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.phone_forwarded,
                                  size: 34,
                                ),
                                color: Colors.green,
                                onPressed: () => launch(
                                    'tel://${_asignacion.telefono.toString()}'),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Text("Tel. Alt. 1: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo1.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.phone_forwarded,
                                  size: 34,
                                ),
                                color: Colors.green,
                                onPressed: () => launch(
                                    'tel://${_asignacion.telefAlternativo1.toString()}'),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Text("Tel. Alt. 2: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo2.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.phone_forwarded,
                                  size: 34,
                                ),
                                color: Colors.green,
                                onPressed: () => launch(
                                    'tel://${_asignacion.telefAlternativo2.toString()}'),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Text("Tel. Alt. 3: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo3.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.phone_forwarded,
                                  size: 34,
                                ),
                                color: Colors.green,
                                onPressed: () => launch(
                                    'tel://${_asignacion.telefAlternativo3.toString()}'),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              Text("Tel. Alt. 4: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo4.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.phone_forwarded,
                                  size: 34,
                                ),
                                color: Colors.green,
                                onPressed: () => launch(
                                    'tel://${_asignacion.telefAlternativo4.toString()}'),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
//-------------------------- METODO NAVEGAR -------------------------------
//-------------------------------------------------------------------------

  _navegar(Asignacion2 asignacion) async {
    if (asignacion.grxx == 0 ||
        asignacion.gryy == 0 ||
        isNullOrEmpty(asignacion.grxx) ||
        isNullOrEmpty(asignacion.gryy)) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "Esta asignación no tiene coordenadas cargadas.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _center =
        LatLng(double.parse(_asignacion.grxx!), double.parse(asignacion.gryy!));
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(asignacion.reclamoTecnicoID.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: asignacion.nombre.toString(),
        snippet: asignacion.domicilio.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      var uri = Uri.parse(
          "google.navigation:q=${double.parse(asignacion.grxx!)},${double.parse(asignacion.gryy!)}&mode=d");
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);

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
