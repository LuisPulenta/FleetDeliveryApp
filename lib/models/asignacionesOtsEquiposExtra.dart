class AsignacionesOtsEquiposExtra {
  int idasignacionextra = 0;
  int? idgaos = 0;
  String? fechacarga = '';
  String? nrocliente = '';
  int? idtecnico = 0;
  String? coddeco1 = '';
  String? nroserieextra = '';
  String? proyectomodulo = '';

  AsignacionesOtsEquiposExtra(
      {required this.idasignacionextra,
      required this.idgaos,
      required this.fechacarga,
      required this.nrocliente,
      required this.idtecnico,
      required this.coddeco1,
      required this.nroserieextra,
      required this.proyectomodulo});

  AsignacionesOtsEquiposExtra.fromJson(Map<String, dynamic> json) {
    idasignacionextra = json['idasignacionextra'];
    idgaos = json['idgaos'];
    fechacarga = json['fechacarga'];
    nrocliente = json['nrocliente'];
    idtecnico = json['idtecnico'];
    coddeco1 = json['coddeco1'];
    nroserieextra = json['nroserieextra'];
    proyectomodulo = json['proyectomodulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idasignacionextra'] = this.idasignacionextra;
    data['idgaos'] = this.idgaos;
    data['fechacarga'] = this.fechacarga;
    data['nrocliente'] = this.nrocliente;
    data['idtecnico'] = this.idtecnico;
    data['coddeco1'] = this.coddeco1;
    data['nroserieextra'] = this.nroserieextra;
    data['proyectomodulo'] = this.proyectomodulo;
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
      'proyectomodulo': proyectomodulo,
    };
  }
}
