class ControlesEquivalencia {
  int id = 0;
  String decO1 = '';
  String codigoequivalencia = '';
  String descripcion = '';
  String? proyectoModulo = '';

  ControlesEquivalencia(
      {required this.id,
      required this.decO1,
      required this.codigoequivalencia,
      required this.descripcion,
      required this.proyectoModulo});

  ControlesEquivalencia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    decO1 = json['decO1'];
    codigoequivalencia = json['codigoequivalencia'];
    descripcion = json['descripcion'];
    proyectoModulo = json['proyectoModulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['decO1'] = decO1;
    data['codigoequivalencia'] = codigoequivalencia;
    data['descripcion'] = descripcion;
    data['proyectoModulo'] = proyectoModulo;
    return data;
  }
}
