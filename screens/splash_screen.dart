import 'package:flutter/material.dart';
import '../utils/constants.dart';

// =========================================
// SPLASH SCREEN
// Premier écran qui s'affiche (3 secondes)
// =========================================

// PARTIE 1 : La coquille du widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// PARTIE 2 : Le moteur du widget
class _SplashScreenState extends State<SplashScreen> {

  // initState = s'exécute quand l'écran s'ouvre
  // Comme __construct() en PHP
  @override
  void initState() {
    super.initState();
    _allerVersConnexion(); // On lance le timer
  }

  // Cette fonction attend 3 secondes
  // puis navigue vers la connexion
  Future<void> _allerVersConnexion() async {
    // Future = comme Promise en JavaScript
    // async/await = pareil qu'en JavaScript !

    // On attend 3 secondes
    await Future.delayed(const Duration(seconds: 3));

    // Si l'écran est encore ouvert
    if (!mounted) return;

    // On navigue vers l'écran de connexion
    // (on verra cet écran juste après)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EcranTemporaire(),
      ),
    );
  }

  // BUILD = ce qu'on affiche sur l'écran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fond bleu comme ton design Figma
      backgroundColor: AppColors.primary,

      body: Center(
        // Center = tout centrer
        // comme margin: auto en CSS

        child: Column(
          // Column = empiler les éléments
          // comme flex-direction: column en CSS

          mainAxisAlignment: MainAxisAlignment.center,
          // center = centrer verticalement

          children: [

            // ⚡ ICÔNE ÉCLAIR
            Container(
              // Container = comme une <div> en HTML
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                // BoxDecoration = comme le style CSS
                color: Colors.white.withOpacity(0.2),
                // fond blanc transparent
                borderRadius: BorderRadius.circular(24),
                // coins arrondis = border-radius en CSS
              ),
              child: const Icon(
                Icons.flash_on, // icône éclair
                size: 60,
                color: Colors.white,
              ),
            ),

            // ESPACE (comme margin-bottom en CSS)
            const SizedBox(height: 32),

            // 📝 NOM DE L'APPLICATION
            const Text(
              'TACHE APP',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
                // letterSpacing = letter-spacing en CSS
              ),
            ),

            // ESPACE
            const SizedBox(height: 8),

            // 📝 SLOGAN
            const Text(
              'PRODUCTIVITÉ SIMPLIFIÉE',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 2,
              ),
            ),

            // ESPACE
            const SizedBox(height: 60),

            // ⏳ CERCLE DE CHARGEMENT
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),

          ],
        ),
      ),
    );
  }
}

// =========================================
// ÉCRAN TEMPORAIRE
// (On va le remplacer par le vrai Login)
// =========================================
class EcranTemporaire extends StatelessWidget {
  const EcranTemporaire({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Écran de Connexion\nbientôt disponible !',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}