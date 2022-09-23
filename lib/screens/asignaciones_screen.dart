// ignore_for_file: unnecessary_const

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/models/zona.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AsignacionesScreen extends StatefulWidget {
  final Usuario user;
  final Position positionUser;
  const AsignacionesScreen(
      {Key? key, required this.user, required this.positionUser})
      : super(key: key);

  @override
  _AsignacionesScreenState createState() => _AsignacionesScreenState();
}

class _AsignacionesScreenState extends State<AsignacionesScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  bool _showLoader = false;
  bool _isFiltered = false;
  bool bandera = false;

  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  double _sliderValue = 0;
  bool _prioridad = false;
  bool _citaHoy = false;

  bool _ordenarPorCliente = true;
  bool _ordenarPorFecha = false;

  List<TipoAsignacion> _tiposasignacion = [];
  List<Zona> _zonas = [];
  List<Cartera> _carteras = [];
  List<Asignacion2> _asignaciones = [];
  List<Asignacion2> _asignaciones2 = [];

  List<ControlesEquivalencia> _controlesEquivalencia = [];

  List<FuncionesApp> _funcionesApp = [];
  FuncionesApp _funcionApp = FuncionesApp(
      proyectomodulo: '',
      habilitaFoto: 0,
      habilitaDNI: 0,
      habilitaEstadisticas: 0,
      habilitaFirma: 0,
      serieObligatoria: 0,
      codigoFinal: 0,
      habilitaOtroRecupero: 0,
      habilitaCambioModelo: 0);

  List<CodigoCierre> _codigoscierreAux = [];
  final List<CodigoCierre> _codigoscierre = [];

  String _tipoasignacion = 'Elija un Tipo de Asignación...';
  String _tipoasignacionError = '';
  bool _tipoasignacionShowError = false;

  String _zona = 'Elija una Zona...';
  final String _zonaError = '';
  final bool _zonaShowError = false;

  String _cartera = 'Elija una Cartera...';
  final String _carteraError = '';
  final bool _carteraShowError = false;

  int intentos = 0;

  Asignacion2 asignacionSelected = Asignacion2(
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

  final Set<Marker> _markers = {};

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _tipoasignacion != 'Elija un Tipo de Asignación...'
            ? Text(
                'Asig. $_tipoasignacion: ${_asignaciones2.length.toString()}')
            : Text('Asignaciones: ${_asignaciones2.length.toString()}'),
        backgroundColor: const Color(0xFF282886),
        centerTitle: true,
        actions: <Widget>[
          _asignaciones.isEmpty
              ? Container()
              : IconButton(onPressed: _showMap, icon: const Icon(Icons.map)),
          _asignaciones.isEmpty
              ? Container()
              : _isFiltered
                  ? IconButton(
                      onPressed: _removeFilter,
                      icon: const Icon(Icons.filter_none))
                  : IconButton(
                      onPressed: _showFilter,
                      icon: const Icon(Icons.filter_alt)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        color: const Color(0xFFC7C7C8),
        child: Center(
          child: _showLoader
              ? const LoaderComponent(
                  text: 'Cargando ASIGNACIONES.',
                )
              : _getContent(),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWTIPOS-------------------------------------
//-----------------------------------------------------------------------------

  Widget _showTipos() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _tiposasignacion.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Cargando Tipos de Asignación...'),
                    ],
                  )
                : DropdownButtonFormField(
                    value: _tipoasignacion,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Elija un Tipo de Asignación...',
                      labelText: 'Tipo de Asignación',
                      errorText: _tipoasignacionShowError
                          ? _tipoasignacionError
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _getComboTiposAsignacion(),
                    onChanged: (value) {
                      _tipoasignacion = value.toString();
                    },
                  ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
            child: const Icon(Icons.search),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF282886),
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            //onPressed: () => _getObras(),
            onPressed: () async {
              await _getObras();
            }),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getComboTiposAsignacion() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija un Tipo de Asignación...'),
      value: 'Elija un Tipo de Asignación...',
    ));

    for (var tipoasignacion in _tiposasignacion) {
      list.add(DropdownMenuItem(
        child: Text(tipoasignacion.proyectomodulo.toString()),
        value: tipoasignacion.proyectomodulo.toString(),
      ));
    }

    return list;
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWZONAS-------------------------------------
//-----------------------------------------------------------------------------

  Widget _showZonas() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 66,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _tiposasignacion.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Cargando Zonas...'),
                    ],
                  )
                : DropdownButtonFormField(
                    value: _zona,
                    isExpanded: true,
                    isDense: true,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Elija una Zona...',
                      labelText: 'Zona',
                      errorText: _zonaShowError ? _zonaError : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _getComboZonas(),
                    onChanged: (value) {
                      _zona = value.toString();
                      if (_zona != 'Elija una Zona...' ||
                          _cartera != 'Elija una Cartera...') {
                        _isFiltered = true;
                      } else {
                        _isFiltered = false;
                      }
                      setState(() {});

                      _filter();
                    },
                  ),
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------------------
//--------------------------- SHOWTEXTFILTER ----------------------------------
//-----------------------------------------------------------------------------
  Widget _showTextFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Expanded(flex: 4, child: _showTextoBuscar()),
              Expanded(flex: 2, child: _showButtons()),
            ],
          ),
          const SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showTextoBuscar -------------------
