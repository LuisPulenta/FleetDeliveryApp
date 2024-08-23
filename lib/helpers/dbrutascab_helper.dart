import 'package:fleetdeliveryapp/models/rutacab.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBRutasCab {
  static Future<Database> _openDBRutas() async {
    return openDatabase(join(await getDatabasesPath(), 'rutascab.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE rutascab(idRuta INTEGER, idUser INTEGER, fechaAlta TEXT, nombre TEXT, estado INTEGER, habilitaCatastro INTEGER, totalParadas INTEGER, pendientes INTEGER)",
      );
    }, version: 2);
  }

  static Future<int> insertRuta(RutaCab ruta) async {
    Database database = await _openDBRutas();
    return database.insert("rutascab", ruta.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBRutas();
    return database.delete("rutascab");
  }

  static Future<int> deleteall() async {
    Database database = await _openDBRutas();
    return database.delete("rutascab");
  }

  static Future<int> update(RutaCab ruta) async {
    Database database = await _openDBRutas();
    return database.update("rutascab", ruta.toMap(),
        where: "idRuta = ?", whereArgs: [ruta.idRuta]);
  }

  static Future<List<RutaCab>> rutas() async {
    Database database = await _openDBRutas();
    final List<Map<String, dynamic>> rutasMap =
        await database.query("rutascab");
    return List.generate(
        rutasMap.length,
        (i) => RutaCab(
              idRuta: rutasMap[i]['idRuta'],
              idUser: rutasMap[i]['idUser'],
              fechaAlta: rutasMap[i]['fechaAlta'],
              nombre: rutasMap[i]['nombre'],
              estado: rutasMap[i]['estado'],
              habilitaCatastro: rutasMap[i]['habilitaCatastro'],
              totalParadas: rutasMap[i]['totalParadas'],
              pendientes: rutasMap[i]['pendientes'],
            ));
  }
}
