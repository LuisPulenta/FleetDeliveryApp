import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  const LoaderComponent({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 160,
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xff282886),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xff282886),
            ),
            SizedBox(
              height: 20,
            ),
            Text(text, style: TextStyle(fontSize: 15)),
            SizedBox(
              height: 20,
            ),
            Text("Por favor espere...", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
