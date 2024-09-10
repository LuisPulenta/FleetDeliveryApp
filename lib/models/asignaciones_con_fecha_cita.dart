class AsignacionesConFechaCita {
  String? proyectomodulo = '';
  int? year = 0;
  int? month = 0;
  int? day = 0;
  String? localidad = '';
  int? cantidad = 0;

  AsignacionesConFechaCita(
      {required this.proyectomodulo,
      required this.year,
      required this.month,
      required this.day,
      required this.localidad,
      required this.cantidad});

  AsignacionesConFechaCita.fromJson(Map<String, dynamic> json) {
    proyectomodulo = json['proyectomodulo'];
    year = json['year'];
    month = json['month'];
    day = json['day'];
    localidad = json['localidad'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proyectomodulo'] = proyectomodulo;
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['localidad'] = localidad;
    data['cantidad'] = cantidad;
    return data;
  }
}
