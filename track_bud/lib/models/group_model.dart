class GroupModel {
  String groupId;
  String name;
  String profilePictureUrl;
  List<String> members;
  String createdBy;
  String createdAt;

  GroupModel({
    required this.groupId,
    required this.name,
    required this.profilePictureUrl,
    required this.members,
    required this.createdBy,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'],
      name: map['name'],
      profilePictureUrl: map['profilePictureUrl'],
      members: List<String>.from(map['members']),
      createdBy: map['createdBy'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
