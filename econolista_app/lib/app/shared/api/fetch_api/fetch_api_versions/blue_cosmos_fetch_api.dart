// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class BlueCosmosFetchAPI {
  ///////////////////////////////////////////////////

  Future<Response> fetchDataWithBarcode(String barcodeGTIN) async {
    /////////////////////////////////////////////////////////////////
    var url = Uri.https(
      const String.fromEnvironment('API_END_POINT_V1'),
      '/gtins/$barcodeGTIN',
    );

    var headers = {
      'X-Cosmos-Token': const String.fromEnvironment('API_KEY_V1')
    };

    var response = await http.get(url, headers: headers);

    return response;
  }
}
