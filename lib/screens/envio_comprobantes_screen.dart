// ignore_for_file: unnecessary_const

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnvioComprobantesScreen extends StatefulWidget {
  final Usuario user;
  const EnvioComprobantesScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EnvioComprobantesScreenState createState() =>
      _EnvioComprobantesScreenState();
}

class _EnvioComprobantesScreenState extends State<EnvioComprobantesScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;
  List<Asignacion2> _asignaciones = [];
  List<Asignacion2> _asignaciones2 = [];
  Asignacion2 asignacionSelected = Asignacion2(
      recupidjobcard: '',
      cliente: '',
      documento: '',
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
      zona: '',
      modificadoAPP: 0,
      hsCumplidaTime: '');

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _getAsignaciones();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envío de Comprobantes'),
        backgroundColor: const Color(0xFF282886),
        centerTitle: true,
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
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        Expanded(
          child: _asignaciones2.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Asignaciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getAsignaciones,
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
                                        child: Text("Proyecto: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Expanded(
                                        child: Text(e.proyectomodulo.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 80,
                                        child: Text("Hora Cump.: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Text(
                                          DateFormat('HH:mm').format(
                                              DateTime.parse(
                                                  e.hsCumplidaTime.toString())),
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
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
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 80,
                                        child: Text("DNI: ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0e4888),
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(e.documento.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      e.proyectomodulo == 'Cable'
                                          ? const SizedBox(
                                              width: 30,
                                              child: const Text("OT: ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xFF0e4888),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            )
                                          : Container(),
                                      e.proyectomodulo == 'Cable'
                                          ? Expanded(
                                              flex: 1,
                                              child: Text(
                                                  e.recupidjobcard.toString(),
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
//************************** METODO LOADOBRAS *********************************
//*****************************************************************************

  Future<void> _getAsignaciones() async {
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

    response = await ApiHelper.getAsignacionesEjb(widget.user.idUser);

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

    _asignaciones = response.result;
    _asignaciones2 = [];

    //Guardo en _asignaciones2 solamente las asignaciones de Proyectos que llevan Comprobantes
    _asignaciones.forEach((asignacion) {
      if (asignacion.proyectomodulo == 'DTV' ||
          asignacion.proyectomodulo == 'Cable' ||
          asignacion.proyectomodulo == 'Tasa' ||
          asignacion.proyectomodulo == 'Prisma' ||
          asignacion.proyectomodulo == 'TLC') {
        _asignaciones2.add(asignacion);
      }
    });

    _asignaciones2.sort((b, a) {
      return a.hsCumplidaTime
          .toString()
          .toLowerCase()
          .compareTo(b.hsCumplidaTime.toString().toLowerCase());
    });

    setState(() {
      _showLoader = false;
    });
  }

//-------------------------------------------------------------------------
//-------------------------- _goInfoAsignacion ----------------------------
//-------------------------------------------------------------------------

  void _goInfoAsignacion(Asignacion2 asignacion) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnvioComprobanteScreen(
                  user: widget.user,
                  asignacion: asignacion,
                )));
  }

//-------------------------------------------------------------------------
//-------------------------- METODO isNullOrEmpty -------------------------
//-------------------------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);
}
