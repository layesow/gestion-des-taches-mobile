import 'package:flutter/material.dart';
import 'package:tache_app/screens/login_screen.dart';
import 'package:tache_app/screens/register_screen.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

// Point d'entrée de l'application
// Comme index.php en PHP
void main() {
  runApp(const TacheApp());
}

class TacheApp extends StatelessWidget {
  const TacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // Nom de l'application
      title: 'Tache App',

      // Cacher le badge DEBUG
      debugShowCheckedModeBanner: false,

      // Couleur de fond globale
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),

      // Premier écran = Splash Screen
      home: const RegisterScreen(),
    );
  }
}
