import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late Turno _turno;
  bool mostrar = false;

  // DateTime? fechaTurno;
  // int? horaTurno;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = TimeOfDay.now();

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

    _turno = Turno(
      idTurno: 0,
      idUser: 0,
      fechaCarga: '',
      fechaTurno: '',
      horaTurno: 0,
      fechaConfirmaTurno: '',
      idUserConfirma: 0,
      fechaTurnoConfirmado: '',
      horaTurnoConfirmado: 0,
      concluido: '',
    );

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
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            color: const Color.fromARGB(255, 33, 172, 236),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("Cantidad",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            color: const Color.fromARGB(255, 33, 172, 236),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("Empresa",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            color: const Color.fromARGB(255, 33, 172, 236),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("Cantidad",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),

                      //----------------- Primera Fila --------------------------------
                      TableRow(
                        children: [
                          const _celda(
                              valor: "DTV",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.dtv! > 0
                                ? _equiposSinDevolver.dtv.toString()
                                : '',
                            color: Colors.white,
                          ),
                          const _celda(
                              valor: "Tasa",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.tasa! > 0
                                ? _equiposSinDevolver.tasa.toString()
                                : '',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      //----------------- Segunda Fila --------------------------------
                      TableRow(
                        children: [
                          const _celda(
                              valor: "Cable",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.cable! > 0
                                ? _equiposSinDevolver.cable.toString()
                                : '',
                            color: Colors.white,
                          ),
                          const _celda(
                              valor: "TLC",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.tlc! > 0
                                ? _equiposSinDevolver.tlc.toString()
                                : '',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      //----------------- Tercera Fila --------------------------------
                      TableRow(
                        children: [
                          const _celda(
                              valor: "Prisma",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.prisma! > 0
                                ? _equiposSinDevolver.prisma.toString()
                                : '',
                            color: Colors.white,
                          ),
                          const _celda(
                              valor: "Teco",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.teco! > 0
                                ? _equiposSinDevolver.teco.toString()
                                : '',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      //----------------- Cuarta Fila --------------------------------
                      TableRow(
                        children: [
                          const _celda(
                              valor: "SuperC",
                              color: Color.fromARGB(255, 130, 205, 239)),
                          _celda(
                            valor: _equiposSinDevolver.superC! > 0
                                ? _equiposSinDevolver.superC.toString()
                                : '',
                            color: Colors.white,
                          ),
                          const _celda(
                            valor: "TOTAL",
                            color: Colors.yellow,
                          ),
                          _celda(
                            valor: _equiposSinDevolver.sinIngresoDeposito! > 0
                                ? _equiposSinDevolver.sinIngresoDeposito
                                    .toString()
                                : '',
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const Text(
                'TURNO PARA DEVOLUCION',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              _equiposSinDevolver.sinIngresoDeposito! == 0
                  ? const Text('No tiene equipos para devolver',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))
                  : Container(),
              _turno.idUser == 0 &&
                      mostrar &&
                      _equiposSinDevolver.sinIngresoDeposito! > 0
                  ? Column(
                      children: [
                        const Text(
                            'No tiene ningún Turno en gestión. Debería Solicitar un Turno.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: _getFecha(context),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              _turno.idUser == 0 &&
                      mostrar &&
                      _equiposSinDevolver.sinIngresoDeposito! > 0
                  ? _showButtonTurno()
                  : Container(),
              _turno.idUser == widget.user.idUser &&
                      _turno.fechaConfirmaTurno == null &&
                      mostrar
                  ? Column(
                      children: [
                        const Text(
                          'Usted tiene un turno pendiente de confirmación',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Text(' '),
                                Row(
                                  children: [
                                    const Text('  Fecha: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                _turno.fechaTurno.toString())),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                    const Text('  -  Hora: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(_HoraMinuto(_turno.horaTurno!),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                const Text(' '),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              _turno.idUser == widget.user.idUser &&
                      _turno.fechaConfirmaTurno == null &&
                      mostrar
                  ? _showButtonDeleteTurno()
                  : Container(),
              _turno.idUser == widget.user.idUser &&
                      _turno.fechaConfirmaTurno != null &&
                      mostrar
                  ? Column(
                      children: [
                        const Text('Usted tiene un turno confirmado',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Text(' '),
                                Row(
                                  children: [
                                    const Text('  Fecha: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(_turno
                                                .fechaTurnoConfirmado
                                                .toString())),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                    const Text('  -  Hora: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        _HoraMinuto(
                                            _turno.horaTurnoConfirmado!),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                const Text(' '),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Container(),
              _turno.idUser == widget.user.idUser &&
                      _turno.fechaConfirmaTurno != null &&
                      mostrar
                  ? _showButtonConfirma()
                  : Container(),
              const SizedBox(
                height: 20,
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

    _getTurnos();
  }

//----------------------------------------------------------------------------
//--------------------------- _getTurnos -------------------------------------
//----------------------------------------------------------------------------

  Future<void> _getTurnos() async {
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

    response = await ApiHelper.getTurnos(widget.user.idUser.toString());

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
      _turno = response.result;
      mostrar = true;
    });
  }

//-----------------------------------------------------------------
//---------------------  _showButtonTurno -----------------
//-----------------------------------------------------------------

  Widget _showButtonTurno() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Solicitar Turno'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF282886),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//---------------------  _showButtonDeleteTurno -------------------
//-----------------------------------------------------------------

  Widget _showButtonDeleteTurno() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete_forever),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Borrar Turno'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _delete,
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

    if (selectedDate == null) {
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
                    Text('Debe ingresar Fecha del Turno.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
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
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    String ahora = DateTime.now().toString();

    Map<String, dynamic> request = {
      'IDTurno': 0,
      'IdUser': widget.user.idUser,
      'FechaCarga': ahora,
      'FechaTurno': selectedDate.toString(),
      'HoraTurno': selectedTime.hour * 3600 + selectedTime.minute * 60,
      'FechaConfirmaTurno': null,
      'IDUserConfirma': null,
      'FechaTurnoConfirmado': null,
      'HoraTurnoConfirmado': null,
      'Concluido': "NO",
    };

    Response response =
        await ApiHelper.post('/api/AsignacionesOtsTurnos/', request);

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

    //Navigator.pop(context, 'yes');
    _getTurnos();
    setState(() {});
  }

  //--------------------------------------------------------------------------
  //---------------------------- _delete -----------------------------------
  //------------------------------------------------------------------------

  void _delete() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(''),
            content:
                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
              Text('¿Está seguro de borrar el turno?'),
              SizedBox(
                height: 10,
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('NO')),
              TextButton(
                  child: const Text('SI'),
                  onPressed: () {
                    _deleteRecord();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  //--------------------------------------------------------------------------
  //---------------------------- _deleteRecord -------------------------------
  //--------------------------------------------------------------------------

  void _deleteRecord() async {
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

    String ahora = DateTime.now().toString();

    Response response = await ApiHelper.delete(
        '/api/AsignacionesOtsTurnos/', _turno.idTurno.toString());

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

    //Navigator.pop(context, 'yes');
    _getTurnos();
    setState(() {});
  }

  //--------------------------------------------------------------------------
  //---------------------------- _confirma ---------------------------------
  //------------------------------------------------------------------------

  void _confirma() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(''),
            content:
                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
              Text('¿Está seguro de dar por cumplido este Turno?'),
              SizedBox(
                height: 10,
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('NO')),
              TextButton(
                  child: const Text('SI'),
                  onPressed: () {
                    _confirmaRecord();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  //--------------------------------------------------------------------------
  //---------------------------- _confirmaRecord -----------------------------
  //--------------------------------------------------------------------------

  void _confirmaRecord() async {
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

    String ahora = DateTime.now().toString();

    Map<String, dynamic> request = {
      'IDTurno': _turno.idTurno,
      'IdUser': _turno.idUser,
      'FechaCarga': _turno.fechaCarga.toString(),
      'FechaTurno': _turno.fechaTurno.toString(),
      'HoraTurno': _turno.horaTurno,
      'FechaConfirmaTurno': _turno.fechaConfirmaTurno.toString(),
      'IDUserConfirma': _turno.idUserConfirma,
      'FechaTurnoConfirmado': _turno.fechaTurnoConfirmado.toString(),
      'HoraTurnoConfirmado': _turno.horaTurnoConfirmado,
      'Concluido': "SI",
    };

    Response response = await ApiHelper.put(
        '/api/AsignacionesOtsTurnos/', _turno.idTurno.toString(), request);

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

    //Navigator.pop(context, 'yes');
    _getTurnos();
    setState(() {});
  }

//-----------------------------------------------------------------
//---------------------  _showButtonConfirma ----------------------
//-----------------------------------------------------------------

  Widget _showButtonConfirma() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Turno cumplido'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF282886),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                _confirma();
              },
            ),
          ),
        ],
      ),
    );
  }
//----------------------------------------------------------------------------
//------------------------------- _getFecha ----------------------------------
//----------------------------------------------------------------------------

  Widget _getFecha(context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80,
        ),
        Positioned(
          bottom: 0,
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(
                width: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InkWell(
                        child: Text(
                            "    ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                      ),
                    ),
                  ],
                ),
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              const Icon(Icons.schedule),
              const SizedBox(
                width: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: InkWell(
                        child: Text(
                            "        ${selectedTime.hour}:${selectedTime.minute}"),
                      ),
                    ),
                  ],
                ),
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          bottom: 50,
          child: Container(
              child: const Text(
            ' Fecha Turno: ',
            style: TextStyle(fontSize: 12),
          )),
        ),
        Positioned(
          left: 244,
          bottom: 50,
          child: Container(
              child: const Text(
            ' Hora Turno: ',
            style: TextStyle(fontSize: 12),
          )),
        )
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
  }

//----------------------------------------------------------------------------
//----------------------------- _HoraMinuto ----------------------------------
//----------------------------------------------------------------------------

  String _HoraMinuto(int valor) {
    String hora = (valor / 3600).floor().toString();
    String minutos =
        ((valor - ((valor / 3600).floor()) * 3600) / 60).round().toString();

    if (minutos.length == 1) {
      minutos = "0" + minutos;
    }
    return hora.toString() + ':' + minutos.toString();
  }
}

//-------------------------------------------------------------------------
//------------------------------ _celda -----------------------------------
//-------------------------------------------------------------------------
class _celda extends StatelessWidget {
  final String valor;
  final Color color;
  const _celda({
    Key? key,
    required this.valor,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(valor,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
