import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getDatabasePath() async {
  final dir = await getApplicationDocumentsDirectory();
  // Para Windows, isto é normalmente C:\Users\<user>\AppData\Roaming\<appname>
  // Para ir para "Documentos", faz assim:
  final documentsDir = Directory('${Platform.environment['USERPROFILE']}\\Documents');
  final dbPath = join(documentsDir.path, 'skypt_app.db');
  return dbPath;
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gestao3d.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
  // Usa o teu método para obter o caminho nos Documentos
  final documentsDir = Directory('${Platform.environment['USERPROFILE']}\\Documents');
  final path = join(documentsDir.path, filePath);
  print("Base de dados em: $path");
  return await openDatabase(path, version: 1, onCreate: _createDB);
}

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT UNIQUE,
        password TEXT,
        preco_kwh REAL DEFAULT 0.25
      )
    ''');

    await db.execute('''
  CREATE TABLE filamento(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fabricante TEXT,
    gramas INTEGER,
    stock_atual INTEGER,
    data_compra TEXT,
    preco_compra REAL,
    danificado INTEGER,
    posicao_nota TEXT,
    cor TEXT,
    user_id INTEGER
  )
''');

    await db.execute('''
      CREATE TABLE acessorio(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        quantidade INTEGER,
        preco_compra REAL,
        user_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE cliente(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT,
        mensagem TEXT,
        objetivo TEXT,
        user_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE modelo3d(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        filamento_id INTEGER,
        tipo_filamento TEXT,
        gramas_utilizadas INTEGER,
        tempo_minutos INTEGER,
        cliente_ou_pessoal TEXT,
        cliente_id INTEGER,
        cliente_nome TEXT,
        energia_kwh REAL,
        custo_energia REAL,
        custo_filamento REAL,
        custo_acessorios REAL,
        custo_total REAL,
        acessorios_usados TEXT,
        preco_venda REAL,
        data_criacao TEXT,
        user_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE gasto(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        valor REAL,
        data TEXT,
        user_id INTEGER
      )
    ''');
    
  }

  // ========== User (login, register, preco_kwh) ==========
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final res = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }

  Future<bool> emailExists(String email) async {
    final db = await instance.database;
    final res = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  // Ajustado para aceitar nome, email, password!
  Future<int> registerUser(String nome, String email, String password, {double precoKwh = 0.25}) async {
    final db = await instance.database;
    return await db.insert('user', {
      'nome': nome,
      'email': email,
      'password': password,
      'preco_kwh': precoKwh,
    });
  }

  Future<double> getUserPrecoKwh(int userId) async {
    final db = await instance.database;
    final res = await db.query('user', where: 'id = ?', whereArgs: [userId]);
    if (res.isNotEmpty && res.first['preco_kwh'] != null) {
      return (res.first['preco_kwh'] as num).toDouble();
    }
    // Se não existir, cria utilizador base:
    int id = await db.insert('user', {'preco_kwh': 0.25});
    return 0.25;
  }

  Future<void> updateUserPrecoKwh(int userId, double preco) async {
    final db = await instance.database;
    await db.update('user', {'preco_kwh': preco}, where: 'id = ?', whereArgs: [userId]);
  }

  Future<void> updateFilamentoStockAtual(int id, int novoStockAtual) async {
  final db = await instance.database;
  await db.update('filamento', {'stock_atual': novoStockAtual}, where: 'id = ?', whereArgs: [id]);
}

  // ========== Filamentos ==========
  Future<List<Map<String, dynamic>>> getFilamentos(int userId) async {
    final db = await instance.database;
    return db.query('filamento', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> insertFilamento(Map<String, dynamic> data, int userId) async {
  final db = await instance.database;
  data['user_id'] = userId;
  data['stock_atual'] = data['gramas']; // <-- stock inicial = stock atual
  await db.insert('filamento', data);
}

  Future<void> updateFilamento(Map<String, dynamic> data, int id) async {
    final db = await instance.database;
    await db.update('filamento', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFilamento(int id) async {
    final db = await instance.database;
    await db.delete('filamento', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateFilamentoGramas(int id, int gramas) async {
    final db = await instance.database;
    await db.update('filamento', {'gramas': gramas}, where: 'id = ?', whereArgs: [id]);
  }

  // ========== Acessorios ==========
  Future<List<Map<String, dynamic>>> getAcessorios(int userId) async {
    final db = await instance.database;
    return db.query('acessorio', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> insertAcessorio(Map<String, dynamic> data, int userId) async {
    final db = await instance.database;
    data['user_id'] = userId;
    await db.insert('acessorio', data);
  }

  Future<void> updateAcessorio(Map<String, dynamic> data, int id) async {
    final db = await instance.database;
    await db.update('acessorio', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAcessorio(int id) async {
    final db = await instance.database;
    await db.delete('acessorio', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateAcessorioQuantidade(int id, int qtd) async {
    final db = await instance.database;
    await db.update('acessorio', {'quantidade': qtd}, where: 'id = ?', whereArgs: [id]);
  }

  // ========== Clientes ==========
  Future<List<Map<String, dynamic>>> getClientes(int userId) async {
    final db = await instance.database;
    return db.query('cliente', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> insertCliente(Map<String, dynamic> data, int userId) async {
    final db = await instance.database;
    data['user_id'] = userId;
    await db.insert('cliente', data);
  }

  Future<void> deleteCliente(int id) async {
    final db = await instance.database;
    await db.delete('cliente', where: 'id = ?', whereArgs: [id]);
  }

  // ========== Modelos 3D ==========
  Future<List<Map<String, dynamic>>> getModelos(int userId) async {
    final db = await instance.database;
    return db.query('modelo3d', where: 'user_id = ?', whereArgs: [userId], orderBy: 'data_criacao DESC');
  }

  Future<void> insertModelo(Map<String, dynamic> data, int userId) async {
    final db = await instance.database;
    data['user_id'] = userId;
    await db.insert('modelo3d', data);
  }

  Future<void> deleteModelo(int id) async {
    final db = await instance.database;
    await db.delete('modelo3d', where: 'id = ?', whereArgs: [id]);
  }

  // ========== Gastos ==========
  Future<List<Map<String, dynamic>>> getGastos(int userId) async {
    final db = await instance.database;
    return db.query('gasto', where: 'user_id = ?', whereArgs: [userId], orderBy: 'data DESC');
  }

  Future<void> insertGasto(Map<String, dynamic> data, int userId) async {
    final db = await instance.database;
    data['user_id'] = userId;
    await db.insert('gasto', data);
  }
  
}