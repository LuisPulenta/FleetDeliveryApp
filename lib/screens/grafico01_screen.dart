import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/helpers/api_helper.dart';
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Grafico01Screen extends StatefulWidget {
  final Usuario user;

  Grafico01Screen({Key? key, required this.user}) : super(key: key);

  @override
  State<Grafico01Screen> createState() => _Grafico01ScreenState();
}

class _Grafico01ScreenState extends State<Grafico01Screen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  bool _showLoader = false;
  bool bandera = false;
  int intentos = 0;
  List<TipoAsignacion> _tiposasignacion = [];
  String _tipoasignacion = 'Elija un Tipo de Asignación...';
  String _tipoasignacionError = '';
  bool _tipoasignacionShowError = false;
  List<DropdownMenuItem<int>> _meses = [];
  List<Option> _listoptions = [];
  DateTime _selectedDate = DateTime.now();
  int _optionMes = DateTime.now().month;
  int _mes = 0;
  int _anio = DateTime.now().year;

  int _asignados = 0;
  int _ejecutados = 0;

  String _optionMesError = '';
  bool _optionMesShowError = false;

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asign. vs. Ejecut.'),
        backgroundColor: const Color(0xFF282886),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        color: const Color(0xFFC7C7C8),
        child: Center(
          child: _showLoader
              ? const LoaderComponent(
                  text: 'Cargando ASIGNACIONES.',
                )
              : _getContent(),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5),
                          child: const Text(('Mes: ')),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5),
                          child: DropdownButtonFormField(
                              items: _meses,
                              value: _optionMes,
                              onChanged: (option) {
                                setState(() {
                                  _optionMes = option as int;
                                  _mes = option;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Seleccione un Mes...',
                                labelText: '',
                                fillColor: Colors.white,
                                filled: true,
                                errorText: _optionMesShowError
                                    ? _optionMesError
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                        ),
                      ],
                    )),
                Container(
                  width: 60,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 24),
                        child: Text(('Año: ')),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        width: 100,
                        height: 30,
                        child: Text(
                          _anio.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: const Color(0xFF282886),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF282886),
                          minimumSize: const Size(40, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(flex: 4, child: _showTipos()),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.equalizer),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF282886),
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () => _grafico01(),
              ),
            ),
          ],
        ),
        Text("Asignados:"),
        Text(_asignados.toString()),
        Text("Ejecutados:"),
        Text(_ejecutados.toString()),
      ],
    );
  }

//*****************************************************************************
//************************** METODO LOADDATA **********************************
//*****************************************************************************

  void _loadData() async {
    await _getTiposAsignaciones();
    _getlistOptions();
  }

//*****************************************************************************
//************************** METODO GETTIPOASIGNACIONES ***********************
//*****************************************************************************

  Future<void> _getTiposAsignaciones() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getTipoAsignaciones(widget.user.idUser);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _tiposasignacion = response.result;
      }
    } while (bandera == false);

    setState(() {});
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWTIPOS-------------------------------------
//-----------------------------------------------------------------------------

  Widget _showTipos() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _tiposasignacion.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Cargando Tipos de Asignación...'),
                    ],
                  )
                : DropdownButtonFormField(
                    value: _tipoasignacion,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Elija un Tipo de Asignación...',
                      labelText: 'Tipo de Asignación',
                      errorText: _tipoasignacionShowError
                          ? _tipoasignacionError
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _getComboTiposAsignacion(),
                    onChanged: (value) {
                      _tipoasignacion = value.toString();
                    },
                  ),
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ _getComboTiposAsignacion----------------------
//-----------------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboTiposAsignacion() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija un Tipo de Asignación...'),
      value: 'Elija un Tipo de Asignación...',
    ));

    for (var tipoasignacion in _tiposasignacion) {
      list.add(DropdownMenuItem(
        child: Text(tipoasignacion.proyectomodulo.toString()),
        value: tipoasignacion.proyectomodulo.toString(),
      ));
    }

    return list;
  }

