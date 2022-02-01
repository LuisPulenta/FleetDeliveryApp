import 'package:fleetdeliveryapp/models/asignacion2.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        padding: EdgeInsets.all(5),
        color: Color(0xFFC7C7C8),
        child: Center(
          child: _getContent(),
        ),
      ),
    );
  }

//*****************************************************************************
//************************** METODO GETCONTENT ********************************
//*****************************************************************************

  Widget _getContent() {
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
                          SizedBox(
                            height: 23,
                          ),
                          _showMedioCita(),
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
}
