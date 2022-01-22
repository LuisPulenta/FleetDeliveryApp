class NroRegMax {
  int id = 0;

  NroRegMax({required id});

  NroRegMax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}
