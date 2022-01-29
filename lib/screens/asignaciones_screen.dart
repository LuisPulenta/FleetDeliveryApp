import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/asignacion.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/tipoasignacion.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/asignacioninfo_screen.dart';
import 'package:flutter/material.dart';

class AsignacionesScreen extends StatefulWidget {
  final Usuario user;
  const AsignacionesScreen({required this.user});

  @override
  _AsignacionesScreenState createState() => _AsignacionesScreenState();
}

class _AsignacionesScreenState extends State<AsignacionesScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  bool _showLoader = false;
  bool _isFiltered = false;

  List<TipoAsignacion> _tiposasignacion = [];
  List<Asignacion> _asignaciones = [];

  String _tipoasignacion = 'Elija un Tipo de Asignación...';
  String _tipoasignacionError = '';
  bool _tipoasignacionShowError = false;
  TextEditingController _tipoasignacionController = TextEditingController();

  Asignacion asignacionSelected = Asignacion(
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
      cantAsign: 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _loadData();
    setState(() {});
  }

//*****************************************************************************
//************************** METODO PANTALLA **********************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asignaciones"),
        backgroundColor: Color(0xFF0e4888),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              children: <Widget>[
                _showTipos(),
                SizedBox(
                  height: 10,
                ),
                _getContent(),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Cargando Asignaciones.',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWTIPOS-------------------------------------
//-----------------------------------------------------------------------------

  Widget _showTipos() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: _tiposasignacion.length == 0
                ? Text('Cargando Tipos de Asignación...')
                : DropdownButtonFormField(
                    value: _tipoasignacion,
                    decoration: InputDecoration(
                      hintText: 'Elija un Tipo de Asignación...',
                      labelText: 'Tipo de Asignación',
                      errorText: _tipoasignacionShowError
                          ? _tipoasignacionError
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _getComboTiposAsignacion(),
                    onChanged: (value) {
                      setState(() {
                        _tipoasignacion = value.toString();
                      });
                    },
                  ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          child: Icon(Icons.search),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF781f1e),
            minimumSize: Size(50, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () => _getObras(),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getComboTiposAsignacion() {
    List<DropdownMenuItem<String>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Elija un Tipo de Asignación...'),
      value: 'Elija un Tipo de Asignación...',
    ));

    _tiposasignacion.forEach((tipoasignacion) {
      list.add(DropdownMenuItem(
        child: Text(tipoasignacion.proyectomodulo.toString()),
        value: tipoasignacion.proyectomodulo.toString(),
      ));
    });

    return list;
  }

  //-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showAsignacionesCount(),
        Expanded(
          child: _asignaciones.length == 0 ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO SHOWOBRASCOUNT ------------------------
//-----------------------------------------------------------------------------

  Widget _showAsignacionesCount() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          Text("Cantidad de Asignaciones: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_asignaciones.length.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Asignaciones con ese criterio de búsqueda'
              : 'No hay Asignaciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getObras,
      child: ListView(
        children: _asignaciones.map((e) {
          return Card(
            color: Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                asignacionSelected = e;
                _goInfoAsignacion(e);
              },
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
                                      Text("N° Obra: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.recupidjobcard.toString(),
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
                                    children: [
                                      Text("Cliente: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.cliente.toString(),
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
                                    children: [
                                      Text("OP/N° Fuga: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child:
                                            Text(e.telefAlternativo1.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Domicilio: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(e.domicilio.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOADDATA **********************************
//*****************************************************************************

  void _loadData() async {
    await _getTiposAsignaciones();
  }

//*****************************************************************************
//************************** METODO GETTIPOASIGNACIONES ***********************
//*****************************************************************************

  Future<Null> _getTiposAsignaciones() async {
    // setState(() {
    //   _showLoader = true;
    // });

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

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getTipoAsignaciones(widget.user.idUser);

    // setState(() {
    //   _showLoader = false;
    // });

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
      _tiposasignacion = response.result;
    });
  }

//*****************************************************************************
//************************** METODO LOADOBRAS *********************************
//*****************************************************************************

  Future<Null> _getObras() async {
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

    Response response = Response(isSuccess: false);
    response =
        await ApiHelper.getAsignaciones(widget.user.idUser, _tipoasignacion);
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
      _asignaciones = response.result;
      _asignaciones.sort((a, b) {
        return a.cliente
            .toString()
            .toLowerCase()
            .compareTo(b.cliente.toString().toLowerCase());
      });
    });

    var a = 1;
  }

//*****************************************************************************
//************************** METODO GOINFOOBRA ********************************
//*****************************************************************************

  void _goInfoAsignacion(Asignacion asignacion) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AsignacionInfoScreen(
                  user: widget.user,
                  asignacion: asignacion,
                )));
    if (result == 'yes' || result != 'yes') {
      _getObras();
      setState(() {});
    }
  }
}
