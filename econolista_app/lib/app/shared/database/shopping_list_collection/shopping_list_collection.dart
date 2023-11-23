import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/shared/models/product_models.dart';
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

  Future<String> calculateShoppingListTotal(String shoppingId) async {
    double totalShoppingPriceValue = 0.0;

    DocumentSnapshot documentSnapshot =
        await ShoppingListCollection().fetchProductList(shoppingId).get();

    Map<String, dynamic>? productListData =
        documentSnapshot.data() as Map<String, dynamic>?;

    if (productListData != null) {
      dynamic productList = productListData['ProductsList'];

      Map<String, dynamic> jsonDecodeProductsList = {};

      if (productList is Map<String, dynamic>) {
        productList.forEach((key, product) {
          if (product != null && product is Map<String, dynamic>) {
            jsonDecodeProductsList[key] = product;
          }
        });
      }

      jsonDecodeProductsList.forEach((chave, produto) {
        if (produto.containsKey('productPrice')) {
          dynamic productPrice = produto['productPrice'];

          if (productPrice is String) {
            double precoDoProduto = double.parse(productPrice);
            totalShoppingPriceValue += precoDoProduto;
          } else if (productPrice is double || productPrice is int) {
            double precoDoProduto = double.parse(productPrice.toString());
            totalShoppingPriceValue += precoDoProduto;
          }
        }
      });
    }

    return totalShoppingPriceValue.toStringAsFixed(2);
  }

  Future<List<Map<String, dynamic>>> formSubmitProductsList(
      ProductModels productModels, String shoppingId) async {
    try {
      await _updateProductInList(
          productModels, shoppingId, productModels.productId);
      return [
        {'status': true, 'message': 'Produto Alterado Com Sucesso'}
      ];
    } catch (e) {
      return [
        {
          'status': false,
          'message': 'Erro ao Tentar Executar Uma Operação, Tente Novamente!'
        }
      ];
    }
  }

  Future<void> _updateProductInList(
    ProductModels updatedProduct,
    String shoppingId,
    String productIndex,
  ) async {
    // Obter a referência do documento
    DocumentReference documentReference =
        ShoppingListCollection().fetchProductList(shoppingId);

    // Obter os dados atuais do documento
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? productListData =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (productListData != null) {
        // Obter a lista de produtos
        Map<String, dynamic> productList =
            Map<String, dynamic>.from(productListData['ProductsList'] ?? {});

        // Verificar se o índice é válido
        int? parsedIndex = int.tryParse(productIndex);

        if (parsedIndex != null && parsedIndex >= 0) {
          // Atualizar o produto no índice especificado
          productList[productIndex] = {
            ...updatedProduct.toMap(),
            'id': productIndex,
          };
        } else {
          // Adicionar um novo produto com um ID baseado no índice
          int newIndex = productList.length;
          productList[newIndex.toString()] = {
            ...updatedProduct.toMap(),
            'id': newIndex.toString(),
          };
        }

        // Atualizar os dados no Firestore
        await documentReference.update({'ProductsList': productList});
      }
    }
  }

  Future<List<Map<String, dynamic>>> deleteProductFromList(
    String shoppingId,
    String productIndex,
  ) async {
    try {
      // Obter a referência do documento
      DocumentReference documentReference =
          ShoppingListCollection().fetchProductList(shoppingId);

      // Obter os dados atuais do documento
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? productListData =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (productListData != null) {
          // Obter a lista de produtos
          Map<String, dynamic> productList =
              Map<String, dynamic>.from(productListData['ProductsList'] ?? {});

          // Verificar se o índice é válido
          int? parsedIndex = int.tryParse(productIndex);

          if (parsedIndex != null && parsedIndex >= 0) {
            // Remover o produto no índice especificado
            productList.remove(productIndex);

            // Reorganizar os índices
            productList = reorganizeProductListIndexes(productList);

            // Atualizar os dados no Firestore
            await documentReference.update({'ProductsList': productList});
          }
        }
      }
      return [
        {
          'status': true,
          'message': 'Produto Excluído Com Sucesso',
        }
      ];
    } catch (e) {
      return [
        {
          'status': false,
          'message': 'Erro Ao Tentar Excluir o Produto, Tente Novamente!',
        }
      ];
    }
  }

  Map<String, dynamic> reorganizeProductListIndexes(
      Map<String, dynamic> productList) {
    // Converter chaves para inteiros e ordenar
    List<int> indexes = productList.keys.map((key) => int.parse(key)).toList();
    indexes.sort();

    // Criar um novo mapa com índices reorganizados
    Map<String, dynamic> newProductList = {};
    for (int i = 0; i < indexes.length; i++) {
      String oldKey = indexes[i].toString();
      newProductList[i.toString()] = productList[oldKey];
    }

    return newProductList;
  }

/////////////////////////////////////////////////////////////////////
}
