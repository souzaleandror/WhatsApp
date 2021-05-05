import 'package:flutter/material.dart';
import 'package:whatsapp/model/conversa.dart';

class AbaConversas extends StatefulWidget {
  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> listaConversas = [
    Conversa('Jamilton', 'Ola, tudo bem',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-644ea.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=55342466-6334-4dbf-8e0a-9ed1bfd5376c'),
    Conversa('Jamilton1', 'Ola, tudo bem2',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-644ea.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=64295a19-5596-466f-87f6-7cc0feb95273'),
    Conversa('Jamilton2', 'Ola, tudo bem3',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-644ea.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=c55f18d6-b240-40d8-9e01-9020e9b663ed'),
    Conversa('Jamilton3', 'Ola, tudo bem4',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-644ea.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=5b12dfc8-8232-4ce3-80aa-be7b67d691ec'),
    Conversa('Jamilton4', 'Ola, tudo bem5',
        'https://firebasestorage.googleapis.com/v0/b/whatsapp-644ea.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=023f7860-ebb6-4ac8-aaef-679d66906369'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        Conversa conversa = listaConversas[index];
        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversa.caminhoFoto),
          ),
          title: Text(
            conversa.nome,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            conversa.messagem,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        );
      },
    );
  }
}
