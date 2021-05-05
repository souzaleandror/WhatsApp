enum TypeMensagem { texto, audio, imagem }

class Mensagem {
  String idUsuario;
  String whoSend;
  String whoReceived;
  String parentDocumentId;
  String documentId;
  String mensagem;
  String urlImagem;
  String tipo;
  int type;
  int typeMensagem;
  bool readed;
  DateTime created;
  DateTime dateReaded;

  Mensagem({
    this.idUsuario,
    this.whoSend,
    this.whoReceived,
    this.parentDocumentId,
    this.documentId,
    this.mensagem,
    this.urlImagem,
    this.tipo,
    this.type,
    this.typeMensagem,
    this.readed,
    this.created,
    this.dateReaded,
  });

  factory Mensagem.fromMap(Map<String, dynamic> map) {
    return new Mensagem(
      idUsuario: map['idUsuario'] as String,
      whoSend: map['whoSend'] as String,
      whoReceived: map['whoReceived'] as String,
      parentDocumentId: map['parentDocumentId'] as String,
      documentId: map['documentId'] as String,
      mensagem: map['mensagem'] as String,
      urlImagem: map['urlImagem'] as String,
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
      'idUsuario': this.idUsuario,
      'whoSend': this.whoSend,
      'whoReceived': this.whoReceived,
      'parentDocumentId': this.parentDocumentId,
      'documentId': this.documentId,
      'mensagem': this.mensagem,
      'urlImagem': this.urlImagem,
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
    return 'Mensagem{idUsuario: $idUsuario, whoSend: $whoSend, whoReceived: $whoReceived, parentDocumentId: $parentDocumentId, documentId: $documentId, mensagem: $mensagem, urlImagem: $urlImagem, tipo: $tipo, type: $type, typeMensagem: $typeMensagem, readed: $readed, created: $created, dateReaded: $dateReaded}';
  }
}
