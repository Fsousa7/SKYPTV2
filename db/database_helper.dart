import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getDatabasePath() async {
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
    final documentsDir = Directory('${Platform.environment['USERPROFILE']}\\Documents');
    final path = join(documentsDir.path, filePath);
    print("Base de dados em: $path");
    return await openDatabase(
      path, 
      version: 2,  
      onCreate: _createDB,
      onUpgrade: _onUpgrade, 
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE modelo3d ADD COLUMN filamentos_usados TEXT');
        await db.execute('ALTER TABLE modelo3d ADD COLUMN impressora_id INTEGER');
        await db.execute('ALTER TABLE modelo3d ADD COLUMN impressora_nome TEXT');
        print("Base de dados atualizada para suportar múltiplos filamentos e impressora");
      } catch (e) {
        print("Erro na migração: $e");
      }
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT UNIQUE,
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
        user_id INTEGER,
        filamentos_usados TEXT,
        impressora_id INTEGER,
        impressora_nome TEXT
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

  Future<Map<String, dynamic>?> loginUserByNome(String nome, String password) async {
    final db = await instance.database;
    final res = await db.query(
      'user',
      where: 'nome = ? AND password = ?',
      whereArgs: [nome, password],
      limit: 1,
    );
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }

  Future<bool> nomeExists(String nome) async {
    final db = await instance.database;
    final res = await db.query(
      'user',
      where: 'nome = ?',
      whereArgs: [nome],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<int> registerUserByNome(String nome, String password, {double precoKwh = 0.25}) async {
    final db = await instance.database;
    return await db.insert('user', {
      'nome': nome,
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
    await db.insert('user', {'preco_kwh': 0.25});
    return 0.25;
  }

  Future<void> updateUserPrecoKwh(int userId, double preco) async {
    final db = await instance.database;
    await db.update('user', {'preco_kwh': preco}, where: 'id = ?', whereArgs: [userId]);
  }

  // ========== Filamentos ==========

  Future<List<Map<String, dynamic>>> getFilamentos(int userId) async {
    final db = await instance.database;
    return db.query('filamento', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> insertFilamento(Map<String, dynamic> data, int userId) async {
    final db = await instance.database;
    data['user_id'] = userId;
    data['stock_atual'] = data['gramas'];
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

  Future<void> updateFilamentoStockAtual(int id, int novoStockAtual) async {
    final db = await instance.database;
    await db.update('filamento', {'stock_atual': novoStockAtual}, where: 'id = ?', whereArgs: [id]);
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

  Future<int> updateCliente(Map<String, dynamic> cliente, int id) async {
    final db = await database;
    return await db.update(
      'cliente',
      cliente,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Modelos 3D ==========

  Future<List<Map<String, dynamic>>> getModelos(int userId) async {
    final db = await instance.database;
    return db.query('modelo3d', where: 'user_id = ?', whereArgs: [userId], orderBy: 'data_criacao DESC');
  }

  Future<int> insertModelo(Map<String, dynamic> data, int userId) async {
    final db = await instance.database;
    data['user_id'] = userId;
    try {
      if (data.containsKey('filamentos_usados')) {
        List<dynamic> filamentosUsados = [];
        if (data['filamentos_usados'] is String) {
          filamentosUsados = jsonDecode(data['filamentos_usados']);
        } else {
          data['filamentos_usados'] = jsonEncode(data['filamentos_usados']);
        }
        if (filamentosUsados.isNotEmpty) {
          Map<String, dynamic> firstFilamento = Map<String, dynamic>.from(filamentosUsados.first);
          data['filamento_id'] = firstFilamento['filamentoId'];
          data['tipo_filamento'] = firstFilamento['cor'];
          data['gramas_utilizadas'] = firstFilamento['gramasUsados'];
        }
      }
      return await db.insert('modelo3d', data);
    } catch (e) {
      print("Erro ao inserir modelo: $e");
      Map<String, dynamic> insertRow = {
        'nome': data['nome'],
        'filamento_id': 0,
        'tipo_filamento': '',
        'gramas_utilizadas': 0,
        'tempo_minutos': data['tempo_minutos'],
        'cliente_ou_pessoal': data['cliente_ou_pessoal'],
        'cliente_id': data['cliente_id'],
        'cliente_nome': data['cliente_nome'],
        'energia_kwh': data['energia_kwh'],
        'custo_energia': data['custo_energia'],
        'custo_filamento': data['custo_filamento'],
        'custo_acessorios': data['custo_acessorios'],
        'custo_total': data['custo_total'],
        'acessorios_usados': data['acessorios_usados'],
        'preco_venda': data['preco_venda'],
        'data_criacao': data['data_criacao'],
        'user_id': userId
      };
      try {
        if (data.containsKey('filamentos_usados')) {
          List<dynamic> filamentosUsados = [];
          if (data['filamentos_usados'] is String) {
            filamentosUsados = jsonDecode(data['filamentos_usados']);
          } else if (data['filamentos_usados'] is List) {
            filamentosUsados = data['filamentos_usados'];
          }
          if (filamentosUsados.isNotEmpty) {
            Map<String, dynamic> firstFilamento = Map<String, dynamic>.from(filamentosUsados.first);
            insertRow['filamento_id'] = firstFilamento['filamentoId'];
            insertRow['tipo_filamento'] = firstFilamento['cor'];
            insertRow['gramas_utilizadas'] = firstFilamento['gramasUsados'];
          }
        }
        return await db.insert('modelo3d', insertRow);
      } catch (e) {
        print("Erro no modo fallback: $e");
        rethrow;
      }
    }
  }

  Future<void> deleteModelo(int id) async {
    final db = await instance.database;
    await db.delete('modelo3d', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateModelo(Map<String, dynamic> modeloMap, int id) async {
    final db = await database;
    return await db.update(
      'modelo3d',
      modeloMap,
      where: 'id = ?',
      whereArgs: [id],
    );
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