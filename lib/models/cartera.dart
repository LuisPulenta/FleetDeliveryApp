class Cartera {
  String? motivos = '';

  Cartera({required this.motivos});

  Cartera.fromJson(Map<String, dynamic> json) {
    motivos = json['motivos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['motivos'] = motivos;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'motivos': motivos,
    };
  }
}
