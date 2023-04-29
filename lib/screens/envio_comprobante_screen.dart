import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:intl/intl.dart';
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
      hsCumplidaTime: '');

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
                                                primary: Colors.green,
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
                                                primary: Colors.red,
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

    var a = 1;
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

  //------------------------------------------------------------
  //--------------------- _sendMessage2 ------------------------
  //------------------------------------------------------------

  void _sendMessage2(String message) async {}

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
}
