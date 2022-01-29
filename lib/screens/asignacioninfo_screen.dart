import 'package:fleetdeliveryapp/models/asignacion.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';

class AsignacionInfoScreen extends StatefulWidget {
  final Usuario user;
  final Asignacion asignacion;

  AsignacionInfoScreen({required this.user, required this.asignacion});

  @override
  _AsignacionInfoScreenState createState() => _AsignacionInfoScreenState();
}

class _AsignacionInfoScreenState extends State<AsignacionInfoScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Asignación Info'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}
