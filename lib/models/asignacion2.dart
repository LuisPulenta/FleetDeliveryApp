class Asignacion2 {
  String? recupidjobcard = '';
  String? cliente = '';
  String? documento = '';
  String? nombre = '';
  String? domicilio = '';
  String? cp = '';
  String? entrecallE1 = '';
  String? entrecallE2 = '';
  String? localidad = '';
  String? partido = '';
  String? telefono = '';
  String? grxx = '';
  String? gryy = '';
  String? estadogaos = '';
  String? proyectomodulo = '';
  int? userID = 0;
  String? causantec = '';
  String? subcon = '';
  String? fechaAsignada = '';
  int? codigoCierre = 0;
  String? descripcion = '';
  int? cierraenapp = 0;
  int? nomostrarapp = 0;
  String? novedades = '';
  String? provincia = '';
  int? reclamoTecnicoID = 0;
  String? motivos = '';
  String? fechaCita = '';
  String? medioCita = '';
  String? nroSeriesExtras = '';
  String? evento1 = '';
  String? fechaEvento1 = '';
  String? evento2 = '';
  String? fechaEvento2 = '';
  String? evento3 = '';
  String? fechaEvento3 = '';
  String? evento4 = '';
  String? fechaEvento4 = '';
  String? observacion = '';
  String? telefAlternativo1 = '';
  String? telefAlternativo2 = '';
  String? telefAlternativo3 = '';
  String? telefAlternativo4 = '';
  int? cantAsign = 0;
  String? codigoequivalencia = '';
  String? deco1descripcion = '';
  int? elegir = 0;
  String? observacionCaptura = '';
  String? zona = '';
  int? modificadoAPP = 0;
  String? hsCumplidaTime = '';
  int? marcado = 0;

  Asignacion2(
      {required this.recupidjobcard,
      required this.cliente,
      required this.documento,
      required this.nombre,
      required this.domicilio,
      required this.cp,
      required this.entrecallE1,
      required this.entrecallE2,
      required this.partido,
      required this.localidad,
      required this.telefono,
      required this.grxx,
      required this.gryy,
      required this.estadogaos,
      required this.proyectomodulo,
      required this.userID,
      required this.causantec,
      required this.subcon,
      required this.fechaAsignada,
      required this.codigoCierre,
      required this.descripcion,
      required this.cierraenapp,
      required this.nomostrarapp,
      required this.novedades,
      required this.provincia,
      required this.reclamoTecnicoID,
      required this.motivos,
      required this.fechaCita,
      required this.medioCita,
      required this.nroSeriesExtras,
      required this.evento1,
      required this.fechaEvento1,
      required this.evento2,
      required this.fechaEvento2,
      required this.evento3,
      required this.fechaEvento3,
      required this.evento4,
      required this.fechaEvento4,
      required this.observacion,
      required this.telefAlternativo1,
      required this.telefAlternativo2,
      required this.telefAlternativo3,
      required this.telefAlternativo4,
      required this.cantAsign,
      required this.codigoequivalencia,
      required this.deco1descripcion,
      required this.elegir,
      required this.observacionCaptura,
      required this.zona,
      required this.modificadoAPP,
      required this.hsCumplidaTime,
      required this.marcado});

  Asignacion2.fromJson(Map<String, dynamic> json) {
    cliente = json['cliente'];
    recupidjobcard = json['recupidjobcard'];
    documento = json['documento'];
    nombre = json['nombre'];
    domicilio = json['domicilio'];
    cp = json['cp'];
    entrecallE1 = json['entrecallE1'];
    entrecallE2 = json['entrecallE2'];
    localidad = json['localidad'];
    partido = json['partido'];
    telefono = json['telefono'];
    grxx = json['grxx'];
    gryy = json['gryy'];
    estadogaos = json['estadogaos'];
    proyectomodulo = json['proyectomodulo'];
    userID = json['userID'];
    causantec = json['causantec'];
    subcon = json['subcon'];
    fechaAsignada = json['fechaAsignada'];
    codigoCierre = json['codigoCierre'];
    descripcion = json['descripcion'];
    cierraenapp = json['cierraenapp '];
    nomostrarapp = json['nomostrarapp'];
    novedades = json['novedades'];
    provincia = json['provincia'];
    reclamoTecnicoID = json['reclamoTecnicoID'];
    motivos = json['motivos'];
    fechaCita = json['fechaCita'];
    medioCita = json['medioCita'];
    nroSeriesExtras = json['nroSeriesExtras'];
    evento1 = json['evento1'];
    fechaEvento1 = json['fechaEvento1'];
    evento2 = json['evento2'];
    fechaEvento2 = json['fechaEvento2'];
    evento3 = json['evento3'];
    fechaEvento3 = json['fechaEvento3'];
    evento4 = json['evento4'];
    fechaEvento4 = json['fechaEvento4'];
    observacion = json['observacion'];
    telefAlternativo1 = json['telefAlternativo1'];
    telefAlternativo2 = json['telefAlternativo2'];
    telefAlternativo3 = json['telefAlternativo3'];
    telefAlternativo4 = json['telefAlternativo4'];
    cantAsign = json['cantAsign'];
    codigoequivalencia = json['codigoequivalencia'];
    deco1descripcion = json['deco1descripcion'];
    elegir = json['elegir'];
    observacionCaptura = json['observacionCaptura'];
    zona = json['zona'];
    modificadoAPP = json['modificadoAPP'];
    hsCumplidaTime = json['hsCumplidaTime'];
    marcado = json['marcado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recupidjobcard'] = recupidjobcard;
    data['cliente'] = cliente;
    data['documento'] = documento;
    data['nombre'] = nombre;
    data['domicilio'] = domicilio;
    data['cp'] = cp;
    data['entrecallE1'] = entrecallE1;
    data['entrecallE2'] = entrecallE2;
    data['localidad'] = localidad;
    data['partido'] = partido;
    data['telefono'] = telefono;
    data['grxx'] = grxx;
    data['gryy'] = gryy;
    data['estadogaos'] = estadogaos;
    data['proyectomodulo'] = proyectomodulo;
    data['userID'] = userID;
    data['causantec'] = causantec;
    data['subcon'] = subcon;
    data['fechaAsignada'] = fechaAsignada;
    data['codigoCierre'] = codigoCierre;
    data['descripcion'] = descripcion;
    data['cierraenapp'] = cierraenapp;
    data['nomostrarapp'] = nomostrarapp;
    data['novedades'] = novedades;
    data['provincia'] = provincia;
    data['reclamoTecnicoID'] = reclamoTecnicoID;
    data['motivos'] = motivos;
    data['fechaCita'] = fechaCita;
    data['medioCita'] = medioCita;
    data['nroSeriesExtras'] = nroSeriesExtras;
    data['evento1'] = evento1;
    data['fechaEvento1'] = fechaEvento1;
    data['evento2'] = evento2;
    data['fechaEvento2'] = fechaEvento2;
    data['evento3'] = evento3;
    data['fechaEvento3'] = fechaEvento3;
    data['evento4'] = evento4;
    data['fechaEvento4'] = fechaEvento4;
    data['observacion'] = observacion;
    data['telefAlternativo1'] = telefAlternativo1;
    data['telefAlternativo2'] = telefAlternativo2;
    data['telefAlternativo3'] = telefAlternativo3;
    data['telefAlternativo4'] = telefAlternativo4;
    data['cantAsign'] = cantAsign;
    data['codigoequivalencia'] = codigoequivalencia;
    data['deco1descripcion'] = deco1descripcion;
    data['elegir'] = elegir;
    data['observacionCaptura'] = observacionCaptura;
    data['zona'] = zona;
    data['modificadoAPP'] = modificadoAPP;
    data['hsCumplidaTime'] = hsCumplidaTime;
    data['marcado'] = marcado;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'recupidjobcard': recupidjobcard,
      'cliente': cliente,
      'nombre': nombre,
      'documento': documento,
      'domicilio': domicilio,
      'cp': cp,
      'entrecallE1': entrecallE1,
      'entrecallE2': entrecallE2,
      'localidad': localidad,
      'partido': partido,
      'telefono': telefono,
      'grxx': grxx,
      'gryy': gryy,
      'estadogaos': estadogaos,
      'proyectomodulo': proyectomodulo,
      'userID': userID,
      'causantec': causantec,
      'subcon': subcon,
      'fechaAsignada': fechaAsignada,
      'codigoCierre': codigoCierre,
      'descripcion': descripcion,
      'cierraenapp': cierraenapp,
      'nomostrarapp': nomostrarapp,
      'novedades': novedades,
      'provincia': provincia,
      'reclamoTecnicoID': reclamoTecnicoID,
      'motivos': motivos,
      'fechaCita': fechaCita,
      'medioCita': medioCita,
      'nroSeriesExtras': nroSeriesExtras,
      'evento1': evento1,
      'fechaEvento1': fechaEvento1,
      'evento2': evento2,
      'fechaEvento2': fechaEvento2,
      'evento3': evento3,
      'fechaEvento3': fechaEvento3,
      'evento4': evento4,
      'fechaEvento4': fechaEvento4,
      'observacion': observacion,
      'telefAlternativo1': telefAlternativo1,
      'telefAlternativo2': telefAlternativo2,
      'telefAlternativo3': telefAlternativo3,
      'telefAlternativo4': telefAlternativo4,
      'cantAsign': cantAsign,
      'codigoequivalencia': codigoequivalencia,
      'deco1descripcion': deco1descripcion,
      'elegir': elegir,
      'observacionCaptura': observacionCaptura,
      'zona': zona,
      'modificadoAPP': modificadoAPP,
      'hsCumplidaTime': hsCumplidaTime,
      'marcado': marcado,
    };
  }

  get hayTelefono {
    return telefono != null && telefono != "" && telefono != "Sin Dato"
        ? true
        : false;
  }

  get hayTelefAlternativo1 {
    return telefAlternativo1 != null &&
            telefAlternativo1 != "" &&
            telefAlternativo1 != "Sin Dato"
        ? true
        : false;
  }

  get hayTelefAlternativo2 {
    return telefAlternativo2 != null &&
            telefAlternativo2 != "" &&
            telefAlternativo2 != "Sin Dato"
        ? true
        : false;
  }

  get hayTelefAlternativo3 {
    return telefAlternativo3 != null &&
            telefAlternativo3 != "" &&
            telefAlternativo3 != "Sin Dato"
        ? true
        : false;
  }

  get hayTelefAlternativo4 {
    return telefAlternativo4 != null &&
            telefAlternativo4 != "" &&
            telefAlternativo4 != "Sin Dato"
        ? true
        : false;
  }
}
