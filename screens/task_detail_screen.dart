import 'package:flutter/material.dart';
import 'package:tache_app/screens/edit_task_screen.dart';
import '../services/api/task_service.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';

// ================================
// CHANGÉ : StatefulWidget au lieu de StatelessWidget
// Pour pouvoir mettre à jour le statut de la tâche en temps réel
// ================================
class TaskDetailScreen extends StatefulWidget {
  // On reçoit la tâche à afficher
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  
  // ================================
  // Variable pour suivre l'état actuel de la tâche
  // Peut changer quand on toggle le statut
  // ================================
  late Task currentTask;
  
  @override
  void initState() {
    super.initState();
    // Copie initiale de la tâche reçue
    currentTask = widget.task;
  }

  // ================================
  // FONCTION : Obtenir la couleur selon la priorité
  // ================================
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

  // ================================
  // FONCTION : Obtenir le texte de priorité
  // ================================
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
                  builder: (context) => EditTaskScreen(task: currentTask),
                ),
              ).then((_) {
                // Après modification, retour à la liste
                Navigator.pop(context, true);
              });
            },
          ),

          // Bouton supprimer
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.priorityHigh,
            ),
            onPressed: () {
              // Afficher une boîte de dialogue de confirmation
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Supprimer la tâche'),
                  content: const Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
                  actions: [
                    // Bouton Annuler
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext); // Ferme le dialog
                      },
                      child: const Text('Annuler'),
                    ),
                    // Bouton Supprimer
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext); // Ferme le dialog

                        try {
                          // Appel API pour supprimer la tâche
                          await TaskService().deleteTask(currentTask.id);

                          if (mounted) {
                            // Retour à la liste avec indicateur de succès
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          // Gestion des erreurs
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString().replaceAll('Exception: ', '')),
                                backgroundColor: AppColors.priorityHigh,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Supprimer',
                        style: TextStyle(color: AppColors.priorityHigh),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      // ================================
      // CONTENU PRINCIPAL
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
                  color: _getPriorityColor(currentTask.priority),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getPriorityText(currentTask.priority),
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
            // TITRE DE LA TÂCHE
            // ================================
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                currentTask.title,
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
                  // Icône d'horloge
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

                  // Date limite
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
                        currentTask.getFormattedDate(),
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
                    currentTask.description,
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
            // STATUT DE LA TÂCHE
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

                  // Badge du statut (Terminée / En cours)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: currentTask.isCompleted
                          ? AppColors.priorityLow.withOpacity(0.2)
                          : AppColors.priorityHigh.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentTask.isCompleted ? 'Terminée' : 'En cours',
                      style: TextStyle(
                        color: currentTask.isCompleted
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
      // BOUTON EN BAS DE L'ÉCRAN
      // Pour marquer la tâche comme terminée ou non terminée
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
            onPressed: () async {
              try {
                // Appel API pour toggle le statut
                await TaskService().toggleTaskComplete(currentTask.id);
                
                // ✅ Met à jour l'état local immédiatement
                setState(() {
                  currentTask = Task(
                    id: currentTask.id,
                    title: currentTask.title,
                    description: currentTask.description,
                    dateTime: currentTask.dateTime,
                    priority: currentTask.priority,
                    isCompleted: !currentTask.isCompleted,  // Inverse le statut
                  );
                });
                
                // Afficher un message de confirmation
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        currentTask.isCompleted 
                          ? 'Tâche marquée comme terminée'
                          : 'Tâche marquée comme non terminée',
                      ),
                      backgroundColor: AppColors.priorityLow,
                    ),
                  );
                }
              } catch (e) {
                // Gestion des erreurs
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: AppColors.priorityHigh,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              // Couleur selon le statut
              backgroundColor: currentTask.isCompleted
                  ? AppColors.textMedium
                  : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              // Texte selon le statut
              currentTask.isCompleted
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