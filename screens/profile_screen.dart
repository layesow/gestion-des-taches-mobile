import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/api/auth_service.dart';  // ← AJOUTÉ
import 'edit_profile_screen.dart';

// ================================
// CHANGÉ : StatefulWidget pour charger les données
// ================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  // ================================
  // Variables pour stocker les infos utilisateur
  // ================================
  final AuthService _authService = AuthService();
  
  bool _isLoading = true;
  String? _errorMessage;
  
  String _name = '';
  String _email = '';
  String _phone = '';
  
  // ================================
  // Charger les infos au démarrage
  // ================================
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  // ================================
  // Fonction pour charger les données utilisateur
  // ================================
Future<void> _loadUserData() async {
  print('🔵 Début chargement profil...');
  
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });
  
  try {
    // Appel API pour récupérer les infos
    final userData = await _authService.getUser();
    
    //print('✅ Données reçues : $userData');
    
    // ✅ CORRECTION : Les données sont dans userData['user']
    final user = userData['user'];
    
    setState(() {
      _name = user['name'] ?? '';
      _email = user['email'] ?? '';
      _phone = user['phone'] ?? '';
      _isLoading = false;
    });
    
    //print('📋 Nom: $_name');
    //print('📋 Email: $_email');
    //print('📋 Phone: $_phone');
  } catch (e) {
    //print('❌ Erreur : $e');
    setState(() {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
    });
  }
}
  
  // ================================
  // Fonction pour obtenir les initiales
  // ================================
  String _getInitials() {
    if (_name.isEmpty) return '?';
    
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.priorityHigh,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            'Réessayer',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
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
                              
                              // Photo de profil (avec initiales)
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
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Nom (depuis l'API)
                              Text(
                                _name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // Email (depuis l'API)
                              Text(
                                _email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textMedium,
                                ),
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ================================
                        // INFORMATIONS PERSONNELLES
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

                              const SizedBox(height: 16),

                              // Nom (depuis l'API)
                              _buildInfoItem(
                                Icons.person_outline,
                                'Nom complet',
                                _name,
                              ),

                              // Email (depuis l'API)
                              _buildInfoItem(
                                Icons.email_outlined,
                                'Email',
                                _email,
                              ),

                              // Téléphone (depuis l'API)
                              _buildInfoItem(
                                Icons.phone_outlined,
                                'Téléphone',
                                _phone.isNotEmpty ? _phone : 'Non renseigné',
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ================================
                        // BOUTON MODIFIER
                        // ================================
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(  // ← Passe les données
                                      currentName: _name,
                                      currentEmail: _email,
                                      currentPhone: _phone,
                                    ),
                                  ),
                                ).then((updated) {
                                  // Recharger si modification effectuée
                                  if (updated == true) {
                                    _loadUserData();
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Modifier le profil',
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
      ),
    );
  }

  // ================================
  // Widget pour afficher une info
  // ================================
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textMedium,
            size: 20,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}