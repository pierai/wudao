/// API 相关常量
class ApiConstants {
  ApiConstants._();

  // Base URL - 根据环境切换
  static const String baseUrl = 'http://192.168.2.95:8080';

  // API 版本
  static const String apiVersion = 'v1';

  // API 路径前缀
  static const String apiPrefix = '/api/$apiVersion';

  // 超时配置（毫秒）
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 15000;

  // 端点
  static const String healthEndpoint = '/health';
  static const String goalsEndpoint = '$apiPrefix/goals';
  static const String habitsEndpoint = '$apiPrefix/habits';
  static const String reflectionsEndpoint = '$apiPrefix/reflections';
  static const String knowledgeEndpoint = '$apiPrefix/knowledge';
}
