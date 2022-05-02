import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/asignacionmap_screen.dart';
import 'package:fleetdeliveryapp/screens/firma_screen.dart';
import 'package:fleetdeliveryapp/screens/take_picture_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AsignacionInfoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;
  final List<CodigoCierre> codigoscierre;
  final Position positionUser;
  final FuncionesApp funcionApp;
  final List<ControlesEquivalencia> controlesEquivalencia;

  AsignacionInfoScreen(
      {required this.user,
      required this.asignacion,
      required this.codigoscierre,
      required this.positionUser,
      required this.funcionApp,
      required this.controlesEquivalencia});

  @override
  _AsignacionInfoScreenState createState() => _AsignacionInfoScreenState();
}

class _AsignacionInfoScreenState extends State<AsignacionInfoScreen>
    with SingleTickerProviderStateMixin {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  int _codigocierre = -1;
  String _codigocierreError = '';
  bool _codigocierreShowError = false;
  TextEditingController _codigocierreController = TextEditingController();

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();

  String _macserie = '';
  String _macserieError = '';
  bool _macserieShowError = false;
  TextEditingController _macserieController = TextEditingController();

  List<CodigoCierre> __codigoscierre = [];
  bool _photoChanged = false;
  bool _signatureChanged = false;
  late XFile _image;
  late ByteData _signature;

  String _barCodeValue = '';

  String _equipo = 'Elija un Modelo...';
  String _equipoError = '';
  bool _equipoShowError = false;
  TextEditingController _equipoController = TextEditingController();

  List<Asign> _asigns = [];

  bool _showLoader = false;

  bool bandera = false;

  bool ubicOk = false;

  TabController? _tabController;

  MapType _defaultMapType = MapType.normal;

  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(31, 64), zoom: 16.0);

  final Set<Marker> _markers = {};

  String estadogaos = "";

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  Asignacion2 _asignacion = Asignacion2(
      cliente: '',
      nombre: '',
      domicilio: '',
      cp: '',
      entrecallE1: '',
      entrecallE2: '',
      partido: '',
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
      deco1descripcion: '',
      elegir: 0,
      observacionCaptura: '',
      zona: '');

  LatLng _center = LatLng(0, 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asignacion = widget.asignacion;
    estadogaos = _asignacion.estadogaos!;

    __codigoscierre = widget.codigoscierre;
    _tabController = TabController(length: 3, vsync: this);

    double? grxx = double.tryParse(_asignacion.grxx!);
    double? gryy = double.tryParse(_asignacion.gryy!);

    _initialPosition = (grxx != null && gryy != null)
        ? CameraPosition(target: LatLng(grxx, gryy), zoom: 16.0)
        : CameraPosition(target: LatLng(0, 0), zoom: 16.0);

    ubicOk = true;
    _center =
        (grxx != null && gryy != null) ? LatLng(grxx, gryy) : LatLng(0, 0);

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
      backgroundColor: Color.fromARGB(255, 206, 233, 194),
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
                Container(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      AppBar(
                        title: (Text(
                            'Asignación ${widget.asignacion.proyectomodulo}')),
                        centerTitle: true,
                        backgroundColor: Color(0xff282886),
                      ),
                      Expanded(
                        child: SingleChildScrollView(child: _showAsignacion()),
                        flex: 3,
                      ),
                      Expanded(child: _showAutonumericos(), flex: 2)
                    ],
                  ),
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
                      title: (Text("Observaciones")),
                      centerTitle: true,
                      backgroundColor: Color(0xff282886),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Center(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Text("Novedades: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.novedades}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("N° Series Extras: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.nroSeriesExtras}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("Obs. Inicial: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child:
                                      Text('${_asignacion.observacionCaptura}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("Obs. Cliente: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.observacion}',
                                      style: TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        )),
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
                    Icon(Icons.list),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Observ.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Tab(
              //   child: Row(
              //     children: [
              //       Icon(Icons.map),
              //       SizedBox(
              //         width: 2,
              //       ),
              //       Text(
              //         "Mapa",
              //         style: TextStyle(fontSize: 14),
              //       ),
              //     ],
              //   ),
              // ),
            ]),
      ),
    );
  }

