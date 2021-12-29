import 'dart:io';

import 'package:app/src/provider/rest_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('Latest api will return correctly', () async {
    final provider = _getProvider(latestJson);
    final result = await provider.latest();
    final currency = result.item1;
    final timestamp = result.item2;

    expect(currency.length, 2);
  });
}

const String latestJson = 'test/provider_test/latest.json';
const String symbolsJson = 'test/provider_test/symbols.json';
const String accessKeyInvalidJson =
    'test/provider_test/access_key_invalid.json';

RestProvider _getProvider(String filePath) =>
    RestProvider(httpClient: _getMockProvider(filePath));

MockClient _getMockProvider(String filePath) => MockClient((_) async =>
    Response(await File(filePath).readAsString(), 200, headers: headers));

final headers = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
};
