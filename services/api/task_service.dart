import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../storage/cache_service.dart';  // ← AJOUTÉ

/// Service de gestion des tâches
/// Gère : CRUD complet des tâches + Cache local Hive
class TaskService {
  final ApiClient _client = ApiClient();

  /// Récupérer toutes les tâches de l'utilisateur
  /// 1. Essaie depuis l'API (internet)
  /// 2. Si pas internet → Charge depuis le cache local
  Future<List<dynamic>> getTasks() async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.get(
        Uri.parse('${ApiClient.baseUrl}/tasks'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Succès : Sauvegarder dans le cache
        await CacheService.saveTasks(data['tasks']);
        return data['tasks'];
      } else {
        throw Exception('Erreur lors de la récupération des tâches');
      }
    } on SocketException {
      // ✅ Pas de connexion internet → Charger depuis le cache
      print('📵 Pas de connexion internet → Chargement depuis le cache');
      
      if (CacheService.hasTasks()) {
        return CacheService.getTasks();
      } else {
        throw Exception('Pas de connexion internet et aucune donnée en cache');
      }
    } catch (e) {
      // ✅ Autre erreur → Essayer le cache
      print('❌ Erreur API → Tentative depuis le cache : $e');
      
      if (CacheService.hasTasks()) {
        return CacheService.getTasks();
      }
      
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Créer une nouvelle tâche
  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    required DateTime dateTime,
    required String priority,
  }) async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/tasks'),
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
        // ✅ Mettre à jour le cache après création
        final updatedTasks = await _refreshCache();
        print('✅ Tâche créée et cache mis à jour');
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la création');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Mettre à jour une tâche
  Future<Map<String, dynamic>> updateTask({
    required String id,
    required String title,
    required String description,
    required DateTime dateTime,
    required String priority,
  }) async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.put(
        Uri.parse('${ApiClient.baseUrl}/tasks/$id'),
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
        // ✅ Mettre à jour le cache après modification
        await _refreshCache();
        print('✅ Tâche modifiée et cache mis à jour');
        return data;
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Supprimer une tâche
  Future<void> deleteTask(String id) async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.delete(
        Uri.parse('${ApiClient.baseUrl}/tasks/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // ✅ Mettre à jour le cache après suppression
        await _refreshCache();
        print('✅ Tâche supprimée et cache mis à jour');
      } else {
        throw Exception('Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  /// Basculer le statut complété/non complété
  Future<Map<String, dynamic>> toggleTaskComplete(String id) async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/tasks/$id/toggle'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Mettre à jour le cache après toggle
        await _refreshCache();
        print('✅ Statut modifié et cache mis à jour');
        return data;
      } else {
        throw Exception('Erreur lors de la mise à jour du statut');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // ================================
  // FONCTION PRIVÉE : Rafraîchir le cache
  // Récupère les tâches depuis l'API et met à jour le cache
  // ================================
  Future<List<dynamic>> _refreshCache() async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.get(
        Uri.parse('${ApiClient.baseUrl}/tasks'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await CacheService.saveTasks(data['tasks']);
        return data['tasks'];
      }
    } catch (e) {
      print('⚠️ Impossible de rafraîchir le cache : $e');
    }
    return [];
  }
}