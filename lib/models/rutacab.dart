class RutaCab {
  int idRuta = 0;
  int? idUser = 0;
  String? fechaAlta = '';
  String? nombre = '';
  int? estado = 0;

  RutaCab(
      {required idRuta,
      required idUser,
      required fechaAlta,
      required nombre,
      required estado});

  RutaCab.fromJson(Map<String, dynamic> json) {
    idRuta = json['idRuta'];
    idUser = json['idUser'];
    fechaAlta = json['fechaAlta'];
    nombre = json['nombre'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idRuta'] = idRuta;
    data['idUser'] = idUser;
    data['fechaAlta'] = fechaAlta;
    data['nombre'] = nombre;
    data['estado'] = estado;
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
