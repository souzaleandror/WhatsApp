import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/model/usuario.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  String _uuidUsuariologado;
  String _emailUsuariologado;

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsuario();
  }

  Future<List<Usuario>> _recuperarUsuarios() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection('usuarios').getDocuments();

    List<Usuario> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if (dados['email'] == _emailUsuariologado) continue;
      Usuario usuario = Usuario();
      usuario.idUsuario = item.documentID;
      usuario.nome = dados['nome'];
      usuario.email = dados['email'];
      usuario.urlImagem = dados['urlImagem'];
      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  Future<void> _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    setState(() {
      _uuidUsuariologado = usuario.uid;
      _emailUsuariologado = usuario.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarUsuarios(),
      initialData: [],
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text('Carregando contatos'),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                List<Usuario> listaItens = snapshot.data;
                Usuario usuario = listaItens[index];
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RouteGenerator.ROTA_MENSAGENS,
                        arguments: usuario);
                  },
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  leading: CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: usuario.urlImagem != null
                        ? NetworkImage(usuario.urlImagem)
                        : null,
                  ),
                  title: Text(
                    usuario.nome,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            );
            break;
        }
        return Container();
      },
    );
  }
}
