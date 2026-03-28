class MemberSportModel {
  final int? id;
  final int memberId;
  final int sportId;

  MemberSportModel({
    this.id,
    required this.memberId,
    required this.sportId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'member_id': memberId,
      'sport_id': sportId,
    };
  }

  factory MemberSportModel.fromMap(Map<String, dynamic> map) {
    return MemberSportModel(
      id: map['id'],
      memberId: map['member_id'],
      sportId: map['sport_id'],
    );
  }
}