import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/asign.dart';
import 'package:fleetdeliveryapp/models/asignacion2.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AgendarCitaScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion2 asignacion;

  AgendarCitaScreen({required this.user, required this.asignacion});

  @override
  _AgendarCitaScreenState createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
//*****************************************************************************
//************************** VARIABLES ****************************************
//*****************************************************************************

  List medios = ["Teléfono", "WhatsApp", "SMS", "Otro"];
  String _opseleccionada = "Teléfono";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool _showLoader = false;
  bool bandera = false;
  List<Asign> _asigns = [];

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agendar Cita"),
        backgroundColor: Color(0xFF0e4888),
        //backgroundColor: Color(0xFF0e4888),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            color: Color(0xFFC7C7C8),
            child: Column(
              children: <Widget>[
                _showAsignacion(),
                _getDateAndTime(context),
              ],
            ),
          ),
          Center(
            child: _showLoader
                ? LoaderComponent(text: 'Guardando CITA.')
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
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                              Text("Cliente: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    '${widget.asignacion.cliente.toString()} - ${widget.asignacion.nombre.toString()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Rec.Téc.: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                    widget.asignacion.reclamoTecnicoID
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Dirección: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.domicilio.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Localidad: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.localidad.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Provincia: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.provincia.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              Text("Teléfono: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child:
                                    Text(widget.asignacion.telefono.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Divider(
                            color: Colors.black,
                            height: 2,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Text("Est. Gaos: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                  widget.asignacion.estadogaos.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Cód. Cierre: ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                child: Text(
                                  widget.asignacion.codigoCierre.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Divider(
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
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                          SizedBox(
                            height: 23,
                          ),
                          _showMedioCita(),
                          SizedBox(
                            height: 20,
                          ),
                          _getFecha(context),
                          SizedBox(
                            height: 50,
                          ),
                          _showButtons(context),
                          SizedBox(
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
        Icon(Icons.fact_check),
        SizedBox(
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
    medios.forEach((element) {
      list.add(DropdownMenuItem(child: Text(element), value: element));
    });
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
          child: Container(
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Icon(Icons.schedule),
                SizedBox(
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 50,
          bottom: 40,
          child: Container(
              color: Colors.white,
              child: Text(
                ' Fecha Cita: ',
                style: TextStyle(fontSize: 12),
              )),
        ),
        Positioned(
          left: 244,
          bottom: 40,
          child: Container(
              color: Colors.white,
              child: Text(
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
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (selected != null && selected != selectedTime)
      setState(() {
        selectedTime = selected as TimeOfDay;
      });
  }

//*****************************************************************************
//************************** METODO SHOWBUTTONS *******************************
//*****************************************************************************

  Widget _showButtons(context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Guardar'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF282886),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _save(widget.asignacion, context),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Cancelar'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF637893),
                    minimumSize: Size(double.infinity, 50),
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
            AlertDialogAction(key: null, label: 'Aceptar'),
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
      response = await ApiHelper.GetAutonumericos(request1);
      if (response.isSuccess) {
        bandera = true;
        _asigns = response.result;
      }
    } while (bandera == false);

    for (Asign _asign in _asigns) {
      Map<String, dynamic> request2 = {
        'idregistro': _asign.idregistro,
        'subagentemercado': _asign.subagentemercado,
        'recupidjobcard': _asign.recupidjobcard,
        'cliente': _asign.cliente,
        'nombre': _asign.nombre,
        'domicilio': _asign.domicilio,
        'entrecallE1': _asign.entrecallE1,
        'entrecallE2': _asign.entrecallE2,
        'cp': _asign.cp,
        'ztecnico': _asign.ztecnico,
        'provincia': _asign.provincia,
        'localidad': _asign.localidad,
        'telefono': _asign.telefono,
        'grxx': _asign.grxx,
        'gryy': _asign.gryy,
        'decO1': _asign.decO1,
        'cmodeM1': _asign.cmodeM1,
        'fechacarga': _asign.fechacarga,
        'estado': _asign.estado,
        'fechaent': _asign.fechaent,
        'tecasig': _asign.tecasig,
        'zona': _asign.zona,
        'idr': _asign.idr,
        'modelo': _asign.modelo,
        'smartcard': _asign.smartcard,
        'ruta': _asign.ruta,
        'estadO2': _asign.estadO2,
        'estadO3': _asign.estadO3,
        'tarifa': _asign.tarifa,
        'proyectomodulo': _asign.proyectomodulo,
        'fechacaptura': _asign.fechacaptura,
        'estadogaos': _asign.estadogaos,
        'fechacumplida': _asign.fechacumplida,
        'bajasistema': _asign.bajasistema,
        'idcabeceracertif': _asign.idcabeceracertif,
        'subcon': _asign.subcon,
        'causantec': _asign.causantec,
        'pasaDefinitiva': _asign.pasaDefinitiva,
        'fechaAsignada': _asign.fechaAsignada,
        'hsCaptura': _asign.hsCaptura,
        'hsAsignada': _asign.hsAsignada,
        'hsCumplida': _asign.hsCumplida,
        'observacion': _asign.observacion,
        'linkFoto': _asign.linkFoto,
        'userID': _asign.userID,
        'hsCumplidaTime': _asign.hsCumplidaTime,
        'terminalAsigna': _asign.terminalAsigna,
        'urlDni': _asign.urlDni,
        'urlFirma': _asign.urlFirma,
        'urlDni2': _asign.urlDni2,
        'urlFirma2': _asign.urlFirma2,
        'esCR': _asign.esCR,
        'autonumerico': _asign.autonumerico,
        'reclamoTecnicoID': _asign.reclamoTecnicoID,
        'clienteTipoId': _asign.clienteTipoId,
        'documento': _asign.documento,
        'partido': _asign.partido,
        'emailCliente': _asign.emailCliente,
        'observacionCaptura': _asign.observacionCaptura,
        'fechaInicio': _asign.fechaInicio,
        'fechaEnvio': _asign.fechaEnvio,
        'marcaModeloId': _asign.marcaModeloId,
        'enviado': _asign.enviado,
        'cancelado': _asign.cancelado,
        'recupero': _asign.recupero,
        'codigoCierre': _asign.codigoCierre,
        'visitaTecnica': _asign.visitaTecnica,
        'novedades': _asign.novedades,
        'pdfGenerado': _asign.pdfGenerado,
        'fechaCumplidaTecnico': _asign.fechaCumplidaTecnico,
        'archivoOutGenerado': _asign.archivoOutGenerado,
        'idSuscripcion': _asign.idSuscripcion,
        'itemsID': _asign.itemsID,
        'sectorOperativo': _asign.sectorOperativo,
        'idTipoTrabajoRel': _asign.idTipoTrabajoRel,
        'motivos': _asign.motivos,
        'controlesEquivalencia': _asign.controlesEquivalencia,
        'fechaCita': _asign.fechaCita,
        'medioCita': _asign.medioCita,
        'nroSeriesExtras': _asign.nroSeriesExtras,
        'fechaEvento1': selectedDate.add(
            Duration(hours: selectedTime.hour, minutes: selectedTime.minute)),
        'fechaEvento2': asignacion.fechaEvento1,
        'fechaEvento3': asignacion.fechaEvento2,
        'fechaEvento4': asignacion.fechaEvento3,
        'evento1':
            'Cita por ${_opseleccionada} para el ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.hour}:${selectedTime.minute}',
        'evento2': asignacion.evento1,
        'evento3': asignacion.evento2,
        'evento4': asignacion.evento3,
        'telefAlternativo1': _asign.telefAlternativo1,
        'telefAlternativo2': _asign.telefAlternativo2,
        'telefAlternativo3': _asign.telefAlternativo3,
        'telefAlternativo4': _asign.telefAlternativo4,
      };

      Response response = await ApiHelper.put(
          '/api/AsignacionesOTs/', _asign.idregistro.toString(), request2);

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
    }

    Navigator.pop(context, 'yes');
  }
}