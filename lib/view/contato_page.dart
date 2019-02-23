import 'package:agenda_contatos/class/contato.dart';
import 'package:flutter/material.dart';

class ContatoPage extends StatefulWidget {

  final Contato contato;
  
  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {

  Contato _editandoContato;

  @override
  void initState(){
    super.initState();
    if(widget.contato == null){
      _editandoContato = Contato();
    }else{
      _editandoContato = Contato.doMap(widget.contato.paraMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(_editandoContato.nome ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon( Icons.save),
        backgroundColor: Colors.pink,
      ),
    );
  }
}