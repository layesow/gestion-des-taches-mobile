import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              // En-tête avec photo
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    
                    // Photo de profil
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            'LS',
                            style: TextStyle(
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

                    // Nom
                    const Text(
                      'Laye SOW',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Email
                    const Text(
                      'layesow@gmail.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMedium,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Informations
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

                    _buildInfoItem(
                      Icons.person_outline,
                      'Nom complet',
                      'Laye SOW',
                    ),

                    _buildInfoItem(
                      Icons.email_outlined,
                      'Email',
                      'layesow@gmail.com',
                    ),

                    _buildInfoItem(
                      Icons.phone_outlined,
                      'Téléphone',
                      '+221 77 000 00 00',
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bouton Modifier
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
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