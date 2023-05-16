import 'package:fleetdeliveryapp/models/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBUsuarios {
  static Future<Database> _openDBUsuarios() async {
    return openDatabase(join(await getDatabasesPath(), 'usuarios.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE usuarios(idUser INTEGER , codigo TEXT, apellidonombre TEXT, usrlogin TEXT, usrcontrasena TEXT,  habilitadoWeb INTEGER, vehiculo TEXT, dominio TEXT, celular TEXT, orden INTEGER, centroDistribucion INTEGER, dni TEXT)",
      );
    }, version: 2);
  }

  static Future<int> insertUsuario(Usuario usuario) async {
    Database database = await _openDBUsuarios();
    return database.insert("usuarios", usuario.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBUsuarios();
    return database.delete("usuarios");
  }

  static Future<int> deleteall() async {
    Database database = await _openDBUsuarios();
    return database.delete("usuarios");
  }

  static Future<int> update(Usuario usuario) async {
    Database database = await _openDBUsuarios();
    return database.update("usuarios", usuario.toMap(),
        where: "idUser = ?", whereArgs: [usuario.idUser]);
  }

  static Future<List<Usuario>> usuarios() async {
    Database database = await _openDBUsuarios();
    final List<Map<String, dynamic>> usuariosMap =
        await database.query("usuarios");
    return List.generate(
        usuariosMap.length,
        (i) => Usuario(
              idUser: usuariosMap[i]['idUser'],
              codigo: usuariosMap[i]['codigo'],
              apellidonombre: usuariosMap[i]['apellidonombre'],
              usrlogin: usuariosMap[i]['usrlogin'],
              usrcontrasena: usuariosMap[i]['usrcontrasena'],
              habilitadoWeb: usuariosMap[i]['habilitadoWeb'],
              vehiculo: usuariosMap[i]['vehiculo'],
              dominio: usuariosMap[i]['dominio'],
              celular: usuariosMap[i]['celular'],
              orden: usuariosMap[i]['orden'],
              centroDistribucion: usuariosMap[i]['centroDistribucion'],
              dni: usuariosMap[i]['dni'],
            ));
  }
}
