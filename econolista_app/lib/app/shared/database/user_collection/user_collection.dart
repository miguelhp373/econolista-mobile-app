// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/shared/models/user_models.dart';

class UserCollection {
  CollectionReference userCollectionReferenceList =
      FirebaseFirestore.instance.collection('user_collection');

  CollectionReference shoppingListCollectionReferenceList =
      FirebaseFirestore.instance.collection('shopping_list_collection');

  Future<Map<String, dynamic>?> _fetchUserCollectionReference(
    String userEmail,
  ) async {
    final Query<Object?> userCollectionRef = userCollectionReferenceList.where(
      'userEmail',
      isEqualTo: userEmail,
    );

    final QuerySnapshot<Object?> snapshotResponse =
        await userCollectionRef.get();

    Map<String, dynamic>? hasUserData;

    if (snapshotResponse.docs.isNotEmpty) {
      hasUserData = snapshotResponse.docs[0].data() as Map<String, dynamic>?;
    }

    return hasUserData;
  }

  void putUserCollection(UserModels userModels) async {
    Map<String, dynamic>? documentReference =
        await _fetchUserCollectionReference(userModels.userEmail);

    if (documentReference?['userEmail'] == null) {
      userCollectionReferenceList.add(userModels.toMap());
      return;
    }
  }

  void _putUserStoreCollection(String storeName, String userEmail) async {
    QuerySnapshot<Object?> snapshot = await userCollectionReferenceList
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> existingData =
          snapshot.docs[0].data() as Map<String, dynamic>;

      Map<String, dynamic> existingStoreCollection =
          Map<String, dynamic>.from(existingData['userStoreCollection'] ?? {});

      // Verifica se o supermercado já existe
      String existingIndex =
          _findStoreIndex(existingStoreCollection, storeName);

      if (existingIndex.isNotEmpty) {
        // Se o supermercado existir, atualiza o valor
        existingStoreCollection[existingIndex] = {'storeName': storeName};
      } else {
        // Encontra o próximo índice disponível começando de zero
        int nextIndex = 0;
        while (existingStoreCollection.containsKey(nextIndex.toString())) {
          nextIndex++;
        }

        existingStoreCollection[nextIndex.toString()] = {
          'storeName': storeName
        };
      }

      await userCollectionReferenceList.doc(snapshot.docs[0].id).update({
        'userStoreCollection': existingStoreCollection,
      });
    }
  }

  String _findStoreIndex(
      Map<String, dynamic> storeCollection, String targetStoreName) {
    // Percorre a coleção existente e verifica se o supermercado já existe
    for (var entry in storeCollection.entries) {
      String index = entry.key;
      String storeName = entry.value['storeName'];
      if (storeName == targetStoreName) {
        return index;
      }
    }
    return '';
  }

  Future<void> deleteUserStoreByIndex(
      String userEmail, int indexToDelete, BuildContext context) async {
    QuerySnapshot<Object?> snapshot = await userCollectionReferenceList
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> existingData =
          snapshot.docs[0].data() as Map<String, dynamic>;

      Map<String, dynamic> existingStoreCollection =
          Map<String, dynamic>.from(existingData['userStoreCollection'] ?? {});

      // Verifica se existem compras associadas ao supermercado
      if (await _hasShoppingAssociated(
          existingStoreCollection, indexToDelete, userEmail)) {
        // Se houver compras, mostra uma mensagem ou toma outra ação
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Não é possível excluir. Existem compras associadas a este supermercado.'),
          ),
        );
        return;
      }

      existingStoreCollection.remove(indexToDelete.toString());

      // Atualize os índices restantes
      int currentIndex = 0;
      Map<String, dynamic> updatedStoreCollection = {};
      existingStoreCollection.forEach((key, value) {
        updatedStoreCollection[currentIndex.toString()] = value;
        currentIndex++;
      });

      await userCollectionReferenceList.doc(snapshot.docs[0].id).update({
        'userStoreCollection': updatedStoreCollection,
      });
    }
  }

  Future<bool> _hasShoppingAssociated(Map<String, dynamic> storeCollection,
      int indexToDelete, String userEmail) async {
    // Verifica se existem compras associadas ao supermercado que será excluído
    String marketNameToDelete =
        storeCollection[indexToDelete.toString()]['storeName'];
    QuerySnapshot<Object?> shoppingSnapshot =
        await shoppingListCollectionReferenceList
            .where('userEmail', isEqualTo: userEmail)
            .where('MarketName', isEqualTo: marketNameToDelete)
            .get();

    return shoppingSnapshot.docs.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> storeNameListShowModal(
    BuildContext context,
    String userEmail,
    String storeIndex,
    String storeName,
  ) async {
    final formSubmitAction = GlobalKey<FormState>();
    final TextEditingController storeNameController = TextEditingController();

    if (storeIndex.isNotEmpty && storeName.isNotEmpty) {
      storeNameController.text = storeName;
    }

    String statusCode = '404';

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Form(
            key: formSubmitAction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informe o Nome do Supermercado',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: storeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Supermercado',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Confirmar'),
                    onPressed: () async {
                      if (formSubmitAction.currentState!.validate()) {
                        try {
                          _putUserStoreCollection(
                            storeNameController.text,
                            userEmail,
                          );
                        } on PlatformException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Erro, Não Foi Possível Salvar o Supermercado!',
                              ),
                            ),
                          );
                          statusCode = '403';
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return [
      {'statusCode': statusCode}
    ];
  }
}
