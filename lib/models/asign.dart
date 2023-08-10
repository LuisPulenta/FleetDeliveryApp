class Asign {
  int idregistro = 0;
  String? subagentemercado = '';
  String? recupidjobcard = '';
  String? cliente = '';
  String? nombre = '';
  String? domicilio = '';
  String? entrecallE1 = '';
  String? entrecallE2 = '';
  String? cp = '';
  String? ztecnico = '';
  String? provincia = '';
  String? localidad = '';
  String? telefono = '';
  String? grxx = '';
  String? gryy = '';
  String? decO1 = '';
  String? cmodeM1 = '';
  String? fechacarga = '';
  String? estado = '';
  String? fechaent = '';
  String? tecasig = '';
  String? zona = '';
  String? idr = '';
  String? modelo = '';
  String? smartcard = '';
  String? ruta = '';
  String? estadO2 = '';
  String? estadO3 = '';
  String? tarifa = '';
  String? proyectomodulo = '';
  String? fechacaptura = '';
  String? estadogaos = '';
  String? fechacumplida = '';
  int? bajasistema = 0;
  int? idcabeceracertif = 0;
  String? subcon = '';
  String? causantec = '';
  int? pasaDefinitiva = 0;
  String? fechaAsignada = '';
  int? hsCaptura = 0;
  int? hsAsignada = 0;
  int? hsCumplida = 0;
  String? observacion = '';
  String? linkFoto = '';
  int? userID = 0;
  String? hsCumplidaTime = '';
  String? terminalAsigna = '';
  String? urlDni = '';
  String? urlFirma = '';
  String? urlDni2 = '';
  String? urlFirma2 = '';
  int? esCR = 0;
  int? autonumerico = 0;
  int? reclamoTecnicoID = 0;
  int? clienteTipoId = 0;
  String? documento = '';
  String? partido = '';
  String? emailCliente = '';
  String? observacionCaptura = '';
  String? fechaInicio = '';
  String? fechaEnvio = '';
  String? marcaModeloId = '';
  String? enviado = '';
  int? cancelado = 0;
  int? recupero = 0;
  int? codigoCierre = 0;
  int? visitaTecnica = 0;
  String? novedades = '';
  int? pdfGenerado = 0;
  String? fechaCumplidaTecnico = '';
  int? archivoOutGenerado = 0;
  String? idSuscripcion = '';
  String? itemsID = '';
  String? sectorOperativo = '';
  String? idTipoTrabajoRel = '';
  String? motivos = '';
  int? elegir = 0;
  int? elegirSI = 0;
  int? elegirNO = 0;
  String? fc_inicio_base = '';
  String? vc_fin_base = '';
  String? fechaCita = '';
  String? medioCita = '';
  String? nroSeriesExtras = '';
  String? fechaEvento1 = '';
  String? fechaEvento2 = '';
  String? fechaEvento3 = '';
  String? fechaEvento4 = '';
  String? evento1 = '';
  String? evento2 = '';
  String? evento3 = '';
  String? evento4 = '';
  int? escames = 0;
  int? escaanio = 0;
  String? estado4 = '';
  int? loteNro = 0;
  String? fechabaja = '';
  String? tipocliente = '';
  double? incentivo = 0.0;
  double? desconexion = 0.0;
  double? quincena = 0.0;
  int? impreso = 0;
  int? idusercambio = 0;
  String? franjaentrega = '';
  String? telefAlternativo1 = '';
  String? telefAlternativo2 = '';
  String? telefAlternativo3 = '';
  String? telefAlternativo4 = '';
  int? tag1 = 0;
  String? tipotel1 = '';
  String? tipotel2 = '';
  String? tipotel3 = '';
  String? tipotel4 = '';
  String? valorunico = '';
  String? descripcion = '';
  int? cierraenapp = 0;
  int? nomostrarapp = 0;
  String? codigoequivalencia = '';
  String? deco1descripcion = '';

  String? clienteCompleto = '';
  String? entreCalles = '';
  int? activo = 0;
  int? marcado = 0;

  Asign(
      {required this.idregistro,
      required this.subagentemercado,
      required this.recupidjobcard,
      required this.cliente,
      required this.nombre,
      required this.domicilio,
      required this.entrecallE1,
      required this.entrecallE2,
      required this.cp,
      required this.ztecnico,
      required this.provincia,
      required this.localidad,
      required this.telefono,
      required this.grxx,
      required this.gryy,
      required this.decO1,
      required this.cmodeM1,
      required this.fechacarga,
      required this.estado,
      required this.fechaent,
      required this.tecasig,
      required this.zona,
      required this.idr,
      required this.modelo,
      required this.smartcard,
      required this.ruta,
      required this.estadO2,
      required this.estadO3,
      required this.tarifa,
      required this.proyectomodulo,
      required this.fechacaptura,
      required this.estadogaos,
      required this.fechacumplida,
      required this.bajasistema,
      required this.idcabeceracertif,
      required this.subcon,
      required this.causantec,
      required this.pasaDefinitiva,
      required this.fechaAsignada,
      required this.hsCaptura,
      required this.hsAsignada,
      required this.hsCumplida,
      required this.observacion,
      required this.linkFoto,
      required this.userID,
      required this.hsCumplidaTime,
      required this.terminalAsigna,
      required this.urlDni,
      required this.urlFirma,
      required this.urlDni2,
      required this.urlFirma2,
      required this.esCR,
      required this.autonumerico,
      required this.reclamoTecnicoID,
      required this.clienteTipoId,
      required this.documento,
      required this.partido,
      required this.emailCliente,
      required this.observacionCaptura,
      required this.fechaInicio,
      required this.fechaEnvio,
      required this.marcaModeloId,
      required this.enviado,
      required this.cancelado,
      required this.recupero,
      required this.codigoCierre,
      required this.visitaTecnica,
      required this.novedades,
      required this.pdfGenerado,
      required this.fechaCumplidaTecnico,
      required this.archivoOutGenerado,
      required this.idSuscripcion,
      required this.itemsID,
      required this.sectorOperativo,
      required this.idTipoTrabajoRel,
      required this.motivos,
      required this.elegir,
      required this.elegirSI,
      required this.elegirNO,
      required this.fc_inicio_base,
      required this.vc_fin_base,
      required this.fechaCita,
      required this.medioCita,
      required this.nroSeriesExtras,
      required this.fechaEvento1,
      required this.fechaEvento2,
      required this.fechaEvento3,
      required this.fechaEvento4,
      required this.evento1,
      required this.evento2,
      required this.evento3,
      required this.evento4,
      required this.escames,
      required this.escaanio,
      required this.estado4,
      required this.loteNro,
      required this.fechabaja,
      required this.tipocliente,
      required this.incentivo,
      required this.desconexion,
      required this.quincena,
      required this.impreso,
      required this.idusercambio,
      required this.franjaentrega,
      required this.telefAlternativo1,
      required this.telefAlternativo2,
      required this.telefAlternativo3,
      required this.telefAlternativo4,
      required this.tag1,
      required this.tipotel1,
      required this.tipotel2,
      required this.tipotel3,
      required this.tipotel4,
      required this.valorunico,
      required this.clienteCompleto,
      required this.entreCalles,
      required this.descripcion,
      required this.cierraenapp,
      required this.nomostrarapp,
      required this.codigoequivalencia,
      required this.deco1descripcion,
      required this.activo,
      required this.marcado});

  Asign.fromJson(Map<String, dynamic> json) {
    idregistro = json['idregistro'];
    subagentemercado = json['subagentemercado'];
    recupidjobcard = json['recupidjobcard'];
    cliente = json['cliente'];
    nombre = json['nombre'];
    domicilio = json['domicilio'];
    entrecallE1 = json['entrecallE1'];
    entrecallE2 = json['entrecallE2'];
    cp = json['cp'];
    ztecnico = json['ztecnico'];
    provincia = json['provincia'];
    localidad = json['localidad'];
    telefono = json['telefono'];
    grxx = json['grxx'];
    gryy = json['gryy'];
    decO1 = json['decO1'];
    cmodeM1 = json['cmodeM1'];
    fechacarga = json['fechacarga'];
    estado = json['estado'];
    fechaent = json['fechaent'];
    tecasig = json['tecasig'];
    zona = json['zona'];
    idr = json['idr'];
    modelo = json['modelo'];
    smartcard = json['smartcard'];
    ruta = json['ruta'];
    estadO2 = json['estadO2'];
    estadO3 = json['estadO3'];
    tarifa = json['tarifa'];
    proyectomodulo = json['proyectomodulo'];
    fechacaptura = json['fechacaptura'];
    estadogaos = json['estadogaos'];
    fechacumplida = json['fechacumplida'];
    bajasistema = json['bajasistema'];
    idcabeceracertif = json['idcabeceracertif'];
    subcon = json['subcon'];
    causantec = json['causantec'];
    pasaDefinitiva = json['pasaDefinitiva'];
    fechaAsignada = json['fechaAsignada'];
    hsCaptura = json['hsCaptura'];
    hsAsignada = json['hsAsignada'];
    hsCumplida = json['hsCumplida'];
    observacion = json['observacion'];
    linkFoto = json['linkFoto'];
    userID = json['userID'];
    hsCumplidaTime = json['hsCumplidaTime'];
    terminalAsigna = json['terminalAsigna'];
    urlDni = json['urlDni'];
    urlFirma = json['urlFirma'];
    urlDni2 = json['urlDni2'];
    urlFirma2 = json['urlFirma2'];
    esCR = json['esCR'];
    autonumerico = json['autonumerico'];
    reclamoTecnicoID = json['reclamoTecnicoID'];
    clienteTipoId = json['clienteTipoId'];
    documento = json['documento'];
    partido = json['partido'];
    emailCliente = json['emailCliente'];
    observacionCaptura = json['observacionCaptura'];
    fechaInicio = json['fechaInicio'];
    fechaEnvio = json['fechaEnvio'];
    marcaModeloId = json['marcaModeloId'];
    enviado = json['enviado'];
    cancelado = json['cancelado'];
    recupero = json['recupero'];
    codigoCierre = json['codigoCierre'];
    visitaTecnica = json['visitaTecnica'];
    novedades = json['novedades'];
    pdfGenerado = json['pdfGenerado'];
    fechaCumplidaTecnico = json['fechaCumplidaTecnico'];
    archivoOutGenerado = json['archivoOutGenerado'];
    idSuscripcion = json['idSuscripcion'];
    itemsID = json['itemsID'];
    sectorOperativo = json['sectorOperativo'];
    idTipoTrabajoRel = json['idTipoTrabajoRel'];
    motivos = json['motivos'];
    elegir = json['elegir'];
    elegirSI = json['elegirSI'];
    elegirNO = json['elegirNO'];
    fc_inicio_base = json['fc_inicio_base'];
    vc_fin_base = json['vc_fin_base'];
    fechaCita = json['fechaCita'];
    medioCita = json['medioCita'];
    nroSeriesExtras = json['nroSeriesExtras'];
    fechaEvento1 = json['fechaEvento1'];
    fechaEvento2 = json['fechaEvento2'];
    fechaEvento3 = json['fechaEvento3'];
    fechaEvento4 = json['fechaEvento4'];
    evento1 = json['evento1'];
    evento2 = json['evento2'];
    evento3 = json['evento3'];
    evento4 = json['evento4'];
    escames = json['escames'];
    escaanio = json['escaanio'];
    estado4 = json['estado4'];
    loteNro = json['loteNro'];
    fechabaja = json['fechabaja'];
    tipocliente = json['tipocliente'];
    incentivo = json['incentivo'];
    desconexion = json['desconexion'];
    quincena = json['quincena'];
    impreso = json['impreso'];
    idusercambio = json['idusercambio'];
    franjaentrega = json['franjaentrega'];
    telefAlternativo1 = json['telefAlternativo1'];
    telefAlternativo2 = json['telefAlternativo2'];
    telefAlternativo3 = json['telefAlternativo3'];
    telefAlternativo4 = json['telefAlternativo4'];
    tag1 = json['tag1'];
    tipotel1 = json['tipotel1'];
    tipotel2 = json['tipotel2'];
    tipotel3 = json['tipotel3'];
    tipotel4 = json['tipotel4'];
    valorunico = json['valorunico'];
    clienteCompleto = json['clienteCompleto'];
    entreCalles = json['entreCalles'];
    descripcion = json['descripcion'];
    cierraenapp = json['cierraenapp'];
    nomostrarapp = json['nomostrarapp'];
    codigoequivalencia = json['codigoequivalencia'];
    deco1descripcion = json['deco1descripcion'];
    activo = json['activo'];
    marcado = json['marcado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idregistro'] = idregistro;
    data['subagentemercado'] = subagentemercado;
    data['recupidjobcard'] = recupidjobcard;
    data['cliente'] = cliente;
    data['nombre'] = nombre;
    data['domicilio'] = domicilio;
    data['entrecallE1'] = entrecallE1;
    data['entrecallE2'] = entrecallE2;
    data['cp'] = cp;
    data['ztecnico'] = ztecnico;
    data['provincia'] = provincia;
    data['localidad'] = localidad;
    data['telefono'] = telefono;
    data['grxx'] = grxx;
    data['gryy'] = gryy;
    data['decO1'] = decO1;
    data['cmodeM1'] = cmodeM1;
    data['fechacarga'] = fechacarga;
    data['estado'] = estado;
    data['fechaent'] = fechaent;
    data['tecasig'] = tecasig;
    data['zona'] = zona;
    data['idr'] = idr;
    data['modelo'] = modelo;
    data['smartcard'] = smartcard;
    data['ruta'] = ruta;
    data['estadO2'] = estadO2;
    data['estadO3'] = estadO3;
    data['tarifa'] = tarifa;
    data['proyectomodulo'] = proyectomodulo;
    data['fechacaptura'] = fechacaptura;
    data['estadogaos'] = estadogaos;
    data['fechacumplida'] = fechacumplida;
    data['bajasistema'] = bajasistema;
    data['idcabeceracertif'] = idcabeceracertif;
    data['subcon'] = subcon;
    data['causantec'] = causantec;
    data['pasaDefinitiva'] = pasaDefinitiva;
    data['fechaAsignada'] = fechaAsignada;
    data['hsCaptura'] = hsCaptura;
    data['hsAsignada'] = hsAsignada;
    data['hsCumplida'] = hsCumplida;
    data['observacion'] = observacion;
    data['linkFoto'] = linkFoto;
    data['userID'] = userID;
    data['hsCumplidaTime'] = hsCumplidaTime;
    data['terminalAsigna'] = terminalAsigna;
    data['urlDni'] = urlDni;
    data['urlFirma'] = urlFirma;
    data['urlDni2'] = urlDni2;
    data['urlFirma2'] = urlFirma2;
    data['esCR'] = esCR;
    data['autonumerico'] = autonumerico;
    data['reclamoTecnicoID'] = reclamoTecnicoID;
    data['clienteTipoId'] = clienteTipoId;
    data['documento'] = documento;
    data['partido'] = partido;
    data['emailCliente'] = emailCliente;
    data['observacionCaptura'] = observacionCaptura;
    data['fechaInicio'] = fechaInicio;
    data['fechaEnvio'] = fechaEnvio;
    data['marcaModeloId'] = marcaModeloId;
    data['enviado'] = enviado;
    data['cancelado'] = cancelado;
    data['recupero'] = recupero;
    data['codigoCierre'] = codigoCierre;
    data['visitaTecnica'] = visitaTecnica;
    data['novedades'] = novedades;
    data['pdfGenerado'] = pdfGenerado;
    data['fechaCumplidaTecnico'] = fechaCumplidaTecnico;
    data['archivoOutGenerado'] = archivoOutGenerado;
    data['idSuscripcion'] = idSuscripcion;
    data['itemsID'] = itemsID;
    data['sectorOperativo'] = sectorOperativo;
    data['idTipoTrabajoRel'] = idTipoTrabajoRel;
    data['motivos'] = motivos;
    data['elegir'] = elegir;
    data['elegirSI'] = elegirSI;
    data['elegirNO'] = elegirNO;
    data['fc_inicio_base'] = fc_inicio_base;
    data['vc_fin_base'] = vc_fin_base;
    data['fechaCita'] = fechaCita;
    data['medioCita'] = medioCita;
    data['nroSeriesExtras'] = nroSeriesExtras;
    data['fechaEvento1'] = fechaEvento1;
    data['fechaEvento2'] = fechaEvento2;
    data['fechaEvento3'] = fechaEvento3;
    data['fechaEvento4'] = fechaEvento4;
    data['evento1'] = evento1;
    data['evento2'] = evento2;
    data['evento3'] = evento3;
    data['evento4'] = evento4;
    data['escames'] = escames;
    data['escaanio'] = escaanio;
    data['estado4'] = estado4;
    data['loteNro'] = loteNro;
    data['fechabaja'] = fechabaja;
    data['tipocliente'] = tipocliente;
    data['incentivo'] = incentivo;
    data['desconexion'] = desconexion;
    data['quincena'] = quincena;
    data['impreso'] = impreso;
    data['idusercambio'] = idusercambio;
    data['franjaentrega'] = franjaentrega;
    data['telefAlternativo1'] = telefAlternativo1;
    data['telefAlternativo2'] = telefAlternativo2;
    data['telefAlternativo3'] = telefAlternativo3;
    data['telefAlternativo4'] = telefAlternativo4;
    data['tag1'] = tag1;
    data['tipotel1'] = tipotel1;
    data['tipotel2'] = tipotel2;
    data['tipotel3'] = tipotel3;
    data['tipotel4'] = tipotel4;
    data['valorunico'] = valorunico;
    data['clienteCompleto'] = clienteCompleto;
    data['entreCalles'] = entreCalles;
    data['descripcion'] = descripcion;
    data['cierraenapp'] = cierraenapp;
    data['nomostrarapp'] = nomostrarapp;
    data['codigoequivalencia'] = codigoequivalencia;
    data['deco1descripcion'] = deco1descripcion;
    data['activo'] = activo;
    data['marcado'] = marcado;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idregistro': idregistro,
      'subagentemercado': subagentemercado,
      'recupidjobcard': recupidjobcard,
      'cliente': cliente,
      'nombre': nombre,
      'domicilio': domicilio,
      'entrecallE1': entrecallE1,
      'entrecallE2': entrecallE2,
      'cp': cp,
      'ztecnico': ztecnico,
      'provincia': provincia,
      'localidad': localidad,
      'telefono': telefono,
      'grxx': grxx,
      'gryy': gryy,
      'decO1': decO1,
      'cmodeM1': cmodeM1,
      'fechacarga': fechacarga,
      'estado': estado,
      'fechaent': fechaent,
      'tecasig': tecasig,
      'zona': zona,
      'idr': idr,
      'modelo': modelo,
      'smartcard': smartcard,
      'ruta': ruta,
      'estadO2': estadO2,
      'estadO3': estadO3,
      'tarifa': tarifa,
      'proyectomodulo': proyectomodulo,
      'fechacaptura': fechacaptura,
      'estadogaos': estadogaos,
      'fechacumplida': fechacumplida,
      'bajasistema': bajasistema,
      'idcabeceracertif': idcabeceracertif,
      'subcon': subcon,
      'causantec': causantec,
      'pasaDefinitiva': pasaDefinitiva,
      'fechaAsignada': fechaAsignada,
      'hsCaptura': hsCaptura,
      'hsAsignada': hsAsignada,
      'hsCumplida': hsCumplida,
      'observacion': observacion,
      'linkFoto': linkFoto,
      'userID': userID,
      'hsCumplidaTime': hsCumplidaTime,
      'terminalAsigna': terminalAsigna,
      'urlDni': urlDni,
      'urlFirma': urlFirma,
      'urlDni2': urlDni2,
      'urlFirma2': urlFirma2,
      'esCR': esCR,
      'autonumerico': autonumerico,
      'reclamoTecnicoID': reclamoTecnicoID,
      'clienteTipoId': clienteTipoId,
      'documento': documento,
      'partido': partido,
      'emailCliente': emailCliente,
      'observacionCaptura': observacionCaptura,
      'fechaInicio': fechaInicio,
      'fechaEnvio': fechaEnvio,
      'marcaModeloId': marcaModeloId,
      'enviado': enviado,
      'cancelado': cancelado,
      'recupero': recupero,
      'codigoCierre': codigoCierre,
      'visitaTecnica': visitaTecnica,
      'novedades': novedades,
      'pdfGenerado': pdfGenerado,
      'fechaCumplidaTecnico': fechaCumplidaTecnico,
      'archivoOutGenerado': archivoOutGenerado,
      'idSuscripcion': idSuscripcion,
      'itemsID': itemsID,
      'sectorOperativo': sectorOperativo,
      'idTipoTrabajoRel': idTipoTrabajoRel,
      'motivos': motivos,
      'elegir': elegir,
      'elegirSI': elegirSI,
      'elegirNO': elegirNO,
      'fc_inicio_base': fc_inicio_base,
      'vc_fin_base': vc_fin_base,
      'fechaCita': fechaCita,
      'medioCita': medioCita,
      'nroSeriesExtras': nroSeriesExtras,
      'fechaEvento1': fechaEvento1,
      'fechaEvento2': fechaEvento2,
      'fechaEvento3': fechaEvento3,
      'fechaEvento4': fechaEvento4,
      'evento1': evento1,
      'evento2': evento2,
      'evento3': evento3,
      'evento4': evento4,
      'escames': escames,
      'escaanio': escaanio,
      'estado4': estado4,
      'loteNro': loteNro,
      'fechabaja': fechabaja,
      'tipocliente': tipocliente,
      'incentivo': incentivo,
      'desconexion': desconexion,
      'quincena': quincena,
      'impreso': impreso,
      'idusercambio': idusercambio,
      'franjaentrega': franjaentrega,
      'telefAlternativo1': telefAlternativo1,
      'telefAlternativo2': telefAlternativo2,
      'telefAlternativo3': telefAlternativo3,
      'telefAlternativo4': telefAlternativo4,
      'tag1': tag1,
      'tipotel1': tipotel1,
      'tipotel2': tipotel2,
      'tipotel3': tipotel3,
      'tipotel4': tipotel4,
      'valorunico': valorunico,
      'clienteCompleto': clienteCompleto,
      'entreCalles': entreCalles,
      'descripcion': descripcion,
      'cierraenapp': cierraenapp,
      'nomostrarapp': nomostrarapp,
      'codigoequivalencia': codigoequivalencia,
      'deco1descripcion': deco1descripcion,
      'activo': activo,
      'marcado': marcado,
    };
  }
}
