class Envio {
  int idEnvio = 0;
  int? idproveedor = 0;
  int? agencianr = 0;
  int? estado = 0;
  String? envia = '';
  String? ruta = '';
  String? ordenid = '';
  int? fecha = 0;
  String? hora = '';
  String? imei = '';
  String? transporte = '';
  String? contrato = '';
  String? titular = '';
  String? dni = '';
  String? domicilio = '';
  String? cp = '';
  double? latitud = 0.0;
  double? longitud = 0.0;
  String? autorizado = '';
  String? observaciones = '';
  int? idCabCertificacion = 0;
  int? idRemitoProveedor = 0;
  int? idSubconUsrWeb = 0;
  String? fechaAlta = '';
  String? fechaEnvio = '';
  String? fechaDistribucion = '';
  String? entreCalles = '';
  String? mail = '';
  String? telefonos = '';
  String? localidad = '';
  int? tag = 0;
  String? provincia = '';
  String? fechaEntregaCliente = '';
  String? scaneadoIn = '';
  String? scaneadoOut = '';
  int? ingresoDeposito = 0;
  int? salidaDistribucion = 0;
  int? idRuta = 0;
  int? nroSecuencia = 0;
  String? fechaHoraOptimoCamino = '';
  int? bultos = 0;
  String? peso = '';
  String? alto = '';
  String? ancho = '';
  String? largo = '';
  int? idComprobante = 0;
  String? enviarMailSegunEstado = '';
  String? fechaRuta = '';
  String? ordenIDparaOC = '';
  String? hashUnico = '';
  int? bultosPikeados = 0;
  String? centroDistribucion = '';
  String? fechaUltimaActualizacion = '';
  String? volumen = '';
  int? avonZoneNumber = 0;
  int? avonSectorNumber = 0;
  String? avonAccountNumber = '';
  int? avonCampaignNumber = 0;
  int? avonCampaignYear = 0;
  String? domicilioCorregido = '';
  int? domicilioCorregidoUsando = 0;
  String? urlFirma = '';
  String? urlDNI = '';
  int? ultimoIdMotivo = 0;
  String? ultimaNotaFletero = '';
  int? idComprobanteDevolucion = 0;
  String? turno = '';
  String? barrioEntrega = '';
  String? partidoEntrega = '';
  int? avonDayRoute = 0;
  int? avonTravelRoute = 0;
  int? avonSecuenceRoute = 0;
  int? avonInformarInclusion = 0;
  String? urlDNIFullPath = '';

  Envio(
      {required this.idEnvio,
      required this.idproveedor,
      required this.agencianr,
      required this.estado,
      required this.envia,
      required this.ruta,
      required this.ordenid,
      required this.fecha,
      required this.hora,
      required this.imei,
      required this.transporte,
      required this.contrato,
      required this.titular,
      required this.dni,
      required this.domicilio,
      required this.cp,
      required this.latitud,
      required this.longitud,
      required this.autorizado,
      required this.observaciones,
      required this.idCabCertificacion,
      required this.idRemitoProveedor,
      required this.idSubconUsrWeb,
      required this.fechaAlta,
      required this.fechaEnvio,
      required this.fechaDistribucion,
      required this.entreCalles,
      required this.mail,
      required this.telefonos,
      required this.localidad,
      required this.tag,
      required this.provincia,
      required this.fechaEntregaCliente,
      required this.scaneadoIn,
      required this.scaneadoOut,
      required this.ingresoDeposito,
      required this.salidaDistribucion,
      required this.idRuta,
      required this.nroSecuencia,
      required this.fechaHoraOptimoCamino,
      required this.bultos,
      required this.peso,
      required this.alto,
      required this.ancho,
      required this.largo,
      required this.idComprobante,
      required this.enviarMailSegunEstado,
      required this.fechaRuta,
      required this.ordenIDparaOC,
      required this.hashUnico,
      required this.bultosPikeados,
      required this.centroDistribucion,
      required this.fechaUltimaActualizacion,
      required this.volumen,
      required this.avonZoneNumber,
      required this.avonSectorNumber,
      required this.avonAccountNumber,
      required this.avonCampaignNumber,
      required this.avonCampaignYear,
      required this.domicilioCorregido,
      required this.domicilioCorregidoUsando,
      required this.urlFirma,
      required this.urlDNI,
      required this.ultimoIdMotivo,
      required this.ultimaNotaFletero,
      required this.idComprobanteDevolucion,
      required this.turno,
      required this.barrioEntrega,
      required this.partidoEntrega,
      required this.avonDayRoute,
      required this.avonTravelRoute,
      required this.avonSecuenceRoute,
      required this.avonInformarInclusion,
      required this.urlDNIFullPath});

