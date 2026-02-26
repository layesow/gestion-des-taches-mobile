import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // URL de base de ton API Laravel
  // ⚠️ IMPORTANT : Sur Android, utilise 10.0.2.2 au lieu de 127.0.0.1
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Headers par défaut
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers avec token
  Future<Map<String, String>> get _headersWithToken async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Sauvegarder le token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Récupérer le token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Supprimer le token
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ================================
  // AUTHENTIFICATION
  // ================================

  // Inscription
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Sauvegarder le token
        await saveToken(data['token']);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Connexion
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Sauvegarder le token
        await saveToken(data['token']);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Identifiants incorrects');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      final headers = await _headersWithToken;
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: headers,
      );
      await deleteToken();
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion : $e');
    }
  }

  // Récupérer l'utilisateur connecté
  Future<Map<String, dynamic>> getUser() async {
    try {
      final headers = await _headersWithToken;
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception('Erreur lors de la récupération du profil');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Mettre à jour le profil
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final headers = await _headersWithToken;
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Changer le mot de passe
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final headers = await _headersWithToken;
      final response = await http.post(
        Uri.parse('$baseUrl/change-password'),
        headers: headers,
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors du changement');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // ================================
  // TÂCHES
  // ================================

  // Liste des tâches
  Future<List<dynamic>> getTasks() async {
    try {
      final headers = await _headersWithToken;
      final response = await http.get(
        Uri.parse('$baseUrl/tasks'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['tasks'];
      } else {
        throw Exception('Erreur lors de la récupération des tâches');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Créer une tâche
  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    required DateTime dateTime,
    required String priority,
  }) async {
    try {
      final headers = await _headersWithToken;
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'description': description,
          'date_time': dateTime.toIso8601String(),
          'priority': priority,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la création');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Mettre à jour une tâche
  Future<Map<String, dynamic>> updateTask({
    required String id,
    required String title,
    required String description,
    required DateTime dateTime,
    required String priority,
  }) async {
    try {
      final headers = await _headersWithToken;
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'description': description,
          'date_time': dateTime.toIso8601String(),
          'priority': priority,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Supprimer une tâche
  Future<void> deleteTask(String id) async {
    try {
      final headers = await _headersWithToken;
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Marquer comme complétée/non complétée
  Future<Map<String, dynamic>> toggleTaskComplete(String id) async {
    try {
      final headers = await _headersWithToken;
      final response = await http.post(
        Uri.parse('$baseUrl/tasks/$id/toggle'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception('Erreur lors de la mise à jour du statut');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}