import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class OtroRecuperoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;
  final int idgaos;
  final List<ControlesEquivalencia> controlesEquivalencia;

  const OtroRecuperoScreen({
    super.key,
    required this.user,
    required this.asignacion,
    required this.idgaos,
    required this.controlesEquivalencia,
  });

  @override
  State<OtroRecuperoScreen> createState() => _OtroRecuperoScreenState();
}

class _OtroRecuperoScreenState extends State<OtroRecuperoScreen> {
  //--------------------------------------------------------
  //--------------------- Variables ------------------------
  //--------------------------------------------------------

  String _coddeco1OtroRecupero = 'Elija un Modelo...';
  final String _coddeco1OtroRecuperoError = '';
  final bool _coddeco1OtroRecuperoShowError = false;

  String _nroserieextraOtroRecupero = '';
  final String _nroserieextraOtroRecuperoError = '';
  final bool _nroserieextraOtroRecuperoShowError = false;
  final TextEditingController _nroserieextraOtroRecuperoController =
      TextEditingController();

  //--------------------------------------------------------
  //--------------------- Pantalla -------------------------
  //--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFbfd4e7),
      appBar: AppBar(
        backgroundColor: const Color(0xff282886),
        title: const Text('Otro Recupero'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Esta opción es UNICAMENTE para registrar Recupero de Equipos que no estaban informados que los tenía el Cliente, y que el mismo solicita devolver.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Modelo: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0e4888),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      initialValue: _coddeco1OtroRecupero,
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
                  const Text(
                    "   ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0e4888),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    "Mac/Serie: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0e4888),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Text(
                      _nroserieextraOtroRecupero,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF282886),
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
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
                                  title: const Text(
                                    "Ingrese o escanee el código",
                                  ),
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
                                          prefixIcon: const Icon(Icons.tag),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          _nroserieextraOtroRecupero = value;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF282886,
                                          ),
                                          minimumSize: const Size(50, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          String barcodeScanRes;
                                          try {
                                            barcodeScanRes = '-1';
                                            String? barcodeScanResAux =
                                                await Navigator.of(
                                                  context,
                                                ).push<String>(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BarCodeReader(),
                                                  ),
                                                );
                                            barcodeScanRes =
                                                barcodeScanResAux ?? '-1';
                                          } on PlatformException {
                                            barcodeScanRes = 'Error';
                                          }
                                          // if (!mounted) return;
                                          if (barcodeScanRes == '-1') {
                                            return;
                                          }
                                          _nroserieextraOtroRecuperoController
                                                  .text =
                                              barcodeScanRes;
                                        },
                                        child: const Icon(Icons.qr_code_2),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF120E43,
                                              ),
                                              minimumSize: const Size(
                                                double.infinity,
                                                50,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_nroserieextraOtroRecuperoController
                                                      .text
                                                      .length <
                                                  6) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      title: const Text(
                                                        'Aviso',
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const <Widget>[
                                                          Text(
                                                            'El código debe tener al menos 6 caracteres.',
                                                          ),
                                                          SizedBox(height: 10),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                context,
                                                              ).pop(),
                                                          child: const Text(
                                                            'Ok',
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                return;
                                              }

                                              if (_nroserieextraOtroRecuperoController
                                                  .text
                                                  .contains("http")) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      title: const Text(
                                                        'Aviso',
                                                      ),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const <Widget>[
                                                          Text(
                                                            'No puede registrar direcciones Web.',
                                                          ),
                                                          SizedBox(height: 10),
                                                        ],
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                context,
                                                              ).pop(),
                                                          child: const Text(
                                                            'Ok',
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                FocusScope.of(
                                                  context,
                                                ).unfocus(); //Oculta el teclado
                                                return;
                                              }

                                              _nroserieextraOtroRecupero =
                                                  _nroserieextraOtroRecuperoController
                                                      .text
                                                      .toUpperCase();

                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: const [
                                                Icon(Icons.save),
                                                Text('Aceptar'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFB4161B,
                                              ),
                                              minimumSize: const Size(
                                                double.infinity,
                                                50,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: const [
                                                Icon(Icons.cancel),
                                                Text('Cancelar'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        barrierDismissible: false,
                      );
                    },
                    child: const Icon(Icons.qr_code_2),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffdf281e),
                      minimumSize: const Size(50, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _nroserieextraOtroRecupero = '';
                      });
                    },
                    child: const Icon(Icons.cancel),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF120E43),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        _grabar();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [Icon(Icons.save), Text('Guardar')],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB4161B),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [Icon(Icons.cancel), Text('Cancelar')],
                      ),
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

  //--------------------------------------------------------
  //--------------------- _getComboEquipos -----------------
  //--------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboEquipos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Modelo...',
        child: Text('Elija un Modelo...'),
      ),
    );

    for (var control in widget.controlesEquivalencia) {
      list.add(
        DropdownMenuItem(
          value: control.decO1.toString(),
          child: Text(control.descripcion.toString()),
        ),
      );
    }

    return list;
  }

  //--------------------------------------------------------
  //--------------------- _grabar --------------------------
  //--------------------------------------------------------

  Future<void> _grabar() async {
    //---------------- Verifica que se haya elegido un modelo --------------

    if (_coddeco1OtroRecupero == 'Elija un Modelo...') {
      showMyDialog('Error', 'Debe elegir un Modelo.', 'Aceptar');

      return;
    }

    //---------------- Verifica que se haya elegido un MacSerie --------------

    if (_nroserieextraOtroRecupero == '') {
      showMyDialog('Error', 'Debe elegir un Mac/Serie.', 'Aceptar');

      return;
    }

    //---------------- Verifica que MacSerie no tenga más de 30 caracteres --------------

    if (_nroserieextraOtroRecupero.length > 30) {
      showMyDialog(
        'Error',
        'Mac/Serie no puede tener más de 30 caracteres.',
        'Aceptar',
      );

      return;
    }

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
