// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, await_only_futures, unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../shared/models/product_models.dart';
import '../../shared/widgets/custom_bool_alert_dialog/custom_bool_alert_dialog.dart';
import '../../shared/widgets/popup_button_dropdown/popup_button_dropdown.dart';
import '../../shared/database/shopping_list_collection/shopping_list_collection.dart';
import '../..//shared/api/fetch_api_bluesoft_cosmos/fetch_api_bluesoft_cosmos.dart';

import '../purchase_product_details/purchase_product_details.dart';

class PurchaseProductsList extends StatefulWidget {
  const PurchaseProductsList({super.key, required this.shoppingId});

  final shoppingId;

  @override
  State<PurchaseProductsList> createState() => _PurchaseProductsListState();
}

class _PurchaseProductsListState extends State<PurchaseProductsList> {
  ///////////////////////////////////////////////////
  late StreamController<Map<String, dynamic>> _productListController;

  String _scanBarcode = 'Desconhecido';
  String isTotalShoppingList = '0,00';
  int isTotalItens = 0;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

      ProductModels productModelsInstance = await FetchApiBluesoftCosmos()
          .fetchDataWithBarcode(context, barcodeScanRes);

      if (productModelsInstance.apiStatusCode == '200') {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseProductDetails(
              productModels: productModelsInstance,
              shoppingId: widget.shoppingId,
            ),
          ),
        ).then((value) {
          getProductsList();
        });
      }
    } on PlatformException {
      barcodeScanRes = 'Falha ao obter a versão da plataforma.';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro, Não Foi Possível Abrir o Leitor de Código de Barras!',
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() => _scanBarcode = barcodeScanRes);
  }

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

  void getTotalShoppingPriceValue(BuildContext context) async {
    try {
      String shoppingTotalPriceResult = await ShoppingListCollection()
          .calculateShoppingListTotal(widget.shoppingId);
      setState(() => isTotalShoppingList = shoppingTotalPriceResult);
    } catch (e) {
      //print(e);
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Erro Ao Atualizar Valor Total da Compra!',
            ),
          ),
        );
      } catch (e) {
        //
      }
    }
  }

  void getTotalItensList(int listProductsLength) {
    setState(() => isTotalItens = listProductsLength);
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          deletingAction[0]['message'],
        ),
      ),
    );
    Navigator.of(context).pop();
    getProductsList();
  }

  finishedShopping(BuildContext contextScreen) {
    CustomBoolAlertDialog()
        .showBooleanAlertDialog(
      context,
      'Encerrar Lista de Compras',
      'Deseja Encerrar o Carrinho de Compras Atual?',
    )
        .then(
      (confirmed) async {
        if (confirmed!) {
          await ShoppingListCollection()
              .updateStatusShoppingList(widget.shoppingId, 'Encerrada');
          Navigator.pop(context);
        }
      },
    );
  }

  /////////////////////////////////////////////////////////////////////

  Future<void> _refreshData(BuildContext context) async {
    getProductsList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Lista Atualizada Com Sucesso!',
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _productListController = StreamController<Map<String, dynamic>>();
    getProductsList();
  }

  @override
  Widget build(BuildContext context) {
    getTotalShoppingPriceValue(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho de Compras'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () => _refreshData(context),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SingleChildScrollView(
                    child: StreamBuilder<Map<String, dynamic>>(
                      stream: _productListController.stream,
                      builder: (
                        context,
                        AsyncSnapshot<Map<String, dynamic>> streamSnapshot,
                      ) {
                        if (streamSnapshot.hasData) {
                          Map<String, dynamic> productList =
                              streamSnapshot.data!;
                          if (productList.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: productList.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> product =
                                    productList[index.toString()];

                                Future.microtask(() =>
                                    getTotalItensList(productList.length));

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: product['productPhotoUrl'] !=
                                                      null &&
                                                  product['productPhotoUrl'] !=
                                                      ''
                                              ? Image.network(
                                                  product['productPhotoUrl'],
                                                  width: 50,
                                                  height: 50,
                                                )
                                              : const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      Icon(Icons.question_mark),
                                                ),
                                        ),
                                      ],
                                    ),
                                    tileColor: const Color(0xFFced7db),
                                    title: Text(
                                      product['productName'],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'R\$ ${product['productPrice'].toStringAsFixed(2)} | Quantidade x${product['productQuantity']}',
                                    ),
                                    trailing: PopupButtonDropdown(
                                      editingSelectedRegister: () {
                                        Future.microtask(() {
                                          showDetailsProductFromCart(
                                            ProductModels(
                                              productId: index.toString(),
                                              productName:
                                                  product['productName'] ?? '',
                                              productDescription: product[
                                                      'productDescription'] ??
                                                  '',
                                              productPhotoUrl:
                                                  product['productPhotoUrl'] ??
                                                      '',
                                              productBarcode:
                                                  product['productBarcode'] ??
                                                      '',
                                              productPrice:
                                                  (product['productPrice'] ?? 0)
                                                      .toDouble(),
                                              productQuantity:
                                                  product['productQuantity'] ??
                                                      0,
                                            ),
                                          );
                                        });
                                      },
                                      deletingSelectedRegister: () {
                                        Future.microtask(() {
                                          deleteProductFromCart(
                                              widget.shoppingId,
                                              index.toString());
                                        });
                                      },
                                    ),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PurchaseProductDetails(
                                            productModels: ProductModels(
                                              productId: index.toString(),
                                              productName:
                                                  product['productName'] ?? '',
                                              productDescription: product[
                                                      'productDescription'] ??
                                                  '',
                                              productPhotoUrl:
                                                  product['productPhotoUrl'] ??
                                                      '',
                                              productBarcode:
                                                  product['productBarcode'] ??
                                                      '',
                                              productPrice:
                                                  (product['productPrice'] ?? 0)
                                                      .toDouble(),
                                              productQuantity:
                                                  product['productQuantity'] ??
                                                      0,
                                            ),
                                            shoppingId: widget.shoppingId,
                                          ),
                                        ),
                                      ).then((value) => getProductsList());
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
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
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
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
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 150,
                                width: 150,
                                child: Image(
                                  image: AssetImage(
                                    'assets/lottiefiles/animation_loading_chicken.gif',
                                  ),
                                ),
                              ),
                              Text('Carregando Dados . . . ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                    fontSize: 17,
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(CupertinoIcons.barcode),
        onPressed: () => scanBarcodeNormal(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: R\$ ${isTotalShoppingList.replaceAll('.', ',')}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Total Itens: $isTotalItens',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
