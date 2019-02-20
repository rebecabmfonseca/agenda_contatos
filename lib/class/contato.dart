import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tabContato = "contatoTabela";
final String idCol = "idColuna";
final String nomeCol = "nomeColuna";
final String emailCol = "emailColuna";
final String telCol = "telefoneColuna";
final String imgCol = "imagemColuna";

class Contatos{
  static final Contatos _instancia = Contatos.interno();
  factory Contatos() => _instancia;
  Contatos.interno();

  Database _bd;

  Future<Database> get bd async{
    if(_bd != null){
      return _bd;
    }else{
      _bd = await iniciarBD();
      return _bd;
    }
  }

  Future<Database> iniciarBD() async{
    final caminhoBd = await getDatabasesPath();
    final caminho = join(caminhoBd, "contatos.db");

    return await openDatabase(caminho, version:1, onCreate: (Database bd, int novaVersao) async{
      await bd.execute(
        "CREATE TABLE $tabContato($idCol INTEGER PRIMARY KEY, $nomeCol TEXT, $emailCol TEXT, $telCol TEXT, $imgCol TEXT)"
      );
    });
  }

  Future<Contato> salvarContato(Contato contato) async{
    Database banco = await bd;
    contato.id = await banco.insert(tabContato, contato.paraMap());
    return contato;
  }

  Future<Contato> pegarContato(int id) async{
    Database banco = await bd;
    List<Map> mapas = await banco.query(tabContato,
    columns: [idCol, nomeCol, emailCol, telCol, imgCol],
    where: "$idCol=?",
    whereArgs: [id]);

    if(mapas.length > 0){
      return Contato.doMap(mapas.first);
    }else{
      return null;
    }

  }

  Future<int>removeContato(int id)async{
    Database banco = await bd;
    return await banco.delete(tabContato, where: "$idCol=?", whereArgs: [id]);

  }

  Future<int> atualizaContato(Contato contato)async{
    Database banco = await bd;
    return banco.update(tabContato, contato.paraMap(), where: "$idCol=?", whereArgs: [contato.id]);
  }

  Future<List> todosContatos()async{
    Database banco = await bd;
    String sql = "SELECT * FROM $tabContato";
    List lista = await banco.rawQuery(sql);
    List<Contato> listaContatos = List();
    for (Map m in lista) {
      listaContatos.add(Contato.doMap(m));
    }
    return listaContatos;

  }

  Future<int> quantidadeContatos()async{
    Database banco = await bd;
    String sql = "SELECT COUNT(*) FROM $tabContato";
    return Sqflite.firstIntValue(await banco.rawQuery(sql));
  }
  
  Future fecharBD() async{
    Database banco = await bd;
    banco.close();

  }
  
}

class Contato{

  int id;
  String nome;
  String email;
  String telefone;
  String imagem;

  Contato.doMap(Map map){
    id = map[idCol];
    nome = map[nomeCol];
    email = map[emailCol];
    telefone = map[telCol];
    imagem = map[imgCol];
  }

  Map paraMap(){
    Map<String, dynamic> map = {
      nomeCol: nome,
      emailCol:email,
      telCol:telefone,
      imgCol:imagem
    };

    if(id != null){
      map[idCol] = id;
    }
    return map;
  }

  @override
  String toString(){
    return "Contato(id:$id, nome:$nome, email: $email, telefone: $telefone, img:$imagem";
  }

}