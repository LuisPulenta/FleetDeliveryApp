class Usuario {
  int idUser = 0;
  String? codigo = '';
  String? apellidonombre = '';
  String? usrlogin = '';
  String? usrcontrasena = '';
  int? habilitadoWeb = 0;
  String? vehiculo = '';
  String? dominio = '';
  String? celular = '';
  int? orden = 0;
  int? centroDistribucion = 0;

  Usuario(
      {required this.idUser,
      required this.codigo,
      required this.apellidonombre,
      required this.usrlogin,
      required this.usrcontrasena,
      required this.habilitadoWeb,
      required this.vehiculo,
      required this.dominio,
      required this.celular,
      required this.orden,
      required this.centroDistribucion});

  Usuario.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    codigo = json['codigo'];
    apellidonombre = json['apellidonombre'];
    usrlogin = json['usrlogin'];
    usrcontrasena = json['usrcontrasena'];
    habilitadoWeb = json['habilitadoWeb'];
    vehiculo = json['vehiculo'];
    dominio = json['dominio'];
    celular = json['celular'];
    orden = json['orden'];
    centroDistribucion = json['centroDistribucion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['codigo'] = this.codigo;
    data['apellidonombre'] = this.apellidonombre;
    data['usrlogin'] = this.usrlogin;
    data['usrcontrasena'] = this.usrcontrasena;
    data['habilitadoWeb'] = this.habilitadoWeb;
    data['vehiculo'] = this.vehiculo;
    data['dominio'] = this.dominio;
    data['celular'] = this.celular;
    data['orden'] = this.orden;
    data['centroDistribucion'] = this.centroDistribucion;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'codigo': codigo,
      'apellidonombre': apellidonombre,
      'usrlogin': usrlogin,
      'usrcontrasena': usrcontrasena,
      'habilitadoWeb': habilitadoWeb,
      'vehiculo': vehiculo,
      'dominio': dominio,
      'celular': celular,
      'orden': orden,
      'centroDistribucion': centroDistribucion,
    };
  }
}
