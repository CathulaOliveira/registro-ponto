import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_ponto/dao/registro_ponto_dao.dart';
import 'package:registro_ponto/registro.dart';
import 'package:geolocator/geolocator.dart';

class PontoPage extends StatefulWidget {
  @override
  _PontoPageState createState() => _PontoPageState();
}

class _PontoPageState extends State<PontoPage> {
  List<Registro> registros = [];
  String horaAtual = ''; // Variável para armazenar a hora atual
  Timer? _timer; // Variável para armazenar o Timer
  final _dao = RegistroPontoDao();

  @override
  void initState() {
    super.initState();
    _atualizarHoraAtual(); // Inicia a atualização da hora atual
  }

  @override
  void dispose() {
    _cancelarAtualizacaoHoraAtual(); // Cancela a atualização da hora atual ao sair da tela
    super.dispose();
  }

  void _atualizarHoraAtual() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        horaAtual = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  void _cancelarAtualizacaoHoraAtual() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Ponto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              horaAtual, // Utiliza a variável horaAtual para exibir a hora atual
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _registrarPonto();
              },
              child: Text('Registrar Ponto'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/historico');
              },
              child: Text('Verificar Histórico'),
            ),
          ],
        ),
      ),
    );
  }

  void _registrarPonto() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar se os serviços de localização estão ativados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Serviços de Localização Desativados'),
            content: Text('Por favor, ative os serviços de localização para registrar o ponto.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Verificar permissões de localização
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permissões de Localização Negadas'),
              content: Text('Por favor, conceda as permissões de localização para registrar o ponto.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // Obter a posição atual do dispositivo
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Criar o registro de ponto com data, hora e coordenadas
    final dateTime = DateTime.now();
    final registro = Registro(dateTime: dateTime, latitude: position.latitude, longitude: position.longitude);

    // Mostrar uma popup com as informações do registro de ponto
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text('Registro de Ponto'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Data e Hora: ${registro.dateTime.toString()}'),
              SizedBox(height: 10),
              Text('Latitude: ${registro.latitude}'),
              SizedBox(height: 10),
              Text('Longitude: ${registro.longitude}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _dao.salvar(registro);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        },
    );
  }

  void _mostrarHistorico() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Histórico de Registros'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return ListTile(
                  title: Text(DateFormat("dd/MM/yyyy hh:mm:ss").format(registro.dateTime!)),
                  subtitle: Text(
                    'Latitude: ${registro.latitude}, Longitude: ${registro.longitude}',
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
