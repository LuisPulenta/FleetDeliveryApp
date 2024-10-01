import 'dart:ui' as ui;
import 'package:fleetdeliveryapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class ContratoFirmaScreen extends StatefulWidget {
  final Asignacion2 asignacion;
  final String nroserie;
  const ContratoFirmaScreen(
      {Key? key, required this.asignacion, required this.nroserie})
      : super(key: key);

  @override
  _ContratoFirmaScreenState createState() => _ContratoFirmaScreenState();
}

class _ContratoFirmaScreenState extends State<ContratoFirmaScreen> {
//--------------------------------------------------------
//--------------------- Variables ------------------------
//--------------------------------------------------------

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    ui.Image image =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    Response response = Response(isSuccess: true, result: bytes);
    Navigator.pop(context, response);
  }

  List<String> meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Setiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

//--------------------------------------------------------
//--------------------- Pantalla -------------------------
//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Firma del Contrato"),
          centerTitle: true,
          backgroundColor: const Color(0xff282886),
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          color: const Color(0xFFC7C7C8),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Contrato de Comodato',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                            'Entre TELECENTRO S.A., CUIT: 30-64089726-7 (en adelante TELECENTRO), con domicilio en Brigadier Juan Manuel de Rosas 2860, San Justo, Provincia de Buenos Aires, CP: B1754FTU, por una parte, y por la otra, el Sr./a ${widget.asignacion.nombre}, DNI N° ${widget.asignacion.documento}, cliente de TELECENTRO N°: ${widget.asignacion.cliente}, con domicilio en ${widget.asignacion.domicilio}, (en adelante el Cliente), convienen en celebrar el presente Contrato de Comodato que se regirá por las siguientes cláusulas y condiciones: '),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Primera',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                          'Atento a que el Cliente ha solicitado el servicio denominado Wifi Mesh de Telecentro (en adelante el “Servicio”), recibe de TELECENTRO, en este acto, en carácter de "Comodato" y de plena conformidad el/ los siguiente/s equipo/s (en adelante el/los Equipo/s):',
                        ),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Cantidad de equipos: 1",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Denominación: ",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Marca: ",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "N de serie: ${widget.nroserie}",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Segunda',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "El CLIENTE declara conocer que el cableado interno instalado en su domicilio es una extensión de la red de TELECENTRO, todos sus componentes son propiedad de TELECENTRO, incluyendo los equipos electrónicos que allí se instalen, reservándose TELECENTRO el derecho de utilizar para sí o terceros las facilidades adicionales que los mismos puedan brindar para los distintos Servicios de Tecnologías de la Información y las Comunicaciones (Servicios TIC). El uso de los equipos instalados y todos los componentes de la red interna se regirán por las normas del “Comodato” (Arts. 1533 y subsiguientes del Código civil y Comercial). El CLIENTE se compromete a mantener el Equipo en el mismo estado de uso y conservación en que le fue entregado. Finalizada la prestación del servicio, TELECENTRO procederá a retirar el Equipo, previa coordinación con el cliente, quien deberá proponer una fecha a tal efecto en un plazo máximo de 30 (treinta) días  de solicitado el retiro por TELECENTRO."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Tercera',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "El “comodato” permanecerá vigente mientras el Cliente mantenga su situación de abonado a los servicios de TELECENTRO."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Cuarta',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "El Cliente declara conocer que cada Equipo comprende tanto el extensor de wifi mesh en sí, como la fuente de alimentación eléctrica de estos,, así como también cualquier otro elemento adicional que se entregue junto a los mismos. Por ello, si se produjere la pérdida y/o deterioro total o parcial del Equipo, atento lo establecido en las cláusulas precedentes, el Cliente deberá pagar a TELECENTRO el valor del mismo. A todo evento el Cliente declara tomar conocimiento y aceptar, que el valor de reposición de cada extensor de wifi mesh es de Dólares Estadounidenses Cien (U\$S100). En caso de que el Cliente no devuelva alguno de los componentes del Equipo deberá abonar el valor de los mismos, estipulándose en U\$S 15 el valor de la fuente de alimentación. Queda a criterio del cliente la contratación a su exclusivo costo y cargo de un seguro que cubra el valor del Equipo por todos los riesgos posibles (daño total o parcial por cualquier causal, robo, hurto, etc.); dicha póliza deberá tener como beneficiario a TELECENTRO. La contratación del mentado seguro no exime al Cliente de su responsabilidad como obligado principal pagador."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Quinta',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "Cualquier incumplimiento total o parcial por parte del Cliente a sus obligaciones asumidas en este Contrato, facultará a TELECENTRO de pleno derecho a rescindir el “comodato” y exigir la restitución del Equipo en el plazo y forma que trata la Cláusula Segunda del presente. La falta de restitución del Equipo producirá los efectos de la retención indebida, siendo aplicable lo dispuesto por el art. 173 del Código Penal."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Sexta',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "Sin perjuicio de lo expuesto y en concepto de Cláusula Penal, en caso de que el Cliente no devolviera los Equipos en tiempo y forma fijados en la interpelación pertinente, el Cliente queda obligado al pago de una multa de Dólares Estadounidenses cinco (U\$S 5) por cada día de demora en la efectiva devolución. El importe resultante será independiente del que deba pagar por el valor del equipo fijado en la Cláusula Cuarta y las restantes deudas líquidas y exigibles por servicios y/u otros cargos ya devengados."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Séptima',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "A todos los efectos derivados del presente contrato y la relación entre el CLIENTE y TELECENTRO que sobrepasen la vía administrativa las partes se someten a la jurisdicción de los Tribunales Ordinarios correspondientes al domicilio del cliente. Las partes constituyen a tales efectos los domicilios que se detallan en el encabezado de este Contrato."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Octava',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "El cliente tendrá a su disposición un Centro de Atención mediante el cual se comunicará o formulará cualquier inquietud o reclamo relativo a problemas con el Servicio. En tal caso podrá llamar sin cargo: Atención al Cliente 011-6380-9500 o por internet  www.telecentro.com.ar. Ante un eventual incumplimiento contractual, el CLIENTE se notifica que podrá realizar denuncia y/o pedir asesoramiento ante los siguientes organismos gubernamentales: * Dirección de Defensa del Consumidor - Av. Julio Argentino Roca nº 651, Piso 4° - C.A.B.A, (1322). Tel. 0800-666-1518. *Dirección Provincial de Comercio- Torre Gubernamental II Piso 12, Calle 12 Esq. 52 La Plata – Buenos Aires- Tel. 0800-222-9042. Correo electrónico: infoconsumidor@mp.gba.gov.ar Cierre "),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Novena',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Text(
                            "9.1. Los términos y condiciones aquí establecidas son válidos en sí mismos y no invalidará al resto. La cláusula inválida o incompleta podrá ser sustituida por otra equivalente y válida por acuerdo de las partes."),
                        const Text(
                            "9.2. El presente Contrato es accesorio y se considerará parte integrante de las condiciones generales del Servicio de Televisión digital, Telefonía digital y Banda Ancha y cualquier otro documento suscripto anteriormente por el Cliente."),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text('Décima',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Text(
                            "El Cliente presta su expresa conformidad para celebrar el presente contrato de manera digital. De plena conformidad con las ocho (8) cláusulas que anteceden, el Cliente firma el presente Contrato el día ${DateTime.now().day} del mes de ${meses[DateTime.now().month - 1]} del año ${DateTime.now().year}."),
                        const Text(
                            "El cliente recibirá en el correo electrónico detallado en el encabezado, un enlace con el acceso a la copia del presente. "),
                        const Text(" "),
                        const SizedBox(
                          width: double.infinity,
                          child: Text("Firma por el Cliente:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: SfSignaturePad(
                              key: signatureGlobalKey,
                              backgroundColor: Colors.white,
                              strokeColor: Colors.black,
                              minimumStrokeWidth: 1.0,
                              maximumStrokeWidth: 4.0))),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF120E43),
                                minimumSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: _handleSaveButtonPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.save),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text('Usar Firma',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE03B8B),
                              minimumSize: const Size(double.infinity, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: _handleClearButtonPressed,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.delete),
                                SizedBox(
                                  width: 12,
                                ),
                                Text('Borrar', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ])
                ]),
          ),
        ));
  }
}
