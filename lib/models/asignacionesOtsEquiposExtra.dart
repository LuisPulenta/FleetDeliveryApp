class AsignacionesOtsEquiposExtra {
  int idasignacionextra = 0;
  int? idgaos = 0;
  String? fechacarga = '';
  String? nrocliente = '';
  int? idtecnico = 0;
  String? coddeco1 = '';
  String? nroserieextra = '';
  String? proyectoModulo = '';

  AsignacionesOtsEquiposExtra(
      {required this.idasignacionextra,
      required this.idgaos,
      required this.fechacarga,
      required this.nrocliente,
      required this.idtecnico,
      required this.coddeco1,
      required this.nroserieextra,
      required this.proyectoModulo});

  AsignacionesOtsEquiposExtra.fromJson(Map<String, dynamic> json) {
    idasignacionextra = json['idasignacionextra'];
    idgaos = json['idgaos'];
    fechacarga = json['fechacarga'];
    nrocliente = json['nrocliente'];
    idtecnico = json['idtecnico'];
    coddeco1 = json['coddecO1'];
    nroserieextra = json['nroserieextra'];
    proyectoModulo = json['proyectoModulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idasignacionextra'] = idasignacionextra;
    data['idgaos'] = idgaos;
    data['fechacarga'] = fechacarga;
    data['nrocliente'] = nrocliente;
    data['idtecnico'] = idtecnico;
    data['coddeco1'] = coddeco1;
    data['nroserieextra'] = nroserieextra;
    data['proyectoModulo'] = proyectoModulo;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idasignacionextra': idasignacionextra,
      'idgaos': idgaos,
      'fechacarga': fechacarga,
      'nrocliente': nrocliente,
      'idtecnico': idtecnico,
      'coddeco1': coddeco1,
      'nroserieextra': nroserieextra,
      'proyectoModulo': proyectoModulo,
    };
  }
}
