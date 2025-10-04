// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createEmergencyContactHash() =>
    r'7c648cafec4654deec2a206e25ddc5e77a29a3d1';

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

/// See also [createEmergencyContact].
@ProviderFor(createEmergencyContact)
const createEmergencyContactProvider = CreateEmergencyContactFamily();

/// See also [createEmergencyContact].
class CreateEmergencyContactFamily extends Family<AsyncValue<bool>> {
  /// See also [createEmergencyContact].
  const CreateEmergencyContactFamily();

  /// See also [createEmergencyContact].
  CreateEmergencyContactProvider call(
    String nombre,
    String relacion,
    String telefono,
    String? telefonoAlternativo,
    String? email,
    bool esPrincipal,
  ) {
    return CreateEmergencyContactProvider(
      nombre,
      relacion,
      telefono,
      telefonoAlternativo,
      email,
      esPrincipal,
    );
  }

  @override
  CreateEmergencyContactProvider getProviderOverride(
    covariant CreateEmergencyContactProvider provider,
  ) {
    return call(
      provider.nombre,
      provider.relacion,
      provider.telefono,
      provider.telefonoAlternativo,
      provider.email,
      provider.esPrincipal,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createEmergencyContactProvider';
}

/// See also [createEmergencyContact].
class CreateEmergencyContactProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [createEmergencyContact].
  CreateEmergencyContactProvider(
    String nombre,
    String relacion,
    String telefono,
    String? telefonoAlternativo,
    String? email,
    bool esPrincipal,
  ) : this._internal(
        (ref) => createEmergencyContact(
          ref as CreateEmergencyContactRef,
          nombre,
          relacion,
          telefono,
          telefonoAlternativo,
          email,
          esPrincipal,
        ),
        from: createEmergencyContactProvider,
        name: r'createEmergencyContactProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createEmergencyContactHash,
        dependencies: CreateEmergencyContactFamily._dependencies,
        allTransitiveDependencies:
            CreateEmergencyContactFamily._allTransitiveDependencies,
        nombre: nombre,
        relacion: relacion,
        telefono: telefono,
        telefonoAlternativo: telefonoAlternativo,
        email: email,
        esPrincipal: esPrincipal,
      );

  CreateEmergencyContactProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nombre,
    required this.relacion,
    required this.telefono,
    required this.telefonoAlternativo,
    required this.email,
    required this.esPrincipal,
  }) : super.internal();

  final String nombre;
  final String relacion;
  final String telefono;
  final String? telefonoAlternativo;
  final String? email;
  final bool esPrincipal;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CreateEmergencyContactRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateEmergencyContactProvider._internal(
        (ref) => create(ref as CreateEmergencyContactRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nombre: nombre,
        relacion: relacion,
        telefono: telefono,
        telefonoAlternativo: telefonoAlternativo,
        email: email,
        esPrincipal: esPrincipal,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CreateEmergencyContactProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateEmergencyContactProvider &&
        other.nombre == nombre &&
        other.relacion == relacion &&
        other.telefono == telefono &&
        other.telefonoAlternativo == telefonoAlternativo &&
        other.email == email &&
        other.esPrincipal == esPrincipal;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nombre.hashCode);
    hash = _SystemHash.combine(hash, relacion.hashCode);
    hash = _SystemHash.combine(hash, telefono.hashCode);
    hash = _SystemHash.combine(hash, telefonoAlternativo.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, esPrincipal.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateEmergencyContactRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `nombre` of this provider.
  String get nombre;

  /// The parameter `relacion` of this provider.
  String get relacion;

  /// The parameter `telefono` of this provider.
  String get telefono;

  /// The parameter `telefonoAlternativo` of this provider.
  String? get telefonoAlternativo;

  /// The parameter `email` of this provider.
  String? get email;

  /// The parameter `esPrincipal` of this provider.
  bool get esPrincipal;
}

class _CreateEmergencyContactProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CreateEmergencyContactRef {
  _CreateEmergencyContactProviderElement(super.provider);

  @override
  String get nombre => (origin as CreateEmergencyContactProvider).nombre;
  @override
  String get relacion => (origin as CreateEmergencyContactProvider).relacion;
  @override
  String get telefono => (origin as CreateEmergencyContactProvider).telefono;
  @override
  String? get telefonoAlternativo =>
      (origin as CreateEmergencyContactProvider).telefonoAlternativo;
  @override
  String? get email => (origin as CreateEmergencyContactProvider).email;
  @override
  bool get esPrincipal =>
      (origin as CreateEmergencyContactProvider).esPrincipal;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
