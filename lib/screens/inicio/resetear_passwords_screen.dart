import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetearPasswordsScreen extends StatefulWidget {
  const ResetearPasswordsScreen({Key? key}) : super(key: key);

  @override
  State<ResetearPasswordsScreen> createState() =>
      _ResetearPasswordsScreenState();
}

class _ResetearPasswordsScreenState extends State<ResetearPasswordsScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------
  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  final bool _enabled = false;
  bool _showLoader = false;

  Usuario2 _user = Usuario2(
      idUsuario: 0,
      codigoCausante: '',
      login: '',
      contrasena: '',
      nombre: '',
      apellido: '',
      estado: 0,
      fechaCaduca: 0,
      intentosInvDiario: 0,
      opeAutorizo: 0);

  late Usuario2 _userVacio;

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _userVacio = _user;
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 201, 211),
      appBar: AppBar(
        title: const Text("Reactivar Usuario"),
        centerTitle: true,
        backgroundColor: const Color(0xFF282886),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 25,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(flex: 7, child: _showLegajo()),
                          Expanded(flex: 2, child: _showButton()),
                        ],
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _showInfo(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF120E43),
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _user.login == "" || _user.contrasena == 1
                      ? null
                      : _reactivarUsuario,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.password),
                      SizedBox(
                        width: 35,
                      ),
                      Text('Reactivar Usuario'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
      floatingActionButton: _enabled
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF282886),
              onPressed: _enabled ? null : null,
              child: const Icon(
                Icons.add,
                size: 38,
              ),
            )
          : Container(),
    );
  }

//-----------------------------------------------------------
//--------------------- _showLegajo -------------------------
//-----------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          iconColor: const Color(0xFF282886),
          prefixIconColor: const Color(0xFF282886),
          hoverColor: const Color(0xFF282886),
          focusColor: const Color(0xFF282886),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese LOGIN...',
          labelText: 'LOGIN',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF282886)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _codigo = value;
        },
      ),
    );
  }

//-----------------------------------------------------------
//--------------------- _showButton -------------------------
//-----------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
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
              onPressed: () => _search(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------
//--------------------- _showInfo ---------------------------
//-----------------------------------------------------------

  Widget _showInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomRow(
              icon: Icons.person,
              nombredato: 'Usuario:',
              dato: _user.apellido,
            ),
            CustomRow(
              icon: Icons.phone,
              nombredato: 'Código:',
              dato: _user.codigoCausante,
            ),
            _user.estado == 0
                ? CustomRow(
                    icon: Icons.password,
                    nombredato: 'Password:',
                    dato: _user.contrasena,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------
//--------------------- _search -----------------------------
//-----------------------------------------------------------

  _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese LOGIN.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await _getUsuario();
  }

//----------------------------------------------------------
//--------------------- _getUsuario ------------------------
//----------------------------------------------------------

  Future<void> _getUsuario() async {
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
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Email': _codigo,
      'password': '123456',
    };

    var url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByLogin');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _showLoader = false;
        _user = _userVacio;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'LOGIN no válido.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    _user = Usuario2.fromJson(decodedJson);

    if (_user.estado == 1) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Este Usuario está Activo',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _showLoader = false;
    });
  }

//----------------------------------------------------------
//--------------------- _reactivarUsuario ------------------
//----------------------------------------------------------

  Future<void> _reactivarUsuario() async {
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
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Login': _codigo,
      'IdUsuarioAutoriza': 1,
      'FechaCaduca':
          DateTime.now().difference(DateTime(2022, 01, 01)).inDays + 80723 + 70,
      //Calculo dif entre hoy y el 1 de Enero de 2022 que es el 80723 y le sumo el 80723 y 70 días más
    };

    Response response =
        await ApiHelper.put('/api/Account/', _codigo.toString(), request);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } else {
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: 'Usuario reactivado con éxito!',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      Navigator.pop(context, 'yes');
    }
  }
}

//---------------------------------------------------------------------
class CustomRow extends StatelessWidget {
  IconData? icon;
  final String nombredato;
  final String? dato;
  bool? alert;

  CustomRow(
      {Key? key,
      this.icon,
      required this.nombredato,
      required this.dato,
      this.alert})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          icon != null
              ? alert == true
                  ? const Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : Icon(
                      icon,
                      color: const Color(0xFF282886),
                    )
              : Container(),
          const SizedBox(
            width: 15,
          ),
          Text(
            nombredato,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF282886)),
          ),
          Expanded(
            child: Text(
              dato != null ? dato.toString() : '',
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
