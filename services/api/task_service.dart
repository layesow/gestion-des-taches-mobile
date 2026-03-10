import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

/// Service de gestion des tâches
/// Gère : CRUD complet des tâches
class TaskService {
  final ApiClient _client = ApiClient();

  /// Récupérer toutes les tâches de l'utilisateur
  Future<List<dynamic>> getTasks() async {
    try {
      final headers = await _client.headersWithAuth;
      final response = await http.get(
        Uri.parse('${ApiClient.baseUrl}/tasks'),
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

      if (response.statusCode != 200) {
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
        return data;
      } else {
        throw Exception('Erreur lors de la mise à jour du statut');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}