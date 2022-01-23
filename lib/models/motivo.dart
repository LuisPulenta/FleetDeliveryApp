class Motivo {
  int? id = 0;
  String? motivo = '';

  Motivo({required this.id, required this.motivo});

  Motivo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    motivo = json['motivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['motivo'] = motivo;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'motivo': motivo,
    };
  }
}
