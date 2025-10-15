import '../models/ubicacion_model.dart';
import '../models/location_tree.dart';

List<Headquarters> buildLocationTree(List<Ubicacion> ubicaciones) {
  final Map<String, Map<String, List<Ubicacion>>> map = {};

  for (final u in ubicaciones) {
    final sedeKey = u.sede.trim();
    final edificioKey = u.edificio.trim();

    if (sedeKey.isEmpty) continue;

    map.putIfAbsent(sedeKey, () => {});
    final edificioMap = map[sedeKey]!;

    edificioMap.putIfAbsent(edificioKey, () => []);
    edificioMap[edificioKey]!.add(u);
  }

  final List<Headquarters> result = [];

  map.forEach((sede, edificiosMap) {
    final List<Building> buildings = [];
    edificiosMap.forEach((edificioNombre, ubicList) {
      final List<LocationEntry> entries =
          ubicList.map((u) => LocationEntry.fromUbicacion(u)).toList()
            ..sort((a, b) => a.lugar.compareTo(b.lugar));

      buildings.add(Building(nombre: edificioNombre, ubicaciones: entries));
    });

    buildings.sort((a, b) => a.nombre.compareTo(b.nombre));
    result.add(Headquarters(sede: sede, edificios: buildings));
  });

  result.sort((a, b) => a.sede.compareTo(b.sede));
  return result;
}
