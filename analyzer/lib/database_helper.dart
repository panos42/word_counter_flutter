import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static final _databaseName = 'synonyms.db';
  static final _databaseVersion = 1;

  static final _tableName = 'synonyms';
  static final columnId = '_id';
  static final columnWord = 'word';
  static final columnSynonym = 'synonym';
  // Query the database for synonyms of a given word
  Future<List<String>> getSynonyms(String word) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      _tableName,
      columns: [columnSynonym],
      where: '$columnWord = ?',
      whereArgs: [word],
    );

    // Extract the synonyms from the query results
    return List.generate(maps.length, (i) => maps[i][columnSynonym]);
  }

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database
  static Database? _database = null;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Open the database
  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, _databaseName);

    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_tableName (
            $columnId INTEGER PRIMARY KEY,
            $columnWord TEXT NOT NULL,
            $columnSynonym TEXT NOT NULL
          )
          ''');
  }

  // Insert a word and synonym into the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(_tableName, row);
  }

  // Query the database for all words and synonyms
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(_tableName);
  }
}

void populateDatabase() async {
  final List<String> words = [
    'the',
    'be',
    'to',
    'of',
    'and',
    'a',
    'in',
    'that',
    'have',
    'I',
    'it',
    'for',
    'not',
    'on',
    'with',
    'he',
    'as',
    'you',
    'do',
    'at',
    'this',
    'but'
  ];
  final List<List<String>> synonyms = [
    ['that which indicates', 'that which shows'],
    ['to exist', 'to occupy space'],
    ['toward', 'up to'],
    ['apart from', 'exclusive of'],
    ['and', 'in addition to'],
    ['a single unit of language', 'one of a group of words'],
    ['inside', 'within'],
    ['such that', 'in order that'],
    ['to possess', 'to have'],
    ['the speaker or writer', 'the person being addressed'],
    ['a particular thing', 'an object'],
    ['for the purpose of', 'in order to'],
    ['not', 'the opposite of'],
    ['on top of', 'resting on'],
    ['in association with', 'accompanying'],
    ['he', 'him'],
    ['in the role of', 'as'],
    ['you', 'your'],
    ['to accomplish', 'to achieve'],
    ['at a particular place', 'in a specific position']
  ];

  final db = await DatabaseHelper.instance.database;
  for (int i = 0; i < words.length; i++) {
    await db!.insert(
      DatabaseHelper._tableName,
      {
        DatabaseHelper.columnWord: words[i],
        DatabaseHelper.columnSynonym: synonyms[i].join(', '),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
