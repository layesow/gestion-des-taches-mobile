import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/api/auth_service.dart';  // ← AJOUTÉ
import 'change_password_screen.dart';

class EditProfileScreen extends StatefulWidget {
  // ================================
  // Reçoit les données actuelles
  // ================================
  final String currentName;
  final String currentEmail;
  final String currentPhone;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  // ================================
  // Service API et état de chargement
  // ================================
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // ================================
  // Controllers pré-remplis avec les valeurs actuelles
  // ================================
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Pré-remplir avec les données reçues
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ================================
  // Fonction pour obtenir les initiales
  // ================================
  String _getInitials() {
    if (widget.currentName.isEmpty) return '?';
    
    final parts = widget.currentName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return widget.currentName[0].toUpperCase();
  }

  // ================================
  // Sauvegarder le profil
  // ================================
  Future<void> _saveProfile() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le nom est obligatoire'),
          backgroundColor: AppColors.priorityHigh,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('L\'email est obligatoire'),
          backgroundColor: AppColors.priorityHigh,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Appel API pour mettre à jour le profil
      await _authService.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        // Message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès !'),
            backgroundColor: AppColors.priorityLow,
          ),
        );

        // Retour en arrière (le profil se rechargera)
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.priorityHigh,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ================================
  // Changer la photo (fonctionnalité future)
  // ================================
  void _changePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité bientôt disponible'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      // ================================
      // BARRE DU HAUT
      // ================================
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
          'Modifier le profil',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================================
            // EN-TÊTE AVEC PHOTO
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  
                  // Photo de profil
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          _getInitials(),  // ← Initiales dynamiques
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _changePhoto,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Texte d'aide
                  const Text(
                    'Touchez l\'icône pour changer la photo',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================================
            // FORMULAIRE
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    'INFORMATIONS PERSONNELLES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nom complet
                  const Text(
                    'Nom complet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Votre nom',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.textMedium,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Votre email',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textMedium,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Téléphone
                  const Text(
                    'Téléphone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Votre téléphone',
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: AppColors.textMedium,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================================
            // SECTION SÉCURITÉ
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    'SÉCURITÉ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMedium,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Changer mot de passe
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                    ),
                    title: const Text(
                      'Changer le mot de passe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textMedium,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 32),

            // ================================
            // BOUTONS
            // ================================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  // Bouton Enregistrer
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Enregistrer les modifications',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bouton Annuler
                  SizedBox(
                    width: double.infinity,
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

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}