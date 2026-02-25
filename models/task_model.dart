// ================================
// MODEL TASK
// Structure d'une tâche
// ================================

class Task {
  // Les propriétés d'une tâche
  final String id;
  final String title;          // Titre
  final String description;    // Description
  final DateTime dateTime;     // Date et heure
  final String priority;       // "high", "medium", "low"
  final bool isCompleted;      // Terminée ou non

  // Le constructeur
  // C'est comme __construct() en PHP
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    this.isCompleted = false,  // Par défaut non terminée
  });

  // Fonction pour obtenir la couleur selon la priorité
  // On va l'utiliser pour afficher la barre colorée
  String getPriorityColor() {
    switch (priority) {
      case 'high':
        return 'priorityHigh';
      case 'medium':
        return 'priorityMedium';
      case 'low':
        return 'priorityLow';
      default:
        return 'priorityLow';
    }
  }

  // Fonction pour formater la date
  // Exemple: "Aujourd'hui, 18:30" ou "12 Jan, 14:00"
  String getFormattedDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(
      dateTime.year, 
      dateTime.month, 
      dateTime.day
    );

    // Si c'est aujourd'hui
    if (taskDate == today) {
      return 'Aujourd\'hui, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    
    // Si c'est demain
    final tomorrow = today.add(const Duration(days: 1));
    if (taskDate == tomorrow) {
      return 'Demain, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    // Sinon afficher la date complète
    final months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}