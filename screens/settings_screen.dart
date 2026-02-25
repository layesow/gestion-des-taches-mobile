import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

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
                  
                  _buildOption(
                    context,
                    Icons.notifications_outlined,
                    'Notifications',
                    () {},
                  ),

                  _buildOption(
                    context,
                    Icons.language,
                    'Langue',
                    () {},
                  ),

                  _buildOption(
                    context,
                    Icons.dark_mode_outlined,
                    'Thème sombre',
                    () {},
                  ),

                  _buildOption(
                    context,
                    Icons.info_outline,
                    'À propos',
                    () {},
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
                  onPressed: () {
                    // Déconnexion
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.priorityHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Déconnexion',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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