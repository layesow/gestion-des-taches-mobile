import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/api/task_service.dart';
import '../models/task_model.dart';

// ================================
// CHANGÉ : StatefulWidget pour charger les données
// ================================
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  
  // ================================
  // Service et variables pour les stats
  // ================================
  final TaskService _taskService = TaskService();
  
  bool _isLoading = true;
  String? _errorMessage;
  
  int _totalTasks = 0;
  int _completedTasks = 0;
  int _pendingTasks = 0;
  int _highPriority = 0;
  int _mediumPriority = 0;
  int _lowPriority = 0;
  
  // ================================
  // Charger les stats au démarrage
  // ================================
  @override
  void initState() {
    super.initState();
    _loadStats();
  }
  
  // ================================
  // Fonction pour charger et calculer les stats
  // ================================
  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Récupérer toutes les tâches
      final tasksData = await _taskService.getTasks();
      final tasks = tasksData.map((json) => Task.fromJson(json)).toList();
      
      // Calculer les statistiques
      int total = tasks.length;
      int completed = tasks.where((task) => task.isCompleted).length;
      int pending = tasks.where((task) => !task.isCompleted).length;
      int high = tasks.where((task) => task.priority == 'high').length;
      int medium = tasks.where((task) => task.priority == 'medium').length;
      int low = tasks.where((task) => task.priority == 'low').length;
      
      setState(() {
        _totalTasks = total;
        _completedTasks = completed;
        _pendingTasks = pending;
        _highPriority = high;
        _mediumPriority = medium;
        _lowPriority = low;
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
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
                          onPressed: _loadStats,
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
                : RefreshIndicator(
                    onRefresh: _loadStats,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          // ================================
                          // TITRE
                          // ================================
                          const Text(
                            'Statistiques',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ================================
                          // CARTES DE STATS (données dynamiques)
                          // ================================
                          _buildStatCard(
                            _totalTasks.toString(),
                            'Tâches totales',
                            Icons.task_alt,
                            AppColors.primary,
                          ),

                          const SizedBox(height: 12),

                          _buildStatCard(
                            _completedTasks.toString(),
                            'Terminées',
                            Icons.check_circle,
                            AppColors.priorityLow,
                          ),

                          const SizedBox(height: 12),

                          _buildStatCard(
                            _pendingTasks.toString(),
                            'En cours',
                            Icons.pending,
                            AppColors.priorityHigh,
                          ),

                          const SizedBox(height: 24),

                          // ================================
                          // SECTION PAR PRIORITÉ
                          // ================================
                          const Text(
                            'Par priorité',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Priorités (données dynamiques)
                          Row(
                            children: [
                              Expanded(
                                child: _buildPriorityCard(
                                  _highPriority.toString(),
                                  'Élevée',
                                  AppColors.priorityHigh,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPriorityCard(
                                  _mediumPriority.toString(),
                                  'Moyenne',
                                  AppColors.priorityMedium,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPriorityCard(
                                  _lowPriority.toString(),
                                  'Basse',
                                  AppColors.priorityLow,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ================================
                          // GRAPHIQUE DE PROGRESSION
                          // ================================
                          if (_totalTasks > 0) ...[
                            const Text(
                              'Progression',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildProgressChart(),
                            const SizedBox(height: 24),
                          ],

                          // ================================
                          // MESSAGE SI PAS DE TÂCHES
                          // ================================
                          if (_totalTasks == 0)
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 80,
                                    color: AppColors.textMedium.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Aucune tâche pour le moment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  // ================================
  // Widget pour une carte de stat
  // ================================
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

  // ================================
  // Widget pour une carte de priorité
  // ================================
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

  // ================================
  // Widget pour le graphique de progression
  // ================================
  Widget _buildProgressChart() {
    double completionRate = _totalTasks > 0 
        ? (_completedTasks / _totalTasks) 
        : 0.0;

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
      child: Column(
        children: [
          // Pourcentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Taux de complétion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '${(completionRate * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de progression principale
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 20,
              backgroundColor: AppColors.backgroundLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.priorityLow,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Barres par priorité
          _buildPriorityBar(
            'Haute priorité',
            _highPriority,
            _totalTasks,
            AppColors.priorityHigh,
          ),

          const SizedBox(height: 12),

          _buildPriorityBar(
            'Moyenne priorité',
            _mediumPriority,
            _totalTasks,
            AppColors.priorityMedium,
          ),

          const SizedBox(height: 12),

          _buildPriorityBar(
            'Basse priorité',
            _lowPriority,
            _totalTasks,
            AppColors.priorityLow,
          ),
        ],
      ),
    );
  }

  // ================================
  // Widget pour une barre de priorité
  // ================================
  Widget _buildPriorityBar(
    String label,
    int count,
    int total,
    Color color,
  ) {
    double percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMedium,
              ),
            ),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}