import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaDeTarefas extends StatefulWidget {
  const TelaDeTarefas({super.key});

  @override
  State<TelaDeTarefas> createState() => _TelaDeTarefasState();
}

class _TelaDeTarefasState extends State<TelaDeTarefas> {
  // Ferramentas para falar com os serviços do Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _controladorDoCampoDeTexto = TextEditingController();

  // Função para adicionar uma nova tarefa na nuvem
  void _adicionarTarefa() {
    String textoDaTarefa = _controladorDoCampoDeTexto.text;
    String idDoUsuario = _auth.currentUser!.uid;

    if (textoDaTarefa.isNotEmpty) {
      _firestore
          .collection('usuarios')
          .doc(idDoUsuario)
          .collection('tarefas')
          .add({
        'texto': textoDaTarefa,
        'concluida': false,
        'timestamp': Timestamp.now(),
      });
      _controladorDoCampoDeTexto.clear();
    }
  }

  // Função para remover uma tarefa da nuvem
  void _removerTarefa(String idDaTarefa) {
    String idDoUsuario = _auth.currentUser!.uid;
    _firestore
        .collection('usuarios')
        .doc(idDoUsuario)
        .collection('tarefas')
        .doc(idDaTarefa)
        .delete();
  }
  
  // Função para fazer logout
  void _fazerLogout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TasKING'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // Botão de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _fazerLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorDoCampoDeTexto,
                    decoration: const InputDecoration(hintText: 'Nova tarefa:'),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.add_task),
                  onPressed: _adicionarTarefa,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('usuarios')
                    .doc(_auth.currentUser!.uid)
                    .collection('tarefas')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma tarefa adicionada ainda.'),
                    );
                  }

                  final listaDeTarefasDaNuvem = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: listaDeTarefasDaNuvem.length,
                    itemBuilder: (context, index) {
                      final tarefaDoc = listaDeTarefasDaNuvem[index];
                      final dadosDaTarefa = tarefaDoc.data() as Map<String, dynamic>;
                      final idDaTarefa = tarefaDoc.id;
                      final textoDaTarefa = dadosDaTarefa['texto'];

                      return Dismissible(
                        key: Key(idDaTarefa),
                        onDismissed: (direction) {
                          _removerTarefa(idDaTarefa);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          elevation: 3.0,
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(title: Text(textoDaTarefa)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
