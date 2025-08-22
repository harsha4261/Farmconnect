class Supplier {
  final String id;
  final String name;
  final String category; // seeds, fertilizers, pesticides, tools
  final String phone;
  final String address;
  final String? website;

  Supplier({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.address,
    this.website,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'phone': phone,
      'address': address,
      'website': website,
    };
  }

  static Supplier fromDoc(String id, Map<String, dynamic> json) {
    return Supplier(
      id: id,
      name: json['name'] as String,
      category: json['category'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      website: json['website'] as String?,
    );
  }
}


