import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../screens.dart';

class AdministradorScreen extends StatefulWidget {
  final Modulo modulo;
  const AdministradorScreen({Key? key, required this.modulo}) : super(key: key);

  @override
  State<AdministradorScreen> createState() => _AdministradorScreenState();
}

class _AdministradorScreenState extends State<AdministradorScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF282886),
        title: const Text('Administrador'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            _showButtons(),
          ],
        ),
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _showButton ------------------------
//----------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF282886),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModuloScreen(
                                  modulo: widget.modulo,
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Módulo'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF282886),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ResetearPasswordsScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.password),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Reactivar Usuario GAOS'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
