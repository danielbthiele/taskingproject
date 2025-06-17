import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importe suas telas
import 'telas/tela_de_tarefas.dart';
import 'telas/tela_de_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Firebase. Ele vai ler o google-services.json automaticamente.
  await Firebase.initializeApp();
  runApp(const MeuAppProdutividade());
}

class MeuAppProdutividade extends StatelessWidget {
  const MeuAppProdutividade({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TasKING', // Bom para o sistema operacional identificar o app
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Roteador(), // A "casa" do app é o Roteador
    );
  }
}

// O Roteador decide qual tela mostrar com base no estado de login do usuário.
class Roteador extends StatelessWidget {
  const Roteador({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // "Ouve" as mudanças no estado de autenticação do Firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Enquanto espera a primeira informação, mostra uma tela de "carregando"
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o snapshot tem dados, significa que há um usuário logado
        if (snapshot.hasData) {
          return const TelaDeTarefas(); // Leva para a tela principal de tarefas
        }

        // Se não tem dados, ninguém está logado
        return const TelaDeLogin(); // Leva para a tela de login
      },
    );
  }
}
