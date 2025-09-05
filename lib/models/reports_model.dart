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
  String rutaAudio;
  String estado;
  DateTime fechaCreacion;
  String horaCreacion;

  ReportsModel({
    required this.idReporte,
    required this.usuario,
    required this.ubicacion,
    required this.descripcion,
    required this.rutaAudio,
    required this.estado,
    required this.fechaCreacion,
    required this.horaCreacion,
  });

  ReportsModel copyWith({
    int? idReporte,
    Usuario? usuario,
    Ubicacion? ubicacion,
    String? descripcion,
    String? rutaAudio,
    String? estado,
    DateTime? fechaCreacion,
    String? horaCreacion,
  }) => ReportsModel(
    idReporte: idReporte ?? this.idReporte,
    usuario: usuario ?? this.usuario,
    ubicacion: ubicacion ?? this.ubicacion,
    descripcion: descripcion ?? this.descripcion,
    rutaAudio: rutaAudio ?? this.rutaAudio,
    estado: estado ?? this.estado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    horaCreacion: horaCreacion ?? this.horaCreacion,
  );

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
    idReporte: json["idReporte"],
    usuario: Usuario.fromJson(json["usuario"]),
    ubicacion: Ubicacion.fromJson(json["ubicacion"]),
    descripcion: json["descripcion"] ?? "",
    rutaAudio: json["rutaAudio"] ?? "",
    estado: json["estado"],
    fechaCreacion: DateTime.parse(json["fechaCreacion"]),
    horaCreacion: json["horaCreacion"],
  );

  Map<String, dynamic> toJson() => {
    "idReporte": idReporte,
    "usuario": usuario.toJson(),
    "ubicacion": ubicacion.toJson(),
    "descripcion": descripcion,
    "rutaAudio": rutaAudio,
    "estado": estado,
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
  dynamic reportes;

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
    reportes: reportes ?? this.reportes,
  );

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
    idUbicacion: json["idUbicacion"],
    descripcion: json["descripcion"],
    sede: json["sede"],
    edificio: json["edificio"],
    lugar: json["lugar"],
    piso: json["piso"],
    rutaQr: json["rutaQr"],
    reportes: json["reportes"],
  );

  Map<String, dynamic> toJson() => {
    "idUbicacion": idUbicacion,
    "descripcion": descripcion,
    "sede": sede,
    "edificio": edificio,
    "lugar": lugar,
    "piso": piso,
    "rutaQr": rutaQr,
    "reportes": reportes,
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
