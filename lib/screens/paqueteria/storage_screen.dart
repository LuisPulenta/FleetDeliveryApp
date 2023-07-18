import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  //----------------------------------------------------------
  //---------------------- Variables -------------------------
  //----------------------------------------------------------

  List<RutaCab> _rutas = [];
  List<Parada> _paradas = [];
  List<Envio> _envios = [];
  List<Proveedor> _proveedores = [];
  List<Usuario> _usuarios = [];
  List<Motivo> _motivos = [];

  //----------------------------------------------------------
  //---------------------- initState -------------------------
  //----------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //----------------------------------------------------------
  //---------------------- Pantalla --------------------------
  //----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double ancho = 100;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos en BD Locales"),
        backgroundColor: const Color(0xff282886),
        centerTitle: true,
      ),
      body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(
                  (0xffdadada),
                ),
                Color(
                  (0xffb3b3b4),
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho,
                        child: const Text(
                          "Rutas:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_rutas.length.toString())
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho,
                        child: const Text(
                          "Paradas:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_paradas.length.toString())
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho,
                        child: const Text(
                          "Envíos:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_envios.length.toString())
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho,
                        child: const Text(
                          "Proveedores:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_proveedores.length.toString())
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho,
                        child: const Text(
                          "Usuarios:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_usuarios.length.toString())
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho,
                        child: const Text(
                          "Motivos:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_motivos.length.toString())
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  //----------------------------------------------------------
  //---------------------- _loadData -------------------------
  //----------------------------------------------------------

  void _loadData() async {
    _rutas = await DBRutasCab.rutas();
    _paradas = await DBParadas.paradas();
    _envios = await DBEnvios.envios();
    _proveedores = await DBProveedores.proveedores();
    _usuarios = await DBUsuarios.usuarios();
    _motivos = await DBMotivos.motivos();
    setState(() {});
  }
}
