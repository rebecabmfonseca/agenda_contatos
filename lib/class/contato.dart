import 'package:sqflite/sqflite.dart';

final String idCol = "idColuna";
final String nomeCol = "nomeColuna";
final String emailCol = "emailColuna";
final String telCol = "telefoneColuna";
final String imgCol = "imagemColuna";

class Contatos{

}

class Contato{

  int id;
  String nome;
  String email;
  String telefone;
  String imagem;

  Contato.fromMap(Map map){
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