class Usuario2 {
  int idUsuario = 0;
  String? codigoCausante = '';
  String login = '';
  String contrasena = '';
  String? nombre = '';
  String? apellido = '';
  int? estado = 0;
  int? fechaCaduca = 0;
  int? intentosInvDiario = 0;
  int? opeAutorizo = 0;

  Usuario2(
      {required this.idUsuario,
      required this.codigoCausante,
      required this.login,
      required this.contrasena,
      required this.nombre,
      required this.apellido,
      required this.estado,
      required this.fechaCaduca,
      required this.intentosInvDiario,
      required this.opeAutorizo});

  Usuario2.fromJson(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'];
    codigoCausante = json['codigoCausante'];
    login = json['login'];
    contrasena = json['contrasena'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    estado = json['estado'];
    fechaCaduca = json['fechaCaduca'];
    intentosInvDiario = json['intentosInvDiario'];
    opeAutorizo = json['opeAutorizo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUsuario'] = idUsuario;
    data['codigoCausante'] = codigoCausante;
    data['login'] = login;
    data['contrasena'] = contrasena;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['estado'] = estado;
    data['fechaCaduca'] = fechaCaduca;
    data['intentosInvDiario'] = intentosInvDiario;
    data['opeAutorizo'] = opeAutorizo;
    return data;
  }
}
