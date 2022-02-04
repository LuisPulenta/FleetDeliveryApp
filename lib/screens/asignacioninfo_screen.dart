import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/asign.dart';
import 'package:fleetdeliveryapp/models/asignacion.dart';
import 'package:fleetdeliveryapp/models/asignacion2.dart';
import 'package:fleetdeliveryapp/models/codigocierre.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/take_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AsignacionInfoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;
  final List<CodigoCierre> codigoscierre;

  AsignacionInfoScreen(
      {required this.user,
      required this.asignacion,
      required this.codigoscierre});

  @override
  _AsignacionInfoScreenState createState() => _AsignacionInfoScreenState();
}

class _AsignacionInfoScreenState extends State<AsignacionInfoScreen> {
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

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asignacion = widget.asignacion;
    __codigoscierre = widget.codigoscierre;
    _getAsigns();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC7C7C8),
      appBar: AppBar(
        title: Text('Asignación Info'),
        backgroundColor: Color(0xFF0e4888),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                _showAsignacion(),
                Expanded(child: _showAutonumericos()),
              ],
            ),
          )
        ],
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
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                            SizedBox(
                              height: 1,
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
                                  icon: Icon(Icons.phone),
                                  color: Color(0xFF484848),
                                  onPressed: () =>
                                      launch(_asignacion.telefono!),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                Text("Tel.Alt.1: ",
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
                                  icon: Icon(Icons.phone),
                                  color: Color(0xFF484848),
                                  onPressed: () =>
                                      launch(_asignacion.telefAlternativo1!),
                                ),
                                Text("Tel.Alt.2: ",
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
                                  icon: Icon(Icons.phone),
                                  color: Color(0xFF484848),
                                  onPressed: () =>
                                      launch(_asignacion.telefAlternativo2!),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
                                Text("Tel.Alt.3: ",
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
                                  icon: Icon(Icons.phone),
                                  color: Color(0xFF484848),
                                  onPressed: () =>
                                      launch(_asignacion.telefAlternativo3!),
                                ),
                                Text("Tel.Alt.4: ",
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
                                  icon: Icon(Icons.phone),
                                  color: Color(0xFF484848),
                                  onPressed: () =>
                                      launch(_asignacion.telefAlternativo4!),
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
                  margin: EdgeInsets.only(top: 10),
                  child: !_photoChanged
                      ? Image(
                          image: AssetImage('assets/dni.png'),
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover)
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
                          color: Color(0xFF0e4888),
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
                  margin: EdgeInsets.only(top: 10),
                  child: !_signChanged
                      ? Image(
                          image: AssetImage('assets/firma.png'),
                          width: 80,
                          height: 70,
                          fit: BoxFit.cover)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.file(
                            File(_image.path),
                            height: 80,
                            width: 70,
                            fit: BoxFit.cover,
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
                          color: Color(0xFF0e4888),
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
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done),
                      SizedBox(
                        height: 5,
                      ),
                      Text('SI A TODO'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0e4888),
                    minimumSize: Size(double.infinity, 50),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(
                      height: 5,
                    ),
                    Text('NO A TODO'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffdf281e),
                  minimumSize: Size(double.infinity, 50),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_half),
                    SizedBox(
                      height: 5,
                    ),
                    Text('PARCIAL'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFc41c9c),
                  minimumSize: Size(double.infinity, 50),
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
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Guardar', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0e4888),
                    minimumSize: Size(double.infinity, 50),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Cancelar', style: TextStyle(fontSize: 12)),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffdf281e),
                  minimumSize: Size(double.infinity, 50),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_half),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Otro recupero',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFc41c9c),
                  minimumSize: Size(double.infinity, 50),
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
            color: Color(0xFFFFFFCC),
            shadowColor: Color(0xFF0000FF),
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {}, //=> _goHistory(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              e.marcaModeloId.toString(),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              e.decO1.toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              e.documento.toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 40,
                    )
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
}
