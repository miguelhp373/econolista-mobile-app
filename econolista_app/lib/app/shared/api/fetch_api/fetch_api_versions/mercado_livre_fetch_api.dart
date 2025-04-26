// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class MercadoLivreFetchAPI {
  ///////////////////////////////////////////////////
  //https://api.mercadolibre.com/products/search?status=active&site_id=MLB&product_identifier=4005900707536&category_id=MLB263832
  Future<Response> fetchDataWithBarcode(String barcodeGTIN) async {
    var url = Uri.https(
      const String.fromEnvironment('API_END_POINT_V2'),
      '/products/search',
      {
        'status': 'active',
        'site_id': 'MLB',
        'product_identifier': barcodeGTIN,
        'category_id': 'MLB263832', //supermarket products
      },
    );

    var headers = {'Authorization': const String.fromEnvironment('API_KEY_V2')};

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      var results = jsonResponse['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        var firstResult = results.first;
        var productName = firstResult['name'];
        var productNameDecoded = utf8.decode(productName.runes.toList());
        var productPhotoUrl = firstResult['pictures'][0]['url'];
        productPhotoUrl = productPhotoUrl.replaceFirst('http://', 'https://');
        var productBarcode = jsonResponse['product_identifier'];

        // Cria um novo mapa com os dados relevantes
        var responseData = {
          'description': productNameDecoded,
          'gtin': productBarcode,
          'thumbnail': productPhotoUrl,
          // Adicione outros campos relevantes conforme necessário
        };

        // Converte o mapa para uma string JSON
        var responseBody = json.encode(responseData);

        // Cria um novo objeto Response com o corpo JSON
        var newResponse = Response(responseBody, response.statusCode);

        return newResponse;
      }
    }

    return response; // Retorna a resposta original se não houver resultados ou se houver erro
  }
}
