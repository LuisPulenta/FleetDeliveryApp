import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:fleetdeliveryapp/models/parada.dart';
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
  final List<Parada> paradas;
  final List<Envio> envios;

  const ParadaInfoScreen(
      {required this.user,
      required this.paradaenvio,
      required this.positionUser,
      required this.motivos,
      required this.paradas,
      required this.envios});

  @override
  _ParadaInfoScreenState createState() => _ParadaInfoScreenState();
}

class _ParadaInfoScreenState extends State<ParadaInfoScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;

  int _optionEstado = -1;
  int _optionMotivo = -1;
  int _estado = 0;
  String _optionEstadoError = '';
  bool _optionEstadoShowError = false;
  String _optionMotivoError = '';
  bool _optionMotivoShowError = false;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;

  Parada paradaSelected = Parada(
      idParada: 0,
      idRuta: 0,
      idEnvio: 0,
      tag: 0,
      secuencia: 0,
      leyenda: '',
      latitud: 0,
      longitud: 0,
      iconoPropio: '',
      iDmapa: '',
      distancia: 0,
      tiempo: 0,
      estado: 0,
      fecha: '',
      hora: '',
      idMotivo: 0,
      notaChofer: '',
      nuevoOrden: 0,
      idCabCertificacion: 0,
      idLiquidacionFletero: 0,
      turno: '');

  Envio envioSelected = Envio(
      idEnvio: 0,
      idproveedor: 0,
      agencianr: 0,
      estado: 0,
      envia: '',
      ruta: '',
      ordenid: '',
      fecha: 0,
      hora: '',
      imei: '',
      transporte: '',
      contrato: '',
      titular: '',
      dni: '',
      domicilio: '',
      cp: '',
      latitud: 0,
      longitud: 0,
      autorizado: '',
      observaciones: '',
      idCabCertificacion: 0,
      idRemitoProveedor: 0,
      idSubconUsrWeb: 0,
      fechaAlta: '',
      fechaEnvio: '',
      fechaDistribucion: '',
      entreCalles: '',
      mail: '',
      telefonos: '',
      localidad: '',
      tag: 0,
      provincia: '',
      fechaEntregaCliente: '',
      scaneadoIn: '',
      scaneadoOut: '',
      ingresoDeposito: 0,
      salidaDistribucion: 0,
      idRuta: 0,
      nroSecuencia: 0,
      fechaHoraOptimoCamino: '',
      bultos: 0,
      peso: '',
      alto: '',
      ancho: '',
      largo: '',
      idComprobante: 0,
      enviarMailSegunEstado: '',
      fechaRuta: '',
      ordenIDparaOC: '',
      hashUnico: '',
      bultosPikeados: 0,
      centroDistribucion: '',
      fechaUltimaActualizacion: '',
      volumen: '',
      avonZoneNumber: 0,
      avonSectorNumber: 0,
      avonAccountNumber: '',
      avonCampaignNumber: 0,
      avonCampaignYear: 0,
      domicilioCorregido: '',
      domicilioCorregidoUsando: 0,
      urlFirma: '',
      urlDNI: '',
      ultimoIdMotivo: 0,
      ultimaNotaFletero: '',
      idComprobanteDevolucion: 0,
      turno: '',
      barrioEntrega: '',
      partidoEntrega: '',
      avonDayRoute: 0,
      avonTravelRoute: 0,
      avonSecuenceRoute: 0,
      avonInformarInclusion: 0);

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
            height: 145,
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
                                                : _estado = -1;
                              });
                            },
                            items: _getOptions(),
                            decoration: InputDecoration(
                              hintText: 'Seleccione un Estado...',
                              labelText: '',
                              fillColor: Colors.white,
                              filled: true,
                              errorText: _optionEstadoShowError
                                  ? _optionEstadoError
                                  : null,
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
                  height: 145,
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
                                    errorText: _optionMotivoShowError
                                        ? _optionMotivoError
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
                                    fit: BoxFit.contain,
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

  _save() {
    if (!validateFields()) {
      return;
    }
    _saveRecord();
  }

  bool validateFields() {
    bool isValid = true;

    if (_estado == 0) {
      isValid = false;
      _optionEstadoShowError = true;
      _optionEstadoError = 'Debes seleccionar un Estado';
    } else {
      _optionEstadoShowError = false;
    }

    if (_estado == 7 || _estado == 10) {
      if (_optionMotivo == -1) {
        isValid = false;
        _optionMotivoShowError = true;
        _optionMotivoError = 'Debes seleccionar un Motivo';
      } else {
        _optionMotivoShowError = false;
      }
    }

    setState(() {});

    return isValid;
  }

  void _saveRecord() {
    //***************************************************************
    //******************** Armamos modelo PARADA ********************
    //***************************************************************

    widget.paradas.forEach((element) {
      if (element.idParada == widget.paradaenvio.idParada) {
        paradaSelected = element;
      }
    });

    Map<String, dynamic> requestParada = {
      'idParada': paradaSelected.idParada,
      'idRuta': paradaSelected.idRuta,
      'idEnvio': paradaSelected.idEnvio,
      'tag': paradaSelected.tag,
      'secuencia': paradaSelected.secuencia,
      'leyenda': paradaSelected.leyenda,
      'latitud': paradaSelected.latitud,
      'longitud': paradaSelected.longitud,
      'iconoPropio': paradaSelected.iconoPropio,
      'iDmapa': paradaSelected.iDmapa,
      'distancia': paradaSelected.distancia,
      'tiempo': paradaSelected.tiempo,
      'estado': paradaSelected.estado,
      'fecha': paradaSelected.fecha,
      'hora': paradaSelected.hora,
      'idMotivo': paradaSelected.idMotivo,
      'notaChofer': paradaSelected.notaChofer,
      'nuevoOrden': paradaSelected.nuevoOrden,
      'idCabCertificacion': paradaSelected.idCabCertificacion,
      'idLiquidacionFletero': paradaSelected.idLiquidacionFletero,
      'turno': paradaSelected.turno,
    };

    //***************************************************************
    //******************** Armamos modelo ENVIO ********************
    //***************************************************************

    widget.envios.forEach((element) {
      if (element.idEnvio == widget.paradaenvio.idEnvio) {
        envioSelected = element;
      }
    });

    Map<String, dynamic> requestEnvio = {
      'idEnvio': envioSelected.idEnvio,
      'idproveedor': envioSelected.idproveedor,
      'agencianr': envioSelected.agencianr,
      'estado': envioSelected.estado,
      'envia': envioSelected.envia,
      'ruta': envioSelected.ruta,
      'ordenid': envioSelected.ordenid,
      'fecha': envioSelected.fecha,
      'hora': envioSelected.hora,
      'imei': envioSelected.imei,
      'transporte': envioSelected.transporte,
      'contrato': envioSelected.contrato,
      'titular': envioSelected.titular,
      'dni': envioSelected.dni,
      'domicilio': envioSelected.domicilio,
      'cp': envioSelected.cp,
      'latitud': envioSelected.latitud,
      'longitud': envioSelected.longitud,
      'autorizado': envioSelected.autorizado,
      'observaciones': envioSelected.observaciones,
      'idCabCertificacion': envioSelected.idCabCertificacion,
      'idRemitoProveedor': envioSelected.idRemitoProveedor,
      'idSubconUsrWeb': envioSelected.idSubconUsrWeb,
      'fechaAlta': envioSelected.fechaAlta,
      'fechaEnvio': envioSelected.fechaEnvio,
      'fechaDistribucion': envioSelected.fechaDistribucion,
      'entreCalles': envioSelected.entreCalles,
      'mail': envioSelected.mail,
      'telefonos': envioSelected.telefonos,
      'localidad': envioSelected.localidad,
      'tag': envioSelected.tag,
      'provincia': envioSelected.provincia,
      'fechaEntregaCliente': envioSelected.fechaEntregaCliente,
      'scaneadoIn': envioSelected.scaneadoIn,
      'scaneadoOut': envioSelected.scaneadoOut,
      'ingresoDeposito': envioSelected.ingresoDeposito,
      'salidaDistribucion': envioSelected.salidaDistribucion,
      'idRuta': envioSelected.idRuta,
      'nroSecuencia': envioSelected.nroSecuencia,
      'fechaHoraOptimoCamino': envioSelected.fechaHoraOptimoCamino,
      'bultos': envioSelected.bultos,
      'peso': envioSelected.peso,
      'alto': envioSelected.alto,
      'ancho': envioSelected.ancho,
      'largo': envioSelected.largo,
      'idComprobante': envioSelected.idComprobante,
      'enviarMailSegunEstado': envioSelected.enviarMailSegunEstado,
      'fechaRuta': envioSelected.fechaRuta,
      'ordenIDparaOC': envioSelected.ordenIDparaOC,
      'hashUnico': envioSelected.hashUnico,
      'bultosPikeados': envioSelected.bultosPikeados,
      'centroDistribucion': envioSelected.centroDistribucion,
      'fechaUltimaActualizacion': envioSelected.fechaUltimaActualizacion,
      'volumen': envioSelected.volumen,
      'avonZoneNumber': envioSelected.avonZoneNumber,
      'avonSectorNumber': envioSelected.avonSectorNumber,
      'avonAccountNumber': envioSelected.avonAccountNumber,
      'avonCampaignNumber': envioSelected.avonCampaignNumber,
      'avonCampaignYear': envioSelected.avonCampaignYear,
      'domicilioCorregido': envioSelected.domicilioCorregido,
      'domicilioCorregidoUsando': envioSelected.domicilioCorregidoUsando,
      'urlFirma': envioSelected.urlFirma,
      'urlDNI': envioSelected.urlDNI,
      'ultimoIdMotivo': envioSelected.ultimoIdMotivo,
      'ultimaNotaFletero': envioSelected.ultimaNotaFletero,
      'idComprobanteDevolucion': envioSelected.idComprobanteDevolucion,
      'turno': envioSelected.turno,
      'barrioEntrega': envioSelected.barrioEntrega,
      'partidoEntrega': envioSelected.partidoEntrega,
      'avonDayRoute': envioSelected.avonDayRoute,
      'avonTravelRoute': envioSelected.avonTravelRoute,
      'avonSecuenceRoute': envioSelected.avonSecuenceRoute,
      'avonInformarInclusion': envioSelected.avonInformarInclusion,
    };
  }
}
