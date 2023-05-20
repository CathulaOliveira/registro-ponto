import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:registro_ponto/dao/registro_ponto_dao.dart';
import 'package:registro_ponto/registro.dart';

class HistoricoPage extends StatefulWidget {
  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  List<Registro> registros = [];
  final _dao = RegistroPontoDao();

  @override
  void initState() {
    super.initState();
    _atualizarDados(); // Inicia a atualização da hora atual
  }

  Future<void> _atualizarDados() async {
    final registrosListar = await _dao.listar();
    setState(() {
      registros.clear();
      if (registrosListar.isNotEmpty) {
        registros.addAll(registrosListar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Registros'),
      ),
      body: ListView.builder(
        itemCount: registros.length,
        itemBuilder: (context, index) {
          final registro = registros[index];
          return ListTile(
            title: Text('${registro.id} - ${registro.dateTime.toString()}'),
            subtitle: Text(
              'Latitude: ${registro.latitude}, Longitude: ${registro.longitude}',
            ),
            onTap: () {
              abrirLocalizacaoNoMapa(registro.latitude!!, registro.longitude!!);
            },
          );
        },
      ),
    );
  }

  void abrirLocalizacaoNoMapa(double latitude, double longitude) {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }
}
