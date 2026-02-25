import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Titre
              const Text(
                'Statistiques',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 24),

              // Cartes de stats
              _buildStatCard(
                '24',
                'Tâches totales',
                Icons.task_alt,
                AppColors.primary,
              ),

              const SizedBox(height: 12),

              _buildStatCard(
                '18',
                'Terminées',
                Icons.check_circle,
                AppColors.priorityLow,
              ),

              const SizedBox(height: 12),

              _buildStatCard(
                '6',
                'En cours',
                Icons.pending,
                AppColors.priorityHigh,
              ),

              const SizedBox(height: 24),

              // Titre section
              const Text(
                'Par priorité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 16),

              // Priorités
              Row(
                children: [
                  Expanded(
                    child: _buildPriorityCard(
                      '8',
                      'Élevée',
                      AppColors.priorityHigh,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPriorityCard(
                      '10',
                      'Moyenne',
                      AppColors.priorityMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPriorityCard(
                      '6',
                      'Basse',
                      AppColors.priorityLow,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityCard(String number, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}