  Envio.fromJson(Map<String, dynamic> json) {
    idEnvio = json['idEnvio'];
    idproveedor = json['idproveedor'];
    agencianr = json['agencianr'];
    estado = json['estado'];
    envia = json['envia'];
    ruta = json['ruta'];
    ordenid = json['ordenid'];
    fecha = json['fecha'];
    hora = json['hora'];
    imei = json['imei'];
    transporte = json['transporte'];
    contrato = json['contrato'];
    titular = json['titular'];
    dni = json['dni'];
    domicilio = json['domicilio'];
    cp = json['cp'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    autorizado = json['autorizado'];
    observaciones = json['observaciones'];
    idCabCertificacion = json['idCabCertificacion'];
    idRemitoProveedor = json['idRemitoProveedor'];
    idSubconUsrWeb = json['idSubconUsrWeb'];
    fechaAlta = json['fechaAlta'];
    fechaEnvio = json['fechaEnvio'];
    fechaDistribucion = json['fechaDistribucion'];
    entreCalles = json['entreCalles'];
    mail = json['mail'];
    telefonos = json['telefonos'];
    localidad = json['localidad'];
    tag = json['tag'];
    provincia = json['provincia'];
    fechaEntregaCliente = json['fechaEntregaCliente'];
    scaneadoIn = json['scaneadoIn'];
    scaneadoOut = json['scaneadoOut'];
    ingresoDeposito = json['ingresoDeposito'];
    salidaDistribucion = json['salidaDistribucion'];
    idRuta = json['idRuta'];
    nroSecuencia = json['nroSecuencia'];
    fechaHoraOptimoCamino = json['fechaHoraOptimoCamino'];
    bultos = json['bultos'];
    peso = json['peso'];
    alto = json['alto'];
    ancho = json['ancho'];
    largo = json['largo'];
    idComprobante = json['idComprobante'];
    enviarMailSegunEstado = json['enviarMailSegunEstado'];
    fechaRuta = json['fechaRuta'];
    ordenIDparaOC = json['ordenIDparaOC'];
    hashUnico = json['hashUnico'];
    bultosPikeados = json['bultosPikeados'];
    centroDistribucion = json['centroDistribucion'];
    fechaUltimaActualizacion = json['fechaUltimaActualizacion'];
    volumen = json['volumen'];
    avonZoneNumber = json['avonZoneNumber'];
    avonSectorNumber = json['avonSectorNumber'];
    avonAccountNumber = json['avonAccountNumber'];
    avonCampaignNumber = json['avonCampaignNumber'];
    avonCampaignYear = json['avonCampaignYear'];
    domicilioCorregido = json['domicilioCorregido'];
    domicilioCorregidoUsando = json['domicilioCorregidoUsando'];
    urlFirma = json['urlFirma'];
    urlDNI = json['urlDNI'];
    ultimoIdMotivo = json['ultimoIdMotivo'];
    ultimaNotaFletero = json['ultimaNotaFletero'];
    idComprobanteDevolucion = json['idComprobanteDevolucion'];
    turno = json['turno'];
    barrioEntrega = json['barrioEntrega'];
    partidoEntrega = json['partidoEntrega'];
    avonDayRoute = json['avonDayRoute'];
    avonTravelRoute = json['avonTravelRoute'];
    avonSecuenceRoute = json['avonSecuenceRoute'];
    avonInformarInclusion = json['avonInformarInclusion'];
    urlDNIFullPath = json['urlDNIFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idEnvio'] = this.idEnvio;
    data['idproveedor'] = this.idproveedor;
    data['agencianr'] = this.agencianr;
    data['estado'] = this.estado;
    data['envia'] = this.envia;
    data['ruta'] = this.ruta;
    data['ordenid'] = this.ordenid;
    data['fecha'] = this.fecha;
    data['hora'] = this.hora;
    data['imei'] = this.imei;
    data['transporte'] = this.transporte;
    data['contrato'] = this.contrato;
    data['titular'] = this.titular;
    data['dni'] = this.dni;
    data['domicilio'] = this.domicilio;
    data['cp'] = this.cp;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['autorizado'] = this.autorizado;
    data['observaciones'] = this.observaciones;
    data['idCabCertificacion'] = this.idCabCertificacion;
    data['idRemitoProveedor'] = this.idRemitoProveedor;
    data['idSubconUsrWeb'] = this.idSubconUsrWeb;
    data['fechaAlta'] = this.fechaAlta;
    data['fechaEnvio'] = this.fechaEnvio;
    data['fechaDistribucion'] = this.fechaDistribucion;
    data['entreCalles'] = this.entreCalles;
    data['mail'] = this.mail;
    data['telefonos'] = this.telefonos;
    data['localidad'] = this.localidad;
    data['tag'] = this.tag;
    data['provincia'] = this.provincia;
    data['fechaEntregaCliente'] = this.fechaEntregaCliente;
    data['scaneadoIn'] = this.scaneadoIn;
    data['scaneadoOut'] = this.scaneadoOut;
    data['ingresoDeposito'] = this.ingresoDeposito;
    data['salidaDistribucion'] = this.salidaDistribucion;
    data['idRuta'] = this.idRuta;
    data['nroSecuencia'] = this.nroSecuencia;
    data['fechaHoraOptimoCamino'] = this.fechaHoraOptimoCamino;
    data['bultos'] = this.bultos;
    data['peso'] = this.peso;
    data['alto'] = this.alto;
    data['ancho'] = this.ancho;
    data['largo'] = this.largo;
    data['idComprobante'] = this.idComprobante;
    data['enviarMailSegunEstado'] = this.enviarMailSegunEstado;
    data['fechaRuta'] = this.fechaRuta;
    data['ordenIDparaOC'] = this.ordenIDparaOC;
    data['hashUnico'] = this.hashUnico;
    data['bultosPikeados'] = this.bultosPikeados;
    data['centroDistribucion'] = this.centroDistribucion;
    data['fechaUltimaActualizacion'] = this.fechaUltimaActualizacion;
    data['volumen'] = this.volumen;
    data['avonZoneNumber'] = this.avonZoneNumber;
    data['avonSectorNumber'] = this.avonSectorNumber;
    data['avonAccountNumber'] = this.avonAccountNumber;
    data['avonCampaignNumber'] = this.avonCampaignNumber;
    data['avonCampaignYear'] = this.avonCampaignYear;
    data['domicilioCorregido'] = this.domicilioCorregido;
    data['domicilioCorregidoUsando'] = this.domicilioCorregidoUsando;
    data['urlFirma'] = this.urlFirma;
    data['urlDNI'] = this.urlDNI;
    data['ultimoIdMotivo'] = this.ultimoIdMotivo;
    data['ultimaNotaFletero'] = this.ultimaNotaFletero;
    data['idComprobanteDevolucion'] = this.idComprobanteDevolucion;
    data['turno'] = this.turno;
    data['barrioEntrega'] = this.barrioEntrega;
    data['partidoEntrega'] = this.partidoEntrega;
    data['avonDayRoute'] = this.avonDayRoute;
    data['avonTravelRoute'] = this.avonTravelRoute;
    data['avonSecuenceRoute'] = this.avonSecuenceRoute;
    data['avonInformarInclusion'] = this.avonInformarInclusion;
    data['urlDNIFullPath'] = this.urlDNIFullPath;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idEnvio': idEnvio,
      'idproveedor': idproveedor,
      'agencianr': agencianr,
      'estado': estado,
      'envia': envia,
      'ruta': ruta,
      'ordenid': ordenid,
      'fecha': fecha,
      'hora': hora,
      'imei': imei,
      'transporte': transporte,
      'contrato': contrato,
      'titular': titular,
      'dni': dni,
      'domicilio': domicilio,
      'cp': cp,
      'latitud': latitud,
      'longitud': longitud,
      'autorizado': autorizado,
      'observaciones': observaciones,
      'idCabCertificacion': idCabCertificacion,
      'idRemitoProveedor': idRemitoProveedor,
      'idSubconUsrWeb': idSubconUsrWeb,
      'fechaAlta': fechaAlta,
      'fechaEnvio': fechaEnvio,
      'fechaDistribucion': fechaDistribucion,
      'entreCalles': entreCalles,
      'mail': mail,
      'telefonos': telefonos,
      'localidad': localidad,
      'tag': tag,
      'provincia': provincia,
      'fechaEntregaCliente': fechaEntregaCliente,
      'scaneadoIn': scaneadoIn,
      'scaneadoOut': scaneadoOut,
      'ingresoDeposito': ingresoDeposito,
      'salidaDistribucion': salidaDistribucion,
      'idRuta': idRuta,
      'nroSecuencia': nroSecuencia,
      'fechaHoraOptimoCamino': fechaHoraOptimoCamino,
      'bultos': bultos,
      'peso': peso,
      'alto': alto,
      'ancho': ancho,
      'largo': largo,
      'idComprobante': idComprobante,
      'enviarMailSegunEstado': enviarMailSegunEstado,
      'fechaRuta': fechaRuta,
      'ordenIDparaOC': ordenIDparaOC,
      'hashUnico': hashUnico,
      'bultosPikeados': bultosPikeados,
      'centroDistribucion': centroDistribucion,
      'fechaUltimaActualizacion': fechaUltimaActualizacion,
      'volumen': volumen,
      'avonZoneNumber': avonZoneNumber,
      'avonSectorNumber': avonSectorNumber,
      'avonAccountNumber': avonAccountNumber,
      'avonCampaignNumber': avonCampaignNumber,
      'avonCampaignYear': avonCampaignYear,
      'domicilioCorregido': domicilioCorregido,
      'domicilioCorregidoUsando': domicilioCorregidoUsando,
      'urlFirma': urlFirma,
      'urlDNI': urlDNI,
      'ultimoIdMotivo': ultimoIdMotivo,
      'ultimaNotaFletero': ultimaNotaFletero,
      'idComprobanteDevolucion': idComprobanteDevolucion,
      'turno': turno,
      'barrioEntrega': barrioEntrega,
      'partidoEntrega': partidoEntrega,
      'avonDayRoute': avonDayRoute,
      'avonTravelRoute': avonTravelRoute,
      'avonSecuenceRoute': avonSecuenceRoute,
      'avonInformarInclusion': avonInformarInclusion,
      'urlDNIFullPath': urlDNIFullPath,
    };
  }
}
