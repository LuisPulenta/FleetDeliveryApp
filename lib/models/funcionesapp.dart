class FuncionesApp {
  String proyectomodulo = '';
  int? habilitaFoto = 0;
  int? habilitaDNI = 0;
  int? habilitaEstadisticas = 0;
  int? habilitaFirma = 0;
  int? serieObligatoria = 0;
  int? codigoFinal = 0;
  int? habilitaOtroRecupero = 0;
  int? habilitaCambioModelo = 0;

  FuncionesApp(
      {required this.proyectomodulo,
      required this.habilitaFoto,
      required this.habilitaDNI,
      required this.habilitaEstadisticas,
      required this.habilitaFirma,
      required this.serieObligatoria,
      required this.codigoFinal,
      required this.habilitaOtroRecupero,
      required this.habilitaCambioModelo});

  FuncionesApp.fromJson(Map<String, dynamic> json) {
    proyectomodulo = json['proyectomodulo'];
    habilitaFoto = json['habilitaFoto'];
    habilitaDNI = json['habilitaDNI'];
    habilitaEstadisticas = json['habilitaEstadisticas'];
    habilitaFirma = json['habilitaFirma'];
    serieObligatoria = json['serieObligatoria'];
    codigoFinal = json['codigoFinal'];
    habilitaOtroRecupero = json['habilitaOtroRecupero'];
    habilitaCambioModelo = json['habilitaCambioModelo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proyectomodulo'] = proyectomodulo;
    data['habilitaFoto'] = habilitaFoto;
    data['habilitaDNI'] = habilitaDNI;
    data['habilitaEstadisticas'] = habilitaEstadisticas;
    data['habilitaFirma'] = habilitaFirma;
    data['serieObligatoria'] = serieObligatoria;
    data['codigoFinal'] = codigoFinal;
    data['habilitaOtroRecupero'] = habilitaOtroRecupero;
    data['habilitaCambioModelo'] = habilitaCambioModelo;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'proyectomodulo': proyectomodulo,
      'habilitaFoto': habilitaFoto,
      'habilitaDNI': habilitaDNI,
      'habilitaEstadisticas': habilitaEstadisticas,
      'habilitaFirma': habilitaFirma,
      'serieObligatoria': serieObligatoria,
      'codigoFinal': codigoFinal,
      'habilitaOtroRecupero': habilitaOtroRecupero,
      'habilitaCambioModelo': habilitaCambioModelo,
    };
  }
}
