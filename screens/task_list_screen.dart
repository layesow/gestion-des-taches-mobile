import 'package:flutter/material.dart';
import 'package:tache_app/screens/add_task_screen.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';
import 'task_detail_screen.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  // ================================
  // DONNÉES DE TEST
  // Plus tard on récupérera ça de l'API Laravel
  // ================================
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Présentation Client K-Tech',
      description: 'Finaliser les slides de la démo',
      dateTime: DateTime.now().add(const Duration(hours: 3)),
      priority: 'high',
    ),
    Task(
      id: '2',
      title: 'Revue d\'équipe',
      description: 'Briefing hebdomadaire sur le sprint',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      priority: 'medium',
    ),
    Task(
      id: '3',
      title: 'Mise à jour CRM',
      description: 'Mettre à jour les contacts clients',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      priority: 'low',
      isCompleted: true,
    ),
    Task(
      id: '4',
      title: 'Facturation Q3',
      description: 'Vérification des factures en attente',
      dateTime: DateTime.now().add(const Duration(hours: 5)),
      priority: 'high',
    ),
  ];

  // ================================
  // FONCTION : Obtenir la couleur
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      // ================================
      // EN-TÊTE
      // ================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // elevation = ombre en bas de l'AppBar

        title: const Row(
          children: [
            // Photo de profil
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                'LS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: 12),

            // Nom et salutation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                Text(
                  'Laye SOW',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          // Icône notification
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),

          // Icône menu
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // ================================
      // CORPS DE LA PAGE
      // ================================
      body: Column(
        children: [

          // Container blanc pour titre et recherche
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Titre "Mes tâches"
                const Text(
                  'Mes tâches',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 16),

                // Barre de recherche
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher une tâche...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textMedium,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Filtre "EN COURS"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'EN COURS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${tasks.length} tâches',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================================
          // LISTE DES TÂCHES
          // ================================
          Expanded(
            // Expanded = prend tout l'espace disponible
            child: ListView.builder(
              // ListView.builder = liste scrollable
              // C'est comme un foreach en PHP !
              
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              // itemCount = nombre d'éléments

              itemBuilder: (context, index) {
                // itemBuilder = fonction qui construit
                // chaque élément de la liste
                // index = 0, 1, 2, 3...

                final task = tasks[index];
                // On récupère la tâche à l'index

                return _buildTaskCard(task);
                // On construit la carte de la tâche
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================================
  // FONCTION : Construire une carte de tâche
  // ================================
  Widget _buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // margin = espace extérieur

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      
      child: InkWell(
        // InkWell = rend cliquable avec effet d'onde
        onTap: () {
          // Navigation vers les détails
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },

        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              // Barre de couleur selon priorité
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: 12),

              // Contenu de la tâche
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Titre
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        // lineThrough = barré si terminé
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Description
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMedium,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // ellipsis = "..." si trop long
                    ),

                    const SizedBox(height: 8),

                    // Date et heure
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textMedium,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.getFormattedDate(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMedium,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    // On changera ça plus tard
                    // pour modifier vraiment la tâche
                  });
                },
                activeColor: AppColors.primary,
              ),

            ],
          ),
        ),
      ),
    );
  }
}