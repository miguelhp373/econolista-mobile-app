// ignore_for_file: use_build_context_synchronously

import 'package:econolista_app/app/shared/scaffold_messanger_response_api/scaffold_messanger_response_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../modules/purchase_product_details/purchase_product_details.dart';
import '../api/fetch_api/fetch_api.dart';
import '../models/product_models.dart';

class BarcodeActions extends FetchAPI {
  //////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> scanBarcode(
    BuildContext context,
    String shoppingId,
  ) async {
    ///////////////////////////////////

    String barcodeScannerResponse;
    ProductModels productModels;
    String statusCode = '';

    try {
      //////////////////////////////////////////////////////////
      barcodeScannerResponse = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.BARCODE,
      );

      productModels = await fetchDataWithBarcode(barcodeScannerResponse);

      if (productModels.apiStatusCode == '200') {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseProductDetails(
              productModels: productModels,
              shoppingId: shoppingId,
            ),
          ),
        ).then(
          (value) => statusCode = productModels.apiStatusCode,
        );
      } else {
        ScaffoldMessangerResponseApi().showResponseAPIByStatusCode(
          context,
          int.parse(productModels.apiStatusCode),
        );
      }
    } on PlatformException {
      barcodeScannerResponse = 'Falha ao obter a versão da plataforma.';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro, Não Foi Possível Abrir o Leitor de Código de Barras!',
          ),
        ),
      );
      return [
        {'statusCode': 403} //forbiden
      ];
    }
    return [
      {'statusCode': int.parse(statusCode)}
    ];
  }

  Future<List<Map<String, dynamic>>> barcodeInsertModal(
      BuildContext context, String shoppingId) async {
    ////////////////////////////////////////////////////////////////////////
    final formSubmitAction = GlobalKey<FormState>();
    final TextEditingController barcodeController = TextEditingController();

    ProductModels productModels;
    String statusCode = '';
    ////////////////////////////////////////////////////////////////////
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
                  'Informe o Código de Barras',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'Código de Barras',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo Obrigatório!';
                    }

                    if (value.length < 8 || value.length > 14) {
                      return 'O Código de Barras informado não é válido!';
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
                          //////////////////////////////////////////////////////////

                          productModels = await fetchDataWithBarcode(
                              barcodeController.text);

                          if (productModels.apiStatusCode == '200') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PurchaseProductDetails(
                                  productModels: productModels,
                                  shoppingId: shoppingId,
                                ),
                              ),
                            ).then(
                              (value) =>
                                  statusCode = productModels.apiStatusCode,
                            );
                          } else {
                            ScaffoldMessangerResponseApi()
                                .showResponseAPIByStatusCode(
                              context,
                              int.parse(productModels.apiStatusCode),
                            );
                          }
                        } on PlatformException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Erro, Não Foi Possível Abrir o Leitor de Código de Barras!',
                              ),
                            ),
                          );
                          statusCode = '403';
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
    return [
      {'statusCode': int.parse(statusCode)}
    ];
  }
}
