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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['decO1'] = this.decO1;
    data['codigoequivalencia'] = this.codigoequivalencia;
    data['descripcion'] = this.descripcion;
    data['proyectoModulo'] = this.proyectoModulo;
    return data;
  }
}
