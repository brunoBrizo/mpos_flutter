class TipoConexion {
  int id;
  String name;

  TipoConexion(this.id, this.name);

  static List<TipoConexion> getTipoConexiones() {
    return <TipoConexion>[
      TipoConexion(1, 'Datos'),
      TipoConexion(2, 'WiFi'),
    ];
  }

  static TipoConexion getTipoConexion(int valor) {
    List<TipoConexion> lstConexiones = TipoConexion.getTipoConexiones();
    for (TipoConexion conAux in lstConexiones) {
      if (conAux.id == valor) {
        return conAux;
      }
    }
    return null;
  }

  static int getTipoConexionPosition(int valor) {
    List<TipoConexion> lstConexiones = TipoConexion.getTipoConexiones();
    int position = 0;
    for (TipoConexion conAux in lstConexiones) {
      if (conAux.id == valor) {
        return position;
      }
      position++;
    }
    return null;
  }
}
