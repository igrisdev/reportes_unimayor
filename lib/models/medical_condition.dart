class MedicalCondition {
  final String id;
  final int? idUsuario;
  final String nombre;
  final String descripcion;
  final DateTime fechaDiagnostico;
  final String? mensaje;

  MedicalCondition({
    required this.id,
    this.idUsuario,
    required this.nombre,
    required this.descripcion,
    required this.fechaDiagnostico,
    this.mensaje,
  });

  factory MedicalCondition.fromJson(Map<String, dynamic> json) {
    final idValue = json['idCondicionMedica'] ?? json['id'] ?? '';
    final String idStr = idValue is int
        ? idValue.toString()
        : (idValue as String);

    DateTime parsedDate;
    final rawDate = json['fechaDiagnostico'];
    if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else {
      parsedDate = DateTime.now();
    }

    return MedicalCondition(
      id: idStr,
      idUsuario: json['idUsuario'] is int
          ? json['idUsuario'] as int
          : (json['idUsuario'] != null
                ? int.tryParse(json['idUsuario'].toString())
                : null),
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      fechaDiagnostico: parsedDate,
      mensaje: json['mensaje'] as String?,
    );
  }
}
