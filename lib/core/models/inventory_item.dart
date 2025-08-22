class InventoryItem {
  final String id;
  final String ownerId;
  final String name;
  final String category; // e.g., seeds, fertilizers, pesticides, tools
  final double quantity;
  final String unit; // e.g., kg, L, bags
  final double threshold;
  final DateTime updatedAt;
  final String? notes;

  InventoryItem({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.threshold,
    required this.updatedAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'threshold': threshold,
      'updatedAt': updatedAt.toUtc().millisecondsSinceEpoch,
      'notes': notes,
    };
  }

  static InventoryItem fromDoc(String id, Map<String, dynamic> json) {
    return InventoryItem(
      id: id,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      threshold: (json['threshold'] as num).toDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['updatedAt'] as num?)?.toInt() ?? 0,
        isUtc: true,
      ),
      notes: json['notes'] as String?,
    );
  }
}


