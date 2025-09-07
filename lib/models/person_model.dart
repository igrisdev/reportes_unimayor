import 'dart:convert';

PersonModel personModelFromJson(String str) =>
    PersonModel.fromJson(json.decode(str));

String personModelToJson(PersonModel data) => json.encode(data.toJson());

class PersonModel {
  InfoUsuario infoUsuario;
  List<Contacto> contactos;
  List<CondicionesMedica> condicionesMedicas;

  PersonModel({
    required this.infoUsuario,
    required this.contactos,
    required this.condicionesMedicas,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
    infoUsuario: InfoUsuario.fromJson(json["infoUsuario"]),
    contactos: List<Contacto>.from(
      json["contactos"].map((x) => Contacto.fromJson(x)),
    ),
    condicionesMedicas: List<CondicionesMedica>.from(
      json["condicionesMedicas"].map((x) => CondicionesMedica.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "infoUsuario": infoUsuario.toJson(),
    "contactos": List<dynamic>.from(contactos.map((x) => x.toJson())),
    "condicionesMedicas": List<dynamic>.from(
      condicionesMedicas.map((x) => x.toJson()),
    ),
  };
}

class CondicionesMedica {
  int idCondicionMedica;
  int idUsuario;
  String? nombre;
  String? descripcion;
  DateTime? fechaDiagnostico;
  String? mensaje;

  CondicionesMedica({
    required this.idCondicionMedica,
    required this.idUsuario,
    this.nombre,
    this.descripcion,
    this.fechaDiagnostico,
    this.mensaje,
  });

  factory CondicionesMedica.fromJson(Map<String, dynamic> json) =>
      CondicionesMedica(
        idCondicionMedica: json["idCondicionMedica"] ?? 0,
        idUsuario: json["idUsuario"] ?? 0,
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        fechaDiagnostico: json["fechaDiagnostico"] != null
            ? DateTime.tryParse(json["fechaDiagnostico"])
            : null,
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toJson() => {
    "idCondicionMedica": idCondicionMedica,
    "idUsuario": idUsuario,
    "nombre": nombre,
    "descripcion": descripcion,
    "fechaDiagnostico": fechaDiagnostico?.toIso8601String(),
    "mensaje": mensaje,
  };
}

class Contacto {
  int idContactoEmergencia;
  int idUsuario;
  String? nombre;
  String? relacion;
  String? telefono;
  String? telefonoAlternativo;
  String? email;
  bool esPrincipal;
  String? mensaje;

  Contacto({
    required this.idContactoEmergencia,
    required this.idUsuario,
    this.nombre,
    this.relacion,
    this.telefono,
    this.telefonoAlternativo,
    this.email,
    required this.esPrincipal,
    this.mensaje,
  });

  factory Contacto.fromJson(Map<String, dynamic> json) => Contacto(
    idContactoEmergencia: json["idContactoEmergencia"] ?? 0,
    idUsuario: json["idUsuario"] ?? 0,
    nombre: json["nombre"],
    relacion: json["relacion"],
    telefono: json["telefono"],
    telefonoAlternativo: json["telefonoAlternativo"],
    email: json["email"],
    esPrincipal: json["esPrincipal"] ?? false,
    mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
    "idContactoEmergencia": idContactoEmergencia,
    "idUsuario": idUsuario,
    "nombre": nombre,
    "relacion": relacion,
    "telefono": telefono,
    "telefonoAlternativo": telefonoAlternativo,
    "email": email,
    "esPrincipal": esPrincipal,
    "mensaje": mensaje,
  };
}

class InfoUsuario {
  String correo;
  String nombre;
  String rutaFoto;
  String? mensaje;

  InfoUsuario({
    required this.correo,
    required this.nombre,
    required this.rutaFoto,
    this.mensaje,
  });

  factory InfoUsuario.fromJson(Map<String, dynamic> json) => InfoUsuario(
    correo: json["correo"] ?? "",
    nombre: json["nombre"] ?? "",
    rutaFoto: json["rutaFoto"] ?? "",
    mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
    "correo": correo,
    "nombre": nombre,
    "rutaFoto": rutaFoto,
    "mensaje": mensaje,
  };
}
