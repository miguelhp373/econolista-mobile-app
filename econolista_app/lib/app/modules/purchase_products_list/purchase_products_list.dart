// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../modules/purchase_products_list/components/purchase_products_listview.dart';
import '../../shared/models/product_models.dart';
import '../../shared/widgets/scaffold_message_alert/scaffold_message_alert.dart';
import '../../shared/widgets/top_title_page/top_title_page.dart';
import '../../shared/database/shopping_list_collection/shopping_list_collection.dart';
import '../purchase_product_details/purchase_product_details.dart';

class PurchaseProductsList extends StatefulWidget {
  const PurchaseProductsList({super.key, required this.shoppingId});

  final shoppingId;

  @override
  State<PurchaseProductsList> createState() => _PurchaseProductsListState();
}

class _PurchaseProductsListState extends State<PurchaseProductsList> {
  ///////////////////////////////////////////////////
  String isTotalShoppingList = '0.00';

  void getTotalShoppingPriceValue(BuildContext context) async {
    try {
      String shoppingTotalPriceResult = await ShoppingListCollection()
          .calculateShoppingListTotal(widget.shoppingId);
      setState(() => isTotalShoppingList = shoppingTotalPriceResult);
    } catch (e) {
      //print(e);
      ScaffoldMessengeAlert().showMessageOnDisplayBottom(
          context, 'Erro Ao Atualizar Valor Total da Compra!');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getTotalShoppingPriceValue(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const TopTitlePage(
              titleIcon: Icons.shopping_cart,
              titleText: 'Carrinho de Compras',
            ),
            PurchaseProductsListview(shoppingId: widget.shoppingId),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(CupertinoIcons.barcode),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseProductDetails(
              productModels: ProductModels(
                productId: '',
                productName: '',
                productDescription: '',
                productPhotoUrl: '',
                productBarcode: '',
                productPrice: 0,
                productQuantity: 0,
              ),
              shoppingId: widget.shoppingId,
            ),
          ),
        ),
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
          ],
        ),
      ),
    );
  }
}
