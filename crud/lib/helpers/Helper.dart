import 'package:crud/model/ModelClientes.dart';
import 'package:crud/model/ModelProdutos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Helper {
  static final nomeTabela = "produtos";
  static final Helper _helper = Helper._internal();

  Database _db;

  factory Helper() {
    return _helper;
  }
  // ignore: empty_constructor_bodies
  Helper._internal() {}
  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, preco VARCHAR, marca VARCHAR) ";
    String sql2 = "CREATE TABLE clientes (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, endereco VARCHAR, telefone VARCHAR)";

    await db.execute(sql);
    await db.execute(sql2);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "cadastro.db");
    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvar(ModelProdutos modelProdutos) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, modelProdutos.toMap());
    return resultado;
  }

  recuperar() async {
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY id DESC";
    List produtos = await bancoDados.rawQuery(sql);
    print("resultado: " + produtos.toString());
    return produtos;
  }

  Future<int> atualizar(ModelProdutos modelProdutos) async {
    var bancoDados = await db;
    return await bancoDados.update(nomeTabela, modelProdutos.toMap(),
        where: "id =?", whereArgs: [modelProdutos.id]);
  }

  Future<int> remover(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete(nomeTabela, where: "id =?", whereArgs: [id]);
  }
  Future<int> salvarProdutos(ModelProdutos modelProdutos) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert("clientes", modelProdutos.toMap());
    return resultado;
  }
  Future<int> salvarClientes(ModelClientes modelClientes) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert("clientes", modelClientes.toMap());
    return resultado;
  }

  recuperarClientes() async {
    var bancoDados = await db;
    String sql = "SELECT * FROM clientes ORDER BY id DESC";
    List produtos = await bancoDados.rawQuery(sql);
    print("resultado: " + produtos.toString());
    return produtos;
  }

  Future<int> atualizarClientes(ModelClientes modelClientes) async {
    var bancoDados = await db;
    return await bancoDados.update("clientes", modelClientes.toMap(),
        where: "id =?", whereArgs: [modelClientes.id]);
  }

  Future<int> removerClientes(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete("clientes", where: "id =?", whereArgs: [id]);
  }

}
