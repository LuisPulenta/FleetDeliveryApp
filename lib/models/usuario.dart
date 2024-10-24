class Usuario {
  int idUser = 0;
  String? codigo = '';
  String? apellidonombre = '';
  String usrlogin = '';
  String usrcontrasena = '';
  int? habilitadoWeb = 0;
  String? vehiculo = '';
  String? dominio = '';
  String? celular = '';
  int? orden = 0;
  int? centroDistribucion = 0;
  String? dni = '';
  String? mail = '';
  String? claveEmail = '';

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
      required this.centroDistribucion,
      required this.dni,
      required this.mail,
      required this.claveEmail});

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
    dni = json['dni'];
    mail = json['mail'];
    claveEmail = json['claveEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['codigo'] = codigo;
    data['apellidonombre'] = apellidonombre;
    data['usrlogin'] = usrlogin;
    data['usrcontrasena'] = usrcontrasena;
    data['habilitadoWeb'] = habilitadoWeb;
    data['vehiculo'] = vehiculo;
    data['dominio'] = dominio;
    data['celular'] = celular;
    data['orden'] = orden;
    data['centroDistribucion'] = centroDistribucion;
    data['dni'] = dni;
    data['mail'] = mail;
    data['claveEmail'] = claveEmail;
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
      'dni': dni,
      'mail': mail,
      'claveEmail': claveEmail,
    };
  }
}
