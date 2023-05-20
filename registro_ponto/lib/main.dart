import 'package:flutter/material.dart';
import 'package:registro_ponto/ponto.dart';
import 'package:registro_ponto/historico.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Ponto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PontoPage(),
        '/historico': (context) => HistoricoPage(),
      },
    );
  }
}
