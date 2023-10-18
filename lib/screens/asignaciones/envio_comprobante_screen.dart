import 'dart:io';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
//import 'package:whatsapp_share2/whatsapp_share2.dart';
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
//--------------------------------------------------------------
//------------------------- Variables --------------------------
//--------------------------------------------------------------

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  bool bandera = false;
  bool verPDF = false;
  List<Asign> _asigns = [];
  List<AsignacionesOtsEquiposExtra> _equiposExtra = [];

  String newPath = "";

  bool _showLoader = false;

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
      habilitaCambioModelo: 0,
      habilitaVerPdf: 0);

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

  bool _existeChat = false;

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
      fechacaptura: '',
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
      hsCumplidaTime: '',
      marcado: 0);

//--------------------------------------------------------------
//------------------------- initState --------------------------
//--------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _asignacion = widget.asignacion;
    _getAsigns();
  }

//--------------------------------------------------------------
//------------------------- Pantalla ---------------------------
//--------------------------------------------------------------

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
                        const Spacer(),
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
                              backgroundColor: Colors.deepPurple,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              String message = '';

                              String empresa =
                                  _asignacion.proyectomodulo.toString();
                              if (empresa == 'Otro' || empresa == 'TLC') {
                                empresa = 'Telecentro';
                              }

                              if (empresa == 'Cable') {
                                empresa = 'Cablevisión';
                              }

                              if (empresa == 'Tasa') {
                                empresa = 'Movistar';
                              }

                              if (empresa == 'Prisma') {
                                empresa = 'Prisma';
                              }

                              if (empresa == 'SuperC') {
                                empresa = 'SuperC';
                              }

                              if (empresa == 'DTV') {
                                empresa = 'DirecTV';
                              }

                              for (Asign asign in _asigns) {
                                String mm = (asign.proyectomodulo.toString() ==
                                            'DTV' ||
                                        asign.proyectomodulo.toString() ==
                                            'Cable' ||
                                        asign.proyectomodulo.toString() ==
                                            'TLC')
                                    ? asign.decO1
                                        .toString() //campo deco1 de la base.
                                    : asign.estadO3
                                        .toString(); //campo estado03 de base, proviene del app porque escanea un codigo
                                _mensajeRecibo =
                                    _mensajeRecibo + "Equipo: " + mm + "\n";
                              }

                              message = 'Recibimos del cliente ' +
                                  _asignacion.nombre.toString() +
                                  " - " +
                                  _asignacion.domicilio.toString() +
                                  ' los equipos detallados a continuación: ' +
                                  "\n" +
                                  _mensajeRecibo +
                                  "\n" +
                                  'Atentamente' +
                                  "\n" +
                                  widget.user.apellidonombre.toString() +
                                  " - Empresa Fleet al servicio de " +
                                  empresa;

                              //_sendMessage2(message);

                              //------------------------------------------------
                              String _number2 = "";
                              TextEditingController _phoneController =
                                  TextEditingController();
                              _phoneController.text = "";

                              await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: const [
                                              Text(
                                                "Atención!!",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          content: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 250,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Verifique si el N° de teléfono tiene el formato correcto para WhatsApp",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  const Text(""),
                                                  DropdownButtonFormField(
                                                    value: _telefono,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText:
                                                          'Elija un Teléfono...',
                                                      labelText: 'Teléfono',
                                                      errorText:
                                                          _telefonoShowError
                                                              ? _telefonoError
                                                              : null,
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                    ),
                                                    items: _getComboTelefonos(),
                                                    onChanged: (value) {
                                                      _telefono =
                                                          value.toString();
                                                      _number2 =
                                                          value.toString();
                                                      _phoneController.text =
                                                          _number2;
                                                      setState(() {});
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _phoneController,
                                                    //enabled: false,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText:
                                                          'Teléfono seleccionado...',
                                                      labelText:
                                                          'Teléfono seleccionado',
                                                      //errorText:_passwordShowError ? _passwordError : null,
                                                      prefixIcon: const Icon(
                                                          Icons.phone),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      _number2 = value;
                                                      //_phoneController.text = _number2;
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: ElevatedButton(
                                                        child:
                                                            const Text("+549"),
                                                        onPressed: () async {
                                                          if (_number2.length >
                                                              1) {
                                                            _number2 = "549" +
                                                                _number2;
                                                            _phoneController
                                                                    .text =
                                                                "549" +
                                                                    _phoneController
                                                                        .text;
                                                            setState(() {});
                                                          }
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.insert_comment),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Continuar'),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                minimumSize: const Size(
                                                    double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: _number2 != ""
                                                  ? () async {
                                                      final link =
                                                          WhatsAppUnilink(
                                                        phoneNumber: _number2,
                                                        text: message,
                                                      );
                                                      await launch('$link');
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  : null,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.cancel),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Cancelar'),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize: const Size(
                                                    double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                return;
                                              },
                                            ),
                                          ],
                                          shape: Border.all(
                                              color: Colors.green,
                                              width: 5,
                                              style: BorderStyle.solid),
                                          backgroundColor: Colors.white,
                                        );
                                      },
                                    );
                                  });

                              //------------------------------------------------
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
                              backgroundColor: Colors.purple,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              _enviarRecibo = 2;

                              String _number2 = "";

                              String message = '';

                              String empresa =
                                  _asignacion.proyectomodulo.toString();
                              if (empresa == 'Otro' || empresa == 'TLC') {
                                empresa = 'Telecentro';
                              }

                              if (empresa == 'Cable') {
                                empresa = 'Cablevisión';
                              }

                              if (empresa == 'Tasa') {
                                empresa = 'Movistar';
                              }

                              if (empresa == 'DTV') {
                                empresa = 'DirecTV';
                              }

                              if (empresa == 'Prisma') {
                                empresa = 'Prisma';
                              }
                              if (empresa == 'SuperC') {
                                empresa = 'SuperC';
                              }

                              for (Asign asign in _asigns) {
                                String mm = (asign.proyectomodulo.toString() ==
                                            'DTV' ||
                                        asign.proyectomodulo.toString() ==
                                            'Cable' ||
                                        asign.proyectomodulo.toString() ==
                                            'Prisma' ||
                                        asign.proyectomodulo.toString() ==
                                            'SuperC' ||
                                        asign.proyectomodulo.toString() ==
                                            'TLC')
                                    ? asign.decO1
                                        .toString() //campo deco1 de la base.
                                    : asign.estadO3
                                        .toString(); //campo estado03 de base, proviene del app porque escanea un codigo
                                _mensajeRecibo =
                                    _mensajeRecibo + "Equipo: " + mm + "\n";
                              }

                              message = 'Recibimos del cliente ' +
                                  _asignacion.nombre.toString() +
                                  " - " +
                                  _asignacion.domicilio.toString() +
                                  ' los equipos detallados a continuación: ' +
                                  "\n" +
                                  _mensajeRecibo +
                                  "\n" +
                                  'Atentamente' +
                                  "\n" +
                                  widget.user.apellidonombre.toString() +
                                  " - Empresa Fleet al servicio de " +
                                  empresa;
                              TextEditingController _phoneController =
                                  TextEditingController();
                              _phoneController.text = "";
                              _existeChat = false;

                              await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: const [
                                              Text(
                                                "Atención!!",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          content: SingleChildScrollView(
                                            child: SizedBox(
                                              height: 250,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Verifique si el N° de teléfono tiene el formato correcto para WhatsApp",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  const Text(""),
                                                  DropdownButtonFormField(
                                                    value: _telefono,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText:
                                                          'Elija un Teléfono...',
                                                      labelText: 'Teléfono',
                                                      errorText:
                                                          _telefonoShowError
                                                              ? _telefonoError
                                                              : null,
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                    ),
                                                    items: _getComboTelefonos(),
                                                    onChanged: (value) {
                                                      _telefono =
                                                          value.toString();
                                                      _number2 =
                                                          value.toString();
                                                      _phoneController.text =
                                                          _number2;
                                                      setState(() {});
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _phoneController,
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText:
                                                            'Teléfono seleccionado...',
                                                        labelText:
                                                            'Teléfono seleccionado',
                                                        //errorText:_passwordShowError ? _passwordError : null,
                                                        prefixIcon: const Icon(
                                                            Icons.phone),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                    onChanged: (value) {
                                                      _number2 = value;
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: ElevatedButton(
                                                        child:
                                                            const Text("+549"),
                                                        onPressed: () async {
                                                          if (_number2.length >
                                                              1) {
                                                            _number2 = "549" +
                                                                _number2;
                                                            _phoneController
                                                                    .text =
                                                                "549" +
                                                                    _phoneController
                                                                        .text;
                                                            setState(() {});
                                                          }
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            _funcionApp.habilitaVerPdf == 1
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 0.0),
                                                    child: ElevatedButton(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons
                                                              .picture_as_pdf),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text('Ver PDF'),
                                                        ],
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                        minimumSize: const Size(
                                                            double.infinity,
                                                            50),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                      ),
                                                      onPressed: _number2 != ""
                                                          ? _existeChat == false
                                                              ? () async {
                                                                  _number2.substring(
                                                                              0,
                                                                              3) !=
                                                                          '549'
                                                                      ? _number2 =
                                                                          '549' +
                                                                              _number2
                                                                      : _number2 =
                                                                          _number2;

                                                                  verPDF = true;
                                                                  //Navigator.pop(context);
                                                                  _createPDF(
                                                                      _number2,
                                                                      message);

                                                                  setState(
                                                                      () {});
                                                                  return;
                                                                }
                                                              : null
                                                          : null,
                                                    ),
                                                  )
                                                : Container(),
                                            _funcionApp.habilitaVerPdf == 1
                                                ? const SizedBox(
                                                    height: 15,
                                                  )
                                                : Container(),
                                            ElevatedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.insert_comment),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Crear Chat'),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                minimumSize: const Size(
                                                    double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: _number2 != ""
                                                  ? _existeChat == false
                                                      ? () async {
                                                          _number2.substring(0,
                                                                      3) !=
                                                                  '549'
                                                              ? _number2 =
                                                                  '549' +
                                                                      _number2
                                                              : _number2 =
                                                                  _number2;

                                                          await _creaChat(
                                                              _number2);
                                                          setState(() {});
                                                          return;
                                                        }
                                                      : null
                                                  : null,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.picture_as_pdf),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Enviar PDF'),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                minimumSize: const Size(
                                                    double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: _existeChat
                                                  ? () async {
                                                      verPDF = false;
                                                      await _createPDF(
                                                          _number2, message);
                                                      Navigator.pop(context);
                                                      return;
                                                    }
                                                  : null,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.cancel),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Cancelar'),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                minimumSize: const Size(
                                                    double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                return;
                                              },
                                            ),
                                          ],
                                          shape: Border.all(
                                              color: Colors.green,
                                              width: 5,
                                              style: BorderStyle.solid),
                                          backgroundColor: Colors.white,
                                        );
                                      },
                                    );
                                  });

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

