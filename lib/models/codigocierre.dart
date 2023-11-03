class CodigoCierre {
  String proyectomodulo = '';
  int codigoCierre = 0;
  String? descripcion = '';
  int? cierraEnAPP = 0;
  int? noMostrarAPP = 0;
  String? equivalenciaWS = '';

  CodigoCierre(
      {required this.proyectomodulo,
      required this.codigoCierre,
      required this.descripcion,
      required this.cierraEnAPP,
      required this.noMostrarAPP,
      required this.equivalenciaWS});

  CodigoCierre.fromJson(Map<String, dynamic> json) {
    proyectomodulo = json['proyectomodulo'];
    codigoCierre = json['codigoCierre'];
    descripcion = json['descripcion'];
    cierraEnAPP = json['cierraEnAPP'];
    noMostrarAPP = json['noMostrarAPP'];
    equivalenciaWS = json['equivalenciaWS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proyectomodulo'] = proyectomodulo;
    data['codigoCierre'] = codigoCierre;
    data['descripcion'] = descripcion;
    data['cierraEnAPP'] = cierraEnAPP;
    data['noMostrarAPP'] = noMostrarAPP;
    data['equivalenciaWS'] = equivalenciaWS;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'proyectomodulo': proyectomodulo,
      'codigoCierre': codigoCierre,
      'descripcion': descripcion,
      'cierraEnAPP': cierraEnAPP,
      'noMostrarAPP': noMostrarAPP,
      'equivalenciaWS': equivalenciaWS,
    };
  }
}
