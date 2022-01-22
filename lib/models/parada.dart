class Parada {
  int idParada = 0;
  int? idRuta = 0;
  int? idEnvio = 0;
  int? tag = 0;
  int? secuencia = 0;
  String? leyenda = '';
  double? latitud = 0.0;
  double? longitud = 0.0;
  String? iconoPropio = '';
  String? iDmapa = '';
  int? distancia = 0;
  int? tiempo = 0;
  int? estado = 0;
  String? fecha = '';
  String? hora = '';
  int? idMotivo = 0;
  String? notaChofer = '';
  int? nuevoOrden = 0;
  int? idCabCertificacion = 0;
  int? idLiquidacionFletero = 0;
  String? turno = '';

  Parada(
      {required idParada,
      required idRuta,
      required idEnvio,
      required tag,
      required secuencia,
      required leyenda,
      required latitud,
      required longitud,
      required iconoPropio,
      required iDmapa,
      required distancia,
      required tiempo,
      required estado,
      required fecha,
      required hora,
      required idMotivo,
      required notaChofer,
      required nuevoOrden,
      required idCabCertificacion,
      required idLiquidacionFletero,
      required turno});

  Parada.fromJson(Map<String, dynamic> json) {
    idParada = json['idParada'];
    idRuta = json['idRuta'];
    idEnvio = json['idEnvio'];
    tag = json['tag'];
    secuencia = json['secuencia'];
    leyenda = json['leyenda'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    iconoPropio = json['iconoPropio'];
    iDmapa = json['iDmapa'];
    distancia = json['distancia'];
    tiempo = json['tiempo'];
    estado = json['estado'];
    fecha = json['fecha'];
    hora = json['hora'];
    idMotivo = json['idMotivo'];
    notaChofer = json['notaChofer'];
    nuevoOrden = json['nuevoOrden'];
    idCabCertificacion = json['idCabCertificacion'];
    idLiquidacionFletero = json['idLiquidacionFletero'];
    turno = json['turno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idParada'] = idParada;
    data['idRuta'] = idRuta;
    data['idEnvio'] = idEnvio;
    data['tag'] = tag;
    data['secuencia'] = secuencia;
    data['leyenda'] = leyenda;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['iconoPropio'] = iconoPropio;
    data['iDmapa'] = iDmapa;
    data['distancia'] = distancia;
    data['tiempo'] = tiempo;
    data['estado'] = estado;
    data['fecha'] = fecha;
    data['hora'] = hora;
    data['idMotivo'] = idMotivo;
    data['notaChofer'] = notaChofer;
    data['nuevoOrden'] = nuevoOrden;
    data['idCabCertificacion'] = idCabCertificacion;
    data['idLiquidacionFletero'] = idLiquidacionFletero;
    data['turno'] = turno;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idParada': idParada,
      'idRuta': idRuta,
      'idEnvio': idEnvio,
      'tag': tag,
      'secuencia': secuencia,
      'leyenda': leyenda,
      'latitud': latitud,
      'longitud': longitud,
      'iconoPropio': iconoPropio,
      'iDmapa': iDmapa,
      'distancia': distancia,
      'tiempo': tiempo,
      'estado': estado,
      'fecha': fecha,
      'hora': hora,
      'idMotivo': idMotivo,
      'notaChofer': notaChofer,
      'nuevoOrden': nuevoOrden,
      'idCabCertificacion': idCabCertificacion,
      'idLiquidacionFletero': idLiquidacionFletero,
      'turno': turno,
    };
  }
}
