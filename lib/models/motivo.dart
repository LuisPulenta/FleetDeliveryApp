class Motivo {
  int? id = 0;
  String? motivo = '';
  int? muestraParaEntregado = 0;
  int? exclusivoCliente = 0;
  int? activo = 0;

  Motivo(
      {required this.id,
      required this.motivo,
      required this.muestraParaEntregado,
      required this.exclusivoCliente,
      required this.activo});

  Motivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    motivo = json['motivo'];
    muestraParaEntregado = json['muestraParaEntregado'];
    exclusivoCliente = json['exclusivoCliente'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['motivo'] = motivo;
    data['muestraParaEntregado'] = muestraParaEntregado;
    data['exclusivoCliente'] = exclusivoCliente;
    data['activo'] = activo;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'motivo': motivo,
      'muestraParaEntregado': muestraParaEntregado,
      'exclusivoCliente': exclusivoCliente,
      'activo': activo,
    };
  }
}
