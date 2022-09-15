import 'package:fleetdeliveryapp/models/proveedor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProveedores {
  static Future<Database> _openDBProveedores() async {
    return openDatabase(join(await getDatabasesPath(), 'proveedores.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE proveedores(id INTEGER , nombre TEXT, claveacceso TEXT, permiso INTEGER, permiso2 INTEGER, email INTEGER, iniciales TEXT, razonSocial TEXT, domicilio TEXT, mail INTEGER, telefono INTEGER, responsable TEXT, condicionesContrato TEXT, tag INTEGER, estado INTEGER, cuit TEXT, importacionGenerica INTEGER, enviarNotifAdestinatario INTEGER, enviarCopiaAcliente INTEGER, enviarResumenNotifAcliente INTEGER, pesoCaja TEXT, altoCaja TEXT, anchoCaja TEXT, largoCaja TEXT, pesoMaxPallet TEXT, altoMaxPallet TEXT, anchoMaxPallet TEXT, largoMaxPallet TEXT, cantidadDeCajas INTEGER)",
      );
    }, version: 1);
  }

  static Future<int> insertProveedor(Proveedor proveedor) async {
    Database database = await _openDBProveedores();
    return database.insert("proveedores", proveedor.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBProveedores();
    return database.delete("proveedores");
  }

  static Future<int> deleteall() async {
    Database database = await _openDBProveedores();
    return database.delete("proveedores");
  }

  static Future<List<Proveedor>> proveedores() async {
    Database database = await _openDBProveedores();
    final List<Map<String, dynamic>> proveedoresMap =
        await database.query("proveedores");
    return List.generate(
        proveedoresMap.length,
        (i) => Proveedor(
              id: proveedoresMap[i]['id'],
              nombre: proveedoresMap[i]['nombre'],
              claveacceso: proveedoresMap[i]['claveacceso'],
              permiso: proveedoresMap[i]['permiso'],
              permiso2: proveedoresMap[i]['permiso2'],
              email: proveedoresMap[i]['email'],
              iniciales: proveedoresMap[i]['iniciales'],
              razonSocial: proveedoresMap[i]['razonSocial'],
              domicilio: proveedoresMap[i]['domicilio'],
              mail: proveedoresMap[i]['mail'],
              telefono: proveedoresMap[i]['telefono'],
              responsable: proveedoresMap[i]['responsable'],
              condicionesContrato: proveedoresMap[i]['condicionesContrato'],
              tag: proveedoresMap[i]['tag'],
              estado: proveedoresMap[i]['estado'],
              cuit: proveedoresMap[i]['cuit'],
              importacionGenerica: proveedoresMap[i]['importacionGenerica'],
              enviarNotifAdestinatario: proveedoresMap[i]
                  ['enviarNotifAdestinatario'],
              enviarCopiaAcliente: proveedoresMap[i]['enviarCopiaAcliente'],
              enviarResumenNotifAcliente: proveedoresMap[i]
                  ['enviarResumenNotifAcliente'],
              pesoCaja: proveedoresMap[i]['pesoCaja'],
              altoCaja: proveedoresMap[i]['altoCaja'],
              anchoCaja: proveedoresMap[i]['anchoCaja'],
              largoCaja: proveedoresMap[i]['largoCaja'],
              pesoMaxPallet: proveedoresMap[i]['pesoMaxPallet'],
              altoMaxPallet: proveedoresMap[i]['altoMaxPallet'],
              anchoMaxPallet: proveedoresMap[i]['anchoMaxPallet'],
              largoMaxPallet: proveedoresMap[i]['largoMaxPallet'],
              cantidadDeCajas: proveedoresMap[i]['cantidadDeCajas'],
            ));
  }
}