//--------------------------------------------------------------
//------------------------- _creaChat --------------------------
//--------------------------------------------------------------

  Future<void> _creaChat(String number) async {
    _existeChat = true;
    final link = WhatsAppUnilink(
      phoneNumber: number,
      //***** MENSAJE DE CONTACTO *****
      text: 'Se adjunta Comprobante',
    );
    await launch('$link');
  }

//--------------------------------------------------------------
//------------------------- _createPDF -------------------------
//--------------------------------------------------------------

  Future<void> _createPDF(String number, String message) async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    //Create a PdfGrid
    PdfGrid grid = PdfGrid();
    PdfGrid grid2 = PdfGrid();
    PdfGrid grid3 = PdfGrid();
    PdfGrid grid4 = PdfGrid();
    PdfGrid grid5 = PdfGrid();
    PdfGrid grid6 = PdfGrid();

    PdfGridStyle style10 = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 10),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    PdfGridStyle style12 = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.style = style10;
    grid2.style = style10;
    grid3.style = style10;
    grid4.style = style10;
    grid5.style = style10;
    grid6.style = style10;

    //Add columns to grid
    grid.columns.add(count: 4);
    grid.headers.add(1);
    grid2.columns.add(count: 2);
    grid2.headers.add(1);
    grid3.columns.add(count: 1);
    grid3.headers.add(1);
    grid4.columns.add(count: 3);
    grid4.headers.add(1);
    grid5.columns.add(count: 2);
    grid5.headers.add(1);
    grid6.columns.add(count: 4);
    grid6.headers.add(1);

    //Create and customize the string formats
    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;
    format.lineAlignment = PdfVerticalAlignment.middle;

    PdfStringFormat format2 = PdfStringFormat();
    format2.alignment = PdfTextAlignment.left;
    format2.lineAlignment = PdfVerticalAlignment.middle;

    //Set the column text format
    grid.columns[0].format = format;
    grid.columns[1].format = format;
    grid.columns[2].format = format2;
    grid.columns[3].format = format;
    grid3.columns[0].format = format;
    grid4.columns[0].format = format;
    grid4.columns[1].format = format;
    grid4.columns[2].format = format;
    grid5.columns[0].format = format;
    grid5.columns[1].format = format;
    grid6.columns[0].format = format;
    grid6.columns[1].format = format;
    grid6.columns[2].format = format;
    grid6.columns[3].format = format;

    //Set the width
    grid.columns[0].width = 140;
    grid.columns[1].width = 138;
    grid.columns[2].width = 92;
    grid.columns[3].width = 140;

    grid2.columns[0].width = 140;
    grid2.columns[1].width = 370;

    grid3.columns[0].width = 510;

    grid4.columns[0].width = 140;
    grid4.columns[1].width = 230;
    grid4.columns[2].width = 140;

    grid5.columns[0].width = 140;
    grid5.columns[1].width = 370;

    grid6.columns[0].width = 140;
    grid6.columns[1].width = 100;
    grid6.columns[2].width = 90;
    grid6.columns[3].width = 180;

    //Add headers to grid
    PdfGridRow header = grid.headers[0];
    header.height = 65;
    PdfGridRow header2 = grid2.headers[0];
    PdfGridRow header3 = grid3.headers[0];
    PdfGridRow header4 = grid4.headers[0];
    PdfGridRow header5 = grid5.headers[0];
    PdfGridRow header6 = grid6.headers[0];
    //header2.height = 35;

    header.cells[1].style = PdfGridCellStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    header.cells[0].value = "";
    header.cells[1].value = "Formulario de Recepción de Equipos";

    String? ot = widget.asignacion.proyectomodulo != 'TLC'
        ? (widget.asignacion.reclamoTecnicoID != null &&
                widget.asignacion.reclamoTecnicoID != '')
            ? widget.asignacion.reclamoTecnicoID.toString()
            : ''
        : (widget.asignacion.documento != null &&
                widget.asignacion.documento != '')
            ? widget.asignacion.documento
            : '';

    header.cells[2].value = """
    N° de Cuenta: 
    ${widget.asignacion.cliente}
    OT: ${ot}
    """;

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = "FLEET GROUP";
    row1.cells[1].value = "Fecha Retiro";
    row1.cells[2].value =
        "  " + DateFormat('dd/MM/yyyy').format(DateTime.now());

    header2.cells[0].value = "Apellido y Nombre del Cliente";
    header2.cells[1].value = widget.asignacion.nombre;
    PdfGridRow row2 = grid2.rows.add();
    row2.cells[0].value = "Documento de identidad";
    row2.cells[1].value = widget.asignacion.documento;
    PdfGridRow row3 = grid2.rows.add();
    row3.cells[0].value = "Dirección";
    row3.cells[1].value =
        '${widget.asignacion.domicilio} - ${widget.asignacion.localidad}';

    //Draw the grid in PDF document page

    final page = document.pages.add();
    final Size pageSize = page.getClientSize();

    grid.draw(page: document.pages[0], bounds: const Rect.fromLTWH(0, 0, 0, 0));
    grid2.draw(
        page: document.pages[0], bounds: const Rect.fromLTWH(0, 85, 0, 0));

    header3.cells[0].value = "Datos del Equipo";

    header4.cells[0].value = "MODELO";
    header4.cells[1].value = "SERIE";
    header4.cells[2].value = "ACCESORIOS";

    //*********** AGREGA EQUIPOS ************

    int contador = 0;
    for (Asign asign in _asigns) {
      if (asign.estadogaos == 'EJB') {
        String modelo =
            asign.marcaModeloId != null ? asign.marcaModeloId.toString() : '';
        String serie = (asign.proyectomodulo.toString() == 'DTV' ||
                asign.proyectomodulo.toString() == 'Cable' ||
                asign.proyectomodulo.toString() == 'TLC')
            ? asign.decO1.toString() //campo deco1 de la base.
            : asign.estadO3
                .toString(); //campo estado03 de base, proviene del app porque escanea un codigo

        PdfGridRow row = grid4.rows.add();
        row.cells[0].value = modelo;
        row.cells[1].value = serie;
        row.cells[2].value = " ";
        contador++;
      }
    }

    //*********** AGREGA EQUIPOS EXTRAS************

    for (AsignacionesOtsEquiposExtra equipoExtra in _equiposExtra) {
      String modelo =
          equipoExtra.coddeco1 != null ? equipoExtra.coddeco1.toString() : '';
      String serie = equipoExtra.nroserieextra != null
          ? '${equipoExtra.nroserieextra.toString()} (Equipo extra)'
          : '';

      PdfGridRow row = grid4.rows.add();
      row.cells[0].value = modelo;
      row.cells[1].value = serie;
      row.cells[2].value = " ";
      contador++;
    }

    header5.cells[0].value = "Observaciones";
    header5.cells[1].value = widget.asignacion.observacion;
    PdfGridRow row5 = grid5.rows.add();
    row5.cells[0].value = "Firma recuperador";
    row5.cells[1].value = "";
    header6.cells[0].value = "Nro. Documento";
    header6.cells[1].value = widget.user.dni ?? '';
    header6.cells[2].value = "Alcaración";
    header6.cells[3].value = widget.user.apellidonombre;

    grid3.draw(
        page: document.pages[0], bounds: const Rect.fromLTWH(0, 143, 0, 0));

    grid4.draw(
        page: document.pages[0], bounds: const Rect.fromLTWH(0, 162, 0, 0));

    grid5.draw(
        page: document.pages[0],
        bounds: Rect.fromLTWH(0, 181 + contador * 19, 0, 0));

    grid6.draw(
        page: document.pages[0],
        bounds: Rect.fromLTWH(0, 220 + (contador) * 19, 0, 0));

    page.graphics.drawImage(PdfBitmap(await _readImageData('logo2.png')),
        const Rect.fromLTWH(15, 10, 120, 35));

    page.graphics.drawImage(
        PdfBitmap(await _readImageData(
            '${widget.asignacion.proyectomodulo.toString().toLowerCase()}.png')),
        const Rect.fromLTWH(380, 10, 120, 35));

    //Graba a PDF
    List<int> bytes = document.save();
    document.dispose();

    await _saveAndLaunchFile(bytes, 'Comprobante.pdf', number);
  }

