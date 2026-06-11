import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

// ================================
// SERVICE : Cache local avec Hive
// Sauvegarde les tâches et le profil localement
// ================================
class CacheService {

  // ================================
  // BOÎTES HIVE (comme des tables MySQL)
  // ================================
  static Box get _tasksBox => Hive.box('tasks');
  static Box get _userBox => Hive.box('user');

  // ================================
  // TÂCHES : Sauvegarder
  // ================================
  static Future<void> saveTasks(List<dynamic> tasks) async {
    // Convertir la liste en JSON et sauvegarder
    await _tasksBox.put('tasks_list', jsonEncode(tasks));
    // Sauvegarder la date de dernière mise à jour
    await _tasksBox.put('last_updated', DateTime.now().toIso8601String());
    print('✅ Cache : ${tasks.length} tâches sauvegardées');
  }

  // ================================
  // TÂCHES : Récupérer
  // ================================
  static List<dynamic> getTasks() {
    // Lire les tâches depuis le cache
    final String? tasksJson = _tasksBox.get('tasks_list');
    
    if (tasksJson == null) {
      print('📭 Cache : Aucune tâche en cache');
      return [];
    }
    
    print('📦 Cache : Tâches récupérées depuis le cache');
    return jsonDecode(tasksJson);
  }

  // ================================
  // TÂCHES : Vérifier si le cache existe
  // ================================
  static bool hasTasks() {
    return _tasksBox.containsKey('tasks_list');
  }

  // ================================
  // TÂCHES : Vider le cache
  // ================================
  static Future<void> clearTasks() async {
    await _tasksBox.delete('tasks_list');
    await _tasksBox.delete('last_updated');
    print('🗑️ Cache : Tâches supprimées du cache');
  }

  // ================================
  // UTILISATEUR : Sauvegarder le profil
  // ================================
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _userBox.put('user_data', jsonEncode(user));
    print('✅ Cache : Profil sauvegardé');
  }

  // ================================
  // UTILISATEUR : Récupérer le profil
  // ================================
  static Map<String, dynamic>? getUser() {
    final String? userJson = _userBox.get('user_data');
    
    if (userJson == null) {
      print('📭 Cache : Aucun profil en cache');
      return null;
    }
    
    print('📦 Cache : Profil récupéré depuis le cache');
    return jsonDecode(userJson);
  }

  // ================================
  // UTILISATEUR : Vider le profil
  // ================================
  static Future<void> clearUser() async {
    await _userBox.delete('user_data');
    print('🗑️ Cache : Profil supprimé du cache');
  }

  // ================================
  // TOUT VIDER (lors de la déconnexion)
  // ================================
  static Future<void> clearAll() async {
    await clearTasks();
    await clearUser();
    print('🗑️ Cache : Tout vidé');
  }

  // ================================
  // VÉRIFIER LA CONNEXION INTERNET
  // ================================
  static String? getLastUpdated() {
    return _tasksBox.get('last_updated');
  }
}