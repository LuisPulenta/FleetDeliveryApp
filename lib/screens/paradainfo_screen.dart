import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:flutter/material.dart';

class ParadaInfoScreen extends StatefulWidget {
  final Usuario user;
  final ParadaEnvio paradaenvio;

  const ParadaInfoScreen({required this.user, required this.paradaenvio});

  @override
  _ParadaInfoScreenState createState() => _ParadaInfoScreenState();
}

class _ParadaInfoScreenState extends State<ParadaInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parada: ${widget.paradaenvio.secuencia.toString()}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _showCliente(),
          _showPaquete(),
          _showDelivery(),
          _showButton(),
        ],
      ),
    );
  }

  Widget _showCliente() {
    return Column(children: [
      //************ CLIENTE *********
      Card(
        margin: EdgeInsets.all(10),
        color: Color(0xffb3b3b4),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cliente",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              color: Color(0xff8b8cb6),
              width: double.infinity,
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.person),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.paradaenvio.titular.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(('DOC: ${widget.paradaenvio.dni.toString()}'))
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.home),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.paradaenvio.leyenda.toString()} ${widget.paradaenvio.localidad.toString()}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                            ('Entre: ${widget.paradaenvio.entreCalles.toString()}'))
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.phone),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.paradaenvio.telefonos.toString()} ${widget.paradaenvio.localidad.toString()}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
              height: 40,
            ),
          ],
        ),
      ),
      //************ PAQUETE *********
      Card(
        margin: EdgeInsets.all(10),
        color: Color(0xffb3b3b4),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Paquete",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              color: Color(0xff8b8cb6),
              width: double.infinity,
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.receipt_long),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            ('N° Remito: ${widget.paradaenvio.idEnvio.toString()}'))
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.inventory_2),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            ('Cant. de bultos: ${widget.paradaenvio.bultos.toString()}'))
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
            ),
            Divider(
              height: 3,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.phone),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            ('Observaciones: ${widget.paradaenvio.idproveedor.toString()}')),
                      ],
                    ),
                  ),
                ],
              ),
              color: Color(0xffdadada),
              width: double.infinity,
              height: 40,
            ),
          ],
        ),
      ),
    ]);
  }

  _showPaquete() {
    return Container();
  }

  _showDelivery() {
    return Container();
  }

  _showButton() {
    return Container();
  }
}
