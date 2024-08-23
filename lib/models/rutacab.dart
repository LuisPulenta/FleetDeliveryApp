class RutaCab {
  int idRuta = 0;
  int? idUser = 0;
  String? fechaAlta = '';
  String? nombre = '';
  int? estado = 0;
  int? habilitaCatastro = 0;
  int? totalParadas = 0;
  int? pendientes = 0;

  RutaCab(
      {required this.idRuta,
      required this.idUser,
      required this.fechaAlta,
      required this.nombre,
      required this.estado,
      required this.habilitaCatastro,
      required this.totalParadas,
      required this.pendientes});

  RutaCab.fromJson(Map<String, dynamic> json) {
    idRuta = json['idRuta'];
    idUser = json['idUser'];
    fechaAlta = json['fechaAlta'];
    nombre = json['nombre'];
    estado = json['estado'];
    habilitaCatastro = json['habilitaCatastro'];
    totalParadas = json['totalParadas'];
    pendientes = json['pendientes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRuta'] = idRuta;
    data['idUser'] = idUser;
    data['fechaAlta'] = fechaAlta;
    data['nombre'] = nombre;
    data['estado'] = estado;
    data['habilitaCatastro'] = habilitaCatastro;
    data['totalParadas'] = totalParadas;
    data['pendientes'] = pendientes;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idRuta': idRuta,
      'idUser': idUser,
      'fechaAlta': fechaAlta,
      'nombre': nombre,
      'estado': estado,
      'habilitaCatastro': habilitaCatastro,
      'totalParadas': totalParadas,
      'pendientes': pendientes,
    };
  }
}
