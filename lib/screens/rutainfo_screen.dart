import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/helpers/dbparadasenvios_helper.dart';
import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:fleetdeliveryapp/models/nroregmax.dart';
import 'package:fleetdeliveryapp/models/parada.dart';
import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:fleetdeliveryapp/models/rutacab.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:fleetdeliveryapp/screens/paradamap_screen.dart';
import 'package:fleetdeliveryapp/screens/paradainfo_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
  ParadaEnvio paradaenvioSelected = new ParadaEnvio(
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

  Parada paradaSelected = Parada(
      idParada: 0,
      idRuta: 0,
      idEnvio: 0,
      tag: 0,
      secuencia: 0,
      leyenda: '',
      latitud: 0,
      longitud: 0,
      iconoPropio: '',
      iDmapa: '',
      distancia: 0,
      tiempo: 0,
      estado: 0,
      fecha: '',
      hora: '',
      idMotivo: 0,
      notaChofer: '',
      nuevoOrden: 0,
      idCabCertificacion: 0,
      idLiquidacionFletero: 0,
      turno: '');

  Envio envioSelected = Envio(
      idEnvio: 0,
      idproveedor: 0,
      agencianr: 0,
      estado: 0,
      envia: '',
      ruta: '',
      ordenid: '',
      fecha: 0,
      hora: '',
      imei: '',
      transporte: '',
      contrato: '',
      titular: '',
      dni: '',
      domicilio: '',
      cp: '',
      latitud: 0,
      longitud: 0,
      autorizado: '',
      observaciones: '',
      idCabCertificacion: 0,
      idRemitoProveedor: 0,
      idSubconUsrWeb: 0,
      fechaAlta: '',
      fechaEnvio: '',
      fechaDistribucion: '',
      entreCalles: '',
      mail: '',
      telefonos: '',
      localidad: '',
      tag: 0,
      provincia: '',
      fechaEntregaCliente: '',
      scaneadoIn: '',
      scaneadoOut: '',
      ingresoDeposito: 0,
      salidaDistribucion: 0,
      idRuta: 0,
      nroSecuencia: 0,
      fechaHoraOptimoCamino: '',
      bultos: 0,
      peso: '',
      alto: '',
      ancho: '',
      largo: '',
      idComprobante: 0,
      enviarMailSegunEstado: '',
      fechaRuta: '',
      ordenIDparaOC: '',
      hashUnico: '',
      bultosPikeados: 0,
      centroDistribucion: '',
      fechaUltimaActualizacion: '',
      volumen: '',
      avonZoneNumber: 0,
      avonSectorNumber: 0,
      avonAccountNumber: '',
      avonCampaignNumber: 0,
      avonCampaignYear: 0,
      domicilioCorregido: '',
      domicilioCorregidoUsando: 0,
      urlFirma: '',
      urlDNI: '',
      ultimoIdMotivo: 0,
      ultimaNotaFletero: '',
      idComprobanteDevolucion: 0,
      turno: '',
      barrioEntrega: '',
      partidoEntrega: '',
      avonDayRoute: 0,
      avonTravelRoute: 0,
      avonSecuenceRoute: 0,
      avonInformarInclusion: 0);

  List<ParadaEnvio> _paradasenvios = [];
  List<ParadaEnvio> _paradasenviosdb = [];

  int _nroReg = 0;

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
    return RefreshIndicator(
      onRefresh: _llenarparadasenvios,
      child: ListView(
        children: _paradasenvios.map((e) {
          return Card(
            color: Colors.white60,
            shadowColor: Colors.white,
            elevation: 10,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                paradaenvioSelected = e;
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
                                                          color: Colors.purple,
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
      ),
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
      await _llenarparadasenvios();
    }
  }

  _navegar(e) async {
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

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParadaMapScreen(
            user: widget.user,
            positionUser: widget.positionUser,
            paradaenvio: e,
            markers: _markers,
          ),
        ),
      );
    } else {
      await showAlertDialog(
          context: context,
          title: 'Aviso!',
          message: "Necesita estar conectado a Internet para acceder al mapa",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

  _navegartodos() async {
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

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParadaMapScreen(
            user: widget.user,
            positionUser: widget.positionUser,
            paradaenvio: _paradasenvios[0],
            markers: _markers,
          ),
        ),
      );
    } else {
      await showAlertDialog(
          context: context,
          title: 'Aviso!',
          message: "Necesita estar conectado a Internet para acceder al mapa",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
  }

  Future<void> _llenarparadasenvios() async {
    _paradasenvios = [];
    widget.paradasenvios.forEach((paradasenvio) {
      _paradasenvios.add(paradasenvio);
    });
    _paradasenviosdb = await DBParadasEnvios.paradasenvios();

    _paradasenviosdb.forEach((paradaenvio) {
      if (DateTime.parse(paradaenvio.fecha!)
              .isBefore(DateTime.now().add(Duration(days: -7))) &&
          paradaenvio.enviado != 0) {
        DBParadasEnvios.delete(paradaenvio);
      }
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

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _showLoader = true;
      });

      _paradasenviosdb.forEach((paradaenvio) {
        if (paradaenvio.enviado == 0) {
          _putParada(paradaenvio);
        }
      });

      setState(() {
        _showLoader = false;
      });
    }

    setState(() {});
  }

  void _putParada(ParadaEnvio paradaenvio) async {
    widget.paradas.forEach((element) {
      if (element.idParada == paradaenvio.idParada) {
        paradaSelected = element;
      }
    });

    Map<String, dynamic> requestParada = {
      'idParada': paradaSelected.idParada,
      'idRuta': paradaSelected.idRuta,
      'idEnvio': paradaSelected.idEnvio,
      'tag': paradaSelected.tag,
      'secuencia': paradaSelected.secuencia,
      'leyenda': paradaSelected.leyenda,
      'latitud': paradaSelected.latitud,
      'longitud': paradaSelected.longitud,
      'iconoPropio': paradaSelected.iconoPropio,
      'iDmapa': paradaSelected.iDmapa,
      'distancia': paradaSelected.distancia,
      'tiempo': paradaSelected.tiempo,
      'estado': paradaenvio.estado,
      'fecha': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'hora': DateFormat('HH:mm').format(DateTime.now()),
      'idMotivo': paradaenvio.motivo,
      'notaChofer': paradaenvio.notas,
      'nuevoOrden': paradaSelected.nuevoOrden,
      'idCabCertificacion': paradaSelected.idCabCertificacion,
      'idLiquidacionFletero': paradaSelected.idLiquidacionFletero,
      'turno': paradaSelected.turno,
    };

    Response response = await ApiHelper.put(
        '/api/Paradas/', paradaSelected.idParada.toString(), requestParada);

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
    _putEnvio(paradaenvio);
  }

  void _putEnvio(ParadaEnvio paradaenvio) async {
    widget.envios.forEach((element) {
      if (element.idEnvio == paradaenvio.idEnvio) {
        envioSelected = element;
      }
    });

    Map<String, dynamic> requestEnvio = {
      'idEnvio': envioSelected.idEnvio,
      'idproveedor': envioSelected.idproveedor,
      'agencianr': envioSelected.agencianr,
      'estado': paradaenvio.estado,
      'envia': envioSelected.envia,
      'ruta': envioSelected.ruta,
      'ordenid': envioSelected.ordenid,
      'fecha': envioSelected.fecha,
      'hora': envioSelected.hora,
      'imei': envioSelected.imei,
      'transporte': envioSelected.transporte,
      'contrato': envioSelected.contrato,
      'titular': envioSelected.titular,
      'dni': envioSelected.dni,
      'domicilio': envioSelected.domicilio,
      'cp': envioSelected.cp,
      'latitud': envioSelected.latitud,
      'longitud': envioSelected.longitud,
      'autorizado': envioSelected.autorizado,
      'observaciones': envioSelected.observaciones,
      'idCabCertificacion': envioSelected.idCabCertificacion,
      'idRemitoProveedor': envioSelected.idRemitoProveedor,
      'idSubconUsrWeb': envioSelected.idSubconUsrWeb,
      'fechaAlta': envioSelected.fechaAlta,
      'fechaEnvio': envioSelected.fechaEnvio,
      'fechaDistribucion': envioSelected.fechaDistribucion,
      'entreCalles': envioSelected.entreCalles,
      'mail': envioSelected.mail,
      'telefonos': envioSelected.telefonos,
      'localidad': envioSelected.localidad,
      'tag': envioSelected.tag,
      'provincia': envioSelected.provincia,
      'fechaEntregaCliente': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'scaneadoIn': envioSelected.scaneadoIn,
      'scaneadoOut': envioSelected.scaneadoOut,
      'ingresoDeposito': envioSelected.ingresoDeposito,
      'salidaDistribucion': envioSelected.salidaDistribucion,
      'idRuta': envioSelected.idRuta,
      'nroSecuencia': envioSelected.nroSecuencia,
      'fechaHoraOptimoCamino': envioSelected.fechaHoraOptimoCamino,
      'bultos': envioSelected.bultos,
      'peso': envioSelected.peso,
      'alto': envioSelected.alto,
      'ancho': envioSelected.ancho,
      'largo': envioSelected.largo,
      'idComprobante': envioSelected.idComprobante,
      'enviarMailSegunEstado': envioSelected.enviarMailSegunEstado,
      'fechaRuta': envioSelected.fechaRuta,
      'ordenIDparaOC': envioSelected.ordenIDparaOC,
      'hashUnico': envioSelected.hashUnico,
      'bultosPikeados': envioSelected.bultosPikeados,
      'centroDistribucion': envioSelected.centroDistribucion,
      'fechaUltimaActualizacion':
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'volumen': envioSelected.volumen,
      'avonZoneNumber': envioSelected.avonZoneNumber,
      'avonSectorNumber': envioSelected.avonSectorNumber,
      'avonAccountNumber': envioSelected.avonAccountNumber,
      'avonCampaignNumber': envioSelected.avonCampaignNumber,
      'avonCampaignYear': envioSelected.avonCampaignYear,
      'domicilioCorregido': envioSelected.domicilioCorregido,
      'domicilioCorregidoUsando': envioSelected.domicilioCorregidoUsando,
      'urlFirma': envioSelected.urlFirma,
      'urlDNI': envioSelected.urlDNI,
      'ultimoIdMotivo': paradaenvio.motivo,
      'ultimaNotaFletero': paradaenvio.notas,
      'idComprobanteDevolucion': envioSelected.idComprobanteDevolucion,
      'turno': envioSelected.turno,
      'barrioEntrega': envioSelected.barrioEntrega,
      'partidoEntrega': envioSelected.partidoEntrega,
      'avonDayRoute': envioSelected.avonDayRoute,
      'avonTravelRoute': envioSelected.avonTravelRoute,
      'avonSecuenceRoute': envioSelected.avonSecuenceRoute,
      'avonInformarInclusion': envioSelected.avonInformarInclusion,
    };

    Response response = await ApiHelper.put(
        '/api/Envios/', envioSelected.idEnvio.toString(), requestEnvio);

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

    _postSeguimiento(paradaenvio);
  }

  void _postSeguimiento(ParadaEnvio paradaenvio) async {
    int fec = DateTime.now().difference(DateTime(2022, 01, 01)).inDays + 80723;

    Response response2 = await ApiHelper.getNroRegistroMax();
    if (response2.isSuccess) {
      _nroReg = int.parse(response2.result.toString()) + 1;
    }

    Map<String, dynamic> requestSeguimiento = {
      'id': _nroReg,
      'idenvio': paradaenvio.idEnvio,
      'idetapa': paradaenvio.estado,
      'estado': paradaenvio.estado,
      'idusuario': widget.user.idUser,
      'fecha': fec,
      'hora': DateFormat('HH:mm').format(DateTime.now()),
      'observaciones': 'Informada x Ws App',
      'motivo': paradaenvio.motivodesc,
      'notachofer': paradaenvio.notas,
    };

    Response response = await ApiHelper.post(
      '/api/Seguimientos',
      requestSeguimiento,
    );

    _ponerEnviado1(paradaenvio);
  }

  void _ponerEnviado1(ParadaEnvio paradaenvio) {
    ParadaEnvio paradaenvionueva = ParadaEnvio(
        idParada: paradaenvio.idParada,
        idRuta: paradaenvio.idRuta,
        idEnvio: paradaenvio.idEnvio,
        secuencia: paradaenvio.secuencia,
        leyenda: paradaenvio.leyenda,
        latitud: paradaenvio.latitud,
        longitud: paradaenvio.longitud,
        idproveedor: paradaenvio.idproveedor,
        estado: paradaenvio.estado,
        ordenid: paradaenvio.ordenid,
        titular: paradaenvio.titular,
        dni: paradaenvio.dni,
        domicilio: paradaenvio.domicilio,
        cp: paradaenvio.cp,
        entreCalles: paradaenvio.entreCalles,
        telefonos: paradaenvio.telefonos,
        localidad: paradaenvio.localidad,
        bultos: paradaenvio.bultos,
        proveedor: paradaenvio.proveedor,
        motivo: paradaenvio.motivo,
        motivodesc: paradaenvio.motivodesc,
        notas: paradaenvio.notas,
        enviado: 1,
        fecha: paradaenvio.fecha);

    DBParadasEnvios.update(paradaenvionueva);
  }
}
