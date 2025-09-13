import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_whatsapp_plus/share_whatsapp_plus.dart';

// import 'package:whatsapp_share/whatsapp_share.dart';

class PdfScreen extends StatelessWidget {
  final String phone;
  final String ruta;

  const PdfScreen({super.key, required this.phone, required this.ruta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualización PDF'),
        centerTitle: true,
        backgroundColor: const Color(0xff282886),
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
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 4, 244, 100),
        onPressed: () async {
          XFile xFile = XFile(ruta);

          await shareWhatsappPlus.share(
            text: 'Se adjunta Comprobante',
            phone: phone,
            file: xFile,
          );

          // WhatsappShare.shareFile(
          //   phone: phone,
          //   text: 'Se adjunta Comprobante',
          //   filePath: [ruta],
          //   package: Package.whatsapp,
          // );
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}
