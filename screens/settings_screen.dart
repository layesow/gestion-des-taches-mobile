import 'package:flutter/material.dart';
import 'package:tache_app/services/api/auth_service.dart';
import 'package:tache_app/services/storage/token_storage.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'notifications_settings_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      
      body: SafeArea(
        child: Column(
          children: [
            
            // En-tête
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: const Row(
                children: [
                  Text(
                    'Plus',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  
                  // Notifications
                  _buildOption(
                    context,
                    Icons.notifications_outlined,
                    'Notifications',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsSettingsScreen(),
                        ),
                      );
                    },
                  ),

                  // Langue (pour l'instant juste un message)
                  _buildOption(
                    context,
                    Icons.language,
                    'Langue',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Français (par défaut)'),
                        ),
                      );
                    },
                  ),

                  // Thème sombre (pour l'instant juste un message)
                  _buildOption(
                    context,
                    Icons.dark_mode_outlined,
                    'Thème sombre',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité bientôt disponible'),
                        ),
                      );
                    },
                  ),

                  // À propos
                  _buildOption(
                    context,
                    Icons.info_outline,
                    'À propos',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),

            const Spacer(),

            // Bouton Déconnexion
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Afficher une confirmation
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Déconnexion'),
                        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Déconnexion',
                              style: TextStyle(color: AppColors.priorityHigh),
                            ),
                          ),
                        ],
                      ),
                    );

                    // Si l'utilisateur a confirmé
                    if (confirmed == true && context.mounted) {
                      try {
                        // Appel API pour logout (invalide le token côté serveur)
                        await AuthService().logout();
                      } catch (e) {
                        // Même si l'API échoue, on déconnecte quand même
                        print('Erreur logout API: $e');
                      }

                      // Supprimer le token local
                      await TokenStorage.deleteToken();

                      if (context.mounted) {
                        // Retour au LoginScreen (supprime toutes les pages précédentes)
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.priorityHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textDark),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textMedium,
      ),
      onTap: onTap,
    );
  }
}