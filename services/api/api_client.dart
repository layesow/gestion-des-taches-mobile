import '../storage/token_storage.dart';

/// Client API de base avec configuration commune
class ApiClient {
  /// URL de base de l'API
  /// 10.0.2.2 = localhost pour émulateur Android
  /// Pour téléphone physique, utilise l'IP de ton Mac (192.168.x.x) et assure-toi que le serveur backend est accessible depuis le réseau local
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  //static const String baseUrl = 'http://192.168.1.26:8000/api';

  /// Headers par défaut (sans authentification)
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers avec token d'authentification
  Future<Map<String, String>> get headersWithAuth async {
    final token = await TokenStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}