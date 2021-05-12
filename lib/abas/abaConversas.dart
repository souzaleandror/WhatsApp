import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/conversa.dart';
import 'package:whatsapp/model/usuario.dart';

import '../RouteGenerator.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> listaConversas = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  String _idUsuarioLogado;

  @override
  void initState() {
    _recuperaDadosUsuario();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _idUsuarioLogado = usuario.uid;

    _adicionarListenerConversas();
  }

  Stream<QuerySnapshot> _adicionarListenerConversas() {
    final stream = db
        .collection('conversas')
        .document(_idUsuarioLogado)
        .collection('ultima_conversa')
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text('Carregando conversas'),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.done:
          case ConnectionState.active:
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erro ao carregar dados'),
                  ],
                ),
              );
            } else {
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;

                if (querySnapshot.documents.length == 0) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Voce nao tem mensagens ainda'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> conversas =
                        querySnapshot.documents.toList();
                    DocumentSnapshot doc = conversas[index];
                    Conversa conversa = Conversa.fromMap(doc.data);

                    Usuario usuario = Usuario();
                    usuario.nome = conversa.nome;
                    usuario.urlImagem = conversa.urlImagem;
                    usuario.idUsuario = conversa.idDestinario;

                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.ROTA_MENSAGENS,
                            arguments: usuario);
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: conversa.urlImagem != null
                            ? NetworkImage(conversa.urlImagem)
                            : null,
                      ),
                      title: Text(
                        conversa.nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        conversa.tipo == 'texto'
                            ? conversa.messagem
                            : 'Imagem...',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  },
                );
              }
            }
            break;
        }
        return Container();
      },
    );
  }
}
