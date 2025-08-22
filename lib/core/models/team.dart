class Team {
  final String id;
  final String ownerId;
  final String name;
  final List<String> memberIds;
  final DateTime createdAt;

  Team({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.memberIds,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'memberIds': memberIds,
      'createdAt': createdAt.toUtc().millisecondsSinceEpoch,
    };
  }

  static Team fromDoc(String id, Map<String, dynamic> json) {
    return Team(
      id: id,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      memberIds: (json['memberIds'] as List<dynamic>? ?? []).cast<String>(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['createdAt'] as num?)?.toInt() ?? 0,
        isUtc: true,
      ),
    );
  }
}


