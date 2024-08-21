import 'package:track_bud/services/cache_service.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/services/sqlite_service.dart';
import 'package:track_bud/services/sync_service.dart';

class DependencyInjector {
  static final SyncService syncService = SyncService(
    SQLiteService(),
    FirestoreService(),
    CacheService(),
  );
}
