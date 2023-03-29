import 'dart:convert';

SubContratistasUsrVehiculo subContratistasUsrVehiculoFromMap(String str) =>
    SubContratistasUsrVehiculo.fromMap(json.decode(str));

String subContratistasUsrVehiculoToMap(SubContratistasUsrVehiculo data) =>
    json.encode(data.toMap());

class SubContratistasUsrVehiculo {
  int idUser;
  String dniFrente;
  int id;
  String dniDorso;
  String carnetConducir;
  DateTime fechaVencCarnet;
  String dominio;
  int modeloAnio;
  String marca;
  DateTime fechaVencVtv;
  String gas;
  DateTime fechaObleaGas;
  DateTime ultimaActualizacion;
  String dniFrenteFullPath = '';
  String dniDorsoFullPath = '';
  String carnetConducirFullPath = '';
  String nroPolizaSeguro = '';
  DateTime fechaVencPoliza;
  String compania = '';
  String linkVtv;
  String linkObleaGas;
  String linkPolizaSeguro;
  String linkCedula;
  String linkAntecedentes;
  String linkVtvFullPath;
  String linkObleaGasFullPath;
  String linkPolizaSeguroFullPath;
  String linkCedulaFullPath;
  String linkAntecedentesFullPath;

  SubContratistasUsrVehiculo({
    required this.id,
    required this.idUser,
    required this.dniFrente,
    required this.dniDorso,
    required this.carnetConducir,
    required this.fechaVencCarnet,
    required this.dominio,
    required this.modeloAnio,
    required this.marca,
    required this.fechaVencVtv,
    required this.gas,
    required this.fechaObleaGas,
    required this.ultimaActualizacion,
    required this.dniFrenteFullPath,
    required this.dniDorsoFullPath,
    required this.carnetConducirFullPath,
    required this.nroPolizaSeguro,
    required this.fechaVencPoliza,
    required this.compania,
    required this.linkVtv,
    required this.linkObleaGas,
    required this.linkPolizaSeguro,
    required this.linkCedula,
    required this.linkAntecedentes,
    required this.linkVtvFullPath,
    required this.linkObleaGasFullPath,
    required this.linkPolizaSeguroFullPath,
    required this.linkCedulaFullPath,
    required this.linkAntecedentesFullPath,
  });

  factory SubContratistasUsrVehiculo.fromMap(Map<String, dynamic> json) =>
      SubContratistasUsrVehiculo(
        id: json["id"],
        idUser: json["idUser"],
        dniFrente: json["dniFrente"],
        dniDorso: json["dniDorso"],
        carnetConducir: json["carnetConducir"],
        fechaVencCarnet: DateTime.parse(json["fechaVencCarnet"]),
        dominio: json["dominio"],
        modeloAnio: json["modeloAnio"],
        marca: json["marca"],
        fechaVencVtv: DateTime.parse(json["fechaVencVTV"]),
        gas: json["gas"],
        fechaObleaGas: DateTime.parse(json["fechaObleaGas"]),
        ultimaActualizacion: DateTime.parse(json["ultimaActualizacion"]),
        dniFrenteFullPath: json["dniFrenteFullPath"],
        dniDorsoFullPath: json["dniDorsoFullPath"],
        carnetConducirFullPath: json["carnetConducirFullPath"],
        nroPolizaSeguro: json["nroPolizaSeguro"],
        fechaVencPoliza: DateTime.parse(json["fechaVencPoliza"]),
        compania: json["compania"],
        linkVtv: json["linkVtv"],
        linkObleaGas: json["linkObleaGas"],
        linkPolizaSeguro: json["linkPolizaSeguro"],
        linkCedula: json["linkCedula"],
        linkAntecedentes: json["linkAntecedentes"],
        linkVtvFullPath: json["linkVtvFullPath"],
        linkObleaGasFullPath: json["linkObleaGasFullPath"],
        linkPolizaSeguroFullPath: json["linkPolizaSeguroFullPath"],
        linkCedulaFullPath: json["linkCedulaFullPath"],
        linkAntecedentesFullPath: json["linkAntecedentesFullPath"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "idUser": idUser,
        "dniFrente": dniFrente,
        "dniDorso": dniDorso,
        "carnetConducir": carnetConducir,
        "fechaVencCarnet": fechaVencCarnet.toIso8601String(),
        "dominio": dominio,
        "modeloAnio": modeloAnio,
        "marca": marca,
        "fechaVencVTV": fechaVencVtv.toIso8601String(),
        "gas": gas,
        "fechaObleaGas": fechaObleaGas.toIso8601String(),
        "ultimaActualizacion": ultimaActualizacion.toIso8601String(),
        "dniFrenteFullPath": dniFrenteFullPath,
        "dniDorsoFullPath": dniDorsoFullPath,
        "carnetConducirFullPath": carnetConducirFullPath,
        "nroPolizaSeguro": nroPolizaSeguro,
        "fechaVencPoliza": fechaVencPoliza,
        "compania": compania,
        "linkVtv": linkVtv,
        "linkObleaGas": linkObleaGas,
        "linkPolizaSeguro": linkPolizaSeguro,
        "linkCedula": linkCedula,
        "linkAntecedentes": linkAntecedentes,
        "linkVtvFullPath": linkVtvFullPath,
        "linkObleaGasFullPath": linkObleaGasFullPath,
        "linkPolizaSeguroFullPath": linkPolizaSeguroFullPath,
        "linkCedulaFullPath": linkCedulaFullPath,
        "linkAntecedentesFullPath": linkAntecedentesFullPath,
      };
}
