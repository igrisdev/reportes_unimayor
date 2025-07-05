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
  String descripcion;
  String sede;
  String edificio;
  String salon;
  String piso;
  dynamic informacionAdicional;
  dynamic rutaQr;
  dynamic reportes;

  Ubicacion({
    required this.idUbicacion,
    required this.descripcion,
    required this.sede,
    required this.edificio,
    required this.salon,
    required this.piso,
    required this.informacionAdicional,
    required this.rutaQr,
    required this.reportes,
  });

  Ubicacion copyWith({
    int? idUbicacion,
    String? descripcion,
    String? sede,
    String? edificio,
    String? salon,
    String? piso,
    dynamic informacionAdicional,
    dynamic rutaQr,
    dynamic reportes,
  }) => Ubicacion(
    idUbicacion: idUbicacion ?? this.idUbicacion,
    descripcion: descripcion ?? this.descripcion,
    sede: sede ?? this.sede,
    edificio: edificio ?? this.edificio,
    salon: salon ?? this.salon,
    piso: piso ?? this.piso,
    informacionAdicional: informacionAdicional ?? this.informacionAdicional,
    rutaQr: rutaQr ?? this.rutaQr,
    reportes: reportes ?? this.reportes,
  );

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
    idUbicacion: json["idUbicacion"],
    descripcion: json["descripcion"],
    sede: json["sede"],
    edificio: json["edificio"],
    salon: json["salon"],
    piso: json["piso"],
    informacionAdicional: json["informacionAdicional"],
    rutaQr: json["rutaQr"],
    reportes: json["reportes"],
  );

  Map<String, dynamic> toJson() => {
    "idUbicacion": idUbicacion,
    "descripcion": descripcion,
    "sede": sede,
    "edificio": edificio,
    "salon": salon,
    "piso": piso,
    "informacionAdicional": informacionAdicional,
    "rutaQr": rutaQr,
    "reportes": reportes,
  };
}
