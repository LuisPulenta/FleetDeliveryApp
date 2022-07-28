import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AsignacionInfoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;
  final List<CodigoCierre> codigoscierre;
  final List<CodigoCierre> codigoscierreAux;
  final Position positionUser;
  final FuncionesApp funcionApp;
  final List<ControlesEquivalencia> controlesEquivalencia;

  const AsignacionInfoScreen(
      {Key? key,
      required this.user,
      required this.asignacion,
      required this.codigoscierre,
      required this.codigoscierreAux,
      required this.positionUser,
      required this.funcionApp,
      required this.controlesEquivalencia})
      : super(key: key);

  @override
  _AsignacionInfoScreenState createState() => _AsignacionInfoScreenState();
}

class _AsignacionInfoScreenState extends State<AsignacionInfoScreen>
    with SingleTickerProviderStateMixin {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  String codCierre = '';
  String codCierreGenerico = '';

  String descCodCierreEJB = '';
  String descCodCierreINC = '';

  int _codigocierre = -1;
  final String _codigocierreError = '';
  final bool _codigocierreShowError = false;

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  final String _macserieError = '';
  final bool _macserieShowError = false;
  final TextEditingController _macserieController = TextEditingController();

  List<CodigoCierre> __codigoscierre = [];
  bool _photoChangedDNI = false;
  bool _signatureChanged = false;
  late XFile _image;
  late ByteData? _signature;

  String _equipo = 'Elija un Modelo...';
  final String _equipoError = '';
  final bool _equipoShowError = false;

  List<Asign> _asigns = [];

  bool bandera = false;

  bool ubicOk = false;

  TabController? _tabController;

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
      motivos: '',
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

  LatLng _center = const LatLng(0, 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    super.initState();
    _asignacion = widget.asignacion;
    estadogaos = _asignacion.estadogaos!;

    __codigoscierre = widget.codigoscierre;
    _tabController = TabController(length: 3, vsync: this);

    double? grxx = double.tryParse(_asignacion.grxx!);
    double? gryy = double.tryParse(_asignacion.gryy!);

    ubicOk = true;
    _center = (grxx != null && gryy != null)
        ? LatLng(grxx, gryy)
        : const LatLng(0, 0);

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

    for (var control in widget.controlesEquivalencia) {
      if (control.codigoequivalencia == "Genérico") {
        codCierreGenerico = control.decO1;
      }
    }

    _getAsigns();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
              physics: const AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Container(
                  margin: const EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      AppBar(
                        title: (Text(
                            'Asignación ${widget.asignacion.proyectomodulo}')),
                        centerTitle: true,
                        backgroundColor: const Color(0xff282886),
                      ),
                      Expanded(
                          flex: widget.funcionApp.habilitaDNI == 1 ? 15 : 7,
                          child:
                              SingleChildScrollView(child: _showAsignacion())),
                      Expanded(
                        child: _showAutonumericos(),
                        flex: widget.funcionApp.habilitaDNI == 1 ? 7 : 6,
                      ),
                      _showButtonsGuardarCancelar(),
                    ],
                  ),
                ),
