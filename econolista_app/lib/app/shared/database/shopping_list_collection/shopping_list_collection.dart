import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/shared/models/purchased_models.dart';
import 'package:flutter/material.dart';

class ShoppingListCollection {
  /////////////////////////////////////////////////////////////////////

  CollectionReference storeCollectionReferenceList =
      FirebaseFirestore.instance.collection('user_collection');

  CollectionReference shoppingListCollectionReferenceList =
      FirebaseFirestore.instance.collection('shopping_list_collection');

  /////////////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>> getStoreListForDropdownList(
    String userId,
  ) async {
    //////////////////////////////////////////////////////////
    Map<String, dynamic> result = {'storeNames': <String>[]};

    QuerySnapshot queryStoreCollectionList = await storeCollectionReferenceList
        .where('UserId', isEqualTo: userId)
        .get();

    if (queryStoreCollectionList.docs.isNotEmpty) {
      var data =
          queryStoreCollectionList.docs[0].data() as Map<String, dynamic>;

      if (data.containsKey('StoreCollection') &&
          data['StoreCollection'] is Map) {
        Map<String, dynamic> storeMap = data['StoreCollection'];

        result['storeNames'] = storeMap.values
            .map<String>((store) => store['StoreName'] as String)
            .toList();
      }
    }

    result['storeNames'].insert(0, 'Selecione o Supermercado');

    return result;
  }

  Future<List<DropdownMenuItem<String>>> fetchDropdownItems(
    Map<String, dynamic> shoppingList,
  ) async {
    List<DropdownMenuItem<String>> dropdownItems = shoppingList.entries
        .map(
          (entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value.toString()),
          ),
        )
        .toList();

    return dropdownItems;
  }

  Future<List<Map<String, dynamic>>> formSubmitShoppingList(
      PurchasedModels purchasedModels) async {
    try {
      if (!purchasedModels.purchasedId.isNotEmpty) {
        await shoppingListCollectionReferenceList.add({
          "UserId": purchasedModels.userId,
          "Description": purchasedModels.description,
          "DateTimeCreated": purchasedModels.dateTimeCreated,
          "MarketName": purchasedModels.marketName,
          "ScheduledPurchase": purchasedModels.futurePuchased,
          "Status": purchasedModels.status,
          "ProductsList": {},
        });
        return [
          {'status': true, 'message': 'Lista de Compras Criada Com Sucesso!'}
        ];
      } else {
        await shoppingListCollectionReferenceList
            .doc(purchasedModels.purchasedId)
            .update(
          {
            "Description": purchasedModels.description,
            "DateTimeCreated": purchasedModels.dateTimeCreated,
            "MarketName": purchasedModels.marketName,
            "ScheduledPurchase": purchasedModels.futurePuchased,
            //"Status": purchasedModels.status,
            "ProductsList": {},
          },
        );
        return [
          {'status': true, 'message': 'Lista de Compras Alterada Com Sucesso!'}
        ];
      }
    } catch (e) {
      //print('Exception Error: ${e}');
      return [
        {
          'status': false,
          'message': 'Erro ao Tentar Executar Uma Operação, Tente Novamente!'
        }
      ];
    }
  }

  Query<Object?> fetchShoppingList(String userId) {
    final Query getAllShoppingsListFromCollection =
        shoppingListCollectionReferenceList
            .where(
              'Status',
              isEqualTo: 'Aberta',
            )
            .where('UserId', isEqualTo: userId);

    return getAllShoppingsListFromCollection;
  }

  Query<Object?> fetchProductsList(String userId, String shoppingId) {
    final DocumentReference shoppingDocumentRef =
        shoppingListCollectionReferenceList.doc(shoppingId);

    final CollectionReference itemsCollectionRef =
        shoppingDocumentRef.collection('shopping_list_collection');

    return itemsCollectionRef;
  }

  DocumentReference<Object?> fetchProductList(String shoppingId) {
    final DocumentReference shoppingDocumentRef =
        shoppingListCollectionReferenceList.doc(shoppingId);

    return shoppingDocumentRef;
  }

/////////////////////////////////////////////////////////////////////
}
