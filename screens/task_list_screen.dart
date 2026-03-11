import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';
import '../services/api/task_service.dart';  // ← AJOUTÉ
import 'task_detail_screen.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  // ✅ NOUVEAU : Service et variables
  final TaskService _taskService = TaskService();
  List<Task> tasks = [];  // ← Liste vide au départ
  bool _isLoading = true;
  String? _errorMessage;

  // ✅ NOUVEAU : Charger au démarrage
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // ✅ NOUVEAU : Fonction pour charger les tâches
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tasksData = await _taskService.getTasks();
      setState(() {
        tasks = tasksData.map((json) => Task.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

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
        automaticallyImplyLeading: false,

        title: const Row(
          children: [
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
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),

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

                const Text(
                  'Mes tâches',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 16),

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
          // ✅ MODIFIÉ : Affichage conditionnel
          // ================================
          Expanded(
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
                              onPressed: _loadTasks,
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
                    : tasks.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_outlined,
                                  size: 64,
                                  color: AppColors.textMedium,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Aucune tâche pour le moment',
                                  style: TextStyle(
                                    color: AppColors.textMedium,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Appuyez sur + pour ajouter une tâche',
                                  style: TextStyle(
                                    color: AppColors.textMedium,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadTasks,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return _buildTaskCard(task);
                              },
                            ),
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
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. LA BARRE
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),

          // 2. LE RESTE DU CONTENU
          Expanded(
            child: InkWell(  // ← AJOUTE ICI
              onTap: () {
                print('🔵 Tâche cliquée : ${task.title}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(task: task),
                  ),
                ).then((_) => _loadTasks());
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textMedium,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: AppColors.textMedium),
                              const SizedBox(width: 4),
                              Text(
                                task.getFormattedDate(),
                                style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Checkbox
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) async {
                        try {
                          await _taskService.toggleTaskComplete(task.id);
                          _loadTasks();
                        } catch (e) {
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
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}