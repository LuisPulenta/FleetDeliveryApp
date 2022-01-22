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
      {required id,
      required idenvio,
      required idetapa,
      required estado,
      required idusuario,
      required fecha,
      required hora,
      required observaciones,
      required motivo,
      required notachofer});

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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['idenvio'] = idenvio;
    data['idetapa'] = idetapa;
    data['estado'] = estado;
    data['idusuario'] = idusuario;
    data['fecha'] = fecha;
    data['hora'] = hora;
    data['observaciones'] = observaciones;
    data['motivo'] = motivo;
    data['notachofer'] = notachofer;
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
