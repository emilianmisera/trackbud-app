import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/debt_model.dart';
import '../models/group_model.dart';
import '../models/group_transaction_model.dart';

class SQLiteService {
  static final SQLiteService _instance = SQLiteService._internal();

  factory SQLiteService() {
    return _instance;
  }

  SQLiteService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'trackbud.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        userId TEXT PRIMARY KEY,
        email TEXT,
        name TEXT,
        profilePictureUrl TEXT,
        bankAccountBalance REAL,
        monthlySpendingGoal REAL,
        settings TEXT,
        friends TEXT
        isSynced INTEGER DEFAULT 0 -- 0 means not synced, 1 means synced
      )
    ''');

    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions (
        transactionId TEXT PRIMARY KEY,
        userId TEXT,
        amount REAL,
        type TEXT,
        category TEXT,
        notes TEXT,
        date TEXT,
        billImageUrl TEXT,
        currency TEXT,
        recurrenceType TEXT
        isSynced INTEGER DEFAULT 0 -- 0 means not synced, 1 means synced
      )
    ''');

    // Create debts table
    await db.execute('''
      CREATE TABLE debts (
        debtId TEXT PRIMARY KEY,
        creditorId TEXT,
        debtorId TEXT,
        amount REAL,
        description TEXT,
        date TEXT,
        status TEXT
      )
    ''');

    // Create groups table
    await db.execute('''
      CREATE TABLE groups (
        groupId TEXT PRIMARY KEY,
        name TEXT,
        profilePictureUrl TEXT,
        members TEXT,
        createdBy TEXT,
        createdAt TEXT
      )
    ''');

    // Create groupTransactions table (renamed from groupExpenses)
    await db.execute('''
      CREATE TABLE groupTransactions (
        transactionId TEXT PRIMARY KEY,
        groupId TEXT,
        amount REAL,
        type TEXT,
        description TEXT,
        paidBy TEXT,
        date TEXT,
        splitBetween TEXT
        isSynced INTEGER DEFAULT 0 -- 0 means not synced, 1 means synced
      )
    ''');
  }

  // User methods
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUserById(String userId) async {
    final db = await database;
    final maps = await db.query('users', where: 'userId = ?', whereArgs: [userId]);
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update('users', user.toMap(), where: 'userId = ?', whereArgs: [user.userId]);
  }

  Future<void> updateUserName(String userId, String newName) async {
  final db = await database;
  await db.update(
    'users',
    {'name': newName},
    where: 'userId = ?',
    whereArgs: [userId],
  );
}

  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete('users', where: 'userId = ?', whereArgs: [userId]);
  }

  // Methode zum Abrufen aller nicht synchronisierten Benutzer
  Future<List<UserModel>> getUnsyncedUsers() async {
    final db = await database;
    final maps = await db.query('users', where: 'isSynced = ?', whereArgs: [0]);
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  // Methode zum Markieren eines Benutzers als synchronisiert
  Future<void> markUserAsSynced(String userId) async {
    final db = await database;
    await db.update(
      'users',
      {'isSynced': 1},  // Setzt isSynced auf 1
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // Transaction methods
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TransactionModel>> getTransactionsByUserId(String userId) async {
    final db = await database;
    final maps = await db.query('transactions', where: 'userId = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  Future<void> deleteTransaction(String transactionId) async {
    final db = await database;
    await db.delete('transactions', where: 'transactionId = ?', whereArgs: [transactionId]);
  }

  // Debt methods
  Future<void> insertDebt(DebtModel debt) async {
    final db = await database;
    await db.insert('debts', debt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DebtModel>> getDebtsByUserId(String userId) async {
    final db = await database;
    final maps = await db.query('debts', where: 'creditorId = ? OR debtorId = ?', whereArgs: [userId, userId]);
    return List.generate(maps.length, (i) => DebtModel.fromMap(maps[i]));
  }

  Future<void> deleteDebt(String debtId) async {
    final db = await database;
    await db.delete('debts', where: 'debtId = ?', whereArgs: [debtId]);
  }

  // Group methods
  Future<void> insertGroup(GroupModel group) async {
    final db = await database;
    await db.insert('groups', group.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<GroupModel?> getGroupById(String groupId) async {
    final db = await database;
    final maps = await db.query('groups', where: 'groupId = ?', whereArgs: [groupId]);
    if (maps.isNotEmpty) {
      return GroupModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> deleteGroup(String groupId) async {
    final db = await database;
    await db.delete('groups', where: 'groupId = ?', whereArgs: [groupId]);
  }

  // Group Transaction methods (renamed and updated from groupExpense)
  Future<void> insertGroupTransaction(GroupTransactionModel groupTransaction) async {
    final db = await database;
    await db.insert('groupTransactions', groupTransaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<GroupTransactionModel>> getGroupTransactionsByGroupId(String groupId) async {
    final db = await database;
    final maps = await db.query('groupTransactions', where: 'groupId = ?', whereArgs: [groupId]);
    return List.generate(maps.length, (i) => GroupTransactionModel.fromMap(maps[i]));
  }

  Future<void> deleteGroupTransaction(String transactionId) async {
    final db = await database;
    await db.delete('groupTransactions', where: 'transactionId = ?', whereArgs: [transactionId]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}