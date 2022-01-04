import 'package:fleetdeliveryapp/models/parada.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBParadas {
  static Future<Database> _openDBParadas() async {
    return openDatabase(join(await getDatabasesPath(), 'paradas.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE paradas(id INTEGER,idRuta INTEGER,idEnvio INTEGER,tag INTEGER,secuencia INTEGER,leyenda TEXT,latitud DOUBLE,longitud DOUBLE,iconoPropio TEXT,iDmapa TEXT,distancia INTEGER,tiempo INTEGER,estado INTEGER,fecha TEXT,hora TEXT,idMotivo INTEGER,notaChofer TEXT,nuevoOrden INTEGER,idCabCertificacion INTEGER,idLiquidacionFletero INTEGER,turno TEXT)",
      );
    }, version: 1);
  }

  static Future<int> insertParada(Parada parada) async {
    Database database = await _openDBParadas();
    return database.insert("paradas", parada.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBParadas();
    return database.delete("paradas");
  }

  static Future<List<Parada>> paradas() async {
    Database database = await _openDBParadas();
    final List<Map<String, dynamic>> paradasMap =
        await database.query("paradas");
    return List.generate(
        paradasMap.length,
        (i) => Parada(
              id: paradasMap[i]['id'],
              idRuta: paradasMap[i]['idRuta'],
              idEnvio: paradasMap[i]['idEnvio'],
              tag: paradasMap[i]['tag'],
              secuencia: paradasMap[i]['secuencia'],
              leyenda: paradasMap[i]['leyenda'],
              latitud: paradasMap[i]['latitud'],
              longitud: paradasMap[i]['longitud'],
              iconoPropio: paradasMap[i]['iconoPropio'],
              iDmapa: paradasMap[i]['iDmapa'],
              distancia: paradasMap[i]['distancia'],
              tiempo: paradasMap[i]['tiempo'],
              estado: paradasMap[i]['estado'],
              fecha: paradasMap[i]['fecha'],
              hora: paradasMap[i]['hora'],
              idMotivo: paradasMap[i]['idMotivo'],
              notaChofer: paradasMap[i]['notaChofer'],
              nuevoOrden: paradasMap[i]['nuevoOrden'],
              idCabCertificacion: paradasMap[i]['idCabCertificacion'],
              idLiquidacionFletero: paradasMap[i]['idLiquidacionFletero'],
              turno: paradasMap[i]['turno'],
            ));
  }
}
