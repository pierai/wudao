import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_response.freezed.dart';
part 'health_response.g.dart';

/// 健康检查响应模型
@freezed
sealed class HealthResponse with _$HealthResponse {
  const factory HealthResponse({
    required String status,
    required String timestamp,
    required String service,
    required String version,
  }) = _HealthResponse;

  factory HealthResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthResponseFromJson(json);
}
