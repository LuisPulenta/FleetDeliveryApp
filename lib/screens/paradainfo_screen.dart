import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/display_picture_screen.dart';
import 'package:fleetdeliveryapp/screens/paradamap_screen.dart';
import 'package:fleetdeliveryapp/screens/take_picture_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class ParadaInfoScreen extends StatefulWidget {
  final Usuario user;
  final ParadaEnvio paradaenvio;
  final Position positionUser;
  final List<Motivo> motivos;

  const ParadaInfoScreen(
      {required this.user,
      required this.paradaenvio,
      required this.positionUser,
      required this.motivos});

  @override
  _ParadaInfoScreenState createState() => _ParadaInfoScreenState();
}

class _ParadaInfoScreenState extends State<ParadaInfoScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;

  int _optionEstado = -1;
  int _optionMotivo = -1;
  int _estado = 3;
  String _optionIdError = '';
  bool _optionIdShowError = false;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;

  List<String> _options = [
    'Pendiente',
    'Entregado',
    'No entregado',
    'Rechazado',
  ];

  LatLng _center = LatLng(0, 0);
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parada: ${widget.paradaenvio.secuencia.toString()}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _showCliente(),
            _showPaquete(),
            _showDelivery(),
            _showButton(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showCliente() {
    return Column(children: [
      //************ CLIENTE *********
      Card(
        margin: EdgeInsets.all(10),
        color: Color(0xffb3b3b4),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cliente",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              color: Color(0xff8b8cb6),
              width: double.infinity,
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.person),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paradaenvio.titular.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(('DOC: ${widget.paradaenvio.dni.toString()}'))
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.home),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 240,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.paradaenvio.leyenda.toString()}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                            ('Entre: ${widget.paradaenvio.entreCalles.toString()}')),
                        Text(
                          '${widget.paradaenvio.localidad.toString()} (${widget.paradaenvio.cp.toString().replaceAll(" ", "")})',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.map,
                      color: Colors.blue,
                      size: 34,
                    ),
                    onPressed: () => _navegar(widget.paradaenvio),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.phone),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.paradaenvio.telefonos.toString()}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.phone_forwarded,
                      color: Colors.green,
                      size: 34,
                    ),
                    onPressed: () => launch(
                        'tel://${widget.paradaenvio.telefonos.toString()}'),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
              height: 60,
            ),
          ],
        ),
      ),
    ]);
  }

  _showPaquete() {
    return //************ PAQUETE *********
        Card(
      margin: EdgeInsets.all(10),
      color: Color(0xffb3b3b4),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Paquete",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            color: Color(0xff8b8cb6),
            width: double.infinity,
            height: 40,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.receipt_long),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ('N° Remito: ${widget.paradaenvio.idEnvio.toString()}'))
                    ],
                  ),
                ),
              ],
            ),
            color: Color(0xffdadada),
            width: double.infinity,
          ),
          Divider(
            height: 3,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.inventory_2),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ('Cant. de bultos: ${widget.paradaenvio.bultos.toString()}'))
                    ],
                  ),
                ),
              ],
            ),
            color: Color(0xffdadada),
            width: double.infinity,
          ),
          Divider(
            height: 3,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.phone),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          ('Observaciones: ${widget.paradaenvio.proveedor.toString()}')),
                    ],
                  ),
                ),
              ],
            ),
            color: Color(0xffdadada),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  _showDelivery() {
    return //************ DELIVERY *********
        Card(
      margin: EdgeInsets.all(10),
      color: Color(0xffb3b3b4),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Delivery",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            color: Color(0xff8b8cb6),
            width: double.infinity,
            height: 40,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.fact_check),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(('Estado: ')),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: DropdownButtonFormField(
                            value: _optionEstado,
                            onChanged: (option) {
                              setState(() {
                                _optionEstado = option as int;
                                (_optionEstado == 0)
                                    ? _estado = 3
                                    : (_optionEstado == 1)
                                        ? _estado = 4
                                        : (_optionEstado == 2)
                                            ? _estado = 10
                                            : (_optionEstado == 3)
                                                ? _estado = 7
                                                : _estado = 3;
                              });
                            },
                            items: _getOptions(),
                            decoration: InputDecoration(
                              hintText: 'Seleccione un Estado...',
                              labelText: '',
                              fillColor: Colors.white,
                              filled: true,
                              errorText:
                                  _optionIdShowError ? _optionIdError : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: Color(0xffdadada),
            width: double.infinity,
          ),
          (_estado == 7 || _estado == 10)
              ? Divider(
                  height: 3,
                )
              : Container(),
          (_estado == 7 || _estado == 10)
              ? Container(
                  padding: EdgeInsets.all(10),
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.fact_check),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(('Motivo: ')),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                  value: _optionMotivo,
                                  onChanged: (option) {
                                    setState(() {
                                      _optionMotivo = option as int;
                                    });
                                  },
                                  items: _getOptions2(),
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione un Motivo...',
                                    labelText: '',
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorText: _optionIdShowError
                                        ? _optionIdError
                                        : null,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  color: Color(0xffdadada),
                  width: double.infinity,
                )
              : Container(),
          Divider(
            height: 3,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.format_list_bulleted),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(('Notas: ')),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '',
                              labelText: 'Puede escribir Notas aquí...',
                              errorText: _observacionesShowError
                                  ? _observacionesError
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onChanged: (value) {
                            _observaciones = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: Color(0xffdadada),
            width: double.infinity,
          ),
          Divider(
            height: 3,
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.badge),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(('Documentación: ')),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.fiber_manual_record,
                              size: 12,
                            ),
                            Text(('   Tomar foto')),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.photo_camera,
                                color: Colors.blue,
                                size: 34,
                              ),
                              onPressed: () => _goAddPhoto(),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            !_photoChanged
                                ? Image(
                                    image: AssetImage('assets/noimage.png'),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover)
                                : Image.file(
                                    File(_image.path),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: Color(0xffdadada),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _showButton() {
    return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF120E43),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  _save();
                },
              ),
            ),
          ],
        ));
  }

  _navegar(ParadaEnvio paradaenvio) {
    _center = LatLng(
        paradaenvio.latitud!.toDouble(), paradaenvio.longitud!.toDouble());
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(paradaenvio.secuencia.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: paradaenvio.titular.toString(),
        snippet: paradaenvio.domicilio.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParadaMapScreen(
                  user: widget.user,
                  positionUser: widget.positionUser,
                  paradaenvio: paradaenvio,
                  markers: _markers,
                )));
  }

  List<DropdownMenuItem<int>> _getOptions() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Seleccione un Estado...'),
      value: -1,
    ));
    int nro = 0;
    _options.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element),
        value: nro,
      ));
      nro++;
    });
    return list;
  }

  List<DropdownMenuItem<int>> _getOptions2() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Seleccione un Motivo...'),
      value: -1,
    ));
    int nro = 0;
    widget.motivos.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.motivo.toString()),
        value: element.id,
      ));
      nro++;
    });
    return list;
  }

  void _save() {}

  Future _takePicture() async {
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

  void _goAddPhoto() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿De donde deseas obtener la imagen?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'cancel', label: 'Cancelar'),
          AlertDialogAction(key: 'camera', label: 'Cámara'),
          AlertDialogAction(key: 'gallery', label: 'Galería'),
        ]);

    if (response == 'cancel') {
      return;
    }

    if (response == 'camera') {
      await _takePicture();
    } else {
      await _selectPicture();
    }

    if (_photoChanged) {
      //_addPicture();
    }
  }

  Future<Null> _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _image2 = await _picker.pickImage(source: ImageSource.gallery);

    if (_image2 != null) {
      setState(() {
        _photoChanged = true;
        _image = _image2;
      });
    }
  }
}
