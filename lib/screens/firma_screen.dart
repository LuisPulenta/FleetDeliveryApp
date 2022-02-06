import 'dart:ui' as ui;
import 'package:fleetdeliveryapp/models/response.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class FirmaScreen extends StatefulWidget {
  const FirmaScreen({Key? key}) : super(key: key);

  @override
  _FirmaScreenState createState() => _FirmaScreenState();
}

class _FirmaScreenState extends State<FirmaScreen> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    Response response = Response(isSuccess: true, result: bytes);
    Navigator.pop(context, response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Firma"),
          centerTitle: true,
          backgroundColor: Color(0xff282886),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          color: Color(0xFFC7C7C8),
          child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        child: SfSignaturePad(
                            key: signatureGlobalKey,
                            backgroundColor: Colors.white,
                            strokeColor: Colors.black,
                            minimumStrokeWidth: 1.0,
                            maximumStrokeWidth: 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)))),
                SizedBox(height: 10),
                Row(children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(
                              width: 12,
                            ),
                            Text('Usar Firma', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF120E43),
                          minimumSize: Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _handleSaveButtonPressed),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 12,
                          ),
                          Text('Borrar', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFE03B8B),
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: _handleClearButtonPressed,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center),
        ));
  }
}
