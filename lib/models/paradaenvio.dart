class ParadaEnvio {
  int idParada = 0;
  int? idRuta = 0;
  int? idEnvio = 0;
  int? secuencia = 0;
  String? leyenda = '';
  double? latitud = 0.0;
  double? longitud = 0.0;
  int? idproveedor = 0;
  int? estado = 0;
  String? ordenid = '';
  String? titular = '';
  String? dni = '';
  String? domicilio = '';
  String? cp = '';
  String? entreCalles = '';
  String? telefonos = '';
  String? localidad = '';
  int? bultos = 0;
  String? proveedor = '';
  int? motivo = 0;
  String? motivodesc = '';
  String? notas = '';
  int? enviado = 0;
  String? fecha = '';
  String? imageArray = '';
  String? observaciones = '';
  int? enviadoparada = 0;
  int? enviadoenvio = 0;
  int? enviadoseguimiento = 0;
  String? avonCodAmount = '';
  String? avonCodMemo = '';

  ParadaEnvio({
    required this.idParada,
    required this.idRuta,
    required this.idEnvio,
    required this.secuencia,
    required this.leyenda,
    required this.latitud,
    required this.longitud,
    required this.idproveedor,
    required this.estado,
    required this.ordenid,
    required this.titular,
    required this.dni,
    required this.domicilio,
    required this.cp,
    required this.entreCalles,
    required this.telefonos,
    required this.localidad,
    required this.bultos,
    required this.proveedor,
    required this.motivo,
    required this.motivodesc,
    required this.notas,
    required this.enviado,
    required this.fecha,
    required this.imageArray,
    required this.observaciones,
    required this.enviadoparada,
    required this.enviadoenvio,
    required this.enviadoseguimiento,
    required this.avonCodAmount,
    required this.avonCodMemo,
  });

  ParadaEnvio.fromJson(Map<String, dynamic> json) {
    idParada = json['idParada'];
    idRuta = json['idRuta'];
    idEnvio = json['idEnvio'];
    secuencia = json['secuencia'];
    leyenda = json['leyenda'];
    latitud = json['latitud'];
    longitud = json['longitud'];

    idproveedor = json['idproveedor'];
    estado = json['estado'];
    ordenid = json['ordenid'];
    titular = json['titular'];
    dni = json['dni'];
    domicilio = json['domicilio'];
    cp = json['cp'];
    entreCalles = json['entreCalles'];
    telefonos = json['telefonos'];
    localidad = json['localidad'];
    bultos = json['bultos'];
    proveedor = json['proveedor'];
    motivo = json['motivo'];
    motivodesc = json['motivodesc'];
    notas = json['notas'];
    enviado = json['enviado'];
    fecha = json['fecha'];
    imageArray = json['imageArray'];
    observaciones = json['observaciones'];
    enviadoparada = json['enviadoparada'];
    enviadoenvio = json['enviadoenvio'];
    enviadoseguimiento = json['enviadoseguimiento'];
    avonCodAmount = json['avonCodAmount'];
    avonCodMemo = json['avonCodMemo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idParada'] = idParada;
    data['idRuta'] = idRuta;
    data['idEnvio'] = idEnvio;
    data['secuencia'] = secuencia;
    data['leyenda'] = leyenda;
    data['latitud'] = latitud;
    data['longitud'] = longitud;

    data['idproveedor'] = idproveedor;
    data['estado'] = estado;
    data['ordenid'] = ordenid;
    data['titular'] = titular;
    data['dni'] = dni;
    data['domicilio'] = domicilio;
    data['cp'] = cp;
    data['entreCalles'] = entreCalles;
    data['telefonos'] = telefonos;
    data['localidad'] = localidad;
    data['bultos'] = bultos;
    data['proveedor'] = proveedor;
    data['motivo'] = motivo;
    data['motivodesc'] = motivodesc;
    data['notas'] = notas;
    data['enviado'] = enviado;
    data['fecha'] = fecha;
    data['imageArray'] = imageArray;
    data['observaciones'] = observaciones;
    data['enviadoparada'] = enviadoparada;
    data['enviadoenvio'] = enviadoenvio;
    data['enviadoseguimiento'] = enviadoseguimiento;
    data['avonCodAmount'] = avonCodAmount;
    data['avonCodMemo'] = avonCodMemo;

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idParada': idParada,
      'idRuta': idRuta,
      'idEnvio': idEnvio,
      'secuencia': secuencia,
      'leyenda': leyenda,
      'latitud': latitud,
      'longitud': longitud,
      'idproveedor': idproveedor,
      'estado': estado,
      'ordenid': ordenid,
      'titular': titular,
      'dni': dni,
      'domicilio': domicilio,
      'cp': cp,
      'entreCalles': entreCalles,
      'telefonos': telefonos,
      'localidad': localidad,
      'bultos': bultos,
      'proveedor': proveedor,
      'motivo': motivo,
      'motivodesc': motivodesc,
      'notas': notas,
      'enviado': enviado,
      'fecha': fecha,
      'imageArray': imageArray,
      'observaciones': observaciones,
      'enviadoparada': enviadoparada,
      'enviadoenvio': enviadoenvio,
      'enviadoseguimiento': enviadoseguimiento,
      'avonCodAmount': avonCodAmount,
      'avonCodMemo': avonCodMemo,
    };
  }
}
