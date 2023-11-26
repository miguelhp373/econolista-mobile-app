import 'package:flutter/material.dart';

class ScaffoldMessangerResponseApi {
  void showResponseAPIByStatusCode(BuildContext context, int statusCode) {
    String responseMessage;

    switch (statusCode) {
      case 403:
        responseMessage =
            'Erro 403: Requisição Negada, Tente Novamente Mais Tarde!';
        break;

      case 404:
        responseMessage = 'Produto Não Encontrado!';
        break;

      case 408:
        responseMessage =
            'Erro 408: Tempo esgotado para a requisição, Tente Novamente!';
        break;

      case 429:
        responseMessage =
            'Limite Diário de Produtos Escaneados, Tente Novamente Amanhã!';
        break;

      case 500:
        responseMessage =
            'Erro 500: Erro de servidor, Tente Novamente Mais Tarde!';
        break;
      default:
        responseMessage = 'Erro Interno! Tente Novamente Mais Tarde.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(responseMessage),
      ),
    );
  }
}
