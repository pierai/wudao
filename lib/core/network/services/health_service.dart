import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_client.dart';
import '../models/health_response.dart';
import '../../constants/api_constants.dart';

/// 健康检查服务
class HealthService {
  final ApiClient _apiClient;

  HealthService(this._apiClient);

  /// 检查服务器健康状态
  Future<HealthResponse> checkHealth() async {
    final response = await _apiClient.get(ApiConstants.healthEndpoint);
    return HealthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

/// 健康检查服务 Provider
final healthServiceProvider = Provider<HealthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HealthService(apiClient);
});

/// 健康检查状态 Provider
final healthCheckProvider = FutureProvider<HealthResponse>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  return await healthService.checkHealth();
});
