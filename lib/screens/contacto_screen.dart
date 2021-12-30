import 'package:flutter/material.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacto"),
      ),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 60),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(
                  (0xffe9dac2),
                ),
                Color(
                  (0xffd3a735),
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "assets/kplogo.png",
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Key_Press Software Developers",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Mistol 71 Mi Valle Golf, Va. Parque Santa Ana",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Córdoba - Argentina (5101)",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.phone),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "54 9 3513002255",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.mail),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "info@keypress.com.ar",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.language),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "www.keypress.com.ar",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
