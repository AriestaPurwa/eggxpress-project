import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://your-api-base-url.com/api';
  static const Duration _timeoutDuration = Duration(seconds: 30);
  
  // Headers default untuk semua request
  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers dengan authorization token
  Map<String, String> _authHeaders(String token) => {
    ..._defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // GET Request
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? queryParameters,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final finalUri = queryParameters != null 
          ? uri.replace(queryParameters: queryParameters)
          : uri;

      final headers = token != null ? _authHeaders(token) : _defaultHeaders;

      final response = await http
          .get(finalUri, headers: headers)
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Map<String, dynamic>> post({
    required String endpoint,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = token != null ? _authHeaders(token) : _defaultHeaders;

      final response = await http
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Map<String, dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = token != null ? _authHeaders(token) : _defaultHeaders;

      final response = await http
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE Request
  Future<Map<String, dynamic>> delete({
    required String endpoint,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = token != null ? _authHeaders(token) : _defaultHeaders;

      final response = await http
          .delete(uri, headers: headers)
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Upload file dengan multipart
  Future<Map<String, dynamic>> uploadFile({
    required String endpoint,
    required File file,
    required String fieldName,
    Map<String, String>? additionalFields,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send().timeout(_timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      // Success response
      if (response.body.isEmpty) {
        return {'success': true, 'message': 'Request successful'};
      }
      
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {'success': true, 'data': response.body};
      }
    } else {
      // Error response
      String errorMessage;
      
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['message'] ?? 
                      errorBody['error'] ?? 
                      'Request failed with status: $statusCode';
      } catch (e) {
        errorMessage = 'Request failed with status: $statusCode';
      }

      throw ApiException(
        statusCode: statusCode,
        message: errorMessage,
      );
    }
  }

  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    } else if (error is SocketException) {
      return ApiException(
        statusCode: 0,
        message: 'No internet connection',
      );
    } else if (error.toString().contains('TimeoutException')) {
      return ApiException(
        statusCode: 0,
        message: 'Request timeout',
      );
    } else {
      return ApiException(
        statusCode: 0,
        message: 'An unexpected error occurred: ${error.toString()}',
      );
    }
  }
}

// Custom Exception class untuk API errors
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

// Singleton instance
final apiService = ApiService();

// Usage Examples:
/*
// GET request
try {
  final response = await apiService.get(
    endpoint: '/users',
    queryParameters: {'page': '1', 'limit': '10'},
    token: 'your_auth_token',
  );
  print(response);
} catch (e) {
  print('Error: $e');
}

// POST request
try {
  final response = await apiService.post(
    endpoint: '/users',
    body: {
      'name': 'John Doe',
      'email': 'john@example.com',
    },
    token: 'your_auth_token',
  );
  print(response);
} catch (e) {
  print('Error: $e');
}

// File upload
try {
  final file = File('/path/to/your/file.jpg');
  final response = await apiService.uploadFile(
    endpoint: '/upload',
    file: file,
    fieldName: 'image',
    additionalFields: {'description': 'Profile picture'},
    token: 'your_auth_token',
  );
  print(response);
} catch (e) {
  print('Error: $e');
}
*/