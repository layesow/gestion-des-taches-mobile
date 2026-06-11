import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';
import '../services/api/task_service.dart';
import 'task_detail_screen.dart';
import '../services/api/auth_service.dart';
import '../services/storage/connectivity_service.dart';
import '../services/storage/cache_service.dart';

// ================================
// ÉCRAN : Liste des tâches
// Affiche toutes les tâches avec recherche, filtres, tri et mode hors ligne
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
  final TaskService _taskService = TaskService();
  
  List<Task> tasks = [];          // Liste complète des tâches
  List<Task> _filteredTasks = []; // Liste filtrée et triée
  
  bool _isLoading = true;
  bool _isOffline = false;        // ✅ Mode hors ligne
  String? _errorMessage;
  
  final TextEditingController _searchController = TextEditingController();
  
  // Filtres et tri
  String _selectedPriorityFilter = 'all';  // all, high, medium, low
  String _selectedStatusFilter = 'all';    // all, pending, completed
  String _selectedSort = 'date_desc';      // date_desc, date_asc, priority, title

  // Infos utilisateur
  String _userName = '';
  String _userInitials = '?';

  // ================================
  // CYCLE DE VIE : Initialisation
  // ================================
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadTasks();
  }

  // ================================
  // CYCLE DE VIE : Nettoyage
  // ================================
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ================================
  // FONCTION : Charger les tâches depuis l'API ou le cache
  // ================================
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // ✅ Vérifier la connexion internet
    final connected = await ConnectivityService.isConnected();
    setState(() {
      _isOffline = !connected;
    });

    try {
      final tasksData = await _taskService.getTasks();
      
      setState(() {
        tasks = tasksData.map((json) => Task.fromJson(json)).toList();
        _filteredTasks = tasks;
        _isLoading = false;
      });
      
      // Appliquer les filtres et tri après chargement
      _filterTasks(_searchController.text);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // ================================
  // FONCTION : Charger les infos utilisateur
  // ================================
  Future<void> _loadUserInfo() async {
    try {
      final userData = await AuthService().getUser();
      final user = userData['user'];
      
      setState(() {
        _userName = user['name'] ?? 'Utilisateur';
        _userInitials = _getInitials(user['name'] ?? '');
      });
    } catch (e) {
      print('Erreur chargement utilisateur: $e');
    }
  }

  // ================================
  // FONCTION : Obtenir les initiales
  // ================================
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  // ================================
  // FONCTION : Filtrer et trier les tâches
  // ================================
  void _filterTasks(String query) {
    setState(() {
      List<Task> filtered = tasks;
      
      // 1️⃣ Filtrer par recherche texte
      if (query.isNotEmpty) {
        filtered = filtered.where((task) {
          final titleLower = task.title.toLowerCase();
          final descriptionLower = task.description.toLowerCase();
          final searchLower = query.toLowerCase();
          return titleLower.contains(searchLower) || 
                 descriptionLower.contains(searchLower);
        }).toList();
      }
      
      // 2️⃣ Filtrer par priorité
      if (_selectedPriorityFilter != 'all') {
        filtered = filtered.where((task) => 
          task.priority == _selectedPriorityFilter
        ).toList();
      }
      
      // 3️⃣ Filtrer par statut
      if (_selectedStatusFilter == 'pending') {
        filtered = filtered.where((task) => !task.isCompleted).toList();
      } else if (_selectedStatusFilter == 'completed') {
        filtered = filtered.where((task) => task.isCompleted).toList();
      }
      
      // 4️⃣ Trier
      switch (_selectedSort) {
        case 'date_desc':
          filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));
          break;
        case 'date_asc':
          filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          break;
        case 'priority':
          filtered.sort((a, b) {
            const priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
            return (priorityOrder[a.priority] ?? 3)
                .compareTo(priorityOrder[b.priority] ?? 3);
          });
          break;
        case 'title':
          filtered.sort((a, b) => 
            a.title.toLowerCase().compareTo(b.title.toLowerCase())
          );
          break;
      }

      // Les tâches terminées toujours en bas
      filtered.sort((a, b) {
        if (a.isCompleted && !b.isCompleted) return 1;   // a terminée → va en bas
        if (!a.isCompleted && b.isCompleted) return -1;  // b terminée → va en bas
        return 0;  // même statut → garde l'ordre actuel
      });
      
      _filteredTasks = filtered;
    });
  }

  // ================================
  // Changer le filtre de priorité
  // ================================
  void _changePriorityFilter(String filter) {
    setState(() => _selectedPriorityFilter = filter);
    _filterTasks(_searchController.text);
  }

  // ================================
  // Changer le filtre de statut
  // ================================
  void _changeStatusFilter(String filter) {
    setState(() => _selectedStatusFilter = filter);
    _filterTasks(_searchController.text);
  }

  // ================================
  // Changer le tri
  // ================================
  void _changeSort(String sort) {
    setState(() => _selectedSort = sort);
    _filterTasks(_searchController.text);
  }

  // ================================
  // Afficher le menu de tri
  // ================================
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trier par',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Date (plus récent)', 'date_desc', Icons.arrow_downward),
            _buildSortOption('Date (plus ancien)', 'date_asc', Icons.arrow_upward),
            _buildSortOption('Priorité (haute → basse)', 'priority', Icons.priority_high),
            _buildSortOption('Titre (A → Z)', 'title', Icons.sort_by_alpha),
          ],
        ),
      ),
    );
  }

  // ================================
  // FONCTION : Obtenir la couleur selon la priorité
  // ================================
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':   return AppColors.priorityHigh;
      case 'medium': return AppColors.priorityMedium;
      case 'low':    return AppColors.priorityLow;
      default:       return AppColors.priorityLow;
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
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            // Avatar avec initiales dynamiques
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                _userInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Nom dynamique
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                Text(
                  _userName,
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

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
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
          // ✅ BANNIÈRE HORS LIGNE
          // Affichée seulement si pas de connexion
          // ================================
          if (_isOffline) _buildOfflineBanner(),

          // ================================
          // SECTION : Titre, recherche et filtres
          // ================================
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Titre
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
                  controller: _searchController,
                  onChanged: _filterTasks,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une tâche...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMedium),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.textMedium),
                            onPressed: () {
                              _searchController.clear();
                              _filterTasks('');
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

                // Filtres par priorité
                const Text(
                  'Priorité',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Toutes',
                        isSelected: _selectedPriorityFilter == 'all',
                        onTap: () => _changePriorityFilter('all'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '🔥 Élevée',
                        isSelected: _selectedPriorityFilter == 'high',
                        onTap: () => _changePriorityFilter('high'),
                        color: AppColors.priorityHigh,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '⚡ Moyenne',
                        isSelected: _selectedPriorityFilter == 'medium',
                        onTap: () => _changePriorityFilter('medium'),
                        color: AppColors.priorityMedium,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '✅ Basse',
                        isSelected: _selectedPriorityFilter == 'low',
                        onTap: () => _changePriorityFilter('low'),
                        color: AppColors.priorityLow,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Filtres par statut & Tri
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statut',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildFilterChip(
                                  label: 'Toutes',
                                  isSelected: _selectedStatusFilter == 'all',
                                  onTap: () => _changeStatusFilter('all'),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildFilterChip(
                                  label: 'En cours',
                                  isSelected: _selectedStatusFilter == 'pending',
                                  onTap: () => _changeStatusFilter('pending'),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildFilterChip(
                                  label: 'Terminées',
                                  isSelected: _selectedStatusFilter == 'completed',
                                  onTap: () => _changeStatusFilter('completed'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Bouton tri
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Trier',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _showSortOptions(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12, 
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.sort, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Compteur de tâches
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RÉSULTATS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${_filteredTasks.length} tâches',
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
          // ================================
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
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
                    : _filteredTasks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _searchController.text.isEmpty && 
                                  _selectedPriorityFilter == 'all' && 
                                  _selectedStatusFilter == 'all'
                                      ? Icons.task_outlined
                                      : Icons.search_off,
                                  size: 64,
                                  color: AppColors.textMedium,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty && 
                                  _selectedPriorityFilter == 'all' && 
                                  _selectedStatusFilter == 'all'
                                      ? 'Aucune tâche pour le moment'
                                      : 'Aucune tâche trouvée',
                                  style: const TextStyle(
                                    color: AppColors.textMedium,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (_searchController.text.isEmpty && 
                                    _selectedPriorityFilter == 'all' && 
                                    _selectedStatusFilter == 'all')
                                  const Text(
                                    'Appuyez sur + pour ajouter une tâche',
                                    style: TextStyle(
                                      color: AppColors.textMedium,
                                      fontSize: 14,
                                    ),
                                  ),
                                if (_searchController.text.isNotEmpty || 
                                    _selectedPriorityFilter != 'all' || 
                                    _selectedStatusFilter != 'all')
                                  TextButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _changePriorityFilter('all');
                                      _changeStatusFilter('all');
                                    },
                                    child: const Text('Réinitialiser les filtres'),
                                  ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadTasks,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = _filteredTasks[index];
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
  // ✅ WIDGET : Bannière mode hors ligne
  // ================================
  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      color: AppColors.priorityMedium.withOpacity(0.15),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            color: AppColors.priorityMedium,
            size: 18,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Mode hors ligne - Données depuis le cache local',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.priorityMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Bouton pour réessayer
          InkWell(
            onTap: _loadTasks,
            child: const Text(
              'Réessayer',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barre colorée selon priorité
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

            // Contenu de la carte
            Expanded(
              child: InkWell(
                onTap: () {
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
                            ),
                            const SizedBox(height: 8),
                            // Date
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

                      // Checkbox pour marquer complété
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

  // ================================
  // WIDGET : Bouton de filtre
  // ================================
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (color ?? AppColors.primary) 
              : Colors.transparent,
          border: Border.all(
            color: color ?? AppColors.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected 
                ? Colors.white 
                : (color ?? AppColors.primary),
          ),
        ),
      ),
    );
  }

  // ================================
  // WIDGET : Option de tri
  // ================================
  Widget _buildSortOption(String label, String value, IconData icon) {
    final isSelected = _selectedSort == value;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textMedium,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textDark,
        ),
      ),
      trailing: isSelected 
          ? const Icon(Icons.check, color: AppColors.primary) 
          : null,
      onTap: () {
        _changeSort(value);
        Navigator.pop(context);
      },
    );
  }
}