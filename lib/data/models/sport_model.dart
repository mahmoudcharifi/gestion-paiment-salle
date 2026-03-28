class SportModel {
  final int? id;
  final String name;

  SportModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory SportModel.fromMap(Map<String, dynamic> map) {
    return SportModel(
      id: map['id'],
      name: map['name'] ?? '',
    );
  }
}