import 'package:app/src/model/currency.dart';
import 'package:app/src/provider/db_provider.dart';
import 'package:app/src/provider/rest_provider.dart';
import 'package:app/src/repository/currency_repository.dart';

class CurrencyRepository extends CurrencyRepositoryBase {
  final RestProvider _provider;
  final DbProvider _dbProvider;

  CurrencyRepository(this._provider, this._dbProvider);

  @override
  Stream<List<Currency>> getCurrencies() async* {
    yield await _dbProvider.getCurrencies();

    final result = await _provider.latest();
    final currency = result.item1;
    final timestamp = result.item2;
    final symbols = await _provider.symbols();

    final currenciesList = currency.entries.map((e) {
      final name = symbols[e.key]!;
      return Currency(e.key, name, e.value, timestamp);
    }).toList();

    await Future.forEach<Currency>(
        currenciesList, (e) async => await _dbProvider.insert(e));

    yield await _dbProvider.getCurrencies();
  }
}
