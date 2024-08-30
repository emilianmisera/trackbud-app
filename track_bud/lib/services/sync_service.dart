/*import 'dart:io';
import 'package:track_bud/models/transaction_model.dart';
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
    bool hasInternet = await checkInternetConnection();

    if (hasInternet) {
      // Sync local changes to remote (Firestore)
      await _syncLocalChanges(userId);

      // Sync remote changes to local (SQLite)
      await _syncOnlineData(userId);
    } else {
      print(
          'Keine Internetverbindung. Synchronisation wird später durchgeführt.');
    }
  }

  Future<void> _syncLocalChanges(String userId) async {
    try {
      // sync user
      List<UserModel> localUsers = await _sqliteService.getUnsyncedUsers();
      for (var user in localUsers) {
        await _firestoreService.updateUserNameInFirestore(
            user.userId, user.name);
        // Optionally update local database to mark as synced
        await _sqliteService.markUserAsSynced(user.userId);
      }
      // sync transactions
      List<TransactionModel> localTransactions =
          await _sqliteService.getUnsyncedTransactions();
      for (var transaction in localTransactions) {
        await _firestoreService.addTransaction(transaction);
        await _sqliteService.markTransactionAsSynced(transaction.transactionId);
      }
    } catch (e) {
      print("Fehler beim Synchronisieren von lokalen Änderungen: $e");
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

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
} */
