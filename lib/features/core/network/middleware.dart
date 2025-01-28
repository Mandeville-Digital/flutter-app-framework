import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

abstract class Middleware {
  Future<ApiRequest> processRequest(ApiRequest request);
  Future<ApiResponse> processResponse(ApiResponse response);
}

class AuthMiddleware implements Middleware {
  final SharedPreferences _preferences;
  static const _tokenKey = 'auth_token';

  AuthMiddleware(this._preferences);

  @override
  Future<ApiRequest> processRequest(ApiRequest request) async {
    final token = _preferences.getString(_tokenKey);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }

  @override
  Future<ApiResponse> processResponse(ApiResponse response) async {
    // Handle token expiration or other auth-related responses
    if (response.statusCode == 401) {
      await _preferences.remove(_tokenKey);
    }
    return response;
  }
} 