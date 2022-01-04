import 'package:fleetdeliveryapp/models/envio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBEnvios {
  static Future<Database> _openDBEnvios() async {
    return openDatabase(join(await getDatabasesPath(), 'envios.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE envios(id INTEGER,idproveedor INTEGER,agencianr INTEGER,estado INTEGER,envia TEXT,ruta TEXT,ordenid TEXT,fecha INTEGER,hora TEXT,imei TEXT,transporte TEXT,contrato TEXT,titular TEXT,dni TEXT,domicilio TEXT,cp TEXT,latitud DOUBLE,longitud DOUBLE,autorizado TEXT,observaciones TEXT,idCabCertificacion INTEGER,idRemitoProveedor INTEGER,idSubconUsrWeb INTEGER,fechaAlta TEXT,fechaEnvio TEXT,fechaDistribucion TEXT,entreCalles TEXT,mail TEXT,telefonos TEXT,localidad TEXT,tag INTEGER,provincia TEXT,fechaEntregaCliente TEXT,scaneadoIn TEXT,scaneadoOut TEXT,ingresoDeposito INTEGER,salidaDistribucion INTEGER,nroRuta INTEGER,nroSecuencia INTEGER,fechaHoraOptimoCamino TEXT,bultos INTEGER,peso TEXT,alto TEXT,ancho TEXT,largo TEXT,idComprobante INTEGER,enviarMailSegunEstado TEXT,fechaRuta TEXT,ordenIDparaOC TEXT,hashUnico TEXT,bultosPikeados INTEGER,centroDistribucion TEXT,fechaUltimaActualizacion TEXT,volumen TEXT,avonZoneNumber INTEGER,avonSectorNumber INTEGER,avonAccountNumber TEXT,avonCampaignNumber INTEGER,avonCampaignYear INTEGER,domicilioCorregido TEXT,domicilioCorregidoUsando INTEGER,urlFirma TEXT,urlDNI TEXT,ultimoIdMotivo INTEGER,ultimaNotaFletero TEXT,idComprobanteDevolucion INTEGER,turno TEXT,barrioEntrega TEXT,partidoEntrega TEXT,avonDayRoute INTEGER,avonTravelRoute INTEGER,avonSecuenceRoute INTEGER,avonInformarInclusion INTEGER)",
      );
    }, version: 1);
  }

  static Future<int> insertEnvio(Envio envio) async {
    Database database = await _openDBEnvios();
    return database.insert("envios", envio.toMap());
  }

  static Future<int> delete() async {
    Database database = await _openDBEnvios();
    return database.delete("envios");
  }

  static Future<List<Envio>> envios() async {
    Database database = await _openDBEnvios();
    final List<Map<String, dynamic>> enviosMap = await database.query("envios");
    return List.generate(
        enviosMap.length,
        (i) => Envio(
              id: enviosMap[i]['id'],
              idproveedor: enviosMap[i]['idproveedor'],
              agencianr: enviosMap[i]['agencianr'],
              estado: enviosMap[i]['estado'],
              envia: enviosMap[i]['envia'],
              ruta: enviosMap[i]['ruta'],
              ordenid: enviosMap[i]['ordenid'],
              fecha: enviosMap[i]['fecha'],
              hora: enviosMap[i]['hora'],
              imei: enviosMap[i]['imei'],
              transporte: enviosMap[i]['transporte'],
              contrato: enviosMap[i]['contrato'],
              titular: enviosMap[i]['titular'],
              dni: enviosMap[i]['dni'],
              domicilio: enviosMap[i]['domicilio'],
              cp: enviosMap[i]['cp'],
              latitud: enviosMap[i]['latitud'],
              longitud: enviosMap[i]['longitud'],
              autorizado: enviosMap[i]['autorizado'],
              observaciones: enviosMap[i]['observaciones'],
              idCabCertificacion: enviosMap[i]['idCabCertificacion'],
              idRemitoProveedor: enviosMap[i]['idRemitoProveedor'],
              idSubconUsrWeb: enviosMap[i]['idSubconUsrWeb'],
              fechaAlta: enviosMap[i]['fechaAlta'],
              fechaEnvio: enviosMap[i]['fechaEnvio'],
              fechaDistribucion: enviosMap[i]['fechaDistribucion'],
              entreCalles: enviosMap[i]['entreCalles'],
              mail: enviosMap[i]['mail'],
              telefonos: enviosMap[i]['telefonos'],
              localidad: enviosMap[i]['localidad'],
              tag: enviosMap[i]['tag'],
              provincia: enviosMap[i]['provincia'],
              fechaEntregaCliente: enviosMap[i]['fechaEntregaCliente'],
              scaneadoIn: enviosMap[i]['scaneadoIn'],
              scaneadoOut: enviosMap[i]['scaneadoOut'],
              ingresoDeposito: enviosMap[i]['ingresoDeposito'],
              salidaDistribucion: enviosMap[i]['salidaDistribucion'],
              nroRuta: enviosMap[i]['nroRuta'],
              nroSecuencia: enviosMap[i]['nroSecuencia'],
              fechaHoraOptimoCamino: enviosMap[i]['fechaHoraOptimoCamino'],
              bultos: enviosMap[i]['bultos'],
              peso: enviosMap[i]['peso'],
              alto: enviosMap[i]['alto'],
              ancho: enviosMap[i]['ancho'],
              largo: enviosMap[i]['largo'],
              idComprobante: enviosMap[i]['idComprobante'],
              enviarMailSegunEstado: enviosMap[i]['enviarMailSegunEstado'],
              fechaRuta: enviosMap[i]['fechaRuta'],
              ordenIDparaOC: enviosMap[i]['ordenIDparaOC'],
              hashUnico: enviosMap[i]['hashUnico'],
              bultosPikeados: enviosMap[i]['bultosPikeados'],
              centroDistribucion: enviosMap[i]['centroDistribucion'],
              fechaUltimaActualizacion: enviosMap[i]
                  ['fechaUltimaActualizacion'],
              volumen: enviosMap[i]['volumen'],
              avonZoneNumber: enviosMap[i]['avonZoneNumber'],
              avonSectorNumber: enviosMap[i]['avonSectorNumber'],
              avonAccountNumber: enviosMap[i]['avonAccountNumber'],
              avonCampaignNumber: enviosMap[i]['avonCampaignNumber'],
              avonCampaignYear: enviosMap[i]['avonCampaignYear'],
              domicilioCorregido: enviosMap[i]['domicilioCorregido'],
              domicilioCorregidoUsando: enviosMap[i]
                  ['domicilioCorregidoUsando'],
              urlFirma: enviosMap[i]['urlFirma'],
              urlDNI: enviosMap[i]['urlDNI'],
              ultimoIdMotivo: enviosMap[i]['ultimoIdMotivo'],
              ultimaNotaFletero: enviosMap[i]['ultimaNotaFletero'],
              idComprobanteDevolucion: enviosMap[i]['idComprobanteDevolucion'],
              turno: enviosMap[i]['turno'],
              barrioEntrega: enviosMap[i]['barrioEntrega'],
              partidoEntrega: enviosMap[i]['partidoEntrega'],
              avonDayRoute: enviosMap[i]['avonDayRoute'],
              avonTravelRoute: enviosMap[i]['avonTravelRoute'],
              avonSecuenceRoute: enviosMap[i]['avonSecuenceRoute'],
              avonInformarInclusion: enviosMap[i]['avonInformarInclusion'],
            ));
  }

  //  static Future<List<Envio>> envios2() async {
  //   Database database = await _openDBEnvios();
  //   var resultado =
  //       await database.query!("select * from p_Envios where NroRuta=1434 or NroRuta=1452");
  // }

}
