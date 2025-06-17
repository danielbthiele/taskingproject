import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TelaDeLogin extends StatefulWidget {
  const TelaDeLogin({super.key});

  @override
  State<TelaDeLogin> createState() => _TelaDeLoginState();
}

class _TelaDeLoginState extends State<TelaDeLogin> {
  // Função para fazer o login com a conta do Google
  void fazerLoginComGoogle() async {
    try {
      // Inicia o fluxo de login do Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtém os detalhes da autenticação (tokens)
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Cria uma credencial do Firebase a partir dos tokens do Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Usa a credencial para fazer o login no Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Em um app real, você mostraria um erro para o usuário.
      // Por enquanto, apenas imprimimos no console.
      print("Algo deu errado no login com Google: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/1024tasking.png', height: 150),
                const SizedBox(height: 20),
                // Título
                const Text(
                  'Bem-vindo ao TasKING!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),

                // Botão de Login com Google
                ElevatedButton.icon(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24.0,
                  ),
                  label: const Text('Entrar com Google'),
                  onPressed: fazerLoginComGoogle,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
