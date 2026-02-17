import 'package:flutter/material.dart';
import '../utils/constants.dart';

class Exercice extends StatelessWidget {
  const Exercice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // 👉 Écris ici un Text "Bonjour !"
            // avec fontSize: 32 et fontWeight: bold
            const Text('Bonjour !',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            
            // 👉 Écris ici un SizedBox de height: 16
            const SizedBox(height: 16,),
            
            
            // 👉 Écris ici un Text "Je apprends Flutter"
            // avec fontSize: 16 et color: AppColors.textMedium
            const Text('Je apprends Flutter',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMedium,
              ),
            ),
            
            
            // 👉 Écris ici un SizedBox de height: 32
            const SizedBox(height: 32,),
            
            
            // 👉 Écris ici un ElevatedButton
            // avec le texte "Cliquez ici"
            // et onPressed: () {} (vide pour l'instant)
            ElevatedButton(
              onPressed: () {},
              child: const Text('Cliquez ici'),
            ) 
            
          ],
        ),
      ),
    );
  }
}