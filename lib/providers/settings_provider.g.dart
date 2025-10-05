// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiSettingsServiceHash() =>
    r'c9ced3389e6b378b06345350249390860b4704b3';

/// See also [apiSettingsService].
@ProviderFor(apiSettingsService)
final apiSettingsServiceProvider =
    AutoDisposeProvider<ApiSettingsService>.internal(
      apiSettingsService,
      name: r'apiSettingsServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$apiSettingsServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiSettingsServiceRef = AutoDisposeProviderRef<ApiSettingsService>;
String _$emergencyContactsListHash() =>
    r'cabf3624e37b3835aee8059fc589b188269c60be';

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
    r'425b4fbddb367ee295c69c65a6432832d6fd8250';

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
    r'94d58061334055b5ffd10ed4ab7d5068735c6eca';

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

String _$medicalConditionsListHash() =>
    r'f0e728648dc1fb8eaeddb3f5e5cc62719bed1b96';

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
    r'c17b05dc7d8978e0cdd81cc666ea434b5635c1f7';

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
    r'5157d147f3404ee55c86261552a7e82f17330dc0';

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

String _$updateEmergencyContactHash() =>
    r'46e8e682663e72529cb3bbe799a712b38db1c71f';

/// See also [UpdateEmergencyContact].
@ProviderFor(UpdateEmergencyContact)
final updateEmergencyContactProvider =
    AutoDisposeAsyncNotifierProvider<UpdateEmergencyContact, void>.internal(
      UpdateEmergencyContact.new,
      name: r'updateEmergencyContactProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateEmergencyContactHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UpdateEmergencyContact = AutoDisposeAsyncNotifier<void>;
String _$deleteEmergencyContactHash() =>
    r'28b54ac202934968badef88d24018b48a44abc8a';

/// See also [DeleteEmergencyContact].
@ProviderFor(DeleteEmergencyContact)
final deleteEmergencyContactProvider =
    AutoDisposeAsyncNotifierProvider<DeleteEmergencyContact, void>.internal(
      DeleteEmergencyContact.new,
      name: r'deleteEmergencyContactProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteEmergencyContactHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeleteEmergencyContact = AutoDisposeAsyncNotifier<void>;
String _$updateMedicalConditionHash() =>
    r'a916428612ff2b1048dd62606b6948096742b55a';

/// See also [UpdateMedicalCondition].
@ProviderFor(UpdateMedicalCondition)
final updateMedicalConditionProvider =
    AutoDisposeAsyncNotifierProvider<UpdateMedicalCondition, void>.internal(
      UpdateMedicalCondition.new,
      name: r'updateMedicalConditionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateMedicalConditionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UpdateMedicalCondition = AutoDisposeAsyncNotifier<void>;
String _$deleteMedicalConditionHash() =>
    r'aae2585c50a9a929ad9c6dd85980f8f49f0e841e';

/// See also [DeleteMedicalCondition].
@ProviderFor(DeleteMedicalCondition)
final deleteMedicalConditionProvider =
    AutoDisposeAsyncNotifierProvider<DeleteMedicalCondition, void>.internal(
      DeleteMedicalCondition.new,
      name: r'deleteMedicalConditionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteMedicalConditionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeleteMedicalCondition = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
