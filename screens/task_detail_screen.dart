import 'package:flutter/material.dart';
import 'package:tache_app/screens/edit_task_screen.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  // On reçoit la tâche à afficher
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  // Fonction pour obtenir la couleur
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return AppColors.priorityLow;
    }
  }

  // Fonction pour obtenir le texte de priorité
  String _getPriorityText(String priority) {
    switch (priority) {
      case 'high':
        return 'Priorité Élevée';
      case 'medium':
        return 'Priorité Moyenne';
      case 'low':
        return 'Priorité Basse';
      default:
        return 'Priorité Basse';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ================================
      // BARRE DU HAUT
      // ================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        
        // Bouton retour
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
          ),
          onPressed: () {
            // Revenir en arrière
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Détails de la tâche',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // Bouton modifier
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(task: task),
                ),
              );
            },
          ),

          // Bouton supprimer
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.priorityHigh,
            ),
            onPressed: () {
              // Supprimer la tâche
              // On fera ça plus tard !
            },
          ),
        ],
      ),

      // ================================
      // CONTENU
      // ================================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================================
            // BADGE PRIORITÉ
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getPriorityText(task.priority),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ================================
            // TITRE
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================================
            // DATE ET HEURE
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date limite',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.getFormattedDate(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================================
            // DESCRIPTION
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textMedium,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ================================
            // STATUT
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Statut',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? AppColors.priorityLow.withOpacity(0.2)
                          : AppColors.priorityHigh.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.isCompleted ? 'Terminée' : 'En cours',
                      style: TextStyle(
                        color: task.isCompleted
                            ? AppColors.priorityLow
                            : AppColors.priorityHigh,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),

      // ================================
      // BOUTON EN BAS
      // ================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Marquer comme terminée
              // On fera ça plus tard !
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: task.isCompleted
                  ? AppColors.textMedium
                  : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              task.isCompleted
                  ? 'Marquer comme non terminée'
                  : 'Marquer comme terminée',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}