import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../storage/token_storage.dart';
import '../storage/cache_service.dart';  // ← AJOUTÉ

/// Service d'authentification
/// Gère : inscription, connexion, déconnexion, profil + Cache local
class AuthService {
  final ApiClient _client = ApiClient();

  /// Inscription d'un nouvel utilisateur
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/register'),
        headers: _client.headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // ✅ Sauvegarder le token
        await TokenStorage.saveToken(data['token']);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Connexion d'un utilisateur
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/login'),
        headers: _client.headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Sauvegarder le token
        await TokenStorage.saveToken(data['token']);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Identifiants incorrects');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    try {
      final headers = await _client.headersWithAuth;
      await http.post(
        Uri.parse('${ApiClient.baseUrl}/logout'),
        headers: headers,
      );
    } catch (e) {
      print('⚠️ Erreur logout API : $e');
    } finally {
      // ✅ Toujours supprimer le token ET vider le cache
      await TokenStorage.deleteToken();
      await CacheService.clearAll();  // ← AJOUTÉ
      print('🗑️ Token et cache vidés');
    }
  }

  /// Récupérer le profil de l'utilisateur connecté
  /// 1. Essaie depuis l'API
  /// 2. Si pas internet → Charge depuis le cache
  Future<Map<String, dynamic>> getUser() async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.get(
        Uri.parse('${ApiClient.baseUrl}/user'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Sauvegarder le profil dans le cache
        await CacheService.saveUser(data['user']);
        print('✅ Profil récupéré et mis en cache');
        return data;
      } else {
        throw Exception('Erreur lors de la récupération du profil');
      }
    } on SocketException {
      // ✅ Pas de connexion → Charger depuis le cache
      print('📵 Pas de connexion → Profil depuis le cache');
      
      final cachedUser = CacheService.getUser();
      if (cachedUser != null) {
        // Retourner dans le même format que l'API
        return {'user': cachedUser};
      } else {
        throw Exception('Pas de connexion et aucun profil en cache');
      }
    } catch (e) {
      // ✅ Autre erreur → Essayer le cache
      print('❌ Erreur API → Tentative depuis le cache : $e');
      
      final cachedUser = CacheService.getUser();
      if (cachedUser != null) {
        return {'user': cachedUser};
      }
      
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Mettre à jour le profil
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.put(
        Uri.parse('${ApiClient.baseUrl}/profile'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Mettre à jour le cache du profil
        await CacheService.saveUser({
          'name': name,
          'email': email,
          'phone': phone,
        });
        print('✅ Profil mis à jour et cache rafraîchi');
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Changer le mot de passe
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/change-password'),
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
}