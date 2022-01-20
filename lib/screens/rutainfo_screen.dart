import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/dbparadasenvios_helper.dart';
import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:fleetdeliveryapp/models/parada.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/rutacab.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/paradamap_screen.dart';
import 'package:fleetdeliveryapp/screens/paradainfo_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RutaInfoScreen extends StatefulWidget {
  final Usuario user;
  final RutaCab ruta;
  final List<Parada> paradas;
  final List<Envio> envios;
  final List<ParadaEnvio> paradasenvios;
  final Position positionUser;
  final List<Motivo> motivos;

  RutaInfoScreen(
      {required this.user,
      required this.ruta,
      required this.paradas,
      required this.envios,
      required this.paradasenvios,
      required this.positionUser,
      required this.motivos});

  @override
  _RutaInfoScreenState createState() => _RutaInfoScreenState();
}

class _RutaInfoScreenState extends State<RutaInfoScreen> {
  bool _showLoader = false;
  LatLng _center = LatLng(0, 0);
  final Set<Marker> _markers = {};
  ParadaEnvio paradaSelected = new ParadaEnvio(
      idParada: 0,
      idRuta: 0,
      idEnvio: 0,
      secuencia: 0,
      leyenda: '',
      latitud: 0,
      longitud: 0,
      idproveedor: 0,
      estado: 0,
      ordenid: '',
      titular: '',
      dni: '',
      domicilio: '',
      cp: '',
      entreCalles: '',
      telefonos: '',
      localidad: '',
      bultos: 0,
      proveedor: '',
      motivo: 0,
      motivodesc: '',
      notas: '',
      enviado: 0,
      fecha: '');

  List<ParadaEnvio> _paradasenvios = [];
  List<ParadaEnvio> _paradasenviosdb = [];

  @override
  void initState() {
    super.initState();
    _llenarparadasenvios();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdadada),
      appBar: AppBar(
        title: Text(widget.ruta.nombre!),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegartodos(),
        child: const Icon(
          Icons.map,
          size: 30,
        ),
        backgroundColor: Color(0xff282886),
      ),
    );
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showParadasCount(),
        Expanded(
          child: widget.paradas.length == 0 ? _noContent() : _getListView(),
        )
      ],
    );
  }

  Widget _showParadasCount() {
    int pendientes = 0;
    int cumplidas = 0;
    _paradasenvios.forEach((element) {
      if (element.estado == 3) {
        pendientes++;
      }
    });
    cumplidas = _paradasenvios.length - pendientes;

    return Container(
      padding: EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          Text("Cantidad de Paradas: ",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff282886),
                fontWeight: FontWeight.bold,
              )),
          Text(_paradasenvios.length.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff282886),
                fontWeight: FontWeight.bold,
              )),
          Text((' (Pendientes: ${pendientes})'),
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff282886),
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No hay Paradas registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return ListView(
      children: _paradasenvios.map((e) {
        return Card(
          color: Colors.white60,
          shadowColor: Colors.white,
          elevation: 10,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () {
              paradaSelected = e;
              _goInfoParada(e);
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
                                    Expanded(
                                      child: Text(e.secuencia.toString(),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Color(0xffbc2b51),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    (e.estado == 4)
                                        ? Text(
                                            "ENTREGADO",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : (e.estado == 10)
                                            ? Text(
                                                "NO ENTREGADO",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : (e.estado == 7)
                                                ? Text(
                                                    "RECHAZADO",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    "PENDIENTE",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text("Nombre: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(e.titular.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text("Dirección: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Expanded(
                                      child: Text(e.leyenda.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 135,
                                      child: ElevatedButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.map,
                                                color: Color(0xff282886)),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              'Navegar',
                                              style: TextStyle(
                                                  color: Color(0xff282886)),
                                            ),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFb3b3b4),
                                          minimumSize:
                                              Size(double.infinity, 30),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () => _navegar(e),
                                      ),
                                    ),
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
    );
  }

  void _goInfoParada(ParadaEnvio e) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParadaInfoScreen(
                user: widget.user,
                paradaenvio: e,
                positionUser: widget.positionUser,
                motivos: widget.motivos,
                paradas: widget.paradas,
                envios: widget.envios)));
    if (result == 'yes' || result != 'yes') {
      _llenarparadasenvios();
    }
  }

  _navegar(e) {
    _center = LatLng(e.latitud!.toDouble(), e.longitud!.toDouble());
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId(e.secuencia.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: e.titular.toString(),
        snippet: e.domicilio.toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParadaMapScreen(
                  user: widget.user,
                  positionUser: widget.positionUser,
                  paradaenvio: e,
                  markers: _markers,
                )));
  }

  _navegartodos() {
    _markers.clear();
    _paradasenvios.forEach((element) {
      _markers.add(Marker(
        markerId: MarkerId(element.secuencia.toString()),
        position:
            LatLng(element.latitud!.toDouble(), element.longitud!.toDouble()),
        infoWindow: InfoWindow(
          title: element.titular.toString(),
          snippet: element.domicilio.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ParadaMapScreen(
                  user: widget.user,
                  positionUser: widget.positionUser,
                  paradaenvio: _paradasenvios[0],
                  markers: _markers,
                )));
  }

  void _llenarparadasenvios() async {
    widget.paradasenvios.forEach((paradasenvio) {
      _paradasenvios.add(paradasenvio);
    });
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();

    _paradasenvios.forEach((paradasenvio) {
      _paradasenviosdb.forEach((paradasenviodb) {
        if (paradasenvio.idParada == paradasenviodb.idParada) {
          paradasenvio.estado = paradasenviodb.estado;
          paradasenvio.motivo = paradasenviodb.motivo;
          paradasenvio.motivodesc = paradasenviodb.motivodesc;
          paradasenvio.notas = paradasenviodb.notas;
          paradasenvio.fecha = paradasenviodb.fecha;
        }
      });
    });
    setState(() {});
  }
}
