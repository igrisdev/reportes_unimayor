class Ubicacion {
  final int idUbicacion;
  final String descripcion;
  final String sede;
  final String edificio;
  final String lugar;
  final String piso;
  final String rutaQr;
  final dynamic reportes;

  Ubicacion({
    required this.idUbicacion,
    required this.descripcion,
    required this.sede,
    required this.edificio,
    required this.lugar,
    required this.piso,
    required this.rutaQr,
    required this.reportes,
  });

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      idUbicacion: json['idUbicacion'] as int,
      descripcion: (json['descripcion'] as String?) ?? '',
      sede: (json['sede'] as String?) ?? '',
      edificio: (json['edificio'] as String?) ?? '',
      lugar: (json['lugar'] as String?) ?? '',
      piso: (json['piso'] as String?) ?? '',
      rutaQr: (json['rutaQr'] as String?) ?? '',
      reportes: json['reportes'],
    );
  }

  /// Etiqueta legible para el dropdown de salones (puedes ajustar)
  String displayLabel() {
    final title = lugar.isNotEmpty ? lugar : descripcion;
    if (piso.isNotEmpty) {
      return '$title · Piso $piso';
    }
    return title;
  }
}
