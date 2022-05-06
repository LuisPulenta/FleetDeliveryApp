import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/asignacion2.dart';
import 'package:fleetdeliveryapp/models/controlesequivalencia.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class OtroRecuperoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;
  final int idgaos;
  final List<ControlesEquivalencia> controlesEquivalencia;

  const OtroRecuperoScreen(
      {required this.user,
      required this.asignacion,
      required this.idgaos,
      required this.controlesEquivalencia});

  @override
  State<OtroRecuperoScreen> createState() => _OtroRecuperoScreenState();
}

class _OtroRecuperoScreenState extends State<OtroRecuperoScreen> {
  String _coddeco1OtroRecupero = 'Elija un Modelo...';
  String _coddeco1OtroRecuperoError = '';
  bool _coddeco1OtroRecuperoShowError = false;
  TextEditingController _coddeco1OtroRecuperoController =
      TextEditingController();

  String _nroserieextraOtroRecupero = '';
  String _nroserieextraOtroRecuperoError = '';
  bool _nroserieextraOtroRecuperoShowError = false;
  TextEditingController _nroserieextraOtroRecuperoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFbfd4e7),
      appBar: AppBar(
        backgroundColor: Color(0xff282886),
        title: Text('Otro Recupero'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Esta opción es UNICAMENTE para registrar Recupero de Equipos que no estaban informados que los tenía el Cliente, y que el mismo solicita devolver.',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text("Modelo: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0e4888),
                        fontWeight: FontWeight.bold,
                      )),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _coddeco1OtroRecupero,
                      itemHeight: 50,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Elija un Modelo...',
                        errorText: _coddeco1OtroRecuperoShowError
                            ? _coddeco1OtroRecuperoError
                            : null,
                      ),
                      items: _getComboEquipos(),
                      onChanged: (value) {
                        _coddeco1OtroRecupero = value.toString();
                      },
                    ),
                  ),
                  Text("   ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0e4888),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text("Mac/Serie: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0e4888),
                        fontWeight: FontWeight.bold,
                      )),
                  Expanded(
                    flex: 7,
                    child: Text(_nroserieextraOtroRecupero,
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      child: Icon(Icons.qr_code_2),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF282886),
                        minimumSize: Size(50, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        String barcodeScanRes;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              _nroserieextraOtroRecuperoController.text = '';
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AlertDialog(
                                      backgroundColor: Colors.grey[300],
                                      title:
                                          Text("Ingrese o escanee el código"),
                                      content: Column(
                                        children: [
                                          TextField(
                                            autofocus: true,
                                            controller:
                                                _nroserieextraOtroRecuperoController,
                                            decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: '',
                                                labelText: '',
                                                errorText:
                                                    _nroserieextraOtroRecuperoShowError
                                                        ? _nroserieextraOtroRecuperoError
                                                        : null,
                                                prefixIcon: Icon(Icons.tag),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            onChanged: (value) {
                                              _nroserieextraOtroRecupero =
                                                  value;
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                              child: Icon(Icons.qr_code_2),
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF282886),
                                                minimumSize: Size(50, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: () async {
                                                String barcodeScanRes;
                                                try {
                                                  barcodeScanRes =
                                                      await FlutterBarcodeScanner
                                                          .scanBarcode(
                                                              '#3D8BEF',
                                                              'Cancelar',
                                                              false,
                                                              ScanMode.DEFAULT);
                                                  //print(barcodeScanRes);
                                                } on PlatformException {
                                                  barcodeScanRes = 'Error';
                                                }
                                                // if (!mounted) return;
                                                if (barcodeScanRes == '-1') {
                                                  return;
                                                }
                                                _nroserieextraOtroRecuperoController
                                                    .text = barcodeScanRes;
                                              }),
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Icon(Icons.cancel),
                                                    Text('Cancelar'),
                                                  ],
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFFB4161B),
                                                  minimumSize:
                                                      Size(double.infinity, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: ElevatedButton(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(Icons.save),
                                                      Text('Aceptar'),
                                                    ],
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color(0xFF120E43),
                                                    minimumSize: Size(
                                                        double.infinity, 50),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (_nroserieextraOtroRecuperoController
                                                            .text.length <
                                                        6) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              title:
                                                                  Text('Aviso'),
                                                              content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        'El código debe tener al menos 6 caracteres.'),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ]),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.of(context)
                                                                            .pop(),
                                                                    child: Text(
                                                                        'Ok')),
                                                              ],
                                                            );
                                                          });

                                                      return;
                                                    }

                                                    _nroserieextraOtroRecupero =
                                                        _nroserieextraOtroRecuperoController
                                                            .text;

                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            barrierDismissible: false);
                      }),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      child: Icon(Icons.cancel),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffdf281e),
                        minimumSize: Size(50, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _nroserieextraOtroRecupero = '';
                        });
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.cancel),
                          Text('Cancelar'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFB4161B),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.save),
                          Text('Guardar'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF120E43),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        _grabar();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//*****************************************************************************
//************************** GETCOMBOEQUIPOS **********************************
//*****************************************************************************

  List<DropdownMenuItem<String>> _getComboEquipos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Elija un Modelo...'),
      value: 'Elija un Modelo...',
    ));

    widget.controlesEquivalencia.forEach((control) {
      list.add(DropdownMenuItem(
        child: Text(control.descripcion.toString()),
        value: control.decO1.toString(),
      ));
    });

    return list;
  }

//*****************************************************************************
//************************** METODO GRABAR ************************************
//*****************************************************************************

  Future<void> _grabar() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Map<String, dynamic> request = {
        'idasignacionextra': 0,
        'idgaos': widget.idgaos,
        'fechacarga': DateTime.now().toString(),
        'nrocliente': widget.asignacion.cliente,
        'idtecnico': widget.user.idUser,
        'coddeco1': _coddeco1OtroRecupero,
        'nroserieextra': _nroserieextraOtroRecupero,
        'proyectomodulo': widget.asignacion.proyectomodulo,
      };

      Response response = await ApiHelper.post(
        '/api/AsignacionesOtsEquiposExtra',
        request,
      );
      Navigator.pop(context);
    }
  }
}
