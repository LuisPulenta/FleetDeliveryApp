class Ruta {
  int id = 0;
  int? idFletero = 0;
  String? fechaAlta = '';
  String? nombre = '';
  int? estado = 0;

  Ruta(
      {required this.id,
      required this.idFletero,
      required this.fechaAlta,
      required this.nombre,
      required this.estado});

  Ruta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFletero = json['idFletero'];
    fechaAlta = json['fechaAlta'];
    nombre = json['nombre'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idFletero'] = this.idFletero;
    data['fechaAlta'] = this.fechaAlta;
    data['nombre'] = this.nombre;
    data['estado'] = this.estado;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idFletero': idFletero,
      'fechaAlta': fechaAlta,
      'nombre': nombre,
      'estado': estado,
    };
  }
}
