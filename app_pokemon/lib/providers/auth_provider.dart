import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  bool _isAuthenticated = false;
  int? _userId;

  bool get isAuthenticated => _isAuthenticated;
  int? get userId => _userId;

  // Registrar Usuario
  Future<String?> register(String email, String password) async {
    int result = await _db.registerUser(email, password);

    if (result == -1) {
      return "Este e-mail já está cadastrado!";
    }
    
    return null; 
  }

  // Fazer Login
  Future<bool> login(String email, String password) async {
    var user = await _db.loginUser(email, password);

    if (user != null) {
      _isAuthenticated = true;
      _userId = user['id'];
      
      notifyListeners();
      return true;
    } else {
      _isAuthenticated = false;
      return false;
    }
  }

  // logout
  void logout() {
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}