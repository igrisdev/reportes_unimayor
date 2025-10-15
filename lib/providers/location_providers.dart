import 'package:reportes_unimayor/models/location_tree.dart';
import 'package:reportes_unimayor/services/api_locations_service.dart';
import 'package:reportes_unimayor/utils/parse_location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_providers.g.dart';

@riverpod
Future<List<Headquarters>> locationsTree(LocationsTreeRef ref) async {
  final api = ApiLocationsService();
  final list = await api.getUbicaciones();
  final tree = buildLocationTree(list);

  return tree;
}

@riverpod
Future<Map<String, dynamic>> locationById(LocationByIdRef ref, int id) async {
  try {
    final api = ApiLocationsService();
    final map = await api.getUbicacionById(id);
    return map;
  } catch (e) {
    rethrow;
  }
}
