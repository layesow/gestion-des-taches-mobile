import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class EmailSentScreen extends StatelessWidget {
  final String email;

  const EmailSentScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.textDark,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Icône de succès
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.priorityLow.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: AppColors.priorityLow,
              ),
            ),

            const SizedBox(height: 32),

            // Titre
            const Text(
              'Email envoyé !',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Nous avons envoyé un lien de réinitialisation à votre adresse email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 32),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Veuillez vérifier votre boîte de réception.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Bouton retour
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Retour à la connexion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Renvoyer l'email
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email renvoyé !'),
                    backgroundColor: AppColors.priorityLow,
                  ),
                );
              },
              child: const Text(
                'Renvoyer l\'email',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}