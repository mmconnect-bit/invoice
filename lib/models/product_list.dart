class Product {
  final int? id;
  final String icon;
  final String name;
  final String price;
  final String code;
  final String unit;
  final String category;

  Product({
    this.id,
    required this.icon,
    required this.name,
    required this.price,
    required this.code,
    required this.unit,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          name == other.name &&
          price == other.price &&
          code == other.code &&
          unit == other.unit &&
          category == other.category;

  @override
  int get hashCode =>
      name.hashCode ^
      price.hashCode ^
      code.hashCode ^
      unit.hashCode ^
      category.hashCode;

  @override
  String toString() => 'Product(name: $name, price: $price)';

  Map<String, dynamic> toMap() => {
        'id': id,
        'icon': icon,
        'name': name,
        'price': price,
        'code': code,
        'unit': unit,
        'category': category,
      };

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      icon: map['icon'],
      name: map['name'],
      price: map['price'].toString(),
      code: map['code'],
      unit: map['unit'],
      category: map['category'],
    );
  }

  static List<Product> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((map) => Product.fromMap(map)).toList();
  }
}
