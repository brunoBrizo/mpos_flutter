class LogError {
  int id;
  DateTime fecha;
  String stackTrace;
  String message;
}

/*
[LogErrId]         DECIMAL(10)    NOT NULL    IDENTITY ( 1 , 1 ), 
  [LogErrFecha]      DATETIME    NOT NULL, 
  [LogErrStackTrace] VARCHAR(200)    NOT NULL, 
  [LogErrMessage]    VARCHAR(MAX)    NOT NULL,

*/
