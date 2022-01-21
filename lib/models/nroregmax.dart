class NroRegMax {
  int id = 0;

  NroRegMax({required this.id});

  NroRegMax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}
