// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationsTreeHash() => r'5796b873eb31422be956f49e3de6c003d92eedba';

/// See also [locationsTree].
@ProviderFor(locationsTree)
final locationsTreeProvider =
    AutoDisposeFutureProvider<List<Headquarters>>.internal(
      locationsTree,
      name: r'locationsTreeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$locationsTreeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationsTreeRef = AutoDisposeFutureProviderRef<List<Headquarters>>;
String _$locationByIdHash() => r'96e19721cc50d47590c3bdf214b2e7da63bde901';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [locationById].
@ProviderFor(locationById)
const locationByIdProvider = LocationByIdFamily();

/// See also [locationById].
class LocationByIdFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [locationById].
  const LocationByIdFamily();

  /// See also [locationById].
  LocationByIdProvider call(int id) {
    return LocationByIdProvider(id);
  }

  @override
  LocationByIdProvider getProviderOverride(
    covariant LocationByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'locationByIdProvider';
}

/// See also [locationById].
class LocationByIdProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [locationById].
  LocationByIdProvider(int id)
    : this._internal(
        (ref) => locationById(ref as LocationByIdRef, id),
        from: locationByIdProvider,
        name: r'locationByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$locationByIdHash,
        dependencies: LocationByIdFamily._dependencies,
        allTransitiveDependencies:
            LocationByIdFamily._allTransitiveDependencies,
        id: id,
      );

  LocationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(LocationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocationByIdProvider._internal(
        (ref) => create(ref as LocationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _LocationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LocationByIdRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _LocationByIdProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with LocationByIdRef {
  _LocationByIdProviderElement(super.provider);

  @override
  int get id => (origin as LocationByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
