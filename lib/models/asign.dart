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
  String? controlesEquivalencia = '';
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
  String? telefAlternativo1 = '';
  String? telefAlternativo2 = '';
  String? telefAlternativo3 = '';
  String? telefAlternativo4 = '';
  String? clienteCompleto = '';
  String? entreCalles = '';

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
      required this.controlesEquivalencia,
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
      required this.telefAlternativo1,
      required this.telefAlternativo2,
      required this.telefAlternativo3,
      required this.telefAlternativo4,
      required this.clienteCompleto,
      required this.entreCalles});

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
    controlesEquivalencia = json['controlesEquivalencia'];
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
    telefAlternativo1 = json['telefAlternativo1'];
    telefAlternativo2 = json['telefAlternativo2'];
    telefAlternativo3 = json['telefAlternativo3'];
    telefAlternativo4 = json['telefAlternativo4'];
    clienteCompleto = json['clienteCompleto'];
    entreCalles = json['entreCalles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idregistro'] = this.idregistro;
    data['subagentemercado'] = this.subagentemercado;
    data['recupidjobcard'] = this.recupidjobcard;
    data['cliente'] = this.cliente;
    data['nombre'] = this.nombre;
    data['domicilio'] = this.domicilio;
    data['entrecallE1'] = this.entrecallE1;
    data['entrecallE2'] = this.entrecallE2;
    data['cp'] = this.cp;
    data['ztecnico'] = this.ztecnico;
    data['provincia'] = this.provincia;
    data['localidad'] = this.localidad;
    data['telefono'] = this.telefono;
    data['grxx'] = this.grxx;
    data['gryy'] = this.gryy;
    data['decO1'] = this.decO1;
    data['cmodeM1'] = this.cmodeM1;
    data['fechacarga'] = this.fechacarga;
    data['estado'] = this.estado;
    data['fechaent'] = this.fechaent;
    data['tecasig'] = this.tecasig;
    data['zona'] = this.zona;
    data['idr'] = this.idr;
    data['modelo'] = this.modelo;
    data['smartcard'] = this.smartcard;
    data['ruta'] = this.ruta;
    data['estadO2'] = this.estadO2;
    data['estadO3'] = this.estadO3;
    data['tarifa'] = this.tarifa;
    data['proyectomodulo'] = this.proyectomodulo;
    data['fechacaptura'] = this.fechacaptura;
    data['estadogaos'] = this.estadogaos;
    data['fechacumplida'] = this.fechacumplida;
    data['bajasistema'] = this.bajasistema;
    data['idcabeceracertif'] = this.idcabeceracertif;
    data['subcon'] = this.subcon;
    data['causantec'] = this.causantec;
    data['pasaDefinitiva'] = this.pasaDefinitiva;
    data['fechaAsignada'] = this.fechaAsignada;
    data['hsCaptura'] = this.hsCaptura;
    data['hsAsignada'] = this.hsAsignada;
    data['hsCumplida'] = this.hsCumplida;
    data['observacion'] = this.observacion;
    data['linkFoto'] = this.linkFoto;
    data['userID'] = this.userID;
    data['hsCumplidaTime'] = this.hsCumplidaTime;
    data['terminalAsigna'] = this.terminalAsigna;
    data['urlDni'] = this.urlDni;
    data['urlFirma'] = this.urlFirma;
    data['urlDni2'] = this.urlDni2;
    data['urlFirma2'] = this.urlFirma2;
    data['esCR'] = this.esCR;
    data['autonumerico'] = this.autonumerico;
    data['reclamoTecnicoID'] = this.reclamoTecnicoID;
    data['clienteTipoId'] = this.clienteTipoId;
    data['documento'] = this.documento;
    data['partido'] = this.partido;
    data['emailCliente'] = this.emailCliente;
    data['observacionCaptura'] = this.observacionCaptura;
    data['fechaInicio'] = this.fechaInicio;
    data['fechaEnvio'] = this.fechaEnvio;
    data['marcaModeloId'] = this.marcaModeloId;
    data['enviado'] = this.enviado;
    data['cancelado'] = this.cancelado;
    data['recupero'] = this.recupero;
    data['codigoCierre'] = this.codigoCierre;
    data['visitaTecnica'] = this.visitaTecnica;
    data['novedades'] = this.novedades;
    data['pdfGenerado'] = this.pdfGenerado;
    data['fechaCumplidaTecnico'] = this.fechaCumplidaTecnico;
    data['archivoOutGenerado'] = this.archivoOutGenerado;
    data['idSuscripcion'] = this.idSuscripcion;
    data['itemsID'] = this.itemsID;
    data['sectorOperativo'] = this.sectorOperativo;
    data['idTipoTrabajoRel'] = this.idTipoTrabajoRel;
    data['motivos'] = this.motivos;
    data['controlesEquivalencia'] = this.controlesEquivalencia;
    data['fechaCita'] = this.fechaCita;
    data['medioCita'] = this.medioCita;
    data['nroSeriesExtras'] = this.nroSeriesExtras;
    data['fechaEvento1'] = this.fechaEvento1;
    data['fechaEvento2'] = this.fechaEvento2;
    data['fechaEvento3'] = this.fechaEvento3;
    data['fechaEvento4'] = this.fechaEvento4;
    data['evento1'] = this.evento1;
    data['evento2'] = this.evento2;
    data['evento3'] = this.evento3;
    data['evento4'] = this.evento4;
    data['telefAlternativo1'] = this.telefAlternativo1;
    data['telefAlternativo2'] = this.telefAlternativo2;
    data['telefAlternativo3'] = this.telefAlternativo3;
    data['telefAlternativo4'] = this.telefAlternativo4;
    data['clienteCompleto'] = this.clienteCompleto;
    data['entreCalles'] = this.entreCalles;
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
      'controlesEquivalencia': controlesEquivalencia,
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
      'telefAlternativo1': telefAlternativo1,
      'telefAlternativo2': telefAlternativo2,
      'telefAlternativo3': telefAlternativo3,
      'telefAlternativo4': telefAlternativo4,
      'clienteCompleto': clienteCompleto,
      'entreCalles': entreCalles,
    };
  }
}
