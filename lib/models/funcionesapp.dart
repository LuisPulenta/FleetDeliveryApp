class FuncionesApp {
  String proyectomodulo = '';
  int? habilitaFoto = 0;
  int? habilitaDNI = 0;
  int? habilitaEstadisticas = 0;
  int? habilitaFirma = 0;
  int? serieObligatoria = 0;
  int? codigoFinal = 0;

  FuncionesApp(
      {required this.proyectomodulo,
      required this.habilitaFoto,
      required this.habilitaDNI,
      required this.habilitaEstadisticas,
      required this.habilitaFirma,
      required this.serieObligatoria,
      required this.codigoFinal});

  FuncionesApp.fromJson(Map<String, dynamic> json) {
    proyectomodulo = json['proyectomodulo'];
    habilitaFoto = json['habilitaFoto'];
    habilitaDNI = json['habilitaDNI'];
    habilitaEstadisticas = json['habilitaEstadisticas'];
    habilitaFirma = json['habilitaFirma'];
    serieObligatoria = json['serieObligatoria'];
    codigoFinal = json['codigoFinal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['proyectomodulo'] = this.proyectomodulo;
    data['habilitaFoto'] = this.habilitaFoto;
    data['habilitaDNI'] = this.habilitaDNI;
    data['habilitaEstadisticas'] = this.habilitaEstadisticas;
    data['habilitaFirma'] = this.habilitaFirma;
    data['serieObligatoria'] = this.serieObligatoria;
    data['codigoFinal'] = this.codigoFinal;
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
    };
  }
}
