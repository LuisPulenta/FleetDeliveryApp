class EquiposSinDevolver {
  int userID = 0;
  String apellidonombre = '';
  int? sinIngresoDeposito = 0;
  int? dtv = 0;
  int? cable = 0;
  int? tasa = 0;
  int? tlc = 0;
  int? prisma = 0;
  int? teco = 0;
  int? superC = 0;

  EquiposSinDevolver(
      {required this.userID,
      required this.apellidonombre,
      required this.sinIngresoDeposito,
      required this.dtv,
      required this.cable,
      required this.tasa,
      required this.tlc,
      required this.prisma,
      required this.teco,
      required this.superC});

  EquiposSinDevolver.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    apellidonombre = json['apellidonombre'];
    sinIngresoDeposito = json['sinIngresoDeposito'];
    dtv = json['dtv'];
    cable = json['cable'];
    tasa = json['tasa'];
    tlc = json['tlc'];
    prisma = json['prisma'];
    teco = json['teco'];
    superC = json['superC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['apellidonombre'] = this.apellidonombre;
    data['sinIngresoDeposito'] = this.sinIngresoDeposito;
    data['dtv'] = this.dtv;
    data['cable'] = this.cable;
    data['tasa'] = this.tasa;
    data['tlc'] = this.tlc;
    data['prisma'] = this.prisma;
    data['teco'] = this.teco;
    data['superC'] = this.superC;
    return data;
  }
}
