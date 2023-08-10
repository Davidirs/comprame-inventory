class Product {
  final int? id;
  final String? name;
  final int? units;
  final num? buy;
  final num? sale;

  const Product({
    this.id,
    this.name,
    this.units,
    this.buy,
    this.sale,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        units: json["units"],
        buy: json["buy"],
        sale: json["sale"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'units': units,
      'buy': buy,
      'sale': sale,
    };
  }
}
