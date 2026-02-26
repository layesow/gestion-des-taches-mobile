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
      // BOUTON FLOTTANT (en bas à droite)
      // ================================
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 6,
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),

      // ================================
      // BOTTOM NAVIGATION BAR (simple, sans encoche)
      // ================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          // Style
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMedium,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,

          items: const [
            // 📋 Tâches
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'Tâches',
            ),

            // 📊 Statistiques
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),

            // 👤 Profil
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),

            // ⚙️ Plus
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Plus',
            ),
          ],
        ),
      ),
    );
  }
}