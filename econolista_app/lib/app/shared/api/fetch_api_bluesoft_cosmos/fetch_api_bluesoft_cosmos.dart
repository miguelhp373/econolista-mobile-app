// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert' as convert;
import 'package:econolista_app/app/shared/models/product_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchApiBluesoftCosmos {
  Future<ProductModels> fetchDataWithBarcode(
      BuildContext context, String gtinBarcode) async {
    var url = Uri.https(
        const String.fromEnvironment('API_END_POINT'), '/gtins/$gtinBarcode');

    var headers = {
      'X-Cosmos-Token': const String.fromEnvironment('API_KEY_COSMOS_BLUESOFT')
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      return ProductModels.fromJson(jsonResponse);
    } else {
      String resultErrorMessageByStatusCode = '';

      switch (response.statusCode) {
        case 403:
          resultErrorMessageByStatusCode =
              'Erro 403: Requisição Negada, Tente Novamente Mais Tarde!';
          break;

        case 404:
          resultErrorMessageByStatusCode = 'Produto Não Encontrado!';
          break;

        case 408:
          resultErrorMessageByStatusCode =
              'Erro 408: Tempo esgotado para a requisição, Tente Novamente!';
          break;

        case 429:
          resultErrorMessageByStatusCode =
              'Limite Diário de Produtos Escaneados, Tente Novamente Amanhã!';
          break;

        case 500:
          resultErrorMessageByStatusCode =
              'Erro 500: Erro de servidor, Tente Novamente Mais Tarde!';
          break;
        default:
          'Erro Interno! Tente Novamente Mais Tarde.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultErrorMessageByStatusCode),
        ),
      );
      return ProductModels(apiStatusCode: response.statusCode.toString());
    }
  }
}
