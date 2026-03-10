import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'task_list_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'add_task_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // Index de l'onglet actuel
  int _currentIndex = 0;

  // Liste des écrans
  final List<Widget> _screens = [
    const TaskListScreen(),    // 📋 Tâches
    const StatsScreen(),       // 📊 Statistiques  
    const ProfileScreen(),     // 👤 Profil
    const SettingsScreen(),    // ⚙️ Plus/Paramètres
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // Le contenu change selon l'onglet
      body: _screens[_currentIndex],

      // ================================
      // BOUTON FLOTTANT AU MILIEU
      // ================================
      floatingActionButton: Padding(
        // Ajuste la valeur (ici 20) pour le faire descendre plus ou moins
        padding: const EdgeInsets.only(top: 40), 
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTaskScreen(),
              ),
            ).then((_) {
              setState(() {
                _currentIndex = 0;
              });
            });
          },
          backgroundColor: AppColors.primary,
          elevation: 8,
          child: const Icon(
            Icons.add,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // ================================
      // BOTTOM APP BAR avec encoche
      // ================================
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 📋 Tâches
              _buildNavItem(
                icon: Icons.task_alt,
                label: 'Tâches',
                index: 0,
              ),

              // 📊 Stats
              _buildNavItem(
                icon: Icons.bar_chart,
                label: 'Stats',
                index: 1,
              ),

              // Espace pour le FAB
              const SizedBox(width: 40),

              // 👤 Profil
              _buildNavItem(
                icon: Icons.person,
                label: 'Profil',
                index: 2,
              ),

              // ⚙️ Plus
              _buildNavItem(
                icon: Icons.menu,
                label: 'Plus',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour construire un élément de navigation
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textMedium,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.textMedium,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}