//--------------------------------------------------------------
//------------------------- _readImageData ---------------------
//--------------------------------------------------------------

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

//--------------------------------------------------------------
//------------------------- _saveAndLaunchFile -----------------
//--------------------------------------------------------------

  Future<void> _saveAndLaunchFile(
      List<int> bytes, String fileName, String number) async {
    await initRecorder();

    final path = (await getExternalStorageDirectory())!.path;
    //final path = (await getApplicationDocumentsDirectory())!.path;

    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    String ruta = '$path/$fileName';

    Uint8List bytes2 = Uint8List.fromList(bytes);

    //OpenFile.open(ruta);

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => PdfScreen(
    //               ruta: ruta,
    //             )));

    if (file.path.isNotEmpty && verPDF == false) {
      await WhatsappShare.shareFile(
          phone: number,
          text: 'Se adjunta Comprobante',
          filePath: [file.path],
          package: Package.whatsapp);
    } else if (file.path.isNotEmpty && verPDF == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfScreen(
                    phone: number,
                    ruta: ruta,
                  )));
    } else {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ha ocurrido un error al generar el documento PDF',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
  }

//--------------------------------------------------------------
//------------------------- initRecorder -----------------------
//--------------------------------------------------------------

  Future initRecorder() async {
    bool permission = await requestPermission();
    if (Platform.isAndroid) {
      if (permission) {
        var directory = await getExternalStorageDirectory();
        newPath = "";
        String convertedDirectoryPath = (directory?.path).toString();
        List<String> paths = convertedDirectoryPath.split("/");
        for (int x = 1; x < convertedDirectoryPath.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/fleetDeliveryApp/Pdf";

        directory = Directory(newPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } else {}
    }
  }

//--------------------------------------------------------------
//------------------------- requestPermission ------------------
//--------------------------------------------------------------

  Future<bool> requestPermission() async {
    bool storagePermission = await Permission.storage.isGranted;
    bool mediaPermission = await Permission.accessMediaLocation.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;

    if (!storagePermission) {
      storagePermission = await Permission.storage.request().isGranted;
    }

    if (!mediaPermission) {
      mediaPermission =
          await Permission.accessMediaLocation.request().isGranted;
    }

    if (!manageExternal) {
      manageExternal =
          await Permission.manageExternalStorage.request().isGranted;
    }

    bool isPermissionGranted =
        storagePermission && mediaPermission && manageExternal;

    if (isPermissionGranted) {
      return true;
    } else {
      return false;
    }
  }

//--------------------------------------------------------------
//------------------------- _getAsigns -------------------------
//--------------------------------------------------------------

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
      response = await ApiHelper.getAutonumericosEjb(request1);
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

    _getEquiposExtras();
  }

//--------------------------------------------------------------
//------------------------- _getEquiposExtras ------------------
//--------------------------------------------------------------

  Future<void> _getEquiposExtras() async {
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

    Response response = Response(isSuccess: false);
    do {
      response = await ApiHelper.getEquiposExtra(
          widget.asignacion.cliente.toString(),
          widget.user.idUser,
          widget.asignacion.proyectomodulo.toString());
      if (response.isSuccess) {
        bandera = true;
        _equiposExtra = response.result;
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

    _getFuncionApp();
  }

//--------------------------------------------------------------
//------------------------- _showAsignacion --------------------
//--------------------------------------------------------------

  Widget _showAsignacion() {
    return Card(
      color: Colors.white,
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
                              Text(
                                  DateFormat('HH:mm').format(DateTime.parse(
                                      _asignacion.hsCumplidaTime.toString())),
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
                              _asignacion.proyectomodulo == 'Cable'
                                  ? const SizedBox(
                                      width: 30,
                                      child: Text("OT: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: const Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    )
                                  : Container(),
                              _asignacion.proyectomodulo == 'Cable'
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

//------------------------------------------------------------
//------------------------- _getComboTelefonos ---------------
//------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboTelefonos() {
    List<String> telefonos = [];

    if (widget.asignacion.hayTelefono) {
      telefonos.add(widget.asignacion.telefono!);
    }

    if (widget.asignacion.hayTelefAlternativo1) {
      telefonos.add(widget.asignacion.telefAlternativo1!);
    }

    if (widget.asignacion.hayTelefAlternativo2) {
      telefonos.add(widget.asignacion.telefAlternativo2!);
    }

    if (widget.asignacion.hayTelefAlternativo3) {
      telefonos.add(widget.asignacion.telefAlternativo3!);
    }

    if (widget.asignacion.hayTelefAlternativo4) {
      telefonos.add(widget.asignacion.telefAlternativo4!);
    }

    var set = telefonos.toSet();
    telefonos = set.toList();

    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija un Teléfono...'),
      value: 'Elija un Teléfono...',
    ));

    for (var telefono in telefonos) {
      list.add(DropdownMenuItem(
        child: Text(telefono),
        value: telefono,
      ));
    }
    return list;
  }

//--------------------------------------------------------
//--------------------- _getFuncionApp ------------------------
//--------------------------------------------------------

  Future<void> _getFuncionApp() async {
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

    Response response3 = Response(isSuccess: false);
    response3 =
        await ApiHelper.getFuncionesApp(widget.asignacion.proyectomodulo!);

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

    _funcionesApp = response3.result;
    _funcionApp = _funcionesApp[0];

    setState(() {
      _showLoader = false;
    });
  }
}
