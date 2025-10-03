import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_client.dart';
import '../../constants/api_constants.dart';

/// 简单健康检查服务（不使用 freezed）
class SimpleHealthService {
  final ApiClient _apiClient;

  SimpleHealthService(this._apiClient);

  /// 检查服务器健康状态
  Future<Map<String, dynamic>> checkHealth() async {
    final response = await _apiClient.get(ApiConstants.healthEndpoint);
    return response.data as Map<String, dynamic>;
  }
}

/// 简单健康检查服务 Provider
final simpleHealthServiceProvider = Provider<SimpleHealthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SimpleHealthService(apiClient);
});

/// 简单健康检查状态 Provider
final simpleHealthCheckProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final healthService = ref.watch(simpleHealthServiceProvider);
  return await healthService.checkHealth();
});
