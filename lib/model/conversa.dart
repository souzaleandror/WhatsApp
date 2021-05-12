import 'package:cloud_firestore/cloud_firestore.dart';

enum TypeConversa { texto, audio, imagem }

class Conversa {
  String idRemetente;
  String idDestinario;
  String nome;
  String messagem;
  String urlImagem;
  String urlImagemMensagem;
  String tipoMensagem;
  String tipo;
  int type;
  int typeMensagem;
  bool readed;
  DateTime created;
  DateTime dateReaded;

  Future<void> salvar() async {
    Firestore db = Firestore.instance;
    await db
        .collection('conversas')
        .document(this.idRemetente)
        .collection('ultima_conversa')
        .document(this.idDestinario)
        .setData(this.toMap());
  }

  Conversa({
    this.idRemetente,
    this.idDestinario,
    this.nome,
    this.messagem,
    this.urlImagem,
    this.urlImagemMensagem,
    this.tipoMensagem,
    this.tipo,
    this.type,
    this.typeMensagem,
    this.readed,
    this.created,
    this.dateReaded,
  });

  factory Conversa.fromMap(Map<String, dynamic> map) {
    return new Conversa(
      idRemetente: map['idRemetente'] as String,
      idDestinario: map['idDestinario'] as String,
      nome: map['nome'] as String,
      messagem: map['messagem'] as String,
      urlImagem: map['urlImagem'] as String,
      urlImagemMensagem: map['urlImagemMensagem'] as String,
      tipoMensagem: map['tipoMensagem'] as String,
      tipo: map['tipo'] as String,
      type: map['type'] as int,
      typeMensagem: map['typeMensagem'] as int,
      readed: map['readed'] as bool,
      created: map['created'].toDate() as DateTime,
      dateReaded: map['dateReaded'] != null ? map['dateReaded'].toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'idRemetente': this.idRemetente,
      'idDestinario': this.idDestinario,
      'nome': this.nome,
      'messagem': this.messagem,
      'urlImagem': this.urlImagem,
      'urlImagemMensagem': this.urlImagemMensagem,
      'tipoMensagem': this.tipoMensagem,
      'tipo': this.tipo,
      'type': this.type,
      'typeMensagem': this.typeMensagem,
      'readed': this.readed,
      'created': this.created,
      'dateReaded': this.dateReaded,
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'Conversa{idRemetente: $idRemetente, idDestinario: $idDestinario, nome: $nome, messagem: $messagem, urlImagem: $urlImagem, urlImagemMensagem: $urlImagemMensagem, tipoMensagem: $tipoMensagem, tipo: $tipo, type: $type, typeMensagem: $typeMensagem, readed: $readed, created: $created, dateReaded: $dateReaded}';
  }
}
