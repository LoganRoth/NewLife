import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "HabitDatabase.db";
  static final _databaseVersion = 1;

  static final dayTable = 'day_table';
  static final weekTable = 'week_table';
  static final monthTable = 'month_table';
  static final goalsTable = 'goals_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnColour = 'colour';
  static final columnCreation = 'creation';
  static final columnIndex = 'location';
  static final columnCompleted = 'completed';
  static final columnToComplete = 'toComplete';
  static final columnStreak = 'streak';
  static final columnUuid = 'uuid';
  static final columnLastReset = 'lastReset';
  static final columnLongestStreak = 'longestStreak';

  static final trackTable = 'track_table';
  static final columnTrackDate = 'trackDate';

  static final columnGoalsStyle = 'goalsStyle';
  static final columnGoalsUnits = 'goalsUnits';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), _databaseName),
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $dayTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnColour INTEGER NOT NULL,
            $columnCreation TEXT NOT NULL,
            $columnIndex INTEGER NOT NULL,
            $columnCompleted INTEGER NOT NULL,
            $columnToComplete INTEGER NOT NULL,
            $columnStreak INTEGER NOT NULL,
            $columnUuid TEXT NOT NULL,
            $columnLastReset TEXT NOT NULL,
            $columnLongestStreak INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $weekTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnColour INTEGER NOT NULL,
            $columnCreation TEXT NOT NULL,
            $columnIndex INTEGER NOT NULL,
            $columnCompleted INTEGER NOT NULL,
            $columnToComplete INTEGER NOT NULL,
            $columnStreak INTEGER NOT NULL,
            $columnUuid TEXT NOT NULL,
            $columnLastReset TEXT NOT NULL,
            $columnLongestStreak INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $monthTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnColour INTEGER NOT NULL,
            $columnCreation TEXT NOT NULL,
            $columnIndex INTEGER NOT NULL,
            $columnCompleted INTEGER NOT NULL,
            $columnToComplete INTEGER NOT NULL,
            $columnStreak INTEGER NOT NULL,
            $columnUuid TEXT NOT NULL,
            $columnLastReset TEXT NOT NULL,
            $columnLongestStreak INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $trackTable (
            $columnId INTEGER PRIMARY KEY,
            $columnUuid TEXT NOT NULL,
            $columnTrackDate TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $goalsTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnColour INTEGER NOT NULL,
            $columnCreation TEXT NOT NULL,
            $columnIndex INTEGER NOT NULL,
            $columnCompleted REAL NOT NULL,
            $columnToComplete REAL NOT NULL,
            $columnUuid TEXT NOT NULL,
            $columnGoalsStyle INTEGER NOT NULL,
            $columnGoalsUnits TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> dayInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dayTable, row);
  }

  Future<int> weekInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(weekTable, row);
  }

  Future<int> monthInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(monthTable, row);
  }

  Future<int> trackInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(trackTable, row);
  }

  Future<int> goalsInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(goalsTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> dayQueryAllRows() async {
    Database db = await instance.database;
    return await db.query(dayTable, orderBy: '$columnIndex ASC');
  }

  Future<List<Map<String, dynamic>>> weekQueryAllRows() async {
    Database db = await instance.database;
    return await db.query(weekTable, orderBy: '$columnIndex ASC');
  }

  Future<List<Map<String, dynamic>>> monthQueryAllRows() async {
    Database db = await instance.database;
    return await db.query(monthTable, orderBy: '$columnIndex ASC');
  }

  Future<List<Map<String, dynamic>>> trackQueryAllRows(String uuid) async {
    Database db = await instance.database;
    return await db
        .query(trackTable, where: '$columnUuid = ?', whereArgs: [uuid]);
  }

  Future<List<Map<String, dynamic>>> goalsQueryAllRows() async {
    Database db = await instance.database;
    return await db.query(goalsTable, orderBy: '$columnIndex ASC');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> dayQueryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $dayTable'));
  }

  Future<int> weekQueryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $weekTable'));
  }

  Future<int> monthQueryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $monthTable'));
  }

  Future<int> goalsQueryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $goalsTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> dayUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(dayTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> weekUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(weekTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> monthUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(monthTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> goalsUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(goalsTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> dayDelete(int id, String uuid) async {
    Database db = await instance.database;
    await db.delete(trackTable, where: '$columnUuid = ?', whereArgs: [uuid]);
    return await db.delete(dayTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> weekDelete(int id, String uuid) async {
    Database db = await instance.database;
    await db.delete(trackTable, where: '$columnUuid = ?', whereArgs: [uuid]);
    return await db.delete(weekTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> monthDelete(int id, String uuid) async {
    Database db = await instance.database;
    await db.delete(trackTable, where: '$columnUuid = ?', whereArgs: [uuid]);
    return await db.delete(monthTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> trackDeleteLast(String uuid) async {
    Database db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM $trackTable WHERE $columnUuid = ? ORDER BY $columnTrackDate DESC LIMIT 1',
        [uuid]);
  }

  Future<int> trackDelete(String uuid, String datetime) async {
    Database db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM $trackTable WHERE $columnUuid = ? AND $columnTrackDate = ?',
        [uuid, datetime]);
  }

  Future<int> goalsDelete(int id, String uuid) async {
    Database db = await instance.database;
    return await db.delete(goalsTable, where: '$columnId = ?', whereArgs: [id]);
  }
}
