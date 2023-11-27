// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/shared/database/user_collection/user_collection.dart';

class SupermarketList extends StatelessWidget {
  const SupermarketList({Key? key, this.userEmail}) : super(key: key);

  final userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Supermercados'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('user_collection')
            .where('userEmail', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text('Nenhum dado de supermercado encontrado.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ));
          }

          QueryDocumentSnapshot<Map<String, dynamic>>? userDocument =
              snapshot.data!.docs.isNotEmpty ? snapshot.data!.docs.first : null;

          if (userDocument == null) {
            return Text('Nenhum dado de supermercado encontrado.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ));
          }

          Map<String, dynamic> userStoreCollection =
              userDocument['userStoreCollection'] ?? {};

          if (userStoreCollection.isEmpty) {
            return Center(
              child: Text('Nenhum supermercado cadastrado.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  )),
            );
          }

          return ListView.builder(
            itemCount: userStoreCollection.length,
            itemBuilder: (context, index) {
              String supermarketName =
                  userStoreCollection[index.toString()]['storeName'];
              return ListTile(
                onTap: () => UserCollection().storeNameListShowModal(
                  context,
                  userEmail,
                  index.toString(),
                  userStoreCollection[index.toString()]['storeName'],
                ),
                title: Text(
                  supermarketName,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    bool confirmExclusion = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Confirmar Exclusão',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          content: Text(
                            'Deseja realmente excluir este supermercado?',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Sim'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmExclusion == true) {
                      // Chamar a função para excluir o supermercado
                      UserCollection()
                          .deleteUserStoreByIndex(userEmail, index, context);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            UserCollection().storeNameListShowModal(context, userEmail, '', ''),
      ),
    );
  }
}
