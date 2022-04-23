class Zona {
  String? zona = '';

  Zona({required this.zona});

  Zona.fromJson(Map<String, dynamic> json) {
    zona = json['zona'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['zona'] = zona;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'zona': zona,
    };
  }
}
