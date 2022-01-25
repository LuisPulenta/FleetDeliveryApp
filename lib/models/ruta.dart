import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:fleetdeliveryapp/models/parada.dart';

class Ruta {
  int idRuta = 0;
  int? idUser = 0;
  String? fechaAlta = '';
  String? nombre = '';
  int? estado = 0;
  List<Parada>? paradas = [];
  List<Envio>? envios = [];

  Ruta(
      {required this.idRuta,
      required this.idUser,
      required this.fechaAlta,
      required this.nombre,
      required this.estado,
      required this.paradas,
      required this.envios});

  Ruta.fromJson(Map<String, dynamic> json) {
    idRuta = json['idRuta'];
    idUser = json['idUser'];
    fechaAlta = json['fechaAlta'];
    nombre = json['nombre'];
    estado = json['estado'];

    if (json['paradas'] != null) {
      paradas = <Parada>[];
      json['paradas'].forEach((v) {
        paradas!.add(Parada.fromJson(v));
      });
    }
    if (json['envios'] != null) {
      envios = <Envio>[];
      json['envios'].forEach((v) {
        envios!.add(Envio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idRuta'] = idRuta;
    data['idUser'] = idUser;
    data['fechaAlta'] = fechaAlta;
    data['nombre'] = nombre;
    data['estado'] = estado;
    if (paradas != null) {
      data['paradas'] = paradas!.map((v) => v.toJson()).toList();
    }
    if (envios != null) {
      data['envios'] = envios!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'idRuta': idRuta,
      'idUser': idUser,
      'fechaAlta': fechaAlta,
      'nombre': nombre,
      'estado': estado,
      'paradas': paradas,
      'envios': envios,
    };
  }
}
