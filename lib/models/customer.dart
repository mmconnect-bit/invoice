class Customer {
  final int? id;
  final String icon;
  final String name;
  final String phone;
  final String email;
  final String address;

  Customer({
    this.id,
    required this.icon,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      icon: map['icon'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
    );
  }

  static List<Customer> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((map) => Customer.fromMap(map)).toList();
  }
}
