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
        paradas!.add(new Parada.fromJson(v));
      });
    }
    if (json['envios'] != null) {
      envios = <Envio>[];
      json['envios'].forEach((v) {
        envios!.add(new Envio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRuta'] = this.idRuta;
    data['idUser'] = this.idUser;
    data['fechaAlta'] = this.fechaAlta;
    data['nombre'] = this.nombre;
    data['estado'] = this.estado;
    if (this.paradas != null) {
      data['paradas'] = this.paradas!.map((v) => v.toJson()).toList();
    }
    if (this.envios != null) {
      data['envios'] = this.envios!.map((v) => v.toJson()).toList();
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
