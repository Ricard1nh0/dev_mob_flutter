import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() =>
      _instance; //Chama a função e retorna sempre a mesma instância

  DatabaseHelper._internal();

  static Database? _database;

  //Iniciar o Banco

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'poke_app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    //Tabela de Usuários
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    //Tabela de Favoritos
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        pokemonId INTEGER,
        name TEXT,
        imageUrl TEXT,
        FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  //Cadastrar user
  Future<int> registerUser(String email, String password) async {
    final db = await database;
    try {
      return await db.insert('users', {'email': email, 'password': password});
    } catch (e) {
      return -1;
    }
  }

  //Verificação do e-mail + senha
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //Add Favorito
  Future<int> addFavorite(
    int userId,
    int pokemonId,
    String name,
    String imageUrl,
  ) async {
    final db = await database;
    return await db.insert('favorites', {
      'userId': userId,
      'pokemonId': pokemonId,
      'name': name,
      'imageUrl': imageUrl,
    });
  }

  //Remover favorito
  Future<int> removeFavorite(int userId, int pokemonId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'userId = ? AND pokemonId = ?',
      whereArgs: [userId, pokemonId],
    );
  }

  //Listar favoritos
  Future<List<Map<String, dynamic>>> getUserFavorites(int userId) async {
    final db = await database;
    return await db.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  //Verificar se ja foi favoritado
  Future<bool> isFavorite(int userId, int pokemonId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'userId = ? AND pokemonId = ?',
      whereArgs: [userId, pokemonId],
    );
    return result.isNotEmpty;
  }
}
