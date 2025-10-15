import 'ubicacion_model.dart';

class LocationEntry {
  final int idUbicacion;
  final String descripcion;
  final String lugar;
  final String piso;

  LocationEntry({
    required this.idUbicacion,
    required this.descripcion,
    required this.lugar,
    required this.piso,
  });

  factory LocationEntry.fromUbicacion(Ubicacion u) {
    return LocationEntry(
      idUbicacion: u.idUbicacion,
      descripcion: u.descripcion,
      lugar: u.lugar,
      piso: u.piso,
    );
  }
}

class Building {
  final String nombre;
  final List<LocationEntry> ubicaciones;

  Building({required this.nombre, required this.ubicaciones});
}

class Headquarters {
  final String sede;
  final List<Building> edificios;

  Headquarters({required this.sede, required this.edificios});
}
