// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 数据导出服务 Provider

@ProviderFor(dataExportService)
const dataExportServiceProvider = DataExportServiceProvider._();

/// 数据导出服务 Provider

final class DataExportServiceProvider
    extends
        $FunctionalProvider<
          DataExportService,
          DataExportService,
          DataExportService
        >
    with $Provider<DataExportService> {
  /// 数据导出服务 Provider
  const DataExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataExportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataExportServiceHash();

  @$internal
  @override
  $ProviderElement<DataExportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DataExportService create(Ref ref) {
    return dataExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataExportService>(value),
    );
  }
}

String _$dataExportServiceHash() => r'139905b2914fd2555cdfc1404051498c82e0fd20';

/// 数据导入服务 Provider

@ProviderFor(dataImportService)
const dataImportServiceProvider = DataImportServiceProvider._();

/// 数据导入服务 Provider

final class DataImportServiceProvider
    extends
        $FunctionalProvider<
          DataImportService,
          DataImportService,
          DataImportService
        >
    with $Provider<DataImportService> {
  /// 数据导入服务 Provider
  const DataImportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataImportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataImportServiceHash();

  @$internal
  @override
  $ProviderElement<DataImportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DataImportService create(Ref ref) {
    return dataImportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataImportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataImportService>(value),
    );
  }
}

String _$dataImportServiceHash() => r'005b7481cba10e7f49ac96a4004bad879bfca3aa';
