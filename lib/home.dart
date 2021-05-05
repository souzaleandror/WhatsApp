import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/abas/abaContatos.dart';
import 'package:whatsapp/abas/abaConversas.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String _emailUsuario = '';
  TabController _controller;

  List<String> listaMenu = ['Configuracoes', 'Logout'];

  Future<void> _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }

  _ecolharMenuItem(String itemEscolhido) {
    print('Item escolhido: ' + itemEscolhido);
    switch (itemEscolhido) {
      case 'Configuracoes':
        Navigator.pushNamed(context, RouteGenerator.ROTA_CONFIGURACOES);
        return;
        break;
      case 'Logout':
        _logout();
        break;
      default:
        return;
        break;
    }
  }

  Future<void> _logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
    //Navigator.of(context).pop(context);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Login(),
    //   ),
    // );
  }

  Future<void> verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
    }
  }

  @override
  void initState() {
    verificarUsuarioLogado();
    _recuperarDadosUsuario();
    _controller = TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp'),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: [
            Tab(
              text: 'Conversas',
            ),
            Tab(
              text: 'Contatos',
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _ecolharMenuItem,
            itemBuilder: (context) {
              return listaMenu.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          AbaConversas(),
          AbaContatos(),
        ],
      ),
    );
  }
}
