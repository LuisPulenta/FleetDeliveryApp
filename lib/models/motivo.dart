class Motivo {
  int? id = 0;
  String? motivo = '';
  int? muestraParaEntregado = 0;

  Motivo(
      {required this.id,
      required this.motivo,
      required this.muestraParaEntregado});

  Motivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    motivo = json['motivo'];
    muestraParaEntregado = json['muestraParaEntregado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['motivo'] = motivo;
    data['muestraParaEntregado'] = muestraParaEntregado;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'motivo': motivo,
      'muestraParaEntregado': muestraParaEntregado,
    };
  }
}
