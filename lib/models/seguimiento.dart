class Seguimiento {
  int id = 0;
  int? idenvio = 0;
  int? idetapa = 0;
  int? estado = 0;
  int? idusuario = 0;
  int? fecha = 0;
  String? hora = '';
  String? observaciones = '';
  String? motivo = '';
  String? notachofer = '';

  Seguimiento(
      {required this.id,
      required this.idenvio,
      required this.idetapa,
      required this.estado,
      required this.idusuario,
      required this.fecha,
      required this.hora,
      required this.observaciones,
      required this.motivo,
      required this.notachofer});

  Seguimiento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idenvio = json['idenvio'];
    idetapa = json['idetapa'];
    estado = json['estado'];
    idusuario = json['idusuario'];
    fecha = json['fecha'];
    hora = json['hora'];
    observaciones = json['observaciones'];
    motivo = json['motivo'];
    notachofer = json['notachofer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idenvio'] = this.idenvio;
    data['idetapa'] = this.idetapa;
    data['estado'] = this.estado;
    data['idusuario'] = this.idusuario;
    data['fecha'] = this.fecha;
    data['hora'] = this.hora;
    data['observaciones'] = this.observaciones;
    data['motivo'] = this.motivo;
    data['notachofer'] = this.notachofer;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idenvio': idenvio,
      'idetapa': idetapa,
      'estado': estado,
      'idusuario': idusuario,
      'fecha': fecha,
      'hora': hora,
      'observaciones': observaciones,
      'motivo': motivo,
      'notachofer': notachofer,
    };
  }
}
