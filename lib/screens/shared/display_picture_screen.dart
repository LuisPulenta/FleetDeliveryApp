import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fleetdeliveryapp/models/models.dart';

class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureScreen({Key? key, required this.image}) : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la foto'),
      ),
      body: Column(
        children: [
          Image.file(
            File(widget.image.path),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return const Color(0xFF120E43);
                        }),
                      ),
                      onPressed: () {
                        Response response =
                            Response(isSuccess: true, result: widget.image);
                        Navigator.pop(context, response);
                      },
                      child: const Text('Usar Foto'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return const Color(0xFFE03B8B);
                        }),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver a tomar'),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
