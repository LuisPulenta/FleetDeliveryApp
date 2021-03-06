import 'dart:convert';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:fleetdeliveryapp/models/zona.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiHelper {
//---------------------------------------------------------------------------
  static Future<Response> put(
      String controller, String id, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> post(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> delete(String controller, String id) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> getUsuarios() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Usuarios');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Usuario> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Usuario.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getProveedores() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Proveedores');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Proveedor> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Proveedor.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getMotivos() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Motivos');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Motivo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Motivo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getNroRegistroMax() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Seguimientos/GetNroRegistroMax');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);

    return Response(isSuccess: true, result: decodedJson);
  }

//---------------------------------------------------------------------------
  static Future<Response> getRutas(int codigo) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Usuarios/GetRutas/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Ruta> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Ruta.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getTipoAsignaciones(int codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Usuarios/GetTiposAsignaciones/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<TipoAsignacion> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TipoAsignacion.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getZonas(int codigo, String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Usuarios/GetZonas/$codigo/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Zona> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Zona.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCarteras(int codigo, String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Usuarios/GetCarteras/$codigo/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Cartera> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Cartera.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getAsignaciones(
      int codigo, String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Usuarios/GetAsignaciones/$codigo/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Asignacion2> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Asignacion2.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCodigosCierre(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Usuarios/GetCodigosCierre/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<CodigoCierre> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CodigoCierre.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getAutonumericos(Map<String, dynamic> request) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/AsignacionesOTs/GetAutonumericos');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Asign> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Asign.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getFuncionesApp(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Usuarios/GetFuncionesApps/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<FuncionesApp> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(FuncionesApp.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getControlesEquivalencia(
      String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/AsignacionesOTs/GetControlesEquivalencia/$proyectomodulo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<ControlesEquivalencia> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(ControlesEquivalencia.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> putWebSesion(int nroConexion) async {
    var url = Uri.parse('${Constants.apiUrl}/api/WebSesions/$nroConexion');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: decodedJson);
  }

//---------------------------------------------------------------------------
  static Future<Response> getParadaByIDParada(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Paradas/GetParadaByIDParada/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Parada.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> getEnvioByIdEnvio(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Envios/GetEnvioByIdEnvio/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Envio.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> getUltimoSeguimientoByIdEnvio(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Seguimientos/GetUltimoSeguimientoByIdEnvio/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Seguimiento.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> getModulo(String codigo) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Modulos/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Modulo.fromJson(decodedJson));
  }
}
