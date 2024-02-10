import 'package:econolista_app/app/shared/api/fetch_api/fetch_api_versions/blue_cosmos_fetch_api.dart';
import 'package:econolista_app/app/shared/api/fetch_api/fetch_api_versions/mercado_livre_fetch_api.dart';
import 'dart:convert' as convert;

import 'package:econolista_app/app/shared/models/product_models.dart';
import 'package:http/http.dart';

class FetchAPI {
  ///////////////////////////////////////////////////

  Future<ProductModels> fetchDataWithBarcode(String barcodeGTIN) async {
    /////////////////////////////////////////////////////////////////

    var apiVersion = const String.fromEnvironment('API_VERSION');

    Response response = (apiVersion == 'V2'
        ? await BlueCosmosFetchAPI().fetchDataWithBarcode(barcodeGTIN)
        : await MercadoLivreFetchAPI().fetchDataWithBarcode(barcodeGTIN));

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      //print(jsonResponse);

      return ProductModels.fromJson(jsonResponse);
    }
    return ProductModels(apiStatusCode: response.statusCode.toString());
  }
}
