import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/RouteGenerator.dart';
import 'package:whatsapp/login.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff075E54),
  accentColor: Color(0xff25D366),
);

final ThemeData temaIos = ThemeData(
  primaryColor: Colors.grey[200],
  accentColor: Color(0xff25D366),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firestore.instance
  //     .collection('usuarios')
  //     .document('001')
  //     .setData({'er1': '1231'});

  runApp(MaterialApp(
    home: Login(),
    theme: Platform.isAndroid ? temaPadrao : temaIos,
    initialRoute: '/',

    onGenerateRoute: RouteGenerator.generateRoute,
    // onGenerateRoute: (RouteSettings settings) {
    //   switch(settings.name) {
    //     case 'home': return Home();break;
    //     default: Home();break;
    //   }
    // },
    // routes: {
    //   '/login': (context) => Login(),
    //   '/home': (context) => Home(),
    // },
    debugShowCheckedModeBanner: false,
  ));
}
