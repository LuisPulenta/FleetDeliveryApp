import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class MisDatosScreen extends StatefulWidget {
  final Usuario user;
  const MisDatosScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MisDatosScreen> createState() => _MisDatosScreenState();
}

class _MisDatosScreenState extends State<MisDatosScreen> {
  //-----------------------------------------------------------------------------
  //---------------------------- Variables --------------------------------------
  //-----------------------------------------------------------------------------

  bool _showLoader = false;

  bool _photoChangedDNIFrente = false;
  bool _photoChangedDNIDorso = false;
  bool _photoChangedCarnetConducir = false;
  bool _photoChangedVTV = false;
  bool _photoChangedObleaGas = false;
  bool _photoChangedPoliza = false;
  bool _photoChangedCedula = false;
  bool _photoChangedAntecedentes = false;

  late XFile _imageDNIFrente;
  late XFile _imageDNIDorso;
  late XFile _imageCarnetConducir;
  late XFile _imageVTV;
  late XFile _imageObleaGas;
  int cualFoto = 0;

  List<int> imageBytesPdfPoliza = [];
  List<int> imageBytesPdfCedula = [];
  List<int> imageBytesPdfAntecedentes = [];

  String base64imagePoliza = '';
  String base64imageCedula = '';
  String base64imageAntecedentes = '';
  String namePdfPoliza = '';
  String namePdfCedula = '';
  String namePdfAntecedentes = '';

  bool _gas = false;

  DateTime? fechaVencCarnetConducir;
  DateTime? fechaVencVTV;
  DateTime? fechaVencObleaGNC;
  DateTime? fechaVencPoliza;

  String _numcha = '';
  String _numchaError = '';
  bool _numchaShowError = false;
  final TextEditingController _numchaController = TextEditingController();

  String _modelo = '';
  String _modeloError = '';
  bool _modeloShowError = false;
  final TextEditingController _modeloController = TextEditingController();

  String _marca = '';
  String _marcaError = '';
  bool _marcaShowError = false;
  final TextEditingController _marcaController = TextEditingController();

  late SubContratistasUsrVehiculo _misDatos;

  bool editMode = false;

  String _numpolizaseguro = '';
  String _numpolizaseguroError = '';
  bool _numpolizaseguroShowError = false;
  final TextEditingController _numpolizaseguroController =
      TextEditingController();

  String _compania = '';
  String _companiaError = '';
  bool _companiaShowError = false;
  final TextEditingController _companiaController = TextEditingController();

