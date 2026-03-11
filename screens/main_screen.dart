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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 5 écrans
    final List<Widget> screens = [
      TaskListScreen(key: UniqueKey()),
      const StatsScreen(),
      const AddTaskScreen(),       // ← Au milieu
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      
      body: screens[_currentIndex],

      // ================================
      // BOTTOM NAVIGATION BAR (5 items)
      // ================================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
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

                // ➕ Ajouter (au milieu, en primaire)
                _buildAddButton(),

                // 👤 Profil
                _buildNavItem(
                  icon: Icons.person,
                  label: 'Profil',
                  index: 3,
                ),

                // ⚙️ Plus
                _buildNavItem(
                  icon: Icons.menu,
                  label: 'Plus',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Bouton de navigation normal
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
      child: SizedBox(
        width: 70,
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
      ),
    );
  }

  // Bouton "Ajouter" spécial (toujours en primaire)
Widget _buildAddButton() {
  return InkWell(
    onTap: () async {  // ← AJOUTE async
      // ✅ Naviguer vers AddTaskScreen (pas changer l'index)
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddTaskScreen(),
        ),
      );
      
      // ✅ Après retour, revenir à l'onglet Tâches
      setState(() {
        _currentIndex = 0;
      });
    },
    child: SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    ),
  );
}
}