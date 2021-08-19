class Notificacion {
  int id;
  String name;

  Notificacion(this.id, this.name);

  static List<Notificacion> getNotificaciones() {
    return <Notificacion>[
      Notificacion(0, 'No notificar'),
      Notificacion(1, 'Email'),
      Notificacion(2, 'WhatsApp'),
      Notificacion(3, 'Elegir al momento'),
    ];
  }

  static Notificacion getNotificacion(int valor) {
    List<Notificacion> lstNotificaciones = Notificacion.getNotificaciones();
    for (Notificacion notAux in lstNotificaciones) {
      if (notAux.id == valor) {
        return notAux;
      }
    }
    return null;
  }

  static int getNotificacionPosition(int valor) {
    List<Notificacion> lstNotificaciones = Notificacion.getNotificaciones();
    int position = 0;
    for (Notificacion notAux in lstNotificaciones) {
      if (notAux.id == valor) {
        return position;
      }
      position++;
    }
    return null;
  }
}
