class EmergencyContact {
  final String id;
  String nombre;
  String relacion;
  String telefono;
  String? telefonoAlternativo;
  String? email;
  bool esPrincipal;

  EmergencyContact({
    required this.id,
    required this.nombre,
    required this.relacion,
    required this.telefono,
    this.telefonoAlternativo,
    this.email,
    this.esPrincipal = false,
  });

  // Constructor factory para deserializar desde el JSON de la API
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    final idValue = json['idContactoEmergencia'] ?? json['id'] ?? '';
    final String contactId = idValue is int
        ? idValue.toString()
        : (idValue as String);

    return EmergencyContact(
      id: contactId,
      nombre: json['nombre'] as String,
      relacion: json['relacion'] as String,
      telefono: json['telefono'] as String,
      telefonoAlternativo: json['telefonoAlternativo'] as String?,
      email: json['email'] as String?,
      esPrincipal: json['esPrincipal'] as bool,
    );
  }
}
