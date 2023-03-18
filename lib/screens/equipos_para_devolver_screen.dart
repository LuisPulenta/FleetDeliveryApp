import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';

class EquiposParaDevolverScreen extends StatefulWidget {
  final Usuario user;
  const EquiposParaDevolverScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<EquiposParaDevolverScreen> createState() =>
      _EquiposParaDevolverScreenState();
}

class _EquiposParaDevolverScreenState extends State<EquiposParaDevolverScreen> {
//-----------------------------------------------------------------------------
//---------------------------- Variables --------------------------------------
//-----------------------------------------------------------------------------
  bool _showLoader = false;
  late EquiposSinDevolver _equiposSinDevolver;

//-----------------------------------------------------------------------------
//--------------------------- initState ---------------------------------------
//-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _equiposSinDevolver = EquiposSinDevolver(
        userID: 0,
        apellidonombre: '',
        sinIngresoDeposito: 0,
        dtv: 0,
        cable: 0,
        tasa: 0,
        tlc: 0,
        prisma: 0,
        teco: 0,
        superC: 0);
    _getEquiposParaDevolver();
  }

//-----------------------------------------------------------------------------
//---------------------------- Pantalla ---------------------------------------
//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7C7C8),
      appBar: AppBar(
        title: const Text('Equipos para devolver'),
        centerTitle: true,
        backgroundColor: const Color(0xFF282886),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              color: Colors.white,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FractionColumnWidth(0.3),
                  1: FractionColumnWidth(0.2),
                  2: FractionColumnWidth(0.3),
                  3: FractionColumnWidth(0.2),
                },
                border: TableBorder.all(),
                children: [
                  //---------------- Título -----------------------------
                  TableRow(
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 33, 172, 236),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Empresa",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 33, 172, 236),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Cantidad",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 33, 172, 236),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Empresa",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 33, 172, 236),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Cantidad",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),

                  //----------------- Primera Fila --------------------------------
                  TableRow(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("DTV",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.dtv! > 0
                                  ? _equiposSinDevolver.dtv.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Tasa",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.tasa! > 0
                                  ? _equiposSinDevolver.tasa.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ],
                  ),
                  //----------------- Segunda Fila --------------------------------
                  TableRow(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Cable",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.cable! > 0
                                  ? _equiposSinDevolver.cable.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("TLC",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.tlc! > 0
                                  ? _equiposSinDevolver.tlc.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ],
                  ),
                  //----------------- Tercera Fila --------------------------------
                  TableRow(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Prisma",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.prisma! > 0
                                  ? _equiposSinDevolver.prisma.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Teco",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.teco! > 0
                                  ? _equiposSinDevolver.teco.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ],
                  ),
                  //----------------- Cuarta Fila --------------------------------
                  TableRow(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("SuperC",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.superC! > 0
                                  ? _equiposSinDevolver.superC.toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 130, 205, 239),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("TOTAL",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 33, 172, 236),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              _equiposSinDevolver.sinIngresoDeposito! > 0
                                  ? _equiposSinDevolver.sinIngresoDeposito
                                      .toString()
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//----------------------------------------------------------------------------
//--------------------------- _getEquiposParaDevolver ------------------------
//----------------------------------------------------------------------------

  Future<void> _getEquiposParaDevolver() async {
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response =
        await ApiHelper.getEquiposSinDevolver(widget.user.idUser.toString());

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
    }

    setState(() {
      _equiposSinDevolver = response.result;
    });
  }
}
