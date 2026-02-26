import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  // ================================
  // CONTROLLERS
  // ================================
  final TextEditingController _titleController = 
      TextEditingController();
  final TextEditingController _descriptionController = 
      TextEditingController();

  // ================================
  // VARIABLES
  // ================================
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedPriority = 'medium'; // Par défaut : moyenne

  // ================================
  // FONCTION : Sélectionner la date
  // ================================
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ================================
  // FONCTION : Sélectionner l'heure
  // ================================
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // ================================
  // FONCTION : Formater la date
  // ================================
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ================================
  // FONCTION : Formater l'heure
  // ================================
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // ================================
  // FONCTION : Créer la tâche
  // ================================
  void _createTask() {
    // Vérifier que tous les champs sont remplis
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le titre est obligatoire'),
          backgroundColor: AppColors.priorityHigh,
        ),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La date et l\'heure sont obligatoires'),
          backgroundColor: AppColors.priorityHigh,
        ),
      );
      return;
    }

    // Combiner date et heure
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Créer la tâche
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: dateTime,
      priority: _selectedPriority,
    );

    // Pour l'instant on affiche juste dans la console
    // Plus tard on enverra à l'API Laravel
    print('Nouvelle tâche créée:');
    print('Titre: ${newTask.title}');
    print('Description: ${newTask.description}');
    print('Date: ${newTask.getFormattedDate()}');
    print('Priorité: ${newTask.priority}');

    // Revenir en arrière
    Navigator.pop(context);

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tâche créée avec succès !'),
        backgroundColor: AppColors.priorityLow,
      ),
    );
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Nouvelle tâche',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ================================
      // FORMULAIRE
      // ================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================================
            // CHAMP TITRE
            // ================================
            const Text(
              'Titre de la tâche *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Ex: Finir le projet...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // CHAMP DESCRIPTION
            // ================================
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Décrivez votre tâche...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // DATE ET HEURE
            // ================================
            const Text(
              'Date et heure *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                // Sélecteur de date
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.textMedium,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate == null
                                ? 'Date'
                                : _formatDate(_selectedDate!),
                            style: TextStyle(
                              color: _selectedDate == null
                                  ? AppColors.textMedium
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Sélecteur d'heure
                Expanded(
                  child: InkWell(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: AppColors.textMedium,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedTime == null
                                ? 'Heure'
                                : _formatTime(_selectedTime!),
                            style: TextStyle(
                              color: _selectedTime == null
                                  ? AppColors.textMedium
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ================================
            // PRIORITÉ
            // ================================
            const Text(
              'Priorité *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                // Bouton Élevée
                Expanded(
                  child: _buildPriorityButton(
                    'high',
                    '🔥 Élevée',
                    AppColors.priorityHigh,
                  ),
                ),

                const SizedBox(width: 8),

                // Bouton Moyenne
                Expanded(
                  child: _buildPriorityButton(
                    'medium',
                    '⚡ Moyenne',
                    AppColors.priorityMedium,
                  ),
                ),

                const SizedBox(width: 8),

                // Bouton Basse
                Expanded(
                  child: _buildPriorityButton(
                    'low',
                    '✅ Basse',
                    AppColors.priorityLow,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ================================
            // BOUTON CRÉER
            // ================================
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _createTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Créer la tâche',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
  // WIDGET : Bouton de priorité
  // ================================
  Widget _buildPriorityButton(
    String priority,
    String label,
    Color color,
  ) {
    final isSelected = _selectedPriority == priority;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}