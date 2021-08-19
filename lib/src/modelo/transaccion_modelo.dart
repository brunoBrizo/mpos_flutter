import 'package:mpos/src/modelo/moneda_modelo.dart';
import 'package:hive/hive.dart';
import 'enums/tipo_transaccion.dart';

part 'transaccion_modelo.g.dart';

@HiveType(typeId: 4)
class Transaccion {
  @HiveField(0)
  int id;
  @HiveField(1)
  String user;
  @HiveField(2)
  DateTime fecha;
  @HiveField(3)
  TipoTransaccion tipo;
  @HiveField(4)
  Moneda moneda;
  @HiveField(5)
  double monto;
  @HiveField(6)
  String nroAutorizacion;
  @HiveField(7)
  int ticket;
  @HiveField(8)
  int nroFactura;
  @HiveField(9)
  int cuotas;
  @HiveField(10)
  double facturaMonto;
  @HiveField(11)
  double facturaMontoGravado;
  @HiveField(12)
  double facturaMontoIva;
  @HiveField(13)
  double montoPropina;
  @HiveField(14)
  double decretoLeyMonto;
  @HiveField(15)
  bool firmarVoucher;
  @HiveField(16)
  String tarjetaNumero;
  @HiveField(17)
  String tarjetaNombre;
  @HiveField(18)
  String tarjetaTitular;
  @HiveField(19)
  bool aprobada;
  @HiveField(20)
  String mid;
  @HiveField(21)
  int terminalId;
  @HiveField(22)
  bool fueDevuelto;
  @HiveField(23)
  String empCod;
  @HiveField(24)
  String termCod;
  @HiveField(25)
  String tokenNro;
  @HiveField(26)
  int tokenSegundosConsultar;
  @HiveField(27)
  String codigoRespuesta;
  @HiveField(28)
  String mensajeRespuesta;
  @HiveField(29)
  int ticketOriginal;
  @HiveField(30)
  int tarjetaId;

  @override
  String toString() {
    return "id: " +
        id.toString() +
        " fecha " +
        fecha.toString() +
        " token " +
        tokenNro +
        " tarjeta " +
        tarjetaNumero +
        " " +
        tarjetaTitular +
        " monto " +
        monto.toString();
  }
}

enum EstadosTransaccion {
  estado_0_Borrador,
  estado_1_PendienteProceso,
  estado_2_EnProceso,
  estado_3_ProcesadaSinConfirmar,
  estado_4_FinalizadaCorrectamente,
  estado_5_FinalizadaConError,
  estado_6_Cancelada
}
