import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  const LoaderComponent({Key? key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 160,
        decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xff282886),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xff282886),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            //const Text("Por favor espere...", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
