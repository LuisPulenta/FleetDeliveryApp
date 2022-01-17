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

  ParadaEnvio(
      {required this.idParada,
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
      required this.proveedor});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idParada'] = this.idParada;
    data['idRuta'] = this.idRuta;
    data['idEnvio'] = this.idEnvio;
    data['secuencia'] = this.secuencia;
    data['leyenda'] = this.leyenda;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;

    data['idproveedor'] = this.idproveedor;
    data['estado'] = this.estado;
    data['ordenid'] = this.ordenid;
    data['titular'] = this.titular;
    data['dni'] = this.dni;
    data['domicilio'] = this.domicilio;
    data['cp'] = this.cp;
    data['entreCalles'] = this.entreCalles;
    data['telefonos'] = this.telefonos;
    data['localidad'] = this.localidad;
    data['bultos'] = this.bultos;
    data['proveedor'] = this.proveedor;

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
    };
  }
}
