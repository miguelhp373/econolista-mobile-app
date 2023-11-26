// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:econolista_app/app/shared/models/product_models.dart';

class FetchAPI {
  ///////////////////////////////////////////////////

  Future<ProductModels> fetchDataWithBarcode(String barcodeGTIN) async {
    /////////////////////////////////////////////////////////////////
    var url = Uri.https(
      const String.fromEnvironment('API_END_POINT'),
      '/gtins/$barcodeGTIN',
    );

    var headers = {
      'X-Cosmos-Token': const String.fromEnvironment('API_KEY_COSMOS_BLUESOFT')
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      return ProductModels.fromJson(jsonResponse);
    }
    return ProductModels(apiStatusCode: response.statusCode.toString());
  }
}
