import 'package:hive/hive.dart';

import 'enums/tipo_parametro.dart';

part 'parametro_modelo.g.dart';

@HiveType(typeId: 0)
class Parametro {
  @HiveField(0)
  TipoParametro id;
  @HiveField(1)
  String valor;

  Parametro(this.id, this.valor);
}

/*

CREATE TABLE [Parametro] ( 
  [ParametroID]    SMALLINT    NOT NULL, 
  [ParametroValor] VARCHAR(1000)    NOT NULL, 
     PRIMARY KEY ( [ParametroID] ))

*/
