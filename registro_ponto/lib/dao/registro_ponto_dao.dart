import 'package:registro_ponto/database/database_provider.dart';
import 'package:registro_ponto/registro.dart';

class RegistroPontoDao {

  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Registro registro) async {
    final db = await dbProvider.database;
    final valores = registro.toMap();

    if (registro.id == null) {
      registro.id = await db.insert(Registro.NOME_TABLE, valores);
      return true;
    } else {
      final registrosAtualizados = await db.update(
          Registro.NOME_TABLE,
          valores,
          where: '${Registro.CAMPO_ID} = ?',
          whereArgs: [registro.id]
      );
      return registrosAtualizados > 0;
    }
  }

  Future<List<Registro>> listar() async {
    var orderBy = Registro.CAMPO_ID;
    orderBy += ' DESC';
    final db = await dbProvider.database;
    final query = '''
      SELECT
        ${Registro.CAMPO_ID},
        ${Registro.CAMPO_DATE_TIME},
        ${Registro.CAMPO_LONGITUDE},
        ${Registro.CAMPO_LATITUDE}
        FROM ${Registro.NOME_TABLE}
        ORDER BY $orderBy
    ''';
    final resultado = await db.rawQuery(query);
    return resultado.map((m) => Registro.fromMap(m)).toList();
  }
}