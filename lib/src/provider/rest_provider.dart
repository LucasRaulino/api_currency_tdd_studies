import 'dart:convert';

import 'package:app/src/provider/response/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class RestProvider {
  static const String _accessKey = '52fdabccf5e752f431c60b5556a6f354';
  static const String _baseUrl = 'data.fixer.io';
  static const String _symbols = '/api/symbols';
  static const String _latest = '/api/latest';
  static const String endpoint3 = '';

  final http.Client _httpClient;

  RestProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Map<String, String>> symbols() async {
    final result = await _callGetApi(endpoint: _symbols, params: {
      'access_key': _accessKey,
    });

    return result.symbols;
  }

  Future<Tuple2<Map<String, num>, int>> latest() async {
    final result = await _callGetApi(endpoint: _latest, params: {
      'accessKey': _accessKey,
      'base': 'EUR',
    });
    return Tuple2(result.rates!, result.timestamp!);
  }

  Future<ApiResponse> _callGetApi({
    required String endpoint,
    Map<String, String>? params,
  }) async {
    final uri = Uri.http(_baseUrl, endpoint, params);

    final response = await _httpClient.get(uri);
    final result = ApiResponse.fromJson(json.decode(response.body));

    if (!result.success) {
      switch (result.error!.code) {
        case 101:
          throw InvalidApiKeyException();
        case 104:
          throw RequestReachedException();
        case 201:
          throw InvalidBaseCurrencyException();
        default:
          throw Exception();
      }
    }

    return result;
  }
}

class InvalidApiKeyException implements Exception {
  final String message =
      'No API key was specified or an invalid API Key was specified.';
}

class RequestReachedException implements Exception {
  final String message =
      'The maximum allowed API amount of monthly API requests has been reached.';
}

class InvalidBaseCurrencyException implements Exception {
  final String message = 'An invalid base currency has been entered.';
}
