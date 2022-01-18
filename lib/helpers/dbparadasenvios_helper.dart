import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBParadasEnvios {
  static Future<Database> _openDBParadasEnvios() async {
    return openDatabase(join(await getDatabasesPath(), 'paradas.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE paradas(idParada INTEGER,idRuta INTEGER,idEnvio INTEGER,secuencia INTEGER,leyenda TEXT,latitud DOUBLE,longitud DOUBLE,idproveedor INTEGER,estado INTEGER,ordenid TEXT,titular TEXT,dni TEXT,domicilio TEXT,cp TEXT,entreCalles TEXT,telefonos TEXT,localidad TEXT, bultos INTEGER, proveedor TEXT,motivo INTEGER,notas TEXT,enviado INTEGER)",
      );
    }, version: 1);
  }

  static Future<int> insertParadaEnvio(ParadaEnvio paradaenvio) async {
    Database database = await _openDBParadasEnvios();
    return database.insert("paradasenvios", paradaenvio.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBParadasEnvios();
    return database.delete("paradasenvios");
  }

  static Future<List<ParadaEnvio>> paradasenvios() async {
    Database database = await _openDBParadasEnvios();
    final List<Map<String, dynamic>> paradasenviosMap =
        await database.query("paradasenvios");
    return List.generate(
        paradasenviosMap.length,
        (i) => ParadaEnvio(
              idParada: paradasenviosMap[i]['idParada'],
              idRuta: paradasenviosMap[i]['idRuta'],
              idEnvio: paradasenviosMap[i]['idEnvio'],
              secuencia: paradasenviosMap[i]['secuencia'],
              leyenda: paradasenviosMap[i]['leyenda'],
              latitud: paradasenviosMap[i]['latitud'],
              longitud: paradasenviosMap[i]['longitud'],
              idproveedor: paradasenviosMap[i]['idproveedor'],
              estado: paradasenviosMap[i]['estado'],
              ordenid: paradasenviosMap[i]['ordenid'],
              titular: paradasenviosMap[i]['titular'],
              dni: paradasenviosMap[i]['dni'],
              domicilio: paradasenviosMap[i]['domicilio'],
              cp: paradasenviosMap[i]['cp'],
              entreCalles: paradasenviosMap[i]['entreCalles'],
              telefonos: paradasenviosMap[i]['telefonos'],
              localidad: paradasenviosMap[i]['localidad'],
              bultos: paradasenviosMap[i]['bultos'],
              proveedor: paradasenviosMap[i]['proveedor'],
              motivo: paradasenviosMap[i]['motivo'],
              notas: paradasenviosMap[i]['notas'],
              enviado: paradasenviosMap[i]['enviado'],
            ));
  }
}
