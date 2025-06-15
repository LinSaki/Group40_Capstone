import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/session.dart';

class SessionService {
  final String baseUrl = 'http://10.0.2.2:8080/api'; 

  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  Future<List<Session>> fetchMySessions(String role, String token) async {
    final url = Uri.parse('$baseUrl/$role/my-sessions');
    final response = await http.get(url, headers: _headers(token));
    
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Session.fromJson(json)).toList();
    } else {
      print('Error fetching sessions: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to fetch sessions');
    }
  }

  Future<void> createSession(String role, Map<String, dynamic> payload, String token) async {
    final url = Uri.parse('$baseUrl/$role/book-session');
    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      print('Error creating session: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to create session: ${response.body}');
    }
  }

  Future<void> updateSession(String role, int sessionId, Map<String, dynamic> payload, String token) async {
    final url = Uri.parse('$baseUrl/$role/edit-session/$sessionId');
    final response = await http.put(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      print('Error updating session: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to update session: ${response.body}');
    }
  }

  Future<void> deleteSession(String role, int sessionId, String token) async {
    final url = Uri.parse('$baseUrl/$role/cancel-session/$sessionId');
    final response = await http.delete(url, headers: _headers(token));

    if (response.statusCode != 200) {
      print('Error deleting session: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to delete session: ${response.body}');
    }
  }
}
