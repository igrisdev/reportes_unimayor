// To parse this JSON data, do
//
//     final reportsModel = reportsModelFromJson(jsonString);

import 'dart:convert';

List<ReportsModel> reportsModelFromJson(String str) => List<ReportsModel>.from(
  json.decode(str).map((x) => ReportsModel.fromJson(x)),
);

String reportsModelToJson(List<ReportsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportsModel {
  int idReporte;
  Usuario usuario;
  Ubicacion ubicacion;
  String descripcion;
  String detallesFinalizacion;
  String ubicacionTextOpcional;
  String rutaAudio;
  String estado;
  bool paraMi;
  DateTime fechaCreacion;
  String horaCreacion;

  ReportsModel({
    required this.idReporte,
    required this.usuario,
    required this.ubicacion,
    required this.descripcion,
    required this.detallesFinalizacion,
    required this.ubicacionTextOpcional,
    required this.rutaAudio,
    required this.estado,
    required this.paraMi,
    required this.fechaCreacion,
    required this.horaCreacion,
  });

  ReportsModel copyWith({
    int? idReporte,
    Usuario? usuario,
    Ubicacion? ubicacion,
    String? descripcion,
    String? detallesFinalizacion,
    String? ubicacionTextOpcional,
    String? rutaAudio,
    String? estado,
    bool? paraMi,
    DateTime? fechaCreacion,
    String? horaCreacion,
  }) => ReportsModel(
    idReporte: idReporte ?? this.idReporte,
    usuario: usuario ?? this.usuario,
    ubicacion: ubicacion ?? this.ubicacion,
    descripcion: descripcion ?? this.descripcion,
    detallesFinalizacion: detallesFinalizacion ?? this.detallesFinalizacion,
    ubicacionTextOpcional: ubicacionTextOpcional ?? this.ubicacionTextOpcional,
    rutaAudio: rutaAudio ?? this.rutaAudio,
    estado: estado ?? this.estado,
    paraMi: paraMi ?? this.paraMi,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    horaCreacion: horaCreacion ?? this.horaCreacion,
  );

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
    idReporte: json["idReporte"],
    usuario: Usuario.fromJson(json["usuario"]),
    ubicacion: json["ubicacion"] != null
        ? Ubicacion.fromJson(json["ubicacion"])
        : Ubicacion(
            idUbicacion: 0,
            descripcion: '',
            sede: '',
            edificio: '',
            lugar: '',
            piso: '',
            rutaQr: '',
          ),
    descripcion: json["descripcion"] ?? "",
    detallesFinalizacion: json["detallesFinalizacion"] ?? "",
    ubicacionTextOpcional: json["ubicacionTextOpcional"] ?? "",
    rutaAudio: json["rutaAudio"] ?? "",
    estado: json["estado"],
    paraMi: json["paraMi"],
    fechaCreacion: DateTime.parse(json["fechaCreacion"]),
    horaCreacion: json["horaCreacion"],
  );

  Map<String, dynamic> toJson() => {
    "idReporte": idReporte,
    "usuario": usuario.toJson(),
    "ubicacion": ubicacion.toJson(),
    "descripcion": descripcion,
    "detallesFinalizacion": detallesFinalizacion,
    "ubicacionTextOpcional": ubicacionTextOpcional,
    "rutaAudio": rutaAudio,
    "estado": estado,
    "paraMi": paraMi,
    "fechaCreacion":
        "${fechaCreacion.year.toString().padLeft(4, '0')}-${fechaCreacion.month.toString().padLeft(2, '0')}-${fechaCreacion.day.toString().padLeft(2, '0')}",
    "horaCreacion": horaCreacion,
  };
}

class Ubicacion {
  int idUbicacion;
  String descripcion;
  String sede;
  String edificio;
  String lugar;
  String piso;
  String rutaQr;

  Ubicacion({
    required this.idUbicacion,
    required this.descripcion,
    required this.sede,
    required this.edificio,
    required this.lugar,
    required this.piso,
    required this.rutaQr,
  });

  Ubicacion copyWith({
    int? idUbicacion,
    String? descripcion,
    String? sede,
    String? edificio,
    String? lugar,
    String? piso,
    String? rutaQr,
    dynamic reportes,
  }) => Ubicacion(
    idUbicacion: idUbicacion ?? this.idUbicacion,
    descripcion: descripcion ?? this.descripcion,
    sede: sede ?? this.sede,
    edificio: edificio ?? this.edificio,
    lugar: lugar ?? this.lugar,
    piso: piso ?? this.piso,
    rutaQr: rutaQr ?? this.rutaQr,
  );

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
    idUbicacion: json["idUbicacion"] ?? 0,
    descripcion: json["descripcion"] ?? '',
    sede: json["sede"] ?? '',
    edificio: json["edificio"] ?? '',
    lugar: json["lugar"] ?? '',
    piso: json["piso"] ?? '',
    rutaQr: json["rutaQr"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "idUbicacion": idUbicacion,
    "descripcion": descripcion,
    "sede": sede,
    "edificio": edificio,
    "lugar": lugar,
    "piso": piso,
    "rutaQr": rutaQr,
  };
}

class Usuario {
  String correo;
  String? nombre;
  dynamic rutaFoto;
  dynamic mensaje;

  Usuario({
    required this.correo,
    required this.nombre,
    required this.rutaFoto,
    required this.mensaje,
  });

  Usuario copyWith({
    String? correo,
    String? nombre,
    dynamic rutaFoto,
    dynamic mensaje,
  }) => Usuario(
    correo: correo ?? this.correo,
    nombre: nombre ?? this.nombre,
    rutaFoto: rutaFoto ?? this.rutaFoto,
    mensaje: mensaje ?? this.mensaje,
  );

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    correo: json["correo"],
    nombre: json["nombre"],
    rutaFoto: json["rutaFoto"],
    mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
    "correo": correo,
    "nombre": nombre,
    "rutaFoto": rutaFoto,
    "mensaje": mensaje,
  };
}
