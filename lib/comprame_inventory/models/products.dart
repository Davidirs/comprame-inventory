class Product {
  final int? id;
  final String? name;
  final int? units;
  final num? buy;
  final num? sale;
  final String? img;
  final String? description;

  const Product(
      {this.id,
      this.name,
      this.units,
      this.buy,
      this.sale,
      this.img,
      this.description});

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        units: json["units"],
        buy: json["buy"],
        sale: json["sale"],
        img: json["img"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'units': units,
      'buy': buy,
      'sale': sale,
      'img': img,
      'description': description,
    };
  }
}
