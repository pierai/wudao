import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/services/data_export_service.dart';
import '../../data/services/data_import_service.dart';
import 'habit_provider.dart';

part 'data_transfer_provider.g.dart';

/// 数据导出服务 Provider
@riverpod
DataExportService dataExportService(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return DataExportService(repository);
}

/// 数据导入服务 Provider
@riverpod
DataImportService dataImportService(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  final exportService = ref.watch(dataExportServiceProvider);
  final database = ref.watch(databaseProvider);
  return DataImportService(repository, exportService, database);
}
