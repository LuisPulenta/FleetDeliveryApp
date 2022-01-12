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
      {required this.idParada,
      required this.idRuta,
      required this.idEnvio,
      required this.tag,
      required this.secuencia,
      required this.leyenda,
      required this.latitud,
      required this.longitud,
      required this.iconoPropio,
      required this.iDmapa,
      required this.distancia,
      required this.tiempo,
      required this.estado,
      required this.fecha,
      required this.hora,
      required this.idMotivo,
      required this.notaChofer,
      required this.nuevoOrden,
      required this.idCabCertificacion,
      required this.idLiquidacionFletero,
      required this.turno});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idParada'] = this.idParada;
    data['idRuta'] = this.idRuta;
    data['idEnvio'] = this.idEnvio;
    data['tag'] = this.tag;
    data['secuencia'] = this.secuencia;
    data['leyenda'] = this.leyenda;
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    data['iconoPropio'] = this.iconoPropio;
    data['iDmapa'] = this.iDmapa;
    data['distancia'] = this.distancia;
    data['tiempo'] = this.tiempo;
    data['estado'] = this.estado;
    data['fecha'] = this.fecha;
    data['hora'] = this.hora;
    data['idMotivo'] = this.idMotivo;
    data['notaChofer'] = this.notaChofer;
    data['nuevoOrden'] = this.nuevoOrden;
    data['idCabCertificacion'] = this.idCabCertificacion;
    data['idLiquidacionFletero'] = this.idLiquidacionFletero;
    data['turno'] = this.turno;
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