//-----------------------------------------------------------------

  Widget _showTextoBuscar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _searchController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Texto a buscar...',
          labelText: 'Texto a buscar',
          //errorText: _codigoShowError ? _codigoError : null,

          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: const Color(0xFF282886),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _search = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTONS ------------------------
//-----------------------------------------------------------------

  Widget _showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF282886),
                minimumSize: const Size(50, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _filter();
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
                  width: 5,
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _search = '';
              _searchController.text = '';
              _filter();
            }, //=> _search(),
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _getComboZonas ---------------------
//-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboZonas() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija una Zona...'),
      value: 'Elija una Zona...',
    ));

    for (var zona in _zonas) {
      if (zona.zona == '') {
        zona.zona = ' Sin Zona';
      }

      list.add(DropdownMenuItem(
        child: Text(zona.zona.toString()),
        value: zona.zona.toString(),
      ));
    }

    return list;
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWCARTERAS----------------------------------
//-----------------------------------------------------------------------------

  Widget _showCarteras() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            height: 66,
            child: _tiposasignacion.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Cargando Carteras...'),
                    ],
                  )
                : DropdownButtonFormField(
                    value: _cartera,
                    isExpanded: true,
                    isDense: true,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Elija una Cartera...',
                      labelText: 'Cartera',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      errorText: _carteraShowError ? _carteraError : null,
                    ),
                    items: _getComboCarteras(),
                    onChanged: (value) {
                      _cartera = value.toString();

                      if (_zona != 'Elija una Zona...' ||
                          _cartera != 'Elija una Cartera...') {
                        _isFiltered = true;
                      } else {
                        _isFiltered = false;
                      }
                      setState(() {});
                      _filter();
                    },
                  ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getComboCarteras() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija una Cartera...'),
      value: 'Elija una Cartera...',
    ));

    for (var cartera in _carteras) {
      if (cartera.motivos == '') {
        cartera.motivos = ' Sin Cartera';
      }

      list.add(DropdownMenuItem(
        child: Text(cartera.motivos.toString()),
        value: cartera.motivos.toString(),
      ));
    }

    return list;
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        // _zonas.length <= 1 && _carteras.length <= 1
        //     ? _showTipos()
        //     : Container(),

        _asignaciones.isEmpty ? _showTipos() : _showTextFilter(),

        // _zonas.length > 1 ? _showZonas() : Container(),
        // _carteras.length > 1 ? _showCarteras() : Container(),

        //_showAsignacionesCount(),
        _showFiltros(),
        Expanded(
          child: _asignaciones2.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO SHOWAFILTROS --------------------------
//-----------------------------------------------------------------------------

  Widget _showFiltros() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: 100,
      child: Column(
        children: [
          Row(
            children: [
              const Text("Prioridad: ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Checkbox(
                  value: _prioridad,
                  focusColor: const Color(0xFF282886),
                  fillColor: MaterialStateProperty.all(const Color(0xFF282886)),
                  onChanged: (value) {
                    _prioridad = value!;
                    _filter();
                  }),
              const SizedBox(
                width: 50,
              ),
              const Text("Con Cita HOY: ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Checkbox(
                  value: _citaHoy,
                  focusColor: const Color(0xFF282886),
                  fillColor: MaterialStateProperty.all(const Color(0xFF282886)),
                  onChanged: (value) {
                    _citaHoy = value!;
                    _filter();
                  }),
              ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.sort_by_alpha),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF282886),
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _orderMethod();
                  }),
            ],
          ),
          Row(
            children: [
              const Text("Antiguedad (días): ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
              Slider(
                min: 0,
                max: 100,
                activeColor: const Color(0xFF282886),
                value: _sliderValue,
                onChanged: (value) {
                  _sliderValue = value;
                  _filter();
                },
                divisions: 5,
              ),
              Center(child: Text(_sliderValue.round().toString())),
            ],
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Asignaciones con ese criterio de búsqueda'
              : 'No hay Asignaciones registradas',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getObras,
      child: ListView(
        children: _asignaciones2.map((e) {
          return Card(
            color: Colors.white,
            //color: Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                asignacionSelected = e;
                _goInfoAsignacion(e);
              },
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
                                            '${e.cliente.toString()} - ${e.nombre.toString()}',
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
                                  //       child:
                                  //           Text(e.reclamoTecnicoID.toString(),
                                  //               style: TextStyle(
                                  //                 fontSize: 12,
                                  //               )),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 1,
                                  // ),
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
                                        child: Text(e.domicilio.toString(),
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
                                        child: (e.entrecallE1
                                                        .toString()
                                                        .length >
                                                    1 &&
                                                e.entrecallE2
                                                        .toString()
                                                        .length >
                                                    1)
                                            ? Text(
                                                '${e.entrecallE1.toString()} y ${e.entrecallE2.toString()}',
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
                                            'CP: ${e.cp.toString()} - ${e.localidad.toString()} - ${e.partido.toString()}',
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
                                      e.zona != ""
                                          ? const SizedBox(
                                              width: 80,
                                              child: Text("Zona: ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF0e4888),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            )
                                          : Container(),
                                      e.zona != ""
                                          ? Expanded(
                                              child: Text(e.zona.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text("Provincia: ",
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           color: Color(0xFF0e4888),
                                  //           fontWeight: FontWeight.bold,
                                  //         )),
                                  //     Expanded(
                                  //       child: Text(e.provincia.toString(),
                                  //           style: TextStyle(
                                  //             fontSize: 12,
                                  //           )),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 1,
                                  // ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 80,
                                        child: Text("Teléfono: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Expanded(
                                        child: Text(e.telefono.toString(),
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
                                        child: Text("Cant. Eq.: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.cantAsign.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: e.cantAsign! > 1
                                                ? Colors.red
                                                : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                        child: Text(e.descripcion.toString(),
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
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 80,
                                                  child: Text("Fec. Asig.: ",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF0e4888),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                                Expanded(
                                                  child: e.fechaAsignada == null
                                                      ? const Text("")
                                                      : Text(
                                                          DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime.parse(e
                                                                  .fechaAsignada
                                                                  .toString())),
                                                          style:
                                                              const TextStyle(
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
                                            //     Text("Medio Cita: ",
                                            //         style: TextStyle(
                                            //           fontSize: 12,
                                            //           color: Color(0xFF0e4888),
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //         )),
                                            //     Expanded(
                                            //       child: Text(
                                            //           e.medioCita.toString(),
                                            //           style: TextStyle(
                                            //             fontSize: 12,
                                            //           )),
                                            //     ),
                                            //   ],
                                            // ),
                                            // SizedBox(
                                            //   height: 1,
                                            // ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 80,
                                                  child: Text("Fec. Cita: ",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF0e4888),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                                Expanded(
                                                  child: e.fechaCita == null
                                                      ? const Text("")
                                                      : Text(
                                                          DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime
                                                                  .parse(e
                                                                      .fechaCita
                                                                      .toString())),
                                                          style:
                                                              const TextStyle(
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
                                                  child: Text("Hora Cita: ",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF0e4888),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                                Expanded(
                                                  child: e.fechaCita == null
                                                      ? const Text("")
                                                      : Text(
                                                          DateFormat('HH:mm')
                                                              .format(DateTime
                                                                  .parse(e
                                                                      .fechaCita
                                                                      .toString())),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Column(
                                          children: [
                                            ElevatedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.fact_check),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('Agendar Cita'),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    const Color(0xFF282886),
                                                minimumSize: const Size(60, 36),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: () => _agendarcita(e),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 80,
                                        child: Text("Cartera: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Expanded(
                                        child: Text(e.motivos.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOADDATA **********************************
//*****************************************************************************

  void _loadData() async {
    await _getTiposAsignaciones();
  }

//*****************************************************************************
//************************** METODO GETTIPOASIGNACIONES ***********************
//*****************************************************************************

  Future<void> _getTiposAsignaciones() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
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
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getTipoAsignaciones(widget.user.idUser);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _tiposasignacion = response.result;
      }
    } while (bandera == false);
    // await showAlertDialog(
    //     context: context,
    //     title: 'Intentos',
    //     message: intentos.toString(),
    //     actions: <AlertDialogAction>[
    //       AlertDialogAction(key: null, label: 'Aceptar'),
    //     ]);
    setState(() {});
  }

//*****************************************************************************
//************************** METODO GETZONAS **********************************
//*****************************************************************************

  Future<void> _getZonas() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
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
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getZonas(widget.user.idUser, _tipoasignacion);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _zonas = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

//*****************************************************************************
//************************** METODO GETCARTERAS **********************************
//*****************************************************************************

  Future<void> _getCarteras() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
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
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response =
          await ApiHelper.getCarteras(widget.user.idUser, _tipoasignacion);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _carteras = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

//*****************************************************************************
//************************** METODO LOADOBRAS *********************************
//*****************************************************************************

  Future<void> _getObras() async {
    if (_tipoasignacion == 'Elija un Tipo de Asignación...') {
      _tipoasignacionShowError = true;
      _tipoasignacionError = 'Elija un Tipo de Asignación...';
      setState(() {});
      return;
    } else {
      _tipoasignacionShowError = false;
    }

    _prioridad = false;

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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);
    response =
        await ApiHelper.getAsignaciones(widget.user.idUser, _tipoasignacion);

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

    Response response2 = Response(isSuccess: false);
    response2 = await ApiHelper.getFuncionesApp(_tipoasignacion);
    Response response3 = Response(isSuccess: false);
    response3 = await ApiHelper.getControlesEquivalencia(_tipoasignacion);

    if (!response2.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    if (!response3.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _asignaciones = response.result;

    if (_ordenarPorCliente) {
      _asignaciones.sort((a, b) {
        return a.cliente
            .toString()
            .toLowerCase()
            .compareTo(b.cliente.toString().toLowerCase());
      });
    }

    if (_ordenarPorFecha) {
      _asignaciones.sort((a, b) {
        return a.fechaAsignada
            .toString()
            .toLowerCase()
            .compareTo(b.fechaAsignada.toString().toLowerCase());
      });
    }

    _funcionesApp = response2.result;

    _controlesEquivalencia = response3.result;

    _funcionApp = _funcionesApp[0];

    _asignaciones2 = _asignaciones;

    await _getCodigosCierre();
    await _getZonas();
    await _getCarteras();
    setState(() {
      _showLoader = false;
    });
  }

//*****************************************************************************
//************************** METODO LOADOBRAS *********************************
//*****************************************************************************

  Future<void> _getCodigosCierre() async {
    if (_tipoasignacion == 'Elija un Tipo de Asignación...') {
      _tipoasignacionShowError = true;
      _tipoasignacionError = 'Elija un Tipo de Asignación...';
      setState(() {});
      return;
    } else {
      _tipoasignacionShowError = false;
    }

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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getCodigosCierre(_tipoasignacion);

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
    _codigoscierreAux = response.result;
    _codigoscierre.clear();

    for (var codCierre in _codigoscierreAux) {
      if (codCierre.codigoCierre != _funcionApp.codigoFinal) {
        _codigoscierre.add(codCierre);
      }
    }

    _codigoscierre.sort((a, b) {
      return a.codigoCierre
          .toString()
          .toLowerCase()
          .compareTo(b.codigoCierre.toString().toLowerCase());
    });
  }

//*****************************************************************************
//************************** METODO GOINFOOBRA ********************************
//*****************************************************************************

  void _goInfoAsignacion(Asignacion2 asignacion) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AsignacionInfoScreen(
                  user: widget.user,
                  asignacion: asignacion,
                  codigoscierre: _codigoscierre,
                  codigoscierreAux: _codigoscierreAux,
                  positionUser: widget.positionUser,
                  funcionApp: _funcionApp,
                  controlesEquivalencia: _controlesEquivalencia,
                )));
    if (result == 'Yes') {
      _getObras();
      setState(() {});
    }
  }

//*****************************************************************************
//************************** METODO REMOVEFILTER ******************************
//*****************************************************************************

  void _removeFilter() {
    setState(() {
      _search = '';
      _isFiltered = false;
    });
    //_asignaciones2 = _asignaciones;
    _filter();
  }

//*****************************************************************************
//************************** METODO SHOWFILTER ********************************
//*****************************************************************************

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Filtrar Asignaciones'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text('Seleccione un valor de las listas desplegables'),
              const SizedBox(
                height: 10,
              ),
              _zonas.length > 1 ? _showZonas() : Container(),
              _carteras.length > 1 ? _showCarteras() : Container(),
            ]),
            //actions: <Widget>[
            // TextButton(
            //     onPressed: () => Navigator.of(context).pop(),
            //     child: const Text('Cancelar')),
            // TextButton(
            //     onPressed: () {
            //       _filter();
            //       if (_search != '') {
            //         _isFiltered = true;
            //       } else {
            //         _isFiltered = false;
            //       }

            //       Navigator.of(context).pop();
            //     },
            //     child: const Text('Filtrar')),
            //],
          );
        });
  }

//*****************************************************************************
//************************** METODO FILTER ************************************
//*****************************************************************************

  _filter() {
    // if (_search.isEmpty) {
    //   return;
    // }
    List<Asignacion2> filteredList = [];
    bool condicionTexto = false;
    bool condicionAntig = false;
    bool condicionCodCierre = false;
    bool condicionFechaCita = false;
    bool condicionZona = false;
    bool condicionCartera = false;
    bool condicionCitaHoy = false;

    for (var asignacion in _asignaciones) {
      if (_zona == 'Elija una Zona...') {
        condicionZona = true;
      } else if (_zona == ' Sin Zona') {
        condicionZona = asignacion.zona == '';
      } else {
        condicionZona = asignacion.zona == _zona;
      }

      if (_cartera == 'Elija una Cartera...') {
        condicionCartera = true;
      } else if (_cartera == ' Sin Cartera') {
        condicionCartera = asignacion.motivos == '';
      } else {
        condicionCartera = asignacion.motivos == _cartera;
      }

      asignacion.fechaAsignada ??= DateTime.now().toString();
      if (asignacion.fechaAsignada == '') {
        asignacion.fechaAsignada = DateTime.now().toString();
      }

      asignacion.fechaCita == ''
          ? asignacion.fechaCita = null
          : asignacion.fechaCita = asignacion.fechaCita;

//----------- Condiciones ---------------------------
//------------------------------------------------------------------------
      condicionTexto = (asignacion.nombre
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          asignacion.cliente
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          asignacion.reclamoTecnicoID
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          asignacion.domicilio
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          asignacion.cp
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()));
//------------------------------------------------------------------------
      condicionAntig = DateTime.now()
              .difference(DateTime.parse(asignacion.fechaAsignada!))
              .inDays >=
          _sliderValue;
//------------------------------------------------------------------------
      condicionCodCierre = _prioridad
          ? asignacion.codigoCierre == 45
          : asignacion.codigoCierre != 9999;
//------------------------------------------------------------------------
      if (!_citaHoy) {
        condicionCitaHoy = true;
      } else {
        if (asignacion.fechaCita != null) {
          DateTime now = DateTime.now();
          DateTime hoy = DateTime(now.year, now.month, now.day);
          DateTime fechaAsigAux = DateTime.parse(asignacion.fechaCita!);
          DateTime fechaAsig =
              DateTime(fechaAsigAux.year, fechaAsigAux.month, fechaAsigAux.day);

          condicionCitaHoy = _citaHoy ? fechaAsig == hoy : true;
        } else {
          condicionCitaHoy = false;
        }
      }
//------------------------------------------------------------------------
      condicionFechaCita = (asignacion.fechaCita != null);
//------------------------------------------------------------------------
      if (condicionTexto &&
          condicionAntig &&
          (condicionCodCierre || condicionFechaCita) &&
          condicionZona &&
          condicionCartera &&
          condicionCitaHoy) {
        filteredList.add(asignacion);
      }
    }

    setState(() {
      _asignaciones2 = filteredList;
    });
  }

//*****************************************************************************
//************************** METODO AGENDARCITA *******************************
//*****************************************************************************

  void _agendarcita(Asignacion2 asignacion) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AgendarCitaScreen(
                  user: widget.user,
                  asignacion: asignacion,
                )));
    if (result == 'yes') {
      _getObras();
      setState(() {});
    }
  }

//*****************************************************************************
//************************** METODO SHOWMAP ***********************************
//*****************************************************************************

  void _showMap() {
    if (_asignaciones2.isEmpty) {
      return;
    }

    _markers.clear();

    double latmin = 180.0;
    double latmax = -180.0;
    double longmin = 180.0;
    double longmax = -180.0;
    double latcenter = 0.0;
    double longcenter = 0.0;

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

        _markers.add(Marker(
            markerId: MarkerId(asign.reclamoTecnicoID.toString()),
            position: LatLng(lat, long),
            // infoWindow: InfoWindow(
            //   title: '${asign.cliente.toString()} - ${asign.nombre.toString()}',
            //   snippet: asign.domicilio.toString(),
            // ),
            onTap: () {
              // CameraPosition(
              //     target: LatLng(element.latitud!.toDouble(),
              //         element.longitud!.toDouble()),
              //     zoom: 16.0);
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
                                '${asign.cliente.toString()} - ${asign.nombre.toString()}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )),
                              Expanded(
                                  child: Text(asign.domicilio.toString(),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () => _navegar(asign),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Abrir',
                                            style: TextStyle(
                                                color: Color(0xff282886)),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.arrow_forward_ios,
                                              color: Color(0xff282886)),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFFb3b3b4),
                                        minimumSize:
                                            const Size(double.infinity, 30),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () => _goInfoAsignacion(asign),
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
            icon: (asign.codigoCierre == 0)
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange)));
      }
    }
    latcenter = (latmin + latmax) / 2;
    longcenter = (longmin + longmax) / 2;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsignacionesMapScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          asignacion: _asignaciones[0],
          posicion: LatLng(latcenter, longcenter),
          markers: _markers,
          customInfoWindowController: _customInfoWindowController,
        ),
      ),
    );
  }

//-------------------------------------------------------------------------
//-------------------------- METODO isNullOrEmpty -------------------------
//-------------------------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);

//-------------------------------------------------------------------------
//-------------------------- METODO NAVEGAR -------------------------------
//-------------------------------------------------------------------------

  _navegar(e) async {
    if (e.grxx == "" ||
        e.gryy == "" ||
        isNullOrEmpty(e.grxx) ||
        isNullOrEmpty(e.gryy)) {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: "Este cliente no tiene coordenadas cargadas.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
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
      await showAlertDialog(
          context: context,
          title: 'Aviso!',
          message: "Necesita estar conectado a Internet para acceder al mapa",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

//*****************************************************************************
//************************** METODO _orderMethod ********************************
//*****************************************************************************

  void _orderMethod() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Ordenar por'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text('Elija Criterio de ordenación'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'N° Cliente ascendente',
                      style: TextStyle(color: Color(0xffFFFFFF)),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff282886),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  _ordenarPorCliente = true;
                  _ordenarPorFecha = false;
                  Navigator.pop(context);
                  _ordenar();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Fechas más antiguas primero',
                      style: TextStyle(color: Color(0xffFFFFFF)),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff282886),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  _ordenarPorCliente = false;
                  _ordenarPorFecha = true;
                  Navigator.pop(context);
                  _ordenar();
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
          );
        });
  }

  void _ordenar() {
    if (_ordenarPorCliente) {
      _asignaciones.sort((a, b) {
        return a.cliente
            .toString()
            .toLowerCase()
            .compareTo(b.cliente.toString().toLowerCase());
      });
      _asignaciones2.sort((a, b) {
        return a.cliente
            .toString()
            .toLowerCase()
            .compareTo(b.cliente.toString().toLowerCase());
      });
    }

    if (_ordenarPorFecha) {
      _asignaciones.sort((a, b) {
        return a.fechaAsignada
            .toString()
            .toLowerCase()
            .compareTo(b.fechaAsignada.toString().toLowerCase());
      });
      _asignaciones2.sort((a, b) {
        return a.fechaAsignada
            .toString()
            .toLowerCase()
            .compareTo(b.fechaAsignada.toString().toLowerCase());
      });
    }

    setState(() {});
  }
}
