import 'package:flutter/material.dart';
import 'package:whatsapp/Configuracoes.dart';
import 'package:whatsapp/cadastro.dart';
import 'package:whatsapp/login.dart';
import 'package:whatsapp/mensagens.dart';

import 'home.dart';

class RouteGenerator {
  static const ROTA_HOME = '/home';
  static const ROTA_LOGIN = '/login';
  static const ROTA_CADASTRO = '/cadastro';
  static const ROTA_CONFIGURACOES = '/configuracoes';
  static const ROTA_MENSAGENS = '/mensagens';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case ROTA_LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case ROTA_CADASTRO:
        return MaterialPageRoute(builder: (_) => Cadastro());
        break;
      case ROTA_HOME:
        return MaterialPageRoute(builder: (_) => Home());
        break;
      case ROTA_CONFIGURACOES:
        return MaterialPageRoute(builder: (_) => Configuracoes());
        break;
      case ROTA_MENSAGENS:
        return MaterialPageRoute(builder: (_) => Mensagens(args));
        break;
      default:
        _erroRota();
        break;
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Tela Nao encontrado'),
        ),
        body: Center(
          child: Text('Tela Nao encontrado'),
        ),
      );
    });
  }
}
