import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/api_service.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;
  String? _email;

  String? get token => _token;
  String? get role => _role;
  String? get email => _email;

  Future<void> login(String email, String password) async {
    AuthRequest request = AuthRequest(email: email, password: password);
    AuthResponse response = await ApiService.login(request);

    _token = response.token;

    final decoded = JwtDecoder.decode(_token!);
    _role = decoded['role']; 
    _email = decoded['sub']; 

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', _token!);

    notifyListeners();
  }

  void logout() async {
    _token = null;
    _role = null;
    _email = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    notifyListeners();
  }
}
