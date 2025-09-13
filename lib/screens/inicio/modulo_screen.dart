import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';

class ModuloScreen extends StatefulWidget {
  final Modulo modulo;
  const ModuloScreen({Key? key, required this.modulo}) : super(key: key);

  @override
  State<ModuloScreen> createState() => _ModuloScreenState();
}

class _ModuloScreenState extends State<ModuloScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------
  String _modulo = '';
  String _moduloError = '';
  bool _moduloShowError = false;
  final TextEditingController _moduloController = TextEditingController();

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moduloController.text = widget.modulo.nroVersion.toString();
    var a = 1;
    setState(() {});
  }

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF282886),
        title: const Text('Módulo'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text('El Módulo debe tener el formato',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(
              height: 20,
            ),
            const Text('x.x.xx',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            _showModulo(),
            const SizedBox(
              height: 20,
            ),
            _showButton(),
          ],
        ),
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _showModulo ------------------------
//----------------------------------------------------------

  Widget _showModulo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _moduloController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Módulo...',
            labelText: 'Módulo',
            errorText: _moduloShowError ? _moduloError : null,
            prefixIcon: const Icon(Icons.numbers),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _modulo = value;
        },
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _showButton ------------------------
//----------------------------------------------------------

  Widget _showButton() {
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
                  onPressed: () => _save(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Guardar'),
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

//---------------------------------------------------------------------
//---------------------------- _save ----------------------------------
//---------------------------------------------------------------------

  void _save() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
      return;
    }

    Map<String, dynamic> request = {
      'IdModulo': 4,
      'NroVersion': _modulo,
    };

    Response response = await ApiHelper.put('/api/Modulos/', '4', request);

    if (!response.isSuccess) {
      showMyDialog('Error', response.message, 'Aceptar');
      return;
    }
    Navigator.pop(context, 'yes');
  }
}
