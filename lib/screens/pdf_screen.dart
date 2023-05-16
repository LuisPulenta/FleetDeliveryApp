import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfScreen extends StatelessWidget {
  final String ruta;

  const PdfScreen({Key? key, required this.ruta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PdfScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: PDFView(
          filePath: ruta,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
        ),
      ),
    );
  }
}