//*****************************************************************************
//************************** METODO SHOWASIGNACION ****************************
//*****************************************************************************

  Widget _showAsignacion() {
    return Card(
      color: Colors.white,
      //color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: EdgeInsets.fromLTRB(8, 12, 8, 0),
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
                          // Row(
                          //   children: [
                          //     Text("Rec.Téc.: ",
                          //         style: TextStyle(
                          //           fontSize: 12,
                          //           color: Color(0xFF0e4888),
                          //           fontWeight: FontWeight.bold,
                          //         )),
                          //     Expanded(
                          //       child: Text(
                          //           _asignacion.reclamoTecnicoID.toString(),
                          //           style: TextStyle(
                          //             fontSize: 12,
                          //           )),
                          //     ),
                          //   ],
                          // ),
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
                                              _asignacion.domicilio.toString(),
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
                                        Text("Entre calles: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Expanded(
                                          child: (_asignacion.entrecallE1
                                                          .toString()
                                                          .length >
                                                      1 &&
                                                  _asignacion.entrecallE2
                                                          .toString()
                                                          .length >
                                                      1)
                                              ? Text(
                                                  '${_asignacion.entrecallE1.toString()} y ${_asignacion.entrecallE2.toString()}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ))
                                              : Text(""),
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
                                          child: Text(
                                              '${_asignacion.localidad.toString()}-${_asignacion.partido.toString()}',
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
                                        Text("Cód. Cierre: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Expanded(
                                          child: Text(
                                              _asignacion.descripcion
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text("Provincia: ",
                                    //         style: TextStyle(
                                    //           fontSize: 12,
                                    //           color: Color(0xFF0e4888),
                                    //           fontWeight: FontWeight.bold,
                                    //         )),
                                    //     Text(_asignacion.provincia.toString(),
                                    //         style: TextStyle(
                                    //           fontSize: 12,
                                    //         )),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.map,
                                  color: Color(0xff282886),
                                  size: 34,
                                ),
                                onPressed: () => _showMap(_asignacion),
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
    );
  }

  Widget _showButtonsDNIFirma() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.funcionApp.habilitaDNI == 1
              ? Expanded(
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
                )
              : Container(),
          SizedBox(
            width: 15,
          ),
          widget.funcionApp.habilitaFirma == 1
              ? Expanded(
                  child: InkWell(
                    child: Stack(children: <Widget>[
                      Container(
                        child: !_signatureChanged
                            ? Image(
                                image: AssetImage('assets/firma.png'),
                                width: 80,
                                height: 60,
                                fit: BoxFit.contain)
                            : Image.memory(
                                _signature.buffer.asUint8List(),
                                width: 80,
                                height: 60,
                              ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 90,
                          child: InkWell(
                            onTap: () => _takeSignature(),
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
                )
              : Container(),
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
                estadogaos.toString(),
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
              flex: 6,
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done),
                      SizedBox(
                        width: 3,
                      ),
                      Text('Realizado', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF282886),
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    _elegirtodos();
                  }),
            ),
            SizedBox(
              width: 3,
            ),
            Expanded(
              flex: 7,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(
                      width: 3,
                    ),
                    Text('No Realizado', style: TextStyle(fontSize: 12)),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffdf281e),
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  _deselegirtodos();
                },
              ),
            ),
            SizedBox(
              width: 3,
            ),
            _asignacion.cantAsign! > 1
                ? Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_half),
                          SizedBox(
                            width: 2,
                          ),
                          Text('Parcial', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFc41c9c),
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        _elegiralgunos();
                      },
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
            key: _key,
            isExpanded: true,
            value: _codigocierre,
            decoration: InputDecoration(
              fillColor: Colors.white,
              hintMaxLines: 2,
              filled: true,
              hintText: 'Elija Código de Cierre',
              labelText: 'Código de Cierre',
              errorText: _codigocierreShowError ? _codigocierreError : null,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: _getComboCodigosCierre(),
            onChanged: (estadogaos == 'INC' || estadogaos == 'PAR')
                ? (value) {
                    _codigocierre = value as int;
                  }
                : null,
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
                  onPressed: () {
                    _guardar();
                  }),
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
                onPressed: () {
                  Navigator.pop(context, "No");
                },
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
                            Text("Id Gaos: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.idregistro.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                            _asigns.length > 1
                                ? Checkbox(
                                    value: e.elegir == 1 ? true : false,
                                    onChanged: (value) {
                                      for (Asign asign in _asigns) {
                                        if (asign.autonumerico ==
                                            e.autonumerico) {
                                          asign.elegir = value == true ? 1 : 0;
                                        }
                                      }
                                      setState(() {});
                                    })
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            Text("Equipo: ",
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
                            SizedBox(
                              height: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Descripción: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: Text(e.codigoequivalencia.toString(),
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
                            Text("Modelo: ",
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
                            Text("Conf. Modelo:   ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              child: DropdownButtonFormField(
                                value: _equipo,
                                itemHeight: 50,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Elija un Modelo...',
                                  errorText:
                                      _equipoShowError ? _equipoError : null,
                                ),
                                items: _getComboEquipos(),
                                onChanged: (value) {
                                  _equipo = value.toString();
                                },
                              ),
                            ),
                            Text("                       ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Mac/Serie: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                )),
                            Expanded(
                              flex: 7,
                              child: Text(e.estadO3.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              child: Icon(Icons.qr_code_2),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF282886),
                                minimumSize: Size(50, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                String barcodeScanRes;

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      _macserieController.text = '';
                                      return Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AlertDialog(
                                              backgroundColor: Colors.grey[300],
                                              title: Text(
                                                  "Ingrese o escanee el código"),
                                              content: Column(
                                                children: [
                                                  TextField(
                                                    autofocus: true,
                                                    controller:
                                                        _macserieController,
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText: '',
                                                        labelText: '',
                                                        errorText:
                                                            _macserieShowError
                                                                ? _macserieError
                                                                : null,
                                                        prefixIcon:
                                                            Icon(Icons.tag),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                    onChanged: (value) {
                                                      _macserie = value;
                                                    },
                                                  ),
                                                  SizedBox(height: 10),
                                                  ElevatedButton(
                                                      child:
                                                          Icon(Icons.qr_code_2),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Color(0xFF282886),
                                                        minimumSize:
                                                            Size(50, 50),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        String barcodeScanRes;
                                                        try {
                                                          barcodeScanRes =
                                                              await FlutterBarcodeScanner
                                                                  .scanBarcode(
                                                                      '#3D8BEF',
                                                                      'Cancelar',
                                                                      false,
                                                                      ScanMode
                                                                          .DEFAULT);
                                                          //print(barcodeScanRes);
                                                        } on PlatformException {
                                                          barcodeScanRes =
                                                              'Error';
                                                        }
                                                        // if (!mounted) return;
                                                        if (barcodeScanRes ==
                                                            '-1') {
                                                          return;
                                                        }
                                                        _macserieController
                                                                .text =
                                                            barcodeScanRes;
                                                      }),
                                                ],
                                              ),
                                              actions: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Icon(Icons.cancel),
                                                            Text('Cancelar'),
                                                          ],
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Color(0xFFB4161B),
                                                          minimumSize: Size(
                                                              double.infinity,
                                                              50),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(Icons.save),
                                                              Text('Aceptar'),
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                0xFF120E43),
                                                            minimumSize: Size(
                                                                double.infinity,
                                                                50),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            for (Asign asign
                                                                in _asigns) {
                                                              if (asign
                                                                      .autonumerico ==
                                                                  e.autonumerico) {
                                                                asign.estadO3 =
                                                                    _macserieController
                                                                        .text;
                                                              }
                                                            }
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    barrierDismissible: false);
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                child: Icon(Icons.cancel),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xffdf281e),
                                  minimumSize: Size(50, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  for (Asign asign in _asigns) {
                                    if (asign.autonumerico == e.autonumerico) {
                                      asign.estadO3 = '';
                                    }
                                  }
                                  setState(() {});
                                }),
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

  void _takeSignature() async {
    Response? response = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FirmaScreen()));
    if (response != null) {
      setState(() {
        _signatureChanged = true;
        _signature = response.result;
      });
    }
  }
//*****************************************************************************
//************************** METODO GETASIGNS *********************************
//*****************************************************************************

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

    for (Asign asign in _asigns) {
      asign.elegir = null;
      for (ControlesEquivalencia control in widget.controlesEquivalencia) {
        if (control.decO1 == asign.decO1) {
          asign.codigoequivalencia = control.descripcion;
        }
      }
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
      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                                onPressed: () {
                                  if (_asignacion.telefAlternativo1
                                          .toString() !=
                                      "Sin Dato") {
                                    launch(
                                        'tel://${_asignacion.telefAlternativo1.toString()}');
                                  }
                                },
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
                                onPressed: () {
                                  if (_asignacion.telefAlternativo2
                                          .toString() !=
                                      "Sin Dato") {
                                    launch(
                                        'tel://${_asignacion.telefAlternativo2.toString()}');
                                  }
                                },
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
                                onPressed: () {
                                  if (_asignacion.telefAlternativo3
                                          .toString() !=
                                      "Sin Dato") {
                                    launch(
                                        'tel://${_asignacion.telefAlternativo3.toString()}');
                                  }
                                },
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
                                onPressed: () {
                                  if (_asignacion.telefAlternativo4
                                          .toString() !=
                                      "Sin Dato") {
                                    launch(
                                        'tel://${_asignacion.telefAlternativo4.toString()}');
                                  }
                                },
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
    if (asignacion.grxx == "0" ||
        asignacion.gryy == "0" ||
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

  void _elegirtodos() {
    estadogaos = "EJB";
    _codigocierre = -1;
    _key.currentState?.reset();

    for (Asign asign in _asigns) {
      asign.estadO2 = "SI";
      asign.elegir = 1;
      asign.activo = 1;
    }
    setState(() {});
  }

  void _deselegirtodos() {
    estadogaos = "INC";
    for (Asign asign in _asigns) {
      asign.estadO2 = "NO";
      asign.elegir = 0;
      asign.activo = 0;
    }
    setState(() {});
  }

  void _elegiralgunos() {
    estadogaos = "PAR";
    for (Asign asign in _asigns) {
      asign.estadO2 = "NO";
      asign.elegir = 0;
      asign.activo = 1;
    }
    setState(() {});
  }

  void _guardar() async {
    if (estadogaos == "PEN") {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'El Estado sigue "PEN". No tiene sentido guardar.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
    ;

    if (estadogaos == "INC" && _codigocierre == -1) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Si la Orden tiene un Estado "INC", hay que cargar el Código Cierre.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
    ;

    if (estadogaos == "PAR" && _codigocierre == -1) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Si la Orden tiene un Estado "PAR", hay que cargar el Código Cierre.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
    ;

    setState(() {});
  }

  void _showMap(Asignacion2 asignacion) async {
    _markers.clear();
    var lat = double.tryParse(asignacion.grxx.toString()) ?? 0;
    var long = double.tryParse(asignacion.gryy.toString()) ?? 0;

    if (lat == 0 || long == 0 || isNullOrEmpty(lat) || isNullOrEmpty(long)) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "Esta parada no tiene coordenadas cargadas.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    if (lat.toString().length > 1 && long.toString().length > 1) {
      _markers.add(
        Marker(
          markerId: MarkerId(asignacion.reclamoTecnicoID.toString()),
          position: LatLng(lat, long),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
                Container(
                  padding: EdgeInsets.all(5),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(Icons.info),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              '${asignacion.cliente.toString()} - ${asignacion.nombre.toString()}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                            Expanded(
                                child: Text(asignacion.domicilio.toString(),
                                    style: TextStyle(fontSize: 12))),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
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
                                      primary: Color(0xFFb3b3b4),
                                      minimumSize: Size(double.infinity, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () => _navegar(asignacion),
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
                LatLng(lat, long));
          },
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsignacionMapScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          asignacion: _asignacion,
          markers: _markers,
          customInfoWindowController: _customInfoWindowController,
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getComboEquipos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Elija un Modelo...'),
      value: 'Elija un Modelo...',
    ));

    widget.controlesEquivalencia.forEach((control) {
      list.add(DropdownMenuItem(
        child: Text(control.descripcion.toString()),
        value: control.decO1.toString(),
      ));
    });

    return list;
  }
}
