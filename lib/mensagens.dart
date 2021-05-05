import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/model/mensagem.dart';
import 'package:whatsapp/model/usuario.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;
  Mensagens(this.contato);
  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  Firestore db = Firestore.instance;

  String _idUsuarioLogado;
  String _idUsuarioDestinatario;

  List<String> listaDeMensagens = [
    "ola",
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
    "It is a long established fact that asda",
    "ola4",
    "ola5",
  ];
  TextEditingController _controllerMensagem = TextEditingController();

  void _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.mensagem = textoMensagem;
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.created = DateTime.now();
      mensagem.tipo = 'texto';
      mensagem.urlImagem = '';
      mensagem.type = 0;
      mensagem.documentId = '';
      mensagem.dateReaded = null;
      mensagem.parentDocumentId = '';
      mensagem.readed = false;
      mensagem.typeMensagem = TypeMensagem.texto.index;
      mensagem.whoReceived = _idUsuarioDestinatario;
      mensagem.whoSend = _idUsuarioLogado;
      mensagem.parentDocumentId = '';

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    }
  }

  Future<void> _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _idUsuarioLogado = usuario.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;
  }

  Future<void> _salvarMensagem(
      String idRemente, String idDestinario, Mensagem msg) async {
    DocumentReference dr = await db
        .collection('mensagens')
        .document(idRemente)
        .collection(idDestinario)
        .add(msg.toMap());

    dr.updateData({'documentId': dr.documentID});

    _controllerMensagem.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaDeMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: 'Digite uma mensagem....',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Color(0xff075E54),
                      ),
                      onPressed: _enviarFoto,
                    )),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: _enviarMensagem,
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
          )
        ],
      ),
    );

    var stream = StreamBuilder(
        stream: db
            .collection('mensagens')
            .document(_idUsuarioLogado)
            .collection(_idUsuarioDestinatario)
            .orderBy('created', descending: false)
            .snapshots(),
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
              QuerySnapshot querySnapshot = snapshot.data;

              if (snapshot.hasError) {
                return Expanded(
                  child: Text('erro ao carregar dados'),
                );
              } else {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: querySnapshot.documents.length,
                      itemBuilder: (context, index) {
                        List<DocumentSnapshot> mensagens =
                            querySnapshot.documents.toList();
                        // print(mensagens);
                        DocumentSnapshot item = mensagens[index];
                        // print(item);

                        Mensagem mensagem = Mensagem.fromMap(
                            querySnapshot.documents[index].data);

                        double larguraContainer;
                        bool myMensagem = true;

                        // larguraContainer =
                        //     MediaQuery.of(context).size.width * 0.80;

                        if (mensagem.mensagem.length >= 15) {
                          larguraContainer =
                              MediaQuery.of(context).size.width * 0.80;
                        } else {
                          larguraContainer =
                              MediaQuery.of(context).size.width * 0.50;
                        }

                        if (mensagem.idUsuario != _idUsuarioLogado) {
                          myMensagem = false;
                        }

                        return Align(
                          alignment: myMensagem
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Container(
                              width: larguraContainer,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: myMensagem
                                    ? Color(0xffd2ffa5)
                                    : Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: myMensagem
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: myMensagem
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Text(
                                    mensagem.mensagem,
                                    softWrap: true,
                                    textAlign: myMensagem
                                        ? TextAlign.end
                                        : TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  !myMensagem
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 4.0),
                                              child: Icon(Icons.done_all),
                                            ),
                                            Text(
                                              DateFormat(
                                                      'dd/MM/yyyy - HH:mm:ss')
                                                  .format(mensagem.created),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              DateFormat(
                                                      'dd/MM/yyyy - HH:mm:ss')
                                                  .format(DateTime.now()),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Icon(
                                                Icons.done_all,
                                                color: mensagem.readed
                                                    ? Colors.blue
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: Text(
                      'Voce nao tem coversa com essa pessoa',
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                }
              }

              break;
          }
          return Container();
        });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: CircleAvatar(
                maxRadius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: widget.contato.urlImagem != null
                    ? NetworkImage(
                        widget.contato.urlImagem,
                      )
                    : null,
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.contato.nome),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('imagens/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                stream,
                caixaDeMensagem,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _enviarFoto() {}
}
