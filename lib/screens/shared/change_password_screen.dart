import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fleetdeliveryapp/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:fleetdeliveryapp/components/loader_component.dart';
import 'package:fleetdeliveryapp/models/models.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Usuario user;
  const ChangePasswordScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  bool _showLoader = false;

  Usuario _user = Usuario(
      idUser: 0,
      codigo: '',
      apellidonombre: '',
      usrlogin: '',
      usrcontrasena: '',
      habilitadoWeb: 0,
      vehiculo: '',
      dominio: '',
      celular: '',
      orden: 0,
      centroDistribucion: 0,
      dni: '',
      mail: '',
      claveEmail: '');

  String _currentPassword = '';
  String _currentPasswordError = '';
  bool _currentPasswordShowError = false;
  TextEditingController _currentPasswordController = TextEditingController();

  String _newPassword = '';
  String _newPasswordError = '';
  bool _newPasswordShowError = false;
  TextEditingController _newPasswordController = TextEditingController();

  String _confirmPassword = '';
  String _confirmPasswordError = '';
  bool _confirmPasswordShowError = false;
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordShow = false;

//--------------------------------------------------------
//--------------------- initState ------------------------
//--------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffe9dac2),
        appBar: AppBar(
          title: const Text('Cambio de Contraseña'),
          centerTitle: true,
          backgroundColor: const Color(0xff282886),
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                _showCurrentPassword(),
                _showNewPassword(),
                _showConfirmPassword(),
                _showButtons(),
              ],
            ),
            _showLoader
                ? const LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

//--------------------------------------------------------
//--------------------- _showCurrentPassword -------------
//--------------------------------------------------------

  Widget _showCurrentPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la contraseña actual...',
          labelText: 'Contraseña actual',
          errorText: _currentPasswordShowError ? _currentPasswordError : null,
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _currentPassword = value;
        },
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showNewPassword -----------------
//--------------------------------------------------------

  Widget _showNewPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la nueva contraseña...',
          labelText: 'Nueva Contraseña',
          errorText: _newPasswordShowError ? _newPasswordError : null,
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _newPassword = value;
        },
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showConfirmPassword -------------
//--------------------------------------------------------

  Widget _showConfirmPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Confirmación de contraseña...',
          labelText: 'Confirmación de contraseña',
          errorText: _confirmPasswordShowError ? _confirmPasswordError : null,
          prefixIcon: const Icon(Icons.lock),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _confirmPassword = value;
        },
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showButtons ---------------------
//--------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showChangePassword(),
        ],
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _showChangePassword --------------
//--------------------------------------------------------

  Widget _showChangePassword() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff282886),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _save(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock),
            SizedBox(
              width: 15,
            ),
            Text('Cambiar contraseña'),
          ],
        ),
      ),
    );
  }

//--------------------------------------------------------
//--------------------- _save ----------------------------
//--------------------------------------------------------

  void _save() async {
    if (!validateFields()) {
      return;
    }
    _changePassword();
  }

//--------------------------------------------------------
//--------------------- validateFields -------------------
//--------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_currentPassword.length < 4) {
      isValid = false;
      _currentPasswordShowError = true;
      _currentPasswordError =
          'Debes ingresar tu Contraseña actual de al menos 4 caracteres';
    } else {
      _currentPasswordShowError = false;
    }

    if (_currentPassword.toUpperCase() !=
        widget.user.usrcontrasena.toUpperCase()) {
      isValid = false;
      _currentPasswordShowError = true;
      _currentPasswordError = 'Debes ingresar tu Contraseña actual';
    } else {
      _currentPasswordShowError = false;
    }

    if (_newPassword.length < 4) {
      isValid = false;
      _newPasswordShowError = true;
      _newPasswordError =
          'Debes ingresar una Contraseña de al menos 4 caracteres';
    } else {
      _newPasswordShowError = false;
    }

    if (_confirmPassword.length < 4) {
      isValid = false;
      _confirmPasswordShowError = true;
      _confirmPasswordError =
          'Debes ingresar una Confirmación de Contraseña de al menos 4 caracteres';
    } else {
      _confirmPasswordShowError = false;
    }

    if (_confirmPassword.length >= 4 && _newPassword.length >= 4) {
      if (_confirmPassword != _newPassword) {
        isValid = false;
        _newPasswordShowError = true;
        _confirmPasswordShowError = true;
        _newPasswordError = 'La contraseña y la confirmación no son iguales';
        _confirmPasswordError =
            'La contraseña y la confirmación no son iguales';
      } else {
        _newPasswordShowError = false;
        _confirmPasswordShowError = false;
      }
    }

    setState(() {});

    return isValid;
  }

//--------------------------------------------------------
//--------------------- _changePassword ------------------
//--------------------------------------------------------

  void _changePassword() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'IDUser': widget.user.idUser,
      'NewPassword': _newPassword.toUpperCase(),
    };

    Response response = await ApiHelper.put(
        '/api/Usuarios/', widget.user.idUser.toString(), request);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: 'Su contraseña ha sido cambiada con éxito.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
    _user.usrcontrasena = _newPassword.toUpperCase();
    DBUsuarios.update(_user);
    Navigator.pop(context, 'yes');
  }
}
