import 'package:track_bud/models/user_model.dart';

class CacheService {
  final Map<String, UserModel> _cache = {};

  UserModel? get(String userId) => _cache[userId];
  void put(String userId, UserModel user) => _cache[userId] = user;
}