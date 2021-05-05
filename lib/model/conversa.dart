class Conversa {
  String _nome;
  String _messagem;
  String _caminhoFoto;

  Conversa(this._nome, this._messagem, this._caminhoFoto);

  String get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  String get messagem => _messagem;

  set messagem(String value) {
    _messagem = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
