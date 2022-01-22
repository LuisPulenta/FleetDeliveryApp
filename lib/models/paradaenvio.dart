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

  ParadaEnvio(
      {required idParada,
      required idRuta,
      required idEnvio,
      required secuencia,
      required leyenda,
      required latitud,
      required longitud,
      required idproveedor,
      required estado,
      required ordenid,
      required titular,
      required dni,
      required domicilio,
      required cp,
      required entreCalles,
      required telefonos,
      required localidad,
      required bultos,
      required proveedor,
      required motivo,
      required motivodesc,
      required notas,
      required enviado,
      required fecha,
      required imageArray});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    };
  }
}
