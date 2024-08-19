import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/cache_service.dart';
import 'sqlite_service.dart';
import 'firestore_service.dart';

class SyncService {
  final SQLiteService _sqliteService;
  final FirestoreService _firestoreService;
  final CacheService _cacheService;

  SyncService(this._sqliteService, this._firestoreService, this._cacheService);

  Future<void> syncData(String userId) async {
  // Retrieve user from local database
  UserModel? localUser = await SQLiteService().getUserById(userId);

  if (localUser != null) {
    // Update Firebase with local data
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'name': localUser.name,
      'email': localUser.email,
    });
  }
}

  Future<void> _syncOnlineData(String userId) async {
    try {
      UserModel? firestoreUser = await _firestoreService.getUserData(userId);
      if (firestoreUser != null) {
        await _sqliteService.insertUser(firestoreUser);
        _cacheService.put(userId, firestoreUser); // refresh cache
      }
    } catch (e) {
      print("Fehler beim Synchronisieren von Online-Daten: $e");
    }
  }

  Future<void> _syncLocalChanges(String userId) async {
    try {
      List<UserModel> localUsers = await _sqliteService.getUnsyncedUsers();
      for (var user in localUsers) {
        await _firestoreService.updateUserNameInFirestore(user.userId, user.name);
        // Optionally update local database to mark as synced
        await _sqliteService.markUserAsSynced(user.userId);
      }
    } catch (e) {
      print("Fehler beim Synchronisieren von lokalen Änderungen: $e");
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}