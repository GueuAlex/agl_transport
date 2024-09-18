import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/DeviceModel.dart';
import '../model/agent_model.dart';

class LocalService {
  static final LocalService _instance = LocalService._internal();
  static Database? _database;

  LocalService._internal();

  factory LocalService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 2, // Augmentez le numéro de version
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS user(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            telephone TEXT,
            actif INTEGER,
            matricule TEXT,
            avatar TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS agl_device(
            id INTEGER PRIMARY KEY,
            localisation_id INTEGER,
            site_id INTEGER,
            uid TEXT UNIQUE,
            model TEXT,
            manufacturer TEXT,
            os TEXT,
            os_version TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS agl_device(
              id INTEGER PRIMARY KEY,
              localisation_id INTEGER,
              site_id INTEGER,
              uid TEXT UNIQUE,
              model TEXT,
              manufacturer TEXT,
              os TEXT,
              os_version TEXT
            )
          ''');
        }
      },
    );
  }

  Future<int> createLocalAgent({required AgentModel agent}) async {
    final db = await database;
    return await db.insert(
      'user',
      {
        'id': agent.id,
        'name': agent.name,
        'email': /* agent.email */ "",
        'telephone': agent.telephone,
        'actif': agent.actif ? 1 : 0,
        'matricule': agent.matricule,
        //'localisation_id': agent.localisation.id,
        'avatar': /* agent.avatar */ "",
        //'localisation_name': agent.localisation.libelle,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('user');
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<int> createDevice(Map<String, dynamic> device) async {
    final db = await database;
    return await db.insert(
      'agl_device',
      device,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DeviceModel?> getDevice() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('agl_device');
    if (maps.isNotEmpty) {
      //print(maps);
      return DeviceModel.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
