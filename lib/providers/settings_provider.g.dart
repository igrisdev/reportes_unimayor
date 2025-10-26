// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emergencyContactsListHash() =>
    r'887e85a01a29df4d650e8bff45c91f1386766e57';

/// See also [emergencyContactsList].
@ProviderFor(emergencyContactsList)
final emergencyContactsListProvider =
    AutoDisposeFutureProvider<List<EmergencyContact>>.internal(
      emergencyContactsList,
      name: r'emergencyContactsListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$emergencyContactsListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmergencyContactsListRef =
    AutoDisposeFutureProviderRef<List<EmergencyContact>>;
String _$emergencyContactByIdHash() =>
    r'232a55928a972832e87d594c1d2d3a5949c6af87';

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

/// See also [emergencyContactById].
@ProviderFor(emergencyContactById)
const emergencyContactByIdProvider = EmergencyContactByIdFamily();

/// See also [emergencyContactById].
class EmergencyContactByIdFamily extends Family<AsyncValue<EmergencyContact>> {
  /// See also [emergencyContactById].
  const EmergencyContactByIdFamily();

  /// See also [emergencyContactById].
  EmergencyContactByIdProvider call(String id) {
    return EmergencyContactByIdProvider(id);
  }

  @override
  EmergencyContactByIdProvider getProviderOverride(
    covariant EmergencyContactByIdProvider provider,
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
  String? get name => r'emergencyContactByIdProvider';
}

/// See also [emergencyContactById].
class EmergencyContactByIdProvider
    extends AutoDisposeFutureProvider<EmergencyContact> {
  /// See also [emergencyContactById].
  EmergencyContactByIdProvider(String id)
    : this._internal(
        (ref) => emergencyContactById(ref as EmergencyContactByIdRef, id),
        from: emergencyContactByIdProvider,
        name: r'emergencyContactByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$emergencyContactByIdHash,
        dependencies: EmergencyContactByIdFamily._dependencies,
        allTransitiveDependencies:
            EmergencyContactByIdFamily._allTransitiveDependencies,
        id: id,
      );

  EmergencyContactByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<EmergencyContact> Function(EmergencyContactByIdRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmergencyContactByIdProvider._internal(
        (ref) => create(ref as EmergencyContactByIdRef),
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
  AutoDisposeFutureProviderElement<EmergencyContact> createElement() {
    return _EmergencyContactByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmergencyContactByIdProvider && other.id == id;
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
mixin EmergencyContactByIdRef
    on AutoDisposeFutureProviderRef<EmergencyContact> {
  /// The parameter `id` of this provider.
  String get id;
}

class _EmergencyContactByIdProviderElement
    extends AutoDisposeFutureProviderElement<EmergencyContact>
    with EmergencyContactByIdRef {
  _EmergencyContactByIdProviderElement(super.provider);

  @override
  String get id => (origin as EmergencyContactByIdProvider).id;
}

String _$createEmergencyContactHash() =>
    r'2ef4b247f79f5388f1f1452a4216047cf7b9cd9e';

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

String _$updateEmergencyContactHash() =>
    r'48b0402a91c5f61d63bd8ef3e8fd50493370d50d';

/// See also [updateEmergencyContact].
@ProviderFor(updateEmergencyContact)
const updateEmergencyContactProvider = UpdateEmergencyContactFamily();

/// See also [updateEmergencyContact].
class UpdateEmergencyContactFamily extends Family<AsyncValue<bool>> {
  /// See also [updateEmergencyContact].
  const UpdateEmergencyContactFamily();

  /// See also [updateEmergencyContact].
  UpdateEmergencyContactProvider call(
    String id,
    String nombre,
    String relacion,
    String telefono,
    String? telefonoAlternativo,
    String? email,
    bool esPrincipal,
  ) {
    return UpdateEmergencyContactProvider(
      id,
      nombre,
      relacion,
      telefono,
      telefonoAlternativo,
      email,
      esPrincipal,
    );
  }

  @override
  UpdateEmergencyContactProvider getProviderOverride(
    covariant UpdateEmergencyContactProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'updateEmergencyContactProvider';
}

/// See also [updateEmergencyContact].
class UpdateEmergencyContactProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updateEmergencyContact].
  UpdateEmergencyContactProvider(
    String id,
    String nombre,
    String relacion,
    String telefono,
    String? telefonoAlternativo,
    String? email,
    bool esPrincipal,
  ) : this._internal(
        (ref) => updateEmergencyContact(
          ref as UpdateEmergencyContactRef,
          id,
          nombre,
          relacion,
          telefono,
          telefonoAlternativo,
          email,
          esPrincipal,
        ),
        from: updateEmergencyContactProvider,
        name: r'updateEmergencyContactProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateEmergencyContactHash,
        dependencies: UpdateEmergencyContactFamily._dependencies,
        allTransitiveDependencies:
            UpdateEmergencyContactFamily._allTransitiveDependencies,
        id: id,
        nombre: nombre,
        relacion: relacion,
        telefono: telefono,
        telefonoAlternativo: telefonoAlternativo,
        email: email,
        esPrincipal: esPrincipal,
      );

  UpdateEmergencyContactProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.nombre,
    required this.relacion,
    required this.telefono,
    required this.telefonoAlternativo,
    required this.email,
    required this.esPrincipal,
  }) : super.internal();

  final String id;
  final String nombre;
  final String relacion;
  final String telefono;
  final String? telefonoAlternativo;
  final String? email;
  final bool esPrincipal;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdateEmergencyContactRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateEmergencyContactProvider._internal(
        (ref) => create(ref as UpdateEmergencyContactRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
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
    return _UpdateEmergencyContactProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateEmergencyContactProvider &&
        other.id == id &&
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
    hash = _SystemHash.combine(hash, id.hashCode);
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
mixin UpdateEmergencyContactRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  String get id;

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

class _UpdateEmergencyContactProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with UpdateEmergencyContactRef {
  _UpdateEmergencyContactProviderElement(super.provider);

  @override
  String get id => (origin as UpdateEmergencyContactProvider).id;
  @override
  String get nombre => (origin as UpdateEmergencyContactProvider).nombre;
  @override
  String get relacion => (origin as UpdateEmergencyContactProvider).relacion;
  @override
  String get telefono => (origin as UpdateEmergencyContactProvider).telefono;
  @override
  String? get telefonoAlternativo =>
      (origin as UpdateEmergencyContactProvider).telefonoAlternativo;
  @override
  String? get email => (origin as UpdateEmergencyContactProvider).email;
  @override
  bool get esPrincipal =>
      (origin as UpdateEmergencyContactProvider).esPrincipal;
}

String _$deleteEmergencyContactHash() =>
    r'd9c79d258d7db08f0dfef0fb6a306781b63c6d3d';

/// See also [deleteEmergencyContact].
@ProviderFor(deleteEmergencyContact)
const deleteEmergencyContactProvider = DeleteEmergencyContactFamily();

/// See also [deleteEmergencyContact].
class DeleteEmergencyContactFamily extends Family<AsyncValue<bool>> {
  /// See also [deleteEmergencyContact].
  const DeleteEmergencyContactFamily();

  /// See also [deleteEmergencyContact].
  DeleteEmergencyContactProvider call(String id) {
    return DeleteEmergencyContactProvider(id);
  }

  @override
  DeleteEmergencyContactProvider getProviderOverride(
    covariant DeleteEmergencyContactProvider provider,
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
  String? get name => r'deleteEmergencyContactProvider';
}

/// See also [deleteEmergencyContact].
class DeleteEmergencyContactProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteEmergencyContact].
  DeleteEmergencyContactProvider(String id)
    : this._internal(
        (ref) => deleteEmergencyContact(ref as DeleteEmergencyContactRef, id),
        from: deleteEmergencyContactProvider,
        name: r'deleteEmergencyContactProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteEmergencyContactHash,
        dependencies: DeleteEmergencyContactFamily._dependencies,
        allTransitiveDependencies:
            DeleteEmergencyContactFamily._allTransitiveDependencies,
        id: id,
      );

  DeleteEmergencyContactProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteEmergencyContactRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteEmergencyContactProvider._internal(
        (ref) => create(ref as DeleteEmergencyContactRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteEmergencyContactProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteEmergencyContactProvider && other.id == id;
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
mixin DeleteEmergencyContactRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DeleteEmergencyContactProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with DeleteEmergencyContactRef {
  _DeleteEmergencyContactProviderElement(super.provider);

  @override
  String get id => (origin as DeleteEmergencyContactProvider).id;
}

String _$medicalConditionsListHash() =>
    r'7471fc09f4f0050a7c7aba7c0f97ec18430cf990';

/// See also [medicalConditionsList].
@ProviderFor(medicalConditionsList)
final medicalConditionsListProvider =
    AutoDisposeFutureProvider<List<MedicalCondition>>.internal(
      medicalConditionsList,
      name: r'medicalConditionsListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$medicalConditionsListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicalConditionsListRef =
    AutoDisposeFutureProviderRef<List<MedicalCondition>>;
String _$medicalConditionByIdHash() =>
    r'9718b9f984bf29bf2ce32e806eeb98835e73a741';

/// See also [medicalConditionById].
@ProviderFor(medicalConditionById)
const medicalConditionByIdProvider = MedicalConditionByIdFamily();

/// See also [medicalConditionById].
class MedicalConditionByIdFamily extends Family<AsyncValue<MedicalCondition>> {
  /// See also [medicalConditionById].
  const MedicalConditionByIdFamily();

  /// See also [medicalConditionById].
  MedicalConditionByIdProvider call(String id) {
    return MedicalConditionByIdProvider(id);
  }

  @override
  MedicalConditionByIdProvider getProviderOverride(
    covariant MedicalConditionByIdProvider provider,
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
  String? get name => r'medicalConditionByIdProvider';
}

/// See also [medicalConditionById].
class MedicalConditionByIdProvider
    extends AutoDisposeFutureProvider<MedicalCondition> {
  /// See also [medicalConditionById].
  MedicalConditionByIdProvider(String id)
    : this._internal(
        (ref) => medicalConditionById(ref as MedicalConditionByIdRef, id),
        from: medicalConditionByIdProvider,
        name: r'medicalConditionByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$medicalConditionByIdHash,
        dependencies: MedicalConditionByIdFamily._dependencies,
        allTransitiveDependencies:
            MedicalConditionByIdFamily._allTransitiveDependencies,
        id: id,
      );

  MedicalConditionByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<MedicalCondition> Function(MedicalConditionByIdRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicalConditionByIdProvider._internal(
        (ref) => create(ref as MedicalConditionByIdRef),
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
  AutoDisposeFutureProviderElement<MedicalCondition> createElement() {
    return _MedicalConditionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicalConditionByIdProvider && other.id == id;
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
mixin MedicalConditionByIdRef
    on AutoDisposeFutureProviderRef<MedicalCondition> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MedicalConditionByIdProviderElement
    extends AutoDisposeFutureProviderElement<MedicalCondition>
    with MedicalConditionByIdRef {
  _MedicalConditionByIdProviderElement(super.provider);

  @override
  String get id => (origin as MedicalConditionByIdProvider).id;
}

String _$createMedicalConditionHash() =>
    r'b20f0f3d6790c370e272f33c951e9e8ac4c1f2e8';

/// See also [createMedicalCondition].
@ProviderFor(createMedicalCondition)
const createMedicalConditionProvider = CreateMedicalConditionFamily();

/// See also [createMedicalCondition].
class CreateMedicalConditionFamily extends Family<AsyncValue<bool>> {
  /// See also [createMedicalCondition].
  const CreateMedicalConditionFamily();

  /// See also [createMedicalCondition].
  CreateMedicalConditionProvider call(
    String nombre,
    String descripcion,
    DateTime fechaDiagnostico,
  ) {
    return CreateMedicalConditionProvider(
      nombre,
      descripcion,
      fechaDiagnostico,
    );
  }

  @override
  CreateMedicalConditionProvider getProviderOverride(
    covariant CreateMedicalConditionProvider provider,
  ) {
    return call(
      provider.nombre,
      provider.descripcion,
      provider.fechaDiagnostico,
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
  String? get name => r'createMedicalConditionProvider';
}

/// See also [createMedicalCondition].
class CreateMedicalConditionProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [createMedicalCondition].
  CreateMedicalConditionProvider(
    String nombre,
    String descripcion,
    DateTime fechaDiagnostico,
  ) : this._internal(
        (ref) => createMedicalCondition(
          ref as CreateMedicalConditionRef,
          nombre,
          descripcion,
          fechaDiagnostico,
        ),
        from: createMedicalConditionProvider,
        name: r'createMedicalConditionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createMedicalConditionHash,
        dependencies: CreateMedicalConditionFamily._dependencies,
        allTransitiveDependencies:
            CreateMedicalConditionFamily._allTransitiveDependencies,
        nombre: nombre,
        descripcion: descripcion,
        fechaDiagnostico: fechaDiagnostico,
      );

  CreateMedicalConditionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nombre,
    required this.descripcion,
    required this.fechaDiagnostico,
  }) : super.internal();

  final String nombre;
  final String descripcion;
  final DateTime fechaDiagnostico;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CreateMedicalConditionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateMedicalConditionProvider._internal(
        (ref) => create(ref as CreateMedicalConditionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nombre: nombre,
        descripcion: descripcion,
        fechaDiagnostico: fechaDiagnostico,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CreateMedicalConditionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateMedicalConditionProvider &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.fechaDiagnostico == fechaDiagnostico;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nombre.hashCode);
    hash = _SystemHash.combine(hash, descripcion.hashCode);
    hash = _SystemHash.combine(hash, fechaDiagnostico.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateMedicalConditionRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `nombre` of this provider.
  String get nombre;

  /// The parameter `descripcion` of this provider.
  String get descripcion;

  /// The parameter `fechaDiagnostico` of this provider.
  DateTime get fechaDiagnostico;
}

class _CreateMedicalConditionProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CreateMedicalConditionRef {
  _CreateMedicalConditionProviderElement(super.provider);

  @override
  String get nombre => (origin as CreateMedicalConditionProvider).nombre;
  @override
  String get descripcion =>
      (origin as CreateMedicalConditionProvider).descripcion;
  @override
  DateTime get fechaDiagnostico =>
      (origin as CreateMedicalConditionProvider).fechaDiagnostico;
}

String _$updateMedicalConditionHash() =>
    r'3a16ecc131a2a96c9bd0a951bc66e3865e58f57a';

/// See also [updateMedicalCondition].
@ProviderFor(updateMedicalCondition)
const updateMedicalConditionProvider = UpdateMedicalConditionFamily();

/// See also [updateMedicalCondition].
class UpdateMedicalConditionFamily extends Family<AsyncValue<bool>> {
  /// See also [updateMedicalCondition].
  const UpdateMedicalConditionFamily();

  /// See also [updateMedicalCondition].
  UpdateMedicalConditionProvider call(
    String id,
    String nombre,
    String descripcion,
    DateTime fechaDiagnostico,
  ) {
    return UpdateMedicalConditionProvider(
      id,
      nombre,
      descripcion,
      fechaDiagnostico,
    );
  }

  @override
  UpdateMedicalConditionProvider getProviderOverride(
    covariant UpdateMedicalConditionProvider provider,
  ) {
    return call(
      provider.id,
      provider.nombre,
      provider.descripcion,
      provider.fechaDiagnostico,
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
  String? get name => r'updateMedicalConditionProvider';
}

/// See also [updateMedicalCondition].
class UpdateMedicalConditionProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [updateMedicalCondition].
  UpdateMedicalConditionProvider(
    String id,
    String nombre,
    String descripcion,
    DateTime fechaDiagnostico,
  ) : this._internal(
        (ref) => updateMedicalCondition(
          ref as UpdateMedicalConditionRef,
          id,
          nombre,
          descripcion,
          fechaDiagnostico,
        ),
        from: updateMedicalConditionProvider,
        name: r'updateMedicalConditionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateMedicalConditionHash,
        dependencies: UpdateMedicalConditionFamily._dependencies,
        allTransitiveDependencies:
            UpdateMedicalConditionFamily._allTransitiveDependencies,
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        fechaDiagnostico: fechaDiagnostico,
      );

  UpdateMedicalConditionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaDiagnostico,
  }) : super.internal();

  final String id;
  final String nombre;
  final String descripcion;
  final DateTime fechaDiagnostico;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdateMedicalConditionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateMedicalConditionProvider._internal(
        (ref) => create(ref as UpdateMedicalConditionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        fechaDiagnostico: fechaDiagnostico,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdateMedicalConditionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateMedicalConditionProvider &&
        other.id == id &&
        other.nombre == nombre &&
        other.descripcion == descripcion &&
        other.fechaDiagnostico == fechaDiagnostico;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, nombre.hashCode);
    hash = _SystemHash.combine(hash, descripcion.hashCode);
    hash = _SystemHash.combine(hash, fechaDiagnostico.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateMedicalConditionRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  String get id;

  /// The parameter `nombre` of this provider.
  String get nombre;

  /// The parameter `descripcion` of this provider.
  String get descripcion;

  /// The parameter `fechaDiagnostico` of this provider.
  DateTime get fechaDiagnostico;
}

class _UpdateMedicalConditionProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with UpdateMedicalConditionRef {
  _UpdateMedicalConditionProviderElement(super.provider);

  @override
  String get id => (origin as UpdateMedicalConditionProvider).id;
  @override
  String get nombre => (origin as UpdateMedicalConditionProvider).nombre;
  @override
  String get descripcion =>
      (origin as UpdateMedicalConditionProvider).descripcion;
  @override
  DateTime get fechaDiagnostico =>
      (origin as UpdateMedicalConditionProvider).fechaDiagnostico;
}

String _$deleteMedicalConditionHash() =>
    r'c9e622a11837b732051a84a47e788983df887ce9';

/// See also [deleteMedicalCondition].
@ProviderFor(deleteMedicalCondition)
const deleteMedicalConditionProvider = DeleteMedicalConditionFamily();

/// See also [deleteMedicalCondition].
class DeleteMedicalConditionFamily extends Family<AsyncValue<bool>> {
  /// See also [deleteMedicalCondition].
  const DeleteMedicalConditionFamily();

  /// See also [deleteMedicalCondition].
  DeleteMedicalConditionProvider call(String id) {
    return DeleteMedicalConditionProvider(id);
  }

  @override
  DeleteMedicalConditionProvider getProviderOverride(
    covariant DeleteMedicalConditionProvider provider,
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
  String? get name => r'deleteMedicalConditionProvider';
}

/// See also [deleteMedicalCondition].
class DeleteMedicalConditionProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [deleteMedicalCondition].
  DeleteMedicalConditionProvider(String id)
    : this._internal(
        (ref) => deleteMedicalCondition(ref as DeleteMedicalConditionRef, id),
        from: deleteMedicalConditionProvider,
        name: r'deleteMedicalConditionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deleteMedicalConditionHash,
        dependencies: DeleteMedicalConditionFamily._dependencies,
        allTransitiveDependencies:
            DeleteMedicalConditionFamily._allTransitiveDependencies,
        id: id,
      );

  DeleteMedicalConditionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<bool> Function(DeleteMedicalConditionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteMedicalConditionProvider._internal(
        (ref) => create(ref as DeleteMedicalConditionRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _DeleteMedicalConditionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteMedicalConditionProvider && other.id == id;
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
mixin DeleteMedicalConditionRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DeleteMedicalConditionProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with DeleteMedicalConditionRef {
  _DeleteMedicalConditionProviderElement(super.provider);

  @override
  String get id => (origin as DeleteMedicalConditionProvider).id;
}

String _$personalDataHash() => r'7dfa5c6eca94c609f751538c4bbf1b5af4f263d6';

/// GET /api/DatosPersonales/usuarios/datos-personales
///
/// Copied from [personalData].
@ProviderFor(personalData)
final personalDataProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      personalData,
      name: r'personalDataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$personalDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PersonalDataRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$updatePersonalDataHash() =>
    r'be724fbeaf49dc2f794d0f298a64a3eebae1029c';

/// PUT /api/DatosPersonales/usuarios/datos-personales
///
/// Copied from [updatePersonalData].
@ProviderFor(updatePersonalData)
const updatePersonalDataProvider = UpdatePersonalDataFamily();

/// PUT /api/DatosPersonales/usuarios/datos-personales
///
/// Copied from [updatePersonalData].
class UpdatePersonalDataFamily extends Family<AsyncValue<bool>> {
  /// PUT /api/DatosPersonales/usuarios/datos-personales
  ///
  /// Copied from [updatePersonalData].
  const UpdatePersonalDataFamily();

  /// PUT /api/DatosPersonales/usuarios/datos-personales
  ///
  /// Copied from [updatePersonalData].
  UpdatePersonalDataProvider call(
    String numeroTelefonico,
    String cedula,
    String codigoInstitucional,
  ) {
    return UpdatePersonalDataProvider(
      numeroTelefonico,
      cedula,
      codigoInstitucional,
    );
  }

  @override
  UpdatePersonalDataProvider getProviderOverride(
    covariant UpdatePersonalDataProvider provider,
  ) {
    return call(
      provider.numeroTelefonico,
      provider.cedula,
      provider.codigoInstitucional,
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
  String? get name => r'updatePersonalDataProvider';
}

/// PUT /api/DatosPersonales/usuarios/datos-personales
///
/// Copied from [updatePersonalData].
class UpdatePersonalDataProvider extends AutoDisposeFutureProvider<bool> {
  /// PUT /api/DatosPersonales/usuarios/datos-personales
  ///
  /// Copied from [updatePersonalData].
  UpdatePersonalDataProvider(
    String numeroTelefonico,
    String cedula,
    String codigoInstitucional,
  ) : this._internal(
        (ref) => updatePersonalData(
          ref as UpdatePersonalDataRef,
          numeroTelefonico,
          cedula,
          codigoInstitucional,
        ),
        from: updatePersonalDataProvider,
        name: r'updatePersonalDataProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updatePersonalDataHash,
        dependencies: UpdatePersonalDataFamily._dependencies,
        allTransitiveDependencies:
            UpdatePersonalDataFamily._allTransitiveDependencies,
        numeroTelefonico: numeroTelefonico,
        cedula: cedula,
        codigoInstitucional: codigoInstitucional,
      );

  UpdatePersonalDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.numeroTelefonico,
    required this.cedula,
    required this.codigoInstitucional,
  }) : super.internal();

  final String numeroTelefonico;
  final String cedula;
  final String codigoInstitucional;

  @override
  Override overrideWith(
    FutureOr<bool> Function(UpdatePersonalDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdatePersonalDataProvider._internal(
        (ref) => create(ref as UpdatePersonalDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        numeroTelefonico: numeroTelefonico,
        cedula: cedula,
        codigoInstitucional: codigoInstitucional,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _UpdatePersonalDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePersonalDataProvider &&
        other.numeroTelefonico == numeroTelefonico &&
        other.cedula == cedula &&
        other.codigoInstitucional == codigoInstitucional;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, numeroTelefonico.hashCode);
    hash = _SystemHash.combine(hash, cedula.hashCode);
    hash = _SystemHash.combine(hash, codigoInstitucional.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdatePersonalDataRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `numeroTelefonico` of this provider.
  String get numeroTelefonico;

  /// The parameter `cedula` of this provider.
  String get cedula;

  /// The parameter `codigoInstitucional` of this provider.
  String get codigoInstitucional;
}

class _UpdatePersonalDataProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with UpdatePersonalDataRef {
  _UpdatePersonalDataProviderElement(super.provider);

  @override
  String get numeroTelefonico =>
      (origin as UpdatePersonalDataProvider).numeroTelefonico;
  @override
  String get cedula => (origin as UpdatePersonalDataProvider).cedula;
  @override
  String get codigoInstitucional =>
      (origin as UpdatePersonalDataProvider).codigoInstitucional;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
