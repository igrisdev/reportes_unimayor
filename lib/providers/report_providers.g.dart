// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportListHash() => r'3ad5a6a8b72753bb1b0d0db02a2fa3d2484f14e5';

/// See also [reportList].
@ProviderFor(reportList)
final reportListProvider =
    AutoDisposeFutureProvider<List<ReportsModel>>.internal(
      reportList,
      name: r'reportListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportListRef = AutoDisposeFutureProviderRef<List<ReportsModel>>;
String _$reportListBrigadierHash() =>
    r'6af45b0c9311a815c3c2a8c1787ae13b8a8fb42f';

/// See also [reportListBrigadier].
@ProviderFor(reportListBrigadier)
final reportListBrigadierProvider =
    AutoDisposeFutureProvider<List<ReportsModel>>.internal(
      reportListBrigadier,
      name: r'reportListBrigadierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportListBrigadierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportListBrigadierRef =
    AutoDisposeFutureProviderRef<List<ReportsModel>>;
String _$reportListHistoryBrigadierHash() =>
    r'8058d2804d28d117c60f1e9638849f514fde8403';

/// See also [reportListHistoryBrigadier].
@ProviderFor(reportListHistoryBrigadier)
final reportListHistoryBrigadierProvider =
    AutoDisposeFutureProvider<List<ReportsModel>>.internal(
      reportListHistoryBrigadier,
      name: r'reportListHistoryBrigadierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportListHistoryBrigadierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportListHistoryBrigadierRef =
    AutoDisposeFutureProviderRef<List<ReportsModel>>;
String _$reportListPendingHash() => r'b061340b1a231ce0a3dade3b8412d98fc727de4f';

/// See also [reportListPending].
@ProviderFor(reportListPending)
final reportListPendingProvider =
    AutoDisposeFutureProvider<List<ReportsModel>>.internal(
      reportListPending,
      name: r'reportListPendingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportListPendingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportListPendingRef = AutoDisposeFutureProviderRef<List<ReportsModel>>;
String _$getReportByIdHash() => r'f9a6ef5da251bee207256934e3110da35126568c';

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

/// See also [getReportById].
@ProviderFor(getReportById)
const getReportByIdProvider = GetReportByIdFamily();

/// See also [getReportById].
class GetReportByIdFamily extends Family<AsyncValue<ReportsModel>> {
  /// See also [getReportById].
  const GetReportByIdFamily();

  /// See also [getReportById].
  GetReportByIdProvider call(String id) {
    return GetReportByIdProvider(id);
  }

  @override
  GetReportByIdProvider getProviderOverride(
    covariant GetReportByIdProvider provider,
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
  String? get name => r'getReportByIdProvider';
}

/// See also [getReportById].
class GetReportByIdProvider extends AutoDisposeFutureProvider<ReportsModel> {
  /// See also [getReportById].
  GetReportByIdProvider(String id)
    : this._internal(
        (ref) => getReportById(ref as GetReportByIdRef, id),
        from: getReportByIdProvider,
        name: r'getReportByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getReportByIdHash,
        dependencies: GetReportByIdFamily._dependencies,
        allTransitiveDependencies:
            GetReportByIdFamily._allTransitiveDependencies,
        id: id,
      );

  GetReportByIdProvider._internal(
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
    FutureOr<ReportsModel> Function(GetReportByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetReportByIdProvider._internal(
        (ref) => create(ref as GetReportByIdRef),
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
  AutoDisposeFutureProviderElement<ReportsModel> createElement() {
    return _GetReportByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReportByIdProvider && other.id == id;
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
mixin GetReportByIdRef on AutoDisposeFutureProviderRef<ReportsModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GetReportByIdProviderElement
    extends AutoDisposeFutureProviderElement<ReportsModel>
    with GetReportByIdRef {
  _GetReportByIdProviderElement(super.provider);

  @override
  String get id => (origin as GetReportByIdProvider).id;
}

String _$getReportByIdBrigadierHash() =>
    r'2ac5e600aee41126a447a8c26f6e8bf1951d1902';

/// See also [getReportByIdBrigadier].
@ProviderFor(getReportByIdBrigadier)
const getReportByIdBrigadierProvider = GetReportByIdBrigadierFamily();

/// See also [getReportByIdBrigadier].
class GetReportByIdBrigadierFamily extends Family<AsyncValue<ReportsModel>> {
  /// See also [getReportByIdBrigadier].
  const GetReportByIdBrigadierFamily();

  /// See also [getReportByIdBrigadier].
  GetReportByIdBrigadierProvider call(String id) {
    return GetReportByIdBrigadierProvider(id);
  }

  @override
  GetReportByIdBrigadierProvider getProviderOverride(
    covariant GetReportByIdBrigadierProvider provider,
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
  String? get name => r'getReportByIdBrigadierProvider';
}

/// See also [getReportByIdBrigadier].
class GetReportByIdBrigadierProvider
    extends AutoDisposeFutureProvider<ReportsModel> {
  /// See also [getReportByIdBrigadier].
  GetReportByIdBrigadierProvider(String id)
    : this._internal(
        (ref) => getReportByIdBrigadier(ref as GetReportByIdBrigadierRef, id),
        from: getReportByIdBrigadierProvider,
        name: r'getReportByIdBrigadierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getReportByIdBrigadierHash,
        dependencies: GetReportByIdBrigadierFamily._dependencies,
        allTransitiveDependencies:
            GetReportByIdBrigadierFamily._allTransitiveDependencies,
        id: id,
      );

  GetReportByIdBrigadierProvider._internal(
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
    FutureOr<ReportsModel> Function(GetReportByIdBrigadierRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetReportByIdBrigadierProvider._internal(
        (ref) => create(ref as GetReportByIdBrigadierRef),
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
  AutoDisposeFutureProviderElement<ReportsModel> createElement() {
    return _GetReportByIdBrigadierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReportByIdBrigadierProvider && other.id == id;
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
mixin GetReportByIdBrigadierRef on AutoDisposeFutureProviderRef<ReportsModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GetReportByIdBrigadierProviderElement
    extends AutoDisposeFutureProviderElement<ReportsModel>
    with GetReportByIdBrigadierRef {
  _GetReportByIdBrigadierProviderElement(super.provider);

  @override
  String get id => (origin as GetReportByIdBrigadierProvider).id;
}

String _$createReportHash() => r'5d9aeb19cdefb9e03ed3cb5b1b153b0610400131';

/// See also [createReport].
@ProviderFor(createReport)
const createReportProvider = CreateReportFamily();

/// See also [createReport].
class CreateReportFamily extends Family<AsyncValue<bool>> {
  /// See also [createReport].
  const CreateReportFamily();

  /// See also [createReport].
  CreateReportProvider call(
    String idUbicacion,
    String? descripcion,
    String? record,
  ) {
    return CreateReportProvider(idUbicacion, descripcion, record);
  }

  @override
  CreateReportProvider getProviderOverride(
    covariant CreateReportProvider provider,
  ) {
    return call(provider.idUbicacion, provider.descripcion, provider.record);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createReportProvider';
}

/// See also [createReport].
class CreateReportProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [createReport].
  CreateReportProvider(String idUbicacion, String? descripcion, String? record)
    : this._internal(
        (ref) => createReport(
          ref as CreateReportRef,
          idUbicacion,
          descripcion,
          record,
        ),
        from: createReportProvider,
        name: r'createReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createReportHash,
        dependencies: CreateReportFamily._dependencies,
        allTransitiveDependencies:
            CreateReportFamily._allTransitiveDependencies,
        idUbicacion: idUbicacion,
        descripcion: descripcion,
        record: record,
      );

  CreateReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.idUbicacion,
    required this.descripcion,
    required this.record,
  }) : super.internal();

  final String idUbicacion;
  final String? descripcion;
  final String? record;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CreateReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateReportProvider._internal(
        (ref) => create(ref as CreateReportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        idUbicacion: idUbicacion,
        descripcion: descripcion,
        record: record,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CreateReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateReportProvider &&
        other.idUbicacion == idUbicacion &&
        other.descripcion == descripcion &&
        other.record == record;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, idUbicacion.hashCode);
    hash = _SystemHash.combine(hash, descripcion.hashCode);
    hash = _SystemHash.combine(hash, record.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateReportRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `idUbicacion` of this provider.
  String get idUbicacion;

  /// The parameter `descripcion` of this provider.
  String? get descripcion;

  /// The parameter `record` of this provider.
  String? get record;
}

class _CreateReportProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CreateReportRef {
  _CreateReportProviderElement(super.provider);

  @override
  String get idUbicacion => (origin as CreateReportProvider).idUbicacion;
  @override
  String? get descripcion => (origin as CreateReportProvider).descripcion;
  @override
  String? get record => (origin as CreateReportProvider).record;
}

String _$cancelReportHash() => r'8f7f576c3841a3b2196843fa0cb2ec9abe753038';

/// See also [cancelReport].
@ProviderFor(cancelReport)
const cancelReportProvider = CancelReportFamily();

/// See also [cancelReport].
class CancelReportFamily extends Family<AsyncValue<bool>> {
  /// See also [cancelReport].
  const CancelReportFamily();

  /// See also [cancelReport].
  CancelReportProvider call(int id) {
    return CancelReportProvider(id);
  }

  @override
  CancelReportProvider getProviderOverride(
    covariant CancelReportProvider provider,
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
  String? get name => r'cancelReportProvider';
}

/// See also [cancelReport].
class CancelReportProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [cancelReport].
  CancelReportProvider(int id)
    : this._internal(
        (ref) => cancelReport(ref as CancelReportRef, id),
        from: cancelReportProvider,
        name: r'cancelReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cancelReportHash,
        dependencies: CancelReportFamily._dependencies,
        allTransitiveDependencies:
            CancelReportFamily._allTransitiveDependencies,
        id: id,
      );

  CancelReportProvider._internal(
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
    FutureOr<bool> Function(CancelReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CancelReportProvider._internal(
        (ref) => create(ref as CancelReportRef),
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
    return _CancelReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CancelReportProvider && other.id == id;
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
mixin CancelReportRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  int get id;
}

class _CancelReportProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CancelReportRef {
  _CancelReportProviderElement(super.provider);

  @override
  int get id => (origin as CancelReportProvider).id;
}

String _$acceptReportHash() => r'61206a23f73c28fd6d474e87182ac327688e53a1';

/// See also [acceptReport].
@ProviderFor(acceptReport)
const acceptReportProvider = AcceptReportFamily();

/// See also [acceptReport].
class AcceptReportFamily extends Family<AsyncValue<bool>> {
  /// See also [acceptReport].
  const AcceptReportFamily();

  /// See also [acceptReport].
  AcceptReportProvider call(int id) {
    return AcceptReportProvider(id);
  }

  @override
  AcceptReportProvider getProviderOverride(
    covariant AcceptReportProvider provider,
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
  String? get name => r'acceptReportProvider';
}

/// See also [acceptReport].
class AcceptReportProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [acceptReport].
  AcceptReportProvider(int id)
    : this._internal(
        (ref) => acceptReport(ref as AcceptReportRef, id),
        from: acceptReportProvider,
        name: r'acceptReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$acceptReportHash,
        dependencies: AcceptReportFamily._dependencies,
        allTransitiveDependencies:
            AcceptReportFamily._allTransitiveDependencies,
        id: id,
      );

  AcceptReportProvider._internal(
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
    FutureOr<bool> Function(AcceptReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AcceptReportProvider._internal(
        (ref) => create(ref as AcceptReportRef),
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
    return _AcceptReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AcceptReportProvider && other.id == id;
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
mixin AcceptReportRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AcceptReportProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with AcceptReportRef {
  _AcceptReportProviderElement(super.provider);

  @override
  int get id => (origin as AcceptReportProvider).id;
}

String _$endReportHash() => r'9fff44374d4ef479e1cadd767d0400c6b6ebd58b';

/// See also [endReport].
@ProviderFor(endReport)
const endReportProvider = EndReportFamily();

/// See also [endReport].
class EndReportFamily extends Family<AsyncValue<bool>> {
  /// See also [endReport].
  const EndReportFamily();

  /// See also [endReport].
  EndReportProvider call(int id, String description) {
    return EndReportProvider(id, description);
  }

  @override
  EndReportProvider getProviderOverride(covariant EndReportProvider provider) {
    return call(provider.id, provider.description);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'endReportProvider';
}

/// See also [endReport].
class EndReportProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [endReport].
  EndReportProvider(int id, String description)
    : this._internal(
        (ref) => endReport(ref as EndReportRef, id, description),
        from: endReportProvider,
        name: r'endReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$endReportHash,
        dependencies: EndReportFamily._dependencies,
        allTransitiveDependencies: EndReportFamily._allTransitiveDependencies,
        id: id,
        description: description,
      );

  EndReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.description,
  }) : super.internal();

  final int id;
  final String description;

  @override
  Override overrideWith(FutureOr<bool> Function(EndReportRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: EndReportProvider._internal(
        (ref) => create(ref as EndReportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        description: description,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _EndReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EndReportProvider &&
        other.id == id &&
        other.description == description;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, description.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EndReportRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `description` of this provider.
  String get description;
}

class _EndReportProviderElement extends AutoDisposeFutureProviderElement<bool>
    with EndReportRef {
  _EndReportProviderElement(super.provider);

  @override
  int get id => (origin as EndReportProvider).id;
  @override
  String get description => (origin as EndReportProvider).description;
}

String _$getRecordHash() => r'244e92aae4a71ca2d5ff1021b91948a988cc08d3';

/// See also [getRecord].
@ProviderFor(getRecord)
const getRecordProvider = GetRecordFamily();

/// See also [getRecord].
class GetRecordFamily extends Family<AsyncValue<String>> {
  /// See also [getRecord].
  const GetRecordFamily();

  /// See also [getRecord].
  GetRecordProvider call(int idReport, String urlRecord) {
    return GetRecordProvider(idReport, urlRecord);
  }

  @override
  GetRecordProvider getProviderOverride(covariant GetRecordProvider provider) {
    return call(provider.idReport, provider.urlRecord);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getRecordProvider';
}

/// See also [getRecord].
class GetRecordProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getRecord].
  GetRecordProvider(int idReport, String urlRecord)
    : this._internal(
        (ref) => getRecord(ref as GetRecordRef, idReport, urlRecord),
        from: getRecordProvider,
        name: r'getRecordProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getRecordHash,
        dependencies: GetRecordFamily._dependencies,
        allTransitiveDependencies: GetRecordFamily._allTransitiveDependencies,
        idReport: idReport,
        urlRecord: urlRecord,
      );

  GetRecordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.idReport,
    required this.urlRecord,
  }) : super.internal();

  final int idReport;
  final String urlRecord;

  @override
  Override overrideWith(
    FutureOr<String> Function(GetRecordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetRecordProvider._internal(
        (ref) => create(ref as GetRecordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        idReport: idReport,
        urlRecord: urlRecord,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetRecordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRecordProvider &&
        other.idReport == idReport &&
        other.urlRecord == urlRecord;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, idReport.hashCode);
    hash = _SystemHash.combine(hash, urlRecord.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetRecordRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `idReport` of this provider.
  int get idReport;

  /// The parameter `urlRecord` of this provider.
  String get urlRecord;
}

class _GetRecordProviderElement extends AutoDisposeFutureProviderElement<String>
    with GetRecordRef {
  _GetRecordProviderElement(super.provider);

  @override
  int get idReport => (origin as GetRecordProvider).idReport;
  @override
  String get urlRecord => (origin as GetRecordProvider).urlRecord;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
