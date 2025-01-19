import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  static const String contactsTable = 'contacts';
  static const String relationsTable = 'relations';
  static const String navigationTable = 'navigation';
  static const String locationTable = 'location_updates'; // New table
  static const String sosStatusTable = 'sos_status';     // New table
  static const String usersTable = 'users'; // New table for user data
  static const String sosTokenTable = 'sos_token';  // New table for SOS token

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'women_safety.db');
    return await openDatabase(
      path,
      version: 3, // Increased version number
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const uniqueTextType = 'TEXT NOT NULL UNIQUE';
    const realType = 'REAL NOT NULL';

    // Create users table
    await db.execute('''
      CREATE TABLE $usersTable (
        id $idType,
        name $textType,
        gender $textType,
        date_of_birth $textType,
        address $textType,
        aadhaar_number $uniqueTextType,
        is_logged_in INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create contacts table
    await db.execute('''
      CREATE TABLE $contactsTable (
        id $idType,
        name $textType,
        phone $uniqueTextType,
        relation $textType
      )
    ''');

    // Create relations table and insert default relations
    await db.execute('''
      CREATE TABLE $relationsTable (
        id $idType,
        name $uniqueTextType
      )
    ''');

    await db.batch()
      ..insert(relationsTable, {'name': 'Work'})
      ..insert(relationsTable, {'name': 'Family'})
      ..insert(relationsTable, {'name': 'Friends'})
      ..insert(relationsTable, {'name': 'Others'})
      ..commit();

    // Create navigation table
    await db.execute('''
      CREATE TABLE $navigationTable (
        id $idType,
        current_page INTEGER NOT NULL,
        last_updated TEXT NOT NULL
      )
    ''');

    // Insert default navigation state
    await db.insert(navigationTable, {
      'current_page': 0,
      'last_updated': DateTime.now().toIso8601String(),
    });

    // Create location tracking table
    await db.execute('''
      CREATE TABLE $locationTable (
        id $idType,
        latitude $realType,
        longitude $realType,
        timestamp $textType,
        battery_level INTEGER,
        is_charging INTEGER
      )
    ''');

    // Create SOS status table
    await db.execute('''
      CREATE TABLE $sosStatusTable (
        id $idType,
        is_active INTEGER NOT NULL DEFAULT 0,
        activated_at $textType,
        last_updated $textType
      )
    ''');

    // Insert default SOS status
    await db.insert(sosStatusTable, {
      'is_active': 0,
      'activated_at': DateTime.now().toIso8601String(),
      'last_updated': DateTime.now().toIso8601String(),
    });

    // Create SOS token table
    await db.execute('''
      CREATE TABLE $sosTokenTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        token TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _createTableIfNotExists(db, usersTable, '''
        CREATE TABLE IF NOT EXISTS $usersTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          gender TEXT NOT NULL,
          date_of_birth TEXT NOT NULL,
          address TEXT NOT NULL,
          aadhaar_number TEXT NOT NULL UNIQUE,
          is_logged_in INTEGER NOT NULL DEFAULT 0
        )
      ''');

      // Check if tables exist before creating
      await _createTableIfNotExists(db, navigationTable, '''
        CREATE TABLE IF NOT EXISTS $navigationTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          current_page INTEGER NOT NULL,
          last_updated TEXT NOT NULL
        )
      ''');

      await _createTableIfNotExists(db, locationTable, '''
        CREATE TABLE IF NOT EXISTS $locationTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          timestamp TEXT NOT NULL,
          battery_level INTEGER,
          is_charging INTEGER
        )
      ''');

      await _createTableIfNotExists(db, sosStatusTable, '''
        CREATE TABLE IF NOT EXISTS $sosStatusTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          is_active INTEGER NOT NULL DEFAULT 0,
          activated_at TEXT NOT NULL,
          last_updated TEXT NOT NULL
        )
      ''');

      await _createTableIfNotExists(db, sosTokenTable, '''
        CREATE TABLE IF NOT EXISTS $sosTokenTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          token TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');

      // Insert default data if tables are empty
      await _insertDefaultDataIfEmpty(db);
    }
  }

  Future<void> _createTableIfNotExists(Database db, String tableName, String createSql) async {
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name="$tableName";');
    
    if (result.isEmpty) {
      await db.execute(createSql);
    }
  }

  Future<void> _insertDefaultDataIfEmpty(Database db) async {
    final List<Map<String, dynamic>> navigationData =
        await db.query(navigationTable);
    
    if (navigationData.isEmpty) {
      await db.insert(navigationTable, {
        'current_page': 0,
        'last_updated': DateTime.now().toIso8601String(),
      });
    }

    final List<Map<String, dynamic>> sosStatus =
        await db.query(sosStatusTable);
    
    if (sosStatus.isEmpty) {
      await db.insert(sosStatusTable, {
        'is_active': 0,
        'activated_at': DateTime.now().toIso8601String(),
        'last_updated': DateTime.now().toIso8601String(),
      });
    }
  }

  // Location tracking methods
  Future<int> insertLocation(Map<String, dynamic> location) async {
    final db = await database;
    return await db.insert(
      locationTable,
      location,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLocationUpdates({int? limit}) async {
    final db = await database;
    
    if (limit != null) {
      return await db.query(
        locationTable,
        orderBy: 'timestamp DESC',
        limit: limit,
      );
    }
    
    return await db.query(locationTable, orderBy: 'timestamp DESC');
  }

  Future<void> deleteOldLocations(Duration maxAge) async {
    final db = await database;
    
    final cutoffDate = DateTime.now().subtract(maxAge).toIso8601String();
    
    await db.delete(
      locationTable,
      where: 'timestamp < ?',
      whereArgs: [cutoffDate],
    );
  }

  // SOS status methods
  Future<bool> getSOSStatus() async {
    final db = await database;
    
    final result = await db.query(sosStatusTable);
    
    if (result.isEmpty) return false;
    
    return result.first['is_active'] == 1;
  }

  Future<void> setSOSStatus(bool isActive) async {
    final db = await database;
    
    await db.update(
      sosStatusTable,
      {
        'is_active': isActive ? 1 : 0,
        'last_updated': DateTime.now().toIso8601String(),
        if (isActive) 'activated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // Contacts Management
  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await database;
    
    return await db.query(contactsTable, orderBy: 'name ASC');
  }

  Future<int> insertContact(Map<String, String> contact) async {
    final db = await database;
    
    return await db.insert(
      contactsTable,
      contact,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateContact(String phoneNumber, Map<String, String> newContact) async {
    final db = await database;
    
    return await db.update(
      contactsTable,
      newContact,
      where: 'phone = ?',
      whereArgs: [phoneNumber],
    );
  }

  Future<int> deleteContact(String phoneNumber) async {
    final db = await database;
    
    return await db.delete(
      contactsTable,
      where: 'phone = ?',
      whereArgs: [phoneNumber],
    );
  }

  // Relations Management
  Future<List<Map<String, dynamic>>> getRelations() async {
    final db = await database;
    
    return await db.query(relationsTable, orderBy: 'name ASC');
  }

  Future<int> addCustomRelation(String relationName) async {
   final db = await database;
   
   return await db.insert(
     relationsTable,
     {'name': relationName},
     conflictAlgorithm: ConflictAlgorithm.ignore,
   );
 }
  
 // Navigation Management
 Future<int> getCurrentPage() async {
   final db = await database;
   final List<Map<String, dynamic>> result = 
       await db.query(navigationTable);
   return result.isEmpty ? 
       0 : 
       result.first['current_page'] as int;
 }
  
 Future<void> setCurrentPage(int page) async {
   final db = await database;
   await db.update(
     navigationTable,
     {
       'current_page': page,
       'last_updated': DateTime.now().toIso8601String(),
     },
     where: 'id = ?',
     whereArgs: [1],
   );
 }

  // User Management Methods
  Future<bool> isUserLoggedIn() async {
    final db = await database;
    final result = await db.query(
      usersTable,
      where: 'is_logged_in = ?',
      whereArgs: [1],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getLoggedInUser() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'is_logged_in = ?',
      whereArgs: [1],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> saveUserData({
    required String name,
    required String gender,
    required String dateOfBirth,
    required String address,
    required String aadhaarNumber,
  }) async {
    final db = await database;

    // Clear any existing user data
    await db.delete('users');

    // Insert the new user
    await db.insert(
      'users',
      {
        'name': name,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'address': address,
        'aadhaar_number': aadhaarNumber,
        'is_logged_in': 1,
      },
    );
  }

  Future<void> logoutUser() async {
    final db = await database;

    // Clear all user data
    await db.delete('users');

    // Ensure any remaining users are marked as logged out
    await db.update(
      'users',
      {'is_logged_in': 0},
    );
  }

  Future<String?> getAadhaarNumber() async {
    final user = await getLoggedInUser();
    return user != null ? user['aadhaar_number'] as String? : null;
  }

  // Contact management methods
  Future<void> insertOrUpdateContact(Map<String, dynamic> contact) async {
    final db = await database;
    
    // Check if contact exists
    final List<Map<String, dynamic>> existingContacts = await db.query(
      contactsTable,
      where: 'phone = ?',
      whereArgs: [contact['phone']],
    );

    if (existingContacts.isEmpty) {
      // Insert new contact
      await db.insert(
        contactsTable,
        contact,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update existing contact
      await db.update(
        contactsTable,
        contact,
        where: 'phone = ?',
        whereArgs: [contact['phone']],
      );
    }
  }

  // Store SOS token
  Future<void> storeSOSToken(String token) async {
    final db = await database;
    
    // Clear any existing tokens first
    await db.delete(sosTokenTable);
    
    // Store new token
    await db.insert(sosTokenTable, {
      'token': token,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Get stored SOS token
  Future<String?> getSOSToken() async {
    final db = await database;
    
    final result = await db.query(sosTokenTable, orderBy: 'created_at DESC', limit: 1);
    
    if (result.isEmpty) return null;
    
    return result.first['token'] as String;
  }

  // Clear stored SOS token
  Future<void> clearSOSToken() async {
    final db = await database;
    await db.delete(sosTokenTable);
  }
}

