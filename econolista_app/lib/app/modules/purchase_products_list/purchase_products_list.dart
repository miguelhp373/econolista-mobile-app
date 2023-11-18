import 'package:econolista_app/app/modules/purchase_products_list/components/purchase_products_listview.dart';
import 'package:econolista_app/app/shared/widgets/top_title_page/top_title_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PurchaseProductsList extends StatefulWidget {
  const PurchaseProductsList({super.key});

  @override
  State<PurchaseProductsList> createState() => _PurchaseProductsListState();
}

class _PurchaseProductsListState extends State<PurchaseProductsList> {
  // Função fictícia para calcular o total da compra
  double calculateTotal() {
    // Implemente a lógica real para calcular o total da compra aqui
    return 150.00;
  }

  @override
  Widget build(BuildContext context) {
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
        child: const Column(
          children: [
            TopTitlePage(
              titleIcon: Icons.shopping_cart,
              titleText: 'Carrinho de Compras',
            ),
            PurchaseProductsListview(shoppingId: '8lAkRuf4daNgOWNsuV51'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(CupertinoIcons.barcode),
        onPressed: () => {},
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: R\$ ${calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            // Adicione mais elementos aqui, se necessário
          ],
        ),
      ),
    );
  }
}
