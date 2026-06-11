import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

void main() async {
  // ✅ Nécessaire avant tout avec async
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialiser Hive
  await Hive.initFlutter();
  
  // ✅ Ouvrir les boxes AVANT de lancer l'app
  await Hive.openBox('tasks');
  await Hive.openBox('user');
  
  print('✅ Hive initialisé et boxes ouvertes !');
  
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