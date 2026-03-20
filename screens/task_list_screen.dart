import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';
import '../services/api/task_service.dart';
import 'task_detail_screen.dart';

// ================================
// ÉCRAN : Liste des tâches
// Affiche toutes les tâches avec recherche
// ================================
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  // ================================
  // VARIABLES
  // ================================
  final TaskService _taskService = TaskService();  // Service pour appeler l'API
  
  List<Task> tasks = [];  // Liste complète des tâches
  List<Task> _filteredTasks = [];  // ✅ Liste filtrée pour la recherche
  
  bool _isLoading = true;  // Indicateur de chargement
  String? _errorMessage;  // Message d'erreur si l'API échoue
  
  final TextEditingController _searchController = TextEditingController();  // ✅ Controller pour la barre de recherche

  // ================================
  // CYCLE DE VIE : Initialisation
  // Appelé une seule fois au démarrage
  // ================================
  @override
  void initState() {
    super.initState();
    _loadTasks();  // Charger les tâches au démarrage
  }

  // ================================
  // CYCLE DE VIE : Nettoyage
  // Appelé quand le widget est détruit
  // ================================
  @override
  void dispose() {
    _searchController.dispose();  // ✅ Libérer la mémoire du controller
    super.dispose();
  }

  // ================================
  // FONCTION : Charger les tâches depuis l'API
  // ================================
  Future<void> _loadTasks() async {
    // Afficher le loader
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Appel API pour récupérer les tâches
      final tasksData = await _taskService.getTasks();
      
      // Convertir les données JSON en objets Task
      setState(() {
        tasks = tasksData.map((json) => Task.fromJson(json)).toList();
        _filteredTasks = tasks;  // ✅ Initialiser la liste filtrée
        _isLoading = false;
      });
    } catch (e) {
      // En cas d'erreur, afficher un message
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // ================================
  // ✅ FONCTION : Filtrer les tâches selon la recherche
  // ================================
  void _filterTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        // Si la recherche est vide, afficher toutes les tâches
        _filteredTasks = tasks;
      } else {
        // Sinon, filtrer par titre ou description
        _filteredTasks = tasks.where((task) {
          final titleLower = task.title.toLowerCase();
          final descriptionLower = task.description.toLowerCase();
          final searchLower = query.toLowerCase();
          
          // Retourne true si le titre OU la description contient la recherche
          return titleLower.contains(searchLower) || 
                 descriptionLower.contains(searchLower);
        }).toList();
      }
    });
  }

  // ================================
  // FONCTION : Obtenir la couleur selon la priorité
  // ================================
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.priorityHigh;  // Rouge
      case 'medium':
        return AppColors.priorityMedium;  // Orange
      case 'low':
        return AppColors.priorityLow;  // Vert
      default:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      // ================================
      // EN-TÊTE (AppBar)
      // ================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,  // Pas de bouton retour

        title: const Row(
          children: [
            // Avatar avec initiales
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

            // Texte de bienvenue
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
          // Bouton notifications (non fonctionnel pour l'instant)
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),

          // Bouton menu (non fonctionnel pour l'instant)
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

          // ================================
          // SECTION : Titre et recherche
          // ================================
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

                // ✅ Barre de recherche (fonctionnelle)
                TextField(
                  controller: _searchController,  // Controller pour gérer le texte
                  onChanged: _filterTasks,  // Appelé à chaque changement de texte
                  decoration: InputDecoration(
                    hintText: 'Rechercher une tâche...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textMedium,
                    ),
                    // ✅ Bouton pour effacer la recherche
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textMedium),
                            onPressed: () {
                              _searchController.clear();  // Vider le champ
                              _filterTasks('');  // Réinitialiser le filtre
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Compteur de tâches
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
                      '${_filteredTasks.length} tâches',  // ✅ Affiche le nombre de tâches filtrées
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
          // SECTION : Liste des tâches
          // Affichage conditionnel selon l'état
          // ================================
          Expanded(
            child: _isLoading
                // ✅ État 1 : Chargement en cours
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                // ✅ État 2 : Erreur réseau/API
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
                    // ✅ État 3 : Aucune tâche (vide OU aucun résultat de recherche)
                    : _filteredTasks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _searchController.text.isEmpty 
                                      ? Icons.task_outlined  // Aucune tâche du tout
                                      : Icons.search_off,  // ✅ Aucun résultat de recherche
                                  size: 64,
                                  color: AppColors.textMedium,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'Aucune tâche pour le moment'
                                      : 'Aucune tâche trouvée',  // ✅ Message différent
                                  style: const TextStyle(
                                    color: AppColors.textMedium,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // ✅ Afficher conseil ou bouton selon le cas
                                if (_searchController.text.isEmpty)
                                  const Text(
                                    'Appuyez sur + pour ajouter une tâche',
                                    style: TextStyle(
                                      color: AppColors.textMedium,
                                      fontSize: 14,
                                    ),
                                  ),
                                if (_searchController.text.isNotEmpty)
                                  TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterTasks('');
                                    },
                                    child: const Text('Effacer la recherche'),
                                  ),
                              ],
                            ),
                          )
                        // ✅ État 4 : Liste des tâches (avec pull to refresh)
                        : RefreshIndicator(
                            onRefresh: _loadTasks,  // Recharger en tirant vers le bas
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredTasks.length,  // ✅ Nombre de tâches filtrées
                              itemBuilder: (context, index) {
                                final task = _filteredTasks[index];  // ✅ Tâche filtrée
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
  // WIDGET : Carte d'une tâche
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
      // IntrinsicHeight permet à la barre colorée de prendre toute la hauteur
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================================
            // BARRE COLORÉE (selon priorité)
            // ================================
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

            // ================================
            // CONTENU DE LA CARTE
            // ================================
            Expanded(
              child: InkWell(
                // ✅ Rendre la carte cliquable
                onTap: () {
                  print('🔵 Tâche cliquée : ${task.title}');
                  // Navigation vers l'écran de détails
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task: task),
                    ),
                  ).then((_) => _loadTasks());  // Recharger après retour
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // ================================
                      // INFORMATIONS DE LA TÂCHE
                      // ================================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titre de la tâche
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                                // Barré si terminée
                                decoration: task.isCompleted 
                                    ? TextDecoration.lineThrough 
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // Description (1 ligne max)
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
                              overflow: TextOverflow.ellipsis,  // ... si trop long
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

                      // ================================
                      // CHECKBOX (marquer complété)
                      // ================================
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (bool? value) async {
                          try {
                            // Appel API pour toggle le statut
                            await _taskService.toggleTaskComplete(task.id);
                            // Recharger la liste
                            _loadTasks();
                          } catch (e) {
                            // Afficher l'erreur
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll('Exception: ', ''),
                                  ),
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