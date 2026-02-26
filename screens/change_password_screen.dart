import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final TextEditingController _currentPasswordController = 
      TextEditingController();
  final TextEditingController _newPasswordController = 
      TextEditingController();
  final TextEditingController _confirmPasswordController = 
      TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  void _changePassword() {
    // Validation
    if (_currentPasswordController.text.isEmpty) {
      _showError('Le mot de passe actuel est obligatoire');
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      _showError('Le nouveau mot de passe est obligatoire');
      return;
    }

    if (_newPasswordController.text.length < 8) {
      _showError('Le mot de passe doit contenir au moins 8 caractères');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showError('Les mots de passe ne correspondent pas');
      return;
    }

    if (_currentPasswordController.text == _newPasswordController.text) {
      _showError('Le nouveau mot de passe doit être différent de l\'ancien');
      return;
    }

    // Plus tard on enverra à l'API Laravel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mot de passe modifié avec succès !'),
        backgroundColor: AppColors.priorityLow,
      ),
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.priorityHigh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

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
          'Changer le mot de passe',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            // Illustration
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Titre
            const Text(
              'Modifier votre mot de passe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            const Text(
              'Assurez-vous que votre nouveau mot de passe est sécurisé',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),

            const SizedBox(height: 32),

            // Mot de passe actuel
            const Text(
              'Mot de passe actuel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _currentPasswordController,
              obscureText: !_currentPasswordVisible,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textMedium,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _currentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _currentPasswordVisible = !_currentPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nouveau mot de passe
            const Text(
              'Nouveau mot de passe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _newPasswordController,
              obscureText: !_newPasswordVisible,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textMedium,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _newPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _newPasswordVisible = !_newPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Confirmer mot de passe
            const Text(
              'Confirmer le nouveau mot de passe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _confirmPasswordController,
              obscureText: !_confirmPasswordVisible,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textMedium,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Indication de sécurité
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Critères de sécurité',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Au moins 8 caractères\n'
                    '• Différent de l\'ancien mot de passe\n'
                    '• Combinaison de lettres et chiffres recommandée',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Enregistrer',
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

          ],
        ),
      ),
    );
  }
}