import 'package:fleetdeliveryapp/models/paradaenvio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBParadasEnvios {
  static Future<Database> _openDBParadasEnvios() async {
    return openDatabase(join(await getDatabasesPath(), 'paradasenvios.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE paradasenvios(idParada INTEGER,idRuta INTEGER,idEnvio INTEGER,secuencia INTEGER,leyenda TEXT,latitud DOUBLE,longitud DOUBLE,idproveedor INTEGER,estado INTEGER,ordenid TEXT,titular TEXT,dni TEXT,domicilio TEXT,cp TEXT,entreCalles TEXT,telefonos TEXT,localidad TEXT, bultos INTEGER, proveedor TEXT,motivo INTEGER, motivodesc TEXT,notas TEXT,enviado INTEGER, fecha TEXT,imageArray TEXT, observaciones TEXT,enviadoparada INTEGER,enviadoenvio INTEGER,enviadoseguimiento INTEGER)",
      );
    }, version: 2);
  }

  static Future<int> insertParadaEnvio(ParadaEnvio paradaenvio) async {
    Database database = await _openDBParadasEnvios();
    return database.insert("paradasenvios", paradaenvio.toMap());
  }

  static Future<int> delete(ParadaEnvio paradaenvio) async {
    Database database = await _openDBParadasEnvios();
    return database.delete("paradasenvios",
        where: "idParada = ?", whereArgs: [paradaenvio.idParada]);
  }

  static Future<int> update(ParadaEnvio paradaenvio) async {
    Database database = await _openDBParadasEnvios();
    return database.update("paradasenvios", paradaenvio.toMap(),
        where: "idParada = ?", whereArgs: [paradaenvio.idParada]);
  }

  static Future<int> deleteall() async {
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
              motivodesc: paradasenviosMap[i]['motivodesc'],
              notas: paradasenviosMap[i]['notas'],
              enviado: paradasenviosMap[i]['enviado'],
              fecha: paradasenviosMap[i]['fecha'],
              imageArray: paradasenviosMap[i]['imageArray'],
              observaciones: paradasenviosMap[i]['observaciones'],
              enviadoparada: paradasenviosMap[i]['enviadoparada'],
              enviadoenvio: paradasenviosMap[i]['enviadoenvio'],
              enviadoseguimiento: paradasenviosMap[i]['enviadoseguimiento'],
            ));
  }
}
