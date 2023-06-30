import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoScreen extends StatefulWidget {
  final Usuario user;
  const InfoScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  //--------------------------------------------------------------
  //------------------------ Variables ---------------------------
  //--------------------------------------------------------------
  bool bandera = false;
  int intentos = 0;
  List<AsignacionesConFechaCita> _asignacionesConFechaCita = [];
  bool _showLoader = false;

  //--------------------------------------------------------------
  //------------------------ initState ---------------------------
  //--------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //--------------------------------------------------------------
  //------------------------ Pantalla ---------------------------
  //--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignaciones con Fecha Cita'),
        centerTitle: true,
        backgroundColor: const Color(0xFF282886),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        color: const Color(0xFFC7C7C8),
        child: Center(
          child: _showLoader
              ? const LoaderComponent(
                  text: 'Cargando Asgnaciones con Fecha Cita.',
                )
              : _getContent(),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.yellow,
          child: Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text('Proy.Mód.',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: Text('    Fecha',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 6,
                child: Text('Localidad',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text('Cantidad',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              _asignacionesConFechaCita.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Asignaciones con Fecha CIta',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _asignacionesConFechaCita.map((e) {
        return Card(
          color: Colors.white,
          //color: Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                  Expanded(
                                    flex: 3,
                                    child: Text(e.proyectomodulo.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                        '${e.day.toString()}/${e.month.toString()}/${e.year.toString()}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Text(e.localidad.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(e.cantidad.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 1,
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
      }).toList(),
    );
  }

  ///--------------------------------------------------------------
  //------------------------ _loadData ---------------------------
  //--------------------------------------------------------------

  Future<void> _loadData() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
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
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.GetConFechaCita(widget.user.idUser);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _asignacionesConFechaCita = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }
}
