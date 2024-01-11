class Dolar {
  final String? updated;
  final double? bcv;
  final double? paralelo;
  final double? own;

  const Dolar({this.updated, this.bcv, this.paralelo, this.own});

  factory Dolar.fromMap(Map<String, dynamic> json) => Dolar(
        updated: json["updated"],
        bcv: json["bcv"],
        paralelo: json["paralelo"],
        own: json["own"],
      );

  Map<String, dynamic> toMap() {
    return {
      'updated': updated,
      'bcv': bcv,
      'paralelo': paralelo,
      'own': own,
    };
  }
}
