import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const TacheApp());
}

class TacheApp extends StatelessWidget {
  const TacheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tache App',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
      ),
      
      home: const SplashScreen(),
    );
  }
}