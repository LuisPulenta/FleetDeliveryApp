import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class PruebaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          child: Icon(Icons.qr_code_2),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF282886),
            minimumSize: Size(50, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () async {
            String barcodeScanRes;
            try {
              barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  '#3D8BEF', 'Cancelar', false, ScanMode.DEFAULT);
              print(barcodeScanRes);
              //e.estadO3 = barcodeScanRes;
            } on PlatformException {
              barcodeScanRes = 'Error';
            }
            //if (!mounted) return;
            if (barcodeScanRes == '-1') {
              return;
            }
          }),
    );
  }
}
