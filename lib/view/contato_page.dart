import 'dart:io';

import 'package:agenda_contatos/class/contato.dart';
import 'package:flutter/material.dart';

class ContatoPage extends StatefulWidget {
  final Contato contato;

  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final _nomeControle = TextEditingController();
  final _emailControle = TextEditingController();
  final _telControle = TextEditingController();

  bool _usuarioEditou = false;
  final nomeFoco = FocusNode();
  Contato _editandoContato;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      _editandoContato = Contato();
    } else {
      _editandoContato = Contato.doMap(widget.contato.paraMap());
      _nomeControle.text = _editandoContato.nome;
      _emailControle.text = _editandoContato.email;
      _telControle.text = _editandoContato.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requisitandoPage,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            title: Text(_editandoContato.nome ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editandoContato.nome != null &&
                  _editandoContato.nome.isNotEmpty) {
                Navigator.pop(context, _editandoContato);
              } else {
                FocusScope.of(context).requestFocus(nomeFoco);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.pink,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editandoContato.imagem != null
                                ? FileImage(File(_editandoContato.imagem))
                                : AssetImage("imagens/pessoa.png"))),
                  ),
                ),
                TextField(
                  controller: _nomeControle,
                  focusNode: nomeFoco,
                  decoration: InputDecoration(
                    labelText: "Nome:",
                  ),
                  onChanged: (texto) {
                    _usuarioEditou = true;
                    setState(() {
                      _editandoContato.nome = texto;
                    });
                  },
                ),
                TextField(
                  controller: _emailControle,
                  decoration: InputDecoration(
                    labelText: "Email:",
                  ),
                  onChanged: (texto) {
                    _usuarioEditou = true;
                    _editandoContato.email = texto;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _telControle,
                  decoration: InputDecoration(
                    labelText: "Telefone:",
                  ),
                  onChanged: (texto) {
                    _usuarioEditou = true;
                    _editandoContato.telefone = texto;
                  },
                  keyboardType: TextInputType.phone,
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _requisitandoPage() {
    if(_usuarioEditou){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar alterações ?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
        );
        return Future.value(false);
    }else
        return Future.value(true);
  }
}
