import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'À propos',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 32),

            // Logo de l'app
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.task_alt,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Nom de l'app
            const Text(
              'Tache App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 4),

            // Slogan
            const Text(
              'Productivité Simplifiée',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),

            const SizedBox(height: 8),

            // Version
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Informations
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'À PROPOS DE L\'APPLICATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 1,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    'Tache App est une application de gestion de tâches moderne et intuitive qui vous aide à organiser votre quotidien avec simplicité et efficacité.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textDark,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'FONCTIONNALITÉS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 1,
                    ),
                  ),

                  SizedBox(height: 12),

                  _FeatureItem(
                    icon: Icons.check_circle,
                    text: 'Gestion intuitive des tâches',
                  ),
                  _FeatureItem(
                    icon: Icons.priority_high,
                    text: 'Système de priorités',
                  ),
                  _FeatureItem(
                    icon: Icons.bar_chart,
                    text: 'Statistiques détaillées',
                  ),
                  _FeatureItem(
                    icon: Icons.notifications,
                    text: 'Rappels intelligents',
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),

            // Développé par
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [

                  Text(
                    'DÉVELOPPÉ PAR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 1,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Laye SOW',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    'Développeur Mobile Flutter',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),

            // Liens
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Conditions d\'utilisation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMedium,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité bientôt disponible'),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Politique de confidentialité',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMedium,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité bientôt disponible'),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 32),

            // Copyright
            const Text(
              '© 2026 Tache App. Tous droits réservés.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
              ),
            ),

            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}

// Widget pour les features
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.priorityLow,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}