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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['claveacceso'] = this.claveacceso;
    data['permiso'] = this.permiso;
    data['permiso2'] = this.permiso2;
    data['email'] = this.email;
    data['iniciales'] = this.iniciales;
    data['razonSocial'] = this.razonSocial;
    data['domicilio'] = this.domicilio;
    data['mail'] = this.mail;
    data['telefono'] = this.telefono;
    data['responsable'] = this.responsable;
    data['condicionesContrato'] = this.condicionesContrato;
    data['tag'] = this.tag;
    data['estado'] = this.estado;
    data['cuit'] = this.cuit;
    data['importacionGenerica'] = this.importacionGenerica;
    data['enviarNotifAdestinatario'] = this.enviarNotifAdestinatario;
    data['enviarCopiaAcliente'] = this.enviarCopiaAcliente;
    data['enviarResumenNotifAcliente'] = this.enviarResumenNotifAcliente;
    data['pesoCaja'] = this.pesoCaja;
    data['altoCaja'] = this.altoCaja;
    data['anchoCaja'] = this.anchoCaja;
    data['largoCaja'] = this.largoCaja;
    data['pesoMaxPallet'] = this.pesoMaxPallet;
    data['altoMaxPallet'] = this.altoMaxPallet;
    data['anchoMaxPallet'] = this.anchoMaxPallet;
    data['largoMaxPallet'] = this.largoMaxPallet;
    data['cantidadDeCajas'] = this.cantidadDeCajas;
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
