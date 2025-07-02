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
  Ubicacion ubicacion;
  String descripcion;
  String estado;
  DateTime fechaCreacion;
  String horaCreacion;

  ReportsModel({
    required this.idReporte,
    required this.ubicacion,
    required this.descripcion,
    required this.estado,
    required this.fechaCreacion,
    required this.horaCreacion,
  });

  ReportsModel copyWith({
    int? idReporte,
    Ubicacion? ubicacion,
    String? descripcion,
    String? estado,
    DateTime? fechaCreacion,
    String? horaCreacion,
  }) => ReportsModel(
    idReporte: idReporte ?? this.idReporte,
    ubicacion: ubicacion ?? this.ubicacion,
    descripcion: descripcion ?? this.descripcion,
    estado: estado ?? this.estado,
    fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    horaCreacion: horaCreacion ?? this.horaCreacion,
  );

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
    idReporte: json["idReporte"],
    ubicacion: Ubicacion.fromJson(json["ubicacion"]),
    descripcion: json["descripcion"],
    estado: json["estado"],
    fechaCreacion: DateTime.parse(json["fechaCreacion"]),
    horaCreacion: json["horaCreacion"],
  );

  Map<String, dynamic> toJson() => {
    "idReporte": idReporte,
    "ubicacion": ubicacion.toJson(),
    "descripcion": descripcion,
    "estado": estado,
    "fechaCreacion":
        "${fechaCreacion.year.toString().padLeft(4, '0')}-${fechaCreacion.month.toString().padLeft(2, '0')}-${fechaCreacion.day.toString().padLeft(2, '0')}",
    "horaCreacion": horaCreacion,
  };
}

class Ubicacion {
  int idUbicacion;
  String nombre;
  String descripcion;
  String sede;
  String edificio;
  String salon;
  String informacionAdicional;
  dynamic reportes;

  Ubicacion({
    required this.idUbicacion,
    required this.nombre,
    required this.descripcion,
    required this.sede,
    required this.edificio,
    required this.salon,
    required this.informacionAdicional,
    required this.reportes,
  });

  Ubicacion copyWith({
    int? idUbicacion,
    String? nombre,
    String? descripcion,
    String? sede,
    String? edificio,
    String? salon,
    String? informacionAdicional,
    dynamic reportes,
  }) => Ubicacion(
    idUbicacion: idUbicacion ?? this.idUbicacion,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    sede: sede ?? this.sede,
    edificio: edificio ?? this.edificio,
    salon: salon ?? this.salon,
    informacionAdicional: informacionAdicional ?? this.informacionAdicional,
    reportes: reportes ?? this.reportes,
  );

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
    idUbicacion: json["idUbicacion"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    sede: json["sede"],
    edificio: json["edificio"],
    salon: json["salon"],
    informacionAdicional: json["informacionAdicional"],
    reportes: json["reportes"],
  );

  Map<String, dynamic> toJson() => {
    "idUbicacion": idUbicacion,
    "nombre": nombre,
    "descripcion": descripcion,
    "sede": sede,
    "edificio": edificio,
    "salon": salon,
    "informacionAdicional": informacionAdicional,
    "reportes": reportes,
  };
}
