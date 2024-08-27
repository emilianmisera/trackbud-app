import 'dart:convert';

class UserModel {
  String userId;
  String email;
  String name;
  String profilePictureUrl;
  double bankAccountBalance;
  double monthlySpendingGoal;
  Map<String, dynamic> settings;
  List<String> friends;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.profilePictureUrl,
    required this.bankAccountBalance,
    required this.monthlySpendingGoal,
    required this.settings,
    required this.friends,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      profilePictureUrl: map['profilePictureUrl'] ?? '',
      bankAccountBalance: map['bankAccountBalance']?.toDouble() ?? 0.0,
      monthlySpendingGoal: map['monthlySpendingGoal']?.toDouble() ?? 0.0,
      
      // Check if settings is a valid JSON string
      settings: map['settings'] != null && map['settings'] is String && map['settings'].isNotEmpty
          ? jsonDecode(map['settings']) as Map<String, dynamic>
          : {}, // Default to an empty Map if null or invalid
      
      // Check if friends is a valid JSON string
      friends: map['friends'] != null && map['friends'] is String && map['friends'].isNotEmpty
          ? List<String>.from(jsonDecode(map['friends']))
          : [], // Default to an empty List if null or invalid
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
      'bankAccountBalance': bankAccountBalance,
      'monthlySpendingGoal': monthlySpendingGoal,
      'settings': jsonEncode(settings),
      'friends': jsonEncode(friends),
    };
  }
}
