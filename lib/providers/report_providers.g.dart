// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportListHash() => r'e5252d2fad63ad8633cb0016a4434a9701c96cdd';

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
String _$getReportByIdHash() => r'1e6bbb4b56558366476e2cb074a57c8d2ea5eb56';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
