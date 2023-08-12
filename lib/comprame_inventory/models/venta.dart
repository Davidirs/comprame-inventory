class Venta {
  final int? id;
  final String? fecha;
  final String? details;
  final num? total;
  final num? profit;
  final String? method; //int? method;

  const Venta({
    this.id,
    this.fecha,
    this.details,
    this.total,
    this.profit,
    this.method,
  });

  factory Venta.fromMap(Map<String, dynamic> json) => Venta(
        id: json["id"],
        fecha: json["fecha"],
        details: json["details"],
        total: json["total"],
        profit: json["profit"],
        method: json["method"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'details': details,
      'total': total,
      'profit': profit,
      'method': method,
    };
  }
}
