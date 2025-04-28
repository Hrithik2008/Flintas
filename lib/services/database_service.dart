import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';
import '../models/user.dart';
import '../models/team.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habit_world.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        track TEXT NOT NULL,
        xp INTEGER NOT NULL,
        worldLevel INTEGER NOT NULL,
        badges TEXT NOT NULL,
        teamIds TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Habits table
    await db.execute('''
      CREATE TABLE habits(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        xpValue INTEGER NOT NULL,
        isDaily INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        completedDates TEXT NOT NULL
      )
    ''');

    // Teams table
    await db.execute('''
      CREATE TABLE teams(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        track TEXT NOT NULL,
        memberIds TEXT NOT NULL,
        projectIds TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // User operations
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return User.fromJson(maps.first);
  }

  // Habit operations
  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      'habits',
      habit.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) => Habit.fromJson(maps[i]));
  }

  // Team operations
  Future<void> insertTeam(Team team) async {
    final db = await database;
    await db.insert(
      'teams',
      team.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Team?> getTeam(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'teams',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Team.fromJson(maps.first);
  }

  Future<List<Team>> getTeamsByTrack(String track) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'teams',
      where: 'track = ?',
      whereArgs: [track],
    );
    return List.generate(maps.length, (i) => Team.fromJson(maps[i]));
  }
} 