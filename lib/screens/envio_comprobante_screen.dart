import 'dart:io';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class EnvioComprobanteScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;

  const EnvioComprobanteScreen({
    Key? key,
    required this.user,
    required this.asignacion,
  }) : super(key: key);

  @override
  _EnvioComprobanteScreenState createState() => _EnvioComprobanteScreenState();
}

class _EnvioComprobanteScreenState extends State<EnvioComprobanteScreen>
    with SingleTickerProviderStateMixin {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool bandera = false;
  List<Asign> _asigns = [];

  final List<String> cuandos = [
    "esta semana",
    "mañana",
    "pasado mañana",
    "el día lunes por la mañana",
    "el día lunes por la tarde",
    "el día martes por la mañana",
    "el día martes por la tarde",
    "el día miércoles por la mañana",
    "el día miércoles por la tarde",
    "el día jueves por la mañana",
    "el día jueves por la tarde",
    "el día viernes por la mañana",
    "el día viernes por la tarde",
    "el día sábado por la mañana",
  ];

  String codCierre = '';
  String codCierreGenerico = '';

  int _enviarRecibo = 0;
  String _mensajeRecibo = '';

  String _telefono = 'Elija un Teléfono...';
  String _telefonoError = '';
  bool _telefonoShowError = false;

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  Asignacion2 _asignacion = Asignacion2(
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
      hsCumplidaTime: 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    super.initState();
    _asignacion = widget.asignacion;
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
            child: Column(
              children: [
                AppBar(
                  title: (const Text("Envío de Comprobante")),
                  centerTitle: true,
                  backgroundColor: const Color(0xff282886),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        _showAsignacion(),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.chat),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Enviar Comprobante como Texto'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              _enviarRecibo = 1;
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.picture_as_pdf),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Enviar Comprobante PDF'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              _enviarRecibo = 2;
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
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

    setState(() {
      _asigns = response.result;
    });
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
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                child: Text('${_asignacion.proyectomodulo}',
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
                              Text(DateFormat('HH:mm').format(DateTime.now()),
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
                                child: Text(_asignacion.documento.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              _asignacion == 'Cable'
                                  ? const SizedBox(
                                      width: 30,
                                      child: const Text("OT: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    )
                                  : Container(),
                              _asignacion == 'Cable'
                                  ? Expanded(
                                      flex: 1,
                                      child: Text(
                                          _asignacion.recupidjobcard.toString(),
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
                                    'CP: ${_asignacion.cp.toString()} - ${_asignacion.localidad.toString()} - ${_asignacion.partido.toString()}',
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
                                child: Text(_asignacion.telefono.toString(),
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
                                  _asignacion.cantAsign.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _asignacion.cantAsign! > 1
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
          ],
        ),
      ),
    );
  }
}
