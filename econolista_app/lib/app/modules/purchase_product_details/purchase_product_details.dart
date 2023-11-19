// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:econolista_app/app/shared/models/product_models.dart';
import 'package:flutter/material.dart';

import '../../shared/database/shopping_list_collection/shopping_list_collection.dart';
import '../../shared/widgets/scaffold_message_alert/scaffold_message_alert.dart';

class PurchaseProductDetails extends StatefulWidget {
  const PurchaseProductDetails(
      {super.key, required this.productModels, required this.shoppingId});
  final ProductModels productModels;
  final String shoppingId;

  @override
  State<PurchaseProductDetails> createState() => _PurchaseProductDetailsState();
}

class _PurchaseProductDetailsState extends State<PurchaseProductDetails> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _productQuantityController;
  late TextEditingController _productPriceController;

  @override
  void initState() {
    super.initState();

    _productQuantityController = TextEditingController(
        text: widget.productModels.productQuantity.toString());
    _productPriceController = TextEditingController(
        text: widget.productModels.productPrice.toString());
  }

  void _submitForm(BuildContext context, ProductModels productModels) async {
    if (_formKey.currentState!.validate()) {
      final submitJsonResult = await ShoppingListCollection()
          .formSubmitProductsList(productModels, widget.shoppingId);

      if (submitJsonResult[0]['status'] == true) {
        ScaffoldMessengeAlert().showMessageOnDisplayBottom(
            context, submitJsonResult[0]['message']);

        Navigator.pop(context);
      } else {
        ScaffoldMessengeAlert().showMessageOnDisplayBottom(
            context, submitJsonResult[0]['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  //color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: widget.productModels.productPhotoUrl != ''
                      ? Image.network(
                          widget.productModels.productPhotoUrl,
                        )
                      : const SizedBox(
                          child: Center(
                            child: Text(
                              'Erro Ao Carregar a Imagem!',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 25),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Text(
                      widget.productModels.productName,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: Text(
                      widget.productModels.productDescription,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5),
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Quantidade',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _productQuantityController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Insira a quantidade de produtos',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    //initialValue: _descriptionTextInput,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A Quantidade deve ser preenchida!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5),
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Preço',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _productPriceController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Insira o Preço do Produto',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    //initialValue: _descriptionTextInput,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O Preço deve ser preenchido!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.productModels.productId != ''
                                ? Icon(Icons.save)
                                : Icon(Icons.shopping_cart),
                            SizedBox(width: 5),
                            widget.productModels.productId != ''
                                ? Text('Salvar Alterações')
                                : Text('Adicionar Ao Carrinho')
                          ],
                        ),
                        onPressed: () => _submitForm(
                          context,
                          ProductModels(
                            productId: widget.productModels.productId,
                            productBarcode: widget.productModels.productBarcode,
                            productDescription:
                                widget.productModels.productDescription,
                            productName: widget.productModels.productName,
                            productPhotoUrl:
                                widget.productModels.productPhotoUrl,
                            productPrice:
                                double.parse(_productPriceController.text),
                            productQuantity:
                                int.parse(_productQuantityController.text),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