  //-----------------------------------------------------------------------------
  //--------------------------- initState ---------------------------------------
  //-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getMisDatos();
  }

  //-----------------------------------------------------------------------------
  //---------------------------- Pantalla ---------------------------------------
  //-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7C7C8),
      appBar: AppBar(
        title: const Text('Mis Datos'),
        centerTitle: true,
        backgroundColor: const Color(0xFF282886),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                const Text(
                  'DNI Frente',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _showDNIFrente(),
                const Divider(color: Colors.black),
                const Text(
                  'DNI Dorso',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _showDNIDorso(),
                const Divider(color: Colors.black),
                const Text(
                  'Carnet de Conducir',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _showCarnetConducir(),
                _showFechaCarnetConducir(),
                const Divider(color: Colors.black),
                const Text(
                  'Vehículo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(flex: 3, child: _showNumcha()),
                    Expanded(flex: 2, child: _showModelo()),
                  ],
                ),
                _showMarca(),
                const SizedBox(height: 10),
                const Text(
                  'VTV:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _showVTV(),
                _showFechaVencVTV(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: SwitchListTile.adaptive(
                    title: const Text(
                      "Tiene GNC:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    activeColor: const Color(0xFF282886),
                    value: _gas,
                    onChanged: (value) {
                      _gas = value;
                      setState(() {});
                    },
                  ),
                ),
                _showFechaVencObleaGNC(),
                const Text(
                  'Oblea Gas:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _showObleaGas(),
                const Divider(color: Colors.black),
                const Text(
                  'Seguro Vehículo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: _showCompania()),
                    Expanded(flex: 1, child: _showNroPoliza()),
                  ],
                ),
                _showFechaVencSeguro(),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 50),
                            backgroundColor: base64imagePoliza != ''
                                ? Colors.red
                                : const Color(0xFF282886),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            if (base64imagePoliza != '') {
                              base64imagePoliza = '';
                              namePdfPoliza = '';
                              setState(() {});
                            } else {
                              _loadPdf(1);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.picture_as_pdf),
                              const SizedBox(width: 15),
                              Text(
                                (base64imagePoliza == '')
                                    ? 'Cargar Póliza'
                                    : 'Borrar',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(namePdfPoliza),
                        editMode &&
                                _misDatos.linkPolizaSeguro.length > 1 &&
                                namePdfPoliza == ''
                            ? Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      200,
                                      14,
                                      241,
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!await launch(
                                      _misDatos.linkPolizaSeguroFullPath,
                                    )) {
                                      throw 'No se puede conectar al Servidor';
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Icon(Icons.picture_as_pdf),
                                      Text('Póliza guardada'),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.black),
                const Text(
                  'Cédula',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 50),
                            backgroundColor: base64imageCedula != ''
                                ? Colors.red
                                : const Color(0xFF282886),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            if (base64imageCedula != '') {
                              base64imageCedula = '';
                              namePdfCedula = '';
                              setState(() {});
                            } else {
                              _loadPdf(2);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.picture_as_pdf),
                              const SizedBox(width: 15),
                              Text(
                                (base64imageCedula == '')
                                    ? 'Cargar Cédula'
                                    : 'Borrar',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(namePdfCedula),
                        editMode &&
                                _misDatos.linkCedula.length > 1 &&
                                namePdfCedula == ''
                            ? Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      200,
                                      14,
                                      241,
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!await launch(
                                      _misDatos.linkCedulaFullPath,
                                    )) {
                                      throw 'No se puede conectar al Servidor';
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Icon(Icons.picture_as_pdf),
                                      Text('Cédula guardada'),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.black),
                const Text(
                  'Antecedentes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 50),
                            backgroundColor: base64imageAntecedentes != ''
                                ? Colors.red
                                : const Color(0xFF282886),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            if (base64imageAntecedentes != '') {
                              base64imageAntecedentes = '';
                              namePdfAntecedentes = '';
                              setState(() {});
                            } else {
                              _loadPdf(3);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.picture_as_pdf),
                              const SizedBox(width: 15),
                              Text(
                                (base64imageAntecedentes == '')
                                    ? 'Cargar Anteced.'
                                    : 'Borrar',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(namePdfAntecedentes),
                        editMode &&
                                _misDatos.linkAntecedentes.length > 1 &&
                                namePdfAntecedentes == ''
                            ? Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      200,
                                      14,
                                      241,
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!await launch(
                                      _misDatos.linkAntecedentesFullPath,
                                    )) {
                                      throw 'No se puede conectar al Servidor';
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Icon(Icons.picture_as_pdf),
                                      Text('Anteced. guardados'),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.black),
                _showButtonGuardar(),
                const SizedBox(height: 15),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showDNIFrente ----------------------------
  //-----------------------------------------------------------------

  Widget _showDNIFrente() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedDNIFrente
                        ? Center(
                            child: !editMode
                                ? const Image(
                                    image: AssetImage('assets/dni.png'),
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _misDatos.dniFrenteFullPath,
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageDNIFrente.path),
                              width: 200,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 1;
                        _takePicture();
                      },
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
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 1;
                        _selectPicture();
                      },
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showDNIDorso -----------------------------
  //-----------------------------------------------------------------

  Widget _showDNIDorso() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedDNIDorso
                        ? Center(
                            child: !editMode
                                ? const Image(
                                    image: AssetImage('assets/dni.png'),
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _misDatos.dniDorsoFullPath,
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageDNIDorso.path),
                              width: 200,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 2;
                        _takePicture();
                      },
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
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 2;
                        _selectPicture();
                      },
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCarnetConducir -----------------------
  //-----------------------------------------------------------------

  Widget _showCarnetConducir() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedCarnetConducir
                        ? Center(
                            child: !editMode
                                ? const Image(
                                    image: AssetImage('assets/dni.png'),
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _misDatos.carnetConducirFullPath,
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageCarnetConducir.path),
                              width: 200,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 3;
                        _takePicture();
                      },
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
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 3;
                        _selectPicture();
                      },
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showVTV ----------------------------------
  //-----------------------------------------------------------------

  Widget _showVTV() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedVTV
                        ? Center(
                            child: !editMode
                                ? const Image(
                                    image: AssetImage('assets/noimage.png'),
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _misDatos.linkVtvFullPath,
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageVTV.path),
                              width: 200,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 4;
                        _takePicture();
                      },
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
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 4;
                        _selectPicture();
                      },
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showObleaGas -----------------------------
  //-----------------------------------------------------------------

  Widget _showObleaGas() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedObleaGas
                        ? Center(
                            child: !editMode
                                ? const Image(
                                    image: AssetImage('assets/noimage.png'),
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    _misDatos.linkObleaGasFullPath,
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageObleaGas.path),
                              width: 200,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 5;
                        _takePicture();
                      },
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
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        cualFoto = 5;
                        _selectPicture();
                      },
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNumcha -------------------------------
  //-----------------------------------------------------------------

  Widget _showNumcha() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _numchaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Patente',
          labelText: 'Patente',
          errorText: _numchaShowError ? _numchaError : null,
          suffixIcon: const Icon(Icons.abc),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numcha = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCompania -----------------------------
  //-----------------------------------------------------------------

  Widget _showCompania() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _companiaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Compañía',
          labelText: 'Compañía',
          errorText: _companiaShowError ? _companiaError : null,
          suffixIcon: const Icon(Icons.abc),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _compania = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNroPoliza ----------------------------
  //-----------------------------------------------------------------

  Widget _showNroPoliza() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _numpolizaseguroController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'N° Póliza',
          labelText: 'N° Póliza',
          errorText: _numpolizaseguroShowError ? _numpolizaseguroError : null,
          suffixIcon: const Icon(Icons.numbers),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numpolizaseguro = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showModelo -------------------------------
  //-----------------------------------------------------------------

  Widget _showModelo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _modeloController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Modelo',
          labelText: 'Modelo',
          errorText: _modeloShowError ? _modeloError : null,
          suffixIcon: const Icon(Icons.numbers),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _modelo = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showMarca --------------------------------
  //-----------------------------------------------------------------

  Widget _showMarca() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _marcaController,
        maxLines: 2,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Marca',
          labelText: 'Marca',
          errorText: _marcaShowError ? _marcaError : null,
          suffixIcon: const Icon(Icons.notes),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _marca = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _takePicture ------------------------------
  //-----------------------------------------------------------------

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
      ],
    );
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
          builder: (context) => TakePictureScreen(camera: firstCamera),
        ),
      );
      if (response != null) {
        setState(() {
          if (cualFoto == 1) {
            _photoChangedDNIFrente = true;
            _imageDNIFrente = response.result;
          }
          if (cualFoto == 2) {
            _photoChangedDNIDorso = true;
            _imageDNIDorso = response.result;
          }
          if (cualFoto == 3) {
            _photoChangedCarnetConducir = true;
            _imageCarnetConducir = response.result;
          }
          if (cualFoto == 4) {
            _photoChangedVTV = true;
            _imageVTV = response.result;
          }
          if (cualFoto == 5) {
            _photoChangedObleaGas = true;
            _imageObleaGas = response.result;
          }
        });
        cualFoto = 0;
      }
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _selectPicture ----------------------------
  //-----------------------------------------------------------------

  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (cualFoto == 1) {
          _photoChangedDNIFrente = true;
          _imageDNIFrente = image;
        }
        if (cualFoto == 2) {
          _photoChangedDNIDorso = true;
          _imageDNIDorso = image;
        }
        if (cualFoto == 3) {
          _photoChangedCarnetConducir = true;
          _imageCarnetConducir = image;
        }
        if (cualFoto == 4) {
          _photoChangedVTV = true;
          _imageVTV = image;
        }
        if (cualFoto == 5) {
          _photoChangedObleaGas = true;
          _imageObleaGas = image;
        }
      });
      cualFoto = 0;
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaCarnetConducir ------------------
  //-----------------------------------------------------------------

  Widget _showFechaCarnetConducir() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 30,
                      child: const Text(
                        'Fecha Venc. Carnet:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 30,
                        child: Text(
                          fechaVencCarnetConducir != null
                              ? "    ${fechaVencCarnetConducir!.day}/${fechaVencCarnetConducir!.month}/${fechaVencCarnetConducir!.year}"
                              : "",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF282886),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => fechaVencCarnet(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------
  //------------------------------ fechaVencCarnet-----------------------------
  //---------------------------------------------------------------------------

  fechaVencCarnet() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != fechaVencCarnetConducir) {
      setState(() {
        fechaVencCarnetConducir = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaVencVTV -------------------------
  //-----------------------------------------------------------------

  Widget _showFechaVencVTV() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 30,
                      child: const Text(
                        'Fecha Venc. VTV:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 30,
                        child: Text(
                          fechaVencVTV != null
                              ? "    ${fechaVencVTV!.day}/${fechaVencVTV!.month}/${fechaVencVTV!.year}"
                              : "",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF282886),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => fechaVVTV(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------------------
  //------------------------------ fechaVencVTV-----------------------------
  //------------------------------------------------------------------------

  fechaVVTV() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != fechaVencVTV) {
      setState(() {
        fechaVencVTV = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaVencObleaGNC --------------------
  //-----------------------------------------------------------------

  Widget _showFechaVencObleaGNC() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 150,
                        height: 30,
                        child: const Text(
                          'Fecha Venc. Oblea:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        width: 80,
                        height: 30,
                        child: Text(
                          fechaVencObleaGNC != null
                              ? "    ${fechaVencObleaGNC!.day}/${fechaVencObleaGNC!.month}/${fechaVencObleaGNC!.year}"
                              : "",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF282886),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => fechaVGNC(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------
  //------------------------------ fechaVGNC-----------------------------------
  //---------------------------------------------------------------------------

  fechaVGNC() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != fechaVencObleaGNC) {
      setState(() {
        fechaVencObleaGNC = selected;
      });
    }
  }

  //----------------------------------------------------------
  //--------------------- _showFechaVencSeguro ---------------
  //----------------------------------------------------------

  Widget _showFechaVencSeguro() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 150,
                        height: 30,
                        child: const Text(
                          'Fecha Venc. Seguro:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        width: 80,
                        height: 30,
                        child: Text(
                          fechaVencPoliza != null
                              ? "    ${fechaVencPoliza!.day}/${fechaVencPoliza!.month}/${fechaVencPoliza!.year}"
                              : "",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF282886),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => fechaSeguro(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------
  //------------------------------ fechaSeguro---------------------------------
  //---------------------------------------------------------------------------

  fechaSeguro() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != fechaVencPoliza) {
      setState(() {
        fechaVencPoliza = selected;
      });
    }
  }

  //----------------------------------------------------------
  //--------------------- _showButtonGuardar -----------------
  //----------------------------------------------------------

  Widget _showButtonGuardar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF282886),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 20),
                  Text('Guardar'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //-------------------------------- _save --------------------------------------
  //-----------------------------------------------------------------------------

  _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

  //-----------------------------------------------------------------------------
  //-------------------------------- validateFields -----------------------------
  //-----------------------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (!_photoChangedDNIFrente && !editMode) {
      isValid = false;
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
                Text('Debe cargar Frente del DNI'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    if (!_photoChangedDNIDorso && !editMode) {
      isValid = false;
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
                Text('Debe cargar Dorso del DNI'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    if (!_photoChangedCarnetConducir && !editMode) {
      isValid = false;
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
                Text('Debe cargar Carnet de Conducir'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    if (_numcha == "") {
      isValid = false;
      _numchaShowError = true;
      _numchaError = 'Debe ingresar una Patente';
    } else {
      if (_numcha.length > 7) {
        isValid = false;
        _numchaShowError = true;
        _numchaError = 'Máximo 7 caracteres';
      } else {
        _numchaShowError = false;
      }
    }

    if (_modelo.isEmpty) {
      isValid = false;
      _modeloShowError = true;
      _modeloError = 'Ingrese año';
    } else {
      if (_modelo.length > 4) {
        isValid = false;
        _modeloShowError = true;
        _modeloError = 'Máx 4 carac.';
      } else {
        _modeloShowError = false;
      }
    }

    if (_marca.isEmpty) {
      isValid = false;
      _marcaShowError = true;
      _marcaError = 'Debe ingresar la marca del vehículo';
    } else {
      if (_marca.length > 30) {
        isValid = false;
        _marcaShowError = true;
        _marcaError = 'La Marca no puede tener más de 30 caracteres';
      } else {
        _marcaShowError = false;
      }
    }

    if (_compania.isEmpty) {
      isValid = false;
      _companiaShowError = true;
      _companiaError = 'Debe ingresar la Compañía de Seguro';
    } else {
      if (_compania.length > 30) {
        isValid = false;
        _companiaShowError = true;
        _companiaError = 'La Compañía no puede tener más de 30 caracteres';
      } else {
        _companiaShowError = false;
      }
    }

    if (_numpolizaseguro.isEmpty) {
      isValid = false;
      _numpolizaseguroShowError = true;
      _numpolizaseguroError = 'Debe ingresar el N° de Póliza';
    } else {
      if (_numpolizaseguro.length > 30) {
        isValid = false;
        _numpolizaseguroShowError = true;
        _numpolizaseguroError =
            'El N° de Póliza no puede tener más de 30 caracteres';
      } else {
        _numpolizaseguroShowError = false;
      }
    }

    if (fechaVencCarnetConducir == null) {
      isValid = false;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text(
                  'Debe ingresar Fecha de Vencimiento del Carnet de Conducir.',
                ),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      setState(() {});
    }

    if (fechaVencVTV == null) {
      isValid = false;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text('Debe ingresar Fecha de Vencimiento del VTV.'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      setState(() {});
    }

    if (fechaVencObleaGNC == null && _gas) {
      isValid = false;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text('Debe ingresar Fecha de Vencimiento de la Oblea de GNC.'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      setState(() {});
    }

    if (fechaVencPoliza == null) {
      isValid = false;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text('Debe ingresar Fecha de Vencimiento del Seguro.'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      setState(() {});
    }

    setState(() {});

    return isValid;
  }

  //--------------------------------------------------------------------------
  //---------------------------- _addRecord ----------------------------------
  //--------------------------------------------------------------------------

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
        'Error',
        "Verifica que estés conectado a Internet",
        'Aceptar',
      );
      return;
    }

    String base64imageDNIFrente = "";
    String base64imageDNIDorso = "";
    String base64imageCarnetConducir = "";
    String base64imageVTV = "";
    String base64imageObleaGas = "";
    String base64imagePolizaParaSubir = "";
    String base64imageCedulaParaSubir = "";
    String base64imageAntecedentesParaSubir = "";

    if (_photoChangedDNIFrente) {
      List<int> imageBytesDNIFrente = await _imageDNIFrente.readAsBytes();
      base64imageDNIFrente = base64Encode(imageBytesDNIFrente);
    }

    if (_photoChangedDNIDorso) {
      List<int> imageBytesDNIDorso = await _imageDNIDorso.readAsBytes();
      base64imageDNIDorso = base64Encode(imageBytesDNIDorso);
    }

    if (_photoChangedCarnetConducir) {
      List<int> imageBytesCarnetConducir = await _imageCarnetConducir
          .readAsBytes();
      base64imageCarnetConducir = base64Encode(imageBytesCarnetConducir);
    }

    if (_photoChangedVTV) {
      List<int> imageBytesVTV = await _imageVTV.readAsBytes();
      base64imageVTV = base64Encode(imageBytesVTV);
    }

    if (_photoChangedObleaGas) {
      List<int> imageBytesObleaGas = await _imageObleaGas.readAsBytes();
      base64imageObleaGas = base64Encode(imageBytesObleaGas);
    }

    if (base64imagePoliza != '') {
      base64imagePolizaParaSubir = base64imagePoliza;
    }

    if (base64imageCedula != '') {
      base64imageCedulaParaSubir = base64imageCedula;
    }

    if (base64imageAntecedentes != '') {
      base64imageAntecedentesParaSubir = base64imageAntecedentes;
    }

    String ahora = DateTime.now().toString();

    Map<String, dynamic> request = {
      'ID': editMode ? _misDatos.id : 0,
      'IdUser': widget.user.idUser,
      'DNIFrente': '',
      'DNIDorso': '',
      'CarnetConducir': '',
      'FechaVencCarnet': fechaVencCarnetConducir.toString(),
      'Dominio': _numcha.toUpperCase(),
      'ModeloAnio': _modelo,
      'Marca': _marca,
      'FechaVencVTV': fechaVencVTV.toString(),
      'Gas': _gas ? "SI" : "NO",
      'FechaObleaGas': fechaVencObleaGNC != null
          ? fechaVencObleaGNC.toString()
          : '',
      'UltimaActualizacion': ahora,
      'DNIFrenteImageArray': base64imageDNIFrente,
      'DNIDorsoImageArray': base64imageDNIDorso,
      'CarnetConducirImageArray': base64imageCarnetConducir,
      'NroPolizaSeguro': _numpolizaseguro,
      'FechaVencPoliza': fechaVencPoliza != null
          ? fechaVencPoliza.toString()
          : '',
      'Compania': _compania,
      'LinkVtvImageArray': base64imageVTV,
      'LinkObleaGasImageArray': base64imageObleaGas,
      'LinkPolizaSeguroImageArray': base64imagePolizaParaSubir,
      'LinkCedulaImageArray': base64imageCedulaParaSubir,
      'LinkAntecedentesImageArray': base64imageAntecedentesParaSubir,
    };

    if (editMode == false) {
      Response response = await ApiHelper.post(
        '/api/SubContratistasUsrVehiculos',
        request,
      );

      setState(() {
        _showLoader = false;
      });

      if (!response.isSuccess) {
        showMyDialog('Aviso', response.message, 'Aceptar');
        return;
      }
    }

    if (editMode == true) {
      Response response = await ApiHelper.put(
        '/api/SubContratistasUsrVehiculos/',
        _misDatos.id.toString(),
        request,
      );

      setState(() {
        _showLoader = false;
      });

      if (!response.isSuccess) {
        showMyDialog('Aviso', response.message, 'Aceptar');
        return;
      }
    }

    Navigator.pop(context, 'yes');
  }

  //----------------------------------------------------------------------------
  //--------------------------- _getMisDatos -----------------------------------
  //----------------------------------------------------------------------------

  Future<void> _getMisDatos() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
        'Error',
        "Verifica que estés conectado a Internet",
        'Aceptar',
      );
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getMisDatos(widget.user.idUser.toString());

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      showMyDialog('Error', response.message, 'Aceptar');
      return;
    }

    setState(() {
      _misDatos = response.result;
    });

    if (_misDatos.idUser != 0) {
      editMode = true;
      _loadFields();
    }
  }

  //-----------------------------------------------------------------------------
  //-------------------- _loadFields --------------------------------------------
  //-----------------------------------------------------------------------------

  void _loadFields() async {
    _numcha = _misDatos.dominio;
    _numchaController.text = _misDatos.dominio;

    _modelo = _misDatos.modeloAnio.toString();
    _modeloController.text = _misDatos.modeloAnio.toString();

    _marca = _misDatos.marca;
    _marcaController.text = _misDatos.marca;

    _gas = _misDatos.gas == 'SI' ? true : false;

    fechaVencCarnetConducir = _misDatos.fechaVencCarnet;
    fechaVencVTV = _misDatos.fechaVencVtv;
    fechaVencObleaGNC = _misDatos.fechaObleaGas != null
        ? DateTime.parse(_misDatos.fechaObleaGas!)
        : null;
    fechaVencPoliza = _misDatos.fechaVencPoliza;

    _compania = _misDatos.compania;
    _companiaController.text = _misDatos.compania;

    _numpolizaseguro = _misDatos.nroPolizaSeguro;
    _numpolizaseguroController.text = _misDatos.nroPolizaSeguro;

    setState(() {});
  }

  //-----------------------------------------------------------------------
  //-------------------- _loadPdf -----------------------------------------
  //-----------------------------------------------------------------------

  Future<void> _loadPdf(int opcion) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      if (opcion == 1) {
        imageBytesPdfPoliza = fileBytes!.buffer.asUint8List();
        base64imagePoliza = base64Encode(imageBytesPdfPoliza);
        namePdfPoliza = fileName;
      }
      if (opcion == 2) {
        imageBytesPdfCedula = fileBytes!.buffer.asUint8List();
        base64imageCedula = base64Encode(imageBytesPdfCedula);
        namePdfCedula = fileName;
      }
      if (opcion == 3) {
        imageBytesPdfAntecedentes = fileBytes!.buffer.asUint8List();
        base64imageAntecedentes = base64Encode(imageBytesPdfAntecedentes);
        namePdfAntecedentes = fileName;
      }
      setState(() {});
    }
  }
}