//*****************************************************************************
//************************** METODO GETLISTOPTIONS ****************************
//*****************************************************************************

  void _getlistOptions() {
    _meses = [];
    _listoptions = [];

    Option opt01 = Option(id: 1, description: 'Enero');
    Option opt02 = Option(id: 2, description: 'Febrero');
    Option opt03 = Option(id: 3, description: 'Marzo');
    Option opt04 = Option(id: 4, description: 'Abril');
    Option opt05 = Option(id: 5, description: 'Mayo');
    Option opt06 = Option(id: 6, description: 'Junio');
    Option opt07 = Option(id: 7, description: 'Julio');
    Option opt08 = Option(id: 8, description: 'Agosto');
    Option opt09 = Option(id: 9, description: 'Setiembre');
    Option opt10 = Option(id: 10, description: 'Octubre');
    Option opt11 = Option(id: 11, description: 'Noviembre');
    Option opt12 = Option(id: 12, description: 'Diciembre');
    _listoptions.add(opt01);
    _listoptions.add(opt02);
    _listoptions.add(opt03);
    _listoptions.add(opt04);
    _listoptions.add(opt05);
    _listoptions.add(opt06);
    _listoptions.add(opt07);
    _listoptions.add(opt08);
    _listoptions.add(opt09);
    _listoptions.add(opt10);
    _listoptions.add(opt11);
    _listoptions.add(opt12);

    _getComboMeses();
  }

//***************************************************************************
//************************** METODO GETCOMBOMESES ***************************
//***************************************************************************

  List<DropdownMenuItem<int>> _getComboMeses() {
    _meses = [];

    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Seleccione un Mes...'),
      value: 0,
    ));

    for (var _listoption in _listoptions) {
      list.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.id,
      ));
    }

    _meses = list;

    return list;
  }

//*****************************************************************************
//************************** _selectDate **************************************
//*****************************************************************************
  // Call this in the select year button.
  void _selectDate(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final Size size = MediaQuery.of(context).size;
        return AlertDialog(
          title: Text('Seleccione el año'),
          // Changing default contentPadding to make the content looks better

          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          content: SizedBox(
            // Giving some size to the dialog so the gridview know its bounds

            height: size.height / 3,
            width: size.width,
            //  Creating a grid view with 3 elements per line.
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                // Generating a list of 123 years starting from 2022
                // Change it depending on your needs.
                ...List.generate(
                  6,
                  (index) => InkWell(
                    onTap: () {
                      // The action you want to happen when you select the year below,
                      _anio = DateTime.now().year - index;
                      setState(() {});

                      // Quitting the dialog through navigator.
                      Navigator.pop(context);
                    },
                    // This part is up to you, it's only ui elements
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Chip(
                        backgroundColor: const Color(0xFF282886),
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                              // Showing the year text, it starts from 2022 and ends in 1900 (you can modify this as you like)
                              (DateTime.now().year - index).toString(),
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
//*****************************************************************************
//************************** METODO SAVE **************************************
//*****************************************************************************

  _grafico01() async {
    if (!validateFields()) {
      return;
    }
    await _mostrarGrafico01();
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

  bool validateFields() {
    bool isValid = true;

    if (_tipoasignacion == 'Elija un Tipo de Asignación...') {
      isValid = false;
      _tipoasignacionShowError = true;
      _tipoasignacionError = 'Debes seleccionar un Tipo de Asignación';
    } else {
      _tipoasignacionShowError = false;
    }

    setState(() {});

    return isValid;
  }

//*****************************************************************************
//************************** _mostrarGrafico01 ********************************
//*****************************************************************************

  Future<void> _mostrarGrafico01() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'UserID': widget.user.idUser,
      'Anio': _anio,
      'Mes': _mes,
      'Proyecto': _tipoasignacion,
    };

    var response = await ApiHelper.post2(
        '/api/AsignacionesOTs/GetGrafico01Asignados', request);

    var response2 = await ApiHelper.post2(
        '/api/AsignacionesOTs/GetGrafico01Ejecutados', request);

    _asignados = 0;
    _ejecutados = 0;

    List<CantidadEntera> asign = response.result;
    List<CantidadEntera> ejec = response2.result;

    if (asign.length > 0) {
      _asignados = asign[0].cantidad!;
    }

    if (ejec.length > 0) {
      _ejecutados = ejec[0].cantidad!;
    }

    setState(() {});
  }
}
