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
      {required idEnvio,
      required idproveedor,
      required agencianr,
      required estado,
      required envia,
      required ruta,
      required ordenid,
      required fecha,
      required hora,
      required imei,
      required transporte,
      required contrato,
      required titular,
      required dni,
      required domicilio,
      required cp,
      required latitud,
      required longitud,
      required autorizado,
      required observaciones,
      required idCabCertificacion,
      required idRemitoProveedor,
      required idSubconUsrWeb,
      required fechaAlta,
      required fechaEnvio,
      required fechaDistribucion,
      required entreCalles,
      required mail,
      required telefonos,
      required localidad,
      required tag,
      required provincia,
      required fechaEntregaCliente,
      required scaneadoIn,
      required scaneadoOut,
      required ingresoDeposito,
      required salidaDistribucion,
      required idRuta,
      required nroSecuencia,
      required fechaHoraOptimoCamino,
      required bultos,
      required peso,
      required alto,
      required ancho,
      required largo,
      required idComprobante,
      required enviarMailSegunEstado,
      required fechaRuta,
      required ordenIDparaOC,
      required hashUnico,
      required bultosPikeados,
      required centroDistribucion,
      required fechaUltimaActualizacion,
      required volumen,
      required avonZoneNumber,
      required avonSectorNumber,
      required avonAccountNumber,
      required avonCampaignNumber,
      required avonCampaignYear,
      required domicilioCorregido,
      required domicilioCorregidoUsando,
      required urlFirma,
      required urlDNI,
      required ultimoIdMotivo,
      required ultimaNotaFletero,
      required idComprobanteDevolucion,
      required turno,
      required barrioEntrega,
      required partidoEntrega,
      required avonDayRoute,
      required avonTravelRoute,
      required avonSecuenceRoute,
      required avonInformarInclusion,
      required urlDNIFullPath});

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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idEnvio'] = idEnvio;
    data['idproveedor'] = idproveedor;
    data['agencianr'] = agencianr;
    data['estado'] = estado;
    data['envia'] = envia;
    data['ruta'] = ruta;
    data['ordenid'] = ordenid;
    data['fecha'] = fecha;
    data['hora'] = hora;
    data['imei'] = imei;
    data['transporte'] = transporte;
    data['contrato'] = contrato;
    data['titular'] = titular;
    data['dni'] = dni;
    data['domicilio'] = domicilio;
    data['cp'] = cp;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['autorizado'] = autorizado;
    data['observaciones'] = observaciones;
    data['idCabCertificacion'] = idCabCertificacion;
    data['idRemitoProveedor'] = idRemitoProveedor;
    data['idSubconUsrWeb'] = idSubconUsrWeb;
    data['fechaAlta'] = fechaAlta;
    data['fechaEnvio'] = fechaEnvio;
    data['fechaDistribucion'] = fechaDistribucion;
    data['entreCalles'] = entreCalles;
    data['mail'] = mail;
    data['telefonos'] = telefonos;
    data['localidad'] = localidad;
    data['tag'] = tag;
    data['provincia'] = provincia;
    data['fechaEntregaCliente'] = fechaEntregaCliente;
    data['scaneadoIn'] = scaneadoIn;
    data['scaneadoOut'] = scaneadoOut;
    data['ingresoDeposito'] = ingresoDeposito;
    data['salidaDistribucion'] = salidaDistribucion;
    data['idRuta'] = idRuta;
    data['nroSecuencia'] = nroSecuencia;
    data['fechaHoraOptimoCamino'] = fechaHoraOptimoCamino;
    data['bultos'] = bultos;
    data['peso'] = peso;
    data['alto'] = alto;
    data['ancho'] = ancho;
    data['largo'] = largo;
    data['idComprobante'] = idComprobante;
    data['enviarMailSegunEstado'] = enviarMailSegunEstado;
    data['fechaRuta'] = fechaRuta;
    data['ordenIDparaOC'] = ordenIDparaOC;
    data['hashUnico'] = hashUnico;
    data['bultosPikeados'] = bultosPikeados;
    data['centroDistribucion'] = centroDistribucion;
    data['fechaUltimaActualizacion'] = fechaUltimaActualizacion;
    data['volumen'] = volumen;
    data['avonZoneNumber'] = avonZoneNumber;
    data['avonSectorNumber'] = avonSectorNumber;
    data['avonAccountNumber'] = avonAccountNumber;
    data['avonCampaignNumber'] = avonCampaignNumber;
    data['avonCampaignYear'] = avonCampaignYear;
    data['domicilioCorregido'] = domicilioCorregido;
    data['domicilioCorregidoUsando'] = domicilioCorregidoUsando;
    data['urlFirma'] = urlFirma;
    data['urlDNI'] = urlDNI;
    data['ultimoIdMotivo'] = ultimoIdMotivo;
    data['ultimaNotaFletero'] = ultimaNotaFletero;
    data['idComprobanteDevolucion'] = idComprobanteDevolucion;
    data['turno'] = turno;
    data['barrioEntrega'] = barrioEntrega;
    data['partidoEntrega'] = partidoEntrega;
    data['avonDayRoute'] = avonDayRoute;
    data['avonTravelRoute'] = avonTravelRoute;
    data['avonSecuenceRoute'] = avonSecuenceRoute;
    data['avonInformarInclusion'] = avonInformarInclusion;
    data['urlDNIFullPath'] = urlDNIFullPath;
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
