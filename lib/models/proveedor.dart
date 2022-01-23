class Proveedor {
  int id = 0;
  String? nombre = '';
  String? claveacceso = '';
  int? permiso = 0;
  int? permiso2 = 0;
  String? email = '';
  String? iniciales = '';
  String? razonSocial = '';
  String? domicilio = '';
  String? mail = '';
  String? telefono = '';
  String? responsable = '';
  String? condicionesContrato = '';
  int? tag = 0;
  int? estado = 0;
  String? cuit = '';
  int? importacionGenerica = 0;
  int? enviarNotifAdestinatario = 0;
  int? enviarCopiaAcliente = 0;
  int? enviarResumenNotifAcliente = 0;
  String? pesoCaja = '';
  String? altoCaja = '';
  String? anchoCaja = '';
  String? largoCaja = '';
  String? pesoMaxPallet = '';
  String? altoMaxPallet = '';
  String? anchoMaxPallet = '';
  String? largoMaxPallet = '';
  int? cantidadDeCajas = 0;

  Proveedor(
      {required this.id,
      required this.nombre,
      required this.claveacceso,
      required this.permiso,
      required this.permiso2,
      required this.email,
      required this.iniciales,
      required this.razonSocial,
      required this.domicilio,
      required this.mail,
      required this.telefono,
      required this.responsable,
      required this.condicionesContrato,
      required this.tag,
      required this.estado,
      required this.cuit,
      required this.importacionGenerica,
      required this.enviarNotifAdestinatario,
      required this.enviarCopiaAcliente,
      required this.enviarResumenNotifAcliente,
      required this.pesoCaja,
      required this.altoCaja,
      required this.anchoCaja,
      required this.largoCaja,
      required this.pesoMaxPallet,
      required this.altoMaxPallet,
      required this.anchoMaxPallet,
      required this.largoMaxPallet,
      required this.cantidadDeCajas});

  Proveedor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    claveacceso = json['claveacceso'];
    permiso = json['permiso'];
    permiso2 = json['permiso2'];
    email = json['email'];
    iniciales = json['iniciales'];
    razonSocial = json['razonSocial'];
    domicilio = json['domicilio'];
    mail = json['mail'];
    telefono = json['telefono'];
    responsable = json['responsable'];
    condicionesContrato = json['condicionesContrato'];
    tag = json['tag'];
    estado = json['estado'];
    cuit = json['cuit'];
    importacionGenerica = json['importacionGenerica'];
    enviarNotifAdestinatario = json['enviarNotifAdestinatario'];
    enviarCopiaAcliente = json['enviarCopiaAcliente'];
    enviarResumenNotifAcliente = json['enviarResumenNotifAcliente'];
    pesoCaja = json['pesoCaja'];
    altoCaja = json['altoCaja'];
    anchoCaja = json['anchoCaja'];
    largoCaja = json['largoCaja'];
    pesoMaxPallet = json['pesoMaxPallet'];
    altoMaxPallet = json['altoMaxPallet'];
    anchoMaxPallet = json['anchoMaxPallet'];
    largoMaxPallet = json['largoMaxPallet'];
    cantidadDeCajas = json['cantidadDeCajas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['nombre'] = nombre;
    data['claveacceso'] = claveacceso;
    data['permiso'] = permiso;
    data['permiso2'] = permiso2;
    data['email'] = email;
    data['iniciales'] = iniciales;
    data['razonSocial'] = razonSocial;
    data['domicilio'] = domicilio;
    data['mail'] = mail;
    data['telefono'] = telefono;
    data['responsable'] = responsable;
    data['condicionesContrato'] = condicionesContrato;
    data['tag'] = tag;
    data['estado'] = estado;
    data['cuit'] = cuit;
    data['importacionGenerica'] = importacionGenerica;
    data['enviarNotifAdestinatario'] = enviarNotifAdestinatario;
    data['enviarCopiaAcliente'] = enviarCopiaAcliente;
    data['enviarResumenNotifAcliente'] = enviarResumenNotifAcliente;
    data['pesoCaja'] = pesoCaja;
    data['altoCaja'] = altoCaja;
    data['anchoCaja'] = anchoCaja;
    data['largoCaja'] = largoCaja;
    data['pesoMaxPallet'] = pesoMaxPallet;
    data['altoMaxPallet'] = altoMaxPallet;
    data['anchoMaxPallet'] = anchoMaxPallet;
    data['largoMaxPallet'] = largoMaxPallet;
    data['cantidadDeCajas'] = cantidadDeCajas;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'claveacceso': claveacceso,
      'permiso': permiso,
      'permiso2': permiso2,
      'email': email,
      'iniciales': iniciales,
      'razonSocial': razonSocial,
      'domicilio': domicilio,
      'mail': mail,
      'telefono': telefono,
      'responsable': responsable,
      'condicionesContrato': condicionesContrato,
      'tag': tag,
      'estado': estado,
      'cuit': cuit,
      'importacionGenerica': importacionGenerica,
      'enviarNotifAdestinatario': enviarNotifAdestinatario,
      'enviarCopiaAcliente': enviarCopiaAcliente,
      'enviarResumenNotifAcliente': enviarResumenNotifAcliente,
      'pesoCaja': pesoCaja,
      'altoCaja': altoCaja,
      'anchoCaja': anchoCaja,
      'largoCaja': largoCaja,
      'pesoMaxPallet': pesoMaxPallet,
      'altoMaxPallet': altoMaxPallet,
      'anchoMaxPallet': anchoMaxPallet,
      'largoMaxPallet': largoMaxPallet,
      'cantidadDeCajas': cantidadDeCajas,
    };
  }
}
