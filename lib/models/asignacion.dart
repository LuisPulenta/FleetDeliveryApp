class Asignacion {
  String? recupidjobcard = '';
  String? cliente = '';
  String? documento = '';
  String? nombre = '';
  String? domicilio = '';
  String? cp = '';
  String? entrecallE1 = '';
  String? entrecallE2 = '';
  String? partido = '';
  String? localidad = '';
  String? telefono = '';
  String? grxx = '';
  String? gryy = '';
  String? estadogaos = '';
  String? proyectomodulo = '';
  int? userID = 0;
  String? causantec = '';
  String? subcon = '';
  String? fechaAsignada = '';
  String? fechacaptura = '';
  int? codigoCierre = 0;
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
  String? observacionCaptura = '';
  String? zona = '';
  int? cantAsign = 0;
  int? modificadoAPP = 0;
  String? emailCliente = '';

  Asignacion(
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
      required this.fechacaptura,
      required this.codigoCierre,
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
      required this.observacionCaptura,
      required this.zona,
      required this.modificadoAPP,
      required this.emailCliente});

  Asignacion.fromJson(Map<String, dynamic> json) {
    recupidjobcard = json['recupidjobcard'];
    cliente = json['cliente'];
    nombre = json['nombre'];
    documento = json['documento'];
    domicilio = json['domicilio'];
    cp = json['cp'];
    entrecallE1 = json['entrecallE1'];
    entrecallE2 = json['entrecallE2'];
    partido = json['partido'];
    localidad = json['localidad'];
    telefono = json['telefono'];
    grxx = json['grxx'];
    gryy = json['gryy'];
    estadogaos = json['estadogaos'];
    proyectomodulo = json['proyectomodulo'];
    userID = json['userID'];
    causantec = json['causantec'];
    subcon = json['subcon'];
    fechaAsignada = json['fechaAsignada'];
    fechacaptura = json['fechacaptura'];
    codigoCierre = json['codigoCierre'];
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
    observacionCaptura = json['observacionCaptura'];
    zona = json['zona'];
    modificadoAPP = json['modificadoAPP'];
    emailCliente = json['emailCliente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recupidjobcard'] = recupidjobcard;
    data['cliente'] = cliente;
    data['nombre'] = nombre;
    data['documento'] = documento;
    data['domicilio'] = domicilio;
    data['cp'] = cp;
    data['entrecallE1'] = entrecallE1;
    data['entrecallE2'] = entrecallE2;
    data['partido'] = partido;
    data['localidad'] = localidad;
    data['telefono'] = telefono;
    data['grxx'] = grxx;
    data['gryy'] = gryy;
    data['estadogaos'] = estadogaos;
    data['proyectomodulo'] = proyectomodulo;
    data['userID'] = userID;
    data['causantec'] = causantec;
    data['subcon'] = subcon;
    data['fechaAsignada'] = fechaAsignada;
    data['fechacaptura'] = fechacaptura;
    data['codigoCierre'] = codigoCierre;
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
    data['observacionCaptura'] = observacionCaptura;
    data['zona'] = zona;
    data['modificadoAPP'] = modificadoAPP;
    data['emailCliente'] = emailCliente;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'recupidjobcard': recupidjobcard,
      'cliente': cliente,
      'documento': documento,
      'nombre': nombre,
      'domicilio': domicilio,
      'cp': cp,
      'entrecallE1': entrecallE1,
      'entrecallE2': entrecallE2,
      'partido': partido,
      'localidad': localidad,
      'telefono': telefono,
      'grxx': grxx,
      'gryy': gryy,
      'estadogaos': estadogaos,
      'proyectomodulo': proyectomodulo,
      'userID': userID,
      'causantec': causantec,
      'subcon': subcon,
      'fechaAsignada': fechaAsignada,
      'fechacaptura': fechacaptura,
      'codigoCierre': codigoCierre,
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
      'observacionCaptura': observacionCaptura,
      'zona': zona,
      'modificadoAPP': modificadoAPP,
      'emailCliente': emailCliente,
    };
  }
}
