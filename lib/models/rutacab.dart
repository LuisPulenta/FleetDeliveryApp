class RutaCab {
  int idRuta = 0;
  int? idUser = 0;
  String? fechaAlta = '';
  String? nombre = '';
  int? estado = 0;

  RutaCab(
      {required this.idRuta,
      required this.idUser,
      required this.fechaAlta,
      required this.nombre,
      required this.estado});

  RutaCab.fromJson(Map<String, dynamic> json) {
    idRuta = json['idRuta'];
    idUser = json['idUser'];
    fechaAlta = json['fechaAlta'];
    nombre = json['nombre'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRuta'] = this.idRuta;
    data['idUser'] = this.idUser;
    data['fechaAlta'] = this.fechaAlta;
    data['nombre'] = this.nombre;
    data['estado'] = this.estado;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idRuta': idRuta,
      'idUser': idUser,
      'fechaAlta': fechaAlta,
      'nombre': nombre,
      'estado': estado,
    };
  }
}
