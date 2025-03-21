import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 

  static Future<AuthResponse> login(AuthRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<String> getRoleFromToken(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['role'];
  }

  static Future<void> registerUser(dynamic userObject) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userObject.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Registration failed');
    }
  }
} 
