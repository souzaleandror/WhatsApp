import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController _controllerName = TextEditingController();
  File _image;
  final picker = ImagePicker();
  String _uuidUsuariologado;
  bool subindoImage = false;
  String urlRecuperada = '';

  @override
  void initState() {
    super.initState();
    _recuperaDadosUsuario();
  }

  Future<void> _recuperaDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuario = await auth.currentUser();
    _uuidUsuariologado = usuario.uid;

    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
        await db.collection('usuarios').document(_uuidUsuariologado).get();
    Map<String, dynamic> dados = snapshot.data;
    _controllerName.text = dados['nome'];
    print(dados);
    if (dados['urlImagem'] != null) {
      setState(() {
        urlRecuperada = dados['urlImagem'];
      });
    }
  }

  Future<void> _recuperarImage(String s) async {
    var pickedFile;
    switch (s) {
      case 'camera':
        pickedFile = await picker.getImage(source: ImageSource.camera);
        break;
      case 'galeria':
        pickedFile = await picker.getImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      if (pickedFile != null) {
        subindoImage = true;
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child('perfil').child(_uuidUsuariologado + '.jpg');

    StorageUploadTask task = arquivo.putFile(_image);

    task.events.listen((StorageTaskEvent storageEvent) {
      if (storageEvent.type == StorageTaskEventType.progress) {
        setState(() {
          subindoImage = true;
        });
      } else if (storageEvent.type == StorageTaskEventType.success) {
        setState(() {
          subindoImage = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);

    setState(() {
      urlRecuperada = url;
    });
  }

  void _atualizarUrlImagemFirestore(String url) {
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {'urlImagem': url};

    db
        .collection('usuarios')
        .document(_uuidUsuariologado)
        .updateData(dadosAtualizar);
  }

  void _atualizarNomeFirestore({String name}) {
    String nome = name ?? _controllerName.text;
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {'nome': nome};

    db
        .collection('usuarios')
        .document(_uuidUsuariologado)
        .updateData(dadosAtualizar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracoes'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child:
                      subindoImage ? CircularProgressIndicator() : Container(),
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage: urlRecuperada != null
                      ? NetworkImage(urlRecuperada)
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      child: Text('Camera'),
                      onPressed: () {
                        _recuperarImage('camera');
                      },
                    ),
                    FlatButton(
                      child: Text('Galeria'),
                      onPressed: () {
                        _recuperarImage('galeria');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 32),
                    onChanged: (text) {
                      _atualizarNomeFirestore(name: text);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 10,
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      //_validarCampos();
                      _atualizarNomeFirestore();
                    },
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        32,
                      ),
                    ),
                    color: Colors.green,
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
