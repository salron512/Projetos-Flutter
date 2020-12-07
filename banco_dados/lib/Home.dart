import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados()async{
    final caminhoBancoDados = await  getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");
    var db = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );
    return db;
    //print("aberto: " + db.isOpen.toString());
  }
  _salvar() async{
    Database db = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuarios = {
      "nome" : "André Ricardo Vicensotti",
      "idade" : 28
    };
    int id =  await db.insert("usuario", dadosUsuarios);
    //print("Salvo $id");
  }
  _listarUsuarios() async{
    Database bd = await _recuperarBancoDados();
    //String sql = "SELECT * FROM usuario";
    String sql = "SELECT * FROM usuario";
    List usuarios = await bd.rawQuery(sql);

    for(var usuario in usuarios){
      print(
        " id: " + usuario["id"].toString()+
        " nome: " + usuario["nome"]+
            " idade: " + usuario["idade"].toString()
      );
    }
  }

  _recuperarUsuarioPeloId(int id) async{
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuario";
    List usuarios = await bd.query(
      "usuario",
      columns: ["id","nome","idade"],
      where: "id = ?",
      whereArgs: [id]
    );
    for(var usuario in usuarios){
      print(
          " id: " + usuario["id"].toString()+
              " nome: " + usuario["nome"]+
              " idade: " + usuario["idade"].toString()
      );
    }
  }

  _excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    
    bd.delete(
      "usuario",
      where: "id = ?",
      whereArgs: [id]
    );
  }
  _altrerarUsuario(int id) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuarios = {
      "nome" : "André Ricardo Vicensotti",
      "idade" : 28
    };
   bd.update(
       "usuario",
       dadosUsuarios,
       where: "id = ?",
     whereArgs: [id]
   );
  }
  @override
  Widget build(BuildContext context) {
    //_recuperarUsuarioPeloId(2);
   // _excluirUsuario(1);
   //_salvar();
    _altrerarUsuario(3);
    _listarUsuarios();
    return Scaffold(
      appBar: AppBar(
        title: Text("Banco de Dados"),
      ),
      body: Container(
        child: Column(
          children:<Widget> [

          ],
        ),
      ),
    );
  }
}
