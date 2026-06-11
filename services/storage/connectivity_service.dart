import 'dart:io';

// ================================
// SERVICE : Vérification de la connectivité
// Vérifie si l'appareil est connecté à internet
// ================================
class ConnectivityService {

  // ================================
  // Vérifier si internet est disponible
  // ================================
  static Future<bool> isConnected() async {
    try {
      // Essaie de se connecter à Google
      final result = await InternetAddress.lookup('google.com');
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('✅ Internet disponible');
        return true;
      }
      
      print('📵 Pas de connexion internet');
      return false;
    } on SocketException catch (_) {
      print('📵 Pas de connexion internet (SocketException)');
      return false;
    }
  }
}