import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';

class AgendarCitaScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;

  const AgendarCitaScreen(
      {Key? key, required this.user, required this.asignacion})
      : super(key: key);

  @override
  _AgendarCitaScreenState createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
//*****************************************************************************
//************************** VARIABLES ****************************************
//*****************************************************************************

  List medios = ["Teléfono", "WhatsApp", "SMS", "Visita directa"];
  String _opseleccionada = "Teléfono";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final bool _showLoader = false;
  bool bandera = false;
  List<Asign> _asigns = [];

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendar Cita"),
        backgroundColor: const Color(0xFF0e4888),
        //backgroundColor: Color(0xFF0e4888),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            color: const Color(0xFFC7C7C8),
            child: Column(
              children: <Widget>[
                _showAsignacion(),
                _getDateAndTime(context),
              ],
            ),
          ),
          Center(
            child: _showLoader
                ? const LoaderComponent(text: 'Guardando CITA.')
                : Container(),
          )
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO SHOWASIGNACION ****************************
//*****************************************************************************

  Widget _showAsignacion() {
    return Card(
      color: Colors.white,
      //color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                              const Text("Cliente: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    '${widget.asignacion.cliente.toString()} - ${widget.asignacion.nombre.toString()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Rec.Téc.: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    widget.asignacion.reclamoTecnicoID
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Dirección: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.domicilio.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Localidad: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.localidad.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Provincia: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.provincia.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const Text("Teléfono: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.telefono.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              const Text("Est. Gaos: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                  widget.asignacion.estadogaos.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("Cód. Cierre: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                  widget.asignacion.codigoCierre.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 2,
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
  }

//*****************************************************************************
//************************** METODO GETDATETIME *******************************
//*****************************************************************************

  Widget _getDateAndTime(context) {
    return Card(
      color: Colors.white,
      //color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                          const SizedBox(
                            height: 23,
                          ),
                          _showMedioCita(),
                          const SizedBox(
                            height: 20,
                          ),
                          _getFecha(context),
                          const SizedBox(
                            height: 50,
                          ),
                          _showButtons(context),
                          const SizedBox(
                            height: 20,
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
  }

//*****************************************************************************
//************************** METODO SHOWMEDIOCITA *****************************
//*****************************************************************************

  Widget _showMedioCita() {
    return Row(
      children: <Widget>[
        const Icon(Icons.fact_check),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: DropdownButtonFormField(
            value: _opseleccionada,
            decoration: InputDecoration(
              hintText: 'Seleccione un medio de cita...',
              labelText: 'Medio de cita',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: getOptionsDropDown(),
            onChanged: (value) {
              setState(() {
                _opseleccionada = value.toString();
              });
            },
          ),
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> getOptionsDropDown() {
    List<DropdownMenuItem<String>> list = [];
    for (var element in medios) {
      list.add(DropdownMenuItem(child: Text(element), value: element));
    }
    return list;
  }

//*****************************************************************************
//************************** METODO SHOWFECHA *********************************
//*****************************************************************************
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
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 50,
          bottom: 40,
          child: Container(
              color: Colors.white,
              child: const Text(
                ' Fecha Cita: ',
                style: TextStyle(fontSize: 12),
              )),
        ),
        Positioned(
          left: 244,
          bottom: 40,
          child: Container(
              color: Colors.white,
              child: const Text(
                ' Hora Cita: ',
                style: TextStyle(fontSize: 12),
              )),
        )
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2023),
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

//*****************************************************************************
//************************** METODO SHOWBUTTONS *******************************
//*****************************************************************************

  Widget _showButtons(context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
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
                      Text('Guardar'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF282886),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _save(widget.asignacion, context),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cancel),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Cancelar'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF637893),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO SAVE **************************************
//*****************************************************************************

  void _save(Asignacion2 asignacion, context) async {
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

    Map<String, dynamic> request1 = {
      'reclamoTecnicoID': asignacion.reclamoTecnicoID,
      'userID': asignacion.userID,
    };

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getAutonumericos(request1);
      if (response.isSuccess) {
        bandera = true;
        _asigns = response.result;
      }
    } while (bandera == false);

    for (Asign _asign in _asigns) {
      Map<String, dynamic> request2 = {
        'idregistro': _asign.idregistro,
        'codigoCierre': _asign.codigoCierre,
        'decO1': _asign.decO1,
        'estadO2': _asign.estadO2,
        'estadO3': _asign.estadO3,
        'estadogaos': _asign.estadogaos,
        'evento1':
            'Cita por $_opseleccionada para el ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.hour}:${selectedTime.minute}',
        'evento2': asignacion.evento1,
        'evento3': asignacion.evento2,
        'evento4': asignacion.evento3,
        'fechaCita': selectedDate
            .add(Duration(
                hours: selectedTime.hour, minutes: selectedTime.minute))
            .toString(),
        'fechacumplida':
            _asign.fechacumplida == Null ? '' : _asign.fechacumplida,
        'fechaEvento1': selectedDate
            .add(Duration(
                hours: selectedTime.hour, minutes: selectedTime.minute))
            .toString(),
        'fechaEvento2':
            asignacion.fechaEvento1 == Null ? '' : asignacion.fechaEvento1,
        'fechaEvento3':
            asignacion.fechaEvento2 == Null ? '' : asignacion.fechaEvento2,
        'fechaEvento4':
            asignacion.fechaEvento3 == Null ? '' : asignacion.fechaEvento3,
        'hsCumplidaTime': _asign.hsCumplidaTime,
        'medioCita': _opseleccionada,
        'nroSeriesExtras': _asign.nroSeriesExtras,
        'observacion': _asign.observacion,
        'urlDni': _asign.urlDni,
        'urlFirma': _asign.urlFirma,
        'ImageArrayDni': [],
        'ImageArrayFirma': [],
      };

      Response response = await ApiHelper.put(
          '/api/AsignacionesOTs/', _asign.idregistro.toString(), request2);

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
    }

    Navigator.pop(context, 'yes');
  }
}
