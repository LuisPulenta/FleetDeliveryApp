import 'package:fleetdeliveryapp/models/web_sesion.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBWebSesions {
  static Future<Database> _openDBWebSesions() async {
    return openDatabase(join(await getDatabasesPath(), 'websesions.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE websesions(id_ws INTEGER , nroConexion INTEGER, usuario TEXT, iP TEXT, loginDate TEXT,  loginTime INTEGER, modulo TEXT, logoutDate TEXT, logoutTime INTEGER, conectAverage INTEGER, version TEXT)",
      );
    }, version: 1);
  }

  static Future<int> insertWebSesion(WebSesion webSesion) async {
    Database database = await _openDBWebSesions();
    return database.insert("websesions", webSesion.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBWebSesions();
    return database.delete("websesions");
  }

  static Future<List<WebSesion>> webSesions() async {
    Database database = await _openDBWebSesions();
    final List<Map<String, dynamic>> webSesionsMap =
        await database.query("websesions");
    return List.generate(
        webSesionsMap.length,
        (i) => WebSesion(
              id_ws: webSesionsMap[i]['id_ws'],
              nroConexion: webSesionsMap[i]['nroConexion'],
              usuario: webSesionsMap[i]['usuario'],
              iP: webSesionsMap[i]['iP'],
              loginDate: webSesionsMap[i]['loginDate'],
              loginTime: webSesionsMap[i]['loginTime'],
              modulo: webSesionsMap[i]['modulo'],
              logoutDate: webSesionsMap[i]['logoutDate'],
              logoutTime: webSesionsMap[i]['logoutTime'],
              conectAverage: webSesionsMap[i]['conectAverage'],
              version: webSesionsMap[i]['version'],
            ));
  }
}
