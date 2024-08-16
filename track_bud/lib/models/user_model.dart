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
      profilePictureUrl: map['profilePictureUrl'],
      bankAccountBalance: map['bankAccountBalance'].toDouble(),
      monthlySpendingGoal: map['monthlySpendingGoal'].toDouble(),
      settings: jsonDecode(map['settings']),
      friends: List<String>.from(jsonDecode(map['friends'])),
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