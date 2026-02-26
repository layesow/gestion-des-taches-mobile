import 'package:flutter/material.dart';
import 'package:tache_app/screens/register_screen.dart';
import '../utils/constants.dart';
import 'main_screen.dart';
import 'forgot_password_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // ================================
  // VARIABLES
  // ================================

  // Pour récupérer ce que l'utilisateur tape
  final TextEditingController _emailController = 
      TextEditingController();
  
  final TextEditingController _passwordController = 
      TextEditingController();

  // Pour afficher/cacher le mot de passe
  bool _motDePasseVisible = false;

  // ================================
  // INTERFACE
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // SingleChildScrollView = permet de scroller
      // si le contenu est trop long
      // comme overflow-y: auto en CSS
      body: SingleChildScrollView(

        // Padding = espace intérieur
        // comme padding en CSS
        padding: const EdgeInsets.all(24),

        child: Column(
          // crossAxisAlignment.start = 
          // aligner à gauche
          // comme align-items: flex-start en CSS
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Espace en haut
            const SizedBox(height: 60),

            // ================================
            // ICÔNE EN HAUT
            // ================================
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  // couleur bleue transparente
                  color: AppColors.primary.withOpacity(0.1),
                  // coins arrondis
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.task_alt,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================================
            // TITRE
            // ================================
            const Center(
              child: Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ================================
            // SOUS-TITRE
            // ================================
            const Center(
              child: Text(
                'Ravi de vous revoir sur Tache App.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================================
            // CHAMP EMAIL
            // ================================

            // Label
            const Text(
              'Adresse Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            // Champ de saisie
            TextField(
              // controller = relie le champ 
              // à notre variable
              controller: _emailController,

              // Type de clavier
              // emailAddress = clavier avec @
              keyboardType: TextInputType.emailAddress,

              decoration: InputDecoration(
                // placeholder
                hintText: 'layesow@gmail.com',

                // icône à gauche
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textMedium,
                ),

                // style de la bordure
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // CHAMP MOT DE PASSE
            // ================================

            // Label
            const Text(
              'Mot de passe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            // Champ de saisie
            TextField(
              controller: _passwordController,

              // obscureText = cacher le texte
              // comme type="password" en HTML
              obscureText: !_motDePasseVisible,

              decoration: InputDecoration(
                hintText: 'Votre mot de passe',

                // icône à gauche
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textMedium,
                ),

                // icône à droite (oeil)
                suffixIcon: IconButton(
                  icon: Icon(
                    // changer l'icône selon 
                    // si le mdp est visible ou non
                    _motDePasseVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textMedium,
                  ),
                  onPressed: () {
                    // setState = mettre à jour l'écran
                    setState(() {
                      _motDePasseVisible = 
                          !_motDePasseVisible;
                    });
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================================
            // MOT DE PASSE OUBLIÉ
            // ================================
            Align(
              // Aligner à droite
              alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Mot de passe oublié ?'),
                ),
            ),

            const SizedBox(height: 24),

            // ================================
            // BOUTON SE CONNECTER
            // ================================
            SizedBox(
              // prendre toute la largeur
              // comme width: 100% en CSS
              width: double.infinity,
              height: 56,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Se connecter →',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================================
            // LIEN INSCRIPTION
            // ================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pas encore de compte ? ',
                  style: TextStyle(
                    color: AppColors.textMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // On navigue vers RegisterScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Créer un compte',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}