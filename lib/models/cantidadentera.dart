class CantidadEntera {
  int? cantidad = 0;

  CantidadEntera({required this.cantidad});

  CantidadEntera.fromJson(Map<String, dynamic> json) {
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cantidad'] = cantidad;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'cantidad': cantidad,
    };
  }
}
