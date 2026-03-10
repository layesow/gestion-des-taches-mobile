import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../utils/constants.dart';
//import '../services/api_service.dart';  // ← AJOUTE en haut
import '../services/api/auth_service.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  //final ApiService _apiService = ApiService();  // ← AJOUTE
  final AuthService _authService = AuthService();
  bool _isLoading = false;  // ← AJOUTE

  // Les controllers pour chaque champ
  final TextEditingController _nomController = 
      TextEditingController();
  final TextEditingController _telephoneController = 
      TextEditingController();
  final TextEditingController _emailController = 
      TextEditingController();
  final TextEditingController _passwordController = 
      TextEditingController();

  // Pour afficher/cacher le mot de passe
  bool _motDePasseVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 60),

            // ================================
            // TITRE
            // ================================
            const Center(
              child: Text(
                'Créer un compte',
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
                'Rejoignez Tache App pour organiser\nvos projets efficacement.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================================
            // CHAMP NOM COMPLET
            // ================================
            const Text(
              'Nom complet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            // Le champ de saisie
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                hintText: 'Laye SOW',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textMedium,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // CHAMP TÉLÉPHONE
            // ================================
            const Text(
              'Téléphone',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _telephoneController,
              // clavier numérique pour le téléphone
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+221 77 000 00 00',
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppColors.textMedium,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // CHAMP EMAIL
            // ================================
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'layesow@gmail.com',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textMedium,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================================
            // CHAMP MOT DE PASSE
            // ================================
            const Text(
              'Mot de passe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _passwordController,
              obscureText: !_motDePasseVisible,
              decoration: InputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textMedium,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _motDePasseVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.textMedium,
                  ),
                  onPressed: () {
                    setState(() {
                      _motDePasseVisible = !_motDePasseVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ================================
            // BOUTON S'INSCRIRE
            // ================================
            SizedBox(
              // Toute la largeur
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  // Validation
                  if (_nomController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez remplir tous les champs obligatoires'),
                        backgroundColor: AppColors.priorityHigh,
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    // Appel API
                    final result = await _authService.register(
                      name: _nomController.text,
                      email: _emailController.text,
                      phone: _telephoneController.text,
                      password: _passwordController.text,
                    );

                    if (mounted) {
                      // Succès - navigation vers MainScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bienvenue ${result['user']['name']} !'),
                          backgroundColor: AppColors.priorityLow,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString().replaceAll('Exception: ', '')),
                          backgroundColor: AppColors.priorityHigh,
                        ),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'S\'inscrire →',
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
            // LIEN SE CONNECTER
            // ================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Déjà un compte ? ',
                  style: TextStyle(
                    color: AppColors.textMedium,
                  ),
                ),
                // APRÈS
                TextButton(
                  onPressed: () {
                    // On revient en arrière
                    // comme le bouton "back" du téléphone
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Se connecter',
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