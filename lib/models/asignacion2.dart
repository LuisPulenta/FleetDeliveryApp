class Asignacion2 {
  String? recupidjobcard = '';
  String? cliente = '';
  String? nombre = '';
  String? domicilio = '';
  String? cp = '';
  String? entrecallE1 = '';
  String? entrecallE2 = '';
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
  int? codigoCierre = 0;
  String? descripcion = '';
  int? cierraenapp = 0;
  int? nomostrarapp = 0;
  String? novedades = '';
  String? provincia = '';
  int? reclamoTecnicoID = 0;
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

  Asignacion2(
      {required this.recupidjobcard,
      required this.cliente,
      required this.nombre,
      required this.domicilio,
      required this.cp,
      required this.entrecallE1,
      required this.entrecallE2,
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
      required this.cantAsign});

  Asignacion2.fromJson(Map<String, dynamic> json) {
    recupidjobcard = json['recupidjobcard'];
    cliente = json['cliente'];
    nombre = json['nombre'];
    domicilio = json['domicilio'];
    cp = json['cp'];
    entrecallE1 = json['entrecallE1'];
    entrecallE2 = json['entrecallE2'];
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
    codigoCierre = json['codigoCierre'];
    descripcion = json['descripcion'];
    cierraenapp = json['cierraenapp '];
    nomostrarapp = json['nomostrarapp'];
    novedades = json['novedades'];
    provincia = json['provincia'];
    reclamoTecnicoID = json['reclamoTecnicoID'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recupidjobcard'] = this.recupidjobcard;
    data['cliente'] = this.cliente;
    data['nombre'] = this.nombre;
    data['domicilio'] = this.domicilio;
    data['cp'] = this.cp;
    data['entrecallE1'] = this.entrecallE1;
    data['entrecallE2'] = this.entrecallE2;
    data['localidad'] = this.localidad;
    data['telefono'] = this.telefono;
    data['grxx'] = this.grxx;
    data['gryy'] = this.gryy;
    data['estadogaos'] = this.estadogaos;
    data['proyectomodulo'] = this.proyectomodulo;
    data['userID'] = this.userID;
    data['causantec'] = this.causantec;
    data['subcon'] = this.subcon;
    data['fechaAsignada'] = this.fechaAsignada;
    data['codigoCierre'] = this.codigoCierre;
    data['descripcion'] = this.descripcion;
    data['cierraenapp'] = this.cierraenapp;
    data['nomostrarapp'] = this.nomostrarapp;
    data['novedades'] = this.novedades;
    data['provincia'] = this.provincia;
    data['reclamoTecnicoID'] = this.reclamoTecnicoID;
    data['fechaCita'] = this.fechaCita;
    data['medioCita'] = this.medioCita;
    data['nroSeriesExtras'] = this.nroSeriesExtras;
    data['evento1'] = this.evento1;
    data['fechaEvento1'] = this.fechaEvento1;
    data['evento2'] = this.evento2;
    data['fechaEvento2'] = this.fechaEvento2;
    data['evento3'] = this.evento3;
    data['fechaEvento3'] = this.fechaEvento3;
    data['evento4'] = this.evento4;
    data['fechaEvento4'] = this.fechaEvento4;
    data['observacion'] = this.observacion;
    data['telefAlternativo1'] = this.telefAlternativo1;
    data['telefAlternativo2'] = this.telefAlternativo2;
    data['telefAlternativo3'] = this.telefAlternativo3;
    data['telefAlternativo4'] = this.telefAlternativo4;
    data['cantAsign'] = this.cantAsign;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'recupidjobcard': recupidjobcard,
      'cliente': cliente,
      'nombre': nombre,
      'domicilio': domicilio,
      'cp': cp,
      'entrecallE1': entrecallE1,
      'entrecallE2': entrecallE2,
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
      'codigoCierre': codigoCierre,
      'descripcion': descripcion,
      'cierraenapp': cierraenapp,
      'nomostrarapp': nomostrarapp,
      'novedades': novedades,
      'provincia': provincia,
      'reclamoTecnicoID': reclamoTecnicoID,
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
    };
  }
}
