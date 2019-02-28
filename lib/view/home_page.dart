import 'dart:io';

import 'package:agenda_contatos/class/contato.dart';
import 'package:agenda_contatos/view/contato_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Contatos contatoControl = Contatos();

  List<Contato> contatos = List();

  @override
  void initState() {
    super.initState();
    atualizaContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contatos"),
          backgroundColor: Colors.pink,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _mostrarPageContato();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length,
          itemBuilder: (contexto, i) {
            return cardContato(contexto, i);
          },
        ));
  }

  Widget cardContato(BuildContext contexto, int i) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contatos[i].imagem != null
                            ? FileImage(File(contatos[i].imagem))
                            : AssetImage("imagens/pessoa.png"))),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contatos[i].nome ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contatos[i].email ?? "",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        contatos[i].telefone ?? "",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
      onTap: () {
        _mostrarOpcoes(contexto, i);
      },
    );
  }

  void atualizaContatos() {
    contatoControl.todosContatos().then((lista) {
      setState(() {
        contatos = lista;
      });
    });
  }

  void _mostrarPageContato({Contato contato}) async {
    final recuperaContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (contexto) => ContatoPage(
                  contato: contato,
                )));
    if (recuperaContato != null) {
      if (contato != null) {
        await contatoControl.atualizaContato(recuperaContato);
      } else {
        await contatoControl.salvarContato(recuperaContato);
      }
      atualizaContatos();
    }
  }

  void _mostrarOpcoes(BuildContext context, int i) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.pink, fontSize: 20.0),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.pink, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _mostrarPageContato(contato: contatos[i]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.pink, fontSize: 20.0),
                        ),
                        onPressed: () {
                          contatoControl.removeContato(contatos[i].id);
                          setState(() {
                            contatos.removeAt(i);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
