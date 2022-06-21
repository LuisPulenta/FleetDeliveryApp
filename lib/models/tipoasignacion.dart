class TipoAsignacion {
  String? proyectomodulo = '';

  TipoAsignacion({required this.proyectomodulo});

  TipoAsignacion.fromJson(Map<String, dynamic> json) {
    proyectomodulo = json['proyectomodulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proyectomodulo'] = proyectomodulo;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'proyectomodulo': proyectomodulo,
    };
  }
}
