// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/modules/purchase_product_details/purchase_product_details.dart';

import '../../../shared/models/product_models.dart';
import '../../../shared/widgets/popup_button_dropdown/popup_button_dropdown.dart';
import '../../../shared/database/shopping_list_collection/shopping_list_collection.dart';
import '../../../shared/widgets/scaffold_message_alert/scaffold_message_alert.dart';

class PurchaseProductsListview extends StatefulWidget {
  const PurchaseProductsListview({super.key, required this.shoppingId});

  final String shoppingId;

  @override
  State<PurchaseProductsListview> createState() =>
      _PurchaseProductsListviewState();
}

class _PurchaseProductsListviewState extends State<PurchaseProductsListview> {
  late StreamController<Map<String, dynamic>> _productListController;

  @override
  void initState() {
    super.initState();
    _productListController = StreamController<Map<String, dynamic>>();
    getProductsList();
  }

  @override
  void dispose() {
    _productListController.close();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////////
  void getProductsList() async {
    DocumentSnapshot documentSnapshot = await ShoppingListCollection()
        .fetchProductList(widget.shoppingId)
        .get();

    Map<String, dynamic>? productListData =
        documentSnapshot.data() as Map<String, dynamic>?;

    if (productListData != null) {
      dynamic productList = productListData['ProductsList'];

      if (productList is Map<String, dynamic>) {
        _processAndAddToStream(productList);
      }
    }
  }

  void _processAndAddToStream(Map<String, dynamic> productList) {
    Map<String, dynamic> convertedProductList = {};

    productList.forEach((key, value) {
      convertedProductList[key.toString()] = value;
    });

    _productListController.add(convertedProductList);
  }

  /////////////////////////////////////////////////////////////////////
  showDetailsProductFromCart(ProductModels productModelsInstance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseProductDetails(
          productModels: productModelsInstance,
          shoppingId: widget.shoppingId,
        ),
      ),
    );
  }

  deleteProductFromCart(String shoppingId, String productIndex) async {
    final deletingAction = await ShoppingListCollection()
        .deleteProductFromList(shoppingId, productIndex);

    ScaffoldMessengeAlert()
        .showMessageOnDisplayBottom(context, deletingAction[0]['message']);
  }

  /////////////////////////////////////////////////////////////////////

  Widget _buildProductTile(Map<String, dynamic> product, String productIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                25,
              ),
              child: product['productPhotoUrl'] != null &&
                      product['productPhotoUrl'] != ''
                  ? Image.network(
                      product['productPhotoUrl'],
                      width: 50,
                      height: 50,
                    )
                  : const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.question_mark),
                    ),
            ),
          ],
        ),
        tileColor: const Color(0xFFced7db),
        title: Text(
          product['productName'],
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        subtitle: Text(
          'R\$ ${product['productPrice'].toStringAsFixed(2)}',
        ),
        trailing: PopupButtonDropdown(
          editingSelectedRegister: () {
            Future.microtask(() {
              showDetailsProductFromCart(
                ProductModels(
                  productId: productIndex,
                  productName: product['productName'] ?? '',
                  productDescription: product['productDescription'] ?? '',
                  productPhotoUrl: product['productPhotoUrl'] ?? '',
                  productBarcode: product['productBarcode'] ?? '',
                  productPrice: (product['productPrice'] ?? 0).toDouble(),
                  productQuantity: product['productQuantity'] ?? 0,
                ),
              );
            });
          },
          deletingSelectedRegister: () {
            Future.microtask(() {
              deleteProductFromCart(widget.shoppingId, productIndex);
            });
          },
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseProductDetails(
              productModels: ProductModels(
                productId: productIndex,
                productName: product['productName'] ?? '',
                productDescription: product['productDescription'] ?? '',
                productPhotoUrl: product['productPhotoUrl'] ?? '',
                productBarcode: product['productBarcode'] ?? '',
                productPrice: (product['productPrice'] ?? 0).toDouble(),
                productQuantity: product['productQuantity'] ?? 0,
              ),
              shoppingId: widget.shoppingId,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
        child: SingleChildScrollView(
          child: StreamBuilder<Map<String, dynamic>>(
            stream: _productListController.stream,
            builder:
                (context, AsyncSnapshot<Map<String, dynamic>> streamSnapshot) {
              if (streamSnapshot.hasData) {
                Map<String, dynamic> productList = streamSnapshot.data!;
                if (productList.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> product =
                          productList[index.toString()];
                      return _buildProductTile(product, index.toString());
                    },
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 150,
                            width: 150,
                            child: Image(
                              image: AssetImage(
                                  'assets/lottiefiles/animation_no_data.gif'),
                            ),
                          ),
                          Text(
                            'Não Há Dados Para Demonstrar',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(
                      image: AssetImage(
                        'assets/lottiefiles/animation_loading_chicken.gif',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
