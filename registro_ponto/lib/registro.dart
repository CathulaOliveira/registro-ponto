import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_ponto/dao/registro_ponto_dao.dart';

class Registro {

  static const CAMPO_ID = 'id';
  static const CAMPO_DATE_TIME = 'date_time';
  static const CAMPO_LATITUDE = 'latitude';
  static const CAMPO_LONGITUDE = 'longitude';
  static const NOME_TABLE = 'registro_ponto';

  int? id;
  DateTime? dateTime;
  double? latitude;
  double? longitude;

  Registro({this.id, required this.dateTime, this.latitude, this.longitude});

  String get dataFormatado {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy hh:mm:ss').format(dateTime!);
  }

  Map<String, dynamic> toMap() => {
    CAMPO_ID: id,
    CAMPO_DATE_TIME: dateTime == null ? null : DateFormat("dd/MM/yyyy hh:mm:ss").format(dateTime!),
    CAMPO_LATITUDE: latitude,
    CAMPO_LONGITUDE: longitude,
  };

  factory Registro.fromMap(Map<String, dynamic> map) => Registro(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    dateTime: map[CAMPO_DATE_TIME] == null ? null : DateFormat('dd/MM/yyyy hh:mm:ss').parse(map[CAMPO_DATE_TIME]),
    latitude: map[CAMPO_LATITUDE] is double ? map[CAMPO_LATITUDE] : '',
    longitude: map[CAMPO_LONGITUDE] is double ? map[CAMPO_LONGITUDE] : '',
  );
}
