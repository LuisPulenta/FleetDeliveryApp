class Turno {
  int idTurno = 0;
  int idUser = 0;
  String? fechaCarga = '';
  String? fechaTurno = '';
  int? horaTurno = 0;
  String? fechaConfirmaTurno = '';
  int? idUserConfirma = 0;
  String? fechaTurnoConfirmado = '';
  int? horaTurnoConfirmado = 0;
  String? concluido = '';

  Turno(
      {required this.idTurno,
      required this.idUser,
      required this.fechaCarga,
      required this.fechaTurno,
      required this.horaTurno,
      required this.fechaConfirmaTurno,
      required this.idUserConfirma,
      required this.fechaTurnoConfirmado,
      required this.horaTurnoConfirmado,
      required this.concluido});

  Turno.fromJson(Map<String, dynamic> json) {
    idTurno = json['idTurno'];
    idUser = json['idUser'];
    fechaCarga = json['fechaCarga'];
    fechaTurno = json['fechaTurno'];
    horaTurno = json['horaTurno'];
    fechaConfirmaTurno = json['fechaConfirmaTurno'];
    idUserConfirma = json['idUserConfirma'];
    fechaTurnoConfirmado = json['fechaTurnoConfirmado'];
    horaTurnoConfirmado = json['horaTurnoConfirmado'];
    concluido = json['concluido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idTurno'] = idTurno;
    data['idUser'] = idUser;
    data['fechaCarga'] = fechaCarga;
    data['fechaTurno'] = fechaTurno;
    data['horaTurno'] = horaTurno;
    data['fechaConfirmaTurno'] = fechaConfirmaTurno;
    data['idUserConfirma'] = idUserConfirma;
    data['fechaTurnoConfirmado'] = fechaTurnoConfirmado;
    data['horaTurnoConfirmado'] = horaTurnoConfirmado;
    data['concluido'] = concluido;
    return data;
  }
}