//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------
                Column(
                  children: [
                    AppBar(
                      title: (const Text("Teléfonos")),
                      centerTitle: true,
                      backgroundColor: const Color(0xff282886),
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
                      title: (const Text("Observaciones")),
                      centerTitle: true,
                      backgroundColor: const Color(0xff282886),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Center(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Novedades: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.novedades}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text("N° Series Extras: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.nroSeriesExtras}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text("Obs. Cliente: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.observacion}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text("Cartera: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                                Expanded(
                                  child: Text('${_asignacion.motivos}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
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
            indicatorColor: const Color(0xff282886),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            labelColor: const Color(0xff282886),
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            tabs: <Widget>[
              Tab(
                child: Row(
                  children: const [
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
                  children: const [
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
                  children: const [
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
      margin: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text("Cliente: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    '${_asignacion.cliente.toString()} - ${_asignacion.nombre.toString()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
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
                                        const SizedBox(
                                          width: 80,
                                          child: Text("Dirección: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Expanded(
                                          child: Text(
                                              _asignacion.domicilio.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 80,
                                          child: Text("Entre calles: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
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
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ))
                                              : const Text(""),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 80,
                                          child: Text("Localidad: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Expanded(
                                          child: Text(
                                              '${_asignacion.localidad.toString()}-${_asignacion.partido.toString()}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 80,
                                          child: Text("Cód. Cierre: ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Expanded(
                                          child: Text(
                                              _asignacion.descripcion
                                                  .toString(),
                                              style: const TextStyle(
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
                                icon: const Icon(
                                  Icons.map,
                                  color: Color(0xff282886),
                                  size: 34,
                                ),
                                onPressed: () => _showMap(_asignacion),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          _showButtonsDNIFirma(),
                          const Divider(
                            color: Colors.black,
                          ),
                          _showButtonsEstados(),
                          const Divider(
                            color: Colors.black,
                          ),
                          //_showButtonsGuardarCancelar(),
                          _showCodCierreObservaciones(),

                          const Divider(
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

//*****************************************************************************
//************************** SHOWBUTTONDNIFIRMA *******************************
//*****************************************************************************

  Widget _showButtonsDNIFirma() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.funcionApp.habilitaDNI == 1
              ? Expanded(
                  child: InkWell(
                    child: Stack(children: <Widget>[
                      Container(
                        child: !_photoChangedDNI
                            ? const Center(
                                child: Image(
                                    image: AssetImage('assets/dni.png'),
                                    width: 80,
                                    height: 60,
                                    fit: BoxFit.contain),
                              )
                            : Center(
                                child: Image.file(
                                  File(_image.path),
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 125,
                          child: InkWell(
                            onTap: () => _takePicture(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                color: const Color(0xFF282886),
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.photo_camera,
                                  size: 30,
                                  color: Color(0xFFf6faf8),
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: InkWell(
                            onTap: () => _selectPicture(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                color: const Color(0xFF282886),
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Color(0xFFf6faf8),
                                ),
                              ),
                            ),
                          )),
                    ]),
                  ),
                )
              : Container(),
          const SizedBox(
            width: 15,
          ),
          widget.funcionApp.habilitaFirma == 1
              ? Expanded(
                  child: InkWell(
                    child: Stack(children: <Widget>[
                      Container(
                        child: !_signatureChanged
                            ? const Image(
                                image: AssetImage('assets/firma.png'),
                                width: 80,
                                height: 60,
                                fit: BoxFit.contain)
                            : Image.memory(
                                _signature!.buffer.asUint8List(),
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
                                color: const Color(0xFF282886),
                                width: 50,
                                height: 50,
                                child: const Icon(
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

//*****************************************************************************
//************************** SHOWBUTTONSESTADOS *******************************
//*****************************************************************************

  Widget _showButtonsEstados() {
    return Column(
      children: [
        Row(
          children: [
            const Text("Est. Gaos: ",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0e4888),
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: Text(
                estadogaos.toString(),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const Text("Cód. Cierre: ",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0e4888),
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: Text(_asignacion.descripcion.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            ),
          ],
        ),
        const SizedBox(
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
                    children: const [
                      Icon(Icons.done),
                      SizedBox(
                        width: 3,
                      ),
                      Text('Realizado', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF282886),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    _elegirtodos();
                  }),
            ),
            const SizedBox(
              width: 3,
            ),
            Expanded(
              flex: 7,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cancel),
                    SizedBox(
                      width: 3,
                    ),
                    Text('No Realizado', style: TextStyle(fontSize: 12)),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffdf281e),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  _deselegirtodos();
                },
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            _asignacion.cantAsign! > 1
                ? Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star_half),
                          SizedBox(
                            width: 2,
                          ),
                          Text('Parcial', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 52, 52, 52),
                        minimumSize: const Size(double.infinity, 40),
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

//*****************************************************************************
//************************** SHOWCODCIERREOBSERVACIONES ***********************
//*****************************************************************************

  Widget _showCodCierreObservaciones() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(0),
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
        const SizedBox(
          height: 5,
        ),
        TextField(
          style:
              const TextStyle(fontSize: 14.0, height: 1.0, color: Colors.black),
          controller: _observacionesController,
          decoration: InputDecoration(
              hintText: 'Ingresa observaciones...',
              labelText: 'Observaciones',
              errorText: _observacionesShowError ? _observacionesError : null,
              suffixIcon: const Icon(Icons.notes),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          onChanged: (value) {
            _observaciones = value;
          },
        ),
      ],
    );
  }

//*****************************************************************************
//************************** SHOWBUTTONSGUARDARCANCELAR ***********************
//*****************************************************************************

  Widget _showButtonsGuardarCancelar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.save),
                        SizedBox(
                          width: 2,
                        ),
                        Text('Guardar', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF282886),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      _guardar();
                    }),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cancel),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Cancelar', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffdf281e),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "No");
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              widget.funcionApp.habilitaOtroRecupero == 1
                  ? Expanded(
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                          primary: const Color.fromARGB(255, 52, 52, 52),
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtroRecuperoScreen(
                                  user: widget.user,
                                  asignacion: widget.asignacion,
                                  idgaos: _asigns[0].idregistro,
                                  controlesEquivalencia:
                                      widget.controlesEquivalencia),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** SHOWAUTONUMERICOS ********************************
//*****************************************************************************

  Widget _showAutonumericos() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      physics: const BouncingScrollPhysics(),
      children: _asigns.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
              color: const Color(0xFFbfd4e7),
              shadowColor: const Color(0xFF0000FF),
              elevation: 10,
              margin:
                  const EdgeInsets.only(left: 5, bottom: 5, right: 5, top: 0),
              child: InkWell(
                onTap: () {}, //=> _goHistory(e),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: Text("Id Gaos: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(e.idregistro.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              _asigns.length > 1 && estadogaos == 'PAR'
                                  ? Checkbox(
                                      value: e.elegir == 1 ? true : false,
                                      onChanged: (value) {
                                        for (Asign asign in _asigns) {
                                          if (asign.autonumerico ==
                                              e.autonumerico) {
                                            asign.elegir =
                                                value == true ? 1 : 0;
                                          }
                                        }
                                        setState(() {});
                                      })
                                  : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: Text("Equipo: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(e.decO1.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                            ],
                          ),
                          e.smartcard.toString().length > 0
                              ? Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: Text("Smartcard: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(e.smartcard.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 70,
                                      child: Text("      Dev. : SI",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Checkbox(
                                        value: e.elegirSI == 1 ? true : false,
                                        onChanged: (value) {
                                          for (Asign asign in _asigns) {
                                            if (asign.autonumerico ==
                                                e.autonumerico) {
                                              asign.elegirSI =
                                                  value == true ? 1 : 0;
                                              asign.elegirNO =
                                                  asign.elegirSI == 1 ? 0 : 1;
                                            }
                                          }
                                          setState(() {});
                                        }),
                                    const SizedBox(
                                      width: 25,
                                      child: Text("NO",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Checkbox(
                                        value: e.elegirNO == 1 ? true : false,
                                        onChanged: (value) {
                                          for (Asign asign in _asigns) {
                                            if (asign.autonumerico ==
                                                e.autonumerico) {
                                              asign.elegirNO =
                                                  value == true ? 1 : 0;
                                              asign.elegirSI =
                                                  asign.elegirNO == 1 ? 0 : 1;
                                            }
                                          }
                                          setState(() {});
                                        }),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              const SizedBox(
                                width: 90,
                                child: Text("Descripción: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: e.codigoequivalencia != null
                                    ? Text(e.codigoequivalencia.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ))
                                    : Text(""),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          // Row(
                          //   children: [
                          //     Text("Modelo: ",
                          //         style: TextStyle(
                          //           fontSize: 12,
                          //           color: Color(0xFF0e4888),
                          //           fontWeight: FontWeight.bold,
                          //         )),
                          //     Expanded(
                          //       child: Text(e.marcaModeloId.toString(),
                          //           style: TextStyle(
                          //             fontSize: 12,
                          //           )),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 1,
                          // ),
                          widget.funcionApp.habilitaCambioModelo == 1
                              ? Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: Text("Conf. Modelo:   ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: DropdownButtonFormField(
                                          value: e.marcaModeloId, //_equipo,
                                          isExpanded: true,
                                          isDense: true,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'Elija un Modelo...',
                                            errorText: _equipoShowError
                                                ? _equipoError
                                                : null,
                                          ),
                                          items: _getComboEquipos(),
                                          onChanged: (value) {
                                            _equipo = value.toString();

                                            for (Asign asign in _asigns) {
                                              if (asign.autonumerico ==
                                                  e.autonumerico) {
                                                asign.marcaModeloId = _equipo;
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const Text("        ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.funcionApp.serieObligatoria == 1 ||
                                  (e.proyectomodulo == 'Cable' &&
                                      e.motivos.toString().contains("VDSL"))
                              ? Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: Text("Mac/Serie: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(e.estadO3.toString(),
                                          style: const TextStyle(fontSize: 12)),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      child: const Icon(Icons.qr_code_2),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFF282886),
                                        minimumSize: const Size(50, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              _macserieController.text = '';
                                              return Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    AlertDialog(
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      title: const Text(
                                                          "Ingrese o escanee el código"),
                                                      content: Column(
                                                        children: [
                                                          TextField(
                                                            autofocus: true,
                                                            controller:
                                                                _macserieController,
                                                            decoration: InputDecoration(
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                filled: true,
                                                                hintText: '',
                                                                labelText: '',
                                                                errorText:
                                                                    _macserieShowError
                                                                        ? _macserieError
                                                                        : null,
                                                                prefixIcon:
                                                                    const Icon(
                                                                        Icons
                                                                            .tag),
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10))),
                                                            onChanged:
                                                                (value) {},
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          ElevatedButton(
                                                              child: const Icon(
                                                                  Icons
                                                                      .qr_code_2),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    const Color(
                                                                        0xFF282886),
                                                                minimumSize:
                                                                    const Size(
                                                                        50, 50),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                String
                                                                    barcodeScanRes;
                                                                try {
                                                                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
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
                                                              child:
                                                                  ElevatedButton(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: const [
                                                                          Icon(Icons
                                                                              .save),
                                                                          Text(
                                                                              'Aceptar'),
                                                                        ],
                                                                      ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            const Color(0xFF120E43),
                                                                        minimumSize: const Size(
                                                                            double.infinity,
                                                                            50),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        if (_macserieController.text.length <
                                                                            6) {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return AlertDialog(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  title: const Text('Aviso'),
                                                                                  content: Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
                                                                                    Text('El código debe tener al menos 6 caracteres.'),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                  ]),
                                                                                  actions: <Widget>[
                                                                                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok')),
                                                                                  ],
                                                                                );
                                                                              });

                                                                          return;
                                                                        }

                                                                        for (Asign asign
                                                                            in _asigns) {
                                                                          if (asign.autonumerico ==
                                                                              e.autonumerico) {
                                                                            asign.estadO3 =
                                                                                _macserieController.text.toUpperCase();
                                                                            asign.elegir =
                                                                                1;
                                                                          }
                                                                        }
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(
                                                                            () {});
                                                                      }),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: const [
                                                                    Icon(Icons
                                                                        .cancel),
                                                                    Text(
                                                                        'Cancelar'),
                                                                  ],
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary:
                                                                      const Color(
                                                                          0xFFB4161B),
                                                                  minimumSize:
                                                                      const Size(
                                                                          double
                                                                              .infinity,
                                                                          50),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
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
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                        child: const Icon(Icons.cancel),
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(0xffdf281e),
                                          minimumSize: const Size(50, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          for (Asign asign in _asigns) {
                                            if (asign.autonumerico ==
                                                e.autonumerico) {
                                              asign.estadO3 = '';
                                            }
                                          }
                                          setState(() {});
                                        }),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 1,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              )),
        );
      }).toList(),
    );
  }

//*****************************************************************************
//************************** GETCOMBOCODIGOSCIERRE ****************************
//*****************************************************************************

  List<DropdownMenuItem<int>> _getComboCodigosCierre() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija Código de Cierre.'),
      value: -1,
    ));

    for (var codigocierre in __codigoscierre) {
      list.add(DropdownMenuItem(
        child: Text(codigocierre.descripcion.toString()),
        value: codigocierre.codigoCierre,
      ));
    }

    return list;
  }

//*****************************************************************************
//************************** TAKEPICTURE **************************************
//*****************************************************************************

  void _takePicture() async {
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
          _photoChangedDNI = true;
          _image = response.result;
        });
      }
    }
  }

//*****************************************************************************
//************************** TAKESIGNATURE ************************************
//*****************************************************************************

  void _takeSignature() async {
    Response? response = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FirmaScreen()));
    if (response != null) {
      setState(() {
        _signatureChanged = true;
        _signature = response.result;
      });

      //_signature2 = await _signature.toByteData(format: ui.ImageByteFormat.png);
    }
  }
//*****************************************************************************
//************************** METODO GETASIGNS *********************************
//*****************************************************************************

  Future<void> _getAsigns() async {
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
      'reclamoTecnicoID': _asignacion.reclamoTecnicoID,
      'userID': _asignacion.userID,
      'cliente': _asignacion.cliente
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

    for (var asign in _asigns) {
      asign.marcaModeloId ??= codCierreGenerico;

      if (asign.marcaModeloId == "") {
        asign.marcaModeloId = codCierreGenerico;
      }

      bool bandera = true;

      for (var control in widget.controlesEquivalencia) {
        if (control.decO1 == asign.marcaModeloId) {
          bandera = false;
        }
      }

      if (bandera) {
        asign.marcaModeloId = codCierreGenerico;
      }
    }
  }

//*****************************************************************************
//************************** SHOWTELEFONOS ************************************
//*****************************************************************************

  Widget _showTelefonos() {
    return Card(
      color: Colors.white,
      //color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text("Cliente: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    '${_asignacion.cliente.toString()} - ${_asignacion.nombre.toString()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Dirección: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.domicilio.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Localidad: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.localidad.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Provincia: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.provincia.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              const Text("Teléfono: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(_asignacion.telefono.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.phone_forwarded,
                                  size: 34,
                                ),
                                color: Colors.green,
                                onPressed: () => launch(
                                    'tel://${_asignacion.telefono.toString()}'),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              const Text("Tel. Alt. 1: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo1.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: const Icon(
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
                          const Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              const Text("Tel. Alt. 2: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo2.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: const Icon(
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
                          const Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              const Text("Tel. Alt. 3: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo3.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: const Icon(
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
                          const Divider(
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              const Text("Tel. Alt. 4: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    _asignacion.telefAlternativo4.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              IconButton(
                                icon: const Icon(
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
                          const Divider(
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);

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

//*****************************************************************************
//************************** METODO GUARDAR ***********************************
//*****************************************************************************

//-------------------------- Verifica que no sea PEN --------------------------
  void _guardar() async {
    if (estadogaos == "PEN") {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'El Estado sigue "PEN". No tiene sentido guardar.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

//---------------- Verifica que si es INC tenga Código de Cierre --------------

    if (estadogaos == "INC" && _codigocierre == -1) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Si la Orden tiene un Estado "INC", hay que cargar el Código Cierre.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

//---------------- Verifica que si es PAR tenga Código de Cierre --------------

    if (estadogaos == "PAR" && _codigocierre == -1) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Si la Orden tiene un Estado "PAR", hay que cargar el Código Cierre.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

//---------------- Verifica que si es PAR haya elegidos y no elegidos -------

    if (estadogaos == "PAR") {
      int elegidos = 0;
      int noelegidos = 0;
      for (Asign asign in _asigns) {
        if (asign.elegir == 1) {
          elegidos = elegidos + 1;
        } else {
          noelegidos = noelegidos + 1;
        }
      }

      if (elegidos == 0) {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message:
                'La Orden tiene un Estado "PAR" pero NO HA ELEGIDO ninguna asignación, ',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      }

      if (noelegidos == 0) {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message:
                'La Orden tiene un Estado "PAR" pero HA ELEGIDO TODAS las asignaciones, ',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      }
    }

//---------------- Verifica que haya Foto del DNI --------------

    if (widget.funcionApp.habilitaDNI == 1 &&
        _photoChangedDNI == false &&
        estadogaos == 'EJB') {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Debe cargar la Foto del DNI.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

//---------------- Verifica que haya Firma --------------

    if (widget.funcionApp.habilitaFirma == 1 &&
        _signatureChanged == false &&
        estadogaos == 'EJB') {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Debe cargar la Firma.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

//---------------- Verifica que estén cargados los Mac/Serie ------------------

    if (widget.funcionApp.serieObligatoria == 1 ||
        (widget.asignacion.proyectomodulo == 'Cable' &&
            widget.asignacion.motivos.toString().contains("VDSL"))) {
      for (Asign asign in _asigns) {
        bool band = false;

        if ((estadogaos == 'EJB' && asign.estadO3!.length < 6) ||
            ((estadogaos == 'PAR' &&
                asign.estadO3!.length < 6 &&
                asign.elegir == 1))) {
          band = true;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text('Aviso'),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text('Mac/Serie debe tener al menos 6 caracteres.'),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok')),
                  ],
                );
              });
        }
        setState(() {});
        if (band) {
          return;
        }
      }
    }

//-------- Verifica para DTV que se haya elegido SI o NO para la Smartcard ----

    if (widget.asignacion.proyectomodulo == 'DTV') {
      for (Asign asign in _asigns) {
        bool band = false;

        if ((estadogaos == 'EJB' &&
                (asign.elegirSI == null && asign.elegirNO == null)) ||
            (estadogaos == 'PAR' && asign.elegir == 1) &&
                (asign.elegirSI == null && asign.elegirNO == null)) {
          band = true;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text('Aviso'),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text(
                            'Debe seleccionar si se devuelve o no la Smartcard.'),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok')),
                  ],
                );
              });
        }
        setState(() {});
        if (band) {
          return;
        }
      }
    }

//---------------- Establece valores para grabar -----------------------------

//----- Fecha -----
    DateTime fechaYa = DateTime.now();

//----- Código de Cierre y Descripción elegido y final-----

    for (CodigoCierre cod in widget.codigoscierreAux) {
      if (cod.codigoCierre.toString() == _codigocierre.toString()) {
        descCodCierreINC = cod.descripcion!;
      }
      if (cod.codigoCierre == widget.funcionApp.codigoFinal) {
        descCodCierreEJB = cod.descripcion!;
      }
    }

//----- EstadoGaos y Código de Cierre -----

    String evento1 = '';
    for (Asign asign in _asigns) {
      if (estadogaos == 'EJB') {
        asign.codigoCierre = widget.funcionApp.codigoFinal;
        asign.estadogaos = 'EJB';
        evento1 = descCodCierreEJB;
      } else if (estadogaos == 'INC') {
        asign.codigoCierre = _codigocierre;
        asign.estadogaos = 'INC';
        evento1 = descCodCierreINC;
      } else if (estadogaos == 'PAR') {
        if (asign.elegir == 1) {
          asign.codigoCierre = widget.funcionApp.codigoFinal;
          asign.estadogaos = 'EJB';
          evento1 = descCodCierreEJB;
        } else {
          asign.codigoCierre = _codigocierre;
          asign.estadogaos = 'INC';
          evento1 = descCodCierreINC;
        }
      }

      String base64imageDNI = '';
      if (_photoChangedDNI) {
        List<int> imageBytesDNI = await _image.readAsBytes();
        base64imageDNI = base64Encode(imageBytesDNI);
      }

      String base64imageFirma = '';
      if (_signatureChanged) {
        List<int> imageBytesFirma = _signature!.buffer.asUint8List();
        base64imageFirma = base64Encode(imageBytesFirma);
      }

      Map<String, dynamic> request = {
        //----------------- Campos que mantienen el valor -----------------
        'idregistro': asign.idregistro,
        'subagentemercado': asign.subagentemercado,
        'recupidjobcard': asign.recupidjobcard,
        'cliente': asign.cliente,
        'nombre': asign.nombre,
        'domicilio': asign.domicilio,
        'entrecallE1': asign.entrecallE1,
        'entrecallE2': asign.entrecallE2,
        'cp': asign.cp,
        'ztecnico': asign.ztecnico,
        'provincia': asign.provincia,
        'localidad': asign.localidad,
        'telefono': asign.telefono,
        'grxx': asign.grxx,
        'gryy': asign.gryy,
        'decO1': asign.decO1,
        'cmodeM1': asign.cmodeM1,
        'estado': asign.estado,
        'zona': asign.zona,
        'idr': asign.idr,
        'modelo': asign.modelo,
        'smartcard': asign.smartcard,
        'ruta': asign.ruta,
        'tarifa': asign.tarifa,
        'proyectomodulo': asign.proyectomodulo,
        'bajasistema': asign.bajasistema,
        'idcabeceracertif': asign.idcabeceracertif,
        'subcon': asign.subcon,
        'causantec': asign.causantec,
        'pasaDefinitiva': asign.pasaDefinitiva,
        'fechaAsignada': asign.fechaAsignada,
        'hsCaptura': asign.hsCaptura,
        'hsAsignada': asign.hsAsignada,
        'userID': asign.userID,
        'terminalAsigna': asign.terminalAsigna,
        'esCR': asign.esCR,
        'autonumerico': asign.autonumerico,
        'reclamoTecnicoID': asign.reclamoTecnicoID,
        'clienteTipoId': asign.clienteTipoId,
        'documento': asign.documento,
        'partido': asign.partido,
        'emailCliente': asign.emailCliente,
        'observacionCaptura': asign.observacionCaptura,
        'fechaInicio': asign.fechaInicio,
        'fechaEnvio': asign.fechaEnvio,
        'enviado': asign.enviado,
        'cancelado': asign.cancelado,
        'recupero': asign.recupero,
        'visitaTecnica': asign.visitaTecnica,
        'novedades': asign.novedades,
        'pdfGenerado': asign.pdfGenerado,
        'fechaCumplidaTecnico': asign.fechaCumplidaTecnico,
        'archivoOutGenerado': asign.archivoOutGenerado,
        'idSuscripcion': asign.idSuscripcion,
        'itemsID': asign.itemsID,
        'sectorOperativo': asign.sectorOperativo,
        'idTipoTrabajoRel': asign.idTipoTrabajoRel,
        'motivos': asign.motivos,
        'fc_inicio_base': asign.fc_inicio_base,
        'vc_fin_base': asign.vc_fin_base,
        'fechaCita': asign.fechaCita,
        'medioCita': asign.medioCita,
        'nroSeriesExtras': asign.nroSeriesExtras,
        'escames': asign.escames,
        'escaanio': asign.escaanio,
        'estado4': asign.estado4,
        'loteNro': asign.loteNro,
        'fechabaja': asign.fechabaja,
        'tipocliente': asign.tipocliente,
        'incentivo': asign.incentivo,
        'desconexion': asign.desconexion,
        'quincena': asign.quincena,
        'impreso': asign.impreso,
        'idusercambio': asign.idusercambio,
        'franjaentrega': asign.franjaentrega,
        'telefAlternativo1': asign.telefAlternativo1,
        'telefAlternativo2': asign.telefAlternativo2,
        'telefAlternativo3': asign.telefAlternativo3,
        'telefAlternativo4': asign.telefAlternativo4,
        'tag1': asign.tag1,
        'tipotel1': asign.tipotel1,
        'tipotel2': asign.tipotel2,
        'tipotel3': asign.tipotel3,
        'tipotel4': asign.tipotel4,
        'valorunico': asign.valorunico,
        'clienteCompleto': asign.clienteCompleto,
        'entreCalles': asign.entreCalles,
        'descripcion': asign.descripcion,
        'cierraenapp': asign.cierraenapp,
        'nomostrarapp': asign.nomostrarapp,
        'urlDni2': asign.urlDni2,
        'urlFirma2': asign.urlFirma2,
        'fechacarga': asign.fechacarga,
        'fechaent': asign.fechaent,
        'tecasig': asign.tecasig,
        'fechacaptura': asign.fechacaptura,
        'linkFoto': asign.linkFoto,
        'elegir': asign.elegirSI == 1
            ? 1
            : asign.elegirNO == 1
                ? 0
                : null,

        //----------------- Campos que cambian el valor -----------------
        'estadogaos': asign.estadogaos,
        'estadO3': widget.funcionApp.serieObligatoria == 1
            ? asign.estadO3
            : asign.decO1, //Mac Serie
        'marcaModeloId': asign.marcaModeloId != 'Elija un Modelo...'
            ? asign.marcaModeloId
            : asign.decO1,
        'observacion': _observaciones,
        'evento4': asign.evento3,
        'fechaEvento4': asign.fechaEvento3,
        'evento3': asign.evento2,
        'fechaEvento3': asign.fechaEvento2,
        'evento2': asign.evento1,
        'fechaEvento2': asign.fechaEvento1,
        'evento1': evento1,
        'fechaEvento1': fechaYa.toString(),
        'estadO2': asign.estadogaos == 'EJB' ? 'SI' : 'NO',
        'codigoCierre': asign.codigoCierre,

        'urlDni': 'Por ahora no hay DNI',
        'urlFirma': 'Por ahora no hay Firma',
        'fechacumplida': fechaYa.toString(),
        'hsCumplida': 80000,
        'hsCumplidaTime': fechaYa.toString(),
        'imageArrayDni': base64imageDNI,
        'imageArrayFirma': base64imageFirma,
      };

      Response response = await ApiHelper.put(
          '/api/AsignacionesOTs/', asign.idregistro.toString(), request);

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

    setState(() {});
    Navigator.pop(context, "Yes");
  }

//*****************************************************************************
//************************** SHOWMAP ******************************************
//*****************************************************************************

  void _showMap(Asignacion2 asignacion) async {
    _markers.clear();
    var lat = double.tryParse(asignacion.grxx.toString()) ?? 0;
    var long = double.tryParse(asignacion.gryy.toString()) ?? 0;

    if (lat == 0 || long == 0 || isNullOrEmpty(lat) || isNullOrEmpty(long)) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "Esta asignación no tiene coordenadas cargadas.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
                              '${asignacion.cliente.toString()} - ${asignacion.nombre.toString()}',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                            Expanded(
                                child: Text(asignacion.domicilio.toString(),
                                    style: const TextStyle(fontSize: 12))),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
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
                                      primary: const Color(0xFFb3b3b4),
                                      minimumSize:
                                          const Size(double.infinity, 30),
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

//*****************************************************************************
//************************** GETCOMBOEQUIPOS **********************************
//*****************************************************************************

  List<DropdownMenuItem<String>> _getComboEquipos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija un Modelo...'),
      value: 'Elija un Modelo...',
    ));

    for (var control in widget.controlesEquivalencia) {
      list.add(DropdownMenuItem(
        child: Text(control.descripcion.toString()),
        value: control.decO1.toString(),
      ));
    }

    return list;
  }

//*****************************************************************************
//************************** SELECTPICTURE ************************************
//*****************************************************************************
  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChangedDNI = true;
        _image = image;
      });
    }
  }
}
