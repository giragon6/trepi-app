import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _http;

  ApiClient({required this.baseUrl, http.Client? client})
    : _http = client ?? http.Client();

  Future<http.Response> get(String path) =>
    _http.get(Uri.parse('$baseUrl$path'));

  Future<http.Response> post(String path, Map<String, dynamic> body) =>
    _http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

  Future<http.Response> put(String path, Map<String, dynamic> body) =>
    _http.put(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

  Future<http.Response> delete(String path) =>
    _http.delete(Uri.parse('$baseUrl$path'));
  void close() {
    _http.close();
  }
}