import 'package:fleetdeliveryapp/models/ruta.dart';
import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBRutas {
  static Future<Database> _openDBRutas() async {
    return openDatabase(join(await getDatabasesPath(), 'rutas.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE rutas(id INTEGER, idFletero INTEGER, fechaAlta TEXT, nombre TEXT, estado INTEGER)",
      );
    }, version: 1);
  }

  static Future<int> insertRuta(Ruta ruta) async {
    Database database = await _openDBRutas();
    return database.insert("rutas", ruta.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBRutas();
    return database.delete("rutas");
  }

  static Future<List<Ruta>> rutas() async {
    Database database = await _openDBRutas();
    final List<Map<String, dynamic>> rutasMap = await database.query("rutas");
    return List.generate(
        rutasMap.length,
        (i) => Ruta(
              id: rutasMap[i]['id'],
              idFletero: rutasMap[i]['idFletero'],
              fechaAlta: rutasMap[i]['fechaAlta'],
              nombre: rutasMap[i]['nombre'],
              estado: rutasMap[i]['estado'],
            ));
  }
}
