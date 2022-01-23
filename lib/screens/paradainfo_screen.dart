import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:fleetdeliveryapp/helpers/dbparadasenvios_helper.dart';
import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:fleetdeliveryapp/models/option.dart';
import 'package:fleetdeliveryapp/models/parada.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
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
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _photoChanged = false;
  late XFile _image;

  int _optionEstado = 0;
  String _optionEstadoError = '';
  bool _optionEstadoShowError = false;
  List<Option> _listoptions = [];

  int _optionMotivo = 0;
  int _estado = 0;

  String _optionMotivoError = '';
  bool _optionMotivoShowError = false;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();
  String _motivodesc = '';

  List<DropdownMenuItem<int>> _items = [];

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

  LatLng _center = LatLng(0, 0);
  final Set<Marker> _markers = {};

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _getlistOptions();
    setState(() {});
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

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

//-------------------------------------------------------------------------
//-------------------------- METODO SHOWCLIENTE ---------------------------
//-------------------------------------------------------------------------

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

//-------------------------------------------------------------------------
//-------------------------- METODO SHOWPAQUETE ---------------------------
//-------------------------------------------------------------------------
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

//-------------------------------------------------------------------------
//-------------------------- METODO SHOWDELIVERY --------------------------
//-------------------------------------------------------------------------

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
                            items: _items,
                            value: _optionEstado,
                            onChanged: (option) {
                              setState(() {
                                _optionEstado = option as int;
                                _estado = option;
                              });
                            },
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
          (_optionEstado == 10 || _optionEstado == 7)
              ? Divider(
                  height: 3,
                )
              : Container(),
          (_optionEstado == 10 || _optionEstado == 7)
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
                                      widget.motivos.forEach((motivo) {
                                        if (motivo.id == _optionMotivo) {
                                          _motivodesc =
                                              motivo.motivo.toString();
                                        }
                                      });
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
                          controller: _observacionesController,
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

//-------------------------------------------------------------------------
//-------------------------- METODO SHOWBUTTON ----------------------------
//-------------------------------------------------------------------------

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
                onPressed: (widget.paradaenvio.estado == 3) ? _save : null,
              ),
            ),
          ],
        ));
  }

//-------------------------------------------------------------------------
//-------------------------- METODO NAVEGAR -------------------------------
//-------------------------------------------------------------------------

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

//*****************************************************************************
//************************** METODO GETOPTIONS2 *******************************
//*****************************************************************************

  List<DropdownMenuItem<int>> _getOptions2() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Seleccione un Motivo...'),
      value: 0,
    ));

    widget.motivos.forEach((element) {
      list.add(DropdownMenuItem(
        child: Text(element.motivo.toString()),
        value: element.id,
      ));
    });
    return list;
  }

//*****************************************************************************
//************************** METODO TAKEPICTURE *******************************
//*****************************************************************************

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

//*****************************************************************************
//************************** METODO GOADDFOTO *********************************
//*****************************************************************************

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

//*****************************************************************************
//************************** METODO SELECTPICTURE *****************************
//*****************************************************************************

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

//*****************************************************************************
//************************** METODO SAVE **************************************
//*****************************************************************************

  _save() async {
    if (!validateFields()) {
      return;
    }
    await _saveRecord();
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

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
      if (_optionMotivo == 0) {
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

//*****************************************************************************
//************************** METODO SAVERECORD ********************************
//*****************************************************************************

  Future<void> _saveRecord() async {
    await _guardaParadaEnBDLocal();
    Navigator.pop(context, 'yes');
  }

//*****************************************************************************
//************************** METODO GUARDARPARADAENBDLOCAL ********************
//*****************************************************************************

  Future<void> _guardaParadaEnBDLocal() async {
    widget.paradas.forEach((element) {
      if (element.idParada == widget.paradaenvio.idParada) {
        paradaSelected = element;
      }
    });

    String base64Image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    ParadaEnvio requestParadaEnvio = ParadaEnvio(
        idParada: widget.paradaenvio.idParada,
        idRuta: widget.paradaenvio.idRuta,
        idEnvio: widget.paradaenvio.idEnvio,
        secuencia: widget.paradaenvio.secuencia,
        leyenda: widget.paradaenvio.leyenda,
        latitud: widget.paradaenvio.latitud,
        longitud: widget.paradaenvio.longitud,
        idproveedor: widget.paradaenvio.idproveedor,
        estado: _estado,
        ordenid: widget.paradaenvio.ordenid,
        titular: widget.paradaenvio.titular,
        dni: widget.paradaenvio.dni,
        domicilio: widget.paradaenvio.domicilio,
        cp: widget.paradaenvio.cp,
        entreCalles: widget.paradaenvio.entreCalles,
        telefonos: widget.paradaenvio.telefonos,
        localidad: widget.paradaenvio.localidad,
        bultos: widget.paradaenvio.bultos,
        proveedor: widget.paradaenvio.proveedor,
        motivo: _optionMotivo,
        motivodesc: _motivodesc,
        notas: _observaciones,
        enviado: 0,
        fecha: DateTime.now().toString(),
        imageArray: base64Image);

    await DBParadasEnvios.insertParadaEnvio(requestParadaEnvio);
    _showSnackbar();
  }

//*****************************************************************************
//************************** METODO GETLISTOPTIONS ****************************
//*****************************************************************************

  void _getlistOptions() {
    _items = [];
    _listoptions = [];

    Option opt1 = Option(id: 3, description: 'Pendiente');
    Option opt2 = Option(id: 4, description: 'Entregado');
    Option opt3 = Option(id: 10, description: 'No Entregado');
    Option opt4 = Option(id: 7, description: 'Rechazado');
    _listoptions.add(opt1);
    _listoptions.add(opt2);
    _listoptions.add(opt3);
    _listoptions.add(opt4);

    _loadFieldValues();
  }

//*****************************************************************************
//************************** METODO LOADFIELDVALUES ***************************
//*****************************************************************************

  void _loadFieldValues() {
    _estado = widget.paradaenvio.estado!;
    _optionMotivo = widget.paradaenvio.motivo!;
    _observaciones = widget.paradaenvio.notas.toString();
    _observacionesController.text = _observaciones;
    _optionEstado = widget.paradaenvio.estado!;

    _getComboEstados();
  }

//*****************************************************************************
//************************** METODO GETCOMBOESTADOS ***************************
//*****************************************************************************

  List<DropdownMenuItem<int>> _getComboEstados() {
    _items = [];

    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Seleccione un Estado...'),
      value: 0,
    ));

    _listoptions.forEach((_listoption) {
      list.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.id,
      ));
    });

    _items = list;

    return list;
  }

//*****************************************************************************
//************************** METODO SHOWSNACKBAR ******************************
//*****************************************************************************

  void _showSnackbar() {
    SnackBar snackbar = SnackBar(
      content: Text("Estado de Parada grabada con éxito"),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
