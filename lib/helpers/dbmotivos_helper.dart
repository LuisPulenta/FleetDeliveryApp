import 'package:fleetdeliveryapp/models/motivo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBMotivos {
  static Future<Database> _openDBMotivos() async {
    return openDatabase(join(await getDatabasesPath(), 'motivos.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE motivos(id INTEGER , motivo TEXT,muestraParaEntregado INTEGER,exclusivoCliente INTEGER,activo INTEGER)",
      );
    }, version: 3);
  }

  static Future<int> insertMotivo(Motivo motivo) async {
    Database database = await _openDBMotivos();
    return database.insert("motivos", motivo.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBMotivos();
    return database.delete("motivos");
  }

  static Future<int> deleteall() async {
    Database database = await _openDBMotivos();
    return database.delete("motivos");
  }

  static Future<List<Motivo>> motivos() async {
    Database database = await _openDBMotivos();
    final List<Map<String, dynamic>> motivosMap =
        await database.query("motivos");
    return List.generate(
        motivosMap.length,
        (i) => Motivo(
              id: motivosMap[i]['id'],
              motivo: motivosMap[i]['motivo'],
              muestraParaEntregado: motivosMap[i]['muestraParaEntregado'],
              exclusivoCliente: motivosMap[i]['exclusivoCliente'],
              activo: motivosMap[i]['activo'],
            ));
  }
